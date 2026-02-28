#!/usr/bin/env python3
import argparse
import json
import os
import re
import subprocess
import sys
from pathlib import Path

DEFAULT_MODELS = {
    "opus": "anthropic/claude-opus-4-6",
    "sonnet": "anthropic/claude-sonnet-4-6",
    "haiku": "anthropic/claude-haiku-4-5",
}

FAMILY_RE = re.compile(r"anthropic/claude-(opus|sonnet|haiku)", re.IGNORECASE)


def find_config_path(explicit: str | None) -> Path:
    if explicit:
        p = Path(explicit).expanduser()
        if p.exists():
            return p
        raise FileNotFoundError(f"Config path not found: {p}")

    candidates = []
    env_path = os.environ.get("OPENCLAW_CONFIG_PATH", "").strip()
    if env_path:
        candidates.append(Path(env_path).expanduser())

    candidates.extend(
        [
            Path("/data/.openclaw/openclaw.json"),
            Path("/data/.clawdbot/openclaw.json"),
            Path.home() / ".openclaw" / "openclaw.json",
            Path.home() / ".clawdbot" / "openclaw.json",
        ]
    )

    for p in candidates:
        if p.exists():
            return p

    raise FileNotFoundError(
        "No OpenClaw config found. Checked OPENCLAW_CONFIG_PATH, /data/.openclaw/openclaw.json, /data/.clawdbot/openclaw.json, ~/.openclaw/openclaw.json, ~/.clawdbot/openclaw.json"
    )


def load_json(path: Path):
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def save_json(path: Path, data):
    with path.open("w", encoding="utf-8", newline="\n") as f:
        json.dump(data, f, indent=2)
        f.write("\n")


def family_of(model_id: str) -> str | None:
    m = FAMILY_RE.search(model_id)
    return m.group(1).lower() if m else None


def is_anthropic_model(model_id: str) -> bool:
    return bool(FAMILY_RE.search(model_id))


def collect_model_strings(node, path=""):
    found = []
    if isinstance(node, dict):
        for k, v in node.items():
            p = f"{path}.{k}" if path else k
            found.extend(collect_model_strings(v, p))
    elif isinstance(node, list):
        for i, v in enumerate(node):
            p = f"{path}[{i}]"
            found.extend(collect_model_strings(v, p))
    elif isinstance(node, str) and is_anthropic_model(node):
        found.append((path, node))
    return found


def choose_target_model(raw_target: str, cfg) -> str:
    lower = raw_target.strip().lower()
    if "/" in raw_target:
        return raw_target.strip()

    if lower not in DEFAULT_MODELS:
        raise ValueError("Target must be opus, sonnet, haiku, or explicit model id.")

    existing = collect_model_strings(cfg)
    for _p, model_id in existing:
        fam = family_of(model_id)
        if fam == lower:
            return model_id

    return DEFAULT_MODELS[lower]


def reorder_anthropic_models(models: list[str], target_model: str) -> list[str]:
    anth = [m for m in models if isinstance(m, str) and is_anthropic_model(m)]
    non_anth = [m for m in models if not (isinstance(m, str) and is_anthropic_model(m))]

    target_family = family_of(target_model)
    anth_by_family = {}
    for m in anth:
        fam = family_of(m)
        if fam and fam not in anth_by_family:
            anth_by_family[fam] = m

    ordered = []
    if target_family:
        ordered.append(target_model)
        for fam in ["opus", "sonnet", "haiku"]:
            if fam == target_family:
                continue
            if fam in anth_by_family:
                ordered.append(anth_by_family[fam])
    else:
        ordered = [target_model] + [m for m in anth if m != target_model]

    dedup = []
    seen = set()
    for m in ordered:
        if m not in seen:
            dedup.append(m)
            seen.add(m)

    return dedup + non_anth


def mutate_models(
    node, target_model: str, changes: list[tuple[str, object, object]], path=""
):
    if isinstance(node, dict):
        for k in list(node.keys()):
            v = node[k]
            p = f"{path}.{k}" if path else k

            if (
                isinstance(v, str)
                and k
                in {
                    "model",
                    "currentModel",
                    "primaryModel",
                }
                and is_anthropic_model(v)
            ):
                if v != target_model:
                    changes.append((p, v, target_model))
                    node[k] = target_model
                continue

            if isinstance(v, list) and k in {"models", "fallbackModels"}:
                if any(isinstance(x, str) and is_anthropic_model(x) for x in v):
                    nxt = reorder_anthropic_models(v, target_model)
                    if nxt != v:
                        changes.append((p, v, nxt))
                        node[k] = nxt
                    continue

            mutate_models(v, target_model, changes, p)

    elif isinstance(node, list):
        for i, item in enumerate(node):
            p = f"{path}[{i}]"
            mutate_models(item, target_model, changes, p)


