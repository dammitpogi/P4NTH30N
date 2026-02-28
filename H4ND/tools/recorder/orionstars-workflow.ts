#!/usr/bin/env bun
/**
 * DECISION_077 + ARCH-081: OrionStars Full Navigation Workflow
 * Login → Dismiss Modals → Game Selection → Auto Spin → Logout
 *
 * Mirrors CdpGameActions.cs OrionStars methods exactly. Production-ready.
 * ARCH-081: Uses relative coordinates (0.0-1.0) with absolute fallbacks.
 * Relative coords computed from design viewport 930x865 calibrated 2026-02-21.
 * OrionStars uses Cocos2d-x Canvas (same engine as FireKirin) — NO DOM elements.
 * Login uses popup keyboard dialog: click field → keyboard overlay → type → confirm.
 *
 * Usage: bun run orionstars-workflow.ts --username=X --password=X [--spins=3]
 */
import { CdpClient, sleep, log } from './cdp-client';
import { writeFile, mkdir } from 'fs/promises';
import { join } from 'path';
import type { RelativeCoordinate, CanvasBounds } from './types';

// ARCH-081: Design viewport these coordinates were calibrated against
const DESIGN_VIEWPORT = { width: 930, height: 865, calibratedDate: '2026-02-21' };

// ── Coordinates (ARCH-081: relative + absolute fallback) ──
// rx = x / DESIGN_VIEWPORT.width, ry = y / DESIGN_VIEWPORT.height
// OrionStars loads into a GUEST LOBBY first, then you click LOGIN to get the form.
const OS: Record<string, RelativeCoordinate> = {
  // Guest lobby
  LOBBY_LOGIN_BTN:  { rx: 0.5000, ry: 0.7977, x: 465, y: 690 },

  // Login form (appears after clicking LOBBY_LOGIN_BTN)
  ACCOUNT:          { rx: 0.5054, ry: 0.4682, x: 470, y: 405 },
  PASSWORD:         { rx: 0.5054, ry: 0.5526, x: 470, y: 478 },
  LOGIN:            { rx: 0.4946, ry: 0.6936, x: 460, y: 600 },
  LOGIN_CLOSE:      { rx: 0.8118, ry: 0.3353, x: 755, y: 290 },

  // Post-login lobby
  DIALOG_OK:        { rx: 0.5054, ry: 0.5260, x: 470, y: 455 },
  NOTIF_CLOSE:      { rx: 0.9355, ry: 0.2139, x: 870, y: 185 },
  SETTINGS:         { rx: 0.9677, ry: 0.7283, x: 900, y: 630 },
  CONFIRM:          { rx: 0.5269, ry: 0.6243, x: 490, y: 540 },
  SPIN:             { rx: 0.9247, ry: 0.7572, x: 860, y: 655 },
  HOME:             { rx: 0.0430, ry: 0.2312, x: 40,  y: 200 },
  MENU:             { rx: 0.0430, ry: 0.7723, x: 40,  y: 668 },

  // Lobby categories (from screenshot 001)
  ALL_CAT:          { rx: 0.0398, ry: 0.3584, x: 37,  y: 310 },
  FAV_CAT:          { rx: 0.0398, ry: 0.4162, x: 37,  y: 360 },
  FISHING_CAT:      { rx: 0.0398, ry: 0.4740, x: 37,  y: 410 },
  REELS_CAT:        { rx: 0.0398, ry: 0.5376, x: 37,  y: 465 },  // "REELS" = slots
  OTHER_CAT:        { rx: 0.0398, ry: 0.5896, x: 37,  y: 510 },
  LINKS_CAT:        { rx: 0.0398, ry: 0.6474, x: 37,  y: 560 },

  // First game on REELS page
  FIRST_GAME:       { rx: 0.3011, ry: 0.4277, x: 280, y: 370 },
};

const URL = 'http://web.orionstars.org/hot_play/orionstars/';

export interface WorkflowResult {
  platform: 'orionstars';
  success: boolean;
  username: string;
  phases: PhaseResult[];
  startTime: string;
  endTime: string;
  durationMs: number;
  screenshots: string[];
  error?: string;
}

