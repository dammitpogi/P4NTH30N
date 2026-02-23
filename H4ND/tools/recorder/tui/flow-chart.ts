// Subway-style Flow Chart Renderer for TUI Run Mode
// Inspired by GitKraken's commit graph — shows step flow with conditional branches
import { MacroStep } from '../types';
import { c, moveTo, writeAt, icon, wordWrap } from './screen';

// ─── Subway Line Characters ─────────────────────────────────────
// These create the "metro map" look with colored lines and station dots
const metro = {
  // Main line (vertical)
  line:     '│',
  lineH:    '─',
  // Stations
  station:  '●',
  stationH: '○',  // hollow = pending
  // Branches
  branchR:  '╮',  // branch right (onTrue)
  branchL:  '╭',  // branch left (onFalse)
  mergeR:   '╯',  // merge from right
  mergeL:   '╰',  // merge from left
  fork:     '┤',  // fork point
  // Arrows
  arrowD:   '▼',
  arrowR:   '►',
  arrowL:   '◄',
  arrowU:   '▲',
  // Jump
  jumpUp:   '⤴',
  jumpDn:   '⤵',
  // Connectors
  teeR:     '├',
  teeL:     '┤',
  cross:    '┼',
  dotLine:  '┊',
};

// Phase colors for subway lines
const phaseColor: Record<string, string> = {
  Login:          c.brightGreen,
  GameSelection:  c.brightBlue,
  Spin:           c.brightYellow,
  Logout:         c.brightRed,
  DismissModals:  c.brightMagenta,
};

// Status colors for stations
function stationColor(status?: string): string {
  switch (status) {
    case 'passed':  return c.green;
    case 'failed':  return c.red;
    case 'running': return c.yellow;
    case 'skipped': return c.gray;
    default:        return c.gray;
  }
}

function stationChar(status?: string): string {
  switch (status) {
    case 'passed':  return c.green + '●' + c.reset;
    case 'failed':  return c.red + '✗' + c.reset;
    case 'running': return c.yellow + '◉' + c.reset;
    case 'skipped': return c.gray + '○' + c.reset;
    default:        return c.gray + '○' + c.reset;
  }
}

export interface FlowChartOptions {
  startRow: number;
  startCol: number;
  width: number;
  maxRows: number;
  scrollOffset: number;
  runCursor: number;
  showBranches: boolean;
}

