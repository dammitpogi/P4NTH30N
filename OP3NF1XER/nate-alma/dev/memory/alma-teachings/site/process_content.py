#!/usr/bin/env python3
"""
Doctrine Bible - Substack Content Processor
Converts 341 markdown posts into organized textbook chapters
"""

import os
import re
import json
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Tuple

# Configuration - resolve relative to this script's location
SCRIPT_DIR = Path(__file__).resolve().parent
TEACHINGS_ROOT = SCRIPT_DIR.parent
SOURCE_DIR = TEACHINGS_ROOT / "substack"
OUTPUT_DIR = SCRIPT_DIR

# Chapter definitions with keywords for categorization
CHAPTERS = {
    "foundations": {
        "title": "I. Foundations",
        "description": "Core concepts in probability, market theory, and risk mathematics",
        "keywords": [
            "probability",
            "determinism",
            "stochastic",
            "efficient market",
            "momentum",
            "mean reversion",
            "reflexivity",
            "soros",
            "volatility",
            "var",
            "beta",
            "sharpe",
            "sortino",
            "risk metrics",
            "standard deviation",
            "log return",
            "game of probabilities",
            "what is volatility",
            "concept of risk",
        ],
    },
    "principles": {
        "title": "II. Trading Principles",
        "description": "Risk management, position sizing, and trading psychology",
        "keywords": [
            "trading principles",
            "risk management",
            "position sizing",
            "kelly criterion",
            "trading psychology",
            "wall street casino",
            "basic principles",
            "odds",
            "fair bet",
            "reversion scripts",
            "statistical arbitrage",
            "strategies",
        ],
    },
    "mechanics": {
        "title": "III. Market Mechanics",
        "description": "Options Greeks, OpEx flows, VIX, and volatility surface",
        "keywords": [
            "vanna",
            "charm",
            "gamma",
            "zomma",
            "vomma",
            "greeks",
            "opex",
            "vix",
            "vixpery",
            "vol of vol",
            "positioning",
            "flows",
            "mechanics",
            "greek",
            "iv down rv up",
            "short vanna",
            "long zomma",
            "short vomma",
            "vanna flip",
            "speed profile",
            "liquidity structure",
        ],
    },
    "macro": {
        "title": "IV. Macro Analysis",
        "description": "Fed policy, geopolitics, inflation, and economic cycles",
        "keywords": [
            "fed",
            "fomc",
            "cpi",
            "pce",
            "nfp",
            "gdp",
            "inflation",
            "stagflation",
            "geopolitic",
            "iran",
            "china",
            "tariff",
            "war",
            "opec",
            "boj",
            "ecb",
            "rate decision",
            "central bank",
            "macro",
            "recession",
            "bessent put",
            "hidden qe",
            "qe",
            "qt",
            "yield",
            "bond",
            "currency",
            "carry trade",
        ],
    },
    "technical": {
        "title": "V. Technical Analysis",
        "description": "Reading posts, levels, sentiment, and market structure",
        "keywords": [
            "reading my daily",
            "guide to reading",
            "levels",
            "pivot",
            "support",
            "resistance",
            "target",
            "sentiment",
            "structure",
            "momentum",
            "trend",
            "consolidation",
            "breakout",
            "rangebound",
            "technical",
            "analysis",
        ],
    },
    "assets": {
        "title": "VI. Asset Classes",
        "description": "SPX, Gold, Bitcoin, and Bonds analysis",
        "keywords": [
            "spx",
            "spy",
            "es",
            "gold",
            "bitcoin",
            "btc",
            "crypto",
            "bond",
            "yield",
            "index",
            "ndx",
            "nasdaq",
            "asset",
            "commodity",
            "oil",
            "brent",
            "gasoil",
        ],
    },
    "archive": {
        "title": "VII. Analysis Archive",
        "description": "Complete collection of weekly and intraday market posts",
        "keywords": ["weekly post", "intraday post", "market analysis"],
    },
}


