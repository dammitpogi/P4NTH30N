/**
 * prune-artifacts.js
 *
 * Keeps only newest backups/reports.
 *
 * Usage:
 *   node skills/update-agent-models/prune-artifacts.js
 *   node skills/update-agent-models/prune-artifacts.js --keep 10
 */

const fs = require("fs");
const path = require("path");

const SKILL_DIR = __dirname;
const TARGETS = [
  { dir: path.join(SKILL_DIR, "backups"), label: "backups" },
  { dir: path.join(SKILL_DIR, "reports"), label: "reports" },
  { dir: path.join(SKILL_DIR, "proposals"), label: "proposals" },
];

function parseKeep(argv) {
  const idx = argv.indexOf("--keep");
  if (idx === -1) return 5;
  const n = Number(argv[idx + 1]);
  return Number.isFinite(n) && n >= 1 ? Math.floor(n) : 5;
}

function pruneDir(dirPath, keep) {
  if (!fs.existsSync(dirPath)) return 0;
  const entries = fs
    .readdirSync(dirPath)
    .map((name) => ({
      name,
      filePath: path.join(dirPath, name),
      stat: fs.statSync(path.join(dirPath, name)),
    }))
    .filter((entry) => entry.stat.isFile())
    .sort((a, b) => b.stat.mtimeMs - a.stat.mtimeMs);

  const toDelete = entries.slice(keep);
  for (const entry of toDelete) {
    fs.unlinkSync(entry.filePath);
  }
  return toDelete.length;
}

function main() {
  const keep = parseKeep(process.argv.slice(2));
  for (const target of TARGETS) {
    const removed = pruneDir(target.dir, keep);
    console.log(`${target.label}: removed=${removed} keep=${keep}`);
  }
}

try {
  main();
} catch (error) {
  console.error(`Prune failed: ${error.message}`);
  process.exit(1);
}
