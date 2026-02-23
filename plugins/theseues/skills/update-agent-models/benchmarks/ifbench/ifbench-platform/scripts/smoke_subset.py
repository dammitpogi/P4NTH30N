#!/usr/bin/env python3
import json
import os
import subprocess
import time
from pathlib import Path


def load_env(path: Path):
    if not path.exists():
        return
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        k, v = line.split("=", 1)
        k = k.strip()
        v = v.strip().strip('"').strip("'")
        os.environ.setdefault(k, v)


def main():
    root = Path(__file__).resolve().parents[1]
    load_env(root / ".env")

    model = os.environ.get("MODEL", "arcee-ai/trinity-mini:free")
    model_safe = model.replace("/", "-").replace(":", "-")
    input_file = Path(os.environ.get("INPUT_FILE", "vendor/IFBench/data/IFBench_test.jsonl"))
    input_file = (root / input_file).resolve() if not input_file.is_absolute() else input_file
    if not input_file.exists():
        raise SystemExit(f"Missing INPUT_FILE: {input_file}")

    run_id = time.strftime("%Y%m%d_%H%M%S", time.gmtime()) + f"_smoke_{model_safe}"
    run_dir = root / "runs" / run_id
    eval_dir = run_dir / "eval"
    run_dir.mkdir(parents=True, exist_ok=True)
    eval_dir.mkdir(parents=True, exist_ok=True)

    subset_file = run_dir / "IFBench_smoke.jsonl"
    n = 20
    with input_file.open("r", encoding="utf-8") as fin, subset_file.open("w", encoding="utf-8") as fout:
        for i, line in enumerate(fin):
            if i >= n:
                break
            fout.write(line)

    # Reuse main runner but override INPUT_FILE.
    env = dict(os.environ)
    env["INPUT_FILE"] = str(subset_file)
    subprocess.check_call(["bash", "scripts/run_ifbench.sh"], cwd=str(root), env=env)


if __name__ == "__main__":
    main()
