#!/usr/bin/env python3
"""
the_Atlas_Forged_Flow_Runner.py — Atlas Forged Flow runner with debug/break step support.

What this adds vs the canon runner:
- New step types:
  - "debug": print a watchlist (or full ctx) and continue (non-interactive by default).
  - "break": interactive pause (REPL) with watchlist / dump / set / continue.
- Watchlist support: expressions like "$txtFilesSorted", "$arrays.headers", "$file", "$result.headers.to"
- Ability to modify ctx mid-run at a breakpoint, including replacing ctx["files"] then continuing.

Compatibility:
- Keeps the original DSL step types: filter, map, sort, foreach, read_file, tool_call, append, condition.
- Tool registry extended with:
    - txt_to_email (existing)
    - to_scopeforgeHeaders (streaming header retarget + @me.com replacement)
    - from_scopeforgeHeaders (generate iCloud-ish headers per template)

Schema validation:
- By default uses "soft" schema mode: if jsonschema validation fails, it logs a warning and falls back
  to minimal validation so extended step types can run without updating the schema.
  Use --schema-strict to force schema compliance.

Usage:
  python the_Atlas_Forged_Flow_Runner_v1.3.2_0051.py automation.json \
      --outdir ./out \
      --result ./result.json \
      --schema ./workflow.schema.json \
      --log ./audit.jsonl \
      --watch '$files,$txtFiles,$txtFilesSorted,$file,$result' \
      --dry-run
"""

from __future__ import annotations

import argparse
import random
import json
import os
import re
import sys
import time
import unicodedata
import uuid as _uuid
from dataclasses import dataclass
from datetime import datetime, timezone, timedelta
from email.utils import parsedate_to_datetime
from typing import Any, Dict, List, Optional, Tuple


# -----------------------------
# Canon-like metadata (separate runner name)
# -----------------------------

RUNNER_NAME = "the_Atlas_Forged_Flow_Runner"
RUNNER_VERSION = "1.3.2"
RUNNER_UPDATE_ID = 56  # pandas display auto-fix + runner hygiene fixes  # merged interop_title_protocol tool  # bumped for API docs/terms enforcement

CANON = {
    "runner_name": RUNNER_NAME,
    "runner_version": RUNNER_VERSION,
    "runner_update_id": RUNNER_UPDATE_ID,
    "filename_pattern": "the_Atlas_Forged_Flow_Runner_v<MAJOR>.<MINOR>.<PATCH>_<UPDATEID>.py",
    "example_filename": "the_Atlas_Forged_Flow_Runner_v1.3.2_0056.py",
}

CHANGELOG = [{"update_id": 42, "summary": "Added debug/break step types with interactive watchlist REPL; added scopeforge header tools."},
    {"update_id": 44, "summary": "Merged workflow.schema.json into runner (embedded schema); extended schema to include debug/break step types."},
    {"update_id": 45, "summary": "Auto-emit canon corpus markdown on each run; added --no-canon-emit and --canon-outdir."},
    {"update_id": 46, "summary": "Added operator type find_header_field_by_value to locate header field names by matching a header value in source files."},
    {"update_id": 47, "summary": "Renamed find_header_field_by_value input from needle->field (dictionary convention); kept needle as backward-compatible alias."},
    {"update_id": 48, "summary": "Canonized find_header_field_by_value input key as field-only (removed needle alias) to keep a single source of truth."},
    {"update_id": 49, "summary": "Canon workflow JSON reshape: workflow={context,steps}; content={input,files,tools}. Runner now normalizes both legacy and canon shapes."},
    {"update_id": 50, "summary": "Canon enforcement: embedded workflow.schema.json updated to v1.3.x canon shape; schema validation is mandatory (no soft fallback)."},
    {"update_id": 51, "summary": "Canon clause added: source_filter exists at tool boundary but is prohibited for Atlas use; included in emitted canon corpus."},
    {"update_id": 52, "summary": "Added arxiv_query tool: fetch + parse arXiv Atom feed (feedparser if available; stdlib XML fallback)."},
    {"update_id": 53, "summary": "Enforced docs_url + terms_url metadata for API tools (starting with arxiv_query)."},
    {"update_id": 55, "summary": "Merged interop_title_protocol tool into runner; removed external tool file dependency."},
    {"update_id": 56, "summary": "Runner now checks/applies pandas display (no truncation) on every start; fixed ToolRegistry + CLI flags."},
]


def runner_metadata() -> dict:
    return {
        "runner_name": RUNNER_NAME,
        "runner_version": RUNNER_VERSION,
        "runner_update_id": RUNNER_UPDATE_ID,
        "utc_built_at": datetime.now(timezone.utc).isoformat(),
    }



# -----------------------------
# Automation JSON normalization (canon + legacy shapes)
# -----------------------------

def normalize_automation(automation: Dict[str, Any]) -> Tuple[Dict[str, Any], List[Dict[str, Any]]]:
    """
    Accepts both legacy and canon workflow shapes and returns:
      - ctx: runtime context dict
      - steps: ordered list of step dicts

    Canon shape:
      {
        name, version, changelog, notes,
        workflow: { context: {...}, steps: { "1": {...}, "2": {...} } },
        content: { input: str, files: [], tools: {} }
      }

    Legacy shape:
      {
        name, version,
        files: [], tools: {}, arrays: {...}, workflow: [ ... ],
        ...other runtime keys...
      }
    """
    # Canon detection
    if isinstance(automation.get("workflow"), dict) and "steps" in automation["workflow"]:
        wf = automation["workflow"] or {}
        content = automation.get("content", {}) or {}
        ctx: Dict[str, Any] = {}

        wf_ctx = wf.get("context", {}) or {}
        if not isinstance(wf_ctx, dict):
            raise ValueError("workflow.context must be an object/dict")
        ctx.update(wf_ctx)

        ctx["input"] = content.get("input", "")
        ctx["files"] = content.get("files", []) or []
        ctx["tools"] = content.get("tools", {}) or {}

        steps_obj = wf.get("steps", {}) or {}
        if not isinstance(steps_obj, dict):
            raise ValueError("workflow.steps must be an object/dict keyed by stepNumber")

        def _step_key(k: str) -> int:
            try:
                return int(k)
            except Exception:
                return 10**9

        ordered = [steps_obj[k] for k in sorted(steps_obj.keys(), key=_step_key)]
        return ctx, ordered

    # Legacy fallback
    ctx = dict(automation)
    steps = automation.get("workflow", []) or []
    if not isinstance(steps, list):
        raise ValueError("Legacy workflow must be a list")
    ctx.setdefault("files", [])
    ctx.setdefault("tools", {})
    return ctx, steps


# -----------------------------
# Canon corpus (auto-emitted on each run)
# -----------------------------

CANON_CORPUS_TEMPLATE = r'''# the_Atlas_Canon_Corpus__v{version}_{update_id:04d}

This document is auto-emitted by the Atlas Forged Flow runner on each run to keep canon co-located with the executable.

## Canon naming & versioning

### Canon runner filename
- Pattern: `the_Atlas_Forged_Flow_Runner_v<MAJOR>.<MINOR>.<PATCH>_<UPDATEID>.py`
- This runner: `the_Atlas_Forged_Flow_Runner_v{version}_{update_id:04d}.py`

### Monotonic versioning for modified artifacts
For any non-canon artifact that is modified and re-emitted (e.g., workflow JSON), use:
- `{{filename}}_####.{{ext}}`

## Workflow Orchestration DSL


### Non-Canon Tool-Boundary Artifacts

`source_filter` exists at the tool boundary. Atlas **MUST NOT** utilize it (no explicit setting, no dependence, no reasoning). It may be referenced only as a prohibited artifact.

### Canon workflow JSON shape (v1.3.0+)
- Top-level: `name`, `version`, `changelog`, `notes`, `workflow`, `content`
- `workflow.context`: runtime variables (including arrays)
- `workflow.steps`: dict keyed by step number ("1", "2", ...)
- `content`: ingress (`input`, `files`, `tools`)


Core step types:
- `filter`, `map`, `sort`, `foreach`, `read_file`, `tool_call`, `append`, `condition`

Debug/inspection step types (runner extensions):
- `debug` — print watchlist (or full dump) and continue (optionally interactive if `break: true` or CLI `--break-on-debug`)
- `break` — interactive pause with watchlist visibility, optional mutation of context, then continue

## Embedded schema

This runner ships with an embedded `workflow.schema.json` (Draft 2020-12).
- Default: validate with embedded schema.
- Override: pass `--schema path/to/workflow.schema.json`.
- Strict: pass `--schema-strict`.

## Emit behavior

On every run, the runner writes this file alongside outputs unless disabled via `--no-canon-emit`.

'''

# -----------------------------
# Logging (structured JSONL)
# -----------------------------

class AuditLogger:
    def __init__(self, path: Optional[str]) -> None:
        self.path = path
        self._fh = open(path, "a", encoding="utf-8") if path else None

    def close(self) -> None:
        if self._fh:
            self._fh.close()
            self._fh = None

    def emit(self, event: str, level: str = "info", **fields: Any) -> None:
        rec = {
            "ts": datetime.now(timezone.utc).isoformat(),
            "level": level,
            "event": event,
            **fields,
        }
        line = json.dumps(rec, ensure_ascii=False)
        if self._fh:
            self._fh.write(line + "\n")
            self._fh.flush()
        else:
            print(line, file=sys.stderr)


# -----------------------------
# Pandas display truncation guard (per-run; no external files)
# -----------------------------

_PANDAS_DISPLAY_DESIRED = {
    "display.max_colwidth": None,
    "display.max_rows": None,
    "display.max_columns": None,
    "display.width": 0,
    "display.expand_frame_repr": False,
    "display.max_seq_items": None,
}


