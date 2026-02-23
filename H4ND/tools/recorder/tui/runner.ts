// TUI CDP Runner — Real step execution via Chrome DevTools Protocol
import { CdpClient, sleep } from '../cdp-client';
import type { MacroStep } from './types';

// Single source of truth for default longpress duration
const DEFAULT_LONGPRESS_MS = 3000;
import type {
  CanvasBounds,
  RelativeCoordinate,
  ConditionalLogic,
  ConditionalBranch,
} from '../types';
import { join } from 'path';
import { mkdirSync, existsSync, writeFileSync } from 'fs';
import { spawn } from 'child_process';

export interface RunResult {
  success: boolean;
  message: string;
  screenshotPath?: string;
  durationMs: number;
  error?: string;
}

// ARCH-081: Click capture result includes canvas bounds and relative coordinates
export interface ClickCaptureResult {
  x: number;
  y: number;
  rx: number;
  ry: number;
  context: string;
  canvasBounds: CanvasBounds;
}

export interface ConditionResult {
  conditionMet: boolean;
  branch: ConditionalBranch;
  details: string;
}

export class TuiRunner {
  private cdp: CdpClient | null = null;
  private connected = false;
  private aborted = false;
  private sessionDir: string;

  constructor(sessionDir?: string) {
    const ts = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19);
    this.sessionDir = sessionDir || join(process.cwd(), 'sessions', `tui-run-${ts}`);
  }

  get isConnected(): boolean { return this.connected; }
  get screenshotDir(): string { return this.sessionDir; }

  abort(): void { this.aborted = true; }

  // ─── Connect to Chrome CDP ─────────────────────────────────
  async connect(): Promise<{ ok: boolean; message: string }> {
    try {
      const resp = await fetch('http://127.0.0.1:9222/json/version');
      if (!resp.ok) return { ok: false, message: 'CDP not responding on port 9222' };
      const data = await resp.json() as any;

      if (!existsSync(this.sessionDir)) mkdirSync(this.sessionDir, { recursive: true });
      this.cdp = new CdpClient('127.0.0.1', 9222, this.sessionDir);
      await this.cdp.connect();
      this.connected = true;
      return { ok: true, message: `Connected to ${data.Browser}` };
    } catch (err: any) {
      return { ok: false, message: err.message || 'CDP connection failed' };
    }
  }

  // ─── Ensure Chrome is running with CDP ─────────────────────
  async ensureChrome(): Promise<{ ok: boolean; message: string }> {
    // Check if already available
    try {
      const resp = await fetch('http://127.0.0.1:9222/json/version');
      if (resp.ok) return this.connect();
    } catch {}

    // Try to start Chrome
    const chromeArgs = [
      '--remote-debugging-port=9222',
      '--remote-debugging-address=127.0.0.1',
      '--incognito',
      '--no-first-run',
      '--ignore-certificate-errors',
      '--disable-web-security',
      '--allow-running-insecure-content',
      '--disable-features=SafeBrowsing',
      `--user-data-dir=${process.env.TEMP || 'C:\\Temp'}\\chrome_debug_tui`
    ];

    try {
      spawn('chrome.exe', chromeArgs, { detached: true, stdio: 'ignore' }).unref();
    } catch {
      return { ok: false, message: 'Failed to spawn chrome.exe' };
    }

    // Wait up to 10s for Chrome
    for (let i = 0; i < 10; i++) {
      await sleep(1000);
      try {
        const resp = await fetch('http://127.0.0.1:9222/json/version');
        if (resp.ok) return this.connect();
      } catch {}
    }
    return { ok: false, message: 'Chrome failed to start within 10s' };
  }

  // ─── Execute a single MacroStep ────────────────────────────
  async executeStep(step: MacroStep): Promise<RunResult> {
    const start = Date.now();
    this.aborted = false;

    if (!this.cdp || !this.connected) {
      return { success: false, message: 'Not connected to CDP', durationMs: 0 };
    }

    try {
      let msg = '';

      switch (step.action) {
        case 'click': {
          const coord = step.coordinates;
          if (coord && 'rx' in coord && 'ry' in coord) {
            // ARCH-081: Use relative coordinates
            await this.cdp.clickRelative(coord as RelativeCoordinate);
            msg = `Clicked relative (${(coord as RelativeCoordinate).rx.toFixed(4)}, ${(coord as RelativeCoordinate).ry.toFixed(4)})`;
          } else {
            const x = coord?.x ?? 0;
            const y = coord?.y ?? 0;
            await this.cdp.clickAt(x, y);
            msg = `Clicked (${x}, ${y})`;
          }
          break;
        }

        case 'longpress': {
          const coord = step.coordinates;
          const holdMs = step.holdMs || DEFAULT_LONGPRESS_MS;
          // ARCH-081: Resolve relative coords for longpress too
          if (coord && 'rx' in coord && 'ry' in coord) {
            const bounds = await this.cdp.getCanvasBounds();
            const abs = CdpClient.transformRelativeCoords(coord as RelativeCoordinate, bounds);
            await this.cdp.longPress(abs.x, abs.y, holdMs);
            msg = `Long-pressed relative (${(coord as RelativeCoordinate).rx.toFixed(4)}, ${(coord as RelativeCoordinate).ry.toFixed(4)}) for ${holdMs}ms`;
          } else {
            const x = coord?.x ?? 0;
            const y = coord?.y ?? 0;
            await this.cdp.longPress(x, y, holdMs);
            msg = `Long-pressed (${x}, ${y}) for ${holdMs}ms`;
          }
          break;
        }

        case 'type': {
          const text = step.input || '';
          await this.cdp.typeChars(text);
          msg = `Typed "${text.slice(0, 20)}${text.length > 20 ? '...' : ''}"`;
          break;
        }

        case 'clip': {
          const clipText = step.input || '';
          if (clipText) {
            await this.cdp.setClipboard(clipText);
            msg = `Clipboard loaded: "${clipText.slice(0, 3)}${'*'.repeat(Math.max(0, clipText.length - 3))}"`;
          } else {
            msg = 'Clip — no input text specified';
          }
          break;
        }

        case 'navigate': {
          const url = step.url || '';
          if (url) {
            await this.cdp.navigate(url);
            msg = `Navigated to ${url}`;
          } else {
            msg = 'Navigate — no URL specified';
          }
          break;
        }

        case 'wait': {
          const waitMs = step.delayMs || 1000;
          const chunks = Math.ceil(waitMs / 200);
          for (let i = 0; i < chunks; i++) {
            if (this.aborted) return { success: false, message: 'Aborted during wait', durationMs: Date.now() - start };
            await sleep(Math.min(200, waitMs - i * 200));
          }
          msg = `Waited ${waitMs}ms`;
          break;
        }

        default:
          msg = `Unknown action: ${step.action || 'none'}`;
      }

      // Post-action delay (skip for wait/longpress which handle their own delay)
      if (step.action !== 'wait' && step.action !== 'longpress' && step.delayMs) {
        const delayChunks = Math.ceil(step.delayMs / 200);
        for (let i = 0; i < delayChunks; i++) {
          if (this.aborted) return { success: false, message: 'Aborted during delay', durationMs: Date.now() - start };
          await sleep(Math.min(200, step.delayMs - i * 200));
        }
      }

      // Screenshot if requested
      let screenshotPath: string | undefined;
      if (step.takeScreenshot && this.cdp) {
        try {
          const label = `step${String(step.stepId).padStart(2, '0')}_${step.action || 'unknown'}`;
          screenshotPath = await this.cdp.screenshot(label);
          msg += ` | 📸 saved`;
        } catch (ssErr: any) {
          msg += ` | 📸 failed: ${ssErr.message}`;
        }
      }

      return { success: true, message: msg, screenshotPath, durationMs: Date.now() - start };

    } catch (err: any) {
      return { success: false, message: err.message || 'Step execution failed', durationMs: Date.now() - start, error: err.message };
    }
  }

  async evaluateConditional(conditional: ConditionalLogic): Promise<ConditionResult> {
    const { condition, onTrue, onFalse } = conditional;
    let conditionMet = false;
    let details = '';

    try {
      switch (condition.type) {
        case 'element-exists': {
          const target = condition.target || '';
          conditionMet = await this.checkElementExists(target);
          details = conditionMet
            ? `element exists: ${target}`
            : `element missing: ${target}`;
          break;
        }
        case 'element-missing': {
          const target = condition.target || '';
          conditionMet = !(await this.checkElementExists(target));
          details = conditionMet
            ? `element missing as expected: ${target}`
            : `element still present: ${target}`;
          break;
        }
        case 'text-contains': {
          const target = condition.target || '';
          conditionMet = await this.checkTextContains(target);
          details = conditionMet
            ? `text found: ${target}`
            : `text not found: ${target}`;
          break;
        }
        case 'cdp-check': {
          const command = condition.cdpCommand || '';
          conditionMet = await this.checkCdpCommand(command);
          details = conditionMet ? 'cdp-check passed' : 'cdp-check failed';
          break;
        }
        case 'custom-js': {
          const expr = condition.target || '';
          conditionMet = await this.evaluateCustomJs(expr);
          details = conditionMet
            ? 'custom-js returned true'
            : 'custom-js returned false';
          break;
        }
        default:
          conditionMet = false;
          details = `${condition.type} must be evaluated from run result`;
          break;
      }
    } catch (err: any) {
      conditionMet = false;
      details = err?.message || 'conditional evaluation failed';
    }

    return {
      conditionMet,
      branch: conditionMet ? onTrue : onFalse,
      details,
    };
  }

  evaluateToolConditional(
    conditional: ConditionalLogic,
    stepSuccess: boolean
  ): ConditionResult {
    const { condition, onTrue, onFalse } = conditional;
    const conditionMet =
      condition.type === 'tool-success'
        ? stepSuccess
        : condition.type === 'tool-failure'
          ? !stepSuccess
          : false;
    return {
      conditionMet,
      branch: conditionMet ? onTrue : onFalse,
      details: `step ${stepSuccess ? 'passed' : 'failed'} (${condition.type})`,
    };
  }

  // ─── Take standalone screenshot ────────────────────────────
  async takeScreenshot(label: string): Promise<{ ok: boolean; path?: string; message: string }> {
    if (!this.cdp || !this.connected) {
      return { ok: false, message: 'Not connected to CDP' };
    }
    try {
      const path = await this.cdp.screenshot(label);
      return { ok: true, path, message: `Screenshot saved: ${path}` };
    } catch (err: any) {
      return { ok: false, message: err.message };
    }
  }

  // ─── Get current page URL ──────────────────────────────────
  async getPageUrl(): Promise<string> {
    if (!this.cdp) return '(not connected)';
    try {
      return await this.cdp.evaluate<string>('window.location.href');
    } catch {
      return '(error)';
    }
  }

  // ARCH-081: Get canvas bounds from the page
  async getCanvasBounds(): Promise<CanvasBounds> {
    if (!this.cdp) return { x: 0, y: 0, width: 0, height: 0 };
    return this.cdp.getCanvasBounds();
  }

  // ─── Wait for mouse click and capture coordinates + context ──
  // ARCH-081: Returns ClickCaptureResult with canvas bounds and relative coords
  // Uses mousedown + variable polling (not Promise-based) to avoid awaitPromise hang
  async waitForClick(timeoutMs = 30000): Promise<ClickCaptureResult | null> {
    if (!this.cdp) throw new Error('CDP client is null');
    if (!this.connected) throw new Error('CDP not connected');
    this.aborted = false; // Reset from any previous run abort
    
    // ARCH-081: Capture canvas bounds BEFORE the click (so we can compute rx/ry)
    let canvasBounds: CanvasBounds = { x: 0, y: 0, width: 0, height: 0 };
    try {
      canvasBounds = await this.cdp.getCanvasBounds();
    } catch (e: any) {
      // Non-fatal: canvas bounds not available, rx/ry will be 0
    }

    // Inject a transparent overlay div on top of EVERYTHING (including Canvas/iframes)
    // Canvas games (Cocos2d-x) swallow mouse events — DOM listeners on document never fire.
    // The overlay is a regular div so mousedown is guaranteed. It removes itself after capture.
    await this.cdp.evaluate(`
      window.__clickResult = null;
      var overlay = document.createElement('div');
      overlay.id = '__captureOverlay';
      overlay.style.cssText = 'position:fixed;top:0;left:0;width:100vw;height:100vh;z-index:999999;cursor:crosshair;background:transparent;';
      overlay.addEventListener('mousedown', function(e) {
        window.__clickResult = {
          x: e.clientX,
          y: e.clientY,
          tag: 'capture-overlay',
          id: '',
          text: '',
          classes: '',
          width: window.innerWidth,
          height: window.innerHeight
        };
        overlay.remove();
      });
      document.body.appendChild(overlay);
      void 0;
    `);
    
    // Poll the variable until result appears or timeout
    const startTime = Date.now();
    while (Date.now() - startTime < timeoutMs) {
      if (this.aborted) {
        try { await this.cdp.evaluate(`var o = document.getElementById('__captureOverlay'); if (o) o.remove(); window.__clickResult = null; void 0;`); } catch {}
        return null;
      }
      
      try {
        const result = await this.cdp.evaluate<any>(`window.__clickResult`);
        
        if (result) {
          // Clean up
          try { await this.cdp.evaluate(`window.__clickResult = null; void 0;`); } catch {}
          
          const parts = [];
          if (result.tag) parts.push(result.tag);
          if (result.id) parts.push(result.id);
          if (result.classes && result.classes !== '.') parts.push(result.classes);
          if (result.text) parts.push(`"${result.text}"`);
          if (result.width && result.height) parts.push(`${result.width}x${result.height}`);
          
          const context = parts.length > 0 ? parts.join(' ') : 'Element at coordinates';

          // ARCH-081: Compute relative coordinates from canvas bounds
          let rx = 0;
          let ry = 0;
          if (canvasBounds.width > 0 && canvasBounds.height > 0) {
            rx = Math.round(((result.x - canvasBounds.x) / canvasBounds.width) * 10000) / 10000;
            ry = Math.round(((result.y - canvasBounds.y) / canvasBounds.height) * 10000) / 10000;
            rx = Math.max(0, Math.min(1, rx));
            ry = Math.max(0, Math.min(1, ry));
          }

          return { x: result.x, y: result.y, rx, ry, context, canvasBounds };
        }
      } catch {}
      
      await sleep(200);
    }
    
    // Timeout - cleanup overlay
    try { await this.cdp.evaluate(`var o = document.getElementById('__captureOverlay'); if (o) o.remove(); window.__clickResult = null; void 0;`); } catch {}
    return null;
  }

  // ─── Bring Chrome window to front ─────────────────────────
  async bringChromeToFront(): Promise<void> {
    try {
      // Use PowerShell to find and focus Chrome window
      const ps = spawn('powershell', [
        '-NoProfile', '-Command',
        `Add-Type -Name User32 -Namespace Win32 -MemberDefinition '[DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd); [DllImport("user32.dll")] public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);'; $chrome = Get-Process chrome -ErrorAction SilentlyContinue | Select-Object -First 1; if ($chrome) { [Win32.User32]::SetForegroundWindow($chrome.MainWindowHandle) | Out-Null }`
      ], { stdio: 'ignore' });
      ps.unref();
      await sleep(300);
    } catch {
      // Best effort
    }
  }

  // ─── Focus terminal window (Windows) ─────────────────────
  async focusTui(): Promise<void> {
    try {
      // Use PowerShell to bring the terminal back to front
      const ps = spawn('powershell', [
        '-NoProfile', '-Command',
        `Add-Type -Name Win -Namespace Native -MemberDefinition '[DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd); [DllImport("kernel32.dll")] public static extern IntPtr GetConsoleWindow();'; [Native.Win]::SetForegroundWindow([Native.Win]::GetConsoleWindow()) | Out-Null`
      ], { stdio: 'ignore' });
      ps.unref();
      await sleep(200);
    } catch {
      // Best effort
    }
  }

  // ─── Write run summary to session dir ─────────────────────
  async writeRunSummary(steps: any[]): Promise<void> {
    if (!existsSync(this.sessionDir)) return;
    const summary = {
      timestamp: new Date().toISOString(),
      totalSteps: steps.length,
      passed: steps.filter((s: any) => s._status === 'passed').length,
      failed: steps.filter((s: any) => s._status === 'failed').length,
      steps: steps.map((s: any) => ({
        stepId: s.stepId,
        action: s.action,
        status: s._status,
        result: s._lastResult,
        durationMs: s._durationMs,
        screenshot: s._screenshotPath,
      })),
    };
    writeFileSync(join(this.sessionDir, 'run-summary.json'), JSON.stringify(summary, null, 2));
  }

  // ─── Kill Chrome browser ───────────────────────────────────
  async killChrome(): Promise<void> {
    this.disconnect();
    try {
      // Kill all Chrome processes
      spawn('taskkill', ['/F', '/IM', 'chrome.exe'], { stdio: 'ignore' }).unref();
      await sleep(500);
    } catch {
      // Best effort
    }
  }

  // ─── Disconnect ────────────────────────────────────────────
  disconnect(): void {
    this.cdp?.close();
    this.cdp = null;
    this.connected = false;
  }

  private async checkElementExists(selector: string): Promise<boolean> {
    if (!selector || !this.cdp) return false;
    try {
      return await this.cdp.evaluate<boolean>(
        `(() => document.querySelector(${JSON.stringify(selector)}) !== null)()`
      );
    } catch {
      return false;
    }
  }

  private async checkTextContains(text: string): Promise<boolean> {
    if (!text || !this.cdp) return false;
    try {
      return await this.cdp.evaluate<boolean>(
        `(() => { const body = document.body; const value = body ? (body.innerText || body.textContent || '') : ''; return value.includes(${JSON.stringify(text)}); })()`
      );
    } catch {
      return false;
    }
  }

  private async checkCdpCommand(command: string): Promise<boolean> {
    if (!command || !this.cdp) return false;
    try {
      const parsed = JSON.parse(command) as { method?: string; params?: Record<string, unknown> };
      if (!parsed.method) return false;
      await this.cdp.send(parsed.method, parsed.params || {});
      return true;
    } catch {
      return false;
    }
  }

  private async evaluateCustomJs(expression: string): Promise<boolean> {
    if (!expression || !this.cdp) return false;
    try {
      return await this.cdp.evaluate<boolean>(`(() => !!(${expression}))()`);
    } catch {
      return false;
    }
  }
}
