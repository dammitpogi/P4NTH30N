#!/usr/bin/env bun
import { readFileSync, writeFileSync, existsSync, mkdirSync } from 'fs';
import { join } from 'path';
import {
  type MacroStep, type MacroConfig, type AppState, type ViewMode, type EditField,
  EDIT_FIELDS, PHASES, ACTIONS, TOOLS,
} from './types';
import {
  c, box, icon, moveTo, clearScreen, clearLine, hideCursor, showCursor,
  drawBox, drawSep, writeAt, pad, flush, getTermSize, progressBar,
} from './screen';
import { TuiRunner } from './runner';
import {
  type ConditionalEditorState,
  loadConditionalState,
  buildConditionalLogic,
  renderConditionalEditor,
} from './conditional-editor';
import {
  extractPrintableChar,
  isBackspace,
  isEnter,
  isEscape,
} from './input-filter';
import {
  renderFlowChart,
  renderMiniFlowChart,
  type FlowChartOptions,
} from './flow-chart';
import {
  type TimelineEntry,
  type RunStats,
  createRunStats,
  updateRunStats,
  renderStatsPanel,
  renderBreakpointPanel,
  renderStepResultDetail,
  renderExecutionLog,
} from './run-dashboard';

const MAX_FLOW_JUMPS = 200;
const MAX_RETRY_COUNT = 10;

// ─── Default Config ──────────────────────────────────────────────
function defaultConfig(): MacroConfig {
  return {
    platform: 'firekirin',
    decision: 'DECISION_077',
    sessionNotes: '',
    steps: [],
    metadata: {
      created: new Date().toISOString().slice(0, 10),
      modified: new Date().toISOString().slice(0, 10),
      coordinates: {},
      credentials: {},
    },
  };
}

function defaultStep(id: number): MacroStep {
  return {
    stepId: id,
    enabled: true,
    phase: 'Login',
    takeScreenshot: true,
    screenshotReason: '',
    comment: 'Button: [describe location/appearance] | Context: [what this does]',
    tool: 'none',
    action: 'click',
    coordinates: { rx: 0, ry: 0, x: 0, y: 0 },
    delayMs: undefined, // Manual input - document actual timing needed
    verification: { entryGate: '', exitGate: '' },
    breakpoint: false,
  };
}

// ─── Main App ────────────────────────────────────────────────────
export class RecorderTUI {
  private state: AppState;
  private running = true;
  private runner: TuiRunner;
  private readonly configRedirectWarning: string | null = null;
  private conditionalState: ConditionalEditorState | null = null;
  private timeline: TimelineEntry[] = [];
  private runStats: RunStats | null = null;

  constructor(configPath: string) {
    const { rows, cols } = getTermSize();

    // Auto-detect platform-specific config: if step-config.json is given but
    // step-config-firekirin.json exists, load the platform-specific file instead
    const resolvedPath = this.resolveConfigPath(configPath);
    const config = this.loadConfig(resolvedPath);
    const requestedConfigName = configPath.split(/[\\/]/).pop() || configPath;
    const resolvedConfigName = resolvedPath.split(/[\\/]/).pop() || resolvedPath;

    if (resolvedPath !== configPath) {
      this.configRedirectWarning =
        `CONFIG REDIRECT: requested ${requestedConfigName} -> using ${resolvedConfigName}`;
    }

    this.runner = new TuiRunner();

    this.state = {
      view: 'step-list',
      configPath: resolvedPath,
      config,
      cursor: 0,
      scroll: 0,
      editCursor: 0,
      editBuffer: '',
      editingField: false,
      runCursor: 0,
      runPaused: false,
      runAuto: false,
      runExecuting: false,
      cdpConnected: false,
      cdpBrowser: '',
      sessionDir: '',
      dirty: false,
      statusMessage: this.configRedirectWarning
        || `Loaded ${config.steps.length} steps from ${resolvedConfigName}`,
      conditionalCursor: 0,
      conditionalEditing: false,
      conditionalEditBuffer: '',
      screenRows: rows,
      screenCols: cols,
    };
  }

  private loadConfig(path: string): MacroConfig {
    if (existsSync(path)) {
      try {
        const raw = readFileSync(path, 'utf-8');
        const parsed = JSON.parse(raw);
        // Ensure steps have breakpoint field
        const steps = (parsed.steps || []).map((s: any, i: number) => ({
          ...defaultStep(i + 1),
          ...s,
          enabled: s.enabled ?? true,
          breakpoint: s.breakpoint ?? false,
          _status: undefined,
        }));
        return { ...defaultConfig(), ...parsed, steps };
      } catch {
        return defaultConfig();
      }
    }
    return defaultConfig();
  }

  private saveConfig(): void {
    const dir = join(this.state.configPath, '..');
    if (!existsSync(dir)) mkdirSync(dir, { recursive: true });

    // Strip runtime fields before saving
    const toSave = {
      ...this.state.config,
      steps: this.state.config.steps.map(s => {
        const { _status, _lastResult, _screenshotPath, _durationMs, ...clean } = s;
        return clean;
      }),
      metadata: {
        ...this.state.config.metadata,
        modified: new Date().toISOString().slice(0, 10),
      },
    };
    writeFileSync(this.state.configPath, JSON.stringify(toSave, null, 2));
    this.state.dirty = false;
    this.setStatus('Saved!', c.green);
  }

  private setStatus(msg: string, color: string = c.white): void {
    if (this.state.statusTimeout) clearTimeout(this.state.statusTimeout);
    this.state.statusMessage = color + msg + c.reset;
    this.state.statusTimeout = setTimeout(() => {
      this.state.statusMessage = '';
      this.render();
    }, 4000);
  }

  // Resolve config path: prefer platform-specific file if it exists
  private resolveConfigPath(configPath: string): string {
    // Already platform-specific
    if (configPath.indexOf('-firekirin') >= 0 || configPath.indexOf('-orionstars') >= 0) {
      return configPath;
    }
    // Check if platform-specific files exist
    const baseName = configPath.replace('.json', '');
    const fkPath = `${baseName}-firekirin.json`;
    const osPath = `${baseName}-orionstars.json`;
    if (existsSync(fkPath)) return fkPath;
    if (existsSync(osPath)) return osPath;
    return configPath;
  }

  // ─── Input Handling ──────────────────────────────────────────
  async start(): Promise<void> {
    if (!process.stdin.isTTY) {
      console.error('Error: TUI requires an interactive terminal (TTY).');
      console.error('Run directly: bun run recorder-tui.ts');
      process.exit(1);
    }

    // Global error handler
    process.on('uncaughtException', (err) => {
      this.cleanup();
      console.error('\n\n' + c.red + c.bold + '=== CRASH DETECTED ===' + c.reset);
      console.error(c.red + 'Error: ' + err.message + c.reset);
      console.error(c.gray + err.stack + c.reset);
      process.exit(1);
    });

    process.on('unhandledRejection', (reason) => {
      this.cleanup();
      console.error('\n\n' + c.red + c.bold + '=== UNHANDLED PROMISE REJECTION ===' + c.reset);
      console.error(c.red + 'Reason: ' + reason + c.reset);
      process.exit(1);
    });

    process.stdin.setRawMode(true);
    process.stdin.resume();
    process.stdin.setEncoding('utf8');

    flush(hideCursor() + clearScreen());
    this.render();

    process.stdin.on('data', async (key: string) => {
      if (!this.running) return;
      await this.handleKey(key);
      this.render();
    });

    process.on('SIGWINCH', () => {
      const { rows, cols } = getTermSize();
      this.state.screenRows = rows;
      this.state.screenCols = cols;
      this.render();
    });
  }

  private cleanup(): void {
    try {
      process.stdin.setRawMode(false);
      flush(showCursor());
      flush(clearScreen());
    } catch (e) {
      // Ignore cleanup errors
    }
  }

  private async handleKey(key: string): Promise<void> {
    // Global keys
    if (key === '\x03') { // Ctrl+C
      this.quit();
      return;
    }
    if (key === '\x13') { // Ctrl+S
      if (this.state.view === 'conditional-edit') {
        this.saveConditionalEditor();
      } else {
        this.saveConfig();
      }
      return;
    }
    if (key === '\x1b[15~') { // F4
      this.quit();
      return;
    }

    switch (this.state.view) {
      case 'step-list':   await this.handleStepListKey(key); break;
      case 'step-detail': this.handleStepDetailKey(key); break;
      case 'step-edit':   await this.handleStepEditKey(key); break;
      case 'step-add':    await this.handleStepEditKey(key); break;
      case 'conditional-edit': this.handleConditionalEditKey(key); break;
      case 'run-mode':    await this.handleRunModeKey(key); break;
      case 'help':        this.handleHelpKey(key); break;
    }
  }