def ensure_pandas_display_fix(log: Optional["AuditLogger"] = None) -> Dict[str, Any]:
    """
    Ensure pandas display options are set to avoid notebook truncation.
    This is intentionally in-process (no filesystem hooks) to keep the runner self-contained.

    Returns a JSON-serializable dict with before/after and whether changes were applied.
    """
    try:
        import pandas as pd  # type: ignore
    except Exception as e:
        info = {"available": False, "applied": False, "error": str(e)}
        if log:
            log.emit("pandas_display_fix", level="info", **info)
        return info

    before = {k: pd.get_option(k) for k in _PANDAS_DISPLAY_DESIRED.keys()}
    mismatched = {k: (before[k], _PANDAS_DISPLAY_DESIRED[k]) for k in _PANDAS_DISPLAY_DESIRED if before.get(k) != _PANDAS_DISPLAY_DESIRED[k]}

    if mismatched:
        for k, v in _PANDAS_DISPLAY_DESIRED.items():
            pd.set_option(k, v)

    after = {k: pd.get_option(k) for k in _PANDAS_DISPLAY_DESIRED.keys()}

    info = {
        "available": True,
        "applied": bool(mismatched),
        "changed_keys": sorted(list(mismatched.keys())),
        "before": before,
        "after": after,
    }
    if log:
        log.emit("pandas_display_fix", level="info", **{k: info[k] for k in ("available", "applied", "changed_keys")})
    return info



# -----------------------------
# Utilities: path expressions
# -----------------------------


def is_expr(s: Any) -> bool:
    return isinstance(s, str) and s.startswith("$")


def split_path(expr: str) -> List[str]:
    if not expr.startswith("$"):
        raise ValueError(f"Not an expression: {expr}")
    expr = expr[1:]
    if expr.startswith("."):
        expr = expr[1:]
    return [p for p in expr.split(".") if p]


def get_in(obj: Any, path: List[str]) -> Any:
    cur = obj
    for p in path:
        if isinstance(cur, dict):
            cur = cur.get(p)
        else:
            cur = getattr(cur, p)
    return cur


def set_in(obj: Any, path: List[str], value: Any) -> None:
    """Set dict path (creates dicts as needed). Path is list of keys."""
    if not path:
        raise ValueError("Cannot set empty path")
    cur = obj
    for p in path[:-1]:
        if isinstance(cur, dict):
            cur = cur.setdefault(p, {})
        else:
            raise ValueError(f"Cannot set through non-dict at '{p}'")
    last = path[-1]
    if not isinstance(cur, dict):
        raise ValueError("Cannot set on non-dict container")
    cur[last] = value


def resolve_expr(expr: str, ctx: Dict[str, Any], scope: Dict[str, Any]) -> Any:
    parts = split_path(expr)
    if not parts:
        return ctx
    root = parts[0]
    if root in scope:
        return get_in(scope[root], parts[1:])
    if root in ctx:
        return get_in(ctx[root], parts[1:])
    return get_in(ctx, parts)


def resolve_value(v: Any, ctx: Dict[str, Any], scope: Dict[str, Any]) -> Any:
    if isinstance(v, dict) and v.get("type") == "extract_line_4_date":
        return op_extract_line_4_date(v, ctx, scope)
    if isinstance(v, dict) and v.get("type") == "find_header_field_by_value":
        return op_find_header_field_by_value(v, ctx, scope)

    if is_expr(v):
        return resolve_expr(v, ctx, scope)

    if isinstance(v, list):
        return [resolve_value(x, ctx, scope) for x in v]

    if isinstance(v, dict):
        return {k: resolve_value(val, ctx, scope) for k, val in v.items()}

    return v


def resolve_target_list(target_expr: str, ctx: Dict[str, Any], scope: Dict[str, Any]) -> List[Any]:
    if not is_expr(target_expr):
        raise ValueError(f"append.target must be an expression path, got: {target_expr}")
    parts = split_path(target_expr)

    if len(parts) == 1:
        parent = ctx
        key = parts[0]
    else:
        root = parts[0]
        if root in scope:
            parent = scope[root]
            rest = parts[1:]
        else:
            parent = ctx
            rest = parts

        for p in rest[:-1]:
            if isinstance(parent, dict):
                parent = parent.setdefault(p, {})
            else:
                raise ValueError(f"append.target parent is not dict at {p}")
        key = rest[-1]

    if key not in parent:
        parent[key] = []
    if not isinstance(parent[key], list):
        raise ValueError(f"append.target does not resolve to a list: {target_expr}")
    return parent[key]


# -----------------------------
# Predicate evaluation
# -----------------------------


def eval_pred(pred: Dict[str, Any], ctx: Dict[str, Any], scope: Dict[str, Any]) -> bool:
    if "eq" in pred:
        a, b = pred["eq"]
        return resolve_value(a, ctx, scope) == resolve_value(b, ctx, scope)
    if "endsWith" in pred:
        s, suf = pred["endsWith"]
        return str(resolve_value(s, ctx, scope) or "").endswith(str(resolve_value(suf, ctx, scope)))
    if "startsWith" in pred:
        s, pre = pred["startsWith"]
        return str(resolve_value(s, ctx, scope) or "").startswith(str(resolve_value(pre, ctx, scope)))
    if "contains" in pred:
        s, sub = pred["contains"]
        return str(resolve_value(sub, ctx, scope)) in str(resolve_value(s, ctx, scope) or "")
    if "and" in pred:
        return all(eval_pred(p, ctx, scope) for p in pred["and"])
    if "or" in pred:
        return any(eval_pred(p, ctx, scope) for p in pred["or"])
    if "not" in pred:
        return not eval_pred(pred["not"], ctx, scope)
    if "any" in pred:
        return any(eval_pred(p, ctx, scope) for p in pred["any"])
    if "all" in pred:
        return all(eval_pred(p, ctx, scope) for p in pred["all"])
    raise ValueError(f"Unknown predicate: {pred}")


# -----------------------------
# Special operator: extract row-4 Date
# -----------------------------


def op_extract_line_4_date(spec: Dict[str, Any], ctx: Dict[str, Any], scope: Dict[str, Any]) -> Any:
    pattern = spec.get("pattern", r"^Date:\s*(.+)$")
    parse = spec.get("parse", "rfc2822_to_iso8601")
    fallback = spec.get("fallback", "raw")
    src = spec.get("from")

    path_val = None
    if src is not None:
        path_val = resolve_value(src, ctx, scope)
    else:
        for v in scope.values():
            if isinstance(v, dict) and "path" in v:
                path_val = v["path"]
                break

    if not path_val:
        return None

    try:
        with open(path_val, "r", encoding="utf-8", errors="replace") as f:
            lines = f.read().splitlines()
        if len(lines) < 4:
            return None
        line4 = lines[3].strip()
        m = re.match(pattern, line4)
        if not m:
            return line4 if fallback == "raw" else None
        date_raw = m.group(1).strip()
        if parse == "rfc2822_to_iso8601":
            try:
                dt = parsedate_to_datetime(date_raw)
                return dt.isoformat()
            except Exception:
                return date_raw if fallback == "raw" else None
        return date_raw
    except FileNotFoundError:
        return None


# -----------------------------
# Special operator: find header field name by matching a value in headers
# -----------------------------


def op_find_header_field_by_value(spec: Dict[str, Any], ctx: Dict[str, Any], scope: Dict[str, Any]) -> Any:
    """
    Scan the beginning of a text file for RFC-822-style header lines and return the header FIELD NAME
    whose value matches the provided field value.

    Spec:
      {
        "type": "find_header_field_by_value",
        "from": "$f.path",
        "field": "Paul Pogi Celebrado <nexus@scopeforge.net>",
        "scan_lines": 200,              # optional
        "case_sensitive": false,        # optional
        "match": "contains"|"equals",   # optional (default: contains)
        "stop_at_blank": true,          # optional (default: true)
        "return": "field"|"field_lower" # optional (default: field)
      }
    """
    src = spec.get("from")
    # Dictionary-style convention: "field" holds the value to match; "field_value" is accepted as a backward-compatible alias.
    needle = spec.get("field")
    if not needle:
        return None

    scan_lines = int(spec.get("scan_lines", 200))
    case_sensitive = bool(spec.get("case_sensitive", False))
    match_mode = spec.get("match", "contains")
    stop_at_blank = spec.get("stop_at_blank", True)
    ret_mode = spec.get("return", "field")

    path_val = resolve_value(src, ctx, scope) if src is not None else None
    if not path_val:
        return None

    header_re = re.compile(r"^([A-Za-z0-9-]+):\s*(.*)$")

    needle_cmp = str(needle) if case_sensitive else str(needle).lower()

    try:
        with open(path_val, "r", encoding="utf-8", errors="replace") as f:
            for i, line in enumerate(f):
                if i >= scan_lines:
                    break
                line = line.rstrip("\n").rstrip("\r")
                if stop_at_blank and line.strip() == "":
                    break
                mm = header_re.match(line)
                if not mm:
                    continue
                field = mm.group(1)
                value = mm.group(2)

                value_cmp = value if case_sensitive else value.lower()

                if match_mode == "equals":
                    ok = (value_cmp.strip() == needle_cmp.strip())
                else:
                    ok = (needle_cmp in value_cmp)

                if ok:
                    return field.lower() if ret_mode == "field_lower" else field
        return None
    except FileNotFoundError:
        return None


# -----------------------------
# Tool implementations
# -----------------------------


