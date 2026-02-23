#!/usr/bin/env python3
import argparse
import json
import os
from pathlib import Path


def read_jsonl(path: Path):
    rows = []
    with path.open("r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            rows.append(json.loads(line))
    return rows


def accuracy_from_eval(rows):
    if not rows:
        return None
    vals = [1.0 if r.get("follow_all_instructions") else 0.0 for r in rows]
    return sum(vals) / len(vals)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--run-dir", required=True)
    args = ap.parse_args()

    run_dir = Path(args.run_dir)
    eval_dir = run_dir / "eval"
    meta_path = run_dir / "metadata.json"
    meta = {}
    if meta_path.exists():
        meta = json.loads(meta_path.read_text(encoding="utf-8"))

    loose_files = sorted(eval_dir.glob("*-eval_results_loose.jsonl"))
    strict_files = sorted(eval_dir.glob("*-eval_results_strict.jsonl"))
    if not loose_files or not strict_files:
        raise SystemExit(f"Missing eval outputs in {eval_dir}")

    loose_rows = read_jsonl(loose_files[-1])
    strict_rows = read_jsonl(strict_files[-1])

    summary = {
        "timestamp": meta.get("timestamp"),
        "api_base": meta.get("api_base"),
        "model": meta.get("model"),
        "ifbench_git_sha": meta.get("ifbench_git_sha"),
        "accuracy_loose": accuracy_from_eval(loose_rows),
        "accuracy_strict": accuracy_from_eval(strict_rows),
        "evaluated_count": len(loose_rows),
        "blank_or_error_count": sum(1 for r in loose_rows if not (r.get("response") or "").strip()),
        "eval_files": {
            "loose": str(loose_files[-1].name),
            "strict": str(strict_files[-1].name),
        },
    }

    (run_dir / "summary.json").write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(json.dumps(summary, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
