#!/usr/bin/env python3
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
MEMORY_DIR = ROOT / "memory"

PATTERNS = [
    re.compile(r"\bNate\b.*\b(wants|asked|requested|prefers|needs)\b", re.IGNORECASE),
    re.compile(r"\bnext steps\b", re.IGNORECASE),
    re.compile(r"\bgoals\b", re.IGNORECASE),
    re.compile(r"\bsub-?agents?\b", re.IGNORECASE),
    re.compile(r"\bfallback\b", re.IGNORECASE),
    re.compile(r"\bgroup\b.*\bmention\b", re.IGNORECASE),
]


def interesting(line: str) -> bool:
    text = line.strip()
    if not text:
        return False
    return any(p.search(text) for p in PATTERNS)


def collect():
    items = []
    for path in sorted(MEMORY_DIR.glob("20*.md")):
        try:
            lines = path.read_text(encoding="utf-8", errors="ignore").splitlines()
        except OSError:
            continue
        for i, line in enumerate(lines, start=1):
            if interesting(line):
                items.append(
                    {
                        "file": str(path).replace("\\", "/"),
                        "line": i,
                        "text": line.strip(),
                    }
                )
    return items


def summarize(items):
    summary = {
        "totalSignals": len(items),
        "themes": {
            "group-mention-policy": 0,
            "multi-model-routing": 0,
            "subagent-workflow": 0,
            "cost-and-fallback": 0,
        },
    }
    for it in items:
        t = it["text"].lower()
        if "mention" in t and "group" in t:
            summary["themes"]["group-mention-policy"] += 1
        if "model" in t or "fallback" in t or "agent" in t:
            summary["themes"]["multi-model-routing"] += 1
        if "sub-agent" in t or "subagent" in t:
            summary["themes"]["subagent-workflow"] += 1
        if "cost" in t or "fallback" in t or "rate limit" in t:
            summary["themes"]["cost-and-fallback"] += 1
    return summary


def main():
    items = collect()
    out = {
        "memoryRoot": str(MEMORY_DIR).replace("\\", "/"),
        "summary": summarize(items),
        "signals": items,
    }
    print(json.dumps(out, indent=2))


if __name__ == "__main__":
    main()