# -----------------------------
# Tool: interop_title_protocol (no-hardcoded-phrases title generator)
# -----------------------------
#
# Contract:
# - NEVER inject fixed words/phrases; only use user-provided:
#     * title_frames
#     * must_include_sets
#     * responsibility_bullets
#     * optional format tokens (separators)
#     * optional stopwords
# - If required inputs are missing, return questions instead of guessing.
#
# Args (dict):
#   title_frames: list[str]                      (required)
#   must_include_sets: list[list[str]]           (required; each title must include >=1 token from EACH set)
#   responsibility_bullets: list[str]            (required)
#   format: dict                                 (optional)
#   stopwords: list[str]                         (optional)
#   display_last_n: int                           (optional)
#   variants_per_base: int                        (optional; default 10)
#
# Returns (dict):
#   ok: bool
#   missing?: list[str]
#   questions?: list[dict]
#   ranked_titles?: list[dict]  (worst->best)
#   display_titles?: list[dict]
#   favorite_title?: str
#   job_description?: str
#

def tool_interop_title_protocol(args: Dict[str, Any], *, outdir: str, dry_run: bool) -> Dict[str, Any]:
    import math
    import re

    def _tokenize(text: str) -> List[str]:
        return [t for t in re.split(r"[^A-Za-z0-9]+", str(text)) if t]

    def _lower_set(xs: List[str]) -> set:
        return {str(x).lower() for x in xs if isinstance(x, str) and x}

    def _dedupe_keep_order(xs: List[str]) -> List[str]:
        seen = set()
        out = []
        for x in xs:
            k = str(x).lower()
            if k not in seen:
                seen.add(k)
                out.append(str(x))
        return out

    title_frames = args.get("title_frames") or []
    must_include_sets = args.get("must_include_sets") or []
    responsibility_bullets = args.get("responsibility_bullets") or []
    fmt = args.get("format") or {}
    stopwords = args.get("stopwords") or []
    display_last_n = args.get("display_last_n")
    variants_per_base = int(args.get("variants_per_base", 10))

    missing = []
    if not title_frames:
        missing.append("title_frames")
    if not must_include_sets:
        missing.append("must_include_sets")
    if not responsibility_bullets:
        missing.append("responsibility_bullets")

    if missing:
        questions = []
        if "title_frames" in missing:
            questions.append({"id": "Q_frames", "ask": "Provide allowed title heads (exact list).", "expected": "array[string]"})
        if "must_include_sets" in missing:
            questions.append({"id": "Q_must_include", "ask": "Provide must-include concept sets; each title must include >=1 token from EACH set.", "expected": "array[array[string]]"})
        if "responsibility_bullets" in missing:
            questions.append({"id": "Q_responsibilities", "ask": "Provide 3–6 responsibility bullets (weekly ownership).", "expected": "array[string]"})
        return {"ok": False, "missing": missing, "questions": questions}

    stop = _lower_set(stopwords)

    # Build vocab strictly from user inputs
    bullet_tokens = []
    for b in responsibility_bullets:
        bullet_tokens.extend(_tokenize(b))
    bullet_tokens = [t for t in bullet_tokens if t.lower() not in stop]
    bullet_tokens = _dedupe_keep_order(bullet_tokens)

    must_tokens = []
    for s in must_include_sets:
        if not isinstance(s, list):
            continue
        for t in s:
            if isinstance(t, str) and t and t.lower() not in stop:
                must_tokens.append(t)
    must_tokens = _dedupe_keep_order(must_tokens)

    vocab_meta = {
        "stopwords": list(stop),
        "bullet_tokens": bullet_tokens,
        "must_tokens": must_tokens,
        "vocab": _dedupe_keep_order(must_tokens + bullet_tokens),
    }

    # formatting (structural only)
    primary_sep = fmt.get("primary_separator", " ")
    head_position = fmt.get("head_position", "prefix")   # prefix|suffix
    head_sep = fmt.get("head_separator", " ")
    seps = fmt.get("separators") or []
    if primary_sep not in seps:
        seps = [primary_sep] + list(seps)

    max_words = int(fmt.get("max_words", 12))
    max_core_tokens = int(fmt.get("max_core_tokens", 4))

    # choose representative token from each must-include set (user ordering)
    must_reps = []
    for s in must_include_sets:
        rep = None
        if isinstance(s, list):
            for tok in s:
                if isinstance(tok, str) and tok:
                    rep = tok
                    break
        if rep:
            must_reps.append(rep)

    bullet_pool = [t for t in bullet_tokens if t not in must_reps]

    # build core bundles (must reps + sliding window of bullet tokens)
    cores = []
    base = must_reps[:]
    if not bullet_pool:
        cores.append(base[:max_core_tokens])
    else:
        for i in range(min(20, len(bullet_pool))):
            extra = bullet_pool[i:i + max(0, max_core_tokens - len(base))]
            core = (base + extra)[:max_core_tokens]
            cores.append(core)
        if not cores:
            cores.append(base[:max_core_tokens])

    def _join(parts: List[str], sep: str) -> str:
        return sep.join([p for p in parts if p]).strip()

    def _title_from(head: str, core: List[str], sep: str) -> str:
        if head_position == "suffix":
            return _join(core + [head], sep)
        return (str(head).strip() + head_sep + _join(core, sep)).strip()

    def _satisfies_must(title: str) -> Tuple[bool, List[int]]:
        t = title.lower()
        hit = []
        for i, s in enumerate(must_include_sets):
            ok = False
            if isinstance(s, list):
                for tok in s:
                    if isinstance(tok, str) and tok and tok.lower() in t:
                        ok = True
                        break
            if ok:
                hit.append(i)
        return (len(hit) == len(must_include_sets), hit)

    def _score(title: str) -> Dict[str, float]:
        toks = _tokenize(title)
        toks_l = [x.lower() for x in toks]
        must_l = _lower_set(must_tokens)
        bullets_l = _lower_set(bullet_tokens)

        from_must = any(t in must_l for t in toks_l)
        from_bullets = any(t in bullets_l for t in toks_l)
        bridge = (1.0 if from_must else 0.0) + (1.0 if from_bullets else 0.0)

        n = max(1, len(toks))
        clarity = 1.0 / (1.0 + math.log(1 + n))
        return {"bridge_score": bridge, "clarity_score": clarity, "length_words": float(n)}

    # generate candidates
    candidates = []
    for head in title_frames:
        if not isinstance(head, str) or not head.strip():
            continue
        for core in cores:
            base_title = _title_from(head, core, primary_sep)
            candidates.append({"head": head, "core": core, "title": base_title, "variant": "base"})
            for v in range(variants_per_base):
                # rotate core
                reordered = core[:]
                if reordered:
                    k = (v + 1) % len(reordered)
                    reordered = reordered[k:] + reordered[:k]
                sep = seps[min(v, len(seps) - 1)] if seps else primary_sep
                t2 = _title_from(head, reordered, sep)
                candidates.append({"head": head, "core": reordered, "title": t2, "variant": f"rot{v+1}/sep{v+1}"})

    # filter
    filtered = []
    for c in candidates:
        ok, hit_sets = _satisfies_must(c["title"])
        if not ok:
            continue
        if len(_tokenize(c["title"])) > max_words:
            continue
        c["hit_sets"] = hit_sets
        filtered.append(c)

    # fallback
    if not filtered:
        for head in title_frames:
            title = _title_from(head, must_reps, primary_sep)
            ok, hit_sets = _satisfies_must(title)
            if ok:
                filtered.append({"head": head, "core": must_reps, "title": title, "variant": "fallback", "hit_sets": hit_sets})

    scored = []
    for c in filtered:
        scores = _score(c["title"])
        scored.append({
            **c,
            "scores": scores,
            "constraints_satisfied": {"must_include_sets": True, "max_words": True},
        })

    # worst->best (low bridge then low clarity)
    scored.sort(key=lambda x: (x["scores"]["bridge_score"], x["scores"]["clarity_score"]))

    # dedupe
    uniq = []
    seen = set()
    for s in scored:
        k = s["title"].lower()
        if k in seen:
            continue
        seen.add(k)
        uniq.append(s)

    ranked = [{"rank": i + 1, **u} for i, u in enumerate(uniq)]

    display = ranked
    if display_last_n is not None:
        n = int(display_last_n)
        if n > 0:
            display = ranked[-n:]

    favorite = ranked[-1]["title"] if ranked else None
    job_desc = None
    if favorite:
        bullets = [str(b).strip() for b in responsibility_bullets if isinstance(b, str) and b.strip()]
        if bullets:
            job_desc = f"{favorite} — " + " ".join([b if b.endswith('.') else (b + '.') for b in bullets])
        else:
            job_desc = f"{favorite} — (Provide responsibility_bullets to generate a grounded job description.)"

    return {
        "ok": True,
        "vocab_meta": vocab_meta,
        "ranked_titles": ranked,
        "display_titles": display,
        "favorite_title": favorite,
        "job_description": job_desc,
    }



def transliterate_then_strip_ascii(s: str) -> str:
    s = unicodedata.normalize("NFKD", s)
    s = s.encode("ascii", "ignore").decode("ascii")
    out = []
    for ch in s:
        o = ord(ch)
        if ch in ("\t", "\n", "\r") or (0x20 <= o <= 0x7E):
            out.append(ch)
    return "".join(out)


def normalize_crlf(s: str) -> str:
    s = s.replace("\r\n", "\n").replace("\r", "\n")
    s = s.replace("\n", "\r\n")
    if not s.endswith("\r\n"):
        s += "\r\n"
    return s