def extract_metadata(file_path: Path) -> Dict:
    """Extract metadata from markdown file"""
    content = file_path.read_text(encoding="utf-8")

    # Extract title
    title_match = re.search(r"^# (.+)$", content, re.MULTILINE)
    title = (
        title_match.group(1)
        if title_match
        else file_path.stem.replace("-", " ").title()
    )

    # Extract date
    date_match = re.search(r"\*\*Date:\*\* (.+)$", content, re.MULTILINE)
    date = date_match.group(1) if date_match else "unknown"

    # Extract source URL
    source_match = re.search(r"\*\*Source:\*\* (.+)$", content, re.MULTILINE)
    source = source_match.group(1) if source_match else ""

    # Extract subtitle/description
    subtitle_match = re.search(r"^\u003e (.+)$", content, re.MULTILINE)
    subtitle = subtitle_match.group(1) if subtitle_match else ""

    return {
        "title": title,
        "date": date,
        "source": source,
        "subtitle": subtitle,
        "content": content,
        "filename": file_path.name,
    }


def categorize_post(metadata: Dict) -> str:
    """Determine which chapter a post belongs to"""
    text_to_check = f"{metadata['title']} {metadata['subtitle']} {metadata['content'][:1000]}".lower()

    scores = {}
    for chapter_key, chapter_data in CHAPTERS.items():
        score = 0
        for keyword in chapter_data["keywords"]:
            if keyword.lower() in text_to_check:
                score += 1
        scores[chapter_key] = score

    # Return chapter with highest score, default to archive
    best_match = max(scores, key=scores.get)
    return best_match if scores[best_match] > 0 else "archive"


def process_posts():
    """Process all markdown files and organize into chapters"""
    posts_by_chapter = {key: [] for key in CHAPTERS.keys()}

    # Get all markdown files
    md_files = list(SOURCE_DIR.glob("*.md"))
    print(f"Found {len(md_files)} markdown files")

    for file_path in md_files:
        if file_path.name == "all-posts.json":
            continue

        try:
            metadata = extract_metadata(file_path)
            chapter = categorize_post(metadata)
            posts_by_chapter[chapter].append(metadata)
        except Exception as e:
            print(f"Error processing {file_path}: {e}")

    # Sort posts within each chapter by date
    for chapter in posts_by_chapter:
        posts_by_chapter[chapter].sort(
            key=lambda x: x["date"] if x["date"] != "unknown" else "9999"
        )

    return posts_by_chapter


def generate_search_index(posts_by_chapter: Dict) -> List[Dict]:
    """Generate search index for all posts"""
    index = []

    for chapter_key, posts in posts_by_chapter.items():
        for i, post in enumerate(posts):
            index.append(
                {
                    "id": f"{chapter_key}-{i}",
                    "title": post["title"],
                    "chapter": CHAPTERS[chapter_key]["title"],
                    "chapter_key": chapter_key,
                    "date": post["date"],
                    "excerpt": post["subtitle"][:150]
                    if post["subtitle"]
                    else post["content"][
                        post["content"].find("---") + 3 : post["content"].find("---")
                        + 200
                    ].strip(),
                    "filename": post["filename"],
                }
            )

    return index


def main():
    print("Processing substack posts...")
    posts_by_chapter = process_posts()

    # Print summary
    print("\n" + "=" * 60)
    print("CHAPTER DISTRIBUTION")
    print("=" * 60)
    total = 0
    for chapter_key, posts in posts_by_chapter.items():
        print(f"{CHAPTERS[chapter_key]['title']}: {len(posts)} posts")
        total += len(posts)
    print(f"\nTotal posts categorized: {total}")

    # Save categorization data
    output_data = {
        "generated_at": datetime.now().isoformat(),
        "total_posts": total,
        "chapters": {},
    }

    for chapter_key, posts in posts_by_chapter.items():
        output_data["chapters"][chapter_key] = {
            "info": CHAPTERS[chapter_key],
            "posts": [
                {"title": p["title"], "date": p["date"], "filename": p["filename"]}
                for p in posts
            ],
        }

    # Save to JSON
    json_path = OUTPUT_DIR / "content-index.json"
    json_path.write_text(json.dumps(output_data, indent=2), encoding="utf-8")
    print(f"\nSaved content index to: {json_path}")

    # Generate search index
    search_index = generate_search_index(posts_by_chapter)
    search_path = OUTPUT_DIR / "search-index.json"
    search_path.write_text(json.dumps(search_index, indent=2), encoding="utf-8")
    print(f"Saved search index to: {search_path}")

    return posts_by_chapter


if __name__ == "__main__":
    main()
