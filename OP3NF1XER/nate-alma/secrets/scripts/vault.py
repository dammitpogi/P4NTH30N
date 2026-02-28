#!/usr/bin/env python3
import argparse
import base64
import json
import os
import secrets
import subprocess
import sys
import time
import urllib.parse
import urllib.request
from pathlib import Path

VAULT_DIR = Path(__file__).resolve().parents[3] / ".secrets" / "auth-vault"
INDEX_PATH = VAULT_DIR / "index.json"
SERVICE_NAME = "openclaw-auth-vault"
DEFAULT_KEY_LENGTH = 40
KEY_CHARSET = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789!@#$%^*-_"


def now_iso() -> str:
    return time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())


def load_index():
    if not INDEX_PATH.exists():
        return {}
    return json.loads(INDEX_PATH.read_text(encoding="utf-8"))


def save_index(idx):
    VAULT_DIR.mkdir(parents=True, exist_ok=True)
    INDEX_PATH.write_text(
        json.dumps(idx, indent=2) + "\n", encoding="utf-8", newline="\n"
    )


def expected_secret_path(name: str, backend: str):
    if backend == "win-dpapi":
        return VAULT_DIR / f"{name}.dpapi"
    if backend == "plaintext":
        return VAULT_DIR / f"{name}.json"
    return None


def normalize_locator(idx: dict, name: str):
    meta = idx.get(name)
    if not meta:
        return None, False
    backend = meta.get("backend")
    locator = meta.get("locator") or ""
    expected = expected_secret_path(name, backend)
    if expected is None:
        return meta, False

    expected_str = str(expected)
    current_path = Path(locator) if locator else None
    if locator == expected_str and expected.exists():
        return meta, False
    if (
        current_path
        and current_path.exists()
        and current_path.resolve() == expected.resolve()
    ):
        meta["locator"] = expected_str
        idx[name] = meta
        return meta, True
    if expected.exists():
        meta["locator"] = expected_str
        idx[name] = meta
        return meta, True
    return meta, False


def ps_run(script: str, env: dict[str, str]):
    cp = subprocess.run(
        ["powershell", "-NoProfile", "-Command", script],
        capture_output=True,
        text=True,
        check=False,
        env={**os.environ, **env},
    )
    return cp.returncode, (cp.stdout or "").strip(), (cp.stderr or "").strip()


def win_encrypt(plain: str):
    script = (
        "$s=ConvertTo-SecureString -String $env:VAULT_SECRET -AsPlainText -Force;"
        "ConvertFrom-SecureString -SecureString $s"
    )
    code, out, err = ps_run(script, {"VAULT_SECRET": plain})
    if code != 0:
        raise RuntimeError(err or "DPAPI encrypt failed")
    return out


def win_decrypt(cipher: str):
    script = (
        "$s=ConvertTo-SecureString $env:VAULT_CIPHER;"
        "$b=[Runtime.InteropServices.Marshal]::SecureStringToBSTR($s);"
        "[Runtime.InteropServices.Marshal]::PtrToStringBSTR($b)"
    )
    code, out, err = ps_run(script, {"VAULT_CIPHER": cipher})
    if code != 0:
        raise RuntimeError(err or "DPAPI decrypt failed")
    return out


def try_keyring():
    try:
        import keyring  # type: ignore

        return keyring
    except Exception:
        return None


def secure_backend(allow_plaintext: bool):
    if os.name == "nt":
        return "win-dpapi"
    if try_keyring() is not None:
        return "keyring"
    if allow_plaintext:
        return "plaintext"
    raise RuntimeError(
        "No secure backend found. Install keyring or pass --allow-plaintext-fallback explicitly."
    )