def bracket_to_angle(addr: str) -> str:
    m = re.match(r"^(.*?)\s*\[(.+?)\]\s*$", addr.strip())
    if m:
        name = m.group(1).strip()
        email = m.group(2).strip()
        if name:
            return f"{name} <{email}>"
        return f"<{email}>"
    return addr.strip()


def tool_txt_to_email(filename: str, content: str, outdir: str, dry_run: bool) -> Dict[str, Any]:
    lines = content.splitlines()
    scan = lines[:200]
    starts = ("From:", "To:", "Subject:", "Date:", "Message-ID:")
    email_detected = any(l.startswith(starts) for l in scan)

    headers = {"to": None, "from": None, "subject": None, "date": None}
    date_raw = None
    for l in scan:
        if l.startswith("From:"):
            headers["from"] = bracket_to_angle(l.split(":", 1)[1].strip())
        elif l.startswith("To:"):
            headers["to"] = bracket_to_angle(l.split(":", 1)[1].strip())
        elif l.startswith("Subject:"):
            headers["subject"] = l.split(":", 1)[1].strip()
        elif l.startswith("Date:"):
            date_raw = l.split(":", 1)[1].strip()

    if date_raw:
        try:
            headers["date"] = parsedate_to_datetime(date_raw).isoformat()
        except Exception:
            headers["date"] = date_raw

    eml_filename = os.path.splitext(os.path.basename(filename))[0] + ".eml"
    eml_content = None
    eml_path = None

    if email_detected:
        ascii_content = transliterate_then_strip_ascii(content)
        eml_content = normalize_crlf(ascii_content)
        if not dry_run:
            eml_path = os.path.join(outdir, eml_filename)
            with open(eml_path, "w", encoding="ascii", errors="ignore") as f:
                f.write(eml_content)

    return {
        "email_detected": email_detected,
        "headers": headers,
        "eml_filename": eml_filename if email_detected else None,
        "eml_content": eml_content,
        "eml_path": eml_path
    }


# ---- scopeforge: helpers for to_scopeforgeHeaders ----

_RE_EMAIL_ME = re.compile(r"<[^<>@\s]+@me\.com>", re.IGNORECASE)

# RFC 2822-ish, e.g. "Mon, 12 Jan 2026 08:46:20 GMT" / "... -0700"
_RE_RFC2822_DATE = re.compile(
    r"(?P<dow>Mon|Tue|Wed|Thu|Fri|Sat|Sun),\s+"
    r"(?P<day>\d{1,2})\s+"
    r"(?P<mon>Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+"
    r"(?P<year>\d{4})\s+"
    r"(?P<h>\d{2}):(?P<m>\d{2}):(?P<s>\d{2})"
    r"(?:\.(?P<frac>\d+))?"
    r"(?:\s+(?P<tz>(?:[+-]\d{4})|GMT|UTC))"
)

# ISO-like, e.g. "2026-01-12 08:46:16.173843004 +0000 UTC"
_RE_ISO_LIKE = re.compile(
    r"(?P<Y>\d{4})-(?P<M>\d{2})-(?P<D>\d{2})\s+"
    r"(?P<h>\d{2}):(?P<m>\d{2}):(?P<s>\d{2})"
    r"(?:\.(?P<frac>\d+))?"
    r"\s+(?P<off>[+-]\d{4})"
    r"(?:\s+(?P<tok>UTC|GMT))?"
)

_RE_EPOCH_10_13 = re.compile(r"(?P<epoch>\b\d{10}\b|\b\d{13}\b)")

_MONTHS = {
    "Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5, "Jun": 6,
    "Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12,
}
_MONTHS_INV = {v: k for k, v in _MONTHS.items()}


def _offset_tz(off: str) -> timezone:
    # "+0000" or "-0700"
    sign = 1 if off[0] == "+" else -1
    hh = int(off[1:3])
    mm = int(off[3:5])
    return timezone(sign * timedelta(hours=hh, minutes=mm))


def _format_rfc2822_like(target_dt: datetime, m: re.Match) -> str:
    tz = m.group("tz")
    frac = m.group("frac")
    if tz in ("GMT", "UTC"):
        tzinfo = timezone.utc
    else:
        tzinfo = _offset_tz(tz)
    dt = target_dt.astimezone(tzinfo)
    mon = _MONTHS_INV[dt.month]
    dow = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][dt.weekday()]
    base = f"{dow}, {dt.day:02d} {mon} {dt.year:04d} {dt.hour:02d}:{dt.minute:02d}:{dt.second:02d}"
    if frac is not None:
        # preserve precision length
        n = len(frac)
        # dt has microsecond precision; extend with zeros if needed
        micro = dt.microsecond
        frac_full = f"{micro:06d}" + "0" * max(0, n - 6)
        base += "." + frac_full[:n]
    base += f" {tz}"
    return base


def _format_iso_like(target_dt: datetime, m: re.Match) -> str:
    off = m.group("off")
    tok = m.group("tok")  # may be None
    frac = m.group("frac")
    tzinfo = _offset_tz(off)
    dt = target_dt.astimezone(tzinfo)
    base = f"{dt.year:04d}-{dt.month:02d}-{dt.day:02d} {dt.hour:02d}:{dt.minute:02d}:{dt.second:02d}"
    if frac is not None:
        n = len(frac)
        micro = dt.microsecond
        frac_full = f"{micro:06d}" + "0" * max(0, n - 6)
        base += "." + frac_full[:n]
    base += f" {off}"
    if tok:
        base += f" {tok}"
    return base


def tool_to_scopeforgeHeaders(source_headers: str, target: str, from_id: str) -> str:
    """
    Streaming-ish per-line transformer:
      1) replace <...@me.com> with from_id
      2) retarget RFC2822-like and ISO-like datetime substrings to the same instant as target
      3) retarget 10/13-digit epoch tokens to target epoch seconds/millis
    Output: CRLF joined and trailing CRLF.
    """
    tgt_dt = parsedate_to_datetime(target)
    if tgt_dt.tzinfo is None:
        tgt_dt = tgt_dt.replace(tzinfo=timezone.utc)

    def repl_epoch(mm: re.Match) -> str:
        e = mm.group("epoch")
        if len(e) == 10:
            val = int(tgt_dt.timestamp())
            return f"{val:010d}"
        if len(e) == 13:
            val = int(round(tgt_dt.timestamp() * 1000))
            return f"{val:013d}"
        return e

    out_lines: List[str] = []
    for line in source_headers.splitlines():
        orig = line

        # (1) email replace
        line = _RE_EMAIL_ME.sub(from_id, line)

        # (2) datetime retarget
        def repl_rfc(m: re.Match) -> str:
            return _format_rfc2822_like(tgt_dt, m)

        def repl_iso(m: re.Match) -> str:
            return _format_iso_like(tgt_dt, m)

        line = _RE_RFC2822_DATE.sub(repl_rfc, line)
        line = _RE_ISO_LIKE.sub(repl_iso, line)

        # (3) epoch retarget
        line = _RE_EPOCH_10_13.sub(repl_epoch, line)

        out_lines.append(line)

    return normalize_crlf("\n".join(out_lines))


def tool_from_scopeforgeHeaders(
    *,
    domain: str = "me.com",
    boundary_n: int = 42,
    client_build: str = "2546Build28",
    server_build_base: str = "2502B13",
    server_build_rev: Optional[str] = None,
    message_id_uuid: Optional[str] = None,
    boundary_uuid: Optional[str] = None,
    line_ending: str = "\r\n",
) -> Dict[str, Any]:
    """
    Generate a small iCloud-ish header block (Content-Type, X-Mailer, Message-id, MIME-Version)
    consistent with TOOL_from_sourceforge_headers.json.
    Returns {"headers": <string>, "message_id": <string>}.
    """
    def rand_hex(n: int) -> str:
        return "".join(random.choice("0123456789abcdef") for _ in range(n))

    if server_build_rev is None:
        server_build_rev = rand_hex(12)
    if message_id_uuid is None:
        message_id_uuid = str(_uuid.uuid4())
    if boundary_uuid is None:
        boundary_uuid = rand_hex(32)

    boundary = f"Apple-Webmail-{boundary_n}--{boundary_uuid}"
    content_type = f"multipart/alternative; boundary={boundary}"
    server_build = f"{server_build_base}.{server_build_rev}"
    x_mailer = f"iCloud MailClient{client_build} MailServer{server_build}"
    message_id = f"<{message_id_uuid}@{domain}>"

    # Ordering declared: Content-Type, X-Mailer, Message-id, MIME-Version
    headers = [
        f"Content-Type: {content_type}",
        f"X-Mailer: {x_mailer}",
        f"Message-id: {message_id}",
        "MIME-Version: 1.0",
    ]
    hdr = line_ending.join(headers) + line_ending
    # Ensure ASCII
    hdr = transliterate_then_strip_ascii(hdr)
    return {"headers": hdr, "message_id": message_id}


# -----------------------------
# Tool: arXiv API query (Atom)
# -----------------------------


