#!/usr/bin/env python3
"""
Check for due reminders and return them.
Used by heartbeat to show reminders.
"""

import json
import sys
import time
from pathlib import Path

SKILL_DIR = Path(__file__).parent.parent
DATA_FILE = SKILL_DIR / "data.json"

def load_data():
    if not DATA_FILE.exists():
        return {"reminders": []}
    with open(DATA_FILE, 'r') as f:
        return json.load(f)

def save_data(data):
    with open(DATA_FILE, 'w') as f:
        json.dump(data, f, indent=2)

def check_reminders():
    """Check for due reminders and mark as fired."""
    data = load_data()
    
    if "reminders" not in data:
        return []
    
    now_ms = int(time.time() * 1000)
    due = []
    
    for reminder in data["reminders"]:
        if not reminder.get("fired") and reminder["dueAt"] <= now_ms:
            due.append(reminder)
            reminder["fired"] = True
    
    if due:
        save_data(data)
    
    return due

def format_reminders(reminders):
    """Format reminders for display."""
    if not reminders:
        return None
    
    # Sort by priority
    priority_order = {"high": 0, "normal": 1, "low": 2}
    reminders = sorted(reminders, key=lambda r: priority_order.get(r.get("priority"), 1))
    
    output = []
    
    # High priority reminders get special treatment
    high = [r for r in reminders if r.get("priority") == "high"]
    if high:
        output.append("\n🔴 IMPORTANT REMINDERS:")
        output.append("=" * 50)
        for r in high:
            output.append(f"❗ {r['text']}")
    
    # Normal reminders
    normal = [r for r in reminders if r.get("priority") in ["normal", None]]
    if normal:
        output.append("\n⏰ REMINDERS:")
        for r in normal:
            output.append(f"  • {r['text']}")
    
    # Low priority
    low = [r for r in reminders if r.get("priority") == "low"]
    if low:
        output.append("\n📌 Low Priority:")
        for r in low:
            output.append(f"  • {r['text']}")
    
    return "\n".join(output)

def main():
    due = check_reminders()
    
    if due:
        formatted = format_reminders(due)
        if formatted:
            print(formatted)
    else:
        print("(no due reminders)")

if __name__ == "__main__":
    main()