// ─── Render Subway Flow Chart ───────────────────────────────────
// Renders a vertical subway map of the workflow with branch indicators
export function renderFlowChart(
  steps: MacroStep[],
  opts: FlowChartOptions
): string {
  let out = '';
  const { startRow, startCol, width, maxRows, scrollOffset, runCursor, showBranches } = opts;
  const lineCol = startCol + 3;       // Main subway line column
  const branchCol = startCol + 7;     // Branch indicator column
  const labelCol = startCol + 10;     // Step label start
  const labelW = width - 12;          // Available width for labels

  // Track which phase we're in for line coloring
  let lastPhase = '';
  let row = startRow;

  for (let i = scrollOffset; i < steps.length && (row - startRow) < maxRows; i++) {
    const step = steps[i];
    const isActive = i === runCursor;
    const pColor = phaseColor[step.phase] || c.white;
    const sColor = stationColor(step._status);

    // ─── Phase transition header ────────────────────────────
    if (step.phase !== lastPhase) {
      if (lastPhase !== '') {
        // Draw phase transition connector
        out += writeAt(row, lineCol, pColor + metro.line + c.reset);
        row++;
        if ((row - startRow) >= maxRows) break;
      }
      // Phase label on the line
      const phaseLabel = ` ${step.phase} `;
      out += writeAt(row, lineCol, pColor + metro.line + c.reset);
      out += writeAt(row, labelCol - 2, `${pColor}${c.bold}${c.inverse} ${step.phase} ${c.reset}`);
      lastPhase = step.phase;
      row++;
      if ((row - startRow) >= maxRows) break;
      // Connector after phase label
      out += writeAt(row, lineCol, pColor + metro.line + c.reset);
      row++;
      if ((row - startRow) >= maxRows) break;
    }

    // ─── Station (step) ─────────────────────────────────────
    // Main line segment
    out += writeAt(row, lineCol, pColor + metro.line + c.reset);

    // Station dot
    out += writeAt(row, lineCol, stationChar(step._status));

    // Breakpoint indicator
    if (step.breakpoint) {
      out += writeAt(row, startCol, `${c.red}${icon.breakpoint}${c.reset}`);
    }

    // Step number
    out += writeAt(row, lineCol + 2, `${c.gray}${String(step.stepId).padStart(2)}${c.reset}`);

    // ─── Branch indicators (subway branches) ────────────────
    if (showBranches && step.conditional) {
      // Fork symbol on the main line
      out += writeAt(row, lineCol + 1, `${c.brightYellow}${metro.teeR}${c.reset}`);
      // Branch line going right
      out += writeAt(row, branchCol, `${c.brightYellow}${metro.lineH}${metro.branchR}${c.reset}`);
    }

    // ─── Step label ─────────────────────────────────────────
    let label = '';
    const actionStr = step.action || step.tool || '—';

    if (isActive) {
      label += `${c.inverse}${c.bold} ${actionStr} ${c.reset}`;
    } else {
      label += `${c.white}${actionStr}${c.reset}`;
    }

    // Coordinates for click/longpress
    if (step.coordinates && (step.action === 'click' || step.action === 'longpress')) {
      const coord = step.coordinates;
      if ('rx' in coord) {
        label += ` ${c.gray}(${(coord as any).rx.toFixed(2)},${(coord as any).ry.toFixed(2)})${c.reset}`;
      }
    }

    // Input preview
    if (step.input) {
      const maxInput = Math.min(step.input.length, 15);
      label += ` ${c.yellow}"${step.input.slice(0, maxInput)}${step.input.length > maxInput ? '…' : ''}"${c.reset}`;
    }

    // URL preview
    if (step.url && step.action === 'navigate') {
      label += ` ${c.cyan}${step.url.slice(0, 25)}${step.url.length > 25 ? '…' : ''}${c.reset}`;
    }

    // Duration
    if (step._durationMs !== undefined) {
      label += ` ${c.gray}${step._durationMs}ms${c.reset}`;
    }

    // Screenshot
    if (step.takeScreenshot) {
      label += ` ${c.gray}${icon.camera}${c.reset}`;
    }

    // Disabled
    if ((step.enabled ?? true) === false) {
      label = `${c.gray}${c.italic}(disabled) ${actionStr}${c.reset}`;
    }

    out += writeAt(row, labelCol, label);
    row++;
    if ((row - startRow) >= maxRows) break;

    // ─── Conditional branch detail lines ────────────────────
    if (showBranches && step.conditional) {
      const cond = step.conditional;
      // True branch line
      out += writeAt(row, lineCol, pColor + metro.line + c.reset);
      out += writeAt(row, branchCol, `${c.brightYellow}${metro.line}${c.reset}`);
      const trueLabel = `${c.green}T:${c.reset} ${cond.onTrue.action}`;
      const trueTarget = cond.onTrue.gotoStep ? ` ${c.brightMagenta}→${cond.onTrue.gotoStep}${c.reset}` : '';
      const trueRetry = cond.onTrue.action === 'retry' && cond.onTrue.retryCount
        ? ` ${c.yellow}×${cond.onTrue.retryCount}${c.reset}` : '';
      out += writeAt(row, branchCol + 2, trueLabel + trueTarget + trueRetry);
      row++;
      if ((row - startRow) >= maxRows) break;

      // False branch line
      out += writeAt(row, lineCol, pColor + metro.line + c.reset);
      out += writeAt(row, branchCol, `${c.brightYellow}${metro.mergeR}${c.reset}`);
      const falseLabel = `${c.red}F:${c.reset} ${cond.onFalse.action}`;
      const falseTarget = cond.onFalse.gotoStep ? ` ${c.brightMagenta}→${cond.onFalse.gotoStep}${c.reset}` : '';
      const falseRetry = cond.onFalse.action === 'retry' && cond.onFalse.retryCount
        ? ` ${c.yellow}×${cond.onFalse.retryCount}${c.reset}` : '';
      out += writeAt(row, branchCol + 2, falseLabel + falseTarget + falseRetry);
      row++;
      if ((row - startRow) >= maxRows) break;
    }

    // ─── Goto jump indicator ────────────────────────────────
    if (step.gotoStep && !step.conditional) {
      out += writeAt(row, lineCol, pColor + metro.line + c.reset);
      const jumpDir = step.gotoStep < step.stepId ? metro.jumpUp : metro.jumpDn;
      out += writeAt(row, lineCol + 2, `${c.brightMagenta}${jumpDir} goto ${step.gotoStep}${c.reset}`);
      row++;
      if ((row - startRow) >= maxRows) break;
    }

    // ─── Connector to next step ─────────────────────────────
    if (i < steps.length - 1 && (row - startRow) < maxRows) {
      out += writeAt(row, lineCol, pColor + metro.line + c.reset);
      row++;
    }
  }

  // Terminal station
  if (row - startRow < maxRows && scrollOffset + maxRows >= steps.length) {
    const endPhase = steps.length > 0 ? steps[steps.length - 1].phase : 'Login';
    const endColor = phaseColor[endPhase] || c.white;
    out += writeAt(row, lineCol, `${endColor}${metro.station}${c.reset}`);
    out += writeAt(row, labelCol, `${c.gray}${c.italic}end${c.reset}`);
  }

  return out;
}