def tool_arxiv_query(
    *,
    search_query: str,
    start: int = 0,
    max_results: int = 10,
    sortBy: str = "relevance",
    sortOrder: str = "descending",
    id_list: Optional[List[str]] = None,
    base_url: str = "https://export.arxiv.org/api/query",
    user_agent: str = "AtlasForgedFlowRunner/1.3.2 (mailto:arxiv-api@googlegroups.com)",
    timeout_s: int = 20,
) -> Dict[str, Any]:
    """
    Query arXiv's Atom API and return a structured dict.

    Args:
      search_query: e.g. "all:electron" or 'cat:cs.AI AND ti:"diffusion"'
      start/max_results: paging
      sortBy: relevance|lastUpdatedDate|submittedDate
      sortOrder: ascending|descending
      id_list: list of specific arXiv IDs (optional; overrides search_query if provided)
    Returns:
      {
        "query_url": "...",
        "feed": { "title": "...", "updated": "...", "totalResults": 123, ... },
        "entries": [
          {
            "id": "YYMM.NNNNN",
            "title": "...",
            "summary": "...",
            "published": "...",
            "updated": "...",
            "authors": ["..."],
            "primary_category": "cs.AI",
            "categories": ["cs.AI","cs.LG"],
            "links": {"abs": "...", "pdf": "..."},
          }, ...
        ]
      }
    """
    import urllib.parse
    import urllib.request

    params = {
        "start": int(start),
        "max_results": int(max_results),
        "sortBy": sortBy,
        "sortOrder": sortOrder,
    }
    if id_list:
        params["id_list"] = ",".join(id_list)
    else:
        params["search_query"] = search_query

    query_url = base_url + "?" + urllib.parse.urlencode(params)

    req = urllib.request.Request(
        query_url,
        headers={
            "User-Agent": user_agent,
            "Accept": "application/atom+xml, application/xml;q=0.9, */*;q=0.8",
        },
        method="GET",
    )

    with urllib.request.urlopen(req, timeout=timeout_s) as resp:
        xml_bytes = resp.read()

    # First try feedparser (nice namespace handling). If not installed, fall back to stdlib XML.
    try:
        import feedparser  # type: ignore

        # Ensure arXiv namespaces are visible (pattern taken from the official example).
        feedparser._FeedParserMixin.namespaces["http://a9.com/-/spec/opensearch/1.1/"] = "opensearch"
        feedparser._FeedParserMixin.namespaces["http://arxiv.org/schemas/atom"] = "arxiv"

        parsed = feedparser.parse(xml_bytes)

        feed_meta = {
            "title": getattr(parsed.feed, "title", None),
            "updated": getattr(parsed.feed, "updated", None),
            "totalResults": getattr(parsed.feed, "opensearch_totalresults", None),
            "startIndex": getattr(parsed.feed, "opensearch_startindex", None),
            "itemsPerPage": getattr(parsed.feed, "opensearch_itemsperpage", None),
        }

        entries: List[Dict[str, Any]] = []
        for e in getattr(parsed, "entries", []) or []:
            arxiv_id = None
            try:
                arxiv_id = str(e.id).split("/abs/")[-1]
            except Exception:
                arxiv_id = getattr(e, "id", None)

            authors = []
            if hasattr(e, "authors"):
                try:
                    authors = [a.name for a in e.authors]
                except Exception:
                    pass
            if not authors and hasattr(e, "author"):
                authors = [e.author]

            links = {"abs": None, "pdf": None}
            for l in getattr(e, "links", []) or []:
                if getattr(l, "rel", None) == "alternate":
                    links["abs"] = getattr(l, "href", None)
                if getattr(l, "title", None) == "pdf":
                    links["pdf"] = getattr(l, "href", None)

            primary_cat = None
            cats = []
            if hasattr(e, "tags") and e.tags:
                try:
                    cats = [t["term"] for t in e.tags if "term" in t]
                    primary_cat = cats[0] if cats else None
                except Exception:
                    pass

            entries.append(
                {
                    "id": arxiv_id,
                    "title": getattr(e, "title", None),
                    "summary": getattr(e, "summary", None),
                    "published": getattr(e, "published", None),
                    "updated": getattr(e, "updated", None),
                    "authors": authors,
                    "primary_category": getattr(e, "arxiv_primary_category", None) or primary_cat,
                    "categories": cats,
                    "links": links,
                    "doi": getattr(e, "arxiv_doi", None) if hasattr(e, "arxiv_doi") else None,
                    "journal_ref": getattr(e, "arxiv_journal_ref", None) if hasattr(e, "arxiv_journal_ref") else None,
                    "comment": getattr(e, "arxiv_comment", None) if hasattr(e, "arxiv_comment") else None,
                }
            )

        return {"query_url": query_url, "feed": feed_meta, "entries": entries}

    except Exception:
        # ---- stdlib XML fallback ----
        import xml.etree.ElementTree as ET

        # arXiv Atom uses these namespaces
        ns = {
            "atom": "http://www.w3.org/2005/Atom",
            "opensearch": "http://a9.com/-/spec/opensearch/1.1/",
            "arxiv": "http://arxiv.org/schemas/atom",
        }

        root = ET.fromstring(xml_bytes)

        def _txt(elem, path):
            x = elem.find(path, ns)
            return x.text.strip() if x is not None and x.text else None

        feed_meta = {
            "title": _txt(root, "atom:title"),
            "updated": _txt(root, "atom:updated"),
            "totalResults": _txt(root, "opensearch:totalResults"),
            "startIndex": _txt(root, "opensearch:startIndex"),
            "itemsPerPage": _txt(root, "opensearch:itemsPerPage"),
        }

        entries: List[Dict[str, Any]] = []
        for e in root.findall("atom:entry", ns):
            arxiv_id = _txt(e, "atom:id")
            if arxiv_id and "/abs/" in arxiv_id:
                arxiv_id = arxiv_id.split("/abs/")[-1]

            title = _txt(e, "atom:title")
            summary = _txt(e, "atom:summary")
            published = _txt(e, "atom:published")
            updated = _txt(e, "atom:updated")

            authors = []
            for a in e.findall("atom:author", ns):
                name = _txt(a, "atom:name")
                if name:
                    authors.append(name)

            links = {"abs": None, "pdf": None}
            for l in e.findall("atom:link", ns):
                rel = l.attrib.get("rel")
                href = l.attrib.get("href")
                title_attr = l.attrib.get("title")
                if rel == "alternate":
                    links["abs"] = href
                if title_attr == "pdf":
                    links["pdf"] = href

            cats = [c.attrib.get("term") for c in e.findall("atom:category", ns) if c.attrib.get("term")]
            primary = None
            pc = e.find("arxiv:primary_category", ns)
            if pc is not None:
                primary = pc.attrib.get("term")
            if not primary and cats:
                primary = cats[0]

            entries.append(
                {
                    "id": arxiv_id,
                    "title": title,
                    "summary": summary,
                    "published": published,
                    "updated": updated,
                    "authors": authors,
                    "primary_category": primary,
                    "categories": cats,
                    "links": links,
                    "doi": _txt(e, "arxiv:doi"),
                    "journal_ref": _txt(e, "arxiv:journal_ref"),
                    "comment": _txt(e, "arxiv:comment"),
                }
            )

        return {"query_url": query_url, "feed": feed_meta, "entries": entries}

# -----------------------------
# Tool registry
# -----------------------------

class ToolRegistry:
    """
    Loads declared tools from automation["tools"] but only executes tools with
    registered Python implementations (adapters).
    """
    def __init__(self, declared_tools: Dict[str, Any]) -> None:
        self.declared_tools = declared_tools or {}
        self.impls = {
            "txt_to_email": self._call_txt_to_email,
            "to_scopeforgeHeaders": self._call_to_scopeforgeHeaders,
            "from_scopeforgeHeaders": self._call_from_scopeforgeHeaders,
            "arxiv_query": self._call_arxiv_query,
            "interop_title_protocol": self._call_interop_title_protocol,
        }

    def has(self, name: str) -> bool:
        return name in self.impls

    def get_declared_spec(self, name: str) -> Any:
        return self.declared_tools.get(name)

    def call(self, name: str, args: Dict[str, Any], *, outdir: str, dry_run: bool) -> Any:
        if name not in self.impls:
            known = ", ".join(sorted(self.impls.keys())) or "(none)"
            raise ValueError(
                f"Tool '{name}' has no implementation in this runner. "
                f"Implemented tools: {known}."
            )
        return self.impls[name](args, outdir=outdir, dry_run=dry_run)

    @staticmethod
    def _call_txt_to_email(args: Dict[str, Any], *, outdir: str, dry_run: bool) -> Any:
        return tool_txt_to_email(args["filename"], args["content"], outdir, dry_run=dry_run)

    @staticmethod
    def _call_to_scopeforgeHeaders(args: Dict[str, Any], *, outdir: str, dry_run: bool) -> Any:
        # args: {source_headers, target, from_id}
        return tool_to_scopeforgeHeaders(
            source_headers=args["source_headers"],
            target=args["target"],
            from_id=args["from_id"],
        )

    @staticmethod
    def _call_from_scopeforgeHeaders(args: Dict[str, Any], *, outdir: str, dry_run: bool) -> Any:
        # args are optional overrides
        return tool_from_scopeforgeHeaders(**args)

    @staticmethod
    def _call_arxiv_query(args: Dict[str, Any], *, outdir: str, dry_run: bool) -> Any:
        """
        Args map (all optional except one of search_query/id_list):
          - search_query: str (e.g. "all:electron")
          - id_list: list[str]
          - start: int
          - max_results: int
          - sortBy: str
          - sortOrder: str
        """
        search_query = args.get("search_query") or ""
        id_list = args.get("id_list")
        if not search_query and not id_list:
            raise ValueError("arxiv_query requires 'search_query' or 'id_list'")

        return tool_arxiv_query(
            search_query=search_query,
            id_list=id_list,
            start=int(args.get("start", 0)),
            max_results=int(args.get("max_results", 10)),
            sortBy=str(args.get("sortBy", "relevance")),
            sortOrder=str(args.get("sortOrder", "descending")),
        )

    @staticmethod
    def _call_interop_title_protocol(args: Dict[str, Any], *, outdir: str, dry_run: bool) -> Any:
        return tool_interop_title_protocol(args, outdir=outdir, dry_run=dry_run)


# -----------------------------
# API connector hygiene: require docs + terms URLs
# -----------------------------

