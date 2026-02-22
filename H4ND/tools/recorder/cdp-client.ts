import WebSocket from 'ws';
import { writeFile, mkdir } from 'fs/promises';
import { join } from 'path';
import type { CanvasBounds, RelativeCoordinate } from './types';

export class CdpClient {
  private ws: WebSocket | null = null;
  private msgId = 0;
  private pending = new Map<number, { resolve: (v: any) => void; reject: (e: Error) => void }>();
  private host: string;
  private port: number;
  private screenshotDir: string;
  private screenshotCount = 0;

  constructor(host = '127.0.0.1', port = 9222, screenshotDir = '') {
    this.host = host;
    this.port = port;
    this.screenshotDir = screenshotDir;
  }

  async connect(): Promise<void> {
    const targets = await fetch(`http://${this.host}:${this.port}/json`).then(r => r.json()) as any[];
    const page = targets.find((t: any) => t.type === 'page');
    if (!page) throw new Error('No page target found');

    const wsUrl = page.webSocketDebuggerUrl;
    console.log(`[CDP] Connecting to ${wsUrl}`);

    return new Promise((resolve, reject) => {
      this.ws = new WebSocket(wsUrl);
      this.ws.on('open', () => {
        console.log(`[CDP] Connected — ${page.url}`);
        resolve();
      });
      this.ws.on('message', (data: Buffer) => {
        const msg = JSON.parse(data.toString());
        if (msg.id && this.pending.has(msg.id)) {
          const p = this.pending.get(msg.id)!;
          this.pending.delete(msg.id);
          if (msg.error) p.reject(new Error(msg.error.message));
          else p.resolve(msg.result);
        }
      });
      this.ws.on('error', reject);
    });
  }

  send(method: string, params: any = {}): Promise<any> {
    return new Promise((resolve, reject) => {
      const id = ++this.msgId;
      this.pending.set(id, { resolve, reject });
      this.ws!.send(JSON.stringify({ id, method, params }));
      setTimeout(() => {
        if (this.pending.has(id)) {
          this.pending.delete(id);
          reject(new Error(`CDP timeout: ${method}`));
        }
      }, 30000);
    });
  }

  async navigate(url: string): Promise<void> {
    await this.send('Page.navigate', { url });
  }

  async evaluate<T = any>(expression: string, contextId?: number): Promise<T> {
    const params: any = {
      expression,
      returnByValue: true,
      awaitPromise: true,
    };
    if (contextId !== undefined) params.contextId = contextId;
    const result = await this.send('Runtime.evaluate', params);
    if (result.exceptionDetails) {
      throw new Error(`JS error: ${result.exceptionDetails.text}`);
    }
    return result.result.value as T;
  }

  async getIframeContextId(frameName: string): Promise<number | undefined> {
    // Collect execution contexts from Runtime events
    const contexts: any[] = [];
    const handler = (data: any) => {
      try {
        const msg = JSON.parse(data.toString());
        if (msg.method === 'Runtime.executionContextCreated') {
          contexts.push(msg.params.context);
        }
      } catch {}
    };
    this.ws!.on('message', handler);

    // Enable Runtime — this triggers executionContextCreated for all frames
    await this.send('Runtime.disable');
    await this.send('Runtime.enable');
    await sleep(1000); // Wait for all context events

    this.ws!.off('message', handler);

    // Find the iframe's native context (not isolated)
    const tree = await this.send('Page.getFrameTree');
    const childFrames = tree.frameTree.childFrames || [];
    for (const child of childFrames) {
      if (child.frame.name === frameName || child.frame.url.includes(frameName)) {
        const frameId = child.frame.id;
        // Find the non-isolated context for this frame
        for (const ctx of contexts) {
          if (ctx.auxData?.frameId === frameId && ctx.auxData?.isDefault === true) {
            return ctx.id;
          }
        }
        // Fallback: any context matching this frame
        for (const ctx of contexts) {
          if (ctx.auxData?.frameId === frameId) {
            return ctx.id;
          }
        }
      }
    }
    return undefined;
  }

  async clickAt(x: number, y: number): Promise<void> {
    await this.send('Input.dispatchMouseEvent', { type: 'mousePressed', x, y, button: 'left', clickCount: 1 });
    await this.send('Input.dispatchMouseEvent', { type: 'mouseReleased', x, y, button: 'left', clickCount: 1 });
  }

  // ARCH-081: Click using relative coordinates, resolving against live canvas bounds
  async clickRelative(coord: RelativeCoordinate, canvasBounds?: CanvasBounds): Promise<void> {
    const bounds = canvasBounds || await this.getCanvasBounds();
    const { x, y } = CdpClient.transformRelativeCoords(coord, bounds);
    log('CDP', `clickRelative(${coord.rx.toFixed(4)}, ${coord.ry.toFixed(4)}) → absolute(${x}, ${y}) [canvas: ${bounds.width}x${bounds.height} @ ${bounds.x},${bounds.y}]`);
    await this.clickAt(x, y);
  }

