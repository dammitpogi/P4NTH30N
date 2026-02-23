// Enhanced Run Mode Dashboard — Verbose execution details, breakpoint info, timing
import { MacroStep } from '../types';
import { c, box, moveTo, writeAt, pad, icon, drawBox, drawSep, progressBar, wordWrap } from './screen';

// ─── Execution Timeline Entry ───────────────────────────────────
export interface TimelineEntry {
  stepId: number;
  action: string;
  status: 'passed' | 'failed' | 'running' | 'skipped' | 'retrying';
  message: string;
  durationMs: number;
  timestamp: number;       // Date.now() when executed
  retryAttempt?: number;
  conditionalResult?: string;
  branchTaken?: 'true' | 'false' | 'none';
  jumpedTo?: number;
}

// ─── Run Statistics ─────────────────────────────────────────────
export interface RunStats {
  totalSteps: number;
  executed: number;
  passed: number;
  failed: number;
  skipped: number;
  retries: number;
  jumps: number;
  totalDurationMs: number;
  avgStepMs: number;
  fastestStepMs: number;
  slowestStepMs: number;
  startTime: number;
}

export function createRunStats(steps: MacroStep[]): RunStats {
  return {
    totalSteps: steps.length,
    executed: 0,
    passed: 0,
    failed: 0,
    skipped: 0,
    retries: 0,
    jumps: 0,
    totalDurationMs: 0,
    avgStepMs: 0,
    fastestStepMs: Infinity,
    slowestStepMs: 0,
    startTime: Date.now(),
  };
}

export function updateRunStats(stats: RunStats, steps: MacroStep[]): RunStats {
  stats.passed = steps.filter(s => s._status === 'passed').length;
  stats.failed = steps.filter(s => s._status === 'failed').length;
  stats.skipped = steps.filter(s => s._status === 'skipped').length;
  stats.executed = stats.passed + stats.failed;
  stats.totalDurationMs = Date.now() - stats.startTime;

  let totalStepTime = 0;
  let count = 0;
  stats.fastestStepMs = Infinity;
  stats.slowestStepMs = 0;
  for (let i = 0; i < steps.length; i++) {
    const d = steps[i]._durationMs;
    if (d !== undefined && d > 0) {
      totalStepTime += d;
      count++;
      if (d < stats.fastestStepMs) stats.fastestStepMs = d;
      if (d > stats.slowestStepMs) stats.slowestStepMs = d;
    }
  }
  stats.avgStepMs = count > 0 ? Math.round(totalStepTime / count) : 0;
  if (stats.fastestStepMs === Infinity) stats.fastestStepMs = 0;

  stats.jumps = steps.filter(s => (s._lastResult || '').indexOf('[jump]') >= 0).length;
  stats.retries = steps.filter(s => (s._lastResult || '').indexOf('retry') >= 0).length;

  return stats;
}

// ─── Format Duration ────────────────────────────────────────────
function fmtMs(ms: number): string {
  if (ms < 1000) return ms + 'ms';
  if (ms < 60000) return (ms / 1000).toFixed(1) + 's';
  const min = Math.floor(ms / 60000);
  const sec = Math.round((ms % 60000) / 1000);
  return min + 'm' + sec + 's';
}

function fmtTime(ts: number): string {
  const d = new Date(ts);
  const h = String(d.getHours()).padStart(2, '0');
  const m = String(d.getMinutes()).padStart(2, '0');
  const s = String(d.getSeconds()).padStart(2, '0');
  return h + ':' + m + ':' + s;
}

