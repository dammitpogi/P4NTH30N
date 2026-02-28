#!/usr/bin/env python3
import argparse
import json
import os
import time
import urllib.error
import urllib.request
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
LEDGER_DIR = ROOT / "memory" / "ops"
LEDGER_PATH = LEDGER_DIR / "anthropic-usage-ledger.json"


def pct(used, limit):
    if not limit:
        return None
    return round((used / limit) * 100.0, 2)


def to_int(h):
    try:
        return int(h)
    except Exception:
        return None


def load_ledger():
    if not LEDGER_PATH.exists():
        return {"monthlyTokenBudget": None, "monthlyUsedTokens": 0, "events": []}
    return json.loads(LEDGER_PATH.read_text(encoding="utf-8"))


def save_ledger(data):
    LEDGER_DIR.mkdir(parents=True, exist_ok=True)
    LEDGER_PATH.write_text(
        json.dumps(data, indent=2) + "\n", encoding="utf-8", newline="\n"
    )


def call_anthropic(api_key, model):
    url = "https://api.anthropic.com/v1/messages"
    payload = {
        "model": model,
        "max_tokens": 1,
        "messages": [{"role": "user", "content": "usage probe"}],
    }
    body = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(url, data=body, method="POST")
    req.add_header("x-api-key", api_key)
    req.add_header("anthropic-version", "2023-06-01")
    req.add_header("content-type", "application/json")
    with urllib.request.urlopen(req, timeout=40) as resp:
        raw = resp.read().decode("utf-8", errors="ignore")
        data = json.loads(raw)
        headers = {k.lower(): v for k, v in resp.headers.items()}
        return data, headers


def main():
    ap = argparse.ArgumentParser(description="Anthropic usage percent checker")
    ap.add_argument("--model", default="claude-sonnet-4-5-20250929")
    ap.add_argument("--monthly-budget", type=int, default=None)
    ap.add_argument("--no-ledger", action="store_true")
    args = ap.parse_args()

    key = os.environ.get("ANTHROPIC_API_KEY", "").strip()
    if not key:
        print(
            json.dumps(
                {
                    "ok": False,
                    "error": "ANTHROPIC_API_KEY is missing",
                    "hint": "export ANTHROPIC_API_KEY then rerun",
                },
                indent=2,
            )
        )
        return 1

    try:
        data, h = call_anthropic(key, args.model)
    except urllib.error.HTTPError as e:
        msg = (
            e.read().decode("utf-8", errors="ignore") if hasattr(e, "read") else str(e)
        )
        print(
            json.dumps({"ok": False, "error": f"HTTP {e.code}", "body": msg}, indent=2)
        )
        return 2
    except Exception as e:
        print(json.dumps({"ok": False, "error": str(e)}, indent=2))
        return 3

    req_limit = to_int(h.get("anthropic-ratelimit-requests-limit"))
    req_remaining = to_int(h.get("anthropic-ratelimit-requests-remaining"))
    tok_limit = to_int(h.get("anthropic-ratelimit-tokens-limit"))
    tok_remaining = to_int(h.get("anthropic-ratelimit-tokens-remaining"))

    req_used = (
        req_limit - req_remaining
        if req_limit is not None and req_remaining is not None
        else None
    )
    tok_used = (
        tok_limit - tok_remaining
        if tok_limit is not None and tok_remaining is not None
        else None
    )

    usage = data.get("usage", {})
    call_tokens = int(usage.get("input_tokens", 0)) + int(usage.get("output_tokens", 0))

    ledger = load_ledger()
    if args.monthly_budget is not None:
        ledger["monthlyTokenBudget"] = args.monthly_budget

    if not args.no_ledger:
        ledger["monthlyUsedTokens"] = (
            int(ledger.get("monthlyUsedTokens", 0)) + call_tokens
        )
        ledger.setdefault("events", []).append(
            {
                "ts": int(time.time()),
                "model": args.model,
                "tokens": call_tokens,
            }
        )
        ledger["events"] = ledger["events"][-2000:]
        save_ledger(ledger)

    budget = ledger.get("monthlyTokenBudget")
    budget_used = int(ledger.get("monthlyUsedTokens", 0))

    out = {
        "ok": True,
        "model": args.model,
        "windowUsagePercent": {
            "requests": pct(req_used, req_limit) if req_used is not None else None,
            "tokens": pct(tok_used, tok_limit) if tok_used is not None else None,
        },
        "windowUsageRaw": {
            "requests": {
                "used": req_used,
                "limit": req_limit,
                "remaining": req_remaining,
            },
            "tokens": {
                "used": tok_used,
                "limit": tok_limit,
                "remaining": tok_remaining,
            },
        },
        "probeCallTokens": call_tokens,
        "monthlyBudget": {
            "budgetTokens": budget,
            "usedTokens": budget_used,
            "usedPercent": pct(budget_used, budget) if budget else None,
            "ledgerPath": str(LEDGER_PATH).replace("\\", "/"),
        },
    }
    print(json.dumps(out, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
