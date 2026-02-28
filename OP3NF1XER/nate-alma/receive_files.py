#!/usr/bin/env python3
"""Simple file receiver that works over Railway SSH stdin/stdout"""

import sys
import os
import json


def receive_files():
    # Read header
    header_line = sys.stdin.readline().strip()
    if not header_line:
        print("No header received", file=sys.stderr)
        sys.exit(1)

    try:
        header = json.loads(header_line)
    except json.JSONDecodeError:
        print(f"Invalid header: {header_line}", file=sys.stderr)
        sys.exit(1)

    target_dir = header.get("target_dir", "/data/workspace")
    os.makedirs(target_dir, exist_ok=True)

    # Read files
    num_files = header.get("num_files", 0)
    for i in range(num_files):
        # Read file header
        file_header_line = sys.stdin.readline().strip()
        if not file_header_line:
            break

        try:
            file_header = json.loads(file_header_line)
        except json.JSONDecodeError:
            print(f"Invalid file header: {file_header_line}", file=sys.stderr)
            continue

        filepath = file_header["path"]
        size = file_header["size"]

        # Construct full path
        full_path = os.path.join(target_dir, filepath)
        os.makedirs(os.path.dirname(full_path), exist_ok=True)

        # Read file content
        with open(full_path, "wb") as f:
            remaining = size
            while remaining > 0:
                chunk_size = min(8192, remaining)
                chunk = sys.stdin.buffer.read(chunk_size)
                if not chunk:
                    break
                f.write(chunk)
                remaining -= len(chunk)

        print(f"Received: {filepath} ({size} bytes)")

    print(f"Transfer complete. Files in: {target_dir}")


if __name__ == "__main__":
    receive_files()
