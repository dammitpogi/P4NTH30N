#!/usr/bin/env python3
"""Generate responses for IFBench with OpenRouter-specific headers.

This is a minimal fork of vendor/IFBench/generate_responses.py.
"""

import argparse
import json
import os
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

import httpx
from tqdm import tqdm


def load_prompts(input_file: str) -> list[dict]:
    prompts = []
    with open(input_file, "r", encoding="utf-8") as f:
        for line in f:
            example = json.loads(line)
            prompts.append({"key": example["key"], "prompt": example["prompt"]})
    return prompts


def build_headers(api_key: str | None) -> dict:
    headers = {"Content-Type": "application/json"}
    if api_key:
        headers["Authorization"] = f"Bearer {api_key}"

    # Optional OpenRouter attribution headers.
    http_referer = (os.getenv("OPENROUTER_HTTP_REFERER") or "").strip()
    x_title = (os.getenv("OPENROUTER_X_TITLE") or "").strip()
    if http_referer:
        headers["HTTP-Referer"] = http_referer
    if x_title:
        headers["X-Title"] = x_title
    return headers


def generate_response(
    client: httpx.Client,
    api_base: str,
    model: str,
    prompt: str,
    temperature: float,
    max_tokens: int,
    api_key: str | None,
    seed: int | None,
) -> str:
    headers = build_headers(api_key)
    payload = {
        "model": model,
        "messages": [{"role": "user", "content": prompt}],
        "temperature": temperature,
        "max_tokens": max_tokens,
    }
    if seed is not None:
        payload["seed"] = seed

    response = client.post(
        f"{api_base.rstrip('/')}/chat/completions",
        headers=headers,
        json=payload,
        timeout=300,
    )
    response.raise_for_status()
    return response.json()["choices"][0]["message"]["content"]


def format_error(exc: Exception) -> str:
    try:
        import httpx

        if isinstance(exc, httpx.HTTPStatusError) and getattr(exc, "response", None) is not None:
            resp = exc.response
            body = ""
            try:
                body = resp.text
            except Exception:
                body = ""
            body = (body or "").strip()
            if len(body) > 500:
                body = body[:500] + "..."
            return f"HTTP {resp.status_code} {resp.reason_phrase}: {body}"
    except Exception:
        pass
    return str(exc)


def load_dotenv(path: Path) -> dict:
    if not path.exists():
        return {}
    out = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        k, v = line.split("=", 1)
        out[k.strip()] = v.strip().strip('"').strip("'")
    return out


def main():
    dotenv = load_dotenv(Path(".env"))
    for k, v in dotenv.items():
        os.environ.setdefault(k, v)

    parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument("--api-base", default=os.getenv("API_BASE", "https://openrouter.ai/api/v1"))
    parser.add_argument("--model", default=os.getenv("MODEL", ""))
    parser.add_argument("--input-file", default=os.getenv("INPUT_FILE", "vendor/IFBench/data/IFBench_test.jsonl"))
    parser.add_argument("--output-file", default=None)
    parser.add_argument("--temperature", type=float, default=float(os.getenv("TEMPERATURE", "0")))
    parser.add_argument("--max-tokens", type=int, default=int(os.getenv("MAX_TOKENS", "4096")))
    parser.add_argument("--seed", type=int, default=None)
    parser.add_argument("--api-key", default=None)
    parser.add_argument("--workers", type=int, default=int(os.getenv("WORKERS", "4")))
    parser.add_argument("--resume", action="store_true")
    args = parser.parse_args()

    if not args.model:
        parser.error("--model is required (or set MODEL in .env)")
    if not args.api_base:
        parser.error("--api-base is required (or set API_BASE in .env)")

    api_key = (
        args.api_key
        or os.getenv("OPENROUTER_API_KEY")
        or os.getenv("API_KEY")
        or ""
    ).strip() or None

    if api_key is None:
        raise SystemExit("Missing API key: set OPENROUTER_API_KEY (preferred) or API_KEY")

    prompts = load_prompts(args.input_file)
    if not args.output_file:
        safe_model_name = args.model.replace("/", "-")
        args.output_file = f"data/{safe_model_name}-responses.jsonl"

    existing_prompts = set()
    existing_responses = []
    if args.resume and Path(args.output_file).exists():
        with open(args.output_file, "r", encoding="utf-8") as f:
            for line in f:
                resp = json.loads(line)
                existing_prompts.add(resp["prompt"])
                existing_responses.append(resp)

    remaining = [p for p in prompts if p["prompt"] not in existing_prompts]
    results = list(existing_responses)
    errors = []

    with httpx.Client() as client:
        with ThreadPoolExecutor(max_workers=args.workers) as executor:
            future_to_prompt = {
                executor.submit(
                    generate_response,
                    client,
                    args.api_base,
                    args.model,
                    p["prompt"],
                    args.temperature,
                    args.max_tokens,
                    api_key,
                    args.seed,
                ): p
                for p in remaining
            }
            with tqdm(total=len(remaining), desc="Generating") as pbar:
                for future in as_completed(future_to_prompt):
                    prompt_data = future_to_prompt[future]
                    try:
                        response = future.result()
                        results.append({"prompt": prompt_data["prompt"], "response": response})
                    except Exception:
                        errors.append({
                            "key": prompt_data.get("key"),
                            "error": format_error(future.exception() or Exception("unknown error")),
                        })
                        results.append({"prompt": prompt_data["prompt"], "response": ""})
                    pbar.update(1)
                    if len(results) % 10 == 0:
                        with open(args.output_file, "w", encoding="utf-8") as f:
                            for r in results:
                                f.write(json.dumps(r) + "\n")

    with open(args.output_file, "w", encoding="utf-8") as f:
        for r in results:
            f.write(json.dumps(r) + "\n")

    if errors:
        err_path = args.output_file + ".errors.jsonl"
        with open(err_path, "w", encoding="utf-8") as f:
            for e in errors:
                f.write(json.dumps(e) + "\n")
        print(f"Errors: {len(errors)} (see {err_path})")
        for e in errors[:3]:
            print(f"  - {e.get('error')}")


if __name__ == "__main__":
    main()