interface PhaseResult {
  name: string;
  success: boolean;
  durationMs: number;
  screenshots: string[];
  details: Record<string, any>;
}

export async function runOrionStarsWorkflow(opts: {
  username: string;
  password: string;
  spins?: number;
  screenshotDir?: string;
  cdpHost?: string;
  cdpPort?: number;
}): Promise<WorkflowResult> {
  const startTime = new Date();
  const ssDir = opts.screenshotDir || join('C:\\P4NTHE0N\\DECISION_077\\sessions', `orionstars-run-${startTime.toISOString().replace(/[:.]/g, '-').slice(0, -5)}`);
  const cdp = new CdpClient(opts.cdpHost || '127.0.0.1', opts.cdpPort || 9222, ssDir);
  const spins = opts.spins ?? 3;
  const allScreenshots: string[] = [];
  const phases: PhaseResult[] = [];

  const result: WorkflowResult = {
    platform: 'orionstars',
    success: false,
    username: opts.username,
    phases,
    startTime: startTime.toISOString(),
    endTime: '',
    durationMs: 0,
    screenshots: allScreenshots,
  };

  try {
    await cdp.connect();
    // ARCH-081: Inject both WS and canvas input interceptors
    await cdp.injectAllInterceptors();

    // ══════════════════════════════════════════════
    // PHASE 1: LOGIN
    // OrionStars has a splash screen + loading bar (12s wait)
    // Login uses popup keyboard: click field → keyboard overlay → type → confirm
    // ══════════════════════════════════════════════
    const loginPhase = await runPhase('Login', async () => {
      const maxAttempts = 3;

      for (let attempt = 1; attempt <= maxAttempts; attempt++) {
        log('Login', `Attempt ${attempt}/${maxAttempts} — navigating to ${URL}`);
        await cdp.navigate(URL);
        await sleep(12000); // OrionStars splash screen + loading bar
        allScreenshots.push(await cdp.screenshot(`A${attempt}_01_guest_lobby`));

        // ARCH-081: Capture canvas bounds for coordinate transformation
        const canvasBounds = await cdp.getCanvasBounds();
        log('Login', `Canvas bounds: ${JSON.stringify(canvasBounds)}`);

        // Step 1: Click LOGIN button on guest lobby (bottom center)
        log('Login', 'Clicking LOGIN on guest lobby');
        await cdp.clickRelative(OS.LOBBY_LOGIN_BTN, canvasBounds);
        await sleep(2000);
        allScreenshots.push(await cdp.screenshot(`A${attempt}_02_login_form`));

        // Step 2: Fill credentials
        // The login form is Canvas-rendered inside iframe "frmDialog".
        // Cocos2d-x creates a TEMPORARY hidden <input> when a Canvas field is tapped.
        // Strategy: click field → wait for temp input → find it in iframe → set value + confirm

        log('Login', 'Getting iframe context for frmDialog');
        const iframeCtx = await cdp.getIframeContextId('frmDialog');
        log('Login', `Iframe context: ${iframeCtx || 'not found'}`);

        // Click Account field — this creates a temp input in the iframe
        log('Login', 'Clicking account field');
        await cdp.clickRelative(OS.ACCOUNT, canvasBounds);
        await sleep(2000);
        allScreenshots.push(await cdp.screenshot(`A${attempt}_03_acct_clicked`));

        // Deep diagnostic: search ALL frames for inputs
        const deepDiag = await cdp.evaluate<string>(`(function(){
          var results = [];
          // Main frame
          var mainInputs = document.querySelectorAll('input');
          results.push('main:' + mainInputs.length);
          // Check all iframes
          var iframes = document.querySelectorAll('iframe');
          for (var i = 0; i < iframes.length; i++) {
            try {
              var doc = iframes[i].contentDocument || iframes[i].contentWindow.document;
              var iInputs = doc.querySelectorAll('input');
              results.push('iframe[' + i + ']:' + iInputs.length);
              for (var j = 0; j < iInputs.length; j++) {
                results.push('  inp:' + iInputs[j].type + ':' + iInputs[j].id + ':val=' + iInputs[j].value.substring(0,20));
              }
              // Also check active element
              if (doc.activeElement) results.push('  active:' + doc.activeElement.tagName + ':' + doc.activeElement.type);
            } catch(e) { results.push('iframe[' + i + ']:cross-origin'); }
          }
          // Check active element in main
          results.push('mainActive:' + document.activeElement?.tagName);
          return results.join('|');
        })()`);
        log('Login', `Deep diagnostic: ${deepDiag}`);

        // Also check iframe context directly
        const iframeDiag2 = await cdp.evaluate<string>(`(function(){
          var inputs = document.querySelectorAll('input');
          var all = document.querySelectorAll('*');
          return 'inputs:' + inputs.length + ' allElements:' + all.length + ' active:' + (document.activeElement?.tagName || 'none') + ' url:' + location.href.substring(0,60);
        })()`, iframeCtx);
        log('Login', `Iframe ctx diag: ${iframeDiag2}`);

        // ARCH-081: Try interceptor first, fall back to typeCharsSlow
        log('Login', `Typing username: ${opts.username}`);
        const usernameViaInterceptor = await cdp.typeViaInterceptor(OS.ACCOUNT, opts.username, canvasBounds);
        if (!usernameViaInterceptor) {
          log('Login', 'Interceptor missed — falling back to typeCharsSlow');
          await cdp.typeCharsSlow(opts.username, 200);
        }
        await sleep(500);
        allScreenshots.push(await cdp.screenshot(`A${attempt}_04_username_typed`));

        // Confirm with Enter
        await cdp.send('Input.dispatchKeyEvent', { type: 'keyDown', key: 'Enter', code: 'Enter', windowsVirtualKeyCode: 13 });
        await cdp.send('Input.dispatchKeyEvent', { type: 'keyUp', key: 'Enter', code: 'Enter', windowsVirtualKeyCode: 13 });
        await sleep(1500);
        allScreenshots.push(await cdp.screenshot(`A${attempt}_05_acct_confirmed`));

        // Click Password field
        log('Login', 'Clicking password field');
        await cdp.clickRelative(OS.PASSWORD, canvasBounds);
        await sleep(2000);

        // ARCH-081: Try interceptor first, fall back to typeCharsSlow
        log('Login', 'Typing password');
        const passwordViaInterceptor = await cdp.typeViaInterceptor(OS.PASSWORD, opts.password, canvasBounds);
        if (!passwordViaInterceptor) {
          log('Login', 'Interceptor missed — falling back to typeCharsSlow');
          await cdp.typeCharsSlow(opts.password, 200);
        }
        await sleep(500);

        // Confirm with Enter
        await cdp.send('Input.dispatchKeyEvent', { type: 'keyDown', key: 'Enter', code: 'Enter', windowsVirtualKeyCode: 13 });
        await cdp.send('Input.dispatchKeyEvent', { type: 'keyUp', key: 'Enter', code: 'Enter', windowsVirtualKeyCode: 13 });
        await sleep(1500);
        allScreenshots.push(await cdp.screenshot(`A${attempt}_06_pwd_confirmed`));

        // Click LOGIN button
        log('Login', 'Clicking LOGIN button');
        await cdp.clickRelative(OS.LOGIN, canvasBounds);
        await sleep(1000);
        allScreenshots.push(await cdp.screenshot(`A${attempt}_07_login_clicked`));

        // Poll for lobby loaded (up to 20s)
        let loggedIn = false;
        for (let poll = 0; poll < 20; poll++) {
          await sleep(1000);
          try {
            const wsFrames = await cdp.evaluate<number>("(window._wsFrames || []).length");
            const wsLogin = await cdp.evaluate<string>("JSON.stringify(window._wsLoginResult || 'none')");
            if (wsFrames > 0 || (wsLogin !== '"none"' && wsLogin !== "'none'")) {
              log('Login', `WS detected at ${poll}s — frames: ${wsFrames}, login: ${wsLogin}`);
              allScreenshots.push(await cdp.screenshot(`A${attempt}_09_ws_detected`));
              loggedIn = true;
              break;
            }

            // Check if login form disappeared — take a screenshot and compare file size
            // The logged-in lobby is visually very different from the login form.
            // Also check for user-specific JS variables that appear after login.
            const pageState = await cdp.evaluate<string>(`(function(){
              var s = [];
              if (window.parent && window.parent.Balance > 0) s.push('bal:' + window.parent.Balance);
              if (location.hash && location.hash.length > 1) s.push('hash:' + location.hash);
              // Check if login form inputs still have placeholder text (= not logged in)
              var acctInput = document.querySelector('input[placeholder*="Account"]') || document.querySelector('input[placeholder*="account"]');
              var pwdInput = document.querySelector('input[placeholder*="password"]') || document.querySelector('input[placeholder*="Password"]');
              if (acctInput && pwdInput) return 'login'; // Still on login form
              // If no login inputs found, we might have transitioned
              if (!acctInput && !pwdInput) s.push('form-gone');
              return s.join(',') || 'login';
            })()`);

            if (pageState !== 'login') {
              log('Login', `Lobby detected at ${poll}s — state: ${pageState}`);
              allScreenshots.push(await cdp.screenshot(`A${attempt}_06_lobby_detected`));
              loggedIn = true;
              break;
            }
          } catch (e: any) {
            log('Login', `Eval error at ${poll}s (page transitioning?): ${e.message}`);
          }

          if (poll > 0 && poll % 3 === 0) {
            allScreenshots.push(await cdp.screenshot(`A${attempt}_wait_${poll}s`));
            log('Login', `Still waiting... ${poll}s`);
          }
        }

        allScreenshots.push(await cdp.screenshot(`A${attempt}_10_post_login`));

        if (loggedIn) {
          log('Login', '✅ Login confirmed — lobby reached');
          return { attempt, url: await cdp.evaluate<string>('location.href') };
        }

        if (attempt < maxAttempts) {
          log('Login', `❌ Login did not complete — refreshing for attempt ${attempt + 1}`);
          await sleep(2000);
        }
      }

      throw new Error(`Login failed after ${maxAttempts} attempts — server did not respond`);
    });
    phases.push(loginPhase);
    if (!loginPhase.success) throw new Error('Login phase failed');

    // ══════════════════════════════════════════════
    // PHASE 2: DISMISS MODALS
    // OrionStars has notification dialogs after login (up to 5 attempts)
    // ══════════════════════════════════════════════
    const modalPhase = await runPhase('DismissModals', async () => {
      log('Modals', 'Dismissing notification dialogs (up to 3 attempts)');
      // ARCH-081: Get fresh canvas bounds for modal dismissal
      const modalBounds = await cdp.getCanvasBounds();
      for (let i = 0; i < 3; i++) {
        await cdp.clickRelative(OS.DIALOG_OK, modalBounds);
        await sleep(750);
        await cdp.clickRelative(OS.NOTIF_CLOSE, modalBounds);
        await sleep(750);
      }
      allScreenshots.push(await cdp.screenshot('04_modals_dismissed'));
      return { dismissed: true };
    });
    phases.push(modalPhase);

    // ══════════════════════════════════════════════
    // PHASE 3: GAME SELECTION
    // ══════════════════════════════════════════════
    const navPhase = await runPhase('GameSelection', async () => {
      // ARCH-081: Get fresh canvas bounds for game navigation
      const navBounds = await cdp.getCanvasBounds();

      log('Nav', 'Selecting REELS category');
      await cdp.clickRelative(OS.REELS_CAT, navBounds);
      await sleep(2000);
      allScreenshots.push(await cdp.screenshot('05_slot_category'));

      // Click first available game on page 1
      log('Nav', 'Clicking first available slot game');
      await cdp.clickRelative(OS.FIRST_GAME, navBounds);
      await sleep(8000);

      allScreenshots.push(await cdp.screenshot('06_game_loaded'));
      return { game: 'first-slot', page: 1 };
    });
    phases.push(navPhase);
    if (!navPhase.success) throw new Error('Game navigation failed');

    // ══════════════════════════════════════════════
    // PHASE 4: AUTO SPIN
    // ══════════════════════════════════════════════
    const spinPhase = await runPhase('AutoSpin', async () => {
      log('Spin', `Executing ${spins} spin(s) via single-click`);
      // ARCH-081: Get fresh canvas bounds for spin phase
      const spinBounds = await cdp.getCanvasBounds();

      for (let i = 0; i < spins; i++) {
        log('Spin', `Spin ${i + 1}/${spins}`);
        await cdp.clickRelative(OS.SPIN, spinBounds);
        await sleep(4000);
        allScreenshots.push(await cdp.screenshot(`07_spin_${i + 1}`));
      }

      allScreenshots.push(await cdp.screenshot('08_spins_complete'));

      return { spins };
    });
    phases.push(spinPhase);

    // ══════════════════════════════════════════════
    // PHASE 5: LOGOUT
    // ══════════════════════════════════════════════
    const logoutPhase = await runPhase('Logout', async () => {
      // ARCH-081: Get fresh canvas bounds for logout phase
      const logoutBounds = await cdp.getCanvasBounds();

      log('Logout', 'Returning to lobby');
      await cdp.clickRelative(OS.HOME, logoutBounds);
      await sleep(3000);
      allScreenshots.push(await cdp.screenshot('10_back_to_lobby'));

      // Click settings/exit button (bottom-right)
      log('Logout', 'Opening settings');
      await cdp.clickRelative(OS.SETTINGS, logoutBounds);
      await sleep(2000);
      allScreenshots.push(await cdp.screenshot('11_settings_open'));

      // Click confirm/OK
      log('Logout', 'Confirming logout');
      await cdp.clickRelative(OS.CONFIRM, logoutBounds);
      await sleep(2000);

      // Force navigate back to login
      await cdp.navigate(URL);
      await sleep(3000);
      allScreenshots.push(await cdp.screenshot('12_logged_out'));

      const url = await cdp.evaluate<string>('location.href');
      log('Logout', `Final URL: ${url}`);
      return { url };
    });
    phases.push(logoutPhase);

    result.success = true;
    log('Done', '✅ OrionStars workflow complete');
  } catch (err: any) {
    result.error = err.message;
    log('Error', `❌ ${err.message}`);
    try { allScreenshots.push(await cdp.screenshot('ERROR_final')); } catch {}
  } finally {
    const endTime = new Date();
    result.endTime = endTime.toISOString();
    result.durationMs = endTime.getTime() - startTime.getTime();

    const resultPath = join(ssDir, 'workflow-result.json');
    await mkdir(ssDir, { recursive: true });
    await writeFile(resultPath, JSON.stringify(result, null, 2));
    log('Done', `Result saved to ${resultPath}`);

    cdp.close();
  }

  return result;
}

