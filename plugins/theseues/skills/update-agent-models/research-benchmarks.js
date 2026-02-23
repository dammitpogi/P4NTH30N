/**
 * research-benchmarks.js
 *
 * Detects missing benchmark coverage for pulled models and attempts to
 * research benchmark entries from Artificial Analysis API.
 *
 * Output: proposal file in skills/update-agent-models/proposals/
 *
 * This script never writes model_benchmarks.json directly.
 */

const fs = require("fs");
const path = require("path");
const https = require("https");

const SKILL_DIR = __dirname;
const ROOT_DIR = path.resolve(SKILL_DIR, "..", "..");
const PROPOSAL_DIR = path.join(SKILL_DIR, "proposals");

const PATHS = {
  opencode: path.join(ROOT_DIR, "opencode.json"),
  modelBenchmarks: path.join(SKILL_DIR, "model_benchmarks.json"),
  acceptedBenchmarks: path.join(SKILL_DIR, "benchmark_manual_accepted.json"),
  workingModels: path.join(SKILL_DIR, "working_models.json"),
  auth: "C:/Users/paulc/.local/share/opencode/auth.json",
};

function loadJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function saveJson(filePath, data) {
  fs.writeFileSync(filePath, JSON.stringify(data, null, 2) + "\n", "utf8");
}

function ensureDirectory(dirPath) {
  if (!fs.existsSync(dirPath)) fs.mkdirSync(dirPath, { recursive: true });
}

