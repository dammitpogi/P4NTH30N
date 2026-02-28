#!/usr/bin/env python3
import argparse
import json
import re
from pathlib import Path

SKILL_DIR = Path(__file__).resolve().parent.parent
WORKSPACE_ROOT = SKILL_DIR.parent.parent
DECISION_ROOT = WORKSPACE_ROOT / "memory" / "decision-engine"


def tokenize(text: str):
    return [t for t in re.findall(r"[a-z0-9]+", text.lower()) if len(t) > 2]


def score_lines(lines, q_tokens):
    results = []
    for i, line in enumerate(lines, start=1):
        lt = set(tokenize(line))
        overlap = sorted(set(q_tokens) & lt)
        if not overlap:
            continue
        results.append((len(overlap), i, line.strip(), overlap))
    results.sort(key=lambda x: (-x[0], x[1]))
    return results


def main():
    ap = argparse.ArgumentParser(description="Search copied decision engine files")
    ap.add_argument("--query", required=True)
    ap.add_argument("--top", type=int, default=8)
    args = ap.parse_args()

    if not DECISION_ROOT.exists():
        raise SystemExit("Decision engine mirror missing under memory/decision-engine")

    q_tokens = tokenize(args.query)
    all_hits = []
    for p in sorted(DECISION_ROOT.glob("*")):
        if p.is_dir() or p.suffix.lower() not in {".md", ".json"}:
            continue
        lines = p.read_text(encoding="utf-8", errors="ignore").splitlines()
        hits = score_lines(lines, q_tokens)
        for score, line_no, text, overlap in hits[:3]:
            all_hits.append(
                {
                    "score": score,
                    "file": str(p).replace("\\", "/"),
                    "line": line_no,
                    "text": text,
                    "matchedTerms": overlap,
                    "citation": f"{str(p).replace('\\', '/')}:{line_no}",
                }
            )

    all_hits.sort(key=lambda x: (-x["score"], x["file"], x["line"]))
    out = {
        "query": args.query,
        "results": all_hits[: max(1, args.top)],
    }
    print(json.dumps(out, indent=2))


if __name__ == "__main__":
    main()
