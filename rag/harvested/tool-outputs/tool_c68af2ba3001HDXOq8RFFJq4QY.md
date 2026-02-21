# Tool Output: tool_c68af2ba3001HDXOq8RFFJq4QY
**Date**: 2026-02-16 23:00:36 UTC
**Size**: 138,742 bytes

```

skills/update-agent-models\benchmark_manual_accepted.json.backup.1771246190333.json:
  478:             "https://huggingface.co/moonshotai/Kimi-K2.5",
  546:             "https://huggingface.co/LiquidAI/LFM2.5-1.2B-Instruct",

skills/update-agent-models\benchmark_manual_accepted.json:
  479:     "huggingface/deepseek-ai/DeepSeek-V3.2": {
  512:     "huggingface/MiniMaxAI/MiniMax-M2.1": {
  545:     "huggingface/moonshotai/Kimi-K2-Instruct-0905": {
  578:     "huggingface/moonshotai/Kimi-K2.5": {
  611:     "huggingface/Qwen/Qwen3-235B-A22B-Thinking-2507": {
  644:     "huggingface/Qwen/Qwen3-Coder-480B-A35B-Instruct": {
  677:     "huggingface/Qwen/Qwen3-Embedding-4B": {
  710:     "huggingface/Qwen/Qwen3-Embedding-8B": {
  743:     "huggingface/Qwen/Qwen3-Next-80B-A3B-Instruct": {
  776:     "huggingface/Qwen/Qwen3-Next-80B-A3B-Thinking": {
  2174:     "huggingface/deepseek-ai/DeepSeek-R1-0528": {
  2222:     "huggingface/moonshotai/Kimi-K2-Instruct": {
  2270:     "huggingface/moonshotai/Kimi-K2-Thinking": {
  2318:     "huggingface/zai-org/GLM-4.7": {
  2366:     "huggingface/zai-org/GLM-4.7-Flash": {
  2414:     "huggingface/zai-org/GLM-5": {
  3676:     "huggingface/XiaomiMiMo/MiMo-V2-Flash": {
  3812:           "type": "huggingface",
  3813:           "url": "https://huggingface.co/arcee-ai/Trinity-Large-Preview",

skills/update-agent-models\benchmarks\benchmark-setups.md:
  127:   - **Local Inference:** (uses Llama or other HuggingFace models)  
  149:   - If GPU needed, ensure CUDA drivers (though huggingface Llama-2 7B can run CPU).
  189:   - If missing data, get it via [HuggingFace IFBench collection](https://huggingface.co/allenai/ifbench). 
  328: - **Data:** Hosted on HuggingFace (dataset `cais/hle`)【50†L278-L286】.
  406: - **Data:** Available via HuggingFace (`ScaleAI/SWE-bench_Pro`)【57†L323-L328】. Verified is a human-validated subset (see [OpenAI blog](https://openai.com/blog/swe-bench-verified) for details).
  418:   - We can also use HuggingFace gold patches for testing: use `helper_code/gather_patches.py` on provided patches.
  431: - **Smoke Test (Gold Patches):** Use the gold patches (HuggingFace dataset contains `gold_patches.json`). Example:
  442:   - CSV path: ensure `swe_bench_pro_full.csv` (HuggingFace dataset file) is in repo root. 
  450: - **Data:** Hosted on HuggingFace (versions `release_v1` to `v6` for code generation, execution, test output).
  482: - **Data:** Available on HuggingFace (`cais/scicode-bench`)【70†L455-L464】.
  519: - **Dataset Downloads:** Some datasets need manual download or have access restrictions (GPQA, SciCode). Follow each repo’s instructions or use HuggingFace.

skills/update-agent-models\compile-research.js:
  270:   // HuggingFace Models
  271:   'huggingface/deepseek-ai/DeepSeek-V3.2': {
  278:   'huggingface/deepseek-ai/DeepSeek-R1-0528': {
  285:   'huggingface/Qwen/Qwen3-235B-A22B-Thinking-2507': {
  292:   'huggingface/Qwen/Qwen3-Coder-480B-A35B-Instruct': {
  299:   'huggingface/zai-org/GLM-4.7': {
  306:   'huggingface/zai-org/GLM-4.7-Flash': {
  313:   'huggingface/zai-org/GLM-5': {
  320:   'huggingface/MiniMaxAI/MiniMax-M2.1': {
  327:   'huggingface/moonshotai/Kimi-K2.5': {
  334:   'huggingface/moonshotai/Kimi-K2-Instruct': {
  341:   'huggingface/moonshotai/Kimi-K2-Thinking': {

skills/update-agent-models\HARDENING-IMPLEMENTATION.md:
  168:     target: 'huggingface/moonshotai/Kimi-K2.5',
  173:     target: 'huggingface/MiniMaxAI/MiniMax-M2.1',

skills/update-agent-models\IMPLEMENTATION_COMPLETE.md:
  60:    1   | huggingface/moonshotai/Kimi-K2-Thinking | N/A | N/A | 0.6687 | unknown ✓
  66: - "N/A" for value/blend means model lacks cost data (expected for huggingface models)

skills/update-agent-models\benchmarks\gpqa\gpqa_openrouter_install.md:
  39: pip install -U huggingface_hub
  40: huggingface-cli login
  138: - Ensure you accepted GPQA terms on Hugging Face and ran `huggingface-cli login`.
  153: GPQA HF dataset:      https://huggingface.co/datasets/Idavidrein/gpqa

skills/update-agent-models\test-models.sh:
  132: HUGGINGFACE_API_KEY="$(get_key huggingface)"
  223: test_huggingface() {
  225:     # HuggingFace Inference API endpoint changed from api-inference to router
  226:     local code=$(curl --max-time 10 --connect-timeout 5 -s -w "%{http_code}" -X POST "https://router.huggingface.co/v1/chat/completions" \
  227:         -H "Authorization: Bearer $HUGGINGFACE_API_KEY" \
  460: verify_huggingface() {
  463:     curl --max-time 10 --connect-timeout 5 -s -X POST "https://router.huggingface.co/v1/chat/completions" \
  464:         -H "Authorization: Bearer $HUGGINGFACE_API_KEY" \
  705:         huggingface)
  706:             code=$(test_huggingface "$model")
  786:             huggingface)
  787:                 if verify_huggingface "$model"; then

skills/update-agent-models\benchmarks\gpqa\gpqa-platform\README.md:
  9:     *   Accept terms for GPQA on Hugging Face: https://huggingface.co/datasets/Idavidrein/gpqa
  10:     *   Set `HF_TOKEN` in `.env`.

skills/update-agent-models\SKILL.md:
  463: - **GPQA Gated Access**: Requires `HF_TOKEN` and accepting terms on Hugging Face.
  748: Suggested Mapping: opencode/kimi-k2.5-free -> huggingface/moonshotai/Kimi-K2.5

skills/update-agent-models\benchmarks\hle\README.md:
  5: 🌐 [Website](https://lastexam.ai) | 📄 [Paper](https://lastexam.ai/paper) | 🤗 [Dataset](https://huggingface.co/datasets/cais/hle)
  17: The HLE Dataset is available for download on Hugging Face at [🤗 cais/hle](https://huggingface.co/datasets/cais/hle)

skills/update-agent-models\research_queue.json:
  13:     "huggingface/XiaomiMiMo/MiMo-V2-Flash",

skills/update-agent-models\research_findings.json:
  120:   "huggingface/XiaomiMiMo/MiMo-V2-Flash": {
  126:       "huggingface.co"
  142:       "huggingface.co"
  152:       "huggingface.co"
  170:       "huggingface.co"
  178:       "huggingface.co"
  186:       "huggingface.co"
  188:     "notes": "Small efficient model by HuggingFace"

skills/update-agent-models\research-sources-report.md:
  98: - **Datasets:** MATH-500 is on Hugging Face (`HuggingFaceH4/MATH-500`)【70†L193-L200】; AIME 2025 as above.  
  101: - **Monitoring:** Watch HF for `HuggingFaceH4/MATH-500`, MathArena updates (GitHub), and AA’s site for Math Index releases. 
  139: - **Dataset:** Public subset (731 tasks) on HF (HuggingFaceH4/SWE-bench) and GitHub【29†L42-L46】. Scale also has private subsets.  
  192: | **Math Index**        | HF [HuggingFaceH4/MATH-500] | Li et al. (2023) [ArXiv]      | AA dashboards             | Watch HF MATH-500, AA updates                  |
  205: - **GPQA:** GitHub search `idavidrein/gpqa`, HuggingFace search `gpqa`, queries like `"GPQA dataset" gpqa benchmark`.
  212: - **Math Index:** Use HF search `MATH-500`, query “HuggingFace MATH-500 dataset”, or AA site for Math Index.
  213: - **HLE:** Search `lastexam ai safety`, `Humanity's Last Exam huggingface`, or `centerforaisafety hle`.
  216: - **SWE-bench Pro:** Query `Scale SWE-bench Pro`, `HuggingFace SWE-bench Pro`, or `scale.com SWE_Bench`.
  217: - **SWE-bench Verified:** Search `HuggingFace SWE-bench Verified`, `OpenAI SWE-bench Verified`.

