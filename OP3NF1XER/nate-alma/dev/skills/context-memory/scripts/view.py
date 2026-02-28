#!/usr/bin/env python3
"""
View raw JSON data from context/memory storage.
"""

import json
from pathlib import Path

SKILL_DIR = Path(__file__).parent.parent
DATA_FILE = SKILL_DIR / "data.json"

def main():
    if not DATA_FILE.exists():
        print("{}")
        return
    
    with open(DATA_FILE, 'r') as f:
        data = json.load(f)
    
    print(json.dumps(data, indent=2))

if __name__ == "__main__":
    main()
