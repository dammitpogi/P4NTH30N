#!/usr/bin/env python3
import datetime
import json
import re
from pathlib import Path

SKILL_DIR = Path(__file__).resolve().parent.parent
WORKSPACE_ROOT = SKILL_DIR.parent.parent
DOC_ROOT = WORKSPACE_ROOT / "memory" / "alma-teachings"


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="ignore")


def tokenize(text: str):
    return re.findall(r"[a-z0-9]+", text.lower())


def extract_headings(lines):
    headings = []
    for i, line in enumerate(lines, start=1):
        if line.startswith("#"):
            title = line.lstrip("#").strip()
            if title:
                headings.append({"line": i, "title": title})
    return headings


def summarize(lines):
    body = [ln.strip() for ln in lines if ln.strip() and not ln.strip().startswith("#")]
    return " ".join(body[:3])[:280]


def build_doc(doc_id: str, rel_path: str, title: str, tags):
    path = DOC_ROOT / rel_path
    text = read_text(path)
    lines = text.splitlines()
    tokens = tokenize(text)
    freq = {}
    for tok in tokens:
        if len(tok) < 4:
            continue
        freq[tok] = freq.get(tok, 0) + 1
    top_terms = sorted(freq.items(), key=lambda kv: kv[1], reverse=True)[:20]
    token_set = sorted({tok for tok in tokens if len(tok) > 2})
    return {
        "id": doc_id,
        "title": title,
        "path": str(path).replace("\\", "/"),
        "relativePath": f"memory/alma-teachings/{rel_path}",
        "tags": tags,
        "summary": summarize(lines),
        "headings": extract_headings(lines),
        "topTerms": [k for k, _ in top_terms],
        "tokenSet": token_set,
        "lineCount": len(lines),
    }


def main():
    docs = [
        build_doc(
            "bible-v3",
            "bible/AI_BIBLE_v3_AGENT_INDEXED.md",
            "AI Bible v3 (Agent Indexed)",
            ["bible", "regime", "events", "levels", "invalidation"],
        ),
        build_doc(
            "textbook-v3",
            "textbook/NATE_TEXTBOOK_v3_AGENT_EDITION.md",
            "Nate Textbook v3 (Agent Edition)",
            ["textbook", "execution", "daily-method", "checklists"],
        ),
        build_doc(
            "delivery-letter-v2",
            "synthesis/DELIVERY_LETTER_P4NTHE0N_TO_NATE_AND_ALMA_2026-02-24.md",
            "Delivery Letter (Emotional Journalist Edition)",
            ["delivery", "journal", "synthesis", "emotion"],
        ),
    ]

    index = {
        "version": "3.0.0",
        "generatedAt": datetime.datetime.now(datetime.UTC).isoformat(),
        "doctrineRoot": "memory/alma-teachings",
        "documents": docs,
        "lookupHints": {
            "regime": ["risk", "volatility", "event pressure", "structure"],
            "levels": ["pivot", "support", "target", "resistance"],
            "events": ["cpi", "nfp", "fomc", "opex", "pce", "geopolitics"],
            "execution": ["bias", "translation", "invalidation", "checklist"],
        },
    }

    out = DOC_ROOT / "index.json"
    out.write_text(json.dumps(index, indent=2), encoding="utf-8")
    print(f"Wrote {out}")


if __name__ == "__main__":
    main()