skills/update-agent-models\research-plan.md:
  41: | gpqa | GitHub + HuggingFace | `github.com/idavidrein/gpqa` + `huggingface.co/datasets/idavidrein/gpqa` | Public |
  42: | mmlu_pro | GitHub + HuggingFace | `github.com/TIGER-AI-Lab/MMLU-Pro` | Public |
  43: | ifbench | GitHub + HuggingFace | `github.com/allenai/IFBench` + `huggingface.co/datasets/allenai/IFBench_test` | Public |
  44: | SWE-bench Pro/Verified | HuggingFace | `huggingface.co/datasets/HuggingFaceH4/SWE-bench` + `princeton-nlp/SWE-bench_Verified` | Public (Verified requires login) |
  47: | aime | HuggingFace | `huggingface.co/datasets/MathArena/aime_2025` | Public |
  98: - `huggingface.co/spaces` (leaderboards)
  178: | **Weekly** | HuggingFace dataset updates | All with HF datasets |

skills/update-agent-models\benchmarks\livecodebench\uv.lock:
  496:     { name = "huggingface-hub" },
  1042: name = "huggingface-hub"
  1054: sdist = { url = "https://files.pythonhosted.org/packages/df/22/8eb91736b1dcb83d879bd49050a09df29a57cc5cd9f38e48a4b1c45ee890/huggingface_hub-0.30.2.tar.gz", hash = "sha256:9a7897c5b6fd9dad3168a794a8998d6378210f5b9688d0dfc180b1a228dc2466", size = 400868 }
  1056:     { url = "https://files.pythonhosted.org/packages/93/27/1fb384a841e9661faad1c31cbfa62864f59632e876df5d795234da51c395/huggingface_hub-0.30.2-py3-none-any.whl", hash = "sha256:68ff05969927058cfa41df4f2155d4bb48f5f54f719dd0390103eefa9b191e28", size = 481433 },
  3339:     { name = "huggingface-hub" },
  3481:     { name = "huggingface-hub" },
  3645:     { name = "huggingface-hub", extra = ["hf-xet"] },

