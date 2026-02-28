#!/usr/bin/env python3
"""SPX ↔ SPY converter with cached ratio"""
import sys
import os
import json

CACHE_FILE = "/data/workspace/trading/.spx_spy_ratio"

def get_cached_ratio():
    """Get ratio from cache or use default"""
    if os.path.exists(CACHE_FILE):
        try:
            with open(CACHE_FILE) as f:
                data = json.load(f)
                return data.get('ratio', 10.0), data.get('note', '')
        except:
            pass
    return 10.0, 'default'

def set_ratio(ratio, note=''):
    """Cache the ratio"""
    with open(CACHE_FILE, 'w') as f:
        json.dump({'ratio': ratio, 'note': note}, f)

if len(sys.argv) < 2:
    print("Usage:")
    print("  convert.py <price> [spy]     # Convert (default SPX→SPY)")
    print("  convert.py ratio             # Show current ratio")
    print("  convert.py set <ratio>       # Update ratio manually")
    print("\nExamples:")
    print("  convert.py 6870              # SPX 6870 → SPY")
    print("  convert.py 687 spy           # SPY 687 → SPX")
    print("  convert.py set 9.9985        # Set exact ratio")
    sys.exit(1)

ratio, note = get_cached_ratio()
cmd = sys.argv[1].lower()

if cmd == "ratio":
    print(f"Current ratio: {ratio:.4f} ({note})")
    sys.exit(0)

if cmd == "set":
    if len(sys.argv) < 3:
        print("Usage: convert.py set <ratio>")
        sys.exit(1)
    new_ratio = float(sys.argv[2])
    set_ratio(new_ratio, 'manual')
    print(f"✓ Ratio updated to {new_ratio:.4f}")
    sys.exit(0)

# Convert
price = float(sys.argv[1])
direction = sys.argv[2].lower() if len(sys.argv) > 2 else "spx"

if direction == "spy":
    result = price * ratio
    print(f"SPY ${price:.2f} → SPX ${result:.2f} (ratio: {ratio:.4f})")
else:
    result = price / ratio
    print(f"SPX ${price:.2f} → SPY ${result:.2f} (ratio: {ratio:.4f})")