def write_secret(name: str, payload: dict, allow_plaintext: bool):
    idx = load_index()
    backend = secure_backend(allow_plaintext)
    raw = json.dumps(payload)

    if backend == "win-dpapi":
        cipher = win_encrypt(raw)
        VAULT_DIR.mkdir(parents=True, exist_ok=True)
        sec_path = VAULT_DIR / f"{name}.dpapi"
        sec_path.write_text(cipher, encoding="utf-8")
        locator = str(sec_path)
    elif backend == "keyring":
        kr = try_keyring()
        kr.set_password(SERVICE_NAME, name, raw)
        locator = f"keyring:{SERVICE_NAME}:{name}"
    else:
        VAULT_DIR.mkdir(parents=True, exist_ok=True)
        sec_path = VAULT_DIR / f"{name}.json"
        sec_path.write_text(raw, encoding="utf-8", newline="\n")
        try:
            os.chmod(sec_path, 0o600)
        except Exception:
            pass
        locator = str(sec_path)

    idx[name] = {
        "backend": backend,
        "locator": locator,
        "updatedAt": now_iso(),
        "type": payload.get("type", "unknown"),
        "encrypted": backend != "plaintext",
    }
    save_index(idx)
    return idx[name]


def read_secret(name: str):
    idx = load_index()
    _meta, changed = normalize_locator(idx, name)
    if changed:
        save_index(idx)
    meta = idx.get(name)
    if not meta:
        raise KeyError(f"Secret not found: {name}")
    backend = meta.get("backend")
    locator = meta.get("locator")

    if backend == "win-dpapi":
        cipher = Path(locator).read_text(encoding="utf-8")
        raw = win_decrypt(cipher)
    elif backend == "keyring":
        kr = try_keyring()
        if kr is None:
            raise RuntimeError("keyring backend unavailable in this runtime")
        raw = kr.get_password(SERVICE_NAME, name)
        if raw is None:
            raise RuntimeError("keyring record missing")
    elif backend == "plaintext":
        raw = Path(locator).read_text(encoding="utf-8")
    else:
        raise RuntimeError(f"Unsupported backend: {backend}")

    return meta, json.loads(raw)


def delete_secret(name: str):
    idx = load_index()
    meta = idx.get(name)
    if not meta:
        return False
    backend = meta.get("backend")
    locator = meta.get("locator")
    if backend in {"win-dpapi", "plaintext"}:
        try:
            Path(locator).unlink(missing_ok=True)
        except Exception:
            pass
    elif backend == "keyring":
        kr = try_keyring()
        if kr is not None:
            try:
                kr.delete_password(SERVICE_NAME, name)
            except Exception:
                pass
    idx.pop(name, None)
    save_index(idx)
    return True


def redacted(payload: dict):
    out = dict(payload)
    for k in [
        "token",
        "password",
        "accessToken",
        "refreshToken",
        "clientSecret",
        "key",
        "privateKey",
        "passphrase",
        "secret",
    ]:
        if k in out and out[k]:
            out[k] = "***"
    return out


def generate_key_material(length: int):
    return "".join(secrets.choice(KEY_CHARSET) for _ in range(length))


def key_length(raw: int):
    if raw < 16:
        return 16
    if raw > 256:
        return 256
    return raw


def cmd_set_bearer(args):
    payload = {
        "type": "bearer",
        "token": args.token,
        "description": args.description,
        "createdAt": now_iso(),
    }
    meta = write_secret(args.name, payload, args.allow_plaintext_fallback)
    print(json.dumps({"ok": True, "name": args.name, "meta": meta}, indent=2))


def cmd_set_password(args):
    payload = {
        "type": "password",
        "username": args.username,
        "password": args.password,
        "description": args.description,
        "createdAt": now_iso(),
    }
    meta = write_secret(args.name, payload, args.allow_plaintext_fallback)
    print(json.dumps({"ok": True, "name": args.name, "meta": meta}, indent=2))


def cmd_set_oauth(args):
    payload = {
        "type": "oauth",
        "accessToken": args.access_token,
        "refreshToken": args.refresh_token,
        "expiresAt": args.expires_at,
        "scope": args.scope,
        "tokenUrl": args.token_url,
        "clientId": args.client_id,
        "clientSecret": args.client_secret,
        "createdAt": now_iso(),
    }
    meta = write_secret(args.name, payload, args.allow_plaintext_fallback)
    print(json.dumps({"ok": True, "name": args.name, "meta": meta}, indent=2))


def cmd_set_api_key(args):
    payload = {
        "type": "api-key",
        "provider": args.provider,
        "key": args.key,
        "description": args.description,
        "createdAt": now_iso(),
    }
    meta = write_secret(args.name, payload, args.allow_plaintext_fallback)
    print(json.dumps({"ok": True, "name": args.name, "meta": meta}, indent=2))


