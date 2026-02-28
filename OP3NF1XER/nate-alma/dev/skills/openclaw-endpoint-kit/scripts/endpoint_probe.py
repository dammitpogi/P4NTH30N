#!/usr/bin/env python3
import argparse
import json
import urllib.request
import urllib.error
import re


def probe(url: str, timeout: int):
    req = urllib.request.Request(url, method="GET")
    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            return {"url": url, "status": resp.status, "ok": 200 <= resp.status < 300}
    except urllib.error.HTTPError as e:
        return {"url": url, "status": e.code, "ok": False, "error": str(e.reason)}
    except Exception as e:
        return {"url": url, "status": 0, "ok": False, "error": str(e)}


def probe_with_body(url: str, timeout: int):
    req = urllib.request.Request(url, method="GET")
    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            body = resp.read().decode("utf-8", errors="ignore")
            title_match = re.search(
                r"<title>(.*?)</title>", body, re.IGNORECASE | re.DOTALL
            )
            title = title_match.group(1).strip() if title_match else ""
            route_kind = "textbook-static"
            if "OpenClaw Control" in title:
                route_kind = "openclaw-spa-shell"
            return {
                "url": url,
                "status": resp.status,
                "ok": 200 <= resp.status < 300,
                "title": title,
                "routeKind": route_kind,
            }
    except urllib.error.HTTPError as e:
        return {"url": url, "status": e.code, "ok": False, "error": str(e.reason)}
    except Exception as e:
        return {"url": url, "status": 0, "ok": False, "error": str(e)}


def main():
    ap = argparse.ArgumentParser(description="Probe OpenClaw endpoint surfaces")
    ap.add_argument(
        "--base", required=True, help="Base URL, e.g. https://...up.railway.app"
    )
    ap.add_argument("--timeout", type=int, default=12)
    args = ap.parse_args()

    base = args.base.rstrip("/")
    routes = ["/", "/healthz", "/openclaw", "/setup/export"]
    checks = [probe(f"{base}{route}", args.timeout) for route in routes]
    textbook = probe_with_body(f"{base}/textbook/", args.timeout)

    output = {
        "base": base,
        "checks": checks,
        "textbookCheck": textbook,
        "textbookUrl": f"{base}/textbook/",
        "portalUrl": f"{base}/openclaw",
    }
    print(json.dumps(output, indent=2))


if __name__ == "__main__":
    main()