API_TOOL_REQUIREMENTS: Dict[str, Dict[str, str]] = {
    # Any tool listed here must have docs_url + terms_url provided in canon.content.tools[tool_name].
    "arxiv_query": {
        "docs_url": "https://info.arxiv.org/help/api/user-manual.html",
        "terms_url": "https://info.arxiv.org/help/api/tou.html",
    },
}

def enforce_api_docs_and_terms(canon: Dict[str, Any]) -> None:
    """
    Ensure that for API-connected tools we record:
      - docs_url: API documentation
      - terms_url: API terms of use / ToS

    Rationale: APIs change; we want durable references in every connector workflow.
    """
    content = canon.get("content") or {}
    tools_meta = (content.get("tools") or {}) if isinstance(content, dict) else {}

    # Determine which tools are referenced by tool_call steps
    referenced: set[str] = set()
    try:
        steps = (canon.get("workflow") or {}).get("steps") or {}
        if isinstance(steps, dict):
            for _, step in steps.items():
                if isinstance(step, dict) and step.get("type") == "tool_call":
                    tname = step.get("tool")
                    if isinstance(tname, str):
                        referenced.add(tname)
    except Exception:
        pass

    for tool_name, defaults in API_TOOL_REQUIREMENTS.items():
        if tool_name not in referenced and tool_name not in tools_meta:
            continue

        meta = tools_meta.get(tool_name) if isinstance(tools_meta, dict) else None
        docs_url = meta.get("docs_url") if isinstance(meta, dict) else None
        terms_url = meta.get("terms_url") if isinstance(meta, dict) else None

        missing = []
        if not docs_url:
            missing.append("docs_url")
        if not terms_url:
            missing.append("terms_url")

        if missing:
            raise ValueError(
                "API tool metadata missing for '%s': %s. "
                "Please include these under canon.content.tools['%s'] in your workflow JSON. "
                "Defaults for this tool are: docs_url=%s ; terms_url=%s"
                % (
                    tool_name,
                    ", ".join(missing),
                    tool_name,
                    defaults.get("docs_url"),
                    defaults.get("terms_url"),
                )
            )

# -----------------------------
# Embedded workflow.schema.json (merged to reduce external dependencies)
# -----------------------------