  // ─── Step List Keys ──────────────────────────────────────────
  private async handleStepListKey(key: string): Promise<void> {
    const steps = this.state.config.steps;
    const maxVisible = this.state.screenRows - 10;

    switch (key) {
      case '\x1b[A': // Up
        if (this.state.cursor > 0) this.state.cursor--;
        if (this.state.cursor < this.state.scroll) this.state.scroll = this.state.cursor;
        break;
      case '\x1b[B': // Down
        if (this.state.cursor < steps.length - 1) this.state.cursor++;
        if (this.state.cursor >= this.state.scroll + maxVisible) this.state.scroll++;
        break;
      case '\r': // Enter - detail view
        if (steps.length > 0) this.state.view = 'step-detail';
        break;
      case 'a': case 'A': // Add step
        this.addStep();
        break;
      case 'd': case 'D': // Delete step
        this.deleteStep();
        break;
      case 'e': case 'E': // Edit step
        if (steps.length > 0) this.enterEditMode();
        break;
      case 'b': case 'B': // Toggle breakpoint
        if (steps.length > 0) {
          steps[this.state.cursor].breakpoint = !steps[this.state.cursor].breakpoint;
          this.state.dirty = true;
        }
        break;
      case 'f': case 'F': // Connect to CDP
        await this.connectCdp();
        break;
      case 'r': case 'R': // Run from cursor
        await this.enterRunMode();
        break;
      case 's': case 'S': // Screenshot
        await this.takeScreenshot();
        break;
      case 'c': case 'C': // Edit conditional logic
        this.openConditionalEditor();
        break;
      case 'g': case 'G':
        this.promptGotoStep();
        break;
      case 'x': case 'X':
        this.clearStepFlow();
        break;
      case 'k': case 'K':
        this.toggleStepEnabled();
        break;
      case 'l': case 'L': // Clone step
        this.cloneStep();
        break;
      case 'v': case 'V':
        this.showConditionalPreview();
        break;
      case 'u': case 'U': // Move step up
        this.moveStep(-1);
        break;
      case 'j': case 'J': // Move step down
        this.moveStep(1);
        break;
      case 'p': case 'P': { // Toggle platform
        // Save current work first
        if (this.state.dirty) this.saveConfig();
        
        const curPath = this.state.configPath;
        const newPlatform = this.state.config.platform === 'firekirin' ? 'orionstars' : 'firekirin';
        const baseName = curPath.replace('.json', '').replace(/-firekirin|-orionstars/, '');
        const newPath = `${baseName}-${newPlatform}.json`;
        
        // If target file doesn't exist, create it by copying current config
        if (!existsSync(newPath)) {
          const newConfig = JSON.parse(JSON.stringify(this.state.config));
          newConfig.platform = newPlatform;
          writeFileSync(newPath, JSON.stringify(newConfig, null, 2));
        }
        
        // Switch to the other platform's config
        this.state.configPath = newPath;
        this.state.config = this.loadConfig(newPath);
        this.state.config.platform = newPlatform;
        this.state.cursor = 0;
        this.state.dirty = false;
        this.setStatus(`Switched to ${newPlatform} (${newPath.split(/[\\/]/).pop()})`, c.yellow);
        break;
      }
      case '?': case 'h': case 'H':
        this.state.view = 'help';
        break;
      case 'q': case 'Q':
        // Close Chrome but keep TUI open
        await this.runner.killChrome();
        this.state.cdpConnected = false;
        this.setStatus('Chrome closed', c.yellow);
        break;
    }
  }

  // ─── Step Detail Keys ────────────────────────────────────────
  private handleStepDetailKey(key: string): void {
    switch (key) {
      case '\x1b': case 'q': case 'Q': // Esc/Q - back to list
        this.state.view = 'step-list';
        break;
      case 'e': case 'E': case '\r': // Edit
        this.enterEditMode();
        break;
      case 'b': case 'B': // Toggle breakpoint
        this.state.config.steps[this.state.cursor].breakpoint =
          !this.state.config.steps[this.state.cursor].breakpoint;
        this.state.dirty = true;
        break;
      case 'c': case 'C':
        this.openConditionalEditor();
        break;
      case 'g': case 'G':
        this.promptGotoStep();
        break;
      case 'k': case 'K':
        this.toggleStepEnabled();
        break;
      case 'x': case 'X':
        this.clearStepFlow();
        break;
    }
  }

  // ─── Step Edit Keys ──────────────────────────────────────────
  private async handleStepEditKey(key: string): Promise<void> {
    const step = this.state.config.steps[this.state.cursor];
    if (!step) return;

    if (this.state.editingField) {
      // Text input mode - use input filter to prevent escape sequences
      if (isEnter(key)) {
        this.commitField(step);
        this.state.editingField = false;
        return;
      }
      if (isEscape(key)) {
        this.state.editingField = false;
        this.state.editBuffer = '';
        return;
      }
      if (isBackspace(key)) {
        this.state.editBuffer = this.state.editBuffer.slice(0, -1);
        return;
      }
      // Extract only printable characters (filters out arrow keys, etc.)
      const char = extractPrintableChar(key);
      if (char !== null) {
        this.state.editBuffer += char;
      }
      return;
    }

    // Navigation mode
    switch (key) {
      case '\x1b[A': // Up
        if (this.state.editCursor > 0) this.state.editCursor--;
        break;
      case '\x1b[B': // Down
        if (this.state.editCursor < EDIT_FIELDS.length - 1) this.state.editCursor++;
        break;
      case '\r': // Enter - edit field
        this.startEditField(step);
        break;
      case '\t': // Tab - next field
        this.state.editCursor = (this.state.editCursor + 1) % EDIT_FIELDS.length;
        break;
      case 'c': case 'C': // Capture click context at current coordinates
        await this.captureClickContext(step);
        break;
      case '\x1b': case 'q': case 'Q': // Esc - back
        if (this.state.view === 'step-add') {
          // If adding, step was already pushed; only remove if user cancels
        }
        this.state.view = 'step-list';
        break;
    }
  }

  // ─── Run Mode Keys ──────────────────────────────────────────
  private async handleRunModeKey(key: string): Promise<void> {
    if (this.state.runExecuting) {
      // Only allow abort while executing
      if (key === '\x1b' || key === 'q' || key === 'Q') {
        this.runner.abort();
        this.state.runAuto = false;
        this.setStatus('Aborting current step...', c.red);
      }
      return;
    }

    // At breakpoint: Space for single-step, A to resume auto-run
    if (this.state.runPaused) {
      switch (key) {
        case ' ': // Space - single step only
          this.state.runPaused = false;
          this.state.runAuto = false;
          await this.runNextStep(true); // skip breakpoint re-check on current step
          // After executing, check if we should pause again
          if (this.state.view === 'run-mode' && this.state.runCursor < this.state.config.steps.length) {
            const nextStep = this.state.config.steps[this.state.runCursor];
            if (nextStep && (nextStep.enabled ?? true)) {
              // Always pause after single-step for manual control
              this.state.runPaused = true;
              nextStep._status = 'running';
              if (nextStep.breakpoint) {
                this.setStatus(`Breakpoint at step ${nextStep.stepId} — Space to continue, A to auto-run`, c.red);
              } else {
                this.setStatus(`Paused at step ${nextStep.stepId} — Space to continue, A to auto-run`, c.yellow);
              }
            }
          }
          break;
        case 'a': case 'A': // Resume auto-run
          this.state.runPaused = false;
          this.state.runAuto = true;
          await this.runNextStep(true); // execute the breakpoint step
          if (this.state.view === 'run-mode' && this.state.runAuto) {
            await this.autoRunLoop();
          }
          break;
        case '\x1b': case 'q': case 'Q': // Esc - abort & return
          this.state.runAuto = false;
          this.runner.abort();
          this.state.view = 'step-list';
          this.setStatus('Run aborted', c.yellow);
          break;
      }
      return;
    }

    // Not paused, not executing - shouldn't happen in auto-run mode
    switch (key) {
      case '\x1b': case 'q': case 'Q': // Esc - abort & return
        this.state.runAuto = false;
        this.runner.abort();
        this.state.view = 'step-list';
        this.setStatus('Run aborted', c.yellow);
        break;
    }
  }

  private handleHelpKey(key: string): void {
    if (key === '\x1b' || key === 'q' || key === 'Q' || key === '?' || key === '\r') {
      this.state.view = 'step-list';
    }
  }

  private handleConditionalEditKey(key: string): void {
    if (!this.conditionalState) {
      this.state.view = 'step-list';
      return;
    }
    if (this.state.conditionalEditing) {
      // Text input mode - use input filter to prevent escape sequences
      if (isEnter(key)) {
        this.commitConditionalField();
        this.state.conditionalEditing = false;
        return;
      }
      if (isEscape(key)) {
        this.state.conditionalEditing = false;
        this.state.conditionalEditBuffer = '';
        return;
      }
      if (isBackspace(key)) {
        this.state.conditionalEditBuffer = this.state.conditionalEditBuffer.slice(0, -1);
        return;
      }
      // Extract only printable characters (filters out arrow keys, etc.)
      const char = extractPrintableChar(key);
      if (char !== null) {
        this.state.conditionalEditBuffer += char;
      }
      return;
    }

    switch (key) {
      case '\x1b[A':
        this.state.conditionalCursor = Math.max(0, this.state.conditionalCursor - 1);
        break;
      case '\x1b[B':
        this.state.conditionalCursor = Math.min(13, this.state.conditionalCursor + 1);
        break;
      case '\r': {
        const current = this.getConditionalFieldValue();
        if (this.isConditionalCycleField(this.state.conditionalCursor)) {
          this.cycleConditionalField();
          this.state.dirty = true;
        } else {
          this.state.conditionalEditing = true;
          this.state.conditionalEditBuffer = current;
        }
        break;
      }
      case '\t':
        this.state.conditionalCursor = (this.state.conditionalCursor + 1) % 14;
        break;
      case '\x13':
      case 's':
      case 'S':
        this.saveConditionalEditor();
        break;
      case '\x04':
      case 'x':
      case 'X':
        this.clearStepConditionalOnly();
        break;
      case '\x1b':
      case 'q':
      case 'Q':
        this.closeConditionalEditor(false);
        break;
    }
  }

