#!/usr/bin/env python3
"""
Add items to context/memory storage.
Usage: add.py --category <inbox|ideas|active|blockers|urgent|projects|goals|lessons|decisions> --text "item text"
"""

import json
import sys
import argparse
from datetime import datetime
from pathlib import Path
import uuid

# Get the data file path (parent of scripts folder)
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

def add_item(category, text):
    """Add an item to a category."""
    data = load_data()
    
    # Determine if context or memory
    if category in ["inbox", "ideas", "active", "blockers", "urgent"]:
        location = "context"
    elif category in ["projects", "goals", "lessons", "decisions", "people"]:
        location = "memory"
    else:
        print(f"Unknown category: {category}")
        sys.exit(1)
    
    # Ensure category exists
    if category not in data[location]:
        data[location][category] = []
    
    # Create item
    item = {
        "id": str(uuid.uuid4())[:8],
        "text": text,
        "created": datetime.now().isoformat(),
        "status": "active"
    }
    
    data[location][category].append(item)
    save_data(data)
    
    print(f"✓ Added to {location}/{category}")
    print(f"  {text}")
    return item

def main():
    parser = argparse.ArgumentParser(description="Add items to context/memory")
    parser.add_argument("--category", required=True, help="Category to add to")
    parser.add_argument("--text", required=True, help="Item text")
    
    args = parser.parse_args()
    add_item(args.category, args.text)

if __name__ == "__main__":
    main()
