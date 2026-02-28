#!/usr/bin/env python3
"""Receive files on remote server"""

import sys
import os
import json


def receive_files():
    target_dir = "/data/workspace"

    # Read header
    header_line = sys.stdin.readline().strip()
    header = json.loads(header_line)
    num_files = header.get("num_files", 0)

    print(f"Receiving {num_files} files to {target_dir}", file=sys.stderr)

    for i in range(num_files):
        # Read file header
        file_header_line = sys.stdin.readline().strip()
        file_header = json.loads(file_header_line)
        filepath = file_header["path"]
        size = file_header["size"]

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

        print(f"Received: {filepath} ({size} bytes)", file=sys.stderr)

    print(f"Transfer complete.", file=sys.stderr)


if __name__ == "__main__":
    receive_files()