function normalizeText(value) {
  return String(value || "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function tokenize(text) {
  return new Set(normalizeText(text).split(" ").filter(Boolean));
}

function stripProviderPrefixes(modelId) {
  const parts = String(modelId || "").split("/");
  if (parts.length <= 1) return String(modelId || "");
  if (parts[0] === "openrouter" && parts.length >= 3) {
    return parts.slice(2).join("/");
  }
  if (parts[0] === "groq" && parts.length >= 3) {
    return parts.slice(1).join("/");
  }
  return parts.slice(1).join("/");
}

function normalizeModelCore(modelId) {
  return stripProviderPrefixes(String(modelId || ""))
    .replace(/:free/gi, "")
    .replace(/:exacto/gi, "")
    .replace(/[_]/g, "-")
    .replace(/\(.*?\)/g, "")
    .trim();
}

function expectedCreatorHints(modelId) {
  const parts = String(modelId || "").split("/");
  if (parts.length < 2) return [];

  if (parts[0] === "openrouter" && parts[1]) {
    return [normalizeText(parts[1]).replace(/\s+/g, "-")];
  }
  if (parts[0] === "groq" && parts[1]) {
    const alias = normalizeText(parts[1]).replace(/\s+/g, "-");
    if (alias === "meta-llama") return ["meta", "meta-llama"];
    return [alias];
  }
  if (parts[0] === "moonshotai") return ["moonshot", "moonshotai"];
  if (parts[0] === "google") return ["google"];
  if (parts[0] === "openai") return ["openai"];
  if (parts[0] === "anthropic") return ["anthropic"];
  return [];
}

function shouldForceManualResearch(modelId) {
  const id = String(modelId || "").toLowerCase();
  if (id.startsWith("lmstudio-local/")) return true;
  if (id.startsWith("opencode/")) return true;
  if (id.includes("llama-guard")) return true;
  return false;
}

function tokenOverlapScore(a, b) {
  const A = tokenize(a);
  const B = tokenize(b);
  if (A.size === 0 || B.size === 0) return 0;
  let match = 0;
  for (const t of A) if (B.has(t)) match += 1;
  return match / A.size;
}

function buildBenchmarkRecordList(modelBenchmarks) {
  return Object.entries(modelBenchmarks.models || {}).map(([key, value]) => ({
    key,
    name: value?.name || key,
    benchmarks: value?.benchmarks || {},
  }));
}

function buildAcceptedBenchmarkRecordList(acceptedBenchmarks) {
  return Object.entries(acceptedBenchmarks?.models || {}).map(([key, value]) => ({
    key,
    name: value?.name || key,
    benchmarks: value?.benchmarks || {},
  }));
}

function resolveBenchmarkRecord(modelId, records) {
  const modelNorm = normalizeText(modelId);
  const exact = records.find((r) => normalizeText(r.key) === modelNorm || normalizeText(r.name) === modelNorm);
  if (exact) return exact;

  let best = null;
  let bestScore = 0;
  for (const record of records) {
    const score = tokenOverlapScore(modelId, `${record.key} ${record.name}`);
    if (score > bestScore) {
      bestScore = score;
      best = record;
    }
  }
  return bestScore >= 0.45 ? best : null;
}

function latestProposal(prefix) {
  if (!fs.existsSync(PROPOSAL_DIR)) return null;
  const files = fs
    .readdirSync(PROPOSAL_DIR)
    .filter((f) => f.startsWith(prefix) && f.endsWith(".json"))
    .sort();
  return files.length > 0 ? path.join(PROPOSAL_DIR, files[files.length - 1]) : null;
}

function loadWorkingModelsPreferProposal() {
  const latest = latestProposal("working_models.");
  if (latest) return loadJson(latest);
  return loadJson(PATHS.workingModels);
}

function isExcludedWorkingModel(modelId) {
  const id = String(modelId || "");
  return id.startsWith("artificial-analysis/") || id === "free/openrouter/free";
}

function parseArgs(argv) {
  const args = new Set(argv);
  const focusIdx = argv.indexOf("--focus-model");
  const focusModel = focusIdx >= 0 ? argv[focusIdx + 1] : "";
  return {
    one: args.has("--one"),
    focusModel: String(focusModel || "").trim(),
  };
}

function extractAaModelList(payload) {
  if (Array.isArray(payload)) return payload;
  if (Array.isArray(payload?.models)) return payload.models;
  if (Array.isArray(payload?.data)) return payload.data;
  if (Array.isArray(payload?.result?.models)) return payload.result.models;
  return [];
}

function pickAaCandidate(modelId, aaModels) {
  const core = normalizeModelCore(modelId);
  const coreNorm = normalizeText(core);
  const coreTokens = tokenize(coreNorm);
  const creatorHints = expectedCreatorHints(modelId);

  let best = null;
  let bestScore = 0;
  for (const m of aaModels) {
    const creatorSlug = normalizeText(m?.model_creator?.slug || "").replace(/\s+/g, "-");
    if (creatorHints.length > 0 && !creatorHints.includes(creatorSlug)) {
      continue;
    }

    const hay = [
      m?.id,
      m?.slug,
      m?.name,
      m?.model,
      m?.provider,
      m?.displayName,
      m?.model_creator?.name,
      m?.model_creator?.slug,
    ]
      .filter(Boolean)
      .join(" ");
    const hayNorm = normalizeText(hay);
    const overlap = tokenOverlapScore(coreNorm, hayNorm);
    const substringBoost = hayNorm.includes(coreNorm) || coreNorm.includes(hayNorm) ? 0.2 : 0;

    let tokenContain = 0;
    for (const t of coreTokens) {
      if (t.length < 3) continue;
      if (hayNorm.includes(t)) tokenContain += 0.03;
    }

    const score = overlap + substringBoost + tokenContain;
    if (score > bestScore) {
      bestScore = score;
      best = m;
    }
  }
  if (bestScore < 0.32) return null;
  return { model: best, confidence: Math.min(bestScore, 1) };
}

function isStealthOrCloaked(modelId) {
  const id = String(modelId || "").toLowerCase();
  if (id.startsWith("opencode/")) return true;
  if (id.startsWith("lmstudio-local/")) return true;
  if (id.includes("llama-guard")) return true;
  return false;
}

function shouldAutoAccept(modelId, confidence) {
  return !isStealthOrCloaked(modelId) && Number(confidence) >= 0.65;
}

function toNumber(v) {
  const n = Number(v);
  return Number.isFinite(n) ? n : null;
}

function extractBenchmarksFromAaModel(m) {
  const raw = m?.evaluations || m?.benchmarks || m?.metrics || m?.scores || {};
  const out = {};
  const aliases = {
    GDPval_AA_ELO: [
      "GDPval_AA_ELO",
      "GDPval-AA ELO",
      "gdpval_aa_elo",
      "gdpval",
      "gdpval_aa",
      "artificial_analysis_gdpval_aa_elo",
    ],
    gpqa: ["gpqa"],
    mmlu_pro: ["mmlu_pro", "mmlu-pro"],
    intelligence_index: ["intelligence_index", "artificial_analysis_intelligence_index"],
    ifbench: ["ifbench"],
    tau2: ["tau2"],
    context_length: ["context_length", "contextWindow", "context_window"],
    aime: ["aime"],
    math_index: ["math_index", "artificial_analysis_math_index"],
    hle: ["hle"],
    terminalbench_hard: ["terminalbench_hard", "terminalbench-hard"],
    coding_index: ["coding_index", "artificial_analysis_coding_index"],
    SWE_bench_Pro: ["SWE_bench_Pro", "swe_bench_pro", "SWE-bench Pro"],
    SWE_bench_Verified: ["SWE_bench_Verified", "swe_bench_verified", "SWE-bench Verified"],
    livecodebench: ["livecodebench"],
    scicode: ["scicode"],
  };

  for (const [target, keys] of Object.entries(aliases)) {
    for (const key of keys) {
      if (Object.prototype.hasOwnProperty.call(raw, key)) {
        const n = toNumber(raw[key]);
        if (n !== null) out[target] = n;
        break;
      }
    }
  }

  return out;
}

function httpGetJson(url, headers) {
  return new Promise((resolve, reject) => {
    const req = https.request(url, { method: "GET", headers }, (res) => {
      let body = "";
      res.on("data", (chunk) => (body += chunk));
      res.on("end", () => {
        if (res.statusCode < 200 || res.statusCode >= 300) {
          return reject(new Error(`HTTP ${res.statusCode}: ${body.slice(0, 200)}`));
        }
        try {
          resolve(JSON.parse(body));
        } catch (error) {
          reject(new Error(`Invalid JSON from AA: ${error.message}`));
        }
      });
    });
    req.on("error", reject);
    req.end();
  });
}

function joinUrl(base, suffix) {
  return `${String(base || "").replace(/\/$/, "")}${suffix}`;
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  const opencode = loadJson(PATHS.opencode);
  const aa = opencode?.provider?.["artificial-analysis"] || {};
  const baseURL = aa?.options?.baseURL;
  const apiKeyRef = aa?.options?.apiKey || "";

  const envName = /^\{env:(.+)\}$/.exec(apiKeyRef)?.[1] || "ARTIFICIAL_ANALYSIS_API_KEY";
  let apiKey = process.env[envName] || "";
  if (!apiKey && fs.existsSync(PATHS.auth)) {
    const auth = loadJson(PATHS.auth);
    apiKey =
      auth?.["artificial-analysis"]?.key ||
      auth?.artificialanalysis?.key ||
      auth?.artificial_analysis?.key ||
      "aa_LglIiFMQYCYavMQnrvguMtpSIwzEsqwX";
  }

  const modelBenchmarks = loadJson(PATHS.modelBenchmarks);
  const acceptedBenchmarks = loadJson(PATHS.acceptedBenchmarks);
  const records = [
    ...buildBenchmarkRecordList(modelBenchmarks),
    ...buildAcceptedBenchmarkRecordList(acceptedBenchmarks),
  ];
  const working = loadWorkingModelsPreferProposal();
  const pulledModels = Object.keys(working.models || {}).filter((modelId) => !isExcludedWorkingModel(modelId));

  const missing = pulledModels.filter((m) => !resolveBenchmarkRecord(m, records));
  if (missing.length === 0) {
    console.log("No missing benchmark coverage.");
    return;
  }

  if (!baseURL || !apiKey) {
    throw new Error(
      `Missing AA access for benchmark research. Missing coverage: ${missing.length} models. Provide ${envName} and rerun.`
    );
  }

  const endpointCandidates = [
    joinUrl(baseURL, "/data/llms/models"),
    joinUrl(baseURL, "/llms/models"),
    "https://artificialanalysis.ai/api/v2/data/llms/models",
  ];

  let payload = null;
  let lastError = null;
  for (const url of endpointCandidates) {
    try {
      // Artificial Analysis docs use x-api-key header.
      // Keep Authorization fallback for compatibility.
      // eslint-disable-next-line no-await-in-loop
      payload = await httpGetJson(url, {
        "x-api-key": apiKey,
        Authorization: `Bearer ${apiKey}`,
      });
      if (payload) break;
    } catch (error) {
      lastError = error;
    }
  }

  if (!payload) {
    throw new Error(`AA models endpoint failed: ${lastError ? lastError.message : "unknown error"}`);
  }
  const aaModels = extractAaModelList(payload);

  const targets = args.focusModel
    ? missing.filter((m) => m === args.focusModel)
    : args.one
    ? missing.slice(0, 1)
    : missing;

  if (args.focusModel && targets.length === 0) {
    throw new Error(`Focus model not currently missing benchmark coverage: ${args.focusModel}`);
  }

  const patch = {};
  const unresolved = [];

  for (const modelId of targets) {
    if (shouldForceManualResearch(modelId)) {
      unresolved.push(modelId);
      continue;
    }
    const matched = pickAaCandidate(modelId, aaModels);
    if (!matched) {
      unresolved.push(modelId);
      continue;
    }
    const benchmarks = extractBenchmarksFromAaModel(matched.model);
    if (Object.keys(benchmarks).length === 0) {
      unresolved.push(modelId);
      continue;
    }
    const autoAccepted = shouldAutoAccept(modelId, matched.confidence);
    patch[modelId] = {
      name: matched.model?.name || matched.model?.model || matched.model?.id || modelId,
      sources: [
        {
          type: "artificial-analysis-api",
          endpoint: "https://artificialanalysis.ai/api/v2/data/llms/models",
          model_reference:
            matched.model?.id || matched.model?.slug || matched.model?.name || null,
        },
      ],
      confidence: Number(matched.confidence.toFixed(3)),
      autoAccepted,
      requiresUserAcceptance: !autoAccepted,
      benchmarks,
    };
  }

  ensureDirectory(PROPOSAL_DIR);
  const stamp = new Date().toISOString().replace(/[:.]/g, "-");
  const outPath = path.join(PROPOSAL_DIR, `benchmark-research.${stamp}.json`);
  saveJson(outPath, {
    timestamp: new Date().toISOString(),
    type: "benchmark-research",
    one_at_a_time: Boolean(args.one),
    requires_user_acceptance: true,
    acceptance_rule:
      "User must approve researched entries before they can be added to benchmark_manual_accepted.json. If not approved and no benchmark is available, continue research and request explicit user decision. Ignore-list updates require explicit user approval and must never be auto-applied.",
    pulled_models: pulledModels.length,
    missing_before: missing.length,
    researched_scope: targets.length,
    remaining_after_scope: Math.max(missing.length - targets.length, 0),
    next_missing_candidate: missing.find((m) => !targets.includes(m)) || null,
    researched: Object.keys(patch).length,
    unresolved_count: unresolved.length,
    unresolved,
    manual_research_tasks: unresolved.map((modelId) => ({
      model: modelId,
      search_queries: [
        `${modelId} benchmark gpqa mmlu_pro ifbench`,
        `${modelId} real backend model alias rumor`,
      ],
      note:
        "If model is stealth/cloaked, identify likely backing model via credible sources. User must approve mapped benchmark data before acceptance. Ignore-list updates require explicit user approval and must never be auto-applied.",
    })),
    model_benchmark_patch: patch,
  });

  console.log(`Benchmark research proposal written: ${outPath}`);
  if (args.one && !args.focusModel) {
    console.log("One-at-a-time mode: researched a single model candidate.");
  }
  if (unresolved.length > 0) {
    console.log(`Research follow-up required for ${unresolved.length} unresolved models.`);
    console.log("This is a workflow decision gate, not a terminal error.");
  }
}

main().catch((error) => {
  console.error(`Benchmark research failed: ${error.message}`);
  process.exit(1);
});