def cmd_set_generic(args):
    payload = {
        "type": args.secret_type,
        "secret": args.secret,
        "description": args.description,
        "createdAt": now_iso(),
    }
    if args.username:
        payload["username"] = args.username
    meta = write_secret(args.name, payload, args.allow_plaintext_fallback)
    print(json.dumps({"ok": True, "name": args.name, "meta": meta}, indent=2))


def cmd_generate_key(args):
    length = key_length(args.length)
    material = f"{args.prefix}{generate_key_material(length)}"

    if args.kind == "password":
        payload = {
            "type": "password",
            "username": args.username,
            "password": material,
            "description": args.description,
            "createdAt": now_iso(),
        }
    elif args.kind == "bearer":
        payload = {
            "type": "bearer",
            "token": material,
            "description": args.description,
            "createdAt": now_iso(),
        }
    else:
        payload = {
            "type": "api-key",
            "provider": args.provider,
            "key": material,
            "description": args.description,
            "createdAt": now_iso(),
        }

    meta = write_secret(args.name, payload, args.allow_plaintext_fallback)
    shown = payload if args.reveal else redacted(payload)
    print(
        json.dumps(
            {"ok": True, "name": args.name, "meta": meta, "payload": shown}, indent=2
        )
    )


def cmd_doctor(_args):
    idx = load_index()
    repairs = []
    for name in list(idx.keys()):
        meta, changed = normalize_locator(idx, name)
        if changed:
            repairs.append({"name": name, "locator": meta.get("locator")})
    if repairs:
        save_index(idx)
    print(
        json.dumps(
            {
                "ok": True,
                "vaultDir": str(VAULT_DIR),
                "index": str(INDEX_PATH),
                "repairs": repairs,
                "repairCount": len(repairs),
            },
            indent=2,
        )
    )


def cmd_list(_args):
    idx = load_index()
    print(json.dumps({"count": len(idx), "secrets": idx}, indent=2))


def cmd_get(args):
    meta, payload = read_secret(args.name)
    shown = payload if args.reveal else redacted(payload)
    print(json.dumps({"name": args.name, "meta": meta, "payload": shown}, indent=2))


def cmd_delete(args):
    ok = delete_secret(args.name)
    print(json.dumps({"ok": ok, "name": args.name}, indent=2))


def cmd_auth_header(args):
    _meta, payload = read_secret(args.name)
    stype = payload.get("type")
    token = None
    if stype == "bearer":
        token = payload.get("token")
    elif stype == "oauth":
        token = payload.get("accessToken")
    if not token:
        raise RuntimeError("Secret does not contain a bearer-compatible token")
    header = f"Bearer {token}"
    shown = header if args.reveal else "Bearer ***"
    print(json.dumps({"name": args.name, "authorization": shown}, indent=2))


def cmd_oauth_refresh(args):
    meta, payload = read_secret(args.name)
    if payload.get("type") != "oauth":
        raise RuntimeError("oauth-refresh requires type=oauth")
    token_url = args.token_url or payload.get("tokenUrl")
    client_id = args.client_id or payload.get("clientId")
    client_secret = args.client_secret or payload.get("clientSecret")
    refresh_token = payload.get("refreshToken")
    if not all([token_url, client_id, client_secret, refresh_token]):
        raise RuntimeError("Missing tokenUrl/clientId/clientSecret/refreshToken")

    body = urllib.parse.urlencode(
        {
            "grant_type": "refresh_token",
            "refresh_token": refresh_token,
            "client_id": client_id,
            "client_secret": client_secret,
        }
    ).encode("utf-8")
    req = urllib.request.Request(token_url, data=body, method="POST")
    req.add_header("Content-Type", "application/x-www-form-urlencoded")
    with urllib.request.urlopen(req, timeout=30) as resp:
        data = json.loads(resp.read().decode("utf-8", errors="ignore"))

    payload["accessToken"] = data.get("access_token", payload.get("accessToken"))
    if data.get("refresh_token"):
        payload["refreshToken"] = data.get("refresh_token")
    if data.get("expires_in"):
        payload["expiresAt"] = now_iso()
        payload["expiresIn"] = data.get("expires_in")
    if data.get("scope"):
        payload["scope"] = data.get("scope")
    payload["updatedAt"] = now_iso()

    write_secret(args.name, payload, args.allow_plaintext_fallback)
    print(
        json.dumps(
            {
                "ok": True,
                "name": args.name,
                "meta": meta,
                "payload": redacted(payload),
            },
            indent=2,
        )
    )


