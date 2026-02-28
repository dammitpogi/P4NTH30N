#!/usr/bin/env python3
import argparse
import json
import os
import subprocess
import sys
from pathlib import Path


DEFAULT_MODEL = {
    "opus": "anthropic/claude-opus-4-1-20250805",
    "sonnet": "anthropic/claude-sonnet-4-5-20250929",
    "haiku": "anthropic/claude-haiku-4-5-20251001",
}


def find_config(explicit: str | None) -> Path:
    if explicit:
        p = Path(explicit).expanduser()
        if not p.exists():
            raise FileNotFoundError(f"Config not found: {p}")
        return p

    env = os.environ.get("OPENCLAW_CONFIG_PATH", "").strip()
    candidates = []
    if env:
        candidates.append(Path(env).expanduser())
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
    raise FileNotFoundError("Could not locate openclaw.json")


def run(cmd):
    try:
        cp = subprocess.run(cmd, capture_output=True, text=True, check=False)
        return cp.returncode, ((cp.stdout or "") + (cp.stderr or "")).strip()
    except FileNotFoundError:
        return 127, f"Command not found: {cmd[0]}"


def load(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


def save(path: Path, cfg):
    path.write_text(json.dumps(cfg, indent=2) + "\n", encoding="utf-8", newline="\n")


def ensure_path(obj, path):
    cur = obj
    for key in path:
        if key not in cur or not isinstance(cur[key], dict):
            cur[key] = {}
        cur = cur[key]
    return cur


def set_value(cfg, path, value, changes):
    cur = cfg
    for k in path[:-1]:
        if k not in cur or not isinstance(cur[k], dict):
            cur[k] = {}
        cur = cur[k]
    leaf = path[-1]
    old = cur.get(leaf, None)
    if old != value:
        cur[leaf] = value
        changes.append((".".join(path), old, value))


def apply_baseline(cfg, group_id: str, with_openai: bool):
    changes = []

    groups = ensure_path(cfg, ["groups"])
    if group_id not in groups or not isinstance(groups[group_id], dict):
        groups[group_id] = {}
    old_group = dict(groups[group_id])
    groups[group_id]["requireMention"] = False
    groups[group_id]["groupPolicy"] = "open"
    if groups[group_id] != old_group:
        changes.append((f"groups.{group_id}", old_group, groups[group_id]))

    agents = ensure_path(cfg, ["agents"])
    defaults = ensure_path(agents, ["defaults"])
    model = ensure_path(defaults, ["model"])
    set_value(cfg, ["agents", "defaults", "model", "provider"], "anthropic", changes)
    set_value(
        cfg,
        ["agents", "defaults", "model", "name"],
        DEFAULT_MODEL["sonnet"],
        changes,
    )
    set_value(
        cfg,
        ["agents", "defaults", "model", "fallbacks"],
        [DEFAULT_MODEL["haiku"], DEFAULT_MODEL["opus"]],
        changes,
    )

    agents_list = agents.get("list", [])
    if not isinstance(agents_list, list):
        agents_list = []
    wanted = [
        {
            "name": "Dash",
            "model": {"provider": "anthropic", "name": DEFAULT_MODEL["sonnet"]},
            "role": "daily chat and routine operations",
        },
        {
            "name": "Coder",
            "model": {"provider": "anthropic", "name": DEFAULT_MODEL["opus"]},
            "role": "complex implementation and debugging",
        },
        {
            "name": "Sprinter",
            "model": {"provider": "anthropic", "name": DEFAULT_MODEL["haiku"]},
            "role": "fast triage and lightweight tasks",
        },
    ]
    if with_openai:
        wanted.append(
            {
                "name": "Scout",
                "model": {"provider": "openai", "name": "gpt-4o"},
                "role": "research and external synthesis",
            }
        )

    by_name = {a.get("name"): a for a in agents_list if isinstance(a, dict)}
    for wa in wanted:
        name = wa["name"]
        if by_name.get(name) != wa:
            by_name[name] = wa
            changes.append((f"agents.list[{name}]", "<old>", wa))

    new_list = [by_name[k] for k in sorted(by_name.keys()) if k]
    if new_list != agents_list:
        agents["list"] = new_list

    return changes


def print_audit(title, payload):
    print(f"=== {title} ===")
    print(json.dumps(payload, indent=2))


def main():
    ap = argparse.ArgumentParser(
        description="Apply Nate baseline OpenClaw config with self-audit"
    )
    ap.add_argument("--config", help="Path to openclaw.json")
    ap.add_argument("--group-id", required=True, help="Telegram group id")
    ap.add_argument("--with-openai", action="store_true")
    ap.add_argument("--apply", action="store_true")
    ap.add_argument("--restart", action="store_true")
    args = ap.parse_args()

    cfg_path = find_config(args.config)
    cfg_before = load(cfg_path)
    preview = json.loads(json.dumps(cfg_before))
    changes = apply_baseline(preview, args.group_id, args.with_openai)

    pre = {
        "configPath": str(cfg_path),
        "groupId": args.group_id,
        "withOpenAI": args.with_openai,
        "plannedChanges": len(changes),
        "sample": changes[:20],
    }
    print_audit("PRE-AUDIT", pre)

    if not args.apply:
        print(
            json.dumps(
                {"previewOnly": True, "next": "rerun with --apply --restart"}, indent=2
            )
        )
        return 0

    save(cfg_path, preview)
    print_audit(
        "MUTATION REPORT",
        {"changedPaths": len(changes), "changes": changes[:40]},
    )

    restart = (0, "skipped")
    status = (0, "skipped")
    if args.restart:
        restart = run(["openclaw", "gateway", "restart"])
        status = run(["openclaw", "gateway", "status"])

    cfg_after = load(cfg_path)
    post = {
        "agentsDefaults": cfg_after.get("agents", {}).get("defaults", {}),
        "groupPolicy": cfg_after.get("groups", {}).get(args.group_id, {}),
        "gatewayRestart": {"code": restart[0], "output": restart[1]},
        "gatewayStatus": {"code": status[0], "output": status[1]},
    }
    print_audit("POST-AUDIT", post)
    return 0


if __name__ == "__main__":
    sys.exit(main())
