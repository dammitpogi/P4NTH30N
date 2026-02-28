#!/usr/bin/env python3
import argparse
import json
import re
from pathlib import Path

SKILL_DIR = Path(__file__).resolve().parent.parent
WORKSPACE_ROOT = SKILL_DIR.parent.parent
DOCTRINE_ROOT = WORKSPACE_ROOT / "memory" / "alma-teachings"
SUBSTACK_DIR = DOCTRINE_ROOT / "substack"
INDEX_PATH = DOCTRINE_ROOT / "bible" / "corpus" / "substack" / "docs.jsonl"

POST_TYPES = {"intraday", "weekly", "educational", "monthly", "other"}

STOPWORDS = {
    "the",
    "and",
    "for",
    "with",
    "from",
    "that",
    "this",
    "into",
    "post",
    "weekly",
    "intraday",
    "unknown",
    "date",
    "paid",
    "share",
    "continue",
    "reading",
    "free",
    "courtesy",
    "alma",
    "next",
    "previous",
}

ALIASES = {
    "volatility": [
        "volatility",
        "vix",
        "vanna",
        "vomma",
        "zomma",
        "vega",
        "gamma",
        "theta",
        "skew",
    ],
    "macro": [
        "fomc",
        "fed",
        "powell",
        "boj",
        "cpi",
        "ppi",
        "pce",
        "rates",
        "yields",
        "inflation",
    ],
    "opex": ["opex", "expiry", "dealer", "positioning", "expo", "flows"],
    "risk": [
        "risk",
        "left-tail",
        "right-tail",
        "tail",
        "window of risk",
        "recession",
        "stagflation",
    ],
    "geopolitics": [
        "china",
        "tariff",
        "war",
        "ukraine",
        "venezuela",
        "geopolitical",
        "bipolar",
    ],
    "ai-crypto": ["nvda", "nvidia", "ai", "bitcoin", "btc", "valuation", "bubble"],
    "education": [
        "what is",
        "concept",
        "var",
        "beta",
        "sharpe",
        "sortino",
        "mean reversion",
        "statistical arbitrage",
        "reflexivity",
        "python course",
    ],
}


def tokenize(text: str):
    tokens = re.findall(r"[a-z0-9]+", text.lower())
    return [t for t in tokens if len(t) > 2 and t not in STOPWORDS]


def parse_post(path: Path):
    text = path.read_text(encoding="utf-8", errors="ignore")
    lines = text.splitlines()
    title = path.stem
    if lines and lines[0].startswith("# "):
        title = lines[0][2:].strip()

    source = ""
    for line in lines[:20]:
        match = re.search(r"\*\*source:\*\*\s*(\S+)", line, flags=re.IGNORECASE)
        if match:
            source = match.group(1).strip()
            break

    body_slice = " ".join(lines[8:20])
    blob = f"{path.name} {title} {body_slice}".lower()

    if "intraday" in blob:
        post_type = "intraday"
    elif "weekly" in blob:
        post_type = "weekly"
    elif "monthly" in blob:
        post_type = "monthly"
    elif any(x in blob for x in ("what is", "concept of", "educational", "course")):
        post_type = "educational"
    else:
        post_type = "other"

    concept_blob = f"{path.stem} {title}".lower()
    concepts = []
    for concept, phrases in ALIASES.items():
        for phrase in phrases:
            if phrase in concept_blob:
                concepts.append(concept)
                break

    return {
        "file": path.name,
        "path": str(path).replace("\\", "/"),
        "title": title,
        "source": source,
        "postType": post_type,
        "tokens": sorted(set(tokenize(f"{title} {body_slice} {path.stem}"))),
        "concepts": sorted(set(concepts)),
        "excerpt": body_slice[:320],
    }


def build_index():
    docs = [parse_post(p) for p in sorted(SUBSTACK_DIR.glob("*.md"))]
    payload = {
        "version": "1.0.0",
        "root": str(SUBSTACK_DIR).replace("\\", "/"),
        "documents": docs,
        "aliases": ALIASES,
    }
    INDEX_PATH.write_text(json.dumps(payload, indent=2), encoding="utf-8")
    return payload


