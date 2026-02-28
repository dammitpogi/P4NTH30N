#!/usr/bin/env python3
"""
List items from context/memory storage.
Usage: list.py --category <inbox|ideas|active|blockers|urgent|projects|goals|lessons|decisions>
       list.py --all
"""

import json
import sys
import argparse
from pathlib import Path

SKILL_DIR = Path(__file__).parent.parent
DATA_FILE = SKILL_DIR / "data.json"

def load_data():
    """Load data from JSON file."""
    if not DATA_FILE.exists():
        return {"context": {}, "memory": {}}
    with open(DATA_FILE, 'r') as f:
        return json.load(f)

def list_category(category):
    """List items in a category."""
    data = load_data()
    
    # Find category
    found = False
    for location in ["context", "memory"]:
        if category in data[location]:
            items = data[location][category]
            found = True
            
            print(f"\n{location.upper()}/{category.upper()}")
            print("=" * 50)
            
            if not items:
                print("(empty)")
            else:
                for i, item in enumerate(items, 1):
                    status = f" [{item.get('status', 'active')}]" if item.get('status') != 'active' else ""
                    print(f"{i}. {item['text']}{status}")
                    print(f"   (id: {item['id']})")
            break
    
    if not found:
        print(f"Unknown category: {category}")
        sys.exit(1)

def list_all():
    """List all items in context and memory."""
    data = load_data()
    
    for location in ["context", "memory"]:
        if data[location]:
            print(f"\n{location.upper()}")
            print("=" * 50)
            for category, items in data[location].items():
                if items:
                    print(f"\n{category}:")
                    for item in items:
                        status = f" [{item.get('status')}]" if item.get('status') != 'active' else ""
                        print(f"  - {item['text']}{status}")

def main():
    parser = argparse.ArgumentParser(description="List context/memory items")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--category", help="Category to list")
    group.add_argument("--all", action="store_true", help="List everything")
    
    args = parser.parse_args()
    
    if args.all:
        list_all()
    else:
        list_category(args.category)

if __name__ == "__main__":
    main()
