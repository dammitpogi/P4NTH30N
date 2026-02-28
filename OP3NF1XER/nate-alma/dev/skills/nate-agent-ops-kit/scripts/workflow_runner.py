#!/usr/bin/env python3
import argparse
import json
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]


def run(cmd):
    cp = subprocess.run(
        cmd, shell=False, capture_output=True, text=True, check=False, cwd=ROOT
    )
    return {
        "cmd": " ".join(cmd),
        "code": cp.returncode,
        "stdout": (cp.stdout or "").strip(),
        "stderr": (cp.stderr or "").strip(),
    }


def profile_heartbeat(group_id: str):
    return [
        run(["python", "skills/anthropic-usage/scripts/check_usage.py"]),
        run(["python", "skills/nate-agent-ops-kit/scripts/extract_requests.py"]),
        run(
            [
                "python",
                "skills/nate-agent-ops-kit/scripts/apply_nate_baseline.py",
                "--group-id",
                group_id,
            ]
        ),
    ]


def profile_apply(group_id: str, with_openai: bool):
    cmd = [
        "python",
        "skills/nate-agent-ops-kit/scripts/apply_nate_baseline.py",
        "--group-id",
        group_id,
        "--apply",
        "--restart",
    ]
    if with_openai:
        cmd.append("--with-openai")
    return [run(cmd)]


def profile_deploy_verify(base_url: str):
    return [
        run(
            [
                "python",
                "skills/openclaw-endpoint-kit/scripts/endpoint_probe.py",
                "--base",
                base_url,
            ]
        ),
    ]


def main():
    ap = argparse.ArgumentParser(description="Reusable Nate agent ops workflow runner")
    ap.add_argument(
        "--profile", choices=["heartbeat", "apply", "deploy-verify"], required=True
    )
    ap.add_argument("--group-id", default="-5107377381")
    ap.add_argument("--with-openai", action="store_true")
    ap.add_argument(
        "--base-url",
        default="https://clawdbot-railway-template-production-461f.up.railway.app",
    )
    args = ap.parse_args()

    if args.profile == "heartbeat":
        results = profile_heartbeat(args.group_id)
    elif args.profile == "apply":
        results = profile_apply(args.group_id, args.with_openai)
    else:
        results = profile_deploy_verify(args.base_url)

    ok = all(r["code"] == 0 for r in results)
    print(json.dumps({"ok": ok, "profile": args.profile, "results": results}, indent=2))
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
