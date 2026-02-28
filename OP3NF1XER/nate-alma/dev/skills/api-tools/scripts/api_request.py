#!/usr/bin/env python3
"""
Generic API request script supporting multiple auth types and HTTP methods.
Uses standard library only (no external dependencies).
"""

import argparse
import json
import sys
import base64
from urllib.request import Request, urlopen
from urllib.error import HTTPError, URLError
from urllib.parse import urlencode
import time


def make_request(
    url: str,
    method: str = "GET",
    headers: dict = None,
    data: str = None,
    auth_type: str = None,
    auth_value: str = None,
    timeout: int = 30,
    verbose: bool = False
) -> dict:
    """
    Make an HTTP request with flexible auth and data handling.
    
    Args:
        url: Target URL
        method: HTTP method (GET, POST, PUT, DELETE, PATCH)
        headers: Additional headers as dict
        data: Request body (JSON string or form data)
        auth_type: Type of auth (bearer, api_key, basic)
        auth_value: Auth credential value
        timeout: Request timeout in seconds
        verbose: Print detailed request info
    
    Returns:
        dict with status, headers, body, and timing info
    """
    # Prepare headers
    req_headers = headers or {}
    
    # Handle authentication
    if auth_type and auth_value:
        if auth_type.lower() == "bearer":
            req_headers["Authorization"] = f"Bearer {auth_value}"
        elif auth_type.lower() == "api_key":
            req_headers["X-API-Key"] = auth_value
        elif auth_type.lower() == "basic":
            # Expects auth_value as "username:password"
            credentials = base64.b64encode(auth_value.encode()).decode()
            req_headers["Authorization"] = f"Basic {credentials}"
    
    # Parse request body
    body_data = None
    if data:
        try:
            # Try to parse as JSON
            json_obj = json.loads(data)
            body_data = json.dumps(json_obj).encode('utf-8')
            req_headers.setdefault("Content-Type", "application/json")
        except json.JSONDecodeError:
            # Treat as form data
            body_data = data.encode('utf-8')
            req_headers.setdefault("Content-Type", "application/x-www-form-urlencoded")
    
    # Create request
    req = Request(url, data=body_data, headers=req_headers, method=method.upper())
    
    if verbose:
        print(f"→ {method.upper()} {url}", file=sys.stderr)
        print(f"→ Headers: {json.dumps(dict(req.headers), indent=2)}", file=sys.stderr)
        if body_data:
            try:
                print(f"→ Body: {body_data.decode('utf-8')}", file=sys.stderr)
            except:
                print(f"→ Body: <binary data>", file=sys.stderr)
    
    # Make request
    start_time = time.time()
    try:
        with urlopen(req, timeout=timeout) as response:
            elapsed_ms = (time.time() - start_time) * 1000
            status = response.status
            response_headers = dict(response.headers)
            body = response.read().decode('utf-8')
            
            # Try to parse as JSON
            try:
                body = json.loads(body)
            except json.JSONDecodeError:
                pass  # Keep as string
            
            result = {
                "status": status,
                "ok": 200 <= status < 300,
                "headers": response_headers,
                "body": body,
                "elapsed_ms": round(elapsed_ms, 2)
            }
            
            if verbose:
                print(f"← {status} ({elapsed_ms:.0f}ms)", file=sys.stderr)
            
            return result
            
    except HTTPError as e:
        elapsed_ms = (time.time() - start_time) * 1000
        try:
            body = e.read().decode('utf-8')
            try:
                body = json.loads(body)
            except:
                pass
        except:
            body = None
        
        result = {
            "status": e.code,
            "ok": False,
            "headers": dict(e.headers) if e.headers else {},
            "body": body,
            "elapsed_ms": round(elapsed_ms, 2),
            "error": str(e.reason)
        }
        
        if verbose:
            print(f"← {e.code} {e.reason} ({elapsed_ms:.0f}ms)", file=sys.stderr)
        
        return result
        
    except URLError as e:
        elapsed_ms = (time.time() - start_time) * 1000
        return {
            "status": 0,
            "ok": False,
            "error": str(e.reason),
            "body": None,
            "elapsed_ms": round(elapsed_ms, 2)
        }
    except Exception as e:
        elapsed_ms = (time.time() - start_time) * 1000
        return {
            "status": 0,
            "ok": False,
            "error": str(e),
            "body": None,
            "elapsed_ms": round(elapsed_ms, 2)
        }


def main():
    parser = argparse.ArgumentParser(description="Generic API request tool")
    parser.add_argument("url", help="Target URL")
    parser.add_argument("-X", "--method", default="GET", help="HTTP method (default: GET)")
    parser.add_argument("-H", "--header", action="append", help="Add header (format: 'Key: Value')")
    parser.add_argument("-d", "--data", help="Request body (JSON or form data)")
    parser.add_argument("--auth-type", choices=["bearer", "api_key", "basic"], help="Auth type")
    parser.add_argument("--auth-value", help="Auth credential")
    parser.add_argument("-v", "--verbose", action="store_true", help="Verbose output")
    parser.add_argument("--timeout", type=int, default=30, help="Request timeout (default: 30s)")
    
    args = parser.parse_args()
    
    # Parse headers
    headers = {}
    if args.header:
        for h in args.header:
            if ":" in h:
                key, value = h.split(":", 1)
                headers[key.strip()] = value.strip()
    
    # Make request
    result = make_request(
        url=args.url,
        method=args.method,
        headers=headers,
        data=args.data,
        auth_type=args.auth_type,
        auth_value=args.auth_value,
        verbose=args.verbose,
        timeout=args.timeout
    )
    
    # Output
    print(json.dumps(result, indent=2))
    
    # Exit with error code if request failed
    sys.exit(0 if result.get("ok") else 1)


if __name__ == "__main__":
    main()
