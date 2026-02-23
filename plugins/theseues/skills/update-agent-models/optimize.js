/**
 * update-agent-models optimizer
 *
 * Deterministically updates oh-my-opencode-theseus.json using bench_calc.json
 * formulas and cached benchmark data.
 *
 * Usage:
 *   node skills/update-agent-models/optimize.js --dry-run
 *   node skills/update-agent-models/optimize.js
 *
 * Options:
 *   --dry-run      Compute without proposal output changes (report/proposal still generated)
 *   --strict       Fail if an agent has zero scored models or unmatched models in its chain
 *   --explain      Print top scoring details per agent
 *   --no-report    Skip JSON run report write
 *   --use-proxy    Apply one-time benchmark proxy proposal (consumed after run)
 *   --keep-proxy   Do not consume the loaded proxy proposal (debug)
 */

const fs = require("fs");
const path = require("path");

const SKILL_DIR = __dirname;
const ROOT_DIR = path.resolve(SKILL_DIR, "..", "..");

const PATHS = {
  benchCalc: path.join(SKILL_DIR, "bench_calc.json"),
  modelBenchmarks: path.join(SKILL_DIR, "model_benchmarks.json"),
  workingModels: path.join(SKILL_DIR, "working_models.json"),
  acceptedBenchmarks: path.join(SKILL_DIR, "benchmark_manual_accepted.json"),
  ignoreList: path.join(SKILL_DIR, "model_ignore_list.json"),
  openaiBudgetPolicy: path.join(SKILL_DIR, "openai_budget_policy.json"),
  theseus: path.join(ROOT_DIR, "oh-my-opencode-theseus.json"),
  reportDir: path.join(SKILL_DIR, "reports"),
  proposalDir: path.join(SKILL_DIR, "proposals"),
  lock: path.join(SKILL_DIR, ".optimize.lock"),
};

const DEFAULT_MAX_CONTEXT_LENGTH = 2_000_000;
const RESERVED_FREE_BRIDGE_MODEL = "free/openrouter/free";

const AGENT_ROLE_MAP = {
  orchestrator: "Orchestrator",
  oracle: "Oracle",
  explorer: "Explorer",
  librarian: "Librarian",
  designer: "Designer",
  fixer: "Fixer",
};

// Ambiguous model IDs mapped to benchmark display names.
const BENCHMARK_NAME_OVERRIDES = {
  "openai/gpt-5.2": "GPT-5.2 (xhigh)",
  "google/gemini-3-pro-preview": "Gemini 3 Pro Preview (high)",
  "google/gemini-3-flash-preview": "Gemini 3 Flash Preview (Reasoning)",
  "anthropic/claude-opus-4-6": "Claude Opus 4.6 (Adaptive Reasoning)",
  "anthropic/claude-sonnet-4-5": "Claude 4.5 Sonnet (Reasoning)",
};

function loadJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function loadOptionalJson(filePath, fallback) {
  if (!fs.existsSync(filePath)) return fallback;
  return loadJson(filePath);
}

function latestFile(dirPath, prefix) {
  if (!fs.existsSync(dirPath)) return null;
  const files = fs
    .readdirSync(dirPath)
    .filter((f) => f.startsWith(prefix) && f.endsWith(".json"))
    .sort();
  return files.length > 0 ? path.join(dirPath, files[files.length - 1]) : null;
}

function saveJson(filePath, data) {
  fs.writeFileSync(filePath, JSON.stringify(data, null, 2) + "\n", "utf8");
}

function ensureDirectory(dirPath) {
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
  }
}

function writeRunReport(report) {
  ensureDirectory(PATHS.reportDir);
  const stamp = new Date().toISOString().replace(/[:.]/g, "-");
  const out = path.join(PATHS.reportDir, `optimize.${stamp}.json`);
  saveJson(out, report);
  return out;
}

function writeProposal(proposal) {
  ensureDirectory(PATHS.proposalDir);
  const stamp = new Date().toISOString().replace(/[:.]/g, "-");
  const out = path.join(PATHS.proposalDir, `theseus-update.${stamp}.json`);
  saveJson(out, proposal);
  return out;
}

function getLatestResearchProposal(pathToDir) {
  const latest = latestFile(pathToDir, 'benchmark-research.');
  return latest ? loadOptionalJson(latest, null) : null;
}

