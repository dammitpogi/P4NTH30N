#!/usr/bin/env python3
"""Railway GraphQL helper for discovery and access verification.

Purpose:
- Send authenticated GraphQL queries/mutations to Railway.
- Verify whether token works with Bearer or Project-Access-Token headers.
- Support access-gate checks before OpenFixer remediation runs.

This tool intentionally avoids storing secrets in files.
Provide token via `--token` or `RAILWAY_API_TOKEN`.
"""

from __future__ import annotations

import argparse
import json
import os
import sys
import urllib.error
import urllib.request
from dataclasses import dataclass
from typing import Any


DEFAULT_ENDPOINT = "https://backboard.railway.com/graphql/v2"


@dataclass
class ProbeResult:
    header_mode: str
    ok: bool
    status_code: int
    body: dict[str, Any]


def _post_graphql(
    endpoint: str,
    token: str,
    query: str,
    variables: dict[str, Any] | None,
    header_mode: str,
    timeout: float,
) -> ProbeResult:
    payload = json.dumps(
        {"query": query, "variables": variables or {}},
        separators=(",", ":"),
    ).encode("utf-8")

    req = urllib.request.Request(endpoint, data=payload, method="POST")
    req.add_header("Content-Type", "application/json")
    req.add_header("Accept", "application/json")
    req.add_header("User-Agent", "curl/8.8.0")

    if header_mode == "bearer":
        req.add_header("Authorization", f"Bearer {token}")
    elif header_mode == "project":
        req.add_header("Project-Access-Token", token)
    else:
        raise ValueError(f"Unsupported header mode: {header_mode}")

    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            body_bytes = resp.read()
            status = resp.getcode()
    except urllib.error.HTTPError as exc:
        body_bytes = exc.read()
        status = exc.code
    except urllib.error.URLError as exc:
        return ProbeResult(
            header_mode=header_mode,
            ok=False,
            status_code=0,
            body={"transportError": str(exc.reason)},
        )

    try:
        body = json.loads(body_bytes.decode("utf-8")) if body_bytes else {}
    except json.JSONDecodeError:
        body = {"raw": body_bytes.decode("utf-8", errors="replace")}

    has_errors = isinstance(body, dict) and "errors" in body
    ok = 200 <= status < 300 and not has_errors
    return ProbeResult(header_mode=header_mode, ok=ok, status_code=status, body=body)


def _print_json(data: dict[str, Any]) -> None:
    print(json.dumps(data, indent=2, sort_keys=False))


def _load_query(args: argparse.Namespace) -> str:
    if args.query:
        return args.query
    if args.query_file:
        with open(args.query_file, "r", encoding="utf-8") as f:
            return f.read()
    raise ValueError("Provide --query or --query-file")


def _load_variables(args: argparse.Namespace) -> dict[str, Any]:
    if args.variables:
        return json.loads(args.variables)
    if args.variables_file:
        with open(args.variables_file, "r", encoding="utf-8") as f:
            return json.load(f)
    return {}


def cmd_probe_auth(args: argparse.Namespace) -> int:
    token = args.token or os.environ.get("RAILWAY_API_TOKEN")
    if not token:
        print("Missing token: use --token or RAILWAY_API_TOKEN", file=sys.stderr)
        return 2

    query = "query { __typename }"
    modes = ["bearer", "project"] if args.mode == "auto" else [args.mode]

    results: list[ProbeResult] = []
    for mode in modes:
        results.append(
            _post_graphql(
                endpoint=args.endpoint,
                token=token,
                query=query,
                variables={},
                header_mode=mode,
                timeout=args.timeout,
            )
        )

    payload = {
        "endpoint": args.endpoint,
        "results": [
            {
                "mode": r.header_mode,
                "ok": r.ok,
                "statusCode": r.status_code,
                "body": r.body,
            }
            for r in results
        ],
    }
    _print_json(payload)
    return 0 if any(r.ok for r in results) else 1


def cmd_execute(args: argparse.Namespace) -> int:
    token = args.token or os.environ.get("RAILWAY_API_TOKEN")
    if not token:
        print("Missing token: use --token or RAILWAY_API_TOKEN", file=sys.stderr)
        return 2

    query = _load_query(args)
    variables = _load_variables(args)
    mode = args.mode

    if mode == "auto":
        auth_probe = _post_graphql(
            endpoint=args.endpoint,
            token=token,
            query="query { __typename }",
            variables={},
            header_mode="bearer",
            timeout=args.timeout,
        )
        mode = "bearer" if auth_probe.ok else "project"

    result = _post_graphql(
        endpoint=args.endpoint,
        token=token,
        query=query,
        variables=variables,
        header_mode=mode,
        timeout=args.timeout,
    )

    _print_json(
        {
            "endpoint": args.endpoint,
            "mode": result.header_mode,
            "ok": result.ok,
            "statusCode": result.status_code,
            "body": result.body,
        }
    )
    return 0 if result.ok else 1


def cmd_schema_hints(args: argparse.Namespace) -> int:
    token = args.token or os.environ.get("RAILWAY_API_TOKEN")
    if not token:
        print("Missing token: use --token or RAILWAY_API_TOKEN", file=sys.stderr)
        return 2

    query = (
        "query { "
        "__schema { "
        "queryType { name fields { name } } "
        "mutationType { name fields { name } } "
        "} "
        "}"
    )
    result = _post_graphql(
        endpoint=args.endpoint,
        token=token,
        query=query,
        variables={},
        header_mode=args.mode,
        timeout=args.timeout,
    )
    _print_json(
        {
            "endpoint": args.endpoint,
            "mode": result.header_mode,
            "ok": result.ok,
            "statusCode": result.status_code,
            "body": result.body,
        }
    )
    return 0 if result.ok else 1


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Railway GraphQL discovery/mutation helper"
    )
    parser.add_argument("--endpoint", default=DEFAULT_ENDPOINT)
    parser.add_argument("--token", help="Railway API token")
    parser.add_argument("--timeout", type=float, default=30.0)

    sub = parser.add_subparsers(dest="command", required=True)

    p_probe = sub.add_parser("probe-auth", help="Probe auth header modes")
    p_probe.add_argument(
        "--mode",
        choices=["auto", "bearer", "project"],
        default="auto",
        help="Header mode to probe",
    )
    p_probe.set_defaults(func=cmd_probe_auth)

    p_exec = sub.add_parser("execute", help="Execute GraphQL query/mutation")
    p_exec.add_argument(
        "--mode",
        choices=["auto", "bearer", "project"],
        default="auto",
    )
    p_exec.add_argument("--query", help="Inline GraphQL query text")
    p_exec.add_argument("--query-file", help="Path to GraphQL query file")
    p_exec.add_argument("--variables", help="JSON string for GraphQL variables")
    p_exec.add_argument("--variables-file", help="Path to JSON variables file")
    p_exec.set_defaults(func=cmd_execute)

    p_schema = sub.add_parser(
        "schema-hints",
        help="Print top-level query/mutation field names",
    )
    p_schema.add_argument(
        "--mode",
        choices=["bearer", "project"],
        default="bearer",
    )
    p_schema.set_defaults(func=cmd_schema_hints)

    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()
    try:
        return args.func(args)
    except FileNotFoundError as exc:
        print(f"File error: {exc}", file=sys.stderr)
        return 2
    except json.JSONDecodeError as exc:
        print(f"Invalid JSON: {exc}", file=sys.stderr)
        return 2
    except ValueError as exc:
        print(str(exc), file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