// ─── Render Stats Panel ─────────────────────────────────────────
export function renderStatsPanel(
  stats: RunStats,
  startRow: number,
  startCol: number,
  width: number
): string {
  let out = '';
  let row = startRow;
  const lc = startCol;
  const vw = width - 2;

  out += writeAt(row++, lc, `${c.bold}${c.brightCyan}Run Statistics${c.reset}`);
  row++;

  // Progress bar
  const done = stats.passed + stats.failed + stats.skipped;
  out += writeAt(row++, lc, `${c.cyan}Progress:${c.reset} ${progressBar(done, stats.totalSteps, Math.min(vw - 22, 20))} ${done}/${stats.totalSteps}`);

  // Pass/fail counts
  const passBar = stats.passed > 0 ? c.green + '\u2588'.repeat(Math.min(stats.passed, 15)) + c.reset : '';
  const failBar = stats.failed > 0 ? c.red + '\u2588'.repeat(Math.min(stats.failed, 15)) + c.reset : '';
  out += writeAt(row++, lc, `${c.green}${icon.check} Passed:${c.reset}  ${stats.passed}  ${passBar}`);
  out += writeAt(row++, lc, `${c.red}${icon.cross} Failed:${c.reset}  ${stats.failed}  ${failBar}`);
  out += writeAt(row++, lc, `${c.gray}○ Skipped:${c.reset} ${stats.skipped}`);
  if (stats.retries > 0) {
    out += writeAt(row++, lc, `${c.yellow}⟳ Retries:${c.reset} ${stats.retries}`);
  }
  if (stats.jumps > 0) {
    out += writeAt(row++, lc, `${c.brightMagenta}⤵ Jumps:${c.reset}   ${stats.jumps}`);
  }
  row++;

  // Timing
  out += writeAt(row++, lc, `${c.bold}${c.brightCyan}Timing${c.reset}`);
  out += writeAt(row++, lc, `${c.cyan}Elapsed:${c.reset}  ${fmtMs(stats.totalDurationMs)}`);
  out += writeAt(row++, lc, `${c.cyan}Avg Step:${c.reset} ${fmtMs(stats.avgStepMs)}`);
  if (stats.fastestStepMs > 0) {
    out += writeAt(row++, lc, `${c.cyan}Fastest:${c.reset}  ${fmtMs(stats.fastestStepMs)}`);
  }
  if (stats.slowestStepMs > 0) {
    out += writeAt(row++, lc, `${c.cyan}Slowest:${c.reset}  ${fmtMs(stats.slowestStepMs)}`);
  }
  out += writeAt(row++, lc, `${c.cyan}Started:${c.reset}  ${fmtTime(stats.startTime)}`);

  return out;
}

