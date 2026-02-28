#!/usr/bin/env python3
"""
Create a reminder using proper timestamp calculation.
Usage: remind.py --message "Your message" --minutes 5
       remind.py --message "Your message" --hours 2
       remind.py --message "Your message" --at "14:30" (Mountain Time)
"""

import json
import sys
import argparse
from datetime import datetime, timedelta
import time

def get_current_unix_ms():
    """Get current Unix timestamp in milliseconds."""
    return int(time.time() * 1000)

def create_reminder(message, minutes=None, hours=None, at_time=None):
    """Calculate correct timestamp and return cron job payload."""
    
    now_ms = get_current_unix_ms()
    
    if minutes:
        target_ms = now_ms + (minutes * 60 * 1000)
    elif hours:
        target_ms = now_ms + (hours * 60 * 60 * 1000)
    elif at_time:
        # Parse "HH:MM" in Mountain Time
        try:
            hour, minute = map(int, at_time.split(':'))
            # TODO: Parse Mountain Time properly (would need pytz or manual conversion)
            # For now, just inform user
            print(f"ERROR: --at time parsing not yet implemented")
            sys.exit(1)
        except:
            print(f"Invalid time format. Use HH:MM (e.g., 14:30)")
            sys.exit(1)
    else:
        print("ERROR: Specify --minutes, --hours, or --at")
        sys.exit(1)
    
    job = {
        "name": f"Reminder: {message[:40]}...",
        "schedule": {
            "kind": "at",
            "atMs": target_ms
        },
        "payload": {
            "kind": "systemEvent",
            "text": f"⏰ REMINDER: {message}"
        },
        "sessionTarget": "main"
    }
    
    return job, target_ms

def main():
    parser = argparse.ArgumentParser(description="Create a reminder with correct timestamps")
    parser.add_argument("--message", required=True, help="Reminder message")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--minutes", type=int, help="Remind in N minutes")
    group.add_argument("--hours", type=int, help="Remind in N hours")
    group.add_argument("--at", help="Remind at HH:MM (Mountain Time)")
    
    args = parser.parse_args()
    
    job, target_ms = create_reminder(
        args.message,
        minutes=args.minutes,
        hours=args.hours,
        at_time=args.at
    )
    
    print(json.dumps(job, indent=2))
    print(f"\n# Target timestamp: {target_ms}")
    print(f"# Current timestamp: {get_current_unix_ms()}")

if __name__ == "__main__":
    main()
