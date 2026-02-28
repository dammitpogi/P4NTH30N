#!/usr/bin/env python3
"""
Add a reminder with proper timestamp calculation.
Usage: remind_add.py --text "text" --minutes 30 [--priority high|normal|low]
       remind_add.py --text "text" --hours 2
"""

import json
import sys
import argparse
import time
from pathlib import Path
import uuid

SKILL_DIR = Path(__file__).parent.parent
DATA_FILE = SKILL_DIR / "data.json"

def load_data():
    if not DATA_FILE.exists():
        return {"context": {}, "memory": {}, "reminders": []}
    with open(DATA_FILE, 'r') as f:
        return json.load(f)

def save_data(data):
    with open(DATA_FILE, 'w') as f:
        json.dump(data, f, indent=2)

def add_reminder(text, minutes=None, hours=None, priority="normal"):
    """Add a reminder with calculated due time."""
    data = load_data()
    
    if "reminders" not in data:
        data["reminders"] = []
    
    # Calculate due timestamp
    now_ms = int(time.time() * 1000)
    
    if minutes:
        due_ms = now_ms + (minutes * 60 * 1000)
    elif hours:
        due_ms = now_ms + (hours * 60 * 60 * 1000)
    else:
        print("ERROR: Specify --minutes or --hours")
        sys.exit(1)
    
    reminder = {
        "id": str(uuid.uuid4())[:8],
        "text": text,
        "dueAt": due_ms,
        "priority": priority,  # high, normal, low
        "created": int(time.time()),
        "fired": False
    }
    
    data["reminders"].append(reminder)
    save_data(data)
    
    print(f"✓ Reminder added")
    print(f"  Text: {text}")
    print(f"  Due in: {minutes or hours} {'minutes' if minutes else 'hours'}")
    print(f"  Priority: {priority}")
    print(f"  ID: {reminder['id']}")

def main():
    parser = argparse.ArgumentParser(description="Add a reminder")
    parser.add_argument("--text", required=True, help="Reminder text")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--minutes", type=int, help="Remind in N minutes")
    group.add_argument("--hours", type=int, help="Remind in N hours")
    parser.add_argument("--priority", choices=["high", "normal", "low"], default="normal")
    
    args = parser.parse_args()
    add_reminder(args.text, args.minutes, args.hours, args.priority)

if __name__ == "__main__":
    main()