// ─── Render Compact Flow Chart (for right panel) ────────────────
// Smaller version showing just the conditional flow around current step
export function renderMiniFlowChart(
  steps: MacroStep[],
  currentIdx: number,
  startRow: number,
  startCol: number,
  width: number,
  maxRows: number
): string {
  let out = '';
  const step = steps[currentIdx];
  if (!step) return out;

  const lineCol = startCol + 2;
  const labelCol = startCol + 5;
  let row = startRow;

  // Title
  out += writeAt(row++, startCol, `${c.bold}${c.brightCyan}Flow Context${c.reset}`);
  row++;

  // Show 2 steps before
  const contextStart = Math.max(0, currentIdx - 2);
  for (let i = contextStart; i < currentIdx && (row - startRow) < maxRows - 4; i++) {
    const s = steps[i];
    const pCol = phaseColor[s.phase] || c.gray;
    out += writeAt(row, lineCol, `${pCol}│${c.reset}`);
    out += writeAt(row, lineCol, stationChar(s._status));
    out += writeAt(row, labelCol, `${c.gray}${s.stepId}. ${s.action || s.tool}${c.reset}`);
    row++;
    out += writeAt(row, lineCol, `${pCol}│${c.reset}`);
    row++;
  }

  // Current step (highlighted)
  const pCol = phaseColor[step.phase] || c.white;
  out += writeAt(row, lineCol, stationChar(step._status));
  out += writeAt(row, labelCol, `${c.bold}${c.inverse} ${step.stepId}. ${step.action || step.tool} ${c.reset}`);
  row++;

  // Show conditional branches if present
  if (step.conditional) {
    const cond = step.conditional;
    const condText = cond.condition.description || cond.condition.type;
    const condLines = wordWrap(condText, width - 8);
    
    out += writeAt(row, lineCol, `${c.brightYellow}├─${c.reset}`);
    out += writeAt(row, labelCol, `${c.brightYellow}IF${c.reset} ${condLines[0] || ''}`);
    row++;
    
    // Additional lines for wrapped conditional text
    for (let i = 1; i < condLines.length && (row - startRow) < maxRows - 4; i++) {
      out += writeAt(row, lineCol, `${c.brightYellow}│${c.reset}`);
      out += writeAt(row, labelCol, condLines[i]);
      row++;
    }

    // True branch
    out += writeAt(row, lineCol, `${c.brightYellow}│${c.reset}`);
    out += writeAt(row, lineCol + 1, `${c.green}├ T:${c.reset} ${cond.onTrue.action}`);
    if (cond.onTrue.gotoStep) {
      out += ` ${c.brightMagenta}→${cond.onTrue.gotoStep}${c.reset}`;
    }
    if (cond.onTrue.action === 'retry' && cond.onTrue.retryCount) {
      out += ` ${c.yellow}×${cond.onTrue.retryCount}${c.reset}`;
      if (cond.onTrue.retryDelayMs) out += ` ${c.gray}${cond.onTrue.retryDelayMs}ms${c.reset}`;
    }
    row++;

    // False branch
    out += writeAt(row, lineCol, `${c.brightYellow}│${c.reset}`);
    out += writeAt(row, lineCol + 1, `${c.red}└ F:${c.reset} ${cond.onFalse.action}`);
    if (cond.onFalse.gotoStep) {
      out += ` ${c.brightMagenta}→${cond.onFalse.gotoStep}${c.reset}`;
    }
    if (cond.onFalse.action === 'retry' && cond.onFalse.retryCount) {
      out += ` ${c.yellow}×${cond.onFalse.retryCount}${c.reset}`;
    }
    row++;
  }

  // Goto indicator
  if (step.gotoStep) {
    const jumpDir = step.gotoStep < step.stepId ? '⤴' : '⤵';
    out += writeAt(row, lineCol, `${c.brightMagenta}${jumpDir}${c.reset}`);
    out += writeAt(row, labelCol, `${c.brightMagenta}goto step ${step.gotoStep}${c.reset}`);
    row++;
  }

  // Show 2 steps after
  out += writeAt(row, lineCol, `${pCol}│${c.reset}`);
  row++;
  const contextEnd = Math.min(steps.length, currentIdx + 3);
  for (let i = currentIdx + 1; i < contextEnd && (row - startRow) < maxRows; i++) {
    const s = steps[i];
    const sCol = phaseColor[s.phase] || c.gray;
    out += writeAt(row, lineCol, stationChar(s._status));
    out += writeAt(row, labelCol, `${c.gray}${s.stepId}. ${s.action || s.tool}${c.reset}`);
    row++;
    if (i < contextEnd - 1) {
      out += writeAt(row, lineCol, `${sCol}│${c.reset}`);
      row++;
    }
  }

  return out;
}