EMBEDDED_WORKFLOW_SCHEMA = {
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "Atlas Forged Flow Automation (Canon v1.3.x)",
  "type": "object",
  "additionalProperties": False,
  "required": [
    "name",
    "version",
    "workflow",
    "content"
  ],
  "properties": {
    "name": {
      "type": "string",
      "minLength": 1
    },
    "version": {
      "type": "string",
      "minLength": 1
    },
    "changelog": {
      "type": "object",
      "description": "Mapping of integer step/update ids to summary strings. Keys are numeric strings.",
      "patternProperties": {
        "^[0-9]+$": {
          "type": "string"
        }
      },
      "additionalProperties": False
    },
    "notes": {
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "workflow": {
      "type": "object",
      "additionalProperties": False,
      "required": [
        "context",
        "steps"
      ],
      "properties": {
        "context": {
          "type": "object",
          "description": "Runtime variable namespace (mutable). Arrays live here as normal variables.",
          "additionalProperties": True
        },
        "steps": {
          "type": "object",
          "description": "Ordered steps keyed by step number as a numeric string.",
          "patternProperties": {
            "^[0-9]+$": {
              "oneOf": [
                {
                  "type": "object",
                  "required": [
                    "id",
                    "type"
                  ],
                  "properties": {
                    "id": {
                      "type": "string"
                    },
                    "type": {
                      "type": "string"
                    }
                  },
                  "additionalProperties": True
                }
              ]
            }
          },
          "additionalProperties": False
        }
      }
    },
    "content": {
      "type": "object",
      "additionalProperties": False,
      "required": [
        "input",
        "files",
        "tools"
      ],
      "properties": {
        "input": {
          "type": "string"
        },
        "files": {
          "type": "array",
          "items": {
            "type": "object",
            "additionalProperties": True,
            "required": [
              "filename",
              "path"
            ],
            "properties": {
              "filename": {
                "type": "string"
              },
              "path": {
                "type": "string"
              },
              "type": {
                "type": "string"
              }
            }
          }
        },
        "tools": {
          "type": "object",
          "additionalProperties": {
            "type": "object"
          }
        }
      }
    }
  }
}

# -----------------------------
# Schema validation
# -----------------------------


def validate_with_jsonschema(instance: Dict[str, Any], schema_obj: Any) -> Tuple[Optional[str], Optional[str]]:
    """
    Returns (fallback_reason, error_string). If ok => (None, None).
    fallback_reason == 'jsonschema_not_available' when the package isn't importable.
    """
    try:
        import jsonschema  # type: ignore
    except Exception:
        return ("jsonschema_not_available", None)

    schema = schema_obj
    try:
        jsonschema.validate(instance=instance, schema=schema)
        return (None, None)
    except Exception as e:
        return (None, str(e))



def minimal_validate(instance: Dict[str, Any]) -> None:
    """
    Minimal structural validation used only as a fallback.
    - Legacy shape: instance["workflow"] is a list of step objects with id/type.
    - Canon shape: instance["workflow"] is an object with "steps".
    """
    for k in ("name", "version", "workflow"):
        if k not in instance:
            raise ValueError(f"Minimal validation failed: missing top-level '{k}'")

    wf = instance["workflow"]

    # Legacy: workflow is a list
    if isinstance(wf, list):
        for i, step in enumerate(wf):
            if not isinstance(step, dict):
                raise ValueError(f"Minimal validation failed: workflow[{i}] must be an object")
            if "type" not in step or "id" not in step:
                raise ValueError(f"Minimal validation failed: workflow[{i}] missing 'id' or 'type'")
        return

    # Canon: workflow is an object with steps
    if isinstance(wf, dict) and "steps" in wf:
        return

    raise ValueError("Minimal validation failed: workflow must be a list (legacy) or an object with steps (canon)")


# -----------------------------
# Debugger / breakpoint support
# -----------------------------


@dataclass
class DebugState:
    watch: List[str]
    break_on_debug: bool = False  # if True, "debug" behaves like "break"



def _pretty(x: Any, max_chars: int = 4000) -> str:
    try:
        s = json.dumps(x, ensure_ascii=False, indent=2)
    except Exception:
        s = str(x)
    if len(s) > max_chars:
        return s[: max_chars - 3] + "..."
    return s


def _print_watch(ctx: Dict[str, Any], scope: Dict[str, Any], watch: List[str]) -> None:
    if not watch:
        print("(watchlist empty)")
        return
    for expr in watch:
        try:
            val = resolve_expr(expr, ctx, scope) if is_expr(expr) else ctx.get(expr)
            print(f"- {expr}: {_preview(val)}")
        except Exception as e:
            print(f"- {expr}: <error: {e}>")


def _dump_all(ctx: Dict[str, Any], scope: Dict[str, Any]) -> None:
    blob = {
        "scope": scope,
        "ctx_top_keys": sorted([k for k in ctx.keys() if not k.startswith("_")]),
        "ctx": ctx,
    }
    print(_pretty(blob))


def _preview(x: Any, max_len: int = 200) -> str:
    try:
        s = json.dumps(x, ensure_ascii=False)
    except Exception:
        s = str(x)
    if len(s) > max_len:
        s = s[: max_len - 3] + "..."
    return s


def _bp_help() -> None:
    print(
        "\nCommands:\n"
        "  help                         Show this help\n"
        "  watch                         Show watchlist\n"
        "  watch add <expr>              Add watch expression (e.g. $txtFilesSorted, $file.filename)\n"
        "  watch del <expr>              Remove watch expression\n"
        "  print <expr>                  Pretty-print an expression\n"
        "  dump                          Dump full ctx+scope (can be large)\n"
        "  set <expr> <json>             Set a ctx path (e.g. set $files [...])\n"
        "  load_files <path.json>        Load ctx['files'] from a JSON file on disk\n"
        "  continue | c                  Resume execution\n"
        "  abort | q                     Abort run (exit non-zero)\n"
    )


def _breakpoint_repl(
    *,
    ctx: Dict[str, Any],
    scope: Dict[str, Any],
    dbg: DebugState,
    log: AuditLogger,
    step_id: str,
    reason: str,
) -> None:
    print("\n" + "=" * 80)
    print(f"BREAKPOINT: step={step_id} reason={reason}")
    print("=" * 80)
    print("Watchlist:")
    _print_watch(ctx, scope, dbg.watch)
    print()

    log.emit("breakpoint_enter", step_id=step_id, reason=reason, watch=dbg.watch)

    while True:
        try:
            line = input("(break) ").strip()
        except EOFError:
            line = "continue"
        if not line:
            continue

        if line in ("help", "?"):
            _bp_help()
            continue

        if line in ("continue", "c"):
            log.emit("breakpoint_continue", step_id=step_id)
            print("Continuing...\n")
            return

        if line in ("abort", "q", "quit", "exit"):
            log.emit("breakpoint_abort", level="error", step_id=step_id)
            raise SystemExit(2)

        if line == "watch":
            _print_watch(ctx, scope, dbg.watch)
            continue

        if line.startswith("watch add "):
            expr = line[len("watch add "):].strip()
            if not expr.startswith("$"):
                print("Watch expressions should start with '$' (example: $txtFilesSorted)")
                continue
            if expr not in dbg.watch:
                dbg.watch.append(expr)
            print(f"Added watch: {expr}")
            continue

        if line.startswith("watch del "):
            expr = line[len("watch del "):].strip()
            if expr in dbg.watch:
                dbg.watch.remove(expr)
                print(f"Removed watch: {expr}")
            else:
                print("Not in watchlist.")
            continue

        if line.startswith("print "):
            expr = line[len("print "):].strip()
            if not expr.startswith("$"):
                print("print expects an expression starting with '$'")
                continue
            try:
                val = resolve_expr(expr, ctx, scope)
                print(_pretty(val))
            except Exception as e:
                print(f"Error: {e}")
            continue

        if line == "dump":
            _dump_all(ctx, scope)
            continue

        if line.startswith("set "):
            # set $path <json>
            rest = line[len("set "):].strip()
            m = re.match(r"(\$\S+)\s+(.+)$", rest)
            if not m:
                print("Usage: set $path <json>")
                continue
            path_expr = m.group(1)
            json_text = m.group(2)
            try:
                new_val = json.loads(json_text)
            except Exception as e:
                print(f"Invalid JSON: {e}")
                continue
            try:
                parts = split_path(path_expr)
                set_in(ctx, parts, new_val)
                print(f"Set {path_expr} OK.")
                # show updated watch quickly
                _print_watch(ctx, scope, dbg.watch)
            except Exception as e:
                print(f"Set failed: {e}")
            continue

        if line.startswith("load_files "):
            p = line[len("load_files "):].strip()
            try:
                with open(p, "r", encoding="utf-8") as f:
                    files = json.load(f)
                if not isinstance(files, list):
                    print("JSON must be a list of file objects.")
                    continue
                ctx["files"] = files
                print(f"Loaded {len(files)} files into $files.")
                _print_watch(ctx, scope, dbg.watch)
            except Exception as e:
                print(f"load_files failed: {e}")
            continue

        print("Unknown command. Type 'help'.")


# -----------------------------
# Step execution
# -----------------------------


def run_steps(
    steps: List[Dict[str, Any]],
    ctx: Dict[str, Any],
    scope: Dict[str, Any],
    *,
    outdir: str,
    dry_run: bool,
    log: AuditLogger,
    tools: ToolRegistry,
    dbg: DebugState,
) -> None:
    for step in steps:
        stype = step["type"]
        sid = step.get("id", "(no-id)")

        t0 = time.time()
        log.emit("step_start", step_id=sid, step_type=stype)

        try:
            if stype == "filter":
                src = resolve_value(step["from"], ctx, scope)
                if not isinstance(src, list):
                    raise ValueError(f"filter.from must resolve to a list ({sid})")
                var = step["as"]
                out = []
                for item in src:
                    local = dict(scope)
                    local[var] = item
                    if eval_pred(step["where"], ctx, local):
                        out.append(item)
                ctx[step["to"]] = out
                log.emit("filter_result", step_id=sid, count=len(out), to=step["to"])

            elif stype == "map":
                src = resolve_value(step["from"], ctx, scope)
                if not isinstance(src, list):
                    raise ValueError(f"map.from must resolve to a list ({sid})")
                var = step["as"]
                out = []
                for item in src:
                    local = dict(scope)
                    local[var] = item
                    out.append(resolve_value(step["mapTo"], ctx, local))
                ctx[step["to"]] = out
                log.emit("map_result", step_id=sid, count=len(out), to=step["to"])

            elif stype == "sort":
                src = resolve_value(step["from"], ctx, scope)
                if not isinstance(src, list):
                    raise ValueError(f"sort.from must resolve to a list ({sid})")
                order = step.get("order", "asc")

                def k(item: Any) -> Any:
                    local = dict(scope)
                    local["item"] = item
                    val = resolve_value(step["by"], ctx, local)
                    return (val is None, str(val) if val is not None else "")

                sorted_list = sorted(src, key=k, reverse=(order == "desc"))
                ctx[step["to"]] = sorted_list
                log.emit("sort_result", step_id=sid, count=len(sorted_list), to=step["to"], order=order)

            elif stype == "foreach":
                src = resolve_value(step["over"], ctx, scope)
                if not isinstance(src, list):
                    raise ValueError(f"foreach.over must resolve to a list ({sid})")
                var = step["as"]
                log.emit("foreach_start", step_id=sid, iterations=len(src), var=var)
                for idx, item in enumerate(src):
                    local = dict(scope)
                    local[var] = item
                    log.emit("foreach_iter", step_id=sid, idx=idx, var=var, item_preview=_preview(item))
                    run_steps(step["do"], ctx, local, outdir=outdir, dry_run=dry_run, log=log, tools=tools, dbg=dbg)
                log.emit("foreach_end", step_id=sid)

            elif stype == "read_file":
                path_val = resolve_value(step["path"], ctx, scope)
                enc = step.get("encoding", "utf-8")
                errs = step.get("errors", "replace")
                with open(path_val, "r", encoding=enc, errors=errs) as f:
                    data = f.read()
                ctx[step["save_as"]] = data
                log.emit("read_file", step_id=sid, path=path_val, bytes=len(data.encode(enc, errors="ignore")), save_as=step["save_as"])

            elif stype == "tool_call":
                tool_name = step["tool"]
                args = resolve_value(step["args"], ctx, scope)
                spec = tools.get_declared_spec(tool_name)
                log.emit("tool_call_start", step_id=sid, tool=tool_name, declared_tool_present=spec is not None)
                res = tools.call(tool_name, args, outdir=outdir, dry_run=dry_run)
                ctx[step["save_as"]] = res
                log.emit(
                    "tool_call_end",
                    step_id=sid,
                    tool=tool_name,
                    save_as=step["save_as"],
                    email_detected=res.get("email_detected") if isinstance(res, dict) else None,
                    wrote_file=(res.get("eml_path") is not None) if isinstance(res, dict) else None,
                )

            elif stype == "append":
                arr = resolve_target_list(step["target"], ctx, scope)
                val = resolve_value(step["value"], ctx, scope)
                arr.append(val)
                log.emit("append", step_id=sid, target=step["target"], appended_preview=_preview(val), new_length=len(arr))

            elif stype == "condition":
                ok = eval_pred(step["if"], ctx, scope)
                log.emit("condition_eval", step_id=sid, result=ok)
                run_steps(step["then"] if ok else step["else"], ctx, scope, outdir=outdir, dry_run=dry_run, log=log, tools=tools, dbg=dbg)

            elif stype == "debug":
                # Non-interactive by default: show watchlist/dump then continue.
                message = step.get("message") or step.get("note") or ""
                print("\n" + "-" * 80)
                print(f"DEBUG: step={sid} {message}".strip())
                print("-" * 80)
                if step.get("dump_all", False):
                    _dump_all(ctx, scope)
                else:
                    # if step provides its own watch list, temporarily show it
                    wl = step.get("watch") or dbg.watch
                    _print_watch(ctx, scope, wl)
                print("-" * 80 + "\n")
                log.emit("debug_snapshot", step_id=sid, message=message, dump_all=bool(step.get("dump_all", False)))
                if dbg.break_on_debug or step.get("break", False):
                    _breakpoint_repl(ctx=ctx, scope=scope, dbg=dbg, log=log, step_id=sid, reason="debug")

            elif stype == "break":
                reason = step.get("reason") or step.get("message") or "break"
                if step.get("watch"):
                    # merge step watch into global watch for convenience
                    for w in step["watch"]:
                        if w not in dbg.watch:
                            dbg.watch.append(w)
                _breakpoint_repl(ctx=ctx, scope=scope, dbg=dbg, log=log, step_id=sid, reason=reason)

            else:
                raise ValueError(f"Unknown step type: {stype} ({sid})")

            dt_ms = int((time.time() - t0) * 1000)
            log.emit("step_end", step_id=sid, step_type=stype, duration_ms=dt_ms)

        except SystemExit:
            raise
        except Exception as e:
            dt_ms = int((time.time() - t0) * 1000)
            log.emit("step_error", level="error", step_id=sid, step_type=stype, duration_ms=dt_ms, error=str(e))
            raise


# -----------------------------
# Main
# -----------------------------



def emit_canon_corpus(*, outdir: str, log: "AuditLogger") -> str:
    """Write the canon corpus markdown to outdir and return the path."""
    filename = f"the_Atlas_Canon_Corpus__v{RUNNER_VERSION}_{RUNNER_UPDATE_ID:04d}.md"
    path = os.path.join(outdir, filename)
    content = CANON_CORPUS_TEMPLATE.format(version=RUNNER_VERSION, update_id=RUNNER_UPDATE_ID)
    tmp = path + ".tmp"
    os.makedirs(outdir, exist_ok=True)
    with open(tmp, "w", encoding="utf-8") as f:
        f.write(content)
    os.replace(tmp, path)
    return path


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("automation_json", nargs="?", help="Path to automation JSON")
    ap.add_argument("--outdir", default="./out", help="Directory to write .eml outputs")
    ap.add_argument("--result", default="./result.json", help="Path to write final context snapshot")
    ap.add_argument("--schema", default=None, help="Path to workflow.schema.json (optional)")
    ap.add_argument("--schema-strict", action="store_true", help="Fail if JSON Schema validation fails")
    ap.add_argument("--log", default="./audit.jsonl", help="Write JSONL audit logs to this path (use empty string to disable)")
    ap.add_argument("--dry-run", action="store_true", help="Do not write output files (e.g., .eml). Still produces result.json and logs.")
    ap.add_argument("--print-canon", action="store_true", help="Print runner metadata JSON and exit")
    ap.add_argument("--no-canon-emit", action="store_true", help="Disable auto-emitting the canon corpus markdown on each run")
    ap.add_argument("--canon-outdir", default=None, help="Directory to write canon corpus markdown (defaults to --outdir)")

    ap.add_argument("--watch", default="", help="Comma-separated watch expressions (e.g. '$files,$txtFilesSorted,$file,$result')")
    ap.add_argument("--break-on-debug", action="store_true", help="Make 'debug' steps interactive like 'break'.")

    args = ap.parse_args()

    if not args.print_canon and not args.automation_json:
        ap.error("automation_json is required unless --print-canon is set")

    if args.print_canon:
        print(json.dumps({"CANON": CANON, "CHANGELOG": CHANGELOG, "runtime": runner_metadata()}, indent=2, ensure_ascii=False))
        return

    log_path = args.log if args.log.strip() else None
    log = AuditLogger(log_path)

    # Per-run self-contained guard for pandas display truncation.
    _pandas_display_fix = ensure_pandas_display_fix(log)

    try:
        if not args.dry_run:
            os.makedirs(args.outdir, exist_ok=True)

        with open(args.automation_json, "r", encoding="utf-8") as f:
            automation = json.load(f)

        # Schema validation (soft by default)
        # - If --schema is provided, load that file.
        # - Otherwise, use the embedded schema shipped inside this runner (reduces external deps).
        schema_obj = None
        schema_source = None
        if args.schema:
            schema_source = args.schema
            with open(args.schema, "r", encoding="utf-8") as f:
                schema_obj = json.load(f)
        else:
            schema_source = "embedded"
            schema_obj = EMBEDDED_WORKFLOW_SCHEMA

        # Enforce API tool hygiene (docs + terms URLs)
        enforce_api_docs_and_terms(automation)

        log.emit(
            "schema_validate_start",
            schema_source=schema_source,
            **runner_metadata(),
            schema_strict=args.schema_strict,
        )
        fallback_reason, error_str = validate_with_jsonschema(automation, schema_obj)
        if fallback_reason == "jsonschema_not_available":
            log.emit("schema_validate_error", level="error", schema_source=schema_source, error="jsonschema_not_available", **runner_metadata())
            raise ValueError("jsonschema is required for canon enforcement. Install with: python -m pip install -U \"jsonschema[format]\"")
        if error_str is not None:
            log.emit("schema_validate_error", level="error", schema_source=schema_source, error=error_str, **runner_metadata())
            raise ValueError(f"Schema validation failed: {error_str}")
        log.emit("schema_validate_ok", schema_source=schema_source, mode="jsonschema")

        # Context begins as normalized automation (mutable runtime ctx)
        ctx, workflow = normalize_automation(automation)
        ctx["_runner"] = runner_metadata()

        # Ensure arrays container exists if referenced
        ctx.setdefault("arrays", {})
        ctx["arrays"].setdefault("headers", [])
        ctx["arrays"].setdefault("emails", [])
        ctx.setdefault("_debug", {})

        declared_tools = ctx.get("tools", {})
        if not isinstance(declared_tools, dict):
            declared_tools = {}
        tools = ToolRegistry(declared_tools)
        watch = [w.strip() for w in args.watch.split(",") if w.strip()]
        dbg = DebugState(watch=watch, break_on_debug=args.break_on_debug)
        ctx["_debug"]["watch"] = dbg.watch

        log.emit(
            "run_start",
            **runner_metadata(),
            automation=os.path.basename(args.automation_json),
            outdir=args.outdir,
            result=args.result,
            dry_run=args.dry_run,
            declared_tools=list(declared_tools.keys()),
            implemented_tools=sorted(list(tools.impls.keys())),
            watch=dbg.watch,
        )

        run_steps(workflow, ctx, scope={}, outdir=args.outdir, dry_run=args.dry_run, log=log, tools=tools, dbg=dbg)

        with open(args.result, "w", encoding="utf-8") as f:
            json.dump(ctx, f, indent=2, ensure_ascii=False)
        # Canon corpus auto-emit (default on)
        if not args.no_canon_emit:
            canon_dir = args.canon_outdir or args.outdir or os.getcwd()
            log.emit("canon_emit_start", canon_outdir=canon_dir, **runner_metadata())
            try:
                canon_path = emit_canon_corpus(outdir=canon_dir, log=log)
                log.emit("canon_emit_ok", canon_path=canon_path, canon_outdir=canon_dir, **runner_metadata())
            except Exception as e:
                log.emit("canon_emit_error", level="error", canon_outdir=canon_dir, error=str(e), **runner_metadata())
                if args.schema_strict:
                    raise

        log.emit("run_end", result=args.result)

        print("OK")
        print(f"Wrote result: {args.result}")
        if args.dry_run:
            print("Dry-run enabled: no output files were written.")
        else:
            print(f"Wrote outputs to: {args.outdir}")
        if log_path:
            print(f"Wrote audit log: {log_path}")

    finally:
        log.close()


if __name__ == "__main__":
    main()



# =====================================================================
# Atlas Nexus Canon Extension (ScopeForge Integration)
# Canon Artifact: the_Atlas_Forged_Flow_Runner_v1.3.2_0058.py
# Canon Release Date: 2026-01-18
# Canon Authority: Atlas Nexus (P4NTH30N ScopeForge Registry)
# ---------------------------------------------------------------------
# This Canon update integrates:
#  - GitHub REST API v1.0.0 Tool Boundary
#  - ScopeForge Canon Registry auto-emission
#  - P4NTH30N Canon Endpoint Declaration
#  - Audit Propagation via AuditLogger
# =====================================================================

import json, datetime, requests
from pathlib import Path

# Canon constants
CANON_VERSION = "1.3.2"
CANON_UPDATE_ID = "0058"
CANON_SCOPEFORGE_PATH = Path("scopeforge/canon_registry.yaml")
CANON_AUDIT_PATH = Path("audit/github_rest_api_v1_audit.jsonl")

# ---------------------------------------------------------------------
# Canon Tool Boundary: GitHub REST API (v1.0.0)
# ---------------------------------------------------------------------
def github_rest_api_v1(args, context):
    base_url = "https://api.github.com"
    url = base_url + args["endpoint"]
    headers = args.get("headers", {}).copy()
    if "auth" in args:
        headers["Authorization"] = f"Bearer {args['auth']}"
    headers.setdefault("Accept", "application/vnd.github+json")

    try:
        response = requests.request(
            method=args["method"],
            url=url,
            headers=headers,
            params=args.get("params", {}),
            json=args.get("body"),
            timeout=30,
        )
        data = response.json() if response.content else None
        context["_last_github_status"] = response.status_code
        context["_last_github_response"] = data
    except Exception as e:
        context["_last_github_status"] = 500
        context["_last_github_response"] = {"error": str(e)}

    # Audit propagation using Canon audit path
    audit_event = {
        "timestamp": datetime.datetime.utcnow().isoformat() + "Z",
        "tool": "github_rest_api_v1",
        "version": "1.0.0",
        "method": args.get("method"),
        "endpoint": args.get("endpoint"),
        "status": context.get("_last_github_status", 0),
        "ok": context.get("_last_github_status", 0) == 200,
    }
    CANON_AUDIT_PATH.parent.mkdir(parents=True, exist_ok=True)
    with CANON_AUDIT_PATH.open("a", encoding="utf-8") as f:
        f.write(json.dumps(audit_event) + "\n")

    return context["_last_github_response"]

# Register in the runner's ToolRegistry if available
try:
    registry.register("github_rest_api_v1", github_rest_api_v1)
except Exception:
    try:
        TOOL_BOUNDARY_MAP["github_rest_api_v1"] = github_rest_api_v1
    except Exception:
        pass

# ---------------------------------------------------------------------
# Canon Endpoint Declaration for P4NTH30N
# ---------------------------------------------------------------------
CANON_ENDPOINTS = [
    {
        "id": "canon_github_repo_p4nth30n",
        "uri": "https://api.github.com/repos/dammitpogi/P4NTH30N",
        "access": "public_readonly",
        "scope": "repository",
        "owner": "dammitpogi",
        "canon_role": "primary_nexus_surface",
        "version": "1.0.0",
        "protocol": "github_rest_v3",
    }
]

# ---------------------------------------------------------------------
# ScopeForge Canon Registry (Auto-emitted if missing)
# ---------------------------------------------------------------------
SCOPEFORGE_CANON_REGISTRY = """
meta:
  id: scopeforge_canon_registry
  version: 1.0.0
  owner: dammitpogi
  governed_by: atlas_nexus
  origin_repo: https://github.com/dammitpogi/P4NTH30N
  description: >
    ScopeForge is the canonical registry for the Nexus platform — defining
    endpoints, schemas, and tools within the Atlas governance substrate.

canon_tools:
  - id: github_rest_api_v1
    version: 1.0.0
    canonical: true
    maintainer: Atlas Nexus
    schema: atlas.tool.github_rest_api_v1.schema.json
    emits:
      - audit/github_rest_api_v1_audit.jsonl

canon_endpoints:
  - id: canon_github_repo_p4nth30n
    uri: https://api.github.com/repos/dammitpogi/P4NTH30N
    access: public_readonly
    scope: repository
    owner: dammitpogi
    version: 1.0.0
    governed_by: atlas_nexus

canon_workflows:
  - id: github_repo_discovery_full
    version: 1.0.0
    steps:
      - type: tool_call
        tool: github_rest_api_v1
        args:
          method: GET
          endpoint: /repos/dammitpogi/P4NTH30N
      - type: debug
        watch:
          - _last_github_status
          - _last_github_response
"""

CANON_SCOPEFORGE_PATH.parent.mkdir(parents=True, exist_ok=True)
if not CANON_SCOPEFORGE_PATH.exists():
    CANON_SCOPEFORGE_PATH.write_text(SCOPEFORGE_CANON_REGISTRY.strip())
