/**
 * apply-auto-accepted.js
 *
 * Syncs autoAccepted entries from latest benchmark-research proposal into
 * benchmark_manual_accepted.json before optimization.
 */

const fs = require('fs');
const path = require('path');

const SKILL_DIR = __dirname;
const PROPOSAL_DIR = path.join(SKILL_DIR, 'proposals');
const ACCEPTED_PATH = path.join(SKILL_DIR, 'benchmark_manual_accepted.json');

function loadJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

function saveJson(filePath, data) {
  fs.writeFileSync(filePath, JSON.stringify(data, null, 2) + '\n', 'utf8');
}

function latestResearchProposal() {
  if (!fs.existsSync(PROPOSAL_DIR)) return null;
  const files = fs
    .readdirSync(PROPOSAL_DIR)
    .filter((f) => f.startsWith('benchmark-research.') && f.endsWith('.json'))
    .sort();
  return files.length > 0 ? path.join(PROPOSAL_DIR, files[files.length - 1]) : null;
}

function main() {
  const proposalPath = latestResearchProposal();
  if (!proposalPath) {
    console.log('No benchmark-research proposal found. Nothing to sync.');
    return;
  }

  const proposal = loadJson(proposalPath);
  const accepted = fs.existsSync(ACCEPTED_PATH) ? loadJson(ACCEPTED_PATH) : { models: {} };
  const patch = proposal.model_benchmark_patch || {};

  const autoAccepted = Object.entries(patch).filter(([, entry]) => Boolean(entry?.autoAccepted));
  if (autoAccepted.length === 0) {
    console.log('No auto-accepted entries found. Nothing to sync.');
    return;
  }

  accepted.models = accepted.models || {};

  let added = 0;
  for (const [modelId, entry] of autoAccepted) {
    if (accepted.models[modelId]) continue;
    accepted.models[modelId] = {
      name: entry?.name || modelId,
      benchmarks: entry?.benchmarks || {},
      source: 'auto-accepted-research',
      acceptedAt: new Date().toISOString(),
      confidence: Number(entry?.confidence || 0),
    };
    added += 1;
  }

  if (added === 0) {
    console.log(`Auto-accepted entries already synced (${autoAccepted.length} tracked).`);
    return;
  }

  saveJson(ACCEPTED_PATH, accepted);
  console.log(`Synced ${added} auto-accepted benchmark entries into ${ACCEPTED_PATH}`);
}

try {
  main();
} catch (error) {
  console.error(`Auto-accept sync failed: ${error.message}`);
  process.exit(1);
}