  // ARCH-081: Get canvas bounding rectangle from the page
  async getCanvasBounds(): Promise<CanvasBounds> {
    try {
      // Search order aligned with C# CdpGameActions.GetCanvasBoundsAsync
      const json = await this.evaluate<string>(`(function(){
        var c = document.querySelector('canvas') ||
                document.querySelector('#GameCanvas') ||
                document.querySelector('iframe[src*="game"]') ||
                document.querySelector('iframe');
        if (!c) {
          var iframes = document.querySelectorAll('iframe');
          for (var i = 0; i < iframes.length; i++) {
            try { c = iframes[i].contentDocument.querySelector('canvas'); if (c) break; } catch(e) {}
          }
        }
        if (!c) return JSON.stringify({x:0,y:0,width:0,height:0});
        var r = c.getBoundingClientRect();
        return JSON.stringify({x:r.x,y:r.y,width:r.width,height:r.height});
      })()`);
      const bounds: CanvasBounds = JSON.parse(json);
      if (bounds.width > 0 && bounds.height > 0) {
        log('CDP', `Canvas bounds: (${bounds.x},${bounds.y}) ${bounds.width}x${bounds.height}`);
      } else {
        log('CDP', 'Canvas bounds: not found — using fallback');
      }
      return bounds;
    } catch (e: any) {
      log('CDP', `getCanvasBounds error: ${e.message}`);
      return { x: 0, y: 0, width: 0, height: 0 };
    }
  }

  // ARCH-081: Transform relative (0.0-1.0) coords to absolute viewport coords
  static transformRelativeCoords(coord: RelativeCoordinate, bounds: CanvasBounds): { x: number; y: number } {
    if (bounds.width <= 0 || bounds.height <= 0) {
      // Canvas not found — fall back to absolute coords from design viewport
      return { x: Math.round(coord.x), y: Math.round(coord.y) };
    }
    return {
      x: Math.round(bounds.x + coord.rx * bounds.width),
      y: Math.round(bounds.y + coord.ry * bounds.height),
    };
  }

  // ARCH-081: Inject MutationObserver interceptor for Cocos2d-x ephemeral inputs
  async injectCanvasInputInterceptor(): Promise<void> {
    const script = `
      window.__p4n_pendingText = '';
      window.__p4n_interceptorActive = true;
      var observer = new MutationObserver(function(mutations) {
        if (!window.__p4n_pendingText) return;
        for (var m = 0; m < mutations.length; m++) {
          for (var n = 0; n < mutations[m].addedNodes.length; n++) {
            var node = mutations[m].addedNodes[n];
            if (node.tagName === 'INPUT' || node.tagName === 'TEXTAREA') {
              var text = window.__p4n_pendingText;
              window.__p4n_pendingText = '';
              var nativeSetter = Object.getOwnPropertyDescriptor(
                window.HTMLInputElement.prototype, 'value'
              ).set;
              nativeSetter.call(node, text);
              node.dispatchEvent(new Event('input', {bubbles: true}));
              node.dispatchEvent(new Event('change', {bubbles: true}));
              console.log('[P4N] Interceptor filled input: ' + text.length + ' chars');
            }
          }
        }
      });
      observer.observe(document.documentElement || document.body || document, {
        childList: true, subtree: true
      });
      console.log('[P4N] Canvas input interceptor installed');
    `;
    await this.send('Page.addScriptToEvaluateOnNewDocument', { source: script });
    await this.evaluate(script);
    log('CDP', 'Canvas input interceptor injected');
  }

