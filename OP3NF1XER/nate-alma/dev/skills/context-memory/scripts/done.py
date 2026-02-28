#!/usr/bin/env python3
"""
Mark an item as done/archive it.
Usage: done.py --id <item_id> [--move-to-memory <category>]
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

def save_data(data):
    """Save data to JSON file."""
    with open(DATA_FILE, 'w') as f:
        json.dump(data, f, indent=2)

def mark_done(item_id, move_to=None):
    """Mark item as done or move to memory."""
    data = load_data()
    
    found = False
    for location in ["context", "memory"]:
        for category, items in data[location].items():
            for item in items:
                if item['id'] == item_id:
                    if move_to:
                        # Move to memory category
                        if move_to not in data["memory"]:
                            data["memory"][move_to] = []
                        item['status'] = 'done'
                        data["memory"][move_to].append(item)
                        items.remove(item)
                        print(f"✓ Archived: {item['text']}")
                        print(f"  Moved to memory/{move_to}")
                    else:
                        # Just mark as done
                        item['status'] = 'done'
                        print(f"✓ Done: {item['text']}")
                    
                    save_data(data)
                    found = True
                    break
    
    if not found:
        print(f"Item not found: {item_id}")
        sys.exit(1)

def main():
    parser = argparse.ArgumentParser(description="Mark items as done or archive")
    parser.add_argument("--id", required=True, help="Item ID")
    parser.add_argument("--move-to-memory", help="Move to memory category (optional)")
    
    args = parser.parse_args()
    mark_done(args.id, args.move_to_memory)

if __name__ == "__main__":
    main()
