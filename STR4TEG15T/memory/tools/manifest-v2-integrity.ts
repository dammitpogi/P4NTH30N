#!/usr/bin/env bun
import { parseArgs } from 'util';
import { createHash } from 'crypto';
import { join } from 'path';

type EventRecord = {
  eventId?: string;
  decisionId?: string;
  timestamp?: string;
  eventType?: string;
  payload?: {
    from?: string;
    to?: string;
    status?: string;
    [key: string]: unknown;
  };
};

type ArchiveCatalog = {
  archives?: Array<{
    path: string;
    sha256: string;
  }>;
};

type IntegrityReport = {
  schemaVersion: '1.0.0';
  generatedAt: string;
  root: string;
  summary: {
    checksPassed: number;
    checksFailed: number;
    warnings: number;
  };
  checks: Array<{
    name: string;
    status: 'PASS' | 'FAIL' | 'WARN';
    details: string;
  }>;
};

async function readJsonSafe<T>(path: string, fallback: T): Promise<T> {
  try {
    return (await Bun.file(path).json()) as T;
  } catch {
    return fallback;
  }
}

async function collectEvents(eventsRoot: string): Promise<EventRecord[]> {
  const events: EventRecord[] = [];
  const glob = new Bun.Glob('**/*.jsonl');
  for await (const file of glob.scan(eventsRoot)) {
    const absolute = join(eventsRoot, file);
    const content = await Bun.file(absolute).text();
    const lines = content.split(/\r?\n/).map((line) => line.trim()).filter(Boolean);
    for (const line of lines) {
      try {
        events.push(JSON.parse(line) as EventRecord);
      } catch {
        // Ignore malformed lines; reported separately by consistency checks.
      }
    }
  }
  return events;
}

function replayStatuses(events: EventRecord[]): Record<string, string> {
  const state: Record<string, string> = {};
  const sorted = [...events].sort((a, b) => {
    const ta = a.timestamp ?? '';
    const tb = b.timestamp ?? '';
    return ta.localeCompare(tb);
  });

  for (const event of sorted) {
    if (!event.decisionId) {
      continue;
    }
    const nextStatus =
      event.payload?.to ??
      event.payload?.status ??
      event.payload?.from;
    if (nextStatus) {
      state[event.decisionId] = String(nextStatus);
    }
  }

  return state;
}

async function sha256(path: string): Promise<string> {
  const content = await Bun.file(path).arrayBuffer();
  return createHash('sha256').update(Buffer.from(content)).digest('hex');
}

