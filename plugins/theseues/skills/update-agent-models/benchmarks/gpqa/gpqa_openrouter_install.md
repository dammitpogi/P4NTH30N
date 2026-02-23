# Run GPQA (lm-evaluation-harness) against an OpenRouter-hosted model (OpenAI-compatible API)

## What this does / key limitation
- ✅ Works well for **GPQA “generative”** and **“cot_*”** task variants (they score by extracting the final answer).
- ⚠️ **Multiple-choice / loglikelihood** GPQA variants require **completion endpoints with logprobs**; **chat-completions** cannot run those in lm-eval.

---

## Prereqs
- Python 3.10+ and `git`
- An **OpenRouter API key**
- A Hugging Face account + token (GPQA dataset is **gated**)

---

## 1) Create a virtual environment
```bash
python -m venv .venv
source .venv/bin/activate  # Windows (PowerShell): .venv\Scripts\Activate.ps1
pip install -U pip
```

---

## 2) Install lm-evaluation-harness (lm-eval)
```bash
git clone --depth 1 https://github.com/EleutherAI/lm-evaluation-harness
cd lm-evaluation-harness
pip install -e .
pip install "lm_eval[api]"
```

---

## 3) Enable GPQA dataset access (Hugging Face gated dataset)
1) Accept the dataset terms on Hugging Face (GPQA is gated).
2) Log in locally:
```bash
pip install -U huggingface_hub
huggingface-cli login
```

---

## 4) Configure OpenRouter credentials
lm-eval’s OpenAI-compatible API model reads the key from `OPENAI_API_KEY`.

### macOS / Linux
```bash
export OPENAI_API_KEY="YOUR_OPENROUTER_KEY"
```

### Windows PowerShell
```powershell
$env:OPENAI_API_KEY="YOUR_OPENROUTER_KEY"
```

---

## 5) Choose model + endpoint
OpenRouter’s OpenAI-compatible chat endpoint is:
- `https://openrouter.ai/api/v1/chat/completions`

Set these shell vars for convenience:
```bash
export OR_BASE_URL="https://openrouter.ai/api/v1/chat/completions"
export OR_MODEL="openai/gpt-4o"  # example; replace with your OpenRouter model slug
```

Optional (recommended) OpenRouter headers:
- `HTTP-Referer` and `X-Title`

---

## 6) Validate + list tasks (sanity checks)
```bash
lm-eval ls tasks | grep -i gpqa
lm-eval validate --tasks gpqa_diamond_cot_zeroshot
```

---

## 7) Run GPQA against OpenRouter (recommended variants)

### A) Quick smoke test (10 examples)
```bash
lm-eval run \
  --model local-chat-completions \
  --model_args model="$OR_MODEL",base_url="$OR_BASE_URL" \
  --apply_chat_template \
  --tasks gpqa_diamond_cot_zeroshot \
  --limit 10 \
  --batch_size 1
```

### B) Full GPQA-Diamond (198 questions)
```bash
lm-eval run \
  --model local-chat-completions \
  --model_args model="$OR_MODEL",base_url="$OR_BASE_URL" \
  --apply_chat_template \
  --tasks gpqa_diamond_cot_zeroshot \
  --batch_size 1 \
  --output_path ./results/gpqa_diamond_openrouter.json
```

### C) Few-shot generative variant (example: 5-shot)
```bash
lm-eval run \
  --model local-chat-completions \
  --model_args model="$OR_MODEL",base_url="$OR_BASE_URL" \
  --apply_chat_template \
  --tasks gpqa_diamond_generative_n_shot \
  --num_fewshot 5 \
  --batch_size 1 \
  --output_path ./results/gpqa_diamond_generative_5shot.json
```

---

## 8) Add OpenRouter optional headers (if desired)
`local-chat-completions` supports a custom `header={...}` model arg.

```bash
lm-eval run \
  --model local-chat-completions \
  --model_args 'model='"$OR_MODEL"',base_url='"$OR_BASE_URL"',header={"HTTP-Referer":"https://your.app","X-Title":"gpqa-eval"}' \
  --apply_chat_template \
  --tasks gpqa_diamond_cot_zeroshot \
  --limit 10 \
  --batch_size 1
```

---

## Troubleshooting
### “Dataset is gated” / 401 / can’t download
- Ensure you accepted GPQA terms on Hugging Face and ran `huggingface-cli login`.

### “MCQ / loglikelihood not supported”
- Use `gpqa_*_cot_*` or `gpqa_*_generative_*` tasks when calling **chat-completions**. Chat endpoints don’t support loglikelihood/MCQ scoring in lm-eval.

### Rate limits / slow runs
- Keep `--batch_size 1` for most hosted APIs.
- Consider lowering concurrency unless you know the provider allows parallelism.

---

## Reference URLs (for the agent)
```text
lm-eval harness repo: https://github.com/EleutherAI/lm-evaluation-harness
OpenRouter API docs:  https://openrouter.ai/docs/api/reference/overview
GPQA HF dataset:      https://huggingface.co/datasets/Idavidrein/gpqa
```
