/**
 * update-agent-models guard
 *
 * Validates invariants so future edits do not silently break the skill.
 *
 * Usage:
 *   node skills/update-agent-models/guard.js
 *   node skills/update-agent-models/guard.js --strict
 */

const fs = require("fs");
const path = require("path");

const SKILL_DIR = __dirname;
const ROOT_DIR = path.resolve(SKILL_DIR, "..", "..");

const FILES = {
  benchCalc: path.join(SKILL_DIR, "bench_calc.json"),
  skillMd: path.join(SKILL_DIR, "SKILL.md"),
  optimize: path.join(SKILL_DIR, "optimize.js"),
  testModels: path.join(SKILL_DIR, "test-models.sh"),
  acceptedBenchmarks: path.join(SKILL_DIR, "benchmark_manual_accepted.json"),
  ignoreList: path.join(SKILL_DIR, "model_ignore_list.json"),
  openaiBudgetPolicy: path.join(SKILL_DIR, "openai_budget_policy.json"),
  openaiLimitsManual: path.join(SKILL_DIR, "openai_limits_manual.json"),
  openaiBudget: path.join(SKILL_DIR, "openai-budget.js"),
  researchBenchmarks: path.join(SKILL_DIR, "research-benchmarks.js"),
  applyAutoAccepted: path.join(SKILL_DIR, "apply-auto-accepted.js"),
  nextInterview: path.join(SKILL_DIR, "next-interview.js"),
  workflow: path.join(SKILL_DIR, "run-workflow.js"),
  status: path.join(SKILL_DIR, "status.js"),
  prune: path.join(SKILL_DIR, "prune-artifacts.js"),
  suggestUnmatched: path.join(SKILL_DIR, "suggest-unmatched.js"),
  workingModels: path.join(SKILL_DIR, "working_models.json"),
  opencode: path.join(ROOT_DIR, "opencode.json"),
  theseus: path.join(ROOT_DIR, "oh-my-opencode-theseus.json"),
};

const FORBIDDEN_FILES = [
  path.join(SKILL_DIR, "candidate_models.json"),
  path.join(SKILL_DIR, "model_resolution.json"),
  path.join(SKILL_DIR, "apply-proposal.js"),
];

const REQUIRED_ROLES = [
  "Orchestrator",
  "Oracle",
  "Explorer",
  "Librarian",
  "Designer",
  "Fixer",
  "Builder",
];

const REQUIRED_AGENTS = [
  "orchestrator",
  "oracle",
  "explorer",
  "librarian",
  "designer",
  "fixer",
];

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function assert(condition, message) {
  if (!condition) throw new Error(message);
}

function normalizeMetricKey(value) {
  return String(value || "")
    .replace(/[^A-Za-z0-9]+/g, "_")
    .replace(/^_+|_+$/g, "");
}

function getFormulaSymbols(formula) {
  const matches = String(formula || "").match(/[A-Za-z_][A-Za-z0-9_]*/g) || [];
  return [...new Set(matches)];
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
    for (const variant of variants) {
      replacements.set(variant, safeName);
    }
  }

  const sorted = [...replacements.entries()].sort((a, b) => b[0].length - a[0].length);
  for (const [from, to] of sorted) {
    const escaped = from.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
    normalized = normalized.replace(new RegExp(`\\b${escaped}\\b`, "g"), to);
  }

  return normalized;
}

function validateFilesExist() {
  for (const [name, filePath] of Object.entries(FILES)) {
    assert(fs.existsSync(filePath), `Missing required file (${name}): ${filePath}`);
  }
}