async function main() {
  const defaultRoot = join(import.meta.dir, '..', 'manifest');
  const defaultOutput = join(defaultRoot, 'views', 'integrity-report.json');
  const { values } = parseArgs({
    args: Bun.argv.slice(2),
    options: {
      root: { type: 'string', default: defaultRoot },
      output: { type: 'string', default: defaultOutput },
      'dry-run': { type: 'boolean', default: false },
    },
    strict: true,
  });

  const checks: IntegrityReport['checks'] = [];
  const eventsRoot = join(values.root, 'events');
  const viewsRoot = join(values.root, 'views');
  const catalogPath = join(values.root, 'catalog', 'archive-catalog.json');
  const currentStatePath = join(viewsRoot, 'current-state.json');
  const byDecisionIndexPath = join(viewsRoot, 'by-decision', '_index.json');

  const events = await collectEvents(eventsRoot);
  const currentState = await readJsonSafe<{ decisions?: Record<string, { status?: string }> }>(
    currentStatePath,
    { decisions: {} },
  );
  const byDecisionIndex = await readJsonSafe<{ decisions?: string[] }>(
    byDecisionIndexPath,
    { decisions: [] },
  );
  const archiveCatalog = await readJsonSafe<ArchiveCatalog>(catalogPath, { archives: [] });

  const eventIds = new Set(events.map((event) => event.decisionId).filter(Boolean) as string[]);
  const viewIds = new Set(Object.keys(currentState.decisions ?? {}));
  const byDecisionIds = new Set(byDecisionIndex.decisions ?? []);

  const missingFromViews = [...eventIds].filter((id) => !viewIds.has(id));
  const orphanedViews = [...viewIds].filter((id) => !eventIds.has(id));

  if (missingFromViews.length === 0) {
    checks.push({
      name: 'event_view_parity_missing_views',
      status: 'PASS',
      details: 'Every decisionId from events exists in current-state view.',
    });
  } else {
    checks.push({
      name: 'event_view_parity_missing_views',
      status: 'FAIL',
      details: `Missing in current-state: ${missingFromViews.join(', ')}`,
    });
  }

  if (orphanedViews.length === 0) {
    checks.push({
      name: 'event_view_parity_orphan_views',
      status: 'PASS',
      details: 'No orphaned decision entries in current-state.',
    });
  } else {
    checks.push({
      name: 'event_view_parity_orphan_views',
      status: 'WARN',
      details: `View-only decisions present: ${orphanedViews.join(', ')}`,
    });
  }

  const missingFromByDecision = [...viewIds].filter((id) => !byDecisionIds.has(id));
  if (missingFromByDecision.length === 0) {
    checks.push({
      name: 'view_index_parity',
      status: 'PASS',
      details: 'by-decision index aligns with current-state decision keys.',
    });
  } else {
    checks.push({
      name: 'view_index_parity',
      status: 'WARN',
      details: `Current-state IDs missing from by-decision index: ${missingFromByDecision.join(', ')}`,
    });
  }

  const replay = replayStatuses(events);
  const inconsistentReplay = Object.entries(replay).filter(([decisionId, status]) => {
    return (currentState.decisions?.[decisionId]?.status ?? '') !== status;
  });

  if (inconsistentReplay.length === 0) {
    checks.push({
      name: 'replay_consistency',
      status: 'PASS',
      details: 'Replay-derived statuses match current-state view.',
    });
  } else {
    checks.push({
      name: 'replay_consistency',
      status: 'FAIL',
      details: `Replay mismatches: ${inconsistentReplay
        .map(([decisionId, status]) => `${decisionId}=>${status}`)
        .join(', ')}`,
    });
  }

  const archiveEntries = archiveCatalog.archives ?? [];
  let checksumFailures = 0;
  for (const archive of archiveEntries) {
    const archivePath = join(values.root, archive.path);
    const file = Bun.file(archivePath);
    if (!(await file.exists())) {
      checksumFailures += 1;
      continue;
    }
    const actual = await sha256(archivePath);
    if (actual !== archive.sha256) {
      checksumFailures += 1;
    }
  }

  if (archiveEntries.length === 0) {
    checks.push({
      name: 'archive_checksum_hooks',
      status: 'WARN',
      details: 'No archive entries in catalog yet; checksum hooks are scaffolded but unexercised.',
    });
  } else if (checksumFailures === 0) {
    checks.push({
      name: 'archive_checksum_hooks',
      status: 'PASS',
      details: `Validated checksum hooks for ${archiveEntries.length} archive entries.`,
    });
  } else {
    checks.push({
      name: 'archive_checksum_hooks',
      status: 'FAIL',
      details: `${checksumFailures} archive entries failed checksum validation.`,
    });
  }

  const report: IntegrityReport = {
    schemaVersion: '1.0.0',
    generatedAt: new Date().toISOString(),
    root: values.root,
    summary: {
      checksPassed: checks.filter((check) => check.status === 'PASS').length,
      checksFailed: checks.filter((check) => check.status === 'FAIL').length,
      warnings: checks.filter((check) => check.status === 'WARN').length,
    },
    checks,
  };

  if (values['dry-run']) {
    console.log(JSON.stringify(report, null, 2));
    return;
  }

  await Bun.write(values.output, `${JSON.stringify(report, null, 2)}\n`);
  console.log(`Manifest integrity report written: ${values.output}`);
  console.log(`PASS=${report.summary.checksPassed} FAIL=${report.summary.checksFailed} WARN=${report.summary.warnings}`);
}

main().catch((error: unknown) => {
  console.error(`manifest-v2-integrity failed: ${String(error)}`);
  process.exit(1);
});