def run_cmd(cmd: list[str]) -> tuple[int, str]:
    try:
        cp = subprocess.run(cmd, capture_output=True, text=True, check=False)
        out = (cp.stdout or "") + (cp.stderr or "")
        return cp.returncode, out.strip()
    except FileNotFoundError:
        return 127, f"Command not found: {cmd[0]}"


def pre_audit_report(
    config_path: Path, before_refs, target_model: str, planned_changes
):
    print("=== PRE-AUDIT ===")
    print(f"configPath: {config_path}")
    print(f"targetModel: {target_model}")
    print(f"anthropicRefsDetected: {len(before_refs)}")
    for p, v in before_refs[:40]:
        print(f"- {p} = {v}")
    if len(before_refs) > 40:
        print(f"- ... ({len(before_refs) - 40} more)")

    print(f"plannedChangeCount: {len(planned_changes)}")
    for p, old, new in planned_changes[:40]:
        print(f"- {p}: {old} -> {new}")
    if len(planned_changes) > 40:
        print(f"- ... ({len(planned_changes) - 40} more)")

    print(
        "selfAuditPre: confirm this target is intended for the active incident/session before applying"
    )


def post_audit_report(after_refs, restart_outcome, status_outcome):
    print("=== POST-AUDIT ===")
    print(f"anthropicRefsAfter: {len(after_refs)}")
    for p, v in after_refs[:40]:
        print(f"- {p} = {v}")
    if len(after_refs) > 40:
        print(f"- ... ({len(after_refs) - 40} more)")

    print("gatewayRestart:")
    print(f"- exitCode: {restart_outcome[0]}")
    if restart_outcome[1]:
        print(f"- output: {restart_outcome[1]}")

    print("gatewayStatus:")
    print(f"- exitCode: {status_outcome[0]}")
    if status_outcome[1]:
        print(f"- output: {status_outcome[1]}")

    print(
        "selfAuditPost: verify active chat agent model and one live response after restart"
    )


def main():
    ap = argparse.ArgumentParser(
        description="Switch Anthropic models in OpenClaw config with self-audit output"
    )
    ap.add_argument(
        "--target",
        required=True,
        help="opus | sonnet | haiku | explicit model id",
    )
    ap.add_argument("--config", help="Explicit openclaw.json path")
    ap.add_argument(
        "--apply",
        action="store_true",
        help="Apply changes. Without this flag, pre-audit preview only.",
    )
    ap.add_argument(
        "--restart",
        action="store_true",
        help="Restart gateway after apply using `openclaw gateway restart`.",
    )
    args = ap.parse_args()

    config_path = find_config_path(args.config)
    cfg = load_json(config_path)
    target_model = choose_target_model(args.target, cfg)

    before_refs = collect_model_strings(cfg)
    draft = json.loads(json.dumps(cfg))
    planned_changes = []
    mutate_models(draft, target_model, planned_changes)

    pre_audit_report(config_path, before_refs, target_model, planned_changes)

    if not args.apply:
        print("previewOnly: true")
        print("nextStep: rerun with --apply --restart once pre-audit is accepted")
        return 0

    save_json(config_path, draft)
    print("=== MUTATION REPORT ===")
    print(f"changedPaths: {len(planned_changes)}")
    for p, old, new in planned_changes[:60]:
        print(f"- {p}: {old} -> {new}")
    if len(planned_changes) > 60:
        print(f"- ... ({len(planned_changes) - 60} more)")

    restart_outcome = (0, "skipped")
    status_outcome = (0, "skipped")
    if args.restart:
        restart_outcome = run_cmd(["openclaw", "gateway", "restart"])
        status_outcome = run_cmd(["openclaw", "gateway", "status"])

    cfg_after = load_json(config_path)
    after_refs = collect_model_strings(cfg_after)
    post_audit_report(after_refs, restart_outcome, status_outcome)
    return 0


if __name__ == "__main__":
    sys.exit(main())