function validateBenchCalc() {
  const benchCalc = readJson(FILES.benchCalc);
  const roles = benchCalc?.model_selection_benchmarks || {};
  const constants = benchCalc?.constants || {};

  for (const [key, value] of Object.entries(constants)) {
    assert(Number.isFinite(Number(value)), `bench_calc.json constant ${key} must be numeric`);
  }

  for (const role of REQUIRED_ROLES) {
    assert(roles[role], `bench_calc.json missing role: ${role}`);
    const roleConfig = roles[role];
    const benchmarks = roleConfig.benchmarks || {};
    const formula = roleConfig.scoring_algorithm;
    assert(Object.keys(benchmarks).length > 0, `Role ${role} has no benchmarks`);
    assert(typeof formula === "string" && formula.length > 0, `Role ${role} missing scoring_algorithm`);

    let weightSum = 0;
    const allowedSymbols = new Set(Object.keys(constants));

    for (const [benchmarkName, benchmarkDef] of Object.entries(benchmarks)) {
      const weight = Number(benchmarkDef?.weight);
      assert(Number.isFinite(weight), `Role ${role} benchmark ${benchmarkName} has invalid weight`);
      weightSum += weight;
      allowedSymbols.add(normalizeMetricKey(benchmarkName));
    }

    assert(Math.abs(weightSum - 1) < 0.001, `Role ${role} weights must sum to 1.0 (actual: ${weightSum})`);

    const normalizedFormula = normalizeFormula(formula, Object.keys(benchmarks));
    const symbols = getFormulaSymbols(normalizedFormula);
    for (const symbol of symbols) {
      if (allowedSymbols.has(symbol)) continue;
      // Skip numeric-like residue and common function placeholders (none expected).
      assert(false, `Role ${role} formula references unsupported symbol: ${symbol}`);
    }
  }
}

function validateForbiddenFilesAbsent() {
  for (const filePath of FORBIDDEN_FILES) {
    assert(!fs.existsSync(filePath), `Forbidden file present: ${filePath}`);
  }
}

function validateOpenAIBudgetPolicy() {
  const policy = readJson(FILES.openaiBudgetPolicy);
  assert(Number.isFinite(Number(policy?.monthly_allowance_usd)), "openai budget monthly_allowance_usd must be numeric");
  for (const k of ["medium", "low", "critical"]) {
    assert(Number.isFinite(Number(policy?.thresholds?.[k])), `openai budget threshold ${k} must be numeric`);
  }
  for (const stage of ["critical", "low", "medium"]) {
    assert(
      Number.isFinite(Number(policy?.health_thresholds_pct?.[stage]?.five_hour)),
      `openai budget health_thresholds_pct.${stage}.five_hour must be numeric`
    );
    assert(
      Number.isFinite(Number(policy?.health_thresholds_pct?.[stage]?.weekly)),
      `openai budget health_thresholds_pct.${stage}.weekly must be numeric`
    );
  }
  for (const stage of ["healthy", "medium", "low", "critical"]) {
    const caps = policy?.openai_stage_caps?.[stage] || {};
    assert(
      Number.isFinite(Number(caps.max_input_per_1m_usd)),
      `openai budget openai_stage_caps.${stage}.max_input_per_1m_usd must be numeric`
    );
    assert(
      Number.isFinite(Number(caps.max_output_per_1m_usd)),
      `openai budget openai_stage_caps.${stage}.max_output_per_1m_usd must be numeric`
    );
  }
  assert(typeof policy?.model_pricing === "object", "openai budget model_pricing must be object");
}

function validateAcceptedBenchmarks() {
  const accepted = readJson(FILES.acceptedBenchmarks);
  const models = accepted?.models || {};
  assert(typeof models === "object", "benchmark_manual_accepted models must be object");

  for (const [modelId, def] of Object.entries(models)) {
    assert(typeof modelId === "string" && modelId.includes("/"), `Invalid accepted model id: ${modelId}`);
    assert(def && typeof def === "object", `Accepted model ${modelId} must be object`);
    assert(def.acceptedByUser === true, `Accepted model ${modelId} must include acceptedByUser=true`);
    assert(typeof def.acceptedAt === "string" && def.acceptedAt.length > 0, `Accepted model ${modelId} missing acceptedAt`);
    assert(Array.isArray(def.sources) && def.sources.length > 0, `Accepted model ${modelId} missing sources[]`);
    assert(def.benchmarks && typeof def.benchmarks === "object", `Accepted model ${modelId} missing benchmarks`);
    for (const [k, v] of Object.entries(def.benchmarks)) {
      assert(Number.isFinite(Number(v)), `Accepted model ${modelId} benchmark ${k} must be numeric`);
    }
  }
}

