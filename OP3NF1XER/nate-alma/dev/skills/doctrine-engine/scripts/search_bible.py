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


def ensure_index():
    if INDEX_PATH.exists():
        return
    raise SystemExit("Missing doctrine index. Run scripts/rebuild_index.py first.")


def load_index():
    ensure_index()
    return json.loads(INDEX_PATH.read_text(encoding="utf-8"))


def score_doc(doc, q_tokens):
    bag = set(doc.get("topTerms", []))
    full_tokens = set(doc.get("tokenSet", []))
    heading_tokens = set()
    for h in doc.get("headings", []):
        heading_tokens.update(tokenize(h.get("title", "")))
    tag_tokens = set(tokenize(" ".join(doc.get("tags", []))))
    summary_tokens = set(tokenize(doc.get("summary", "")))

    score = 0.0
    hits = []
    for tok in q_tokens:
        if tok in bag:
            score += 2.0
            hits.append(tok)
        if tok in full_tokens:
            score += 1.2
            hits.append(tok)
        if tok in heading_tokens:
            score += 2.5
        if tok in tag_tokens:
            score += 1.5
        if tok in summary_tokens:
            score += 1.0
    return score, sorted(set(hits))


def main():
    ap = argparse.ArgumentParser(
        description="Semantic search across doctrine bible index"
    )
    ap.add_argument("--query", required=True)
    ap.add_argument("--top", type=int, default=5)
    args = ap.parse_args()

    index = load_index()
    q_tokens = tokenize(args.query)
    if not q_tokens:
        raise SystemExit("Query has no searchable tokens.")

    ranked = []
    for doc in index.get("documents", []):
        score, hits = score_doc(doc, q_tokens)
        if score <= 0:
            continue
        ranked.append((score, hits, doc))

    ranked.sort(key=lambda x: x[0], reverse=True)
    ranked = ranked[: max(1, args.top)]

    output = {
        "query": args.query,
        "tokens": q_tokens,
        "results": [
            {
                "docId": doc["id"],
                "title": doc["title"],
                "score": round(score, 2),
                "path": doc["path"],
                "matchedTerms": hits,
                "summary": doc.get("summary", ""),
                "topHeadings": [h["title"] for h in doc.get("headings", [])[:6]],
            }
            for score, hits, doc in ranked
        ],
    }
    print(json.dumps(output, indent=2))


if __name__ == "__main__":
    main()