// ─── Render Verbose Breakpoint Panel ────────────────────────────
// This is the big one — shows everything when paused at a breakpoint
export function renderBreakpointPanel(
  step: MacroStep,
  steps: MacroStep[],
  stepIdx: number,
  stats: RunStats,
  timeline: TimelineEntry[],
  startRow: number,
  startCol: number,
  width: number,
  maxRows: number
): string {
  let out = '';
  let row = startRow;
  const lc = startCol;
  const vw = width - 4;

  // ─── Breakpoint Header ────────────────────────────────────
  out += writeAt(row, lc, `${c.bgRed}${c.white}${c.bold}`);
  out += pad(` ${icon.breakpoint} BREAKPOINT — Step ${step.stepId}: ${step.action || step.tool} `, width);
  out += c.reset;
  row += 2;

  // ─── Current Step Details ─────────────────────────────────
  out += writeAt(row++, lc, `${c.bold}${c.brightCyan}Current Step${c.reset}`);
  out += writeAt(row++, lc, `${c.cyan}Step ID:${c.reset}     ${step.stepId} of ${steps.length}`);
  out += writeAt(row++, lc, `${c.cyan}Phase:${c.reset}       ${step.phase}`);
  out += writeAt(row++, lc, `${c.cyan}Action:${c.reset}      ${step.action || '—'}`);
  out += writeAt(row++, lc, `${c.cyan}Tool:${c.reset}        ${step.tool}`);
  if (step.coordinates) {
    const coord = step.coordinates;
    if ('rx' in coord) {
      out += writeAt(row++, lc, `${c.cyan}Coords:${c.reset}      rx=${(coord as any).rx.toFixed(4)} ry=${(coord as any).ry.toFixed(4)}`);
      out += writeAt(row++, lc, `${c.cyan}  Absolute:${c.reset}  (${coord.x}, ${coord.y})`);
    } else {
      out += writeAt(row++, lc, `${c.cyan}Coords:${c.reset}      (${coord.x}, ${coord.y})`);
    }
  }
  if (step.input) {
    out += writeAt(row++, lc, `${c.cyan}Input:${c.reset}       "${step.input.slice(0, vw - 12)}"`);
  }
  if (step.url) {
    out += writeAt(row++, lc, `${c.cyan}URL:${c.reset}         ${step.url.slice(0, vw - 12)}`);
  }
  out += writeAt(row++, lc, `${c.cyan}Delay:${c.reset}       ${step.delayMs || 0}ms`);
  if (step.holdMs && step.action === 'longpress') {
    out += writeAt(row++, lc, `${c.cyan}Hold:${c.reset}        ${step.holdMs}ms`);
  }
  out += writeAt(row++, lc, `${c.cyan}Screenshot:${c.reset}  ${step.takeScreenshot ? `${c.green}Yes${c.reset} — ${step.screenshotReason || '(no reason)'}` : 'No'}`);
  if (step.comment) {
    const commentLines = wordWrap(step.comment, vw - 12);
    out += writeAt(row++, lc, `${c.cyan}Comment:${c.reset}     ${commentLines[0] || ''}`);
    for (let i = 1; i < commentLines.length; i++) {
      out += writeAt(row++, lc, `             ${commentLines[i]}`);
    }
  }
  row++;

  // ─── Verification Gates ───────────────────────────────────
  if (step.verification.entryGate || step.verification.exitGate) {
    out += writeAt(row++, lc, `${c.bold}${c.brightCyan}Verification Gates${c.reset}`);
    if (step.verification.entryGate) {
      out += writeAt(row++, lc, `${c.green}▸ Entry:${c.reset} ${step.verification.entryGate.slice(0, vw - 10)}`);
    }
    if (step.verification.exitGate) {
      out += writeAt(row++, lc, `${c.green}▸ Exit:${c.reset}  ${step.verification.exitGate.slice(0, vw - 10)}`);
    }
    row++;
  }

  // ─── Conditional Logic ────────────────────────────────────
  if (step.conditional) {
    const cond = step.conditional;
    out += writeAt(row++, lc, `${c.bold}${c.brightYellow}Conditional Logic${c.reset}`);
    out += writeAt(row++, lc, `${c.brightYellow}IF${c.reset} ${cond.condition.type}: ${(cond.condition.description || cond.condition.target || '').slice(0, vw - 20)}`);
    if (cond.condition.target) {
      out += writeAt(row++, lc, `${c.cyan}  Target:${c.reset}  ${cond.condition.target.slice(0, vw - 12)}`);
    }
    // True branch
    out += writeAt(row++, lc, `${c.green}  THEN:${c.reset}    ${cond.onTrue.action}${cond.onTrue.gotoStep ? ' → step ' + cond.onTrue.gotoStep : ''}${cond.onTrue.retryCount ? ' ×' + cond.onTrue.retryCount : ''}`);
    if (cond.onTrue.comment) {
      out += writeAt(row++, lc, `${c.gray}           ${cond.onTrue.comment.slice(0, vw - 14)}${c.reset}`);
    }
    // False branch
    out += writeAt(row++, lc, `${c.red}  ELSE:${c.reset}    ${cond.onFalse.action}${cond.onFalse.gotoStep ? ' → step ' + cond.onFalse.gotoStep : ''}${cond.onFalse.retryCount ? ' ×' + cond.onFalse.retryCount : ''}`);
    if (cond.onFalse.comment) {
      out += writeAt(row++, lc, `${c.gray}           ${cond.onFalse.comment.slice(0, vw - 14)}${c.reset}`);
    }
    row++;
  }

  // ─── Goto ─────────────────────────────────────────────────
  if (step.gotoStep && !step.conditional) {
    out += writeAt(row++, lc, `${c.bold}${c.brightMagenta}Flow Control${c.reset}`);
    out += writeAt(row++, lc, `${c.brightMagenta}On failure → goto step ${step.gotoStep}${c.reset}`);
    row++;
  }

  // ─── Execution History (last N entries) ───────────────────
  if (timeline.length > 0 && (row - startRow) < maxRows - 6) {
    out += writeAt(row++, lc, `${c.bold}${c.brightCyan}Execution History${c.reset} ${c.gray}(last ${Math.min(timeline.length, 8)})${c.reset}`);
    const showCount = Math.min(timeline.length, Math.min(8, maxRows - (row - startRow) - 3));
    const startIdx = Math.max(0, timeline.length - showCount);
    for (let i = startIdx; i < timeline.length; i++) {
      const entry = timeline[i];
      const statusIcon = entry.status === 'passed' ? `${c.green}${icon.check}${c.reset}`
        : entry.status === 'failed' ? `${c.red}${icon.cross}${c.reset}`
        : entry.status === 'skipped' ? `${c.gray}○${c.reset}`
        : entry.status === 'retrying' ? `${c.yellow}⟳${c.reset}`
        : `${c.gray}○${c.reset}`;

      let entryLine = `${c.gray}${fmtTime(entry.timestamp)}${c.reset} `;
      entryLine += `${statusIcon} `;
      entryLine += `${c.white}${String(entry.stepId).padStart(2)}${c.reset} `;
      entryLine += `${entry.action} `;
      entryLine += `${c.gray}${fmtMs(entry.durationMs)}${c.reset}`;

      if (entry.conditionalResult) {
        entryLine += ` ${c.brightYellow}[${entry.branchTaken === 'true' ? 'T' : 'F'}]${c.reset}`;
      }
      if (entry.jumpedTo) {
        entryLine += ` ${c.brightMagenta}→${entry.jumpedTo}${c.reset}`;
      }
      if (entry.retryAttempt) {
        entryLine += ` ${c.yellow}retry#${entry.retryAttempt}${c.reset}`;
      }

      out += writeAt(row++, lc, entryLine);
    }
    row++;
  }

  // ─── What's Next ──────────────────────────────────────────
  if ((row - startRow) < maxRows - 4) {
    out += writeAt(row++, lc, `${c.bold}${c.brightCyan}Next Steps${c.reset}`);
    const nextCount = Math.min(3, steps.length - stepIdx - 1);
    for (let i = 1; i <= nextCount; i++) {
      const next = steps[stepIdx + i];
      if (!next) break;
      let nextLine = `  ${c.gray}${next.stepId}.${c.reset} `;
      nextLine += `${next.action || next.tool}`;
      if (next.breakpoint) nextLine += ` ${c.red}${icon.breakpoint}${c.reset}`;
      if (next.conditional) nextLine += ` ${c.brightYellow}[IF]${c.reset}`;
      if (next.gotoStep) nextLine += ` ${c.brightMagenta}[→${next.gotoStep}]${c.reset}`;
      if ((next.enabled ?? true) === false) nextLine = `  ${c.gray}${next.stepId}. (disabled)${c.reset}`;
      out += writeAt(row++, lc, nextLine);
    }
    if (stepIdx + 1 >= steps.length) {
      out += writeAt(row++, lc, `  ${c.gray}${c.italic}(end of workflow)${c.reset}`);
    }
    row++;
  }

  // ─── Controls Reminder ────────────────────────────────────
  if ((row - startRow) < maxRows - 2) {
    out += writeAt(row++, lc, `${c.bgBlue}${c.white} Space${c.reset} single-step  ${c.bgBlue}${c.white} A ${c.reset} resume auto  ${c.bgBlue}${c.white} Esc ${c.reset} abort`);
  }

  return out;
}

