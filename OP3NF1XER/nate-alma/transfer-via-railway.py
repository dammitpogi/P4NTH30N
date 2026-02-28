#!/usr/bin/env python3
"""
Transfer files from local to Railway OpenClaw deployment via Railway CLI
Uses base64 encoding to transfer through Railway SSH command transport
"""

import os
import sys
import json
import base64
import subprocess
from pathlib import Path

LOCAL_DIR = "C:/P4NTH30N/OP3NF1XER/nate-alma/dev"
REMOTE_DIR = "/data/workspace"
CHUNK_SIZE = 4096  # 4KB chunks to avoid command line limits


def get_files(local_dir):
    """Get list of files to transfer"""
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

    return files


def transfer_file(file_info):
    """Transfer a single file via Railway CLI"""
    filepath = file_info["fullpath"]
    relpath = file_info["path"]
    size = file_info["size"]

    print(f"Transferring: {relpath} ({size} bytes)")

    # Read file in chunks and transfer
    with open(filepath, "rb") as f:
        chunk_num = 0
        while True:
            chunk = f.read(CHUNK_SIZE)
            if not chunk:
                break

            # Encode chunk as base64
            b64_data = base64.b64encode(chunk).decode("utf-8")

            # Create remote directory and write chunk
            remote_path = os.path.join(REMOTE_DIR, relpath).replace("\\", "/")
            remote_dir = os.path.dirname(remote_path)

            # Use Railway SSH to write the chunk
            cmd = f'mkdir -p "{remote_dir}" && echo "{b64_data}" | base64 -d >> "{remote_path}"'
            result = subprocess.run(
                f'railway ssh "{cmd}"',
                capture_output=True,
                text=True,
                cwd=LOCAL_DIR,
                shell=True,
            )

            if result.returncode != 0:
                print(f"Error transferring {relpath}: {result.stderr}")
                return False

            chunk_num += 1
            if chunk_num % 10 == 0:
                print(f"  Progress: {chunk_num * CHUNK_SIZE} / {size} bytes")

    print(f"  Complete: {relpath}")
    return True


def main():
    print(f"Scanning directory: {LOCAL_DIR}")
    files = get_files(LOCAL_DIR)
    print(f"Found {len(files)} files to transfer")
    print(f"Target: {REMOTE_DIR}")
    print()

    success_count = 0
    fail_count = 0

    for file_info in files:
        if transfer_file(file_info):
            success_count += 1
        else:
            fail_count += 1

    print()
    print(f"Transfer complete!")
    print(f"  Success: {success_count}")
    print(f"  Failed: {fail_count}")


if __name__ == "__main__":
    main()