  private openConditionalEditor(): void {
    const step = this.state.config.steps[this.state.cursor];
    if (!step) return;
    this.conditionalState = loadConditionalState(step.conditional);
    this.state.conditionalCursor = 0;
    this.state.conditionalEditing = false;
    this.state.conditionalEditBuffer = '';
    this.state.view = 'conditional-edit';
  }

  private saveConditionalEditor(): void {
    if (!this.conditionalState) return;
    const step = this.state.config.steps[this.state.cursor];
    if (!step) return;
    step.conditional = buildConditionalLogic(this.conditionalState);
    this.state.dirty = true;
    this.closeConditionalEditor(true);
    this.setStatus(`Conditional saved for step ${step.stepId}`, c.green);
  }

  private closeConditionalEditor(saved: boolean): void {
    this.conditionalState = null;
    this.state.conditionalEditing = false;
    this.state.conditionalEditBuffer = '';
    this.state.conditionalCursor = 0;
    this.state.view = 'step-list';
    if (!saved) {
      this.setStatus('Conditional edit cancelled', c.yellow);
    }
  }

  private clearStepConditionalOnly(): void {
    const step = this.state.config.steps[this.state.cursor];
    if (!step) return;
    step.conditional = undefined;
    this.state.dirty = true;
    this.closeConditionalEditor(true);
    this.setStatus(`Conditional cleared for step ${step.stepId}`, c.yellow);
  }

  private isConditionalCycleField(cursor: number): boolean {
    return cursor === 0 || cursor === 4 || cursor === 9;
  }

  private cycleConditionalField(): void {
    if (!this.conditionalState) return;
    if (this.state.conditionalCursor === 0) {
      const types: Array<ConditionalEditorState['conditionType']> = [
        'element-exists',
        'element-missing',
        'text-contains',
        'cdp-check',
        'tool-success',
        'tool-failure',
        'custom-js',
      ];
      const idx = types.indexOf(this.conditionalState.conditionType);
      this.conditionalState.conditionType = types[(idx + 1) % types.length];
      return;
    }
    if (this.state.conditionalCursor === 4 || this.state.conditionalCursor === 9) {
      const actions: Array<ConditionalEditorState['onTrueAction']> = [
        'continue',
        'goto',
        'retry',
        'abort',
      ];
      if (this.state.conditionalCursor === 4) {
        const idx = actions.indexOf(this.conditionalState.onTrueAction);
        this.conditionalState.onTrueAction = actions[(idx + 1) % actions.length];
      } else {
        const idx = actions.indexOf(this.conditionalState.onFalseAction);
        this.conditionalState.onFalseAction = actions[(idx + 1) % actions.length];
      }
    }
  }

  private getConditionalFieldValue(): string {
    if (!this.conditionalState) return '';
    const s = this.conditionalState;
    switch (this.state.conditionalCursor) {
      case 0: return s.conditionType;
      case 1: return s.conditionTarget;
      case 2: return s.cdpCommand;
      case 3: return s.conditionDescription;
      case 4: return s.onTrueAction;
      case 5: return s.onTrueGotoStep ? String(s.onTrueGotoStep) : '';
      case 6: return s.onTrueRetryCount ? String(s.onTrueRetryCount) : '';
      case 7: return s.onTrueRetryDelayMs ? String(s.onTrueRetryDelayMs) : '';
      case 8: return s.onTrueComment;
      case 9: return s.onFalseAction;
      case 10: return s.onFalseGotoStep ? String(s.onFalseGotoStep) : '';
      case 11: return s.onFalseRetryCount ? String(s.onFalseRetryCount) : '';
      case 12: return s.onFalseRetryDelayMs ? String(s.onFalseRetryDelayMs) : '';
      case 13: return s.onFalseComment;
      default: return '';
    }
  }

  private commitConditionalField(): void {
    if (!this.conditionalState) return;
    const val = this.state.conditionalEditBuffer;
    const toInt = (input: string): number | undefined => {
      const parsed = parseInt(input);
      return Number.isFinite(parsed) && parsed > 0 ? parsed : undefined;
    };
    switch (this.state.conditionalCursor) {
      case 1: this.conditionalState.conditionTarget = val; break;
      case 2: this.conditionalState.cdpCommand = val; break;
      case 3: this.conditionalState.conditionDescription = val; break;
      case 5: this.conditionalState.onTrueGotoStep = toInt(val); break;
      case 6: this.conditionalState.onTrueRetryCount = toInt(val); break;
      case 7: this.conditionalState.onTrueRetryDelayMs = toInt(val); break;
      case 8: this.conditionalState.onTrueComment = val; break;
      case 10: this.conditionalState.onFalseGotoStep = toInt(val); break;
      case 11: this.conditionalState.onFalseRetryCount = toInt(val); break;
      case 12: this.conditionalState.onFalseRetryDelayMs = toInt(val); break;
      case 13: this.conditionalState.onFalseComment = val; break;
    }
    this.state.conditionalEditBuffer = '';
    this.state.dirty = true;
  }

  // ─── Capture Click Context ──────────────────────────────────
  // ARCH-081: Captures click coordinates from Chrome via CDP with relative coords
  private async captureClickContext(step: MacroStep): Promise<void> {
    if (!this.state.cdpConnected) {
      this.setStatus('CDP not connected — press F to connect first', c.red);
      return;
    }

    // Bring Chrome to front for user to click
    await this.runner.bringChromeToFront();
    
    this.setStatus('Click in Chrome to capture coordinates... (30s timeout)', c.yellow);
    this.render();

    let result;
    try {
      result = await this.runner.waitForClick(30000);
    } catch (err: any) {
      this.setStatus(`Capture failed: ${err.message}`, c.red);
      await this.runner.focusTui();
      return;
    }
    
    if (!result) {
      this.setStatus('Click capture timed out (30s) — click was not detected', c.red);
      await this.runner.focusTui();
      return;
    }
    
    // Update step with captured coordinates and context
    step.coordinates = { rx: result.rx, ry: result.ry, x: result.x, y: result.y };
    step.canvasBounds = result.canvasBounds;
    step.comment = `Button: (${result.x},${result.y}) rx=${result.rx.toFixed(4)} ry=${result.ry.toFixed(4)} | ${result.context}`;
    this.state.dirty = true;
    
    // Refocus TUI
    await this.runner.focusTui();
    const boundsInfo = result.canvasBounds.width > 0
      ? ` [canvas: ${result.canvasBounds.width}x${result.canvasBounds.height}]`
      : '';
    this.setStatus(`Captured: (${result.x},${result.y}) rx=${result.rx.toFixed(4)} ry=${result.ry.toFixed(4)}${boundsInfo}`, c.green);
  }

  // ─── Step CRUD ───────────────────────────────────────────────
  private addStep(): void {
    const steps = this.state.config.steps;
    const nextId = steps.length > 0 ? Math.max(...steps.map(s => s.stepId)) + 1 : 1;
    const newStep = defaultStep(nextId);

    // Copy phase from current step if exists
    if (steps.length > 0 && this.state.cursor < steps.length) {
      newStep.phase = steps[this.state.cursor].phase;
    }

    // Insert after cursor
    const insertAt = this.state.cursor + 1;
    steps.splice(insertAt, 0, newStep);
    this.renumberSteps();
    this.state.cursor = insertAt;
    this.state.dirty = true;
    this.state.view = 'step-edit';
    this.state.editCursor = 0;
    this.setStatus('New step added — edit fields and press Esc when done', c.green);
  }

  private deleteStep(): void {
    const steps = this.state.config.steps;
    if (steps.length === 0) return;
    steps.splice(this.state.cursor, 1);
    this.renumberSteps();
    if (this.state.cursor >= steps.length) this.state.cursor = Math.max(0, steps.length - 1);
    this.state.dirty = true;
    this.setStatus('Step deleted', c.red);
  }

  private cloneStep(): void {
    const steps = this.state.config.steps;
    if (steps.length === 0) return;
    const original = steps[this.state.cursor];
    const clone = { ...JSON.parse(JSON.stringify(original)), breakpoint: false, _status: undefined };
    const insertAt = this.state.cursor + 1;
    steps.splice(insertAt, 0, clone);
    this.renumberSteps();
    this.state.cursor = insertAt;
    this.state.dirty = true;
    this.setStatus('Step cloned', c.cyan);
  }

  private promptGotoStep(): void {
    const step = this.state.config.steps[this.state.cursor];
    if (!step) return;
    this.state.view = 'step-edit';
    this.state.editCursor = EDIT_FIELDS.indexOf('gotoStep');
    this.state.editingField = true;
    this.state.editBuffer = step.gotoStep ? String(step.gotoStep) : '';
  }