// ─── Render Step Result Detail ──────────────────────────────────
// Shows verbose result info for the current/last executed step
export function renderStepResultDetail(
  step: MacroStep,
  startRow: number,
  startCol: number,
  width: number,
  maxRows: number
): string {
  let out = '';
  let row = startRow;
  const lc = startCol;
  const vw = width - 2;

  // Step header
  const statusBg = step._status === 'passed' ? c.bgGreen
    : step._status === 'failed' ? c.bgRed
    : step._status === 'running' ? c.bgBlue
    : c.bgGray;
  const statusLabel = step._status === 'passed' ? ' PASS '
    : step._status === 'failed' ? ' FAIL '
    : step._status === 'running' ? ' EXEC '
    : step._status === 'skipped' ? ' SKIP '
    : ' WAIT ';

  out += writeAt(row++, lc, `${statusBg}${c.white}${c.bold}${statusLabel}${c.reset} ${c.bold}Step ${step.stepId}${c.reset}: ${step.action || step.tool}`);
  row++;

  // Result message
  if (step._lastResult) {
    // Split long results across lines
    const result = step._lastResult;
    const parts = result.split(' | ');
    for (let i = 0; i < parts.length && (row - startRow) < maxRows - 4; i++) {
      const part = parts[i].trim();
      if (!part) continue;
      const partColor = part.indexOf('conditional TRUE') >= 0 ? c.green
        : part.indexOf('conditional FALSE') >= 0 ? c.red
        : part.indexOf('[jump]') >= 0 ? c.brightMagenta
        : part.indexOf('retry') >= 0 ? c.yellow
        : c.white;
      out += writeAt(row++, lc, `${partColor}${part.slice(0, vw)}${c.reset}`);
    }
    row++;
  }

  // Duration
  if (step._durationMs !== undefined) {
    const durColor = step._durationMs > 5000 ? c.red
      : step._durationMs > 2000 ? c.yellow
      : c.green;
    out += writeAt(row++, lc, `${c.cyan}Duration:${c.reset} ${durColor}${fmtMs(step._durationMs)}${c.reset}`);

    // Duration bar (visual)
    const maxBar = Math.min(vw - 2, 30);
    const barLen = Math.min(maxBar, Math.max(1, Math.round((step._durationMs / 5000) * maxBar)));
    const barColor = step._durationMs > 5000 ? c.red
      : step._durationMs > 2000 ? c.yellow
      : c.green;
    out += writeAt(row++, lc, barColor + '\u2588'.repeat(barLen) + c.gray + '\u2591'.repeat(maxBar - barLen) + c.reset);
  }

  // Screenshot
  if (step._screenshotPath) {
    out += writeAt(row++, lc, `${c.cyan}${icon.camera} Screenshot:${c.reset}`);
    out += writeAt(row++, lc, `${c.gray}${step._screenshotPath.slice(-(vw - 2))}${c.reset}`);
  }

  return out;
}

