/**
 * update-agent-models end-to-end workflow runner.
 *
 * Usage:
 *   node skills/update-agent-models/run-workflow.js
 *   node skills/update-agent-models/run-workflow.js --dry-run
 */

const path = require("path");
const fs = require("fs");
const { spawnSync } = require("child_process");

const ROOT_DIR = path.resolve(__dirname, "..", "..");

function run(command, args) {
  const result = spawnSync(command, args, {
    cwd: ROOT_DIR,
    stdio: "inherit",
    shell: false,
  });
  if (result.status !== 0) {
    throw new Error(`${command} ${args.join(" ")} failed`);
  }
}

function latestResearchProposal() {
  const dir = path.join(ROOT_DIR, "skills", "update-agent-models", "proposals");
  if (!fs.existsSync(dir)) return null;
  const files = fs
    .readdirSync(dir)
    .filter((f) => f.startsWith("benchmark-research.") && f.endsWith(".json"))
    .sort();
  return files.length > 0 ? path.join(dir, files[files.length - 1]) : null;
}

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function hasPendingInterviewDecision(proposalPath, deniedModels) {
  if (!proposalPath) return false;
  const proposal = readJson(proposalPath);

  const acceptedPath = path.join(ROOT_DIR, "skills", "update-agent-models", "benchmark_manual_accepted.json");
  const ignorePath = path.join(ROOT_DIR, "skills", "update-agent-models", "model_ignore_list.json");
  const accepted = readJson(acceptedPath);
  const ignored = readJson(ignorePath);
  const acceptedSet = new Set(Object.keys(accepted?.models || {}));
  const ignoredSet = new Set(Object.keys(ignored?.ignored_models || {}));
  const deniedSet = deniedModels || new Set();

  const patch = proposal.model_benchmark_patch || {};
  const pendingPatch = Object.keys(patch).filter(
    (m) => !patch[m]?.autoAccepted && !acceptedSet.has(m) && !ignoredSet.has(m) && !deniedSet.has(m)
  );
  const pendingUnresolved = (proposal.unresolved || []).filter(
    (m) => !acceptedSet.has(m) && !ignoredSet.has(m) && !deniedSet.has(m)
  );

  return pendingPatch.length > 0 || pendingUnresolved.length > 0;
}

