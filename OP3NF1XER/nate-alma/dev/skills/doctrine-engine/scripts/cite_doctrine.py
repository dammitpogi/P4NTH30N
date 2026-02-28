#!/usr/bin/env python3
import argparse
import json
import re
from pathlib import Path

SKILL_DIR = Path(__file__).resolve().parent.parent
WORKSPACE_ROOT = SKILL_DIR.parent.parent
DOC_ROOT = WORKSPACE_ROOT / "memory" / "alma-teachings"
INDEX_PATH = DOC_ROOT / "bible" / "index.json"


def tokenize(text: str):
    return [t for t in re.findall(r"[a-z0-9]+", text.lower()) if len(t) > 2]


def load_index():
    return json.loads(INDEX_PATH.read_text(encoding="utf-8"))


def resolve_path(doc_id: str, path_arg: str):
    if path_arg:
        return Path(path_arg)
    if not doc_id:
        raise SystemExit("Provide --doc or --path")
    index = load_index()
    for doc in index.get("documents", []):
        if doc.get("id") == doc_id:
            return Path(doc["path"])
    raise SystemExit(f"Document not found: {doc_id}")


def main():
    ap = argparse.ArgumentParser(description="Extract cite-ready doctrine lines")
    ap.add_argument("--query", required=True)
    ap.add_argument("--doc")
    ap.add_argument("--path")
    ap.add_argument("--max", type=int, default=5)
    args = ap.parse_args()

    path = resolve_path(args.doc, args.path)
    lines = path.read_text(encoding="utf-8", errors="ignore").splitlines()
    q_tokens = set(tokenize(args.query))
    matches = []
    for i, line in enumerate(lines, start=1):
        l_tokens = set(tokenize(line))
        overlap = q_tokens & l_tokens
        if not overlap:
            continue
        score = len(overlap)
        matches.append((score, i, line.strip(), sorted(overlap)))

    matches.sort(key=lambda x: (-x[0], x[1]))
    matches = matches[: max(1, args.max)]

    out = {
        "query": args.query,
        "path": str(path).replace("\\", "/"),
        "citations": [
            {
                "line": line_no,
                "text": text,
                "matchedTerms": terms,
                "citation": f"{str(path).replace('\\', '/')}:{line_no}",
            }
            for _, line_no, text, terms in matches
        ],
    }
    print(json.dumps(out, indent=2))


if __name__ == "__main__":
    main()
