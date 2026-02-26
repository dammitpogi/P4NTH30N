#!/usr/bin/env python3
"""Update Nate Doctrine Bible login in auth-vault."""

from __future__ import annotations

import argparse
import getpass
import subprocess
import sys
from pathlib import Path


DEFAULT_SECRET_NAME = "nate-bible-site-login"
DEFAULT_DESCRIPTION = "Doctrine Bible website login"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Set or rotate Bible website username/password in auth-vault.",
    )
    parser.add_argument("--name", default=DEFAULT_SECRET_NAME)
    parser.add_argument("--username", required=True)
    parser.add_argument("--password", default="")
    parser.add_argument("--description", default=DEFAULT_DESCRIPTION)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    password = args.password or getpass.getpass("Bible login password: ")
    if not password:
        print("Password is required.", file=sys.stderr)
        return 2

    vault_script = Path(__file__).resolve().parent / "vault.py"
    cmd = [
        sys.executable,
        str(vault_script),
        "set-password",
        "--name",
        args.name,
        "--username",
        args.username,
        "--password",
        password,
        "--description",
        args.description,
    ]

    completed = subprocess.run(cmd, check=False)
    return completed.returncode


if __name__ == "__main__":
    raise SystemExit(main())