  // ARCH-081: Arm the interceptor with text, then click a field to trigger Cocos2d-x input creation
  async typeViaInterceptor(coord: RelativeCoordinate, text: string, canvasBounds?: CanvasBounds): Promise<boolean> {
    try {
      const escaped = text.replace(/'/g, "\\'");
      const armResult = await this.evaluate<string>(`(function(){
        if (window.__p4n_pendingText !== undefined) {
          window.__p4n_pendingText = '${escaped}';
          return 'armed';
        }
        return 'no_interceptor';
      })()`);

      if (armResult !== 'armed') {
        log('CDP', 'Interceptor not installed — falling back to typeChars');
        return false;
      }

      // Click the field to trigger Cocos2d-x to create the ephemeral input
      await this.clickRelative(coord, canvasBounds);
      await sleep(1500);

      // Check if interceptor consumed the text
      const remaining = await this.evaluate<string>('window.__p4n_pendingText || ""');
      if (remaining === '') {
        log('CDP', `Interceptor filled text (${text.length} chars)`);
        return true;
      }

      log('CDP', `Interceptor did not fire — remaining: "${remaining}"`);
      return false;
    } catch (e: any) {
      log('CDP', `typeViaInterceptor error: ${e.message}`);
      return false;
    }
  }

  async longPress(x: number, y: number, holdMs: number): Promise<void> {
    log('CDP', `longPress(${x}, ${y}) holdMs=${holdMs} — pressing`);
    // Press down with full event properties
    await this.send('Input.dispatchMouseEvent', {
      type: 'mousePressed', x, y, button: 'left', buttons: 1,
      clickCount: 1, pointerType: 'mouse'
    });
    // Send frequent mouseMoved with buttons:1 to maintain "held" state in browser
    // button:'none' = no button changed, buttons:1 = left still held
    const interval = 100;
    const ticks = Math.floor(holdMs / interval);
    log('CDP', `longPress — holding ${holdMs}ms (${ticks} ticks)`);
    for (let i = 0; i < ticks; i++) {
      await sleep(interval);
      await this.send('Input.dispatchMouseEvent', {
        type: 'mouseMoved', x, y, button: 'none', buttons: 1,
        pointerType: 'mouse'
      });
    }
    log('CDP', `longPress — releasing`);
    await this.send('Input.dispatchMouseEvent', {
      type: 'mouseReleased', x, y, button: 'left', buttons: 0,
      clickCount: 1, pointerType: 'mouse'
    });
  }

  async typeChars(text: string): Promise<void> {
    for (const c of text) {
      await this.send('Input.dispatchKeyEvent', { type: 'char', text: c });
      await sleep(40);
    }
  }

  async typeCharsSlow(text: string, delayMs = 150): Promise<void> {
    for (const c of text) {
      await this.send('Input.dispatchKeyEvent', { type: 'keyDown', key: c, text: c, unmodifiedText: c });
      await this.send('Input.dispatchKeyEvent', { type: 'char', text: c, unmodifiedText: c });
      await this.send('Input.dispatchKeyEvent', { type: 'keyUp', key: c });
      await sleep(delayMs);
    }
  }

  async insertText(text: string): Promise<void> {
    await this.send('Input.insertText', { text });
  }

  async setClipboard(text: string): Promise<void> {
    log('CDP', `setClipboard — loading ${text.length} chars`);
    // Grant clipboard-write permission to the page origin
    await this.send('Browser.grantPermissions', {
      permissions: ['clipboardReadWrite', 'clipboardSanitizedWrite'],
    });
    // Write to clipboard via page JS context
    await this.evaluate(`navigator.clipboard.writeText(${JSON.stringify(text)})`);
  }

  async screenshot(label: string): Promise<string> {
    this.screenshotCount++;
    const result = await this.send('Page.captureScreenshot', { format: 'png' });
    const buf = Buffer.from(result.data, 'base64');
    const filename = `${String(this.screenshotCount).padStart(3, '0')}_${label}.png`;

    if (this.screenshotDir) {
      await mkdir(this.screenshotDir, { recursive: true });
      const path = join(this.screenshotDir, filename);
      await writeFile(path, buf);
      console.log(`  📸 ${filename} (${(buf.length / 1024).toFixed(0)}KB)`);
      return path;
    }
    return filename;
  }

  // ARCH-081: Inject both WS interceptor and canvas input interceptor
  async injectAllInterceptors(): Promise<void> {
    await this.injectWsInterceptor();
    await this.injectCanvasInputInterceptor();
  }

  async injectWsInterceptor(): Promise<void> {
    await this.send('Page.addScriptToEvaluateOnNewDocument', {
      source: `
        window._wsFrames = [];
        window._wsJackpots = {};
        window._wsLoginResult = null;
        (function() {
          var origWS = window.WebSocket;
          window.WebSocket = function(url, protocols) {
            var ws = protocols ? new origWS(url, protocols) : new origWS(url);
            ws.addEventListener('message', function(e) {
              try {
                window._wsFrames.push({dir:'in', data: e.data, t: Date.now()});
                var msg = JSON.parse(e.data);
                if (msg.mainID === 100 && msg.subID === 120 && msg.data) {
                  window._wsJackpots = {
                    grand: (msg.data.grand || 0) / 100,
                    major: (msg.data.major || 0) / 100,
                    minor: (msg.data.minor || 0) / 100,
                    mini: (msg.data.mini || 0) / 100,
                    ts: Date.now()
                  };
                }
                if (msg.mainID === 100 && msg.subID === 116 && msg.data) {
                  window._wsLoginResult = {
                    result: msg.data.result,
                    score: (msg.data.score || 0) / 100,
                    bossid: msg.data.bossid,
                    msg: msg.data.msg || '',
                    ts: Date.now()
                  };
                }
              } catch(e) {}
            });
            window._lastWS = ws;
            return ws;
          };
          window.WebSocket.prototype = origWS.prototype;
          window.WebSocket.CONNECTING = origWS.CONNECTING;
          window.WebSocket.OPEN = origWS.OPEN;
          window.WebSocket.CLOSING = origWS.CLOSING;
          window.WebSocket.CLOSED = origWS.CLOSED;
        })();
      `,
    });
  }

  close(): void {
    this.ws?.close();
  }
}

export function sleep(ms: number): Promise<void> {
  return new Promise(r => setTimeout(r, ms));
}

export function log(phase: string, msg: string): void {
  const ts = new Date().toISOString().slice(11, 23);
  console.log(`[${ts}] [${phase}] ${msg}`);
}