async function runPhase(name: string, fn: () => Promise<Record<string, any>>): Promise<PhaseResult> {
  const start = Date.now();
  log(name, `── Phase: ${name} ──`);
  try {
    const details = await fn();
    const duration = Date.now() - start;
    log(name, `✅ ${name} complete (${duration}ms)`);
    return { name, success: true, durationMs: duration, screenshots: [], details };
  } catch (err: any) {
    const duration = Date.now() - start;
    log(name, `❌ ${name} failed: ${err.message} (${duration}ms)`);
    return { name, success: false, durationMs: duration, screenshots: [], details: { error: err.message } };
  }
}

// ── CLI Entry Point ──
if (import.meta.main) {
  const args = process.argv.slice(2);
  const getArg = (name: string, def?: string) => {
    const a = args.find(a => a.startsWith(`--${name}=`));
    return a ? a.split('=')[1] : def;
  };

  const username = getArg('username');
  const password = getArg('password');
  const spins = parseInt(getArg('spins', '3')!, 10);

  if (!username || !password) {
    console.log('Usage: bun run orionstars-workflow.ts --username=X --password=X [--spins=3]');
    process.exit(1);
  }

  const result = await runOrionStarsWorkflow({ username, password, spins });
  console.log(`\n${'='.repeat(60)}`);
  console.log(`OrionStars Workflow: ${result.success ? '✅ SUCCESS' : '❌ FAILED'}`);
  console.log(`Duration: ${(result.durationMs / 1000).toFixed(1)}s`);
  console.log(`Screenshots: ${result.screenshots.length}`);
  console.log(`Phases:`);
  for (const p of result.phases) {
    console.log(`  ${p.success ? '✅' : '❌'} ${p.name} (${p.durationMs}ms)`);
  }
  if (result.error) console.log(`Error: ${result.error}`);
  process.exit(result.success ? 0 : 1);
}