function assertResearchGateResolved(options, acceptedBenchmarks, ignoreList, researchProposal, proxyCoveredModels) {
  const proxySet = proxyCoveredModels instanceof Set ? proxyCoveredModels : new Set();
  if ((options.openaiOnly || options.googleOnly) && !options.useProxy) return;
  if (!researchProposal) return;

  const acceptedSet = new Set(Object.keys(acceptedBenchmarks?.models || {}));
  const ignoredSet = new Set(Object.keys(ignoreList?.ignored_models || {}));
  const deniedSet = options.deniedModels || new Set();
  const patch = researchProposal.model_benchmark_patch || {};

  const pendingPatch = Object.keys(patch).filter((m) => {
    const entry = patch[m] || {};
    if (entry.autoAccepted) return !acceptedSet.has(m);
    return !acceptedSet.has(m) && !ignoredSet.has(m) && !deniedSet.has(m) && !proxySet.has(m);
  });

  const unresolved = (researchProposal.unresolved || []).filter(
    (m) => !acceptedSet.has(m) && !ignoredSet.has(m) && !deniedSet.has(m) && !proxySet.has(m)
  );

  if (pendingPatch.length > 0 || unresolved.length > 0) {
    throw new Error(
      `Research gate unresolved: pendingPatch=${pendingPatch.length}, unresolved=${unresolved.length}. ` +
        'Run research/interview flow and sync auto-accepted entries before optimization.'
    );
  }
}

function parseArgs(argv) {
  const args = new Set();
  const deniedModels = new Set();
  for (let i = 0; i < argv.length; i++) {
    if (argv[i] === "--deny" && argv[i + 1]) {
      deniedModels.add(argv[i + 1]);
      i++;
    } else {
      args.add(argv[i]);
    }
  }
  return {
    dryRun: args.has("--dry-run"),
    strict: args.has("--strict"),
    explain: args.has("--explain"),
    noReport: args.has("--no-report"),
    openaiOnly: args.has("--openai-only"),
    googleOnly: args.has("--google-only"),
    useProxy: args.has("--use-proxy"),
    keepProxy: args.has("--keep-proxy"),
    deniedModels,
  };
}

function buildProxyBenchmarkRecordList(proxyProposal) {
  const list = [];
  const models = proxyProposal?.models || {};
  for (const [modelId, value] of Object.entries(models)) {
    list.push({
      key: modelId,
      name: value?.name || modelId,
      benchmarks: value?.benchmarks || {},
      proxy: true,
      oneTime: proxyProposal?.one_time === true,
      proxyAlgorithm: value?.algorithm || proxyProposal?.algorithm || null,
      proxySource: proxyProposal?.source || null,
    });
  }
  return list;
}

function consumeProxyProposalFile(proxyPath) {
  if (!proxyPath) return null;
  const dir = path.dirname(proxyPath);
  const base = path.basename(proxyPath);
  const stamp = new Date().toISOString().replace(/[:.]/g, "-");
  const out = path.join(dir, `consumed.${stamp}.${base}`);
  fs.renameSync(proxyPath, out);
  return out;
}

function withLock(lockPath, fn) {
  ensureDirectory(path.dirname(lockPath));
  let fd;
  try {
    fd = fs.openSync(lockPath, "wx");
    return fn();
  } finally {
    if (fd !== undefined) {
      fs.closeSync(fd);
      fs.unlinkSync(lockPath);
    }
  }
}

