/**
 * suggest-unmatched.js
 *
 * Reads latest optimize report and prints unresolved models requiring benchmark research.
 *
 * Usage:
 *   node skills/update-agent-models/suggest-unmatched.js
 */

const fs = require("fs");
const path = require("path");

const SKILL_DIR = __dirname;
const REPORT_DIR = path.join(SKILL_DIR, "reports");
const PROPOSAL_DIR = path.join(SKILL_DIR, "proposals");

function loadJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function latestReport() {
  if (!fs.existsSync(REPORT_DIR)) return null;
  const files = fs
    .readdirSync(REPORT_DIR)
    .filter((f) => f.startsWith("optimize.") && f.endsWith(".json"))
    .sort();
  if (files.length === 0) return null;
  return path.join(REPORT_DIR, files[files.length - 1]);
}

function main() {
  const reportPath = latestReport();
  if (!reportPath) {
    console.log("No optimize report found.");
    return;
  }

  const report = loadJson(reportPath);
  const models = new Set();
  for (const update of Object.values(report?.updates || {})) {
    for (const unmatched of update?.unmatched || []) {
      models.add(unmatched.modelId);
    }
  }

  if (models.size === 0) {
    console.log("No unmatched models in latest report.");
    return;
  }

  const payload = {
    timestamp: new Date().toISOString(),
    type: "missing-benchmark-coverage",
    models: [...models].sort(),
  };

  if (!fs.existsSync(PROPOSAL_DIR)) fs.mkdirSync(PROPOSAL_DIR, { recursive: true });
  const stamp = new Date().toISOString().replace(/[:.]/g, "-");
  const outPath = path.join(PROPOSAL_DIR, `missing-benchmarks.${stamp}.json`);
  fs.writeFileSync(outPath, JSON.stringify(payload, null, 2) + "\n", "utf8");

  console.log(`Missing benchmark proposal written: ${outPath}`);
  console.log(JSON.stringify(payload, null, 2));
}

try {
  main();
} catch (error) {
  console.error(`Suggest failed: ${error.message}`);
  process.exit(1);
}
