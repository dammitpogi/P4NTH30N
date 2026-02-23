# Run MMLU-Pro via LM Evaluation Harness against OpenRouter (Install + Usage)

This guide installs EleutherAI’s **lm-evaluation-harness** and runs the **MMLU-Pro** benchmark using **OpenRouter** (OpenAI-style Chat Completions endpoint).

## References
- LM Evaluation Harness repo / docs: https://github.com/EleutherAI/lm-evaluation-harness
- MMLU-Pro tasks in LM-Eval: https://github.com/EleutherAI/lm-evaluation-harness/tree/main/lm_eval/tasks/mmlu_pro
- OpenRouter API overview: https://openrouter.ai/docs/api/reference/overview
- OpenRouter auth: https://openrouter.ai/docs/api/reference/authentication

---

## 0) Prerequisites
- OS: Linux/macOS (Windows works but adjust shell commands)
- Python: **3.10+**
- Git
- An OpenRouter API key

Verify:
```bash
python --version
git --version
```

---

## 1) Create a virtual environment
```bash
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
python -m pip install --upgrade pip
```

---

## 2) Install lm-evaluation-harness (with API extras)
Install from source (recommended for the newest task definitions):
```bash
git clone --depth 1 https://github.com/EleutherAI/lm-evaluation-harness
cd lm-evaluation-harness
pip install -e ".[api]"
```

Sanity check:
```bash
lm-eval --help
```

---

## 3) Configure OpenRouter credentials
LM-Eval’s OpenAI-compatible API wrappers use `OPENAI_API_KEY`. Set it to your OpenRouter key:

### macOS / Linux
```bash
export OPENAI_API_KEY="YOUR_OPENROUTER_API_KEY"
```

### Windows (PowerShell)
```powershell
setx OPENAI_API_KEY "YOUR_OPENROUTER_API_KEY"
```
Restart the terminal after `setx`.

Optional (recommended by OpenRouter): app identification headers
- `HTTP-Referer` (your site URL)
- `X-Title` (your app name)

Docs: https://openrouter.ai/docs/api/reference/overview

---

## 4) Run MMLU-Pro against an OpenRouter model

### Notes
- Use `local-chat-completions` with OpenRouter’s Chat Completions endpoint:
  - `https://openrouter.ai/api/v1/chat/completions`
- Start with `--limit` to avoid unexpected costs.
- You can run the full suite via `--tasks mmlu_pro` or a single subject (e.g., `mmlu_pro_math`).

### 4.1 Quick smoke test (cheap)
Runs only a small sample from one subject.
```bash
lm-eval run \
  --model local-chat-completions \
  --model_args model="anthropic/claude-3.5-sonnet",base_url="https://openrouter.ai/api/v1/chat/completions",num_concurrent=4,timeout=120 \
  --tasks mmlu_pro_math \
  --apply_chat_template \
  --limit 20 \
  --output_path results_mmlu_pro_smoke.json
```

### 4.2 Full MMLU-Pro (all subjects)
```bash
lm-eval run \
  --model local-chat-completions \
  --model_args model="anthropic/claude-3.5-sonnet",base_url="https://openrouter.ai/api/v1/chat/completions",num_concurrent=4,timeout=120 \
  --tasks mmlu_pro \
  --apply_chat_template \
  --output_path results_mmlu_pro_full.json
```

### 4.3 Run with OpenRouter optional headers
If you want to include OpenRouter’s optional headers, pass a JSON header dict.
```bash
lm-eval run \
  --model local-chat-completions \
  --model_args model="anthropic/claude-3.5-sonnet",base_url="https://openrouter.ai/api/v1/chat/completions",num_concurrent=4,timeout=120,header='{"HTTP-Referer":"https://your.site","X-Title":"lm-eval"}' \
  --tasks mmlu_pro \
  --apply_chat_template \
  --output_path results_mmlu_pro_full.json
```

---

## 5) Useful variations

### 5.1 Increase/decrease concurrency
- Safer start: `num_concurrent=2`
- Faster (if rate limits allow): `num_concurrent=8`

### 5.2 Run a specific subject
Examples:
```bash
--tasks mmlu_pro_biology
--tasks mmlu_pro_physics
--tasks mmlu_pro_history
```

List tasks:
```bash
lm-eval list
```

---

## 6) Troubleshooting

### "401 Unauthorized" / auth errors
- Confirm `OPENAI_API_KEY` is set in the same shell where you run `lm-eval`.
- Ensure the key is an OpenRouter key.

### Timeouts / flaky requests
- Increase `timeout` (e.g., 180).
- Reduce `num_concurrent`.

### Very high cost / slow runs
- Always run a `--limit` smoke test first.
- Run per-subject tasks instead of the whole suite.

---

## 7) Deliverables to return
- `results_mmlu_pro_smoke.json` (smoke test)
- `results_mmlu_pro_full.json` (full run, if executed)
- The exact command used (for reproducibility)
- Model name (OpenRouter model ID) and date/time run