def main():
    ap = argparse.ArgumentParser(
        description="Auth vault for passwords, bearer, and OAuth"
    )
    sub = ap.add_subparsers(dest="cmd", required=True)

    def add_common(sp):
        sp.add_argument(
            "--allow-plaintext-fallback",
            action="store_true",
            help="Allow non-secure plaintext fallback when secure backends are unavailable",
        )

    sp = sub.add_parser("set-bearer")
    sp.add_argument("--name", required=True)
    sp.add_argument("--token", required=True)
    sp.add_argument("--description", default="")
    add_common(sp)
    sp.set_defaults(fn=cmd_set_bearer)

    sp = sub.add_parser("set-password")
    sp.add_argument("--name", required=True)
    sp.add_argument("--username", default="")
    sp.add_argument("--password", required=True)
    sp.add_argument("--description", default="")
    add_common(sp)
    sp.set_defaults(fn=cmd_set_password)

    sp = sub.add_parser("set-oauth")
    sp.add_argument("--name", required=True)
    sp.add_argument("--access-token", required=True)
    sp.add_argument("--refresh-token", default="")
    sp.add_argument("--expires-at", default="")
    sp.add_argument("--scope", default="")
    sp.add_argument("--token-url", default="")
    sp.add_argument("--client-id", default="")
    sp.add_argument("--client-secret", default="")
    add_common(sp)
    sp.set_defaults(fn=cmd_set_oauth)

    sp = sub.add_parser("set-api-key")
    sp.add_argument("--name", required=True)
    sp.add_argument("--provider", default="")
    sp.add_argument("--key", required=True)
    sp.add_argument("--description", default="")
    add_common(sp)
    sp.set_defaults(fn=cmd_set_api_key)

    sp = sub.add_parser("set-generic")
    sp.add_argument("--name", required=True)
    sp.add_argument("--secret-type", required=True)
    sp.add_argument("--secret", required=True)
    sp.add_argument("--username", default="")
    sp.add_argument("--description", default="")
    add_common(sp)
    sp.set_defaults(fn=cmd_set_generic)

    sp = sub.add_parser("generate-key")
    sp.add_argument("--name", required=True)
    sp.add_argument(
        "--kind", choices=["api-key", "password", "bearer"], default="api-key"
    )
    sp.add_argument("--provider", default="")
    sp.add_argument("--username", default="")
    sp.add_argument("--length", type=int, default=DEFAULT_KEY_LENGTH)
    sp.add_argument("--prefix", default="")
    sp.add_argument("--description", default="")
    sp.add_argument("--reveal", action="store_true")
    add_common(sp)
    sp.set_defaults(fn=cmd_generate_key)

    sp = sub.add_parser("list")
    sp.set_defaults(fn=cmd_list)

    sp = sub.add_parser("get")
    sp.add_argument("--name", required=True)
    sp.add_argument("--reveal", action="store_true")
    sp.set_defaults(fn=cmd_get)

    sp = sub.add_parser("delete")
    sp.add_argument("--name", required=True)
    sp.set_defaults(fn=cmd_delete)

    sp = sub.add_parser("auth-header")
    sp.add_argument("--name", required=True)
    sp.add_argument("--reveal", action="store_true")
    sp.set_defaults(fn=cmd_auth_header)

    sp = sub.add_parser("oauth-refresh")
    sp.add_argument("--name", required=True)
    sp.add_argument("--token-url", default="")
    sp.add_argument("--client-id", default="")
    sp.add_argument("--client-secret", default="")
    add_common(sp)
    sp.set_defaults(fn=cmd_oauth_refresh)

    sp = sub.add_parser("doctor")
    sp.set_defaults(fn=cmd_doctor)

    args = ap.parse_args()
    try:
        args.fn(args)
    except Exception as e:
        print(json.dumps({"ok": False, "error": str(e)}, indent=2))
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
