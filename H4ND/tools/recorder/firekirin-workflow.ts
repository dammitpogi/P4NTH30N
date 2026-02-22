#!/usr/bin/env bun
/**
 * DECISION_077 + ARCH-081: FireKirin Full Navigation Workflow
 * Login → Dismiss Modals → Game Selection → Auto Spin → Logout
 *
 * Mirrors CdpGameActions.cs exactly. Production-ready.
 * ARCH-081: Uses relative coordinates (0.0-1.0) with absolute fallbacks.
 * Relative coords computed from design viewport 930x865 calibrated 2026-02-21.
 *
 * Usage: bun run firekirin-workflow.ts [--username=X] [--password=X] [--spins=N] [--game=fortune-piggy]
 */
import { CdpClient, sleep, log } from './cdp-client';
import { writeFile, mkdir } from 'fs/promises';
import { join } from 'path';
import type { RelativeCoordinate, CanvasBounds } from './types';

// ARCH-081: Design viewport these coordinates were calibrated against
const DESIGN_VIEWPORT = { width: 930, height: 865, calibratedDate: '2026-02-21' };

// ── Coordinates (ARCH-081: relative + absolute fallback) ──
// rx = x / DESIGN_VIEWPORT.width, ry = y / DESIGN_VIEWPORT.height
const FK: Record<string, RelativeCoordinate> = {
  ACCOUNT:        { rx: 0.4946, ry: 0.4243, x: 460, y: 367 },
  PASSWORD:       { rx: 0.4946, ry: 0.5052, x: 460, y: 437 },
  LOGIN:          { rx: 0.5946, ry: 0.6555, x: 553, y: 567 },
  GUEST:          { rx: 0.3978, ry: 0.6555, x: 370, y: 567 },
  SPIN:           { rx: 0.9247, ry: 0.7572, x: 860, y: 655 },
  MENU:           { rx: 0.0430, ry: 0.7723, x: 40,  y: 668 },
  HOME:           { rx: 0.0430, ry: 0.2312, x: 40,  y: 200 },
  SLOT_CAT:       { rx: 0.0398, ry: 0.5931, x: 37,  y: 513 },
  ALL_CAT:        { rx: 0.0398, ry: 0.3618, x: 37,  y: 313 },
  PAGE_LEFT:      { rx: 0.8710, ry: 0.2948, x: 810, y: 255 },
  PAGE_RIGHT:     { rx: 0.9086, ry: 0.2948, x: 845, y: 255 },
  SHARE_CLOSE:    { rx: 0.8065, ry: 0.2775, x: 750, y: 240 },
  ANNOUNCE_CLOSE: { rx: 0.9140, ry: 0.2775, x: 850, y: 240 },
  FORTUNE_PIGGY:  { rx: 0.0860, ry: 0.5896, x: 80,  y: 510 },
  SETTINGS_GEAR:  { rx: 0.9677, ry: 0.0347, x: 900, y: 30  },
  LOGOUT_BTN:     { rx: 0.9247, ry: 0.5376, x: 860, y: 465 },
  CONFIRM_EXIT:   { rx: 0.5376, ry: 0.5202, x: 500, y: 450 },
};

const URL = 'http://play.firekirin.in/web_mobile/firekirin/';