function normalizeText(value) {
  return String(value || "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function normalizeMetricKey(value) {
  return String(value || "")
    .replace(/[^A-Za-z0-9]+/g, "_")
    .replace(/^_+|_+$/g, "");
}

function buildBenchmarkRecordList(modelBenchmarks) {
  const list = [];
  for (const [recordKey, recordValue] of Object.entries(modelBenchmarks.models || {})) {
    list.push({
      key: recordKey,
      name: recordValue?.name || recordKey,
      benchmarks: recordValue?.benchmarks || {},
    });
  }
  return list;
}

function buildAcceptedBenchmarkRecordList(acceptedBenchmarks) {
  const list = [];
  for (const [modelId, value] of Object.entries(acceptedBenchmarks?.models || {})) {
    list.push({
      key: modelId,
      name: value?.name || modelId,
      benchmarks: value?.benchmarks || {},
      accepted: true,
    });
  }
  return list;
}

function buildAutoAcceptedResearchRecordList(researchProposal) {
  const list = [];
  const patch = researchProposal?.model_benchmark_patch || {};
  for (const [modelId, value] of Object.entries(patch)) {
    if (!value?.autoAccepted) continue;
    list.push({
      key: modelId,
      name: value?.name || modelId,
      benchmarks: value?.benchmarks || {},
      accepted: true,
      source: "auto-accepted-research",
    });
  }
  return list;
}

function tokenizeModelId(modelId) {
  const norm = normalizeText(modelId);
  return new Set(norm.split(" ").filter(Boolean));
}

function scoreTokenOverlap(modelId, recordName) {
  const modelTokens = tokenizeModelId(modelId);
  const nameTokens = new Set(normalizeText(recordName).split(" ").filter(Boolean));
  if (modelTokens.size === 0 || nameTokens.size === 0) return 0;

  let overlap = 0;
  for (const token of modelTokens) {
    if (nameTokens.has(token)) overlap += 1;
  }
  return overlap / modelTokens.size;
}

function resolveBenchmarkRecord(modelId, records) {
  const overrideName = BENCHMARK_NAME_OVERRIDES[modelId];
  if (overrideName) {
    const found = records.find((r) => r.name === overrideName || r.key === overrideName);
    if (found) return found;
  }

  const modelNorm = normalizeText(modelId);
  const exact = records.find((r) => normalizeText(r.key) === modelNorm || normalizeText(r.name) === modelNorm);
  if (exact) return exact;

  let best = null;
  let bestScore = 0;
  for (const record of records) {
    const overlap = scoreTokenOverlap(modelId, `${record.key} ${record.name}`);
    if (overlap > bestScore) {
      bestScore = overlap;
      best = record;
    }
  }
  return bestScore >= 0.45 ? best : null;
}

function buildCandidatePool(currentChain, workingModels, ignoreSet, deniedSet) {
  const ordered = [...currentChain];
  const seen = new Set(ordered);

  for (const modelId of Object.keys(workingModels?.models || {})) {
    if (ignoreSet.has(modelId) || deniedSet.has(modelId)) continue;
    if (!seen.has(modelId)) {
      seen.add(modelId);
      ordered.push(modelId);
    }
  }

  return ordered.filter((modelId) => !ignoreSet.has(modelId) && !deniedSet.has(modelId));
}

function getMetricValue(recordBenchmarks, benchmarkName) {
  const candidates = new Set([
    benchmarkName,
    benchmarkName.replace(/\s+/g, "_"),
    normalizeMetricKey(benchmarkName),
  ]);

  for (const key of candidates) {
    if (Object.prototype.hasOwnProperty.call(recordBenchmarks, key)) {
      const value = recordBenchmarks[key];
      if (value === null || value === undefined || Number.isNaN(Number(value))) return 0;
      return Number(value);
    }
  }
  return 0;
}

function normalizeFormula(formula, benchmarkNames) {
  let normalized = String(formula || "");
  const replacements = new Map();

  for (const rawName of benchmarkNames) {
    const safeName = normalizeMetricKey(rawName);
    const variants = new Set([
      rawName,
      rawName.replace(/\s+/g, "_"),
      rawName.replace(/-/g, "_"),
      safeName,
    ]);
    for (const variant of variants) replacements.set(variant, safeName);
  }

  const sorted = [...replacements.entries()].sort((a, b) => b[0].length - a[0].length);
  for (const [from, to] of sorted) {
    const escaped = from.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
    normalized = normalized.replace(new RegExp(`\\b${escaped}\\b`, "g"), to);
  }
  return normalized;
}

function evaluateFormula(formula, values) {
  const allowed = /^[0-9A-Za-z_+\-*/().\s]+$/;
  if (!allowed.test(formula)) {
    throw new Error(`Formula contains unsupported characters: ${formula}`);
  }
  const argNames = Object.keys(values);
  const argValues = Object.values(values);
  const fn = new Function(...argNames, `return (${formula});`);
  const result = Number(fn(...argValues));
  return Number.isFinite(result) ? result : -Infinity;
}

function computeAgentModelScore(roleConfig, recordBenchmarks, formulaConstants) {
  const benchmarkNames = Object.keys(roleConfig.benchmarks || {});
  const formula = normalizeFormula(roleConfig.scoring_algorithm, benchmarkNames);

  const values = { ...formulaConstants };
  for (const benchmarkName of benchmarkNames) {
    const safeName = normalizeMetricKey(benchmarkName);
    values[safeName] = getMetricValue(recordBenchmarks, benchmarkName);
  }

  return evaluateFormula(formula, values);
}

function isOpenAIModel(modelId) {
  return modelId.startsWith("openai/");
}

function isGoogleModel(modelId) {
  return modelId.startsWith("google/");
}

function getGoogleHealthContext(snapshot) {
  const stage = String(snapshot?.stage || "healthy");
  const unhealthyModels = new Set(snapshot?.unhealthyModels || []);
  return {
    stage,
    unhealthyModels,
    snapshot,
  };
}

function getOpenAIBudgetContext(policy, snapshot) {
  const ratio = Number(snapshot?.remaining_ratio);
  const fiveHourRatio = Number(snapshot?.five_hour_remaining_ratio);
  const weeklyRatio = Number(snapshot?.weekly_remaining_ratio);
  const remainingRatio = Number.isFinite(ratio)
    ? ratio
    : Math.min(Number.isFinite(fiveHourRatio) ? fiveHourRatio : 1, Number.isFinite(weeklyRatio) ? weeklyRatio : 1);
  const healthThresholds = policy?.health_thresholds_pct || {};
  const fiveHourPct = Number.isFinite(fiveHourRatio) ? fiveHourRatio * 100 : Number(snapshot?.usage_limits?.five_hour_remaining_pct);
  const weeklyPct = Number.isFinite(weeklyRatio) ? weeklyRatio * 100 : Number(snapshot?.usage_limits?.weekly_remaining_pct);
  const stageFromPct = (five, weekly) => {
    if (five <= Number(healthThresholds?.critical?.five_hour || 10) || weekly <= Number(healthThresholds?.critical?.weekly || 10)) {
      return "critical";
    }
    if (five <= Number(healthThresholds?.low?.five_hour || 25) || weekly <= Number(healthThresholds?.low?.weekly || 20)) {
      return "low";
    }
    if (five <= Number(healthThresholds?.medium?.five_hour || 50) || weekly <= Number(healthThresholds?.medium?.weekly || 30)) {
      return "medium";
    }
    return "healthy";
  };

  const stage = String(snapshot?.budget_stage || stageFromPct(fiveHourPct, weeklyPct));

  return {
    stage,
    remainingRatio,
    modelCosts: snapshot?.model_costs_usd || {},
    policy,
  };
}

function getModelPricing(modelId, budgetCtx) {
  return budgetCtx?.policy?.model_pricing?.[modelId] || null;
}

function getOpenAIStageCaps(budgetCtx) {
  const policyCaps = budgetCtx?.policy?.openai_stage_caps || {};
  const fallback = {
    healthy: { max_input_per_1m_usd: Infinity, max_output_per_1m_usd: Infinity },
    medium: { max_input_per_1m_usd: 10, max_output_per_1m_usd: 40 },
    low: { max_input_per_1m_usd: 8, max_output_per_1m_usd: 32 },
    critical: { max_input_per_1m_usd: 2, max_output_per_1m_usd: 8 },
  };

  const out = {};
  for (const stage of Object.keys(fallback)) {
    out[stage] = {
      max_input_per_1m_usd: Number(policyCaps?.[stage]?.max_input_per_1m_usd ?? fallback[stage].max_input_per_1m_usd),
      max_output_per_1m_usd: Number(policyCaps?.[stage]?.max_output_per_1m_usd ?? fallback[stage].max_output_per_1m_usd),
    };
  }
  return out;
}

function openAICostScore(modelId, budgetCtx) {
  const pricing = getModelPricing(modelId, budgetCtx);
  if (!pricing) return Number.POSITIVE_INFINITY;
  const inRate = Number(pricing.input_per_1m_usd || 0);
  const outRate = Number(pricing.output_per_1m_usd || 0);
  return inRate + outRate;
}

function selectOpenAIByBudgetStage(rankedModelIds, budgetCtx) {
  const openai = rankedModelIds.filter((id) => isOpenAIModel(id));
  if (openai.length === 0) return null;

  const stage = budgetCtx?.stage || "healthy";
  const caps = getOpenAIStageCaps(budgetCtx);
  const cap = caps[stage] || caps.healthy;

  const withinCap = openai.filter((modelId) => {
    const pricing = getModelPricing(modelId, budgetCtx);
    if (!pricing) return false;
    const inRate = Number(pricing.input_per_1m_usd || 0);
    const outRate = Number(pricing.output_per_1m_usd || 0);
    return inRate <= cap.max_input_per_1m_usd && outRate <= cap.max_output_per_1m_usd;
  });
  if (withinCap.length > 0) return withinCap[0];

  return [...openai].sort((a, b) => {
    const ca = openAICostScore(a, budgetCtx);
    const cb = openAICostScore(b, budgetCtx);
    if (ca !== cb) return ca - cb;
    return rankedModelIds.indexOf(a) - rankedModelIds.indexOf(b);
  })[0];
}

function isHighCostOpenAIModel(modelId, budgetCtx) {
  const pricing = getModelPricing(modelId, budgetCtx);
  if (!pricing) return false;
  const inRate = Number(pricing.input_per_1m_usd || 0);
  const outRate = Number(pricing.output_per_1m_usd || 0);
  const p = budgetCtx.policy || {};
  return (
    inRate >= Number(p.high_cost_input_per_1m_usd || 10) ||
    outRate >= Number(p.high_cost_output_per_1m_usd || 30)
  );
}

function applyOpenAIBudgetPenalty(agentKey, modelId, score, budgetCtx) {
  if (!isOpenAIModel(modelId)) return score;

  const stage = budgetCtx?.stage || "healthy";
  const stageConfig = budgetCtx?.policy?.stage_multipliers?.[stage] || { default: 1, high_cost: 1 };
  const agentWeight = Number(budgetCtx?.policy?.agent_budget_weight?.[agentKey] || 1);
  const highCost = isHighCostOpenAIModel(modelId, budgetCtx);

  const baseMultiplier = Number(highCost ? stageConfig.high_cost : stageConfig.default);
  const conservativeMultiplier = Math.max(Math.min(baseMultiplier * agentWeight, 1), 0);
  return score * conservativeMultiplier;
}

function applyGoogleHealthPenalty(modelId, score, googleCtx, options) {
  if (!isGoogleModel(modelId)) return score;

  const stage = googleCtx?.stage || "healthy";
  const multipliers = options.googleOnly
    ? { healthy: 1, medium: 0.8, low: 0.35, critical: 0.05 }
    : { healthy: 1, medium: 0.92, low: 0.7, critical: 0.35 };
  const factor = Number(multipliers[stage] ?? 1);
  return score * Math.max(Math.min(factor, 1), 0);
}

function getFormulaConstants(benchCalc) {
  const constants = { MAX_CONTEXT_LENGTH: DEFAULT_MAX_CONTEXT_LENGTH };
  const source = benchCalc?.constants || {};
  for (const [key, value] of Object.entries(source)) {
    const n = Number(value);
    if (Number.isFinite(n)) constants[key] = n;
  }
  if (!Number.isFinite(constants.MAX_CONTEXT_LENGTH) || constants.MAX_CONTEXT_LENGTH <= 0) {
    constants.MAX_CONTEXT_LENGTH = DEFAULT_MAX_CONTEXT_LENGTH;
  }
  return constants;
}

function validateRoleConfig(roleName, roleConfig) {
  if (!roleConfig || typeof roleConfig !== "object") {
    throw new Error(`Missing role configuration: ${roleName}`);
  }
  if (!roleConfig.benchmarks || !roleConfig.scoring_algorithm) {
    throw new Error(`Invalid role configuration: ${roleName}`);
  }
  let weightSum = 0;
  for (const benchmarkDef of Object.values(roleConfig.benchmarks)) {
    const weight = Number(benchmarkDef?.weight);
    if (!Number.isFinite(weight)) throw new Error(`Invalid weight in role: ${roleName}`);
    weightSum += weight;
  }
  if (Math.abs(weightSum - 1) > 0.001) {
    throw new Error(`Weights for ${roleName} must sum to 1.0 (actual=${weightSum})`);
  }
}

function isAnthropic(modelId) {
  return modelId.startsWith("anthropic/") || modelId.includes("/anthropic/");
}

function isLocal(modelId) {
  return modelId.startsWith("lmstudio-local/");
}

function isReservedBridgeModel(modelId) {
  return modelId === RESERVED_FREE_BRIDGE_MODEL;
}

function enforceChainConstraints(agentKey, chain, selectedOpenAI = null) {
  let filtered = [...chain];
  filtered = filtered.filter((modelId) => !isAnthropic(modelId));

  filtered = filtered.filter((modelId) => !isReservedBridgeModel(modelId));

  if (selectedOpenAI) {
    filtered = filtered.filter((modelId) => !isOpenAIModel(modelId) || modelId === selectedOpenAI);
  } else {
    filtered = filtered.filter((modelId) => !isOpenAIModel(modelId));
  }

  const locals = filtered.filter(isLocal);
  filtered = filtered.filter((modelId) => !isLocal(modelId));
  if (locals.length > 0) {
    filtered.push(RESERVED_FREE_BRIDGE_MODEL);
    filtered.push(locals[0]);
  }

  if (agentKey === "fixer") {
    filtered = filtered.filter((modelId) => modelId !== "anthropic/claude-opus-4-6");
    filtered.unshift("anthropic/claude-opus-4-6");
  }
  return [...new Set(filtered)];
}

function optimize(
  theseus,
  benchCalc,
  modelBenchmarks,
  workingModels,
  acceptedBenchmarks,
  autoAcceptedResearch,
  proxyProposal,
  ignoreList,
  openaiBudgetCtx,
  googleHealthCtx,
  options
) {
  const benchmarkRecords = [
    ...buildBenchmarkRecordList(modelBenchmarks),
    ...buildAcceptedBenchmarkRecordList(acceptedBenchmarks),
    ...buildAutoAcceptedResearchRecordList(autoAcceptedResearch),
    ...(options.useProxy ? buildProxyBenchmarkRecordList(proxyProposal) : []),
  ];
  const formulaConstants = getFormulaConstants(benchCalc);
  const ignoreSet = new Set(Object.keys(ignoreList?.ignored_models || {}));
  const deniedSet = options.deniedModels || new Set();

  const updates = {};
  const strictFailures = [];

  for (const [agentKey, roleName] of Object.entries(AGENT_ROLE_MAP)) {
    const roleConfig = benchCalc?.model_selection_benchmarks?.[roleName];
    validateRoleConfig(roleName, roleConfig);

    const currentChain = [...(theseus?.agents?.[agentKey]?.models || [])];
    if (currentChain.length === 0) continue;
    const candidatePool = buildCandidatePool(currentChain, workingModels, ignoreSet, deniedSet);

    const workingSet = new Set(Object.keys(workingModels.models || {}));
    const scored = [];
    const unscored = [];
    const exemptUnscored = [];

    for (const modelId of candidatePool) {
      if (isReservedBridgeModel(modelId)) {
        exemptUnscored.push({ modelId, reason: "reserved-bridge", isVerified: true });
        continue;
      }

      const isVerified = workingSet.has(modelId);
      if (options.googleOnly && isGoogleModel(modelId) && googleHealthCtx.unhealthyModels.has(modelId)) {
        unscored.push({ modelId, reason: "google-health-failed", isVerified });
        continue;
      }
      const record = resolveBenchmarkRecord(modelId, benchmarkRecords);
      if (!record) {
        unscored.push({ modelId, reason: "no-benchmark-match", isVerified });
        continue;
      }

      const score = computeAgentModelScore(roleConfig, record.benchmarks, formulaConstants);
      if (!Number.isFinite(score) || score === -Infinity) {
        unscored.push({ modelId, reason: "score-error", isVerified });
        continue;
      }
      const adjustedScore = applyOpenAIBudgetPenalty(agentKey, modelId, score, openaiBudgetCtx);
      const finalScore = applyGoogleHealthPenalty(modelId, adjustedScore, googleHealthCtx, options);
      scored.push({
        modelId,
        score: finalScore,
        rawScore: score,
        isVerified,
        synthetic: false,
      });
    }

    scored.sort((a, b) => {
      if (b.score !== a.score) return b.score - a.score;
      if (a.isVerified !== b.isVerified) return a.isVerified ? -1 : 1;
      return a.modelId.localeCompare(b.modelId);
    });

    const ranked = scored.map((m) => m.modelId);

    let rankingForChain = ranked;
    if (options.googleOnly) {
      const selectedGoogle = ranked.find((modelId) => isGoogleModel(modelId)) || null;
      if (selectedGoogle) {
        rankingForChain = ranked.filter((modelId) => !isGoogleModel(modelId) || modelId === selectedGoogle);
      } else {
        rankingForChain = ranked.filter((modelId) => !isGoogleModel(modelId));
      }
    }

    const selectedOpenAI = selectOpenAIByBudgetStage(rankingForChain, openaiBudgetCtx);

    const result = {
      scored,
      unscored,
      chain: enforceChainConstraints(agentKey, rankingForChain, selectedOpenAI),
    };

    if (!theseus.agents[agentKey]) continue;
    theseus.agents[agentKey].models = result.chain;
    if (result.chain.length > 0) {
      theseus.agents[agentKey].model = result.chain[0];
      if (theseus?.fallback?.currentModels) {
        theseus.fallback.currentModels[agentKey] = result.chain[0];
      }
    }

    if (options.strict && result.scored.length === 0) {
      strictFailures.push(`${agentKey}: zero scored models`);
    }
    const blockingUnscored = options.googleOnly
      ? result.unscored.filter((m) => m.reason !== "google-health-failed")
      : result.unscored;

    if (options.strict && blockingUnscored.length > 0) {
      strictFailures.push(`${agentKey}: ${blockingUnscored.length} models missing benchmark coverage`);
    }

    updates[agentKey] = {
      primary: result.chain[0],
      scoredCount: result.scored.length,
      unscoredCount: result.unscored.length,
      chainLength: result.chain.length,
      topScores: result.scored.slice(0, 5),
      unmatched: result.unscored,
      exemptUnscored,
      selectedOpenAI,
    };
  }

  if (strictFailures.length > 0) {
    throw new Error(`Strict mode failed: ${strictFailures.join("; ")}`);
  }
  return updates;
}

function printExplain(updates) {
  for (const [agent, info] of Object.entries(updates)) {
    console.log(`\n[${agent}]`);
    for (const row of info.topScores) {
      console.log(`  ${row.modelId} -> ${row.score.toFixed(6)} (${row.isVerified ? "verified" : "unverified"})`);
    }
    if (info.unmatched.length > 0) {
      console.log(`  unmatched=${info.unmatched.length}`);
    }
  }
}

function buildProposal(beforeTheseus, afterTheseus, updates) {
  const agents = {};
  for (const agent of Object.keys(updates)) {
    agents[agent] = {
      oldPrimary: beforeTheseus?.agents?.[agent]?.model,
      newPrimary: afterTheseus?.agents?.[agent]?.model,
      oldChain: beforeTheseus?.agents?.[agent]?.models || [],
      newChain: afterTheseus?.agents?.[agent]?.models || [],
    };
  }

  return {
    timestamp: new Date().toISOString(),
    target: PATHS.theseus,
    summary: updates,
    agents,
  };
}

function main() {
  const options = parseArgs(process.argv.slice(2));

  const benchCalc = loadJson(PATHS.benchCalc);
  const modelBenchmarks = loadJson(PATHS.modelBenchmarks);
  const latestWorkingProposal = latestFile(PATHS.proposalDir, "working_models.");
  const workingModels = latestWorkingProposal
    ? loadOptionalJson(latestWorkingProposal, loadJson(PATHS.workingModels))
    : loadJson(PATHS.workingModels);
  const acceptedBenchmarks = loadOptionalJson(PATHS.acceptedBenchmarks, { models: {} });
  const latestResearchProposal = latestFile(PATHS.proposalDir, "benchmark-research.");
  const autoAcceptedResearch = latestResearchProposal
    ? loadOptionalJson(latestResearchProposal, null)
    : null;
  const ignoreList = loadOptionalJson(PATHS.ignoreList, { ignored_models: {} });
  const researchProposal = getLatestResearchProposal(PATHS.proposalDir);
  const latestProxyProposalPath = options.useProxy ? latestFile(PATHS.proposalDir, "benchmark-proxy.") : null;
  const proxyProposal = latestProxyProposalPath ? loadOptionalJson(latestProxyProposalPath, null) : null;
  const proxyCoveredModels = new Set(Object.keys(proxyProposal?.models || {}));
  if (options.useProxy) {
    if (!proxyProposal) {
      throw new Error("--use-proxy specified but no benchmark-proxy.*.json found in proposals/");
    }
    if (proxyProposal.one_time !== true) {
      throw new Error("Proxy proposal must include one_time=true for safety");
    }

    if (!researchProposal) {
      throw new Error("--use-proxy requires a latest benchmark-research.*.json proposal. Run research/interview first.");
    }

    const patch = researchProposal?.model_benchmark_patch || {};
    const researched = new Set([...(researchProposal?.unresolved || []), ...Object.keys(patch)]);
    for (const modelId of proxyCoveredModels) {
      if (!researched.has(modelId)) {
        throw new Error(
          `Proxy model not present in latest benchmark research proposal: ${modelId}. ` +
            "Research must be done first; proxies are one-time and only allowed for researched missing-coverage models."
        );
      }
    }
  }

  assertResearchGateResolved(options, acceptedBenchmarks, ignoreList, researchProposal, proxyCoveredModels);
  const openaiBudgetPolicy = loadOptionalJson(PATHS.openaiBudgetPolicy, {
    monthly_allowance_usd: 0,
    thresholds: { medium: 0.6, low: 0.35, critical: 0.15 },
    stage_multipliers: {
      healthy: { default: 1, high_cost: 1 },
      medium: { default: 0.95, high_cost: 0.85 },
      low: { default: 0.7, high_cost: 0.45 },
      critical: { default: 0.35, high_cost: 0.08 },
    },
    model_pricing: {},
    agent_budget_weight: {},
  });
  const latestBudgetPath = latestFile(PATHS.proposalDir, "openai-budget.");
  const openaiBudgetSnapshot = latestBudgetPath
    ? loadOptionalJson(latestBudgetPath, null)
    : null;
  const openaiBudgetCtx = getOpenAIBudgetContext(openaiBudgetPolicy, openaiBudgetSnapshot);
  const latestGoogleHealthPath = latestFile(PATHS.proposalDir, "google-health.");
  const googleHealthSnapshot = latestGoogleHealthPath
    ? loadOptionalJson(latestGoogleHealthPath, null)
    : null;
  const googleHealthCtx = getGoogleHealthContext(googleHealthSnapshot);
  const theseus = loadJson(PATHS.theseus);
  const beforeTheseus = JSON.parse(JSON.stringify(theseus));

  const updates = optimize(
    theseus,
    benchCalc,
    modelBenchmarks,
    workingModels,
    acceptedBenchmarks,
    autoAcceptedResearch,
    proxyProposal,
    ignoreList,
    openaiBudgetCtx,
    googleHealthCtx,
    options
  );

  console.log("Optimized agents:");
  for (const [agent, info] of Object.entries(updates)) {
    console.log(
      `- ${agent}: primary=${info.primary} scored=${info.scoredCount} unscored=${info.unscoredCount} chain=${info.chainLength}`
    );
  }

  if (options.explain) {
    printExplain(updates);
  }

  if (!options.noReport) {
    const reportPath = writeRunReport({
      timestamp: new Date().toISOString(),
      options,
      workingModelsSource: latestWorkingProposal || PATHS.workingModels,
      acceptedBenchmarksCount: Object.keys(acceptedBenchmarks.models || {}).length,
      autoAcceptedResearchCount: buildAutoAcceptedResearchRecordList(autoAcceptedResearch).length,
      ignoredModelsCount: Object.keys(ignoreList.ignored_models || {}).length,
      deniedModelsCount: options.deniedModels.size,
      proxy: {
        enabled: options.useProxy,
        source: latestProxyProposalPath,
        modelsCount: Object.keys(proxyProposal?.models || {}).length,
        algorithm: proxyProposal?.algorithm || null,
        oneTime: proxyProposal?.one_time === true,
      },
      openaiBudget: {
        latestProposal: latestBudgetPath,
        stage: openaiBudgetCtx.stage,
        remainingRatio: openaiBudgetCtx.remainingRatio,
      },
      googleHealth: {
        latestProposal: latestGoogleHealthPath,
        stage: googleHealthCtx.stage,
        unhealthyCount: googleHealthCtx.unhealthyModels.size,
      },
      updates,
    });
    console.log(`Report written: ${reportPath}`);
  }

  const proposalPath = writeProposal(buildProposal(beforeTheseus, theseus, updates));
  console.log(`Proposal written: ${proposalPath}`);

  if (options.useProxy && latestProxyProposalPath && !options.keepProxy) {
    const consumedPath = consumeProxyProposalFile(latestProxyProposalPath);
    console.log(`Proxy proposal consumed: ${consumedPath}`);
  }

  console.log("No config write performed. Skill is proposal-only by design.");
}

try {
  withLock(PATHS.lock, main);
} catch (error) {
  console.error("Optimizer failed:", error.message);
  process.exit(1);
}
