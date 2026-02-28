#!/usr/bin/env bun
import { join } from 'path';

type ReconsolidationFlag = {
  requiredBeforeSynthesis?: boolean;
  status?: 'pending' | 'in_progress' | 'completed' | 'failed' | string;
  completedAt?: string;
  scope?: string;
  evidence?: string[];
};

type ManifestShape = {
  lastUpdated?: string;
  workflowFlags?: {
    reconsolidation?: ReconsolidationFlag;
  };
};

const manifestPath = join(
  import.meta.dir,
  '..',
  'manifest',
  'manifest.json',
);

function toEpoch(value: string | undefined): number {
  if (!value) {
    return Number.NaN;
  }
  const epoch = Date.parse(value);
  return Number.isNaN(epoch) ? Number.NaN : epoch;
}

async function main() {
  const text = await Bun.file(manifestPath).text();
  const manifest = JSON.parse(text) as ManifestShape;
  const flag = manifest.workflowFlags?.reconsolidation;

  if (!flag) {
    throw new Error('Missing workflowFlags.reconsolidation in manifest.');
  }

  if (flag.requiredBeforeSynthesis !== true) {
    throw new Error('reconsolidation.requiredBeforeSynthesis must be true.');
  }

  if (flag.status !== 'completed') {
    throw new Error(`Reconsolidation not complete (status=${String(flag.status)}).`);
  }

  const completedAt = toEpoch(flag.completedAt);
  const lastUpdated = toEpoch(manifest.lastUpdated);
  if (Number.isNaN(completedAt) || Number.isNaN(lastUpdated)) {
    throw new Error('Invalid completedAt or lastUpdated timestamp.');
  }

  if (completedAt < lastUpdated) {
    throw new Error('Reconsolidation stale: completedAt is older than lastUpdated.');
  }

  const evidence = flag.evidence ?? [];
  if (evidence.length === 0) {
    throw new Error('Reconsolidation evidence list is empty.');
  }

  for (const relativePath of evidence) {
    const absolutePath = join(import.meta.dir, '..', '..', relativePath.replace(/^STR4TEG15T\//, ''));
    if (!(await Bun.file(absolutePath).exists())) {
      throw new Error(`Reconsolidation evidence missing: ${relativePath}`);
    }
  }

  console.log('Reconsolidation gate: PASS');
  console.log(`Manifest: ${manifestPath}`);
  console.log(`Scope: ${flag.scope ?? 'unspecified'}`);
  console.log(`CompletedAt: ${flag.completedAt}`);
}

main().catch((error: unknown) => {
  console.error(`reconsolidation-gate failed: ${String(error)}`);
  process.exit(1);
});