// ─── Render Execution Log (scrollable) ──────────────────────────
export function renderExecutionLog(
  timeline: TimelineEntry[],
  startRow: number,
  startCol: number,
  width: number,
  maxRows: number
): string {
  let out = '';
  let row = startRow;
  const lc = startCol;

  out += writeAt(row++, lc, `${c.bold}${c.brightCyan}Execution Log${c.reset} ${c.gray}(${timeline.length} entries)${c.reset}`);
  row++;

  // Show most recent entries that fit
  const showCount = Math.min(timeline.length, maxRows - 2);
  const startIdx = Math.max(0, timeline.length - showCount);

  for (let i = startIdx; i < timeline.length && (row - startRow) < maxRows; i++) {
    const entry = timeline[i];
    const sIcon = entry.status === 'passed' ? `${c.green}${icon.check}${c.reset}`
      : entry.status === 'failed' ? `${c.red}${icon.cross}${c.reset}`
      : entry.status === 'skipped' ? `${c.gray}○${c.reset}`
      : entry.status === 'retrying' ? `${c.yellow}⟳${c.reset}`
      : `${c.cyan}▸${c.reset}`;

    let line = `${c.gray}${fmtTime(entry.timestamp)}${c.reset} `;
    line += sIcon + ' ';
    line += `${c.white}${String(entry.stepId).padStart(2)}${c.reset} `;
    line += `${entry.action.slice(0, 10)} `;
    line += `${c.gray}${fmtMs(entry.durationMs).padStart(6)}${c.reset} `;

    // Truncate message to fit
    const msgSpace = width - 32;
    if (msgSpace > 0 && entry.message) {
      line += `${c.gray}${entry.message.slice(0, msgSpace)}${c.reset}`;
    }

    out += writeAt(row++, lc, line);
  }

  return out;
}