function validateIgnoreList() {
  const ignore = readJson(FILES.ignoreList);
  const models = ignore?.ignored_models || {};
  assert(typeof models === "object", "model_ignore_list ignored_models must be object");

  const proposalsDir = path.join(ROOT_DIR, "skills", "update-agent-models", "proposals");
  const researchFiles = fs.existsSync(proposalsDir)
    ? fs.readdirSync(proposalsDir).filter((f) => f.startsWith("benchmark-research.") && f.endsWith(".json"))
    : [];
  const allUnresolved = new Set();
  for (const file of researchFiles) {
    const proposal = readJson(path.join(proposalsDir, file));
    for (const m of proposal?.unresolved || []) {
      allUnresolved.add(m);
    }
  }

  for (const [modelId, def] of Object.entries(models)) {
    assert(typeof modelId === "string" && modelId.includes("/"), `Invalid ignored model id: ${modelId}`);
    assert(def && typeof def === "object", `Ignored model ${modelId} must be object`);
    assert(typeof def.reason === "string" && def.reason.length > 0, `Ignored model ${modelId} missing reason`);
    assert(def.addedByUser === true, `Ignored model ${modelId} must include addedByUser=true`);
    assert(typeof def.addedAt === "string" && def.addedAt.length > 0, `Ignored model ${modelId} missing addedAt`);
    assert(allUnresolved.has(modelId), `Ignored model ${modelId} must have been in a research proposal's unresolved list`);
  }
}

function validateOpenAIManualLimits() {
  if (!fs.existsSync(FILES.openaiLimitsManual)) return;
  const limits = readJson(FILES.openaiLimitsManual);
  const five = Number(limits?.five_hour_remaining_pct);
  const weekly = Number(limits?.weekly_remaining_pct);
  assert(Number.isFinite(five), "openai_limits_manual five_hour_remaining_pct must be numeric");
  assert(Number.isFinite(weekly), "openai_limits_manual weekly_remaining_pct must be numeric");
  assert(five >= 0 && five <= 100, "openai_limits_manual five_hour_remaining_pct must be 0-100");
  assert(weekly >= 0 && weekly <= 100, "openai_limits_manual weekly_remaining_pct must be 0-100");
}

function validateNoLegacyPathRefs() {
  const filesToCheck = [FILES.skillMd, FILES.optimize, FILES.testModels, FILES.workingModels];
  for (const filePath of filesToCheck) {
    const text = fs.readFileSync(filePath, "utf8");
    assert(!text.includes("skills/agents-config"), `Legacy path found in ${filePath}`);
  }
}

function validateProposalOnlyScripts() {
  const optimizeText = fs.readFileSync(FILES.optimize, "utf8");
  const testModelsText = fs.readFileSync(FILES.testModels, "utf8");
  const workflowText = fs.readFileSync(FILES.workflow, "utf8");
  const forbidden = [
    "saveJson(PATHS.theseus",
    "fs.writeFileSync(PATHS.theseus",
    "copyFileSync(PATHS.theseus",
    "--apply",
    "apply-proposal",
  ];
  for (const token of forbidden) {
    assert(!optimizeText.includes(token), `Proposal-only violation in optimize.js: ${token}`);
  }

  assert(!workflowText.includes("--apply"), "Proposal-only violation in run-workflow.js: --apply");
  assert(!workflowText.includes("apply-proposal"), "Proposal-only violation in run-workflow.js: apply-proposal");

  const forbiddenPatterns = [
    /OUTPUT_FILE=.*working_models\.json/,
    />\s*"?[^"]*oh-my-opencode-theseus\.json"?/,
    />\s*"?[^"]*opencode\.json"?/,
  ];
  for (const pattern of forbiddenPatterns) {
    assert(!pattern.test(testModelsText), `Proposal-only violation in test-models.sh: ${pattern}`);
  }
}