export interface WorkflowResult {
  platform: 'firekirin';
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

export async function runFireKirinWorkflow(opts: {
  username: string;
  password: string;
  spins?: number;
  game?: string;
  screenshotDir?: string;
  cdpHost?: string;
  cdpPort?: number;
}): Promise<WorkflowResult> {
  const startTime = new Date();
  const ssDir = opts.screenshotDir || join('C:\\P4NTH30N\\DECISION_077\\sessions', `firekirin-run-${startTime.toISOString().replace(/[:.]/g, '-').slice(0, -5)}`);
  const cdp = new CdpClient(opts.cdpHost || '127.0.0.1', opts.cdpPort || 9222, ssDir);
  const spins = opts.spins ?? 3;
  const allScreenshots: string[] = [];
  const phases: PhaseResult[] = [];

  const result: WorkflowResult = {
    platform: 'firekirin',
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
    // ══════════════════════════════════════════════
    const loginPhase = await runPhase('Login', async () => {
      const maxAttempts = 3;

      for (let attempt = 1; attempt <= maxAttempts; attempt++) {
        log('Login', `Attempt ${attempt}/${maxAttempts} — navigating to ${URL}`);
        await cdp.navigate(URL);
        await sleep(5000);
        allScreenshots.push(await cdp.screenshot(`A${attempt}_01_login_page`));

        // ARCH-081: Capture canvas bounds for coordinate transformation
        const canvasBounds = await cdp.getCanvasBounds();
        log('Login', `Canvas bounds: ${JSON.stringify(canvasBounds)}`);

        // Click account field (ARCH-081: relative coords)
        log('Login', `Clicking account field`);
        await cdp.clickRelative(FK.ACCOUNT, canvasBounds);
        await sleep(600);
        allScreenshots.push(await cdp.screenshot(`A${attempt}_02_account_clicked`));

        // Type username — try interceptor first, fall back to typeChars
        log('Login', `Typing username: ${opts.username}`);
        const usernameViaInterceptor = await cdp.typeViaInterceptor(FK.ACCOUNT, opts.username, canvasBounds);
        if (!usernameViaInterceptor) {
          await cdp.typeChars(opts.username);
        }
        await sleep(300);
        allScreenshots.push(await cdp.screenshot(`A${attempt}_03_username_typed`));

        // Click password field (ARCH-081: relative coords)
        log('Login', 'Clicking password field');
        await cdp.clickRelative(FK.PASSWORD, canvasBounds);
        await sleep(600);
        allScreenshots.push(await cdp.screenshot(`A${attempt}_04_password_clicked`));

        // Type password — try interceptor first, fall back to typeChars
        log('Login', 'Typing password');
        const passwordViaInterceptor = await cdp.typeViaInterceptor(FK.PASSWORD, opts.password, canvasBounds);
        if (!passwordViaInterceptor) {
          await cdp.typeChars(opts.password);
        }
        await sleep(300);
        allScreenshots.push(await cdp.screenshot(`A${attempt}_05_password_typed`));

        // Click LOGIN (ARCH-081: relative coords)
        log('Login', 'Clicking LOGIN button');
        await cdp.clickRelative(FK.LOGIN, canvasBounds);
        await sleep(1000);
        allScreenshots.push(await cdp.screenshot(`A${attempt}_06_login_clicked`));

        // Poll for lobby loaded (up to 20s)
        // Detection: check if page screenshot changed significantly (login form gone)
        // or if any lobby indicators appear (WebSocket activity, jackpot data, etc.)
        let loggedIn = false;
        for (let poll = 0; poll < 20; poll++) {
          await sleep(1000);

          // Primary check: screenshot the page and look for lobby indicators
          // The lobby has a sidebar with categories (ALL, FAV, FISHING, SLOT, OTHER)
          // and a jackpot bar at the bottom. The login form has ACCOUNT/PASSWORD fields.
          // We detect lobby by checking if the page has changed from the login state.
          try {
            // Check 1: WS interceptor (may work if page reloaded)
            const wsFrames = await cdp.evaluate<number>("(window._wsFrames || []).length");
            const wsLogin = await cdp.evaluate<string>("JSON.stringify(window._wsLoginResult || 'none')");
            if (wsFrames > 0 || (wsLogin !== '"none"' && wsLogin !== "'none'")) {
              log('Login', `WS detected at ${poll}s — frames: ${wsFrames}, login: ${wsLogin}`);
              allScreenshots.push(await cdp.screenshot(`A${attempt}_07_ws_detected`));
              loggedIn = true;
              break;
            }

            // Check 2: Look for lobby DOM changes — Cocos2d-x injects iframes or changes URL hash
            const pageState = await cdp.evaluate<string>(`(function(){
              var s = [];
              if (window.parent && window.parent.Grand > 0) s.push('grand:' + window.parent.Grand);
              if (window.parent && window.parent.Balance > 0) s.push('bal:' + window.parent.Balance);
              if (document.querySelectorAll('iframe').length > 0) s.push('iframe');
              if (location.hash && location.hash.length > 1) s.push('hash:' + location.hash);
              var ws = window._lastWS;
              if (ws && ws.readyState === 1) s.push('ws:open');
              return s.join(',') || 'login';
            })()`);

            if (pageState !== 'login') {
              log('Login', `Lobby detected at ${poll}s — state: ${pageState}`);
              allScreenshots.push(await cdp.screenshot(`A${attempt}_07_lobby_detected`));
              loggedIn = true;
              break;
            }
          } catch (e: any) {
            // Page might be navigating — that's actually a good sign
            log('Login', `Eval error at ${poll}s (page transitioning?): ${e.message}`);
          }

          // Screenshot every 3s while waiting
          if (poll > 0 && poll % 3 === 0) {
            allScreenshots.push(await cdp.screenshot(`A${attempt}_wait_${poll}s`));
            log('Login', `Still waiting... ${poll}s`);
          }
        }

        allScreenshots.push(await cdp.screenshot(`A${attempt}_08_post_login`));

        if (loggedIn) {
          log('Login', '✅ Login confirmed — lobby reached');
          const wsFrames = await cdp.evaluate<number>("(window._wsFrames || []).length");
          return { wsFrames, attempt, url: await cdp.evaluate<string>('location.href') };
        }

        // Not logged in — refresh and retry
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
    // ══════════════════════════════════════════════
    const modalPhase = await runPhase('DismissModals', async () => {
      log('Modals', 'Dismissing announcement/share dialogs');

      // ARCH-081: Get fresh canvas bounds for modal dismissal
      const modalBounds = await cdp.getCanvasBounds();

      // Try closing announcement modal (X button top-right)
      for (let i = 0; i < 3; i++) {
        await cdp.clickRelative(FK.ANNOUNCE_CLOSE, modalBounds);
        await sleep(800);
      }

      // Try closing share dialog
      await cdp.clickRelative(FK.SHARE_CLOSE, modalBounds);
      await sleep(1000);

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

      // Click SLOT category
      log('Nav', 'Selecting SLOT category');
      await cdp.clickRelative(FK.SLOT_CAT, navBounds);
      await sleep(2000);
      allScreenshots.push(await cdp.screenshot('05_slot_category'));

      // Reset to page 1 by clicking left 5 times
      log('Nav', 'Resetting to page 1');
      for (let i = 0; i < 5; i++) {
        await cdp.clickRelative(FK.PAGE_LEFT, navBounds);
        await sleep(400);
      }
      await sleep(1000);

      // Page right once to page 2 where Fortune Piggy lives
      log('Nav', 'Navigating to page 2 (Fortune Piggy)');
      await cdp.clickRelative(FK.PAGE_RIGHT, navBounds);
      await sleep(1500);
      allScreenshots.push(await cdp.screenshot('06_page2_games'));

      // Click Fortune Piggy
      log('Nav', 'Clicking Fortune Piggy');
      await cdp.clickRelative(FK.FORTUNE_PIGGY, navBounds);
      await sleep(8000);

      allScreenshots.push(await cdp.screenshot('07_game_loaded'));

      return { game: 'Fortune Piggy', page: 2 };
    });
    phases.push(navPhase);
    if (!navPhase.success) throw new Error('Game navigation failed');

    // ══════════════════════════════════════════════
    // PHASE 4: AUTO SPIN
    // ══════════════════════════════════════════════
    const spinPhase = await runPhase('AutoSpin', async () => {
      log('Spin', `Executing ${spins} spin(s) via single-click`);
      // ARCH-081: Get fresh canvas bounds for spin phase (game canvas may differ from lobby)
      const spinBounds = await cdp.getCanvasBounds();

      for (let i = 0; i < spins; i++) {
        log('Spin', `Spin ${i + 1}/${spins}`);
        await cdp.clickRelative(FK.SPIN, spinBounds);
        await sleep(4000); // wait for reel animation to complete
        allScreenshots.push(await cdp.screenshot(`08_spin_${i + 1}`));
      }

      allScreenshots.push(await cdp.screenshot('09_spins_complete'));

      return { spins };
    });
    phases.push(spinPhase);

    // ══════════════════════════════════════════════
    // PHASE 5: LOGOUT
    // ══════════════════════════════════════════════
    const logoutPhase = await runPhase('Logout', async () => {
      // Force navigate back to login page — this triggers "Exit the login?" dialog
      log('Logout', 'Force-navigating to login URL');
      await cdp.navigate(URL);
      await sleep(5000);
      allScreenshots.push(await cdp.screenshot('10_logout_nav'));

      // The page reloads to login screen (fresh session in incognito)
      const url = await cdp.evaluate<string>('location.href');
      log('Logout', `Final URL: ${url}`);
      allScreenshots.push(await cdp.screenshot('11_logged_out'));

      return { url };
    });
    phases.push(logoutPhase);

    result.success = true;
    log('Done', '✅ FireKirin workflow complete');
  } catch (err: any) {
    result.error = err.message;
    log('Error', `❌ ${err.message}`);
    try { allScreenshots.push(await cdp.screenshot('ERROR_final')); } catch {}
  } finally {
    const endTime = new Date();
    result.endTime = endTime.toISOString();
    result.durationMs = endTime.getTime() - startTime.getTime();

    // Save workflow result as JSON
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
    console.log('Usage: bun run firekirin-workflow.ts --username=X --password=X [--spins=3]');
    console.log('\nCredentials from MongoDB: run T00L5ET.exe credcheck to list available accounts');
    process.exit(1);
  }

  const result = await runFireKirinWorkflow({ username, password, spins });
  console.log(`\n${'═'.repeat(60)}`);
  console.log(`FireKirin Workflow: ${result.success ? '✅ SUCCESS' : '❌ FAILED'}`);
  console.log(`Duration: ${(result.durationMs / 1000).toFixed(1)}s`);
  console.log(`Screenshots: ${result.screenshots.length}`);
  console.log(`Phases:`);
  for (const p of result.phases) {
    console.log(`  ${p.success ? '✅' : '❌'} ${p.name} (${p.durationMs}ms)`);
  }
  if (result.error) console.log(`Error: ${result.error}`);
  process.exit(result.success ? 0 : 1);
}