  private clearStepFlow(): void {
    const step = this.state.config.steps[this.state.cursor];
    if (!step) return;
    step.gotoStep = undefined;
    step.conditional = undefined;
    this.state.dirty = true;
    this.setStatus(`Cleared flow controls on step ${step.stepId}`, c.yellow);
  }

  private toggleStepEnabled(): void {
    const step = this.state.config.steps[this.state.cursor];
    if (!step) return;
    step.enabled = !(step.enabled ?? true);
    this.state.dirty = true;
    this.setStatus(
      `Step ${step.stepId} ${step.enabled ? 'enabled' : 'disabled'}`,
      step.enabled ? c.green : c.yellow
    );
  }

  private showConditionalPreview(): void {
    const step = this.state.config.steps[this.state.cursor];
    if (!step) return;
    if (!step.conditional) {
      this.setStatus(`Step ${step.stepId} has no conditional`, c.yellow);
      return;
    }
    const desc = step.conditional.condition.description || step.conditional.condition.type;
    this.setStatus(`IF ${desc}`, c.cyan);
  }

  private moveStep(dir: -1 | 1): void {
    const steps = this.state.config.steps;
    const idx = this.state.cursor;
    const target = idx + dir;
    if (target < 0 || target >= steps.length) return;
    [steps[idx], steps[target]] = [steps[target], steps[idx]];
    this.renumberSteps();
    this.state.cursor = target;
    this.state.dirty = true;
  }

  private renumberSteps(): void {
    this.state.config.steps.forEach((s, i) => { s.stepId = i + 1; });
  }

  // ─── Field Editing ───────────────────────────────────────────
  private startEditField(step: MacroStep): void {
    const field = EDIT_FIELDS[this.state.editCursor];
    const val = this.getFieldValue(step, field);

    // Cycle-select fields
    if (field === 'phase') {
      const idx = PHASES.indexOf(step.phase as any);
      step.phase = PHASES[(idx + 1) % PHASES.length];
      this.state.dirty = true;
      return;
    }
    if (field === 'action') {
      const idx = ACTIONS.indexOf(step.action as any);
      step.action = ACTIONS[(idx + 1) % ACTIONS.length];
      this.state.dirty = true;
      return;
    }
    if (field === 'tool') {
      const idx = TOOLS.indexOf(step.tool as any);
      step.tool = TOOLS[(idx + 1) % TOOLS.length];
      this.state.dirty = true;
      return;
    }
    if (field === 'takeScreenshot') {
      step.takeScreenshot = !step.takeScreenshot;
      this.state.dirty = true;
      return;
    }
    if (field === 'conditional') {
      this.openConditionalEditor();
      return;
    }

    // Text input fields
    this.state.editingField = true;
    this.state.editBuffer = val;
  }

  private getFieldValue(step: MacroStep, field: EditField): string {
    switch (field) {
      case 'phase': return step.phase;
      case 'action': return step.action || '';
      case 'tool': return step.tool;
      case 'coordinates_x': return String(step.coordinates?.x ?? 0);
      case 'coordinates_y': return String(step.coordinates?.y ?? 0);
      case 'coordinates_rx': return String(('rx' in (step.coordinates || {})) ? (step.coordinates as any).rx : 0);
      case 'coordinates_ry': return String(('ry' in (step.coordinates || {})) ? (step.coordinates as any).ry : 0);
      case 'input': return step.input || '';
      case 'url': return step.url || '';
      case 'holdMs': return String(step.holdMs ?? 3000);
      case 'delayMs': return String(step.delayMs ?? 500);
      case 'takeScreenshot': return step.takeScreenshot ? 'Yes' : 'No';
      case 'screenshotReason': return step.screenshotReason;
      case 'comment': return step.comment;
      case 'entryGate': return step.verification.entryGate;
      case 'exitGate': return step.verification.exitGate;
      case 'gotoStep': return step.gotoStep ? String(step.gotoStep) : '';
      case 'conditional': return step.conditional ? 'Configured (Enter to edit)' : 'Not set (Enter to add)';
    }
  }

  private commitField(step: MacroStep): void {
    const field = EDIT_FIELDS[this.state.editCursor];
    const val = this.state.editBuffer;
    switch (field) {
      case 'coordinates_x':
        if (!step.coordinates) step.coordinates = { rx: 0, ry: 0, x: 0, y: 0 };
        step.coordinates.x = parseInt(val) || 0;
        break;
      case 'coordinates_y':
        if (!step.coordinates) step.coordinates = { rx: 0, ry: 0, x: 0, y: 0 };
        step.coordinates.y = parseInt(val) || 0;
        break;
      case 'coordinates_rx':
        if (!step.coordinates) step.coordinates = { rx: 0, ry: 0, x: 0, y: 0 };
        (step.coordinates as any).rx = parseFloat(val) || 0;
        break;
      case 'coordinates_ry':
        if (!step.coordinates) step.coordinates = { rx: 0, ry: 0, x: 0, y: 0 };
        (step.coordinates as any).ry = parseFloat(val) || 0;
        break;
      case 'input': step.input = val; break;
      case 'url': step.url = val; break;
      case 'holdMs': step.holdMs = parseInt(val) || 3000; break;
      case 'delayMs': step.delayMs = parseInt(val) || 500; break;
      case 'screenshotReason': step.screenshotReason = val; break;
      case 'comment': step.comment = val; break;
      case 'entryGate': step.verification.entryGate = val; break;
      case 'exitGate': step.verification.exitGate = val; break;
      case 'gotoStep':
        step.gotoStep = parseInt(val) > 0 ? parseInt(val) : undefined;
        break;
      case 'conditional':
        break;
    }
    this.state.editBuffer = '';
    this.state.dirty = true;
  }

  // ─── Edit Mode Entry ────────────────────────────────────────
  private enterEditMode(): void {
    this.state.view = 'step-edit';
    this.state.editCursor = 0;
    this.state.editingField = false;
    this.state.editBuffer = '';
  }

  // ─── CDP Connection ────────────────────────────────────────
  private async connectCdp(): Promise<void> {
    this.setStatus('Connecting to Chrome CDP...', c.yellow);
    this.render();
    const result = await this.runner.ensureChrome();
    if (result.ok) {
      this.state.cdpConnected = true;
      this.state.cdpBrowser = result.message;
      this.state.sessionDir = this.runner.screenshotDir;
      this.setStatus(`CDP: ${result.message}`, c.green);
    } else {
      this.state.cdpConnected = false;
      this.setStatus(`CDP failed: ${result.message}`, c.red);
    }
  }

  // ─── Run Mode ────────────────────────────────────────────────
  private async enterRunMode(): Promise<void> {
    // Auto-connect if not connected
    if (!this.state.cdpConnected) {
      this.setStatus('Connecting to Chrome CDP before run...', c.yellow);
      this.render();
      const conn = await this.runner.ensureChrome();
      if (!conn.ok) {
        this.setStatus(`Cannot run — CDP: ${conn.message}`, c.red);
        return;
      }
      this.state.cdpConnected = true;
      this.state.cdpBrowser = conn.message;
      this.state.sessionDir = this.runner.screenshotDir;
    }

    this.state.view = 'run-mode';
    this.state.runCursor = this.state.cursor;
    this.state.runPaused = false;
    this.state.runAuto = true; // Auto-run by default
    this.state.runExecuting = false;
    // Reset statuses
    this.state.config.steps.forEach(s => {
      s._status = 'pending';
      s._lastResult = undefined;
      s._screenshotPath = undefined;
      s._durationMs = undefined;
    });
    // Initialize dashboard state
    this.timeline = [];
    this.runStats = createRunStats(this.state.config.steps);
    // Bring Chrome to front so user can see actions, then refocus TUI for input
    await this.runner.bringChromeToFront();
    await this.runner.focusTui();

    this.setStatus(`Auto-run started at step ${this.state.runCursor + 1} — Esc to abort`, c.green);
    this.render();
    // Start auto-run loop immediately
    await this.autoRunLoop();
  }