function validateHardNoConfigWrites() {
  const scriptFiles = fs
    .readdirSync(SKILL_DIR)
    .filter((name) => name.endsWith(".js") || name.endsWith(".sh"))
    .filter((name) => name !== "guard.js")
    .map((name) => path.join(SKILL_DIR, name));

  const forbiddenWritePatterns = [
    /saveJson\(PATHS\.theseus/i,
    /fs\.writeFileSync\([^\n\r]*oh-my-opencode-theseus\.json/i,
    /fs\.writeFileSync\([^\n\r]*opencode\.json/i,
    /fs\.writeFileSync\([^\n\r]*working_models\.json/i,
    /fs\.writeFileSync\([^\n\r]*benchmark_manual_accepted\.json/i,
    /fs\.writeFileSync\([^\n\r]*model_ignore_list\.json/i,
    />\s*"?[^"]*oh-my-opencode-theseus\.json"?/i,
    />\s*"?[^"]*opencode\.json"?/i,
    />\s*"?[^"]*working_models\.json"?/i,
    />\s*"?[^"]*benchmark_manual_accepted\.json"?/i,
    />\s*"?[^"]*model_ignore_list\.json"?/i,
    /copyFileSync\([^\n\r]*oh-my-opencode-theseus\.json/i,
  ];

  const forbiddenCreationPatterns = [
    /apply-proposal\.js/i,
    /--apply\b/i,
  ];

  for (const scriptPath of scriptFiles) {
    const text = fs.readFileSync(scriptPath, "utf8");
    for (const pattern of forbiddenWritePatterns) {
      assert(!pattern.test(text), `Hard constraint violation in ${scriptPath}: ${pattern}`);
    }
    for (const pattern of forbiddenCreationPatterns) {
      assert(!pattern.test(text), `Hard constraint violation in ${scriptPath}: ${pattern}`);
    }
  }
}

function validateIgnoreListGovernance() {
  const skillText = fs.readFileSync(FILES.skillMd, "utf8");
  const researchText = fs.readFileSync(FILES.researchBenchmarks, "utf8");
  const interviewText = fs.readFileSync(FILES.nextInterview, "utf8");
  const ignoreText = fs.readFileSync(FILES.ignoreList, "utf8");

  assert(
    /explicit user approval/i.test(skillText),
    "SKILL.md must explicitly require user approval for ignore-list updates"
  );
  assert(
    /must never auto-add/i.test(interviewText),
    "next-interview.js must explicitly ban auto-adding ignore-list entries"
  );
  assert(
    /must never be auto-applied/i.test(researchText),
    "research-benchmarks.js must explicitly ban auto-applied ignore-list updates"
  );
  assert(
    /USER DECISION REQUIRED/.test(ignoreText),
    "model_ignore_list.json warning must mark ignore-list updates as user-decision-required"
  );
}

function validateNoAAInferenceArtifacts() {
  const forbiddenPrefix = "artificial-analysis/";
  const forbiddenExact = new Set(["free/openrouter/free"]);
  const working = readJson(FILES.workingModels);
  for (const modelId of Object.keys(working?.models || {})) {
    assert(!String(modelId).startsWith(forbiddenPrefix), `Forbidden AA model id in working_models.json: ${modelId}`);
    assert(!forbiddenExact.has(String(modelId)), `Forbidden pseudo model id in working_models.json: ${modelId}`);
  }

  const proposalsDir = path.join(ROOT_DIR, "skills", "update-agent-models", "proposals");
  if (!fs.existsSync(proposalsDir)) return;

  const proposalFiles = fs
    .readdirSync(proposalsDir)
    .filter((f) => (f.startsWith("working_models.") || f.startsWith("benchmark-research.")) && f.endsWith(".json"));

  for (const file of proposalFiles) {
    const proposal = readJson(path.join(proposalsDir, file));
    for (const modelId of Object.keys(proposal?.models || {})) {
      assert(!String(modelId).startsWith(forbiddenPrefix), `Forbidden AA model id in proposal ${file}: ${modelId}`);
      assert(!forbiddenExact.has(String(modelId)), `Forbidden pseudo model id in proposal ${file}: ${modelId}`);
    }
    for (const modelId of Object.keys(proposal?.model_benchmark_patch || {})) {
      assert(!String(modelId).startsWith(forbiddenPrefix), `Forbidden AA model id in proposal ${file}: ${modelId}`);
      assert(!forbiddenExact.has(String(modelId)), `Forbidden pseudo model id in proposal ${file}: ${modelId}`);
    }
    for (const modelId of proposal?.unresolved || []) {
      assert(!String(modelId).startsWith(forbiddenPrefix), `Forbidden AA model id in proposal ${file}: ${modelId}`);
      assert(!forbiddenExact.has(String(modelId)), `Forbidden pseudo model id in proposal ${file}: ${modelId}`);
    }
  }
}

function validateDocsSecrets() {
  const docFiles = [FILES.skillMd, path.join(SKILL_DIR, "research_gripes.md")];
  const secretPattern = /(sk-[A-Za-z0-9_-]{10,}|gsk_[A-Za-z0-9_-]{10,}|AIza[0-9A-Za-z_-]{10,}|aa_[A-Za-z0-9_-]{10,}|csk-[A-Za-z0-9_-]{10,})/;
  for (const filePath of docFiles) {
    if (!fs.existsSync(filePath)) continue;
    const text = fs.readFileSync(filePath, "utf8");
    assert(!secretPattern.test(text), `Potential hardcoded secret in docs: ${filePath}`);
  }
}

function validateAAProvider() {
  const opencode = readJson(FILES.opencode);
  const aa = opencode?.provider?.["artificial-analysis"];
  assert(aa, "opencode.json missing provider.artificial-analysis");
  assert(aa?.options?.baseURL, "provider.artificial-analysis missing options.baseURL");
  assert(
    aa?.options?.apiKey === "{env:ARTIFICIAL_ANALYSIS_API_KEY}",
    "provider.artificial-analysis apiKey must be {env:ARTIFICIAL_ANALYSIS_API_KEY}"
  );
}

function validateTheseusConstraints() {
  const theseus = readJson(FILES.theseus);
  const reservedBridge = "free/openrouter/free";
  for (const agent of REQUIRED_AGENTS) {
    assert(theseus?.agents?.[agent], `theseus missing agent config: ${agent}`);
    const models = theseus.agents[agent].models || [];
    assert(Array.isArray(models) && models.length > 0, `Agent ${agent} has empty models chain`);
    if (agent !== "fixer") {
      assert(!models.some((m) => String(m).startsWith("anthropic/")), `Agent ${agent} must not include anthropic models`);
    }

    const localIndex = models.findIndex((m) => String(m).startsWith("lmstudio-local/"));
    if (localIndex >= 0) {
      assert(localIndex > 0, `Agent ${agent} local model must not be first`);
      const bridgeIndex = models.findIndex((m) => m === reservedBridge);
      assert(bridgeIndex >= 0, `Agent ${agent} must include ${reservedBridge} when local model is present`);
      assert(bridgeIndex < localIndex, `Agent ${agent} must place ${reservedBridge} before local model`);
    }
  }

  assert(
    theseus?.agents?.fixer?.currentModel === "anthropic/claude-opus-4-6",
    "Fixer primary must be anthropic/claude-opus-4-6"
  );
}

function run() {
  const strict = process.argv.includes("--strict");
  const checks = [
    ["required-files", validateFilesExist],
    ["forbidden-files", validateForbiddenFilesAbsent],
    ["bench-calc", validateBenchCalc],
    ["openai-budget-policy", validateOpenAIBudgetPolicy],
    ["accepted-benchmarks", validateAcceptedBenchmarks],
    ["ignore-list", validateIgnoreList],
    ["openai-manual-limits", validateOpenAIManualLimits],
    ["path-refs", validateNoLegacyPathRefs],
    ["proposal-only", validateProposalOnlyScripts],
    ["hard-no-config-writes", validateHardNoConfigWrites],
    ["ignore-governance", validateIgnoreListGovernance],
    ["no-aa-inference-artifacts", validateNoAAInferenceArtifacts],
    ["docs-secrets", validateDocsSecrets],
    ["aa-provider", validateAAProvider],
    ["theseus-constraints", validateTheseusConstraints],
  ];

  const warnings = [];
  for (const [name, fn] of checks) {
    try {
      fn();
      console.log(`PASS ${name}`);
    } catch (error) {
      if (!strict && name === "theseus-constraints") {
        warnings.push(`${name}: ${error.message}`);
        console.log(`WARN ${name} - ${error.message}`);
      } else {
        throw error;
      }
    }
  }

  if (warnings.length > 0) {
    console.log("Guard completed with warnings:");
    for (const warning of warnings) {
      console.log(`- ${warning}`);
    }
  } else {
    console.log("Guard completed successfully.");
  }
}

try {
  run();
} catch (error) {
  console.error(`GUARD FAILED: ${error.message}`);
  process.exit(1);
}