def load_index(rebuild: bool):
    if rebuild or not INDEX_PATH.exists():
        return build_index()
    return json.loads(INDEX_PATH.read_text(encoding="utf-8"))


def expand_query(tokens, query_text):
    expanded = set(tokens)
    concept_hits = set()
    query_lower = query_text.lower()

    for concept, phrases in ALIASES.items():
        matched = False
        for phrase in phrases:
            if " " in phrase and phrase in query_lower:
                matched = True
                break
            if phrase in tokens:
                matched = True
                break
        if matched:
            concept_hits.add(concept)
            expanded.update(tokenize(" ".join(phrases)))

    return expanded, concept_hits


def score_doc(doc, q_tokens, q_concepts):
    score = 0.0
    reasons = []

    title_tokens = set(tokenize(doc.get("title", "")))
    doc_tokens = set(doc.get("tokens", []))
    doc_concepts = set(doc.get("concepts", []))

    token_hits = sorted(t for t in q_tokens if t in doc_tokens)
    title_hits = sorted(t for t in q_tokens if t in title_tokens)
    concept_hits = sorted(c for c in q_concepts if c in doc_concepts)

    if token_hits:
        score += 1.2 * len(token_hits)
        reasons.append(f"token_hits={token_hits[:8]}")
    if title_hits:
        score += 2.8 * len(title_hits)
        reasons.append(f"title_hits={title_hits[:8]}")
    if concept_hits:
        score += 3.5 * len(concept_hits)
        reasons.append(f"concept_hits={concept_hits}")

    return score, reasons


def main():
    ap = argparse.ArgumentParser(
        description="Search Substack teachings with semantic alias expansion."
    )
    ap.add_argument("--query", required=True, help="Natural-language search query")
    ap.add_argument("--top", type=int, default=10, help="Top results to return")
    ap.add_argument(
        "--post-type",
        choices=sorted(POST_TYPES),
        help="Optional post-type filter",
    )
    ap.add_argument("--rebuild-index", action="store_true")
    ap.add_argument("--json", action="store_true")
    args = ap.parse_args()

    index = load_index(rebuild=args.rebuild_index)

    q_tokens = set(tokenize(args.query))
    if not q_tokens:
        raise SystemExit("Query has no searchable tokens.")

    expanded_tokens, concept_hits = expand_query(q_tokens, args.query)

    ranked = []
    for doc in index.get("documents", []):
        if args.post_type and doc.get("postType") != args.post_type:
            continue
        score, reasons = score_doc(doc, expanded_tokens, concept_hits)
        if score <= 0:
            continue
        ranked.append((score, reasons, doc))

    ranked.sort(key=lambda x: x[0], reverse=True)
    ranked = ranked[: max(1, args.top)]

    output = {
        "query": args.query,
        "queryTokens": sorted(q_tokens),
        "expandedTokens": sorted(expanded_tokens),
        "concepts": sorted(concept_hits),
        "postTypeFilter": args.post_type,
        "results": [
            {
                "score": round(score, 2),
                "file": doc["file"],
                "title": doc["title"],
                "postType": doc["postType"],
                "path": doc["path"],
                "source": doc.get("source", ""),
                "concepts": doc.get("concepts", []),
                "reasons": reasons,
            }
            for score, reasons, doc in ranked
        ],
    }

    if args.json:
        print(json.dumps(output, indent=2))
        return

    print(f"Query: {output['query']}")
    print(f"Concepts: {', '.join(output['concepts']) or '-'}")
    if args.post_type:
        print(f"Post type filter: {args.post_type}")
    print("")
    for i, item in enumerate(output["results"], start=1):
        print(f"{i}. [{item['score']}] {item['title']}")
        print(f"   - file: {item['file']}")
        print(f"   - type: {item['postType']}")
        print(f"   - concepts: {', '.join(item['concepts']) or '-'}")
        print(f"   - source: {item['source'] or '-'}")
        print(f"   - path: {item['path']}")
        print("")


if __name__ == "__main__":
    main()