function main() {
  const argv = process.argv.slice(2);
  const args = new Set();
  const deniedModels = [];
  for (let i = 0; i < argv.length; i++) {
    if (argv[i] === "--deny" && argv[i + 1]) {
      deniedModels.push(argv[i + 1]);
      i++;
    } else {
      args.add(argv[i]);
    }
  }
  const deniedArgs = deniedModels.flatMap(m => ["--deny", m]);

  const dryRun = args.has("--dry-run");
  const skipModelRefresh = args.has("--skip-model-refresh");
  const refreshResearch = args.has("--refresh-research");
  const openaiOnly = args.has("--openai-only");
  const googleOnly = args.has("--google-only");
  const useProxy = args.has("--use-proxy");
  const keepProxy = args.has("--keep-proxy");
  const keepArgIndex = process.argv.indexOf("--keep");
  const keepValue =
    keepArgIndex >= 0 && process.argv[keepArgIndex + 1]
      ? process.argv[keepArgIndex + 1]
      : "5";

  run("node", ["skills/update-agent-models/guard.js", "--strict"]);

  if (openaiOnly && googleOnly) {
    throw new Error("Use either --openai-only or --google-only, not both");
  }

  if (openaiOnly) {
    console.log("OpenAI-only mode: skipping model test, benchmark research, and interview gates.");
    run("node", ["skills/update-agent-models/openai-budget.js"]);
    run("node", [
      "skills/update-agent-models/optimize.js",
      "--strict",
      "--explain",
      "--openai-only",
      ...deniedArgs,
      ...(useProxy ? ["--use-proxy"] : []),
      ...(keepProxy ? ["--keep-proxy"] : []),
      ...(dryRun ? ["--dry-run"] : []),
    ]);
    run("node", ["skills/update-agent-models/guard.js", "--strict"]);
    console.log("OpenAI-only workflow completed in proposal mode. No config write performed.");
    console.log("Apply proposal changes via an agent-reviewed edit step.");
    return;
  }

  if (googleOnly) {
    console.log("Google-only mode: skipping model test, benchmark research, and interview gates.");
    run("node", ["skills/update-agent-models/google-health.js"]);
    run("node", [
      "skills/update-agent-models/optimize.js",
      "--strict",
      "--explain",
      "--google-only",
      ...deniedArgs,
      ...(useProxy ? ["--use-proxy"] : []),
      ...(keepProxy ? ["--keep-proxy"] : []),
      ...(dryRun ? ["--dry-run"] : []),
    ]);
    run("node", ["skills/update-agent-models/guard.js", "--strict"]);
    console.log("Google-only workflow completed in proposal mode. No config write performed.");
    console.log("Apply proposal changes via an agent-reviewed edit step.");
    return;
  }

  if (!skipModelRefresh) {
    run("bash", ["skills/update-agent-models/test-models.sh"]);
  } else {
    console.log("Skipping model test refresh (--skip-model-refresh requested).");
    console.log("Default behavior is to refresh model health and availability every run.");
  }
  run("node", ["skills/update-agent-models/openai-budget.js"]);

  let proposalPath = latestResearchProposal();
  const pendingDecision = hasPendingInterviewDecision(proposalPath, new Set(deniedModels));

  if (!pendingDecision || refreshResearch) {
    const research = spawnSync("node", ["skills/update-agent-models/research-benchmarks.js"], {
      cwd: ROOT_DIR,
      stdio: "inherit",
      shell: false,
    });
    if (research.status !== 0 && research.status !== 1) {
      throw new Error("node skills/update-agent-models/research-benchmarks.js failed unexpectedly");
    }
    proposalPath = latestResearchProposal();
    if (!proposalPath) {
      throw new Error("research step did not produce benchmark-research proposal");
    }
  } else {
    console.log("Skipping research refresh (pending interview decision exists).");
    console.log("Use --refresh-research to force a new research proposal.");
  }

  run("node", ["skills/update-agent-models/apply-auto-accepted.js"]);

  const interview = spawnSync("node", ["skills/update-agent-models/next-interview.js", ...deniedArgs], {
    cwd: ROOT_DIR,
    stdio: "inherit",
    shell: false,
  });

  if (interview.status === 2) {
    console.log("Interview decision gate reached (expected workflow stage).");
    console.log("Workflow is waiting for a user decision on the current model interview.");
    return;
  }
  if (interview.status === 3) {
    console.log("Research gate reached (expected workflow stage).");
    console.log("Workflow is waiting for additional evidence before the next user interview.");
    return;
  }
  if (interview.status !== 0) {
    throw new Error("node skills/update-agent-models/next-interview.js failed");
  }

  if (proposalPath) {
    const proposal = readJson(proposalPath);
    const remaining = Number(proposal.remaining_after_scope || 0);
    if (remaining > 0) {
      console.log(`One-at-a-time workflow: ${remaining} models still pending research.`);
      console.log("Re-run workflow to process the next model interview/research step.");
      return;
    }
  }

  run("node", [
    "skills/update-agent-models/optimize.js",
    "--strict",
    "--explain",
    ...deniedArgs,
    ...(useProxy ? ["--use-proxy"] : []),
    ...(keepProxy ? ["--keep-proxy"] : []),
    ...(dryRun ? ["--dry-run"] : []),
  ]);
  run("node", ["skills/update-agent-models/suggest-unmatched.js"]);
  run("node", ["skills/update-agent-models/prune-artifacts.js", "--keep", keepValue]);
  run("node", ["skills/update-agent-models/guard.js", "--strict"]);

  console.log("Workflow completed in proposal mode. No config write performed.");
  console.log("Apply proposal changes via an agent-reviewed edit step.");
}

try {
  main();
} catch (error) {
  console.error(`Workflow failed: ${error.message}`);
  process.exit(1);
}
