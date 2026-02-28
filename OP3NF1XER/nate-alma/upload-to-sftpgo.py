#!/usr/bin/env python3
"""Upload files to SFTPGo via HTTP API"""

import os
import json
import base64
import urllib.request
import urllib.error

SFTPGO_URL = "https://sftpgo-alma-production.up.railway.app"
ADMIN_USER = "admin"
ADMIN_PASS = "alma-admin-2026"
LOCAL_DIR = "C:/P4NTH30N/OP3NF1XER/nate-alma/dev"


def get_token():
    """Get admin API token"""
    url = f"{SFTPGO_URL}/api/v2/token"
    data = json.dumps({"username": ADMIN_USER, "password": ADMIN_PASS}).encode()
    req = urllib.request.Request(
        url, data=data, headers={"Content-Type": "application/json"}
    )
    try:
        with urllib.request.urlopen(req) as response:
            result = json.loads(response.read().decode())
            return result.get("access_token")
    except urllib.error.HTTPError as e:
        print(f"Auth error: {e.read().decode()}")
        return None


def create_user(token):
    """Create openclaw user"""
    url = f"{SFTPGO_URL}/api/v2/users"
    user_data = {
        "username": "openclaw",
        "password": "openclaw-transfer-2026",
        "home_dir": "/srv/sftpgo/openclaw",
        "permissions": {"/": ["*"]},
        "status": 1,
    }
    data = json.dumps(user_data).encode()
    req = urllib.request.Request(
        url,
        data=data,
        headers={
            "Content-Type": "application/json",
            "Authorization": f"Bearer {token}",
        },
    )
    try:
        with urllib.request.urlopen(req) as response:
            print("User created successfully")
            return True
    except urllib.error.HTTPError as e:
        if e.code == 409:
            print("User already exists")
            return True
        print(f"Error creating user: {e.read().decode()}")
        return False


def upload_file(token, local_path, remote_path):
    """Upload a file via API"""
    url = f"{SFTPGO_URL}/api/v2/users/openclaw/files?path={urllib.parse.quote(remote_path)}"

    with open(local_path, "rb") as f:
        data = f.read()

    req = urllib.request.Request(
        url,
        data=data,
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/octet-stream",
        },
        method="POST",
    )

    try:
        with urllib.request.urlopen(req) as response:
            return True
    except urllib.error.HTTPError as e:
        print(f"Upload error: {e.read().decode()}")
        return False


def main():
    print("Getting SFTPGo API token...")
    token = get_token()
    if not token:
        print("Failed to authenticate")
        return

    print("Creating user...")
    if not create_user(token):
        print("Failed to create user")
        return

    print(f"Scanning directory: {LOCAL_DIR}")
    files = []
    for root, dirs, filenames in os.walk(LOCAL_DIR):
        dirs[:] = [
            d
            for d in dirs
            if d not in ["node_modules", ".git"] and not d.startswith("tmp-")
        ]
        for filename in filenames:
            filepath = os.path.join(root, filename)
            relpath = os.path.relpath(filepath, LOCAL_DIR)
            files.append(
                {
                    "local": filepath,
                    "remote": relpath.replace("\\", "/"),
                    "size": os.path.getsize(filepath),
                }
            )

    print(f"Found {len(files)} files to upload")

    success = 0
    failed = 0
    for f in files[:10]:  # Test with first 10 files
        print(f"Uploading: {f['remote']} ({f['size']} bytes)...", end=" ")
        if upload_file(token, f["local"], f["remote"]):
            print("OK")
            success += 1
        else:
            print("FAILED")
            failed += 1

    print(f"\nUpload complete: {success} success, {failed} failed")


if __name__ == "__main__":
    main()
