/**
 * update-agent-models status report
 *
 * Usage:
 *   node skills/update-agent-models/status.js
 */

const fs = require("fs");
const path = require("path");

const SKILL_DIR = __dirname;
const ROOT_DIR = path.resolve(SKILL_DIR, "..", "..");

function loadJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function latestFile(dir, prefix) {
  if (!fs.existsSync(dir)) return null;
  const files = fs
    .readdirSync(dir)
    .filter((f) => (!prefix || f.startsWith(prefix)) && fs.statSync(path.join(dir, f)).isFile())
    .sort();
  return files.length > 0 ? path.join(dir, files[files.length - 1]) : null;
}

function main() {
  const working = loadJson(path.join(SKILL_DIR, "working_models.json"));
  const theseus = loadJson(path.join(ROOT_DIR, "oh-my-opencode-theseus.json"));
  const reportPath = latestFile(path.join(SKILL_DIR, "reports"), "optimize.");
  const proposalPath = latestFile(path.join(SKILL_DIR, "proposals"), "theseus-update.");
  const budgetPath = latestFile(path.join(SKILL_DIR, "proposals"), "openai-budget.");

  const verifiedCount = Object.keys(working.models || {}).length;
  console.log(`verified_models=${verifiedCount}`);

  console.log("primary_models:");
  for (const agent of ["orchestrator", "oracle", "designer", "explorer", "librarian", "fixer"]) {
    const model = theseus?.agents?.[agent]?.model || "<missing>";
    console.log(`- ${agent}: ${model}`);
  }

  if (reportPath) {
    const report = loadJson(reportPath);
    console.log(`latest_report=${reportPath}`);
    console.log(`latest_report_timestamp=${report.timestamp || "unknown"}`);
  } else {
    console.log("latest_report=<none>");
  }

  if (proposalPath) {
    const proposal = loadJson(proposalPath);
    console.log(`latest_proposal=${proposalPath}`);
    console.log(`latest_proposal_timestamp=${proposal.timestamp || "unknown"}`);
  } else {
    console.log("latest_proposal=<none>");
  }

  if (budgetPath) {
    const budget = loadJson(budgetPath);
    console.log(`latest_openai_budget=${budgetPath}`);
    console.log(`openai_budget_stage=${budget.budget_stage || "unknown"}`);
    console.log(`openai_remaining_ratio=${budget.remaining_ratio ?? "unknown"}`);
  } else {
    console.log("latest_openai_budget=<none>");
  }
}

try {
  main();
} catch (error) {
  console.error(`Status failed: ${error.message}`);
  process.exit(1);
}
