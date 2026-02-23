import json
import numpy as np
import pandas as pd

from sklearn.compose import ColumnTransformer
from sklearn.impute import SimpleImputer
from sklearn.linear_model import RidgeCV
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import KFold, cross_val_predict

FEATURES = [
    "mmlu_pro", "gpqa", "tau2", "terminalbench_hard",
    "intelligence_index", "coding_index", "hle", "livecodebench",
    # Optional if you have it broadly:
    # "bfcl_v3",
]

TARGET = "ifbench"

def _to_dataframe(obj):
    # Supports: [{"model": "...", ...}, ...] or {"modelname": {...}, ...}
    if isinstance(obj, list):
        return pd.DataFrame(obj)
    if isinstance(obj, dict):
        rows = []
        for k, v in obj.items():
            row = dict(v) if isinstance(v, dict) else {"value": v}
            row.setdefault("model", k)
            rows.append(row)
        return pd.DataFrame(rows)
    raise ValueError("Unsupported JSON shape")

def _scale01_to_100(s: pd.Series) -> pd.Series:
    s = pd.to_numeric(s, errors="coerce")
    # Heuristic: treat <= 1.5 as [0,1] scale (allows a bit of noise)
    if np.nanmax(s.values) <= 1.5:
        return s * 100.0
    return s

def train_ifbench_proxy(df: pd.DataFrame, features=FEATURES, target=TARGET):
    df = df.copy()

    # Normalize target and features to 0–100 when possible
    df[target] = _scale01_to_100(df[target])
    for f in features:
        if f in df.columns:
            df[f] = _scale01_to_100(df[f])

    train = df[df[target].notna()].copy()
    missing_feats = [f for f in features if f not in train.columns]
    if missing_feats:
        print("Warning: missing feature columns in training data:", missing_feats)

    feats = [f for f in features if f in train.columns]
    X = train[feats]
    y = train[target].astype(float)

    # Impute + missing-indicator + standardize + ridge
    pre = ColumnTransformer(
        transformers=[
            ("num", Pipeline(steps=[
                ("imputer", SimpleImputer(strategy="median", add_indicator=True)),
                ("scaler", StandardScaler()),
            ]), feats)
        ],
        remainder="drop"
    )

    model = RidgeCV(alphas=np.logspace(-3, 3, 31))
    pipe = Pipeline([("pre", pre), ("model", model)])

    # Cross-validated sanity check
    cv = KFold(n_splits=min(5, len(train)), shuffle=True, random_state=0)
    preds = cross_val_predict(pipe, X, y, cv=cv)
    mae = float(np.nanmean(np.abs(preds - y)))
    rmse = float(np.sqrt(np.nanmean((preds - y) ** 2)))
    print(f"CV MAE: {mae:.2f} | CV RMSE: {rmse:.2f} | n={len(train)}")

    pipe.fit(X, y)
    return pipe, feats

def bootstrap_predict(pipe, feats, df_train, row_dict, B=200, seed=0):
    rng = np.random.default_rng(seed)
    train = df_train[df_train[TARGET].notna()].copy()
    X_all = train[feats]
    y_all = train[TARGET].astype(float).values

    x_row = pd.DataFrame([{f: row_dict.get(f, np.nan) for f in feats}])
    point = float(pipe.predict(x_row)[0])

    boots = []
    idx = np.arange(len(train))
    for _ in range(B):
        samp = rng.choice(idx, size=len(idx), replace=True)
        # refit a lightweight ridge each time
        # (reusing the same pipeline class/alphas for stability)
        boot_pipe = pipe.__class__(pipe.steps)
        boot_pipe.fit(X_all.iloc[samp], y_all[samp])
        boots.append(float(boot_pipe.predict(x_row)[0]))

    lo, hi = np.quantile(boots, [0.1, 0.9])
    return point, (float(lo), float(hi))

if __name__ == "__main__":
    path = "skills/update-agent-models/model_benchmarks.json"
    with open(path, "r") as f:
        raw = json.load(f)

    df = _to_dataframe(raw)

    # Train two proxies if you can label instruct/base; else train one.
    pipe, feats = train_ifbench_proxy(df)

    # Example: plug in Trinity Mini tuned (fill what you have; leave others absent)
    trinity_tuned = {
        "gpqa": 58.55,      # or 0.5855 if that’s how it’s stored; script normalizes
        "bfcl_v3": 59.67,   # only used if you add it to FEATURES
        # You can add: mmlu_pro, tau2, terminalbench_hard, etc. if you have them
    }

    point = float(pipe.predict(pd.DataFrame([{f: trinity_tuned.get(f, np.nan) for f in feats}]))[0])
    print(f"Trinity tuned ifbench_hat: {point:.2f}")

    # Optional uncertainty band (requires df to include TARGET + feats)
    point, (lo, hi) = bootstrap_predict(pipe, feats, df, trinity_tuned)
    print(f"Trinity tuned ifbench_hat (80% boot interval): {point:.2f} [{lo:.2f}, {hi:.2f}]")
