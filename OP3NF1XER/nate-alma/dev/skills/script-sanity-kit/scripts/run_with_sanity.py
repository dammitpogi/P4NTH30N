#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import os
import subprocess
import sys
from pathlib import Path


def out(level: str, message: str) -> None:
    print(f"[{level}] {message}")


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            h.update(chunk)
    return h.hexdigest()


def syntax_check(script: Path) -> tuple[bool, str]:
    suffix = script.suffix.lower()
    if suffix == ".py":
        cmd = [sys.executable, "-m", "py_compile", str(script)]
    elif suffix == ".sh":
        cmd = ["bash", "-n", str(script)]
    elif suffix == ".js":
        cmd = ["node", "--check", str(script)]
    elif suffix == ".ts":
        return False, "TypeScript syntax precheck skipped (no default tsc contract)"
    elif suffix == ".ps1":
        cmd = [
            "powershell",
            "-NoProfile",
            "-Command",
            f"[void][System.Management.Automation.Language.Parser]::ParseFile('{script}', [ref]$null, [ref]$null)",
        ]
    else:
        return False, f"No syntax checker registered for {suffix}"

    cp = subprocess.run(cmd, capture_output=True, text=True, check=False)
    if cp.returncode == 0:
        return True, "syntax check passed"
    details = (cp.stderr or cp.stdout or "syntax check failed").strip()
    return False, details


def build_command(script: Path, script_args: list[str]) -> list[str]:
    suffix = script.suffix.lower()
    if suffix == ".py":
        return [sys.executable, str(script), *script_args]
    if suffix == ".sh":
        return ["bash", str(script), *script_args]
    if suffix == ".js":
        return ["node", str(script), *script_args]
    if suffix == ".ts":
        return ["bun", "run", str(script), *script_args]
    if suffix == ".ps1":
        return ["powershell", "-NoProfile", "-File", str(script), *script_args]
    raise ValueError(f"unsupported script type: {suffix}")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Run a script with preflight sanity checks and verbose PASS/WARNING output"
    )
    parser.add_argument("--script", required=True, help="Path to target script")
    parser.add_argument(
        "script_args",
        nargs=argparse.REMAINDER,
        help="Arguments for target script (use '--' separator)",
    )
    args = parser.parse_args()

    script = Path(args.script).resolve()
    script_args = args.script_args
    if script_args and script_args[0] == "--":
        script_args = script_args[1:]

    out("PASS", f"target script: {script}")
    if not script.exists():
        out("WARNING", "target script does not exist")
        return 2
    if not script.is_file():
        out("WARNING", "target path is not a file")
        return 2

    if os.access(script, os.R_OK):
        out("PASS", "script is readable")
    else:
        out("WARNING", "script is not readable")
        return 2

    before = sha256(script)
    out("PASS", f"pre-run sha256: {before}")

    ok, detail = syntax_check(script)
    if ok:
        out("PASS", detail)
    else:
        out("WARNING", detail)

    try:
        cmd = build_command(script, script_args)
    except Exception as exc:
        out("WARNING", str(exc))
        return 2

    out("PASS", f"exec command: {' '.join(cmd)}")
    cp = subprocess.run(cmd, text=True, capture_output=True, check=False)

    if cp.stdout:
        for line in cp.stdout.splitlines():
            print(f"[RUNTIME] {line}")
    if cp.stderr:
        for line in cp.stderr.splitlines():
            print(f"[RUNTIME][STDERR] {line}")

    after = sha256(script)
    if before == after:
        out("PASS", "script content unchanged during run")
    else:
        out("WARNING", f"script mutated during run: {before} -> {after}")

    if cp.returncode == 0:
        out("PASS", "child script exit code 0")
    else:
        out("WARNING", f"child script exit code {cp.returncode}")

    return cp.returncode


if __name__ == "__main__":
    raise SystemExit(main())