  private async runNextStep(skipBreakpoint = false): Promise<void> {
    const steps = this.state.config.steps;
    if (this.state.runCursor >= steps.length) {
      const passed = steps.filter(s => s._status === 'passed').length;
      const failed = steps.filter(s => s._status === 'failed').length;
      this.setStatus(`Run complete! ${passed} passed, ${failed} failed`, passed === steps.length ? c.green : c.yellow);
      this.state.runAuto = false;
      this.state.view = 'step-list';
      return;
    }

    const step = steps[this.state.runCursor];
    if ((step.enabled ?? true) === false) {
      step._status = 'skipped';
      step._lastResult = 'Skipped (disabled)';
      this.state.runCursor++;
      return;
    }

    // Check breakpoint
    if (step.breakpoint && !skipBreakpoint) {
      this.state.runPaused = true;
      this.state.runAuto = false;
      step._status = 'running';
      this.setStatus(`Breakpoint at step ${step.stepId} — Space to continue, A to auto-run`, c.red);
      this.render();
      return;
    }

    // Execute step for real via CDP
    step._status = 'running';
    this.state.runExecuting = true;
    this.setStatus(`Executing step ${step.stepId}: ${step.action || step.tool}...`, c.cyan);
    this.render();

    const result = await this.runner.executeStep(step);

    this.state.runExecuting = false;
    step._durationMs = result.durationMs;
    step._screenshotPath = result.screenshotPath;

    let branchAction: 'continue' | 'goto' | 'retry' | 'abort' = 'continue';
    let branchGoto: number | undefined;
    let branchRetries = 0;
    let branchRetryDelayMs = 0;
    let branchNote = '';
    let condBranch: 'true' | 'false' | 'none' = 'none';

    if (result.success) {
      step._status = 'passed';
      step._lastResult = result.message;
    } else {
      step._status = 'failed';
      step._lastResult = result.message;
      if (step.gotoStep) {
        branchAction = 'goto';
        branchGoto = step.gotoStep;
        branchNote = `failure goto step ${step.gotoStep}`;
      }
      if (!this.state.runAuto && !step.gotoStep) {
        this.recordTimeline(step, result.message, branchNote, condBranch, branchGoto);
        this.setStatus(`Step ${step.stepId} failed: ${result.message}`, c.red);
        this.render();
        return;
      }
    }

    if (step.conditional) {
      const conditional = step.conditional;
      const conditionalResult =
        conditional.condition.type === 'tool-success' || conditional.condition.type === 'tool-failure'
          ? this.runner.evaluateToolConditional(conditional, result.success)
          : await this.runner.evaluateConditional(conditional);

      branchAction = conditionalResult.branch.action;
      branchGoto = conditionalResult.branch.gotoStep;
      branchRetries = Math.min(
        MAX_RETRY_COUNT,
        Math.max(0, conditionalResult.branch.retryCount || 0)
      );
      branchRetryDelayMs = Math.max(0, conditionalResult.branch.retryDelayMs || 0);
      branchNote = `conditional ${conditionalResult.conditionMet ? 'TRUE' : 'FALSE'}: ${conditionalResult.details}`;
      condBranch = conditionalResult.conditionMet ? 'true' : 'false';
      step._lastResult = `${step._lastResult || ''} | ${branchNote}`;
    }

    // Record timeline entry for dashboard
    this.recordTimeline(step, result.message, branchNote, condBranch, branchGoto);

    if (branchAction === 'retry') {
      if (branchRetries <= 0) {
        this.setStatus(`Retry requested with invalid retryCount on step ${step.stepId}`, c.red);
        this.state.runAuto = false;
        this.state.view = 'step-list';
        return;
      }
      for (let attempt = 1; attempt <= branchRetries; attempt++) {
        if (branchRetryDelayMs > 0) {
          await this.waitWithAbort(branchRetryDelayMs);
          if (this.state.view !== 'run-mode') return;
        }
        this.setStatus(`Retry ${attempt}/${branchRetries} for step ${step.stepId}`, c.yellow);
        this.render();
        const retryResult = await this.runner.executeStep(step);
        step._durationMs = retryResult.durationMs;
        step._screenshotPath = retryResult.screenshotPath;
        step._lastResult = `retry ${attempt}: ${retryResult.message}`;
        if (retryResult.success) {
          step._status = 'passed';
          branchAction = 'continue';
          break;
        }
        step._status = 'failed';
      }
      if (step._status === 'failed') {
        branchAction = branchGoto ? 'goto' : 'abort';
      }
    }

    if (branchAction === 'abort') {
      this.state.runAuto = false;
      this.state.view = 'step-list';
      this.setStatus(`Run aborted by flow control at step ${step.stepId}`, c.red);
      this.render();
      return;
    }

    if (branchAction === 'goto' && branchGoto) {
      const targetIdx = steps.findIndex(s => s.stepId === branchGoto);
      if (targetIdx >= 0) {
        const jumpCount = steps.filter(s => (s._lastResult || '').includes('[jump]')).length;
        if (jumpCount >= MAX_FLOW_JUMPS) {
          this.state.runAuto = false;
          this.state.view = 'step-list';
          this.setStatus('Flow jump guard triggered (possible infinite loop)', c.red);
          return;
        }
        step._lastResult = `${step._lastResult || ''} [jump]`;
        this.state.runCursor = targetIdx;
        this.setStatus(`Flow jump to step ${branchGoto}`, c.cyan);
        this.render();
        return;
      }
      this.setStatus(`Invalid goto target ${branchGoto} on step ${step.stepId}`, c.red);
      this.state.runAuto = false;
      this.state.view = 'step-list';
      return;
    }

    // Advance
    this.state.runCursor++;
    if (this.state.runCursor >= steps.length) {
      const passed = steps.filter(s => s._status === 'passed').length;
      const failed = steps.filter(s => s._status === 'failed').length;
      this.setStatus(`Run complete! ${passed} passed, ${failed} failed`, passed === steps.length ? c.green : c.yellow);
      this.state.runAuto = false;
      this.state.view = 'step-list';
      // Write run summary
      try { await this.runner.writeRunSummary(steps); } catch {}
    }
    this.render();
  }

  private async autoRunLoop(): Promise<void> {
    while (this.state.runAuto && this.state.view === 'run-mode') {
      if (this.state.runPaused) return; // breakpoint hit, user must resume
      if (this.state.runCursor >= this.state.config.steps.length) return;
      await this.runNextStep();
    }
  }

  private async waitWithAbort(ms: number): Promise<void> {
    const until = Date.now() + ms;
    while (Date.now() < until) {
      await new Promise(resolve => setTimeout(resolve, 100));
      if (!this.state.runAuto || this.state.view !== 'run-mode') return;
    }
  }

  // ─── Timeline Recording ────────────────────────────────────────
  private recordTimeline(
    step: MacroStep,
    message: string,
    conditionalResult: string,
    branchTaken: 'true' | 'false' | 'none',
    jumpedTo?: number,
    retryAttempt?: number
  ): void {
    this.timeline.push({
      stepId: step.stepId,
      action: step.action || step.tool || '—',
      status: step._status === 'passed' ? 'passed'
        : step._status === 'failed' ? 'failed'
        : step._status === 'skipped' ? 'skipped'
        : retryAttempt ? 'retrying'
        : 'passed',
      message,
      durationMs: step._durationMs || 0,
      timestamp: Date.now(),
      retryAttempt,
      conditionalResult: conditionalResult || undefined,
      branchTaken: branchTaken !== 'none' ? branchTaken : undefined,
      jumpedTo,
    });
    // Update stats
    if (this.runStats) {
      updateRunStats(this.runStats, this.state.config.steps);
    }
  }

  // ─── Screenshot ──────────────────────────────────────────────
  private async takeScreenshot(): Promise<void> {
    if (!this.state.cdpConnected) {
      this.setStatus('Not connected — press F to connect CDP first', c.red);
      return;
    }
    this.setStatus('Capturing screenshot...', c.yellow);
    this.render();
    const label = `manual_${new Date().toISOString().replace(/[:.]/g, '-').slice(11, 19)}`;
    const result = await this.runner.takeScreenshot(label);
    if (result.ok) {
      this.setStatus(`Screenshot: ${result.path}`, c.green);
    } else {
      this.setStatus(`Screenshot failed: ${result.message}`, c.red);
    }
  }

