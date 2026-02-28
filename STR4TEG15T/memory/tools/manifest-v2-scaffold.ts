#!/usr/bin/env bun
import { parseArgs } from 'util';
import { join } from 'path';
import { mkdir } from 'fs/promises';

type ScaffoldPlan = {
  directories: string[];
  files: Array<{ path: string; content: string }>;
};

function nowDateParts() {
  const now = new Date();
  const year = String(now.getUTCFullYear());
  const month = String(now.getUTCMonth() + 1).padStart(2, '0');
  const day = String(now.getUTCDate()).padStart(2, '0');
  return { year, month, day, iso: now.toISOString() };
}

function buildPlan(root: string): ScaffoldPlan {
  const { year, month, day, iso } = nowDateParts();
  const eventFile = join(root, 'events', year, month, `${day}.jsonl`);
  const snapshotFile = join(root, 'snapshots', `snapshot-${year}${month}${day}.json`);

  const directories = [
    join(root, 'events'),
    join(root, 'events', year),
    join(root, 'events', year, month),
    join(root, 'views'),
    join(root, 'views', 'by-status'),
    join(root, 'views', 'by-decision'),
    join(root, 'snapshots'),
    join(root, 'archive'),
    join(root, 'archive', year),
    join(root, 'catalog'),
  ];

  const files = [
    {
      path: eventFile,
      content: '',
    },
    {
      path: join(root, 'views', 'current-state.json'),
      content: `${JSON.stringify(
        {
          schemaVersion: '2.0.0',
          generatedAt: iso,
          decisions: {},
          meta: {
            source: 'manifest-v2-scaffold',
            note: 'Materialized view placeholder for manifest v2.',
          },
        },
        null,
        2,
      )}\n`,
    },
    {
      path: join(root, 'views', 'by-status', '_index.json'),
      content: `${JSON.stringify(
        {
          schemaVersion: '2.0.0',
          generatedAt: iso,
          statuses: {},
        },
        null,
        2,
      )}\n`,
    },
    {
      path: join(root, 'views', 'by-decision', '_index.json'),
      content: `${JSON.stringify(
        {
          schemaVersion: '2.0.0',
          generatedAt: iso,
          decisions: [],
        },
        null,
        2,
      )}\n`,
    },
    {
      path: snapshotFile,
      content: `${JSON.stringify(
        {
          schemaVersion: '2.0.0',
          snapshotAt: iso,
          decisions: {},
          sourceEventCursor: `${year}-${month}-${day}`,
        },
        null,
        2,
      )}\n`,
    },
    {
      path: join(root, 'catalog', 'archive-catalog.json'),
      content: `${JSON.stringify(
        {
          schemaVersion: '2.0.0',
          generatedAt: iso,
          archives: [],
        },
        null,
        2,
      )}\n`,
    },
  ];

  return { directories, files };
}

async function ensureDirectory(path: string) {
  await mkdir(path, { recursive: true });
}

async function writeIfMissing(path: string, content: string) {
  const file = Bun.file(path);
  if (await file.exists()) {
    return;
  }
  await Bun.write(path, content);
}

async function main() {
  const defaultRoot = join(import.meta.dir, '..', 'manifest');
  const { values } = parseArgs({
    args: Bun.argv.slice(2),
    options: {
      root: { type: 'string', default: defaultRoot },
      'dry-run': { type: 'boolean', default: false },
    },
    strict: true,
  });

  const plan = buildPlan(values.root);

  if (values['dry-run']) {
    console.log(JSON.stringify(plan, null, 2));
    return;
  }

  for (const directory of plan.directories) {
    await ensureDirectory(directory);
  }

  for (const file of plan.files) {
    await writeIfMissing(file.path, file.content);
  }

  console.log(`Manifest v2 scaffold ready under: ${values.root}`);
  console.log(`Directories ensured: ${plan.directories.length}`);
  console.log(`Seed files ensured: ${plan.files.length}`);
}

main().catch((error: unknown) => {
  console.error(`manifest-v2-scaffold failed: ${String(error)}`);
  process.exit(1);
});
