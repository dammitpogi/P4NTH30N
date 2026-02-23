/**
 * next-interview.js
 *
 * Produces one-at-a-time interview prompt from latest benchmark research proposal.
 * Exits with code 2 when user decision is required.
 * Exits 0 when no interview is pending.
 */

const fs = require("fs");
const path = require("path");

const SKILL_DIR = __dirname;
const PROPOSAL_DIR = path.join(SKILL_DIR, "proposals");
const ACCEPTED_PATH = path.join(SKILL_DIR, "benchmark_manual_accepted.json");
const IGNORE_PATH = path.join(SKILL_DIR, "model_ignore_list.json");
const INTERVIEW_MIN_CONFIDENCE = 0.65;

function loadJson(filePath) {
  if (!fs.existsSync(filePath)) return {};
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function latestResearchProposal() {
  if (!fs.existsSync(PROPOSAL_DIR)) return null;
  const files = fs
    .readdirSync(PROPOSAL_DIR)
    .filter((f) => f.startsWith("benchmark-research.") && f.endsWith(".json"))
    .sort();
  return files.length > 0 ? path.join(PROPOSAL_DIR, files[files.length - 1]) : null;
}

function asNumber(value, fallback = 0) {
  const n = Number(value);
  return Number.isFinite(n) ? n : fallback;
}

function topBenchmarks(benchmarks, limit = 6) {
  return Object.entries(benchmarks || {})
    .map(([name, value]) => [name, asNumber(value, 0)])
    .sort((a, b) => b[1] - a[1])
    .slice(0, limit);
}

function printAgentInterviewProtocol(modelId) {
  console.log("AGENT PLAYBOOK (REQUIRED):");
  console.log("1) Research this exact model first (AA API -> web sources -> backend mapping if needed).");
  console.log("2) Build an evidence pack with concrete sources and attempted queries.");
  console.log("3) Present proposed benchmarks (or explicitly state no trustworthy benchmarks found).");
  console.log("4) Ask the user for one decision only: Approve, Deny, Ignore List, or Instructions.");
  console.log("5) Do not ask generic 'How should we proceed?' questions.");
  console.log("AGENT RESPONSE SCHEMA (REQUIRED):");
  console.log("{");
  console.log(`  \"model\": \"${modelId}\",`);
  console.log("  \"evidence\": {");
  console.log("    \"sources\": [{\"url\": \"...\", \"claim\": \"...\"}],");
  console.log("    \"attempted_queries\": [\"...\", \"...\"],");
  console.log("    \"backend_mapping\": {\"hypothesis\": \"...\", \"confidence\": 0.0}");
  console.log("  },");
  console.log("  \"proposal\": {");
  console.log("    \"action\": \"accept_benchmarks|continue_research|deny_model|ignore_model|manual_values\",");
  console.log("    \"confidence\": 0.0,");
  console.log("    \"benchmarks\": {\"gpqa\": 0.0, \"mmlu_pro\": 0.0, \"ifbench\": 0.0}");
  console.log("  },");
  console.log("  \"question\": \"Approve, Deny, Ignore List, or Instructions?\"");
  console.log("}");
}

function printEntryEvidence(modelId, entry) {
  const confidence = asNumber(entry?.confidence, 0);
  const candidate = entry?.name || "unknown";
  const sources = Array.isArray(entry?.sources) ? entry.sources : [];
  const primarySource = sources[0] || {};

  console.log(`Model: ${modelId}`);
  console.log(`Research candidate: ${candidate}`);
  console.log(`Confidence: ${confidence.toFixed(3)}`);
  if (primarySource.endpoint) {
    console.log(`Primary source: ${primarySource.endpoint}`);
  }
  if (primarySource.model_reference) {
    console.log(`Source model reference: ${primarySource.model_reference}`);
  }

  const top = topBenchmarks(entry?.benchmarks, 6);
  if (top.length > 0) {
    console.log("Proposed benchmark snapshot:");
    for (const [k, v] of top) {
      console.log(`- ${k}: ${v}`);
    }
  }
}

function main() {
  const argv = process.argv.slice(2);
  const deniedSet = new Set();
  for (let i = 0; i < argv.length; i++) {
    if (argv[i] === "--deny" && argv[i + 1]) {
      deniedSet.add(argv[i + 1]);
      i++;
    }
  }

  const proposalPath = latestResearchProposal();
  if (!proposalPath) {
    console.log("No benchmark-research proposal found; no interview pending.");
    return;
  }

  const proposal = loadJson(proposalPath);
  const accepted = loadJson(ACCEPTED_PATH);
  const ignored = loadJson(IGNORE_PATH);
  const acceptedSet = new Set(Object.keys(accepted?.models || {}));
  const ignoredSet = new Set(Object.keys(ignored?.ignored_models || {}));

  const patch = proposal.model_benchmark_patch || {};
  const patchModels = Object.keys(patch).filter(
    (m) => !patch[m]?.autoAccepted && !acceptedSet.has(m) && !ignoredSet.has(m) && !deniedSet.has(m)
  );
  const autoAccepted = Object.keys(patch).filter((m) => patch[m]?.autoAccepted);
  const unresolved = (proposal.unresolved || []).filter((m) => !acceptedSet.has(m) && !ignoredSet.has(m) && !deniedSet.has(m));

  if (patchModels.length === 0 && unresolved.length === 0) {
    console.log("No interview pending; research proposal has no decisions.");
    return;
  }

  console.log(`Interview decision gate from proposal: ${proposalPath}`);
  if (autoAccepted.length > 0) {
    console.log(`Auto-accepted high-confidence non-stealth mappings: ${autoAccepted.length}`);
  }
  if (patchModels.length > 0) {
    const modelId = patchModels[0];
    const entry = proposal.model_benchmark_patch[modelId] || {};
    const confidence = asNumber(entry?.confidence, 0);
    console.log("---");
    printEntryEvidence(modelId, entry);

    if (confidence < INTERVIEW_MIN_CONFIDENCE) {
      console.log("AGENT DIRECTIVE: Confidence is below interview threshold.");
      console.log("AGENT DIRECTIVE: Continue web/rumor research and gather stronger evidence before asking the user.");
      console.log("AGENT DIRECTIVE: Do not ask generic 'How should we proceed?' questions.");
      console.log("AGENT DIRECTIVE: Return evidence package first, then ask user to accept, deny, or give guidance.");
      console.log("AGENT DIRECTIVE: Agents/scripts must never auto-add entries to model_ignore_list.json.");
      printAgentInterviewProtocol(modelId);
      process.exit(3);
    }

    console.log("User decision required (normal workflow stage):");
    console.log("1) Approve (Accept researched benchmark entry)");
    console.log("2) Deny (Skip for this run, do not add to ignore list)");
    console.log("3) Ignore List (Approve adding this model to ignore list)");
    console.log("4) Instructions (Provide manual benchmark values or general guidance)");
    console.log("AGENT DIRECTIVE: Present evidence before asking for decision.");
    console.log("AGENT DIRECTIVE: Ask user to Approve, Deny, Ignore List, or give Instructions.");
    console.log("AGENT DIRECTIVE: Do not ask generic 'How should we proceed?' questions.");
    console.log("AGENT DIRECTIVE: Ask user for explicit approval before any ignore-list edit.");
    console.log("AGENT DIRECTIVE: Agents/scripts must never auto-add entries to model_ignore_list.json.");
    printAgentInterviewProtocol(modelId);
    process.exit(2);
  }

  if (unresolved.length > 0) {
    const modelId = unresolved[0];
    console.log("---");
    console.log(`Model: ${modelId}`);
    console.log("Research result: unresolved");
    const manualTask = (proposal.manual_research_tasks || []).find((t) => t.model === modelId);
    if (manualTask?.search_queries?.length) {
      console.log("Current research hints:");
      for (const query of manualTask.search_queries) {
        console.log(`- ${query}`);
      }
    }
    console.log("User decision required (normal workflow stage):");
    console.log("1) Approve (Accept researched benchmark entry)");
    console.log("2) Deny (Skip for this run, do not add to ignore list)");
    console.log("3) Ignore List (Approve adding this model to ignore list)");
    console.log("4) Instructions (Provide manual benchmark values or general guidance)");
    console.log("AGENT DIRECTIVE: Present evidence and attempted sources before asking for decision.");
    console.log("AGENT DIRECTIVE: Ask user to Approve, Deny, Ignore List, or give Instructions.");
    console.log("AGENT DIRECTIVE: Do not ask generic 'How should we proceed?' questions.");
    console.log("AGENT DIRECTIVE: Ask user for explicit approval before any ignore-list edit.");
    console.log("AGENT DIRECTIVE: Agents/scripts must never auto-add entries to model_ignore_list.json.");
    printAgentInterviewProtocol(modelId);
    process.exit(2);
  }
}

try {
  main();
} catch (error) {
  console.error(`Interview step failed: ${error.message}`);
  process.exit(1);
}