skills/update-agent-models\benchmarks\vendor\lm-evaluation-harness\docs\task_guide.md:
  205: Metrics can be defined in the `metric_list` argument when building the YAML config. Multiple metrics can be listed along with any auxiliary arguments. For example, setting the [`exact_match` metric](https://github.com/huggingface/evaluate/tree/main/metrics/exact_match), auxiliary arguments such as `ignore_case`, `ignore_punctuation`, `regexes_to_ignore` can be listed as well. They will be added to the metric function as `kwargs`. Some metrics have predefined values for `aggregation` and `higher_is_better` so listing the metric name only can be sufficient.

skills/update-agent-models\benchmarks\livecodebench\README.md:
  6:     <a href="https://huggingface.co/livecodebench/">💻 Data </a> •
  8:     <a href="https://huggingface.co/spaces/livecodebench/code_generation_samples">🔍 Explorer</a> 
  44: - [Code Generation](https://huggingface.co/datasets/livecodebench/code_generation_lite)
  45: - [Code Execution](https://huggingface.co/datasets/livecodebench/execution)
  46: - [Test Output Prediction](https://huggingface.co/datasets/livecodebench/test_generation)

skills/update-agent-models\benchmarks\vendor\lm-evaluation-harness\docs\python-api.md:
  58: from lm_eval.models.huggingface import HFLM
  197: from lm_eval.models.huggingface import HFLM

skills/update-agent-models\benchmarks\vendor\lm-evaluation-harness\docs\new_task_guide.md:
  41: All data downloading and management is handled through the HuggingFace (**HF**) [`datasets`](https://github.com/huggingface/datasets) API. So, the first thing you should do is check to see if your task's dataset is already provided in their catalog [here](https://huggingface.co/datasets). If it's not in there, please consider adding it to their Hub to make it accessible to a wider user base by following their [new dataset guide](https://github.com/huggingface/datasets/blob/main/ADD_NEW_DATASET.md)
  45: Once you have a HuggingFace dataset prepared for your task, we want to assign our new YAML to use this dataset:
  49: dataset_name: ... # the dataset configuration to use. Leave `null` if your dataset does not require a config to be passed. See https://huggingface.co/docs/datasets/load_hub#configurations for more info.
  161: Alternatively, if you have previously downloaded a dataset from huggingface hub (using `save_to_disk()`) and wish to use the local files, you will need to use `data_dir` under `dataset_kwargs` to point to where the directory is.
  169: You can also set `dataset_path` as a directory path in your local system. This will assume that there is a loading script with the same name as the directory. [See datasets docs](https://huggingface.co/docs/datasets/loading#local-loading-script).
  318: For a full list of natively supported metrics and aggregation functions see [`docs/task_guide.md`](https://github.com/EleutherAI/lm-evaluation-harness/blob/main/docs/task_guide.md). All metrics supported in [HuggingFace Evaluate](https://github.com/huggingface/evaluate/tree/main/metrics) can also be used, and will be loaded if a given metric name is not one natively supported in `lm-eval` or `hf_evaluate` is set to `true`.

skills/update-agent-models\benchmarks\terminal-bench\uv.lock:
  724: name = "huggingface-hub"
  737: sdist = { url = "https://files.pythonhosted.org/packages/45/c9/bdbe19339f76d12985bc03572f330a01a93c04dffecaaea3061bdd7fb892/huggingface_hub-0.34.4.tar.gz", hash = "sha256:a4228daa6fb001be3f4f4bdaf9a0db00e1739235702848df00885c9b5742c85c", size = 459768, upload-time = "2025-08-08T09:14:52.365Z" }
  739:     { url = "https://files.pythonhosted.org/packages/39/7b/bb06b061991107cd8783f300adff3e7b7f284e330fd82f507f2a1417b11d/huggingface_hub-0.34.4-py3-none-any.whl", hash = "sha256:9b365d781739c93ff90c359844221beef048403f1bc1f1c123c191257c3c890a", size = 561452, upload-time = "2025-08-08T09:14:50.159Z" },
  2506:     { name = "huggingface-hub" },

skills/update-agent-models\benchmarks\vendor\lm-evaluation-harness\docs\model_guide.md:
  69: To allow a model to be evaluated on all types of tasks, you will need to implement these three types of measurements (note that `loglikelihood_rolling` is a special case of `loglikelihood`). For a reference implementation, check out `lm_eval/models/huggingface.py` ! Additionally, check out `lm_eval.api.model.TemplateLM` for a class that abstracts away some commonly used functions across LM subclasses, or see if your model would lend itself well to subclassing the `lm_eval.models.huggingface.HFLM` class and overriding just the initialization or a couple methods!
  73: LMs take in tokens in position `[0 1 2 ... N]` and output a probability distribution for token position `N+1`. We provide a simplified graphic here, excerpted from `huggingface.py`:
  111: Many models are fine-tuned with a [Chat Template](https://huggingface.co/docs/transformers/main/en/chat_templating) in order to enable back-and-forth interaction between a "User"'s queries and the model (often called "Assistant")'s responses. It can be desirable to evaluate fine-tuned models on evaluation tasks while wrapped in the conversational format they expect.
  136:         For the reference implementation, see HFLM class in `lm_eval.models.huggingface`.
  188: **Pro tip**: In order to make the Evaluation Harness overestimate total runtimes rather than underestimate it, HuggingFace models come in-built with the ability to provide responses on data points in *descending order by total input length* via `lm_eval.utils.Reorderer`. Take a look at `lm_eval.models.hf_causal.HFLM` to see how this is done, and see if you can implement it in your own model!

skills/update-agent-models\benchmarks\livecodebench\poetry.lock:
  534: description = "HuggingFace community-driven open-source library of datasets"
  547: huggingface-hub = ">=0.19.4"
  1312: name = "huggingface-hub"
  1314: description = "Client library to download and publish models, datasets and other repos on the huggingface.co hub"
  1318:     {file = "huggingface_hub-0.22.2-py3-none-any.whl", hash = "sha256:3429e25f38ccb834d310804a3b711e7e4953db5a9e420cc147a5e194ca90fd17"},
  1319:     {file = "huggingface_hub-0.22.2.tar.gz", hash = "sha256:32e9a9a6843c92f253ff9ca16b9985def4d80a93fb357af5353f770ef74a81be"},
  2343: test = ["accelerate", "beartype (<0.16.0)", "coverage[toml] (>=5.1)", "datasets", "diff-cover", "huggingface-hub", "llama-cpp-python (>=0.2.42)", "pre-commit", "pytest", "pytest-benchmark", "pytest-cov", "pytest-mock", "responses", "transformers"]
  3464: testing = ["h5py (>=3.7.0)", "huggingface_hub (>=0.12.1)", "hypothesis (>=6.70.2)", "pytest (>=7.2.0)", "pytest-benchmark (>=4.0.0)", "safetensors[numpy]", "setuptools_rust (>=1.5.2)"]
  3836: huggingface_hub = ">=0.16.4,<1.0"
  3944: huggingface-hub = ">=0.19.3,<1.0"
  3995: torchhub = ["filelock", "huggingface-hub (>=0.19.3,<1.0)", "importlib-metadata", "numpy (>=1.17)", "packaging (>=20.0)", "protobuf", "regex (!=2019.12.17)", "requests", "sentencepiece (>=0.1.91,!=0.1.92)", "tokenizers (>=0.14,<0.19)", "torch", "tqdm (>=4.27)"]

skills/update-agent-models\benchmarks\vendor\lm-evaluation-harness\docs\interface.md:
  61: # Basic evaluation with HuggingFace model
  79: | `--model_args` | `-a` | Model constructor arguments as `key=val key2=val2` or `key=val,key2=val2`. For HuggingFace models, see [`HFLM`](https://github.com/EleutherAI/lm-evaluation-harness/blob/main/lm_eval/models/huggingface.py) for available arguments. |
  132: | `--hf_hub_log_args` | | HuggingFace Hub logging arguments. See [HF Hub Logging](#huggingface-hub-logging). |
  140: | `--trust_remote_code` | | Allow executing remote code from HuggingFace Hub. |
  150: ### HuggingFace Hub Logging
  264: | `HF_TOKEN` | HuggingFace Hub token for private datasets/models. |

skills/update-agent-models\benchmarks\vendor\lm-evaluation-harness\docs\API_guide.md:
  68:   - Specifies the tokenizer library to use. Options are "tiktoken", "huggingface", or None.
  69:   - Default is "huggingface".
  116:             tokenizer_backend="huggingface",

skills/update-agent-models\benchmarks\tau2-bench\web\leaderboard\SUBMISSION_GUIDE.md:
  101:       "title": "Model Weights on HuggingFace",
  102:       "url": "https://huggingface.co/example/our-agent-model",
  103:       "type": "huggingface"

skills/update-agent-models\benchmarks\scicode\README.md:
  10: **[2025-02-17]: SciCode benchmark is available at [HuggingFace Datasets](https://huggingface.co/datasets/SciCode1/SciCode)!**

skills/update-agent-models\benchmarks\swe-bench-pro\index.html:
  268:                 <a href="https://huggingface.co/datasets/ScaleAI/SWE-bench_Pro" class="btn" target="_blank">💾 Data</a>

skills/update-agent-models\benchmarks\livecodebench\lcb_runner\runner\parser.py:
  25:         help="trust_remote_code option used in huggingface models",

skills/update-agent-models\benchmarks\tau2-bench\web\leaderboard\src\components\Leaderboard.jsx:
  991:                               {ref.type === 'huggingface' && '🤗'}

skills/update-agent-models\benchmarks\swe-bench-pro\helper_code\generate_sweagent_instances.py:
  3: Generate SWE-agent instance YAML file from HuggingFace SWE-bench Pro dataset.
  86:         description='Generate SWE-agent instances from HuggingFace SWE-bench Pro dataset',

skills/update-agent-models\benchmarks\tau2-bench\web\leaderboard\src\components\Leaderboard.css:
  1459: .reference-type.huggingface {

skills/update-agent-models\benchmarks\swe-bench-pro\helper_code\extract_gold_patches.py:
  3: Extract gold patches from the HuggingFace SWE-bench Pro dataset.
  29:         description="Extract gold patches from HuggingFace SWE-bench Pro dataset"
  47:         help="HuggingFace dataset name (default: ScaleAI/SWE-bench_Pro)"

skills/update-agent-models\benchmarks\swe-bench-pro\requirements.txt:
  12: # HuggingFace Hub for dataset management
  13: huggingface_hub>=0.16.0

skills/update-agent-models\benchmarks\swe-bench-pro\README.md:
  6: * HuggingFace: <a href="https://huggingface.co/datasets/ScaleAI/SWE-bench_Pro">https://huggingface.co/datasets/ScaleAI/SWE-bench_Pro</a>
  74: Each instance in the HuggingFace dataset has a `dockerhub_tag` column containing the Docker tag for that instance. You can access it directly:
  151: You can test with the gold patches, which are in the HuggingFace dataset. There is a helper script in `helper_code` which can extract the gold patches into the required JSON format.

skills/update-agent-models\benchmarks\livecodebench\lcb_runner\lm_styles.py:
  66:         link="https://huggingface.co/meta-llama/Meta-Llama-3-8B",
  73:         link="https://huggingface.co/meta-llama/Meta-Llama-3-70B",
  81:         link="https://huggingface.co/meta-llama/Meta-Llama-3-8B-Instruct",
  88:         link="https://huggingface.co/meta-llama/Meta-Llama-3-70B-Instruct",
  96:         link="https://huggingface.co/meta-llama/Llama-3.1-8B",
  103:         link="https://huggingface.co/meta-llama/Llama-3.1-70B",
  110:         link="https://huggingface.co/meta-llama/Llama-3.1-405B-FP8",
  118:         link="https://huggingface.co/meta-llama/Llama-3.1-8B-Instruct",
  125:         link="https://huggingface.co/meta-llama/Llama-3.1-70B-Instruct",
  132:         link="https://huggingface.co/meta-llama/Llama-3.1-405B-Instruct-FP8",
  136:     #     "meta-llama/Llama-3.3-8B-Instruct", # Has been removed from HuggingFace by meta-llama
  140:     #     link="https://huggingface.co/meta-llama/Llama-3.3-8B-Instruct",
  147:         link="https://huggingface.co/meta-llama/Llama-3.3-70B-Instruct",
  155:         link="https://huggingface.co/deepseek-ai/deepseek-coder-33b-base",
  162:         link="https://huggingface.co/deepseek-ai/deepseek-coder-6.7b-base",
  169:         link="https://huggingface.co/deepseek-ai/deepseek-coder-1.3b-base",
  177:         link="https://huggingface.co/deepseek-ai/deepseek-coder-33b-instruct",
  184:         link="https://huggingface.co/deepseek-ai/deepseek-coder-6.7b-instruct",
  191:         link="https://huggingface.co/deepseek-ai/deepseek-coder-1.3b-instruct",
  199:         link="https://huggingface.co/01-ai/Yi-Coder-9B-Chat",
  221:         link="https://huggingface.co/deepseek-ai/DeepSeek-V3",
  229:         link="https://huggingface.co/deepseek-ai/DeepSeek-V2",
  554:         link="https://huggingface.co/bigcode/starcoder2-7b-magicoder-instruct/tree/main",
  561:         link="https://huggingface.co/bigcode/starcoder2-7b-magicoder-instruct/tree/main",
  568:         link="https://huggingface.co/bigcode/starcoder2-7b-magicoder-instruct/tree/main",
  575:         link="https://huggingface.co/google/codegemma-7b",
  582:         link="https://huggingface.co/google/codegemma-2b",
  589:         link="https://huggingface.co/google/gemma-7b",
  596:         link="https://huggingface.co/google/gemma-2b",
  634:         link="https://huggingface.co/Qwen/QwQ-32B-Preview",
  641:         link="https://huggingface.co/Qwen/QwQ-32B",
  649:         link="https://huggingface.co/Qwen/Qwen2-72B-Instruct",
  657:         link="https://huggingface.co/Qwen/Qwen2.5-7B-Instruct",
  664:         link="https://huggingface.co/Qwen/Qwen2.5-32B-Instruct",
  671:         link="https://huggingface.co/Qwen/Qwen2.5-72B-Instruct",
  679:         link="https://huggingface.co/Qwen/Qwen2.5-Coder-7B-Instruct",
  686:         link="https://huggingface.co/Qwen/Qwen2.5-Coder-32B-Instruct",
  693:         link="https://huggingface.co/Qwen/Qwen3-235B-A22B",
  721:         link="https://huggingface.co/Qwen/QwQ-Max-Preview",
  728:         link="https://huggingface.co/deepseek-ai/DeepSeek-R1",
  735:         link="https://huggingface.co/deepseek-ai/DeepSeek-R1-0528",
  743:         link="https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B",
  750:         link="https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Qwen-7B",
  757:         link="https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Qwen-14B",
  764:         link="https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Qwen-32B",
  771:         link="https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Llama-8B",
  778:         link="https://huggingface.co/deepseek-ai/DeepSeek-R1-Distill-Llama-70B",
  848:         "https://huggingface.co/nvidia/Llama-3_1-Nemotron-Ultra-253B-v1",
  855:         "https://huggingface.co/nvidia/Llama-3_1-Nemotron-Nano-8B-v1/",
  862:         "https://huggingface.co/agentica-org/DeepCoder-14B-Preview",

skills/update-agent-models\benchmarks\livecodebench\lcb_runner\evaluation\utils_execute.py:
  1: # Copyright 2020 The HuggingFace Datasets Authors and the current dataset script contributor.

skills/update-agent-models\benchmarks\terminal-bench\scripts_python\export_tasks_to_hf_dataset.py:
  25:     pip install datasets pyarrow pyyaml tqdm huggingface_hub
  265:         from huggingface_hub import HfApi

skills/update-agent-models\benchmarks\tau2-bench\src\tau2\scripts\leaderboard\submission.py:
  28:     HUGGINGFACE = "huggingface"

skills/update-agent-models\benchmarks\ifbench\ifbench-platform\vendor\IFBench\README.md:
  25: You can find our released datasets in this [collection](https://huggingface.co/collections/allenai/ifbench-683f590687f61b512558cdf1), which contains the [test data](https://huggingface.co/datasets/allenai/IFBench_test), the [multi-turn test data](https://huggingface.co/datasets/allenai/IFBench_multi-turn) and the [IF-RLVR training data](https://huggingface.co/datasets/allenai/IF_multi_constraints_upto5).
  28: We also release our IF-RLVR code, as part of [open-instruct](https://github.com/allenai/open-instruct). You can run this [GRPO script](https://github.com/allenai/open-instruct/blob/main/open_instruct/grpo_fast.py), using our [training data](https://huggingface.co/datasets/allenai/IF_multi_constraints_upto5). This is an [example command](https://github.com/allenai/open-instruct/blob/main/scripts/train/rlvr/valpy_if_grpo_fast.sh).

skills/update-agent-models\reports\optimize.2026-02-16T22-53-05-239Z.json:
  38:       "primary": "huggingface/moonshotai/Kimi-K2-Thinking",
  44:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  74:           "modelId": "huggingface/MiniMaxAI/MiniMax-M2.1",
  84:           "modelId": "huggingface/zai-org/GLM-4.7",
  105:       "primary": "huggingface/zai-org/GLM-4.7",
  111:           "modelId": "huggingface/zai-org/GLM-4.7",
  131:           "modelId": "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  141:           "modelId": "huggingface/deepseek-ai/DeepSeek-V3.2",
  151:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  172:       "primary": "huggingface/moonshotai/Kimi-K2-Thinking",
  178:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  208:           "modelId": "huggingface/MiniMaxAI/MiniMax-M2.1",
  239:       "primary": "huggingface/moonshotai/Kimi-K2-Thinking",
  245:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  275:           "modelId": "huggingface/MiniMaxAI/MiniMax-M2.1",
  285:           "modelId": "huggingface/zai-org/GLM-4.7",
  306:       "primary": "huggingface/moonshotai/Kimi-K2-Thinking",
  312:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  342:           "modelId": "huggingface/zai-org/GLM-4.7",
  352:           "modelId": "huggingface/MiniMaxAI/MiniMax-M2.1",
  373:       "primary": "huggingface/zai-org/GLM-4.7",
  379:           "modelId": "huggingface/zai-org/GLM-4.7",
  399:           "modelId": "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  409:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",

skills/update-agent-models\reports\optimize.2026-02-16T22-52-53-606Z.json:
  38:       "primary": "huggingface/moonshotai/Kimi-K2-Thinking",
  44:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  74:           "modelId": "huggingface/MiniMaxAI/MiniMax-M2.1",
  84:           "modelId": "huggingface/zai-org/GLM-4.7",
  105:       "primary": "huggingface/zai-org/GLM-4.7",
  111:           "modelId": "huggingface/zai-org/GLM-4.7",
  131:           "modelId": "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  141:           "modelId": "huggingface/deepseek-ai/DeepSeek-V3.2",
  151:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  172:       "primary": "huggingface/moonshotai/Kimi-K2-Thinking",
  178:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  208:           "modelId": "huggingface/MiniMaxAI/MiniMax-M2.1",
  239:       "primary": "huggingface/moonshotai/Kimi-K2-Thinking",
  245:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  275:           "modelId": "huggingface/MiniMaxAI/MiniMax-M2.1",
  285:           "modelId": "huggingface/zai-org/GLM-4.7",
  306:       "primary": "huggingface/moonshotai/Kimi-K2-Thinking",
  312:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  342:           "modelId": "huggingface/zai-org/GLM-4.7",
  352:           "modelId": "huggingface/MiniMaxAI/MiniMax-M2.1",
  373:       "primary": "huggingface/zai-org/GLM-4.7",
  379:           "modelId": "huggingface/zai-org/GLM-4.7",
  399:           "modelId": "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  409:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",

skills/update-agent-models\reports\optimize.2026-02-16T22-22-44-092Z.json:
  38:       "primary": "huggingface/moonshotai/Kimi-K2-Thinking",
  44:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  65:           "modelId": "huggingface/MiniMaxAI/MiniMax-M2.1",
  72:           "modelId": "huggingface/zai-org/GLM-4.7",
  103:           "modelId": "huggingface/deepseek-ai/DeepSeek-R1-0528",
  117:           "modelId": "huggingface/zai-org/GLM-4.7",
  124:           "modelId": "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  142:       "primary": "huggingface/moonshotai/Kimi-K2-Thinking",
  148:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  169:           "modelId": "huggingface/MiniMaxAI/MiniMax-M2.1",
  194:       "primary": "huggingface/moonshotai/Kimi-K2-Thinking",
  200:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  221:           "modelId": "huggingface/MiniMaxAI/MiniMax-M2.1",
  228:           "modelId": "huggingface/zai-org/GLM-4.7",
  246:       "primary": "huggingface/MiniMaxAI/MiniMax-M2.1",
  252:           "modelId": "huggingface/MiniMaxAI/MiniMax-M2.1",
  259:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  280:           "modelId": "huggingface/zai-org/GLM-4.7",
  298:       "primary": "huggingface/zai-org/GLM-4.7",
  304:           "modelId": "huggingface/zai-org/GLM-4.7",
  311:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  332:           "modelId": "huggingface/deepseek-ai/DeepSeek-V3.2",

skills/update-agent-models\reports\optimize.2026-02-16T18-57-05-998Z.json:
  58:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  287:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  412:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  530:           "modelId": "huggingface/MiniMaxAI/MiniMax-M2.1",
  537:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",

skills/update-agent-models\reports\optimize.2026-02-16T14-52-43-224Z.json:
  58:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  206:           "modelId": "huggingface/Qwen/Qwen3-235B-A22B-Thinking-2507",
  502:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",

skills/update-agent-models\reports\optimize.2026-02-16T14-37-04-529Z.json:
  65:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  166:           "modelId": "huggingface/Qwen/Qwen3-235B-A22B-Thinking-2507",
  389:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",

skills/update-agent-models\benchmarks\ifbench\ifbench-platform\vendor\IFBench\eval\eval_results_strict.jsonl:
  269: [Omitted long matching line]

skills/update-agent-models\benchmarks\ifbench\ifbench-platform\vendor\IFBench\eval\eval_results_loose.jsonl:
  269: [Omitted long matching line]

skills/update-agent-models\benchmarks\ifbench\ifbench-platform\vendor\IFBench\data\sample_output.jsonl:
  269: [Omitted long matching line]

skills/update-agent-models\benchmarks\ifbench\ifbench-platform\vendor\IFBench\data\IFBench_test.jsonl:
  269: [Omitted long matching line]

skills/update-agent-models\benchmarks\tau2-bench\web\leaderboard\public\submissions\schema.json:
  81:             "enum": ["paper", "blog_post", "documentation", "model_card", "github", "huggingface", "other"],

skills/update-agent-models\benchmarks\tau2-bench\web\leaderboard\public\submissions\README.md:
  301: - `huggingface`: Hugging Face model pages
  383: - **HuggingFace model repositories** 
  391: - Direct links to GitHub/HuggingFace repositories

skills/update-agent-models\benchmarks\terminal-bench\terminal_bench\agents\installed_agents\opencode\opencode_agent.py:
  54:         elif self._provider == "huggingface":
  55:             keys.append("HF_TOKEN")

skills/update-agent-models\benchmarks\tau2-bench\src\experiments\agentify_tau_bench\uv.lock:
  1030: name = "huggingface-hub"
  1045: sdist = { url = "https://files.pythonhosted.org/packages/b8/63/eeea214a6b456d8e91ac2ea73ebb83da3af9aa64716dfb6e28dd9b2e6223/huggingface_hub-1.1.2.tar.gz", hash = "sha256:7bdafc432dc12fa1f15211bdfa689a02531d2a47a3cc0d74935f5726cdbcab8e", size = 606173, upload-time = "2025-11-06T10:04:38.398Z" }
  1047:     { url = "https://files.pythonhosted.org/packages/33/21/e15d90fd09b56938502a0348d566f1915f9789c5bb6c00c1402dc7259b6e/huggingface_hub-1.1.2-py3-none-any.whl", hash = "sha256:dfcfa84a043466fac60573c3e4af475490a7b0d7375b22e3817706d6659f61f7", size = 514955, upload-time = "2025-11-06T10:04:36.674Z" },
  2791:     { name = "huggingface-hub" },

skills/update-agent-models\benchmarks\tau2-bench\pdm.lock:
  636: name = "huggingface-hub"
  639: summary = "Client library to download and publish models, datasets and other repos on the huggingface.co hub"
  652:     {file = "huggingface_hub-0.29.3-py3-none-any.whl", hash = "sha256:0b25710932ac649c08cdbefa6c6ccb8e88eef82927cacdb048efb726429453aa"},
  653:     {file = "huggingface_hub-0.29.3.tar.gz", hash = "sha256:64519a25716e0ba382ba2d3fb3ca082e7c7eb4a2fc634d200e8380006e0760e5"},
  2150:     "huggingface-hub<1.0,>=0.16.4",

skills/update-agent-models\proposals\working_models.20260216T221856Z.json:
  18:     "huggingface/deepseek-ai/DeepSeek-R1-0528": {"lastVerified": 1771280336000, "successCount": 1, "failureCount": 0, "provider": "huggingface", "displayName": "huggingface/deepseek-ai/DeepSeek-R1-0528"},
  19:     "huggingface/deepseek-ai/DeepSeek-V3.2": {"lastVerified": 1771280336000, "successCount": 1, "failureCount": 0, "provider": "huggingface", "displayName": "huggingface/deepseek-ai/DeepSeek-V3.2"},
  20:     "huggingface/MiniMaxAI/MiniMax-M2.1": {"lastVerified": 1771280336000, "successCount": 1, "failureCount": 0, "provider": "huggingface", "displayName": "huggingface/MiniMaxAI/MiniMax-M2.1"},
  21:     "huggingface/moonshotai/Kimi-K2-Instruct": {"lastVerified": 1771280336000, "successCount": 1, "failureCount": 0, "provider": "huggingface", "displayName": "huggingface/moonshotai/Kimi-K2-Instruct"},
  22:     "huggingface/moonshotai/Kimi-K2-Instruct-0905": {"lastVerified": 1771280336000, "successCount": 1, "failureCount": 0, "provider": "huggingface", "displayName": "huggingface/moonshotai/Kimi-K2-Instruct-0905"},
  23:     "huggingface/moonshotai/Kimi-K2-Thinking": {"lastVerified": 1771280336000, "successCount": 1, "failureCount": 0, "provider": "huggingface", "displayName": "huggingface/moonshotai/Kimi-K2-Thinking"},
  24:     "huggingface/moonshotai/Kimi-K2.5": {"lastVerified": 1771280336000, "successCount": 1, "failureCount": 0, "provider": "huggingface", "displayName": "huggingface/moonshotai/Kimi-K2.5"},
  25:     "huggingface/Qwen/Qwen3-Next-80B-A3B-Instruct": {"lastVerified": 1771280336000, "successCount": 1, "failureCount": 0, "provider": "huggingface", "displayName": "huggingface/Qwen/Qwen3-Next-80B-A3B-Instruct"},
  26:     "huggingface/Qwen/Qwen3-Next-80B-A3B-Thinking": {"lastVerified": 1771280336000, "successCount": 1, "failureCount": 0, "provider": "huggingface", "displayName": "huggingface/Qwen/Qwen3-Next-80B-A3B-Thinking"},
  27:     "huggingface/XiaomiMiMo/MiMo-V2-Flash": {"lastVerified": 1771280336000, "successCount": 1, "failureCount": 0, "provider": "huggingface", "displayName": "huggingface/XiaomiMiMo/MiMo-V2-Flash"},
  28:     "huggingface/zai-org/GLM-4.7": {"lastVerified": 1771280336000, "successCount": 1, "failureCount": 0, "provider": "huggingface", "displayName": "huggingface/zai-org/GLM-4.7"},
  29:     "huggingface/zai-org/GLM-5": {"lastVerified": 1771280336000, "successCount": 1, "failureCount": 0, "provider": "huggingface", "displayName": "huggingface/zai-org/GLM-5"},

skills/update-agent-models\proposals\theseus-update.2026-02-16T22-53-05-240Z.json:
  6:       "primary": "huggingface/moonshotai/Kimi-K2-Thinking",
  12:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  42:           "modelId": "huggingface/MiniMaxAI/MiniMax-M2.1",
  52:           "modelId": "huggingface/zai-org/GLM-4.7",
  73:       "primary": "huggingface/zai-org/GLM-4.7",
  79:           "modelId": "huggingface/zai-org/GLM-4.7",
  99:           "modelId": "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  109:           "modelId": "huggingface/deepseek-ai/DeepSeek-V3.2",
  119:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  140:       "primary": "huggingface/moonshotai/Kimi-K2-Thinking",
  146:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  176:           "modelId": "huggingface/MiniMaxAI/MiniMax-M2.1",
  207:       "primary": "huggingface/moonshotai/Kimi-K2-Thinking",
  213:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  243:           "modelId": "huggingface/MiniMaxAI/MiniMax-M2.1",
  253:           "modelId": "huggingface/zai-org/GLM-4.7",
  274:       "primary": "huggingface/moonshotai/Kimi-K2-Thinking",
  280:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  310:           "modelId": "huggingface/zai-org/GLM-4.7",
  320:           "modelId": "huggingface/MiniMaxAI/MiniMax-M2.1",
  341:       "primary": "huggingface/zai-org/GLM-4.7",
  347:           "modelId": "huggingface/zai-org/GLM-4.7",
  367:           "modelId": "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  377:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  410:       "newPrimary": "huggingface/moonshotai/Kimi-K2-Thinking",
  412:         "huggingface/moonshotai/Kimi-K2-Thinking",
  415:         "huggingface/MiniMaxAI/MiniMax-M2.1",
  416:         "huggingface/zai-org/GLM-4.7",
  418:         "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  419:         "huggingface/deepseek-ai/DeepSeek-V3.2",
  420:         "huggingface/moonshotai/Kimi-K2-Instruct-0905",
  425:         "huggingface/deepseek-ai/DeepSeek-R1-0528",
  426:         "huggingface/moonshotai/Kimi-K2.5",
  427:         "huggingface/zai-org/GLM-5",
  428:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Instruct",
  429:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Thinking",
  434:         "huggingface/moonshotai/Kimi-K2-Instruct",
  441:         "huggingface/moonshotai/Kimi-K2-Thinking",
  444:         "huggingface/MiniMaxAI/MiniMax-M2.1",
  445:         "huggingface/zai-org/GLM-4.7",
  447:         "huggingface/deepseek-ai/DeepSeek-V3.2",
  448:         "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  449:         "huggingface/moonshotai/Kimi-K2-Instruct-0905",
  450:         "huggingface/deepseek-ai/DeepSeek-R1-0528",
  452:         "huggingface/moonshotai/Kimi-K2.5",
  456:         "huggingface/zai-org/GLM-5",
  457:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Instruct",
  458:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Thinking",
  459:         "huggingface/moonshotai/Kimi-K2-Instruct",
  471:       "newPrimary": "huggingface/zai-org/GLM-4.7",
  474:         "huggingface/deepseek-ai/DeepSeek-R1-0528",
  476:         "huggingface/zai-org/GLM-4.7",
  477:         "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  478:         "huggingface/deepseek-ai/DeepSeek-V3.2",
  479:         "huggingface/moonshotai/Kimi-K2-Thinking",
  482:         "huggingface/MiniMaxAI/MiniMax-M2.1",
  483:         "huggingface/moonshotai/Kimi-K2-Instruct-0905",
  486:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Instruct",
  487:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Thinking",
  488:         "huggingface/moonshotai/Kimi-K2.5",
  489:         "huggingface/zai-org/GLM-5",
  497:         "huggingface/moonshotai/Kimi-K2-Instruct",
  502:         "huggingface/zai-org/GLM-4.7",
  504:         "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  505:         "huggingface/deepseek-ai/DeepSeek-V3.2",
  506:         "huggingface/moonshotai/Kimi-K2-Thinking",
  509:         "huggingface/MiniMaxAI/MiniMax-M2.1",
  510:         "huggingface/deepseek-ai/DeepSeek-R1-0528",
  512:         "huggingface/moonshotai/Kimi-K2-Instruct-0905",
  513:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Instruct",
  514:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Thinking",
  515:         "huggingface/moonshotai/Kimi-K2.5",
  516:         "huggingface/zai-org/GLM-5",
  526:         "huggingface/moonshotai/Kimi-K2-Instruct",
  532:       "newPrimary": "huggingface/moonshotai/Kimi-K2-Thinking",
  534:         "huggingface/moonshotai/Kimi-K2-Thinking",
  537:         "huggingface/MiniMaxAI/MiniMax-M2.1",
  539:         "huggingface/zai-org/GLM-4.7",
  540:         "huggingface/zai-org/GLM-5",
  541:         "huggingface/deepseek-ai/DeepSeek-V3.2",
  542:         "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  543:         "huggingface/moonshotai/Kimi-K2.5",
  544:         "huggingface/moonshotai/Kimi-K2-Instruct-0905",
  549:         "huggingface/deepseek-ai/DeepSeek-R1-0528",
  550:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Instruct",
  551:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Thinking",
  552:         "huggingface/moonshotai/Kimi-K2-Instruct",
  563:         "huggingface/moonshotai/Kimi-K2-Thinking",
  566:         "huggingface/MiniMaxAI/MiniMax-M2.1",
  568:         "huggingface/zai-org/GLM-4.7",
  569:         "huggingface/deepseek-ai/DeepSeek-V3.2",
  570:         "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  571:         "huggingface/zai-org/GLM-5",
  572:         "huggingface/moonshotai/Kimi-K2.5",
  573:         "huggingface/moonshotai/Kimi-K2-Instruct-0905",
  578:         "huggingface/deepseek-ai/DeepSeek-R1-0528",
  579:         "huggingface/moonshotai/Kimi-K2-Instruct",
  580:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Instruct",
  581:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Thinking",
  593:       "newPrimary": "huggingface/moonshotai/Kimi-K2-Thinking",
  595:         "huggingface/moonshotai/Kimi-K2-Thinking",
  598:         "huggingface/MiniMaxAI/MiniMax-M2.1",
  599:         "huggingface/zai-org/GLM-4.7",
  600:         "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  604:         "huggingface/deepseek-ai/DeepSeek-V3.2",
  608:         "huggingface/moonshotai/Kimi-K2-Instruct-0905",
  612:         "huggingface/moonshotai/Kimi-K2-Instruct",
  613:         "huggingface/deepseek-ai/DeepSeek-R1-0528",
  614:         "huggingface/moonshotai/Kimi-K2.5",
  615:         "huggingface/zai-org/GLM-5",
  616:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Instruct",
  617:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Thinking",
  624:         "huggingface/moonshotai/Kimi-K2-Thinking",
  627:         "huggingface/MiniMaxAI/MiniMax-M2.1",
  628:         "huggingface/zai-org/GLM-4.7",
  629:         "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  631:         "huggingface/deepseek-ai/DeepSeek-V3.2",
  636:         "huggingface/moonshotai/Kimi-K2-Instruct-0905",
  637:         "huggingface/moonshotai/Kimi-K2.5",
  638:         "huggingface/zai-org/GLM-5",
  639:         "huggingface/deepseek-ai/DeepSeek-R1-0528",
  642:         "huggingface/moonshotai/Kimi-K2-Instruct",
  645:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Instruct",
  646:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Thinking",
  654:       "newPrimary": "huggingface/moonshotai/Kimi-K2-Thinking",
  656:         "huggingface/MiniMaxAI/MiniMax-M2.1",
  657:         "huggingface/moonshotai/Kimi-K2-Thinking",
  660:         "huggingface/zai-org/GLM-4.7",
  661:         "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  663:         "huggingface/deepseek-ai/DeepSeek-V3.2",
  664:         "huggingface/deepseek-ai/DeepSeek-R1-0528",
  666:         "huggingface/moonshotai/Kimi-K2-Instruct-0905",
  667:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Instruct",
  668:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Thinking",
  672:         "huggingface/moonshotai/Kimi-K2.5",
  675:         "huggingface/zai-org/GLM-5",
  678:         "huggingface/moonshotai/Kimi-K2-Instruct",
  685:         "huggingface/moonshotai/Kimi-K2-Thinking",
  688:         "huggingface/zai-org/GLM-4.7",
  689:         "huggingface/MiniMaxAI/MiniMax-M2.1",
  691:         "huggingface/deepseek-ai/DeepSeek-V3.2",
  692:         "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  693:         "huggingface/deepseek-ai/DeepSeek-R1-0528",
  694:         "huggingface/moonshotai/Kimi-K2-Instruct-0905",
  696:         "huggingface/moonshotai/Kimi-K2.5",
  697:         "huggingface/zai-org/GLM-5",
  698:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Instruct",
  699:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Thinking",
  705:         "huggingface/moonshotai/Kimi-K2-Instruct",
  715:       "newPrimary": "huggingface/zai-org/GLM-4.7",
  717:         "huggingface/zai-org/GLM-4.7",
  718:         "huggingface/moonshotai/Kimi-K2-Thinking",
  721:         "huggingface/deepseek-ai/DeepSeek-V3.2",
  723:         "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  724:         "huggingface/MiniMaxAI/MiniMax-M2.1",
  726:         "huggingface/deepseek-ai/DeepSeek-R1-0528",
  727:         "huggingface/moonshotai/Kimi-K2-Instruct-0905",
  728:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Instruct",
  729:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Thinking",
  733:         "huggingface/zai-org/GLM-5",
  734:         "huggingface/moonshotai/Kimi-K2.5",
  735:         "huggingface/moonshotai/Kimi-K2-Instruct",
  746:         "huggingface/zai-org/GLM-4.7",
  748:         "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  749:         "huggingface/moonshotai/Kimi-K2-Thinking",
  752:         "huggingface/MiniMaxAI/MiniMax-M2.1",
  753:         "huggingface/deepseek-ai/DeepSeek-V3.2",
  754:         "huggingface/deepseek-ai/DeepSeek-R1-0528",
  755:         "huggingface/moonshotai/Kimi-K2-Instruct-0905",
  757:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Instruct",
  758:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Thinking",
  762:         "huggingface/zai-org/GLM-5",
  763:         "huggingface/moonshotai/Kimi-K2.5",
  764:         "huggingface/moonshotai/Kimi-K2-Instruct",

skills/update-agent-models\proposals\theseus-update.2026-02-16T22-52-53-607Z.json:
  6:       "primary": "huggingface/moonshotai/Kimi-K2-Thinking",
  12:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  42:           "modelId": "huggingface/MiniMaxAI/MiniMax-M2.1",
  52:           "modelId": "huggingface/zai-org/GLM-4.7",
  73:       "primary": "huggingface/zai-org/GLM-4.7",
  79:           "modelId": "huggingface/zai-org/GLM-4.7",
  99:           "modelId": "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  109:           "modelId": "huggingface/deepseek-ai/DeepSeek-V3.2",
  119:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  140:       "primary": "huggingface/moonshotai/Kimi-K2-Thinking",
  146:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  176:           "modelId": "huggingface/MiniMaxAI/MiniMax-M2.1",
  207:       "primary": "huggingface/moonshotai/Kimi-K2-Thinking",
  213:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  243:           "modelId": "huggingface/MiniMaxAI/MiniMax-M2.1",
  253:           "modelId": "huggingface/zai-org/GLM-4.7",
  274:       "primary": "huggingface/moonshotai/Kimi-K2-Thinking",
  280:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  310:           "modelId": "huggingface/zai-org/GLM-4.7",
  320:           "modelId": "huggingface/MiniMaxAI/MiniMax-M2.1",
  341:       "primary": "huggingface/zai-org/GLM-4.7",
  347:           "modelId": "huggingface/zai-org/GLM-4.7",
  367:           "modelId": "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  377:           "modelId": "huggingface/moonshotai/Kimi-K2-Thinking",
  410:       "newPrimary": "huggingface/moonshotai/Kimi-K2-Thinking",
  412:         "huggingface/moonshotai/Kimi-K2-Thinking",
  415:         "huggingface/MiniMaxAI/MiniMax-M2.1",
  416:         "huggingface/zai-org/GLM-4.7",
  418:         "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  419:         "huggingface/deepseek-ai/DeepSeek-V3.2",
  420:         "huggingface/moonshotai/Kimi-K2-Instruct-0905",
  425:         "huggingface/deepseek-ai/DeepSeek-R1-0528",
  426:         "huggingface/moonshotai/Kimi-K2.5",
  427:         "huggingface/zai-org/GLM-5",
  428:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Instruct",
  429:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Thinking",
  434:         "huggingface/moonshotai/Kimi-K2-Instruct",
  441:         "huggingface/moonshotai/Kimi-K2-Thinking",
  444:         "huggingface/MiniMaxAI/MiniMax-M2.1",
  445:         "huggingface/zai-org/GLM-4.7",
  447:         "huggingface/deepseek-ai/DeepSeek-V3.2",
  448:         "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  449:         "huggingface/moonshotai/Kimi-K2-Instruct-0905",
  450:         "huggingface/deepseek-ai/DeepSeek-R1-0528",
  452:         "huggingface/moonshotai/Kimi-K2.5",
  456:         "huggingface/zai-org/GLM-5",
  457:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Instruct",
  458:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Thinking",
  459:         "huggingface/moonshotai/Kimi-K2-Instruct",
  471:       "newPrimary": "huggingface/zai-org/GLM-4.7",
  474:         "huggingface/deepseek-ai/DeepSeek-R1-0528",
  476:         "huggingface/zai-org/GLM-4.7",
  477:         "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  478:         "huggingface/deepseek-ai/DeepSeek-V3.2",
  479:         "huggingface/moonshotai/Kimi-K2-Thinking",
  482:         "huggingface/MiniMaxAI/MiniMax-M2.1",
  483:         "huggingface/moonshotai/Kimi-K2-Instruct-0905",
  486:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Instruct",
  487:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Thinking",
  488:         "huggingface/moonshotai/Kimi-K2.5",
  489:         "huggingface/zai-org/GLM-5",
  497:         "huggingface/moonshotai/Kimi-K2-Instruct",
  502:         "huggingface/zai-org/GLM-4.7",
  504:         "huggingface/XiaomiMiMo/MiMo-V2-Flash",
  505:         "huggingface/deepseek-ai/DeepSeek-V3.2",
  506:         "huggingface/moonshotai/Kimi-K2-Thinking",
  509:         "huggingface/MiniMaxAI/MiniMax-M2.1",
  510:         "huggingface/deepseek-ai/DeepSeek-R1-0528",
  512:         "huggingface/moonshotai/Kimi-K2-Instruct-0905",
  513:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Instruct",
  514:         "huggingface/Qwen/Qwen3-Next-80B-A3B-Thinking",
  515:         "huggingface/moonsh

... (truncated)
```
