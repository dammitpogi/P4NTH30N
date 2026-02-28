#!/usr/bin/env bun
import { parseArgs } from 'util';
import { basename, join } from 'path';

type DecisionIndexRecord = {
  decisionId: string;
  title: string;
  status: string;
  category: string;
  priority: string;
  date: string;
  sourceFile: string;
};

type DecisionStatusIndex = {
  schemaVersion: '1.0.0';
  generatedAt: string;
  sourceDirectory: string;
  total: number;
  byStatus: Record<string, number>;
  byCategory: Record<string, number>;
  decisions: DecisionIndexRecord[];
};

const DEFAULT_DECISIONS_DIR = join(
  import.meta.dir,
  '..',
  '..',
  'decisions',
  'active',
);
const DEFAULT_OUTPUT_PATH = join(
  import.meta.dir,
  '..',
  'decision-engine',
  'decision-status-index.json',
);

function extractField(content: string, label: string): string {
  const regex = new RegExp(`\\*\\*${label}\\*\\*:\\s*(.+)$`, 'm');
  const match = content.match(regex);
  if (!match || !match[1]) {
    return 'Unknown';
  }
  return match[1].trim();
}

function extractTitle(content: string, fallback: string): string {
  const firstLine = content.split(/\r?\n/, 1)[0] ?? '';
  if (!firstLine.startsWith('#')) {
    return fallback;
  }
  return firstLine.replace(/^#+\s*/, '').trim() || fallback;
}

function extractDecisionId(content: string, fallback: string): string {
  const id = extractField(content, 'Decision ID');
  if (id !== 'Unknown') {
    return id;
  }
  const titleId = content.match(/DECISION[_-]\d+/i)?.[0];
  return titleId ? titleId.toUpperCase() : fallback;
}

async function collectRecords(decisionsDir: string): Promise<DecisionIndexRecord[]> {
  const records: DecisionIndexRecord[] = [];
  const glob = new Bun.Glob('*.md');

  for await (const relativeFile of glob.scan(decisionsDir)) {
    const absolutePath = join(decisionsDir, relativeFile);
    const content = await Bun.file(absolutePath).text();
    const filename = basename(relativeFile, '.md').toUpperCase();

    const record: DecisionIndexRecord = {
      decisionId: extractDecisionId(content, filename),
      title: extractTitle(content, filename),
      status: extractField(content, 'Status'),
      category: extractField(content, 'Category'),
      priority: extractField(content, 'Priority'),
      date: extractField(content, 'Date'),
      sourceFile: join('STR4TEG15T', 'decisions', 'active', relativeFile).replace(/\\/g, '/'),
    };

    records.push(record);
  }

  records.sort((a, b) => a.decisionId.localeCompare(b.decisionId));
  return records;
}

function countBy(records: DecisionIndexRecord[], selector: (record: DecisionIndexRecord) => string): Record<string, number> {
  const result: Record<string, number> = {};
  for (const record of records) {
    const key = selector(record);
    result[key] = (result[key] ?? 0) + 1;
  }
  return result;
}

async function main() {
  const { values } = parseArgs({
    args: Bun.argv.slice(2),
    options: {
      source: { type: 'string', default: DEFAULT_DECISIONS_DIR },
      output: { type: 'string', default: DEFAULT_OUTPUT_PATH },
      'dry-run': { type: 'boolean', default: false },
    },
    strict: true,
  });

  const decisions = await collectRecords(values.source);
  const index: DecisionStatusIndex = {
    schemaVersion: '1.0.0',
    generatedAt: new Date().toISOString(),
    sourceDirectory: values.source,
    total: decisions.length,
    byStatus: countBy(decisions, (record) => record.status),
    byCategory: countBy(decisions, (record) => record.category),
    decisions,
  };

  if (values['dry-run']) {
    console.log(JSON.stringify(index, null, 2));
    return;
  }

  await Bun.write(values.output, `${JSON.stringify(index, null, 2)}\n`);
  console.log(`Decision status index written: ${values.output}`);
  console.log(`Total decisions indexed: ${index.total}`);
}

main().catch((error: unknown) => {
  console.error(`decision-status-indexer failed: ${String(error)}`);
  process.exit(1);
});