  // ─── Quit ────────────────────────────────────────────────────
  private quit(): void {
    if (this.state.dirty) {
      this.saveConfig();
    }
    this.runner.disconnect();
    this.running = false;
    flush(showCursor() + clearScreen() + moveTo(1, 1));
    console.log('Saved and exited.');
    process.exit(0);
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  //  RENDERING
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  private render(): void {
    const { screenRows: rows, screenCols: cols } = this.state;
    let out = clearScreen();

    // Header
    out += this.renderHeader(cols);

    switch (this.state.view) {
      case 'step-list':   out += this.renderStepList(rows, cols); break;
      case 'step-detail': out += this.renderStepDetail(rows, cols); break;
      case 'step-edit':   out += this.renderStepEdit(rows, cols); break;
      case 'conditional-edit': out += this.renderConditionalEdit(rows, cols); break;
      case 'run-mode':    out += this.renderRunMode(rows, cols); break;
      case 'help':        out += this.renderHelp(rows, cols); break;
    }

    // Status bar
    out += this.renderStatusBar(rows, cols);

    flush(out);
  }

  // ─── Header ────────────────────────────────────────────────────
  private renderHeader(cols: number): string {
    let out = '';
    const title = ` P4NTH30N RECORDER ${c.gray}v3.0${c.reset} `;
    const platform = this.state.config.platform === 'firekirin'
      ? `${c.brightRed}FireKirin${c.reset}`
      : `${c.brightBlue}OrionStars${c.reset}`;
    const dirty = this.state.dirty ? `${c.red} [UNSAVED]${c.reset}` : '';
    const cdpStatus = this.state.cdpConnected
      ? `${c.green}CDP:ON${c.reset}`
      : `${c.red}CDP:OFF${c.reset}`;
    const mode = `${c.gray}${this.state.view}${c.reset}`;

    out += moveTo(1, 1) + c.bgGray + c.brightWhite + c.bold;
    out += pad(` ${title}  ${c.reset}${c.bgGray}${platform}${dirty}  ${cdpStatus}${c.bgGray}  ${mode}`, cols);
    out += c.reset;
    return out;
  }

  // ─── Step List View ──────────────────────────────────────────
  private renderStepList(rows: number, cols: number): string {
    let out = '';
    const steps = this.state.config.steps;
    const listW = Math.min(cols - 2, 62);
    const detailW = cols - listW - 3;
    const listH = rows - 5;

    // Left panel: step list
    out += drawBox(2, 1, listW, listH, 'Steps', c.cyan);

    if (steps.length === 0) {
      out += writeAt(4, 3, `${c.gray}No steps yet. Press ${c.bold}A${c.reset}${c.gray} to add one.${c.reset}`);
    } else {
      const maxVisible = listH - 2;
      for (let i = 0; i < maxVisible && (i + this.state.scroll) < steps.length; i++) {
        const si = i + this.state.scroll;
        const step = steps[si];
        const isCurrent = si === this.state.cursor;
        const row = 3 + i;

        let line = '';
        // Cursor indicator
        line += isCurrent ? `${c.brightCyan}${icon.cursor} ` : '  ';
        // Breakpoint
        line += step.breakpoint ? `${c.red}${icon.dot}${c.reset}` : ' ';
        if ((step.enabled ?? true) === false) {
          line += `${c.gray}⏸${c.reset}`;
        } else {
          line += ' ';
        }
        // Step number
        line += `${c.gray}${String(step.stepId).padStart(2)}${c.reset} `;
        // Phase badge
        line += this.phaseBadge(step.phase) + ' ';
        // Action/tool
        const actionStr = step.action || step.tool || '—';
        line += `${c.white}${actionStr}${c.reset} `;
        // Coordinates
        if (step.coordinates && step.action === 'click') {
          const coord = step.coordinates;
          if ('rx' in coord) {
            line += `${c.gray}(${(coord as any).rx.toFixed(2)},${(coord as any).ry.toFixed(2)})${c.reset} `;
          } else {
            line += `${c.gray}(${coord.x},${coord.y})${c.reset} `;
          }
        }
        // Input preview
        if (step.input) {
          line += `${c.yellow}"${step.input.slice(0, 12)}"${c.reset} `;
        }
        // Status icon
        line += this.statusIcon(step._status);
        // Screenshot indicator
        if (step.takeScreenshot) line += ` ${c.gray}${icon.camera}${c.reset}`;
        if (step.conditional) line += ` ${c.brightYellow}[IF]${c.reset}`;
        if (step.gotoStep) line += ` ${c.brightMagenta}[→${step.gotoStep}]${c.reset}`;

        // Highlight current line
        if (isCurrent) {
          line = `${c.inverse}${line}${c.reset}`;
        }

        out += writeAt(row, 2, pad(line, listW - 2));
      }

      // Scrollbar hint
      if (steps.length > listH - 2) {
        const pct = Math.round((this.state.scroll / (steps.length - listH + 2)) * (listH - 3));
        out += writeAt(3 + pct, listW - 1, `${c.cyan}▐${c.reset}`);
      }
    }

    // Right panel: selected step details
    out += drawBox(2, listW + 1, detailW, listH, 'Details', c.gray);

    if (steps.length > 0) {
      const step = steps[this.state.cursor];
      let r = 3;
      const dc = listW + 3;
      const dw = detailW - 4;
      out += writeAt(r++, dc, `${c.bold}Step ${step.stepId}${c.reset}`);
      out += writeAt(r++, dc, `${c.cyan}Phase:${c.reset}  ${step.phase}`);
      out += writeAt(r++, dc, `${c.cyan}Action:${c.reset} ${step.action || '—'}`);
      out += writeAt(r++, dc, `${c.cyan}Tool:${c.reset}   ${step.tool}`);
      out += writeAt(r++, dc, `${c.cyan}Enabled:${c.reset} ${step.enabled ?? true ? `${c.green}Yes${c.reset}` : `${c.yellow}No${c.reset}`}`);
      if (step.coordinates) {
        const coord = step.coordinates;
        if ('rx' in coord) {
          out += writeAt(r++, dc, `${c.cyan}Coords:${c.reset} rx=${(coord as any).rx.toFixed(4)} ry=${(coord as any).ry.toFixed(4)}`);
          out += writeAt(r++, dc, `${c.cyan}  Abs:${c.reset}  (${coord.x}, ${coord.y})`);
        } else {
          out += writeAt(r++, dc, `${c.cyan}Coords:${c.reset} (${coord.x}, ${coord.y})`);
        }
      }
      if (step.input) {
        out += writeAt(r++, dc, `${c.cyan}Input:${c.reset}  ${step.input.slice(0, dw - 8)}`);
      }
      out += writeAt(r++, dc, `${c.cyan}Delay:${c.reset}  ${step.delayMs || 0}ms`);
      out += writeAt(r++, dc, `${c.cyan}Screenshot:${c.reset} ${step.takeScreenshot ? 'Yes' : 'No'}`);
      out += writeAt(r++, dc, `${c.cyan}Breakpoint:${c.reset} ${step.breakpoint ? `${c.red}Yes${c.reset}` : 'No'}`);
      out += writeAt(r++, dc, `${c.cyan}Goto:${c.reset} ${step.gotoStep || '—'}`);
      out += writeAt(r++, dc, `${c.cyan}Conditional:${c.reset} ${step.conditional ? `${c.brightYellow}Configured${c.reset}` : '—'}`);
      if (step.conditional?.condition.description) {
        out += writeAt(r++, dc, `${c.gray}IF ${step.conditional.condition.description.slice(0, dw - 3)}${c.reset}`);
      }
      r++;
      if (step.comment) {
        out += writeAt(r++, dc, `${c.gray}${step.comment.slice(0, dw)}${c.reset}`);
      }
      if (step.verification.entryGate) {
        r++;
        out += writeAt(r++, dc, `${c.green}Entry:${c.reset} ${step.verification.entryGate.slice(0, dw - 7)}`);
      }
      if (step.verification.exitGate) {
        out += writeAt(r++, dc, `${c.green}Exit:${c.reset}  ${step.verification.exitGate.slice(0, dw - 7)}`);
      }
    }

    // Hotkey bar
    const hkRow = rows - 3;
    out += moveTo(hkRow, 1);
    out += `${c.bgGray}${c.brightWhite}`;
    out += pad(
      ` ${c.bold}A${c.reset}${c.bgGray}dd  ` +
      `${c.bold}E${c.reset}${c.bgGray}dit  ` +
      `${c.bold}D${c.reset}${c.bgGray}el  ` +
      `${c.bold}B${c.reset}${c.bgGray}reakpt  ` +
      `${c.bold}F${c.reset}${c.bgGray}Connect  ` +
      `${c.bold}R${c.reset}${c.bgGray}un  ` +
      `${c.bold}S${c.reset}${c.bgGray}creenshot  ` +
      `${c.bold}C${c.reset}${c.bgGray}onditional  ` +
      `${c.bold}G${c.reset}${c.bgGray}oto  ` +
      `${c.bold}X${c.reset}${c.bgGray}ClearFlow  ` +
      `${c.bold}K${c.reset}${c.bgGray}Enable  ` +
      `${c.bold}L${c.reset}${c.bgGray}Clone  ` +
      `${c.bold}U${c.reset}${c.bgGray}p  ` +
      `${c.bold}J${c.reset}${c.bgGray}Down  ` +
      `${c.bold}P${c.reset}${c.bgGray}latform  ` +
      `${c.bold}?${c.reset}${c.bgGray}Help  ` +
      `${c.bold}Q${c.reset}${c.bgGray}uit`,
      cols
    );
    out += c.reset;

    return out;
  }

  // ─── Step Detail View ────────────────────────────────────────
  private renderStepDetail(rows: number, cols: number): string {
    let out = '';
    const step = this.state.config.steps[this.state.cursor];
    if (!step) return out;

    const w = Math.min(cols - 4, 70);
    const h = rows - 6;
    out += drawBox(2, 2, w, h, `Step ${step.stepId} Detail`, c.cyan);

    let r = 4;
    const lc = 4;
    out += writeAt(r++, lc, `${c.bold}${c.brightCyan}Step ${step.stepId}: ${step.phase}${c.reset}`);
    r++;
    out += writeAt(r++, lc, `${c.cyan}Phase:${c.reset}           ${this.phaseBadge(step.phase)}`);
    out += writeAt(r++, lc, `${c.cyan}Action:${c.reset}          ${step.action || '—'}`);
    out += writeAt(r++, lc, `${c.cyan}Tool:${c.reset}            ${step.tool}`);
    out += writeAt(r++, lc, `${c.cyan}Enabled:${c.reset}         ${step.enabled ?? true ? 'Yes' : 'No'}`);
    if (step.coordinates && 'rx' in step.coordinates) {
      out += writeAt(r++, lc, `${c.cyan}Coordinates:${c.reset}     rx=${(step.coordinates as any).rx.toFixed(4)} ry=${(step.coordinates as any).ry.toFixed(4)} | abs(${step.coordinates.x}, ${step.coordinates.y})`);
    } else {
      out += writeAt(r++, lc, `${c.cyan}Coordinates:${c.reset}     ${step.coordinates ? `(${step.coordinates.x}, ${step.coordinates.y})` : '—'}`);
    }
    out += writeAt(r++, lc, `${c.cyan}Input:${c.reset}           ${step.input || '—'}`);
    out += writeAt(r++, lc, `${c.cyan}Delay:${c.reset}           ${step.delayMs || 0}ms`);
    out += writeAt(r++, lc, `${c.cyan}Screenshot:${c.reset}      ${step.takeScreenshot ? 'Yes' : 'No'}`);
    out += writeAt(r++, lc, `${c.cyan}Screenshot Why:${c.reset}  ${step.screenshotReason.slice(0, w - 20) || '—'}`);
    out += writeAt(r++, lc, `${c.cyan}Breakpoint:${c.reset}      ${step.breakpoint ? `${c.red}${icon.breakpoint} Yes${c.reset}` : 'No'}`);
    out += writeAt(r++, lc, `${c.cyan}Goto Step:${c.reset}       ${step.gotoStep || '—'}`);
    out += writeAt(r++, lc, `${c.cyan}Conditional:${c.reset}     ${step.conditional ? 'Configured' : '—'}`);
    if (step.conditional?.condition.description) {
      out += writeAt(r++, lc, `${c.cyan}If Condition:${c.reset}   ${step.conditional.condition.description.slice(0, w - 24)}`);
    }
    r++;
    out += writeAt(r++, lc, `${c.bold}Comment:${c.reset}`);
    out += writeAt(r++, lc, `${c.gray}${step.comment.slice(0, w - 6) || '(none)'}${c.reset}`);
    r++;
    out += writeAt(r++, lc, `${c.bold}Verification:${c.reset}`);
    out += writeAt(r++, lc, `  ${c.green}Entry:${c.reset} ${step.verification.entryGate || '(none)'}`);
    out += writeAt(r++, lc, `  ${c.green}Exit:${c.reset}  ${step.verification.exitGate || '(none)'}`);

    // Keys
    out += moveTo(rows - 3, 1);
    out += `${c.bgGray}${c.brightWhite}`;
    out += pad(
      ` ${c.bold}E${c.reset}${c.bgGray}dit  ` +
      `${c.bold}B${c.reset}${c.bgGray}reakpoint  ` +
      `${c.bold}C${c.reset}${c.bgGray}onditional  ` +
      `${c.bold}G${c.reset}${c.bgGray}oto  ` +
      `${c.bold}K${c.reset}${c.bgGray}Enable  ` +
      `${c.bold}Esc${c.reset}${c.bgGray}/Q Back`,
      cols
    );
    out += c.reset;

    return out;
  }

  // ─── Step Edit View ──────────────────────────────────────────
  private renderStepEdit(rows: number, cols: number): string {
    let out = '';
    const step = this.state.config.steps[this.state.cursor];
    if (!step) return out;

    const w = Math.min(cols - 4, 75);
    const h = rows - 5;
    const title = this.state.view === 'step-add' ? 'Add Step' : `Edit Step ${step.stepId}`;
    out += drawBox(2, 2, w, h, title, c.yellow);

    let r = 4;
    const labelCol = 4;
    const valueCol = 24;
    const maxValueWidth = w - valueCol - 2; // Leave 2 chars margin from right edge

    for (let i = 0; i < EDIT_FIELDS.length; i++) {
      const field = EDIT_FIELDS[i];
      const isCurrent = i === this.state.editCursor;
      const val = this.getFieldValue(step, field);

      // Cursor
      const cursor = isCurrent ? `${c.brightYellow}${icon.cursor} ` : '  ';

      // Label
      const label = this.fieldLabel(field);

      // Value display with width constraint
      let valDisplay: string;
      if (isCurrent && this.state.editingField) {
        // Editing: show full buffer with horizontal scroll if needed
        // Show the rightmost portion if buffer is too long (so cursor is visible)
        const bufferDisplay = this.state.editBuffer.length > maxValueWidth - 3
          ? '…' + this.state.editBuffer.slice(-(maxValueWidth - 4))
          : this.state.editBuffer;
        valDisplay = `${c.bgBlue}${c.white} ${bufferDisplay}${c.inverse} ${c.reset}`;
      } else if (field === 'phase' || field === 'action' || field === 'tool' || field === 'takeScreenshot' || field === 'conditional') {
        // Cycleable fields
        const hint = field === 'conditional' ? '(Enter to open)' : '(Enter to cycle)';
        const availWidth = maxValueWidth - hint.length - 1;
        const truncVal = val.length > availWidth ? val.slice(0, availWidth - 1) + '…' : val;
        valDisplay = `${c.brightCyan}${truncVal}${c.reset} ${c.gray}${hint}${c.reset}`;
      } else {
        // Regular fields: truncate to fit
        const displayVal = val || `${c.gray}(empty)`;
        const truncVal = val && val.length > maxValueWidth
          ? val.slice(0, maxValueWidth - 1) + '…'
          : displayVal;
        valDisplay = `${c.white}${truncVal}${c.reset}`;
      }

      out += writeAt(r, labelCol, `${cursor}${c.cyan}${label}${c.reset}`);
      out += writeAt(r, valueCol, valDisplay);
      r++;
    }

    // Keys
    out += moveTo(rows - 3, 1);
    out += `${c.bgGray}${c.brightWhite}`;
    out += pad(
      ` ${c.bold}↑↓${c.reset}${c.bgGray} Navigate  ` +
      `${c.bold}Enter${c.reset}${c.bgGray} Edit/Cycle  ` +
      `${c.bold}Tab${c.reset}${c.bgGray} Next  ` +
      `${c.bold}C${c.reset}${c.bgGray}oords Capture  ` +
      `${c.bold}Esc${c.reset}${c.bgGray}/Q Save & Back`,
      cols
    );
    out += c.reset;

    return out;
  }

  private renderConditionalEdit(rows: number, cols: number): string {
    if (!this.conditionalState) {
      return '';
    }
    this.conditionalState.cursor = this.state.conditionalCursor;
    return renderConditionalEditor(
      this.conditionalState,
      rows,
      cols,
      this.state.conditionalEditing,
      this.state.conditionalEditBuffer
    );
  }

  // ─── Run Mode View (Enhanced Dashboard) ────────────────────
  private renderRunMode(rows: number, cols: number): string {
    let out = '';
    const steps = this.state.config.steps;
    const curStep = steps[this.state.runCursor] || steps[Math.max(0, this.state.runCursor - 1)];

    // ━━━ BREAKPOINT MODE: Full-screen verbose panel ━━━━━━━━━
    if (this.state.runPaused && curStep) {
      // Two-column breakpoint layout
      const leftW = Math.min(Math.floor(cols * 0.55), 65);
      const rightW = cols - leftW - 3;
      const h = rows - 4;

      // Left: Verbose breakpoint panel
      out += drawBox(2, 1, leftW, h, `${icon.breakpoint} BREAKPOINT`, c.red);
      out += renderBreakpointPanel(
        curStep, steps, this.state.runCursor,
        this.runStats || createRunStats(steps),
        this.timeline,
        3, 3, leftW - 4, h - 2
      );

      // Right: Subway flow chart context
      out += drawBox(2, leftW + 1, rightW, h, 'Flow Map', c.brightYellow);
      out += renderMiniFlowChart(
        steps, this.state.runCursor,
        3, leftW + 3, rightW - 4, h - 2
      );

      // Bottom bar
      out += moveTo(rows - 2, 1);
      out += `${c.bgRed}${c.white}${c.bold}`;
      out += pad(
        ` ${icon.breakpoint} PAUSED at step ${curStep.stepId}  ` +
        `${c.reset}${c.bgRed}${c.white}` +
        `Space=step  A=auto  Esc=abort  ` +
        `${c.reset}${c.bgRed}${c.gray}` +
        `Session: ${(this.state.sessionDir || '').slice(-30)}`,
        cols
      );
      out += c.reset;

      return out;
    }

    // ━━━ NORMAL RUN MODE: 3-panel layout ━━━━━━━━━━━━━━━━━━━━
    // Layout: [Subway Flow Chart] [Step Detail + Result] [Stats + Log]
    const flowW = Math.min(Math.floor(cols * 0.38), 50);
    const detailW = Math.min(Math.floor(cols * 0.32), 45);
    const statsW = cols - flowW - detailW - 4;
    const h = rows - 5;

    // ─── Panel 1: Subway Flow Chart ─────────────────────────
    const runTitle = this.state.runAuto ? 'Flow [AUTO]' : this.state.runExecuting ? 'Flow [EXEC]' : 'Flow [MANUAL]';
    out += drawBox(2, 1, flowW, h, runTitle, c.green);

    // Progress bar at top of flow panel
    const done = steps.filter(s => s._status === 'passed').length;
    const failed = steps.filter(s => s._status === 'failed').length;
    const barW = Math.min(flowW - 12, 18);
    out += writeAt(3, 3, `${progressBar(done + failed, steps.length, barW)} ${done}${c.green}${icon.check}${c.reset}${failed}${c.red}${icon.cross}${c.reset}/${steps.length}`);

    // Subway flow chart
    const flowScrollStart = Math.max(0, this.state.runCursor - Math.floor((h - 7) / 3));
    out += renderFlowChart(steps, {
      startRow: 5,
      startCol: 2,
      width: flowW - 2,
      maxRows: h - 5,
      scrollOffset: flowScrollStart,
      runCursor: this.state.runCursor,
      showBranches: true,
    });

    // ─── Panel 2: Step Detail + Result ──────────────────────
    const detailCol = flowW + 1;
    out += drawBox(2, detailCol, detailW, h, 'Execution', c.cyan);

    if (curStep) {
      if (this.state.runExecuting) {
        // Currently executing - show spinner
        out += writeAt(3, detailCol + 2, `${c.bgBlue}${c.white}${c.bold} EXECUTING ${c.reset}`);
        out += writeAt(4, detailCol + 2, `${c.yellow}${icon.running} Step ${curStep.stepId}: ${curStep.action || curStep.tool}${c.reset}`);
        if (curStep.comment) {
          out += writeAt(6, detailCol + 2, `${c.gray}${curStep.comment.slice(0, detailW - 6)}${c.reset}`);
        }
        if (curStep.coordinates) {
          const coord = curStep.coordinates;
          if ('rx' in coord) {
            out += writeAt(7, detailCol + 2, `${c.cyan}Target:${c.reset} (${(coord as any).rx.toFixed(4)}, ${(coord as any).ry.toFixed(4)})`);
          }
        }
      } else {
        // Show verbose result detail
        out += renderStepResultDetail(
          curStep,
          3, detailCol + 2, detailW - 4, Math.floor(h / 2) - 1
        );
      }

      // Execution log in bottom half of panel 2
      const logStartRow = Math.floor(h / 2) + 3;
      out += drawSep(logStartRow - 1, detailCol, detailW, c.cyan);
      out += renderExecutionLog(
        this.timeline,
        logStartRow, detailCol + 2, detailW - 4,
        h - Math.floor(h / 2) - 2
      );
    }

    // ─── Panel 3: Stats + Mini Flow Context ─────────────────
    const statsCol = flowW + detailW + 2;
    out += drawBox(2, statsCol, statsW, h, 'Dashboard', c.magenta);

    if (this.runStats) {
      updateRunStats(this.runStats, steps);
      out += renderStatsPanel(
        this.runStats,
        3, statsCol + 2, statsW - 4
      );
    }

    // Session dir
    if (this.state.sessionDir) {
      out += writeAt(rows - 4, 3, `${c.gray}Session: ${this.state.sessionDir}${c.reset}`);
    }

    // Bottom hotkey bar
    out += moveTo(rows - 3, 1);
    out += `${c.bgGray}${c.brightWhite}`;
    const mode = this.state.runAuto ? 'AUTO-RUN' : this.state.runExecuting ? 'EXECUTING' : 'MANUAL';
    out += pad(
      ` ${c.bold}[${mode}]${c.reset}${c.bgGray}  ` +
      `${c.bold}Esc${c.reset}${c.bgGray}/Q Abort  ` +
      `${c.gray}Steps: ${done + failed}/${steps.length}  ` +
      `Elapsed: ${this.runStats ? this.fmtElapsed(this.runStats.totalDurationMs) : '—'}${c.reset}`,
      cols
    );
    out += c.reset;

    return out;
  }

  private fmtElapsed(ms: number): string {
    if (ms < 1000) return ms + 'ms';
    if (ms < 60000) return (ms / 1000).toFixed(1) + 's';
    const min = Math.floor(ms / 60000);
    const sec = Math.round((ms % 60000) / 1000);
    return min + 'm' + sec + 's';
  }

  // ─── Help View ───────────────────────────────────────────────
  private renderHelp(rows: number, cols: number): string {
    let out = '';
    const w = Math.min(cols - 4, 65);
    const h = rows - 5;
    out += drawBox(2, 2, w, h, 'Help — Keyboard Shortcuts', c.yellow);

    const lines = [
      '',
      `${c.bold}${c.brightCyan}Step List${c.reset}`,
      `  ${c.bold}↑/↓${c.reset}      Navigate steps`,
      `  ${c.bold}Enter${c.reset}    View step detail`,
      `  ${c.bold}A${c.reset}        Add new step after cursor`,
      `  ${c.bold}E${c.reset}        Edit current step`,
      `  ${c.bold}D${c.reset}        Delete current step`,
      `  ${c.bold}C${c.reset}        Edit conditional logic (if/then/else)`,
      `  ${c.bold}G${c.reset}        Set goto step for flow jump`,
      `  ${c.bold}X${c.reset}        Clear step conditional + goto`,
      `  ${c.bold}K${c.reset}        Enable/disable step`,
      `  ${c.bold}L${c.reset}        Clone current step`,
      `  ${c.bold}B${c.reset}        Toggle breakpoint`,
      `  ${c.bold}U/J${c.reset}      Move step up/down`,
      `  ${c.bold}F${c.reset}        Connect to Chrome (CDP)`,
      `  ${c.bold}R${c.reset}        Run from selected step (live CDP)`,
      `  ${c.bold}S${c.reset}        Take screenshot (CDP)`,
      `  ${c.bold}P${c.reset}        Toggle platform (FK/OS)`,
      '',
      `${c.bold}${c.brightCyan}Edit Mode${c.reset}`,
      `  ${c.bold}↑/↓${c.reset}      Navigate fields`,
      `  ${c.bold}Enter${c.reset}    Edit field / Cycle option`,
      `  ${c.bold}Tab${c.reset}      Next field`,
      `  ${c.bold}C${c.reset}        Capture coordinates (click in Chrome)`,
      `  ${c.bold}Esc${c.reset}      Save & back to list`,
      '',
      `${c.bold}${c.brightCyan}Run Mode (Auto-Run by Default)${c.reset}`,
      `  Starts from selected step and follows flow controls`,
      `  At breakpoint:`,
      `    ${c.bold}Space${c.reset}  Single-step (manual mode)`,
      `    ${c.bold}A${c.reset}      Resume auto-run`,
      `    ${c.bold}Esc${c.reset}    Abort and return to list`,
      `  Conditional actions: continue / goto / retry / abort`,
      '',
      `${c.bold}${c.brightCyan}Global${c.reset}`,
      `  ${c.bold}Ctrl+S${c.reset}   Save config`,
      `  ${c.bold}Ctrl+C${c.reset}   Quit (auto-saves)`,
      `  ${c.bold}Q${c.reset}        Quit (auto-saves)`,
    ];

    for (let i = 0; i < lines.length && i < h - 3; i++) {
      out += writeAt(4 + i, 4, lines[i]);
    }

    out += moveTo(rows - 3, 1);
    out += `${c.bgGray}${c.brightWhite}`;
    out += pad(` Press any key to return`, cols);
    out += c.reset;

    return out;
  }

  // ─── Status Bar ────────────────────────────────────────────────
  private renderStatusBar(rows: number, cols: number): string {
    let out = moveTo(rows, 1);
    const steps = this.state.config.steps;
    const cdpTag = this.state.cdpConnected ? `${c.green}CDP:ON${c.reset}` : `${c.red}CDP:OFF${c.reset}`;
    const redirectWarning = this.configRedirectWarning
      ? ` | ${c.brightRed}CONFIG_REDIRECT_ACTIVE${c.reset}`
      : '';
    const info = `${c.gray}Steps: ${steps.length} | ` +
      `Breakpoints: ${steps.filter(s => s.breakpoint).length} | ` +
      `Disabled: ${steps.filter(s => (s.enabled ?? true) === false).length} | ` +
      `Conditionals: ${steps.filter(s => !!s.conditional).length} | ` +
      `Platform: ${this.state.config.platform} | ${c.reset}${cdpTag}${redirectWarning}`;

    out += `${c.bgBlack}${c.white}`;
    out += pad(` ${this.state.statusMessage || info}`, cols);
    out += c.reset;
    return out;
  }

  // ─── Helpers ─────────────────────────────────────────────────
  private phaseBadge(phase: string): string {
    const colors: Record<string, string> = {
      Login: c.brightGreen,
      GameSelection: c.brightBlue,
      Spin: c.brightYellow,
      Logout: c.brightRed,
      DismissModals: c.brightMagenta,
    };
    return `${colors[phase] || c.white}[${phase.slice(0, 5)}]${c.reset}`;
  }

  private statusIcon(status?: string): string {
    switch (status) {
      case 'passed':  return `${c.green}${icon.check}${c.reset}`;
      case 'failed':  return `${c.red}${icon.cross}${c.reset}`;
      case 'running': return `${c.yellow}${icon.running}${c.reset}`;
      case 'skipped': return `${c.gray}${icon.circle}${c.reset}`;
      default:        return `${c.gray}${icon.circle}${c.reset}`;
    }
  }

  private fieldLabel(field: EditField): string {
    const labels: Record<EditField, string> = {
      phase: 'Phase',
      action: 'Action',
      tool: 'Tool',
      coordinates_x: 'Coord X',
      coordinates_y: 'Coord Y',
      coordinates_rx: 'Relative X',
      coordinates_ry: 'Relative Y',
      input: 'Input Text',
      url: 'URL',
      holdMs: 'Hold (ms)',
      delayMs: 'Delay (ms)',
      takeScreenshot: 'Screenshot',
      screenshotReason: 'Screenshot Why',
      comment: 'Comment',
      entryGate: 'Entry Gate',
      exitGate: 'Exit Gate',
      gotoStep: 'Goto Step',
      conditional: 'Conditional',
    };
    return pad(labels[field] || field, 18);
  }
}
