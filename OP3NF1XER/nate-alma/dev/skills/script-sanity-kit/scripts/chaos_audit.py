#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import re
from pathlib import Path

SCRIPT_EXTENSIONS = {".py", ".sh", ".js", ".ts", ".ps1"}


def log(level: str, message: str) -> None:
    print(f"[{level}] {message}")


def pass_line(message: str) -> None:
    log("PASS", message)


def warn_line(message: str) -> None:
    log("WARNING", message)


def discover_scripts(root: Path) -> list[Path]:
    scripts: list[Path] = []
    for path in root.rglob("*"):
        if path.is_file() and path.suffix.lower() in SCRIPT_EXTENSIONS:
            scripts.append(path)
    return sorted(scripts)


def first_line_number(lines: list[str], pattern: str) -> int:
    rx = re.compile(pattern)
    for idx, line in enumerate(lines, start=1):
        if rx.search(line):
            return idx
    return 1


def finding(
    level: str,
    message: str,
    line_number: int,
    recommendation: str,
) -> dict[str, object]:
    severity = "blocker" if level == "WARNING" else "info"
    return {
        "level": level,
        "severity": severity,
        "message": message,
        "line": line_number,
        "recommendation": recommendation,
    }


def check_script(path: Path, root: Path) -> tuple[int, int, list[dict[str, object]]]:
    passes = 0
    warnings = 0
    findings: list[dict[str, object]] = []
    rel = path.relative_to(root)
    text = path.read_text(encoding="utf-8", errors="ignore")
    lines = text.splitlines()

    if lines and lines[0].startswith("#!"):
        pass_line(f"{rel} has shebang")
        passes += 1
        findings.append(
            finding(
                "PASS",
                "has shebang",
                1,
                "No action needed.",
            )
        )
    elif path.suffix.lower() in {".py", ".sh"}:
        warn_line(f"{rel} missing shebang")
        warnings += 1
        findings.append(
            finding(
                "WARNING",
                "missing shebang",
                1,
                "Add a shebang at line 1 (for example: #!/usr/bin/env python3 or #!/usr/bin/env bash).",
            )
        )

    if "[PASS]" in text or "[WARNING]" in text:
        pass_line(f"{rel} includes PASS/WARNING runtime markers")
        passes += 1
        findings.append(
            finding(
                "PASS",
                "includes PASS/WARNING runtime markers",
                first_line_number(lines, r"\[(PASS|WARNING)\]"),
                "No action needed.",
            )
        )
    else:
        pass_line(
            f"{rel} does not include inline PASS/WARNING markers; wrapper logging recommended"
        )
        passes += 1
        findings.append(
            finding(
                "PASS",
                "no inline PASS/WARNING markers",
                1,
                "Run through run_with_sanity.py for verbose runtime diagnostics.",
            )
        )

    if path.suffix.lower() == ".py":
        if "try:" in text and "except" in text:
            pass_line(f"{rel} has exception handling blocks")
            passes += 1
            findings.append(
                finding(
                    "PASS",
                    "has exception handling blocks",
                    first_line_number(lines, r"\btry\s*:"),
                    "No action needed.",
                )
            )
        else:
            pass_line(
                f"{rel} has no try/except blocks; fail-fast behavior may be intentional"
            )
            passes += 1
            findings.append(
                finding(
                    "PASS",
                    "no try/except blocks found",
                    1,
                    "Consider top-level exception handling if this script is operator-facing.",
                )
            )

    if path.suffix.lower() == ".sh":
        if "set -e" in text or "set -euo pipefail" in text:
            pass_line(f"{rel} has shell fail-fast semantics")
            passes += 1
            findings.append(
                finding(
                    "PASS",
                    "has shell fail-fast semantics",
                    first_line_number(lines, r"\bset\s+-e"),
                    "No action needed.",
                )
            )
        else:
            warn_line(f"{rel} missing fail-fast shell options")
            warnings += 1
            findings.append(
                finding(
                    "WARNING",
                    "missing fail-fast shell options",
                    2,
                    "Add 'set -euo pipefail' after shebang to expose command failures early.",
                )
            )

    if "../" in text or "..\\" in text:
        pass_line(f"{rel} uses relative parent traversal; stability review recommended")
        passes += 1
        findings.append(
            finding(
                "PASS",
                "uses parent traversal path coupling",
                first_line_number(lines, r"\.\./|\.\.\\"),
                "Prefer absolute resolution from script location for stronger portability.",
            )
        )
    else:
        pass_line(f"{rel} avoids parent traversal path coupling")
        passes += 1
        findings.append(
            finding(
                "PASS",
                "avoids parent traversal path coupling",
                1,
                "No action needed.",
            )
        )

    return passes, warnings, findings


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Chaos audit for all scripts under skills/ with PASS/WARNING output"
    )
    parser.add_argument(
        "--skills-root",
        default=str(Path(__file__).resolve().parents[2]),
        help="Root directory containing skills subdirectories",
    )
    parser.add_argument(
        "--json-out",
        default="",
        help="Optional output path for machine-readable audit report",
    )
    args = parser.parse_args()

    root = Path(args.skills_root).resolve()
    if not root.exists() or not root.is_dir():
        warn_line(f"skills root not found: {root}")
        return 2

    pass_line(f"skills root resolved: {root}")
    scripts = discover_scripts(root)
    pass_line(f"discovered {len(scripts)} script files")

    total_passes = 0
    total_warnings = 0
    severity_counts = {"blocker": 0, "info": 0}
    report: dict[str, object] = {
        "skillsRoot": str(root),
        "scriptsScanned": len(scripts),
        "checks": [],
    }
    for script in scripts:
        p, w, findings = check_script(script, root)
        total_passes += p
        total_warnings += w
        for item in findings:
            severity = str(item.get("severity", "info"))
            severity_counts[severity] = severity_counts.get(severity, 0) + 1
        report["checks"].append(
            {
                "script": str(script.relative_to(root)),
                "passCount": p,
                "warningCount": w,
                "findings": findings,
            }
        )

    report["passedChecks"] = total_passes
    report["warningChecks"] = total_warnings
    report["severityCounts"] = severity_counts

    if args.json_out:
        out_path = Path(args.json_out)
        if not out_path.is_absolute():
            out_path = Path.cwd() / out_path
        out_path.parent.mkdir(parents=True, exist_ok=True)
        out_path.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
        pass_line(f"wrote json report: {out_path}")

    print()
    print("[PASS] Audit Summary")
    print(f"[PASS] Scripts scanned: {len(scripts)}")
    print(f"[PASS] Passed checks: {total_passes}")
    print(f"[PASS] Severity info checks: {severity_counts.get('info', 0)}")
    if total_warnings:
        print(f"[WARNING] Warning checks: {total_warnings}")
        print(f"[WARNING] Severity blocker checks: {severity_counts.get('blocker', 0)}")
    else:
        print("[PASS] Warning checks: 0")
        print("[PASS] Severity blocker checks: 0")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
