import argparse
import json
import os
from typing import Optional

import requests


class SetupClient:
    def __init__(self, base_url: str, password: str) -> None:
        self.base_url = base_url.rstrip("/")
        self.auth = ("admin", password)

    def healthz(self) -> dict:
        """Check wrapper health."""
        response = requests.get(f"{self.base_url}/setup/healthz", auth=self.auth, timeout=10)
        response.raise_for_status()
        return response.json()

    def gateway_health(self) -> dict:
        """Check gateway health via public endpoint."""
        response = requests.get(f"{self.base_url}/healthz", timeout=10)
        response.raise_for_status()
        return response.json()

    def get_status(self) -> dict:
        """Get detailed setup status."""
        response = requests.get(f"{self.base_url}/setup/api/status", auth=self.auth, timeout=10)
        response.raise_for_status()
        return response.json()

    def get_debug(self) -> dict:
        """Get debug info for troubleshooting."""
        response = requests.get(f"{self.base_url}/setup/api/debug", auth=self.auth, timeout=10)
        response.raise_for_status()
        return response.json()

    def run_command(self, command: str, args: Optional[list] = None) -> dict:
        """Run command via setup API."""
        response = requests.post(
            f"{self.base_url}/setup/api/run",
            auth=self.auth,
            json={"command": command, "args": args or []},
            timeout=20,
        )
        response.raise_for_status()
        return response.json()


def main() -> None:
    parser = argparse.ArgumentParser(description="OpenClaw setup API client")
    parser.add_argument(
        "base_url",
        nargs="?",
        default=os.environ.get(
            "OPENCLAW_URL",
            "https://clawdbot-railway-template-production-461f.up.railway.app",
        ),
        help="OpenClaw base URL (default: env OPENCLAW_URL or Railway URL)",
    )
    parser.add_argument(
        "--password",
        default=os.environ.get("SETUP_PASSWORD", "@Q5PDS9zoc2eSnNr%-itS9Eqo!d^"),
        help="Setup password (default: env SETUP_PASSWORD)",
    )
    parser.add_argument("--command", help="Run setup command via /setup/api/run")
    parser.add_argument("--args", nargs="*", help="Arguments for command")
    parser.add_argument("--debug", action="store_true", help="Print debug info")

    args = parser.parse_args()
    client = SetupClient(args.base_url, args.password)

    print("=== Wrapper Health ===")
    print(json.dumps(client.healthz(), indent=2))

    print("\n=== Gateway Health ===")
    print(json.dumps(client.gateway_health(), indent=2))

    print("\n=== Setup Status ===")
    print(json.dumps(client.get_status(), indent=2))

    if args.debug:
        print("\n=== Debug Info ===")
        print(json.dumps(client.get_debug(), indent=2))

    if args.command:
        print("\n=== Command Result ===")
        print(json.dumps(client.run_command(args.command, args.args), indent=2))


if __name__ == "__main__":
    main()
