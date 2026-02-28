#!/usr/bin/env python3
"""Send files to remote server via Railway SSH"""

import os
import json
import sys


def send_directory(local_dir, target_dir="/data/workspace"):
    # Collect files
    files = []
    for root, dirs, filenames in os.walk(local_dir):
        # Skip excluded directories
        dirs[:] = [
            d
            for d in dirs
            if d not in ["node_modules", ".git"] and not d.startswith("tmp-")
        ]

        for filename in filenames:
            filepath = os.path.join(root, filename)
            relpath = os.path.relpath(filepath, local_dir)
            size = os.path.getsize(filepath)
            files.append({"path": relpath, "size": size, "fullpath": filepath})

    # Send header
    header = {"target_dir": target_dir, "num_files": len(files)}
    print(json.dumps(header), flush=True)

    # Send files
    for f in files:
        file_header = {"path": f["path"], "size": f["size"]}
        print(json.dumps(file_header), flush=True)

        with open(f["fullpath"], "rb") as fileobj:
            while True:
                chunk = fileobj.read(8192)
                if not chunk:
                    break
                sys.stdout.buffer.write(chunk)
                sys.stdout.buffer.flush()

        print(f"Sent: {f['path']} ({f['size']} bytes)", file=sys.stderr)

    print(f"Transfer complete. {len(files)} files sent.", file=sys.stderr)


if __name__ == "__main__":
    send_directory("C:/P4NTH30N/OP3NF1XER/nate-alma/dev")
