#!/usr/bin/env bun
import { readFile } from 'fs/promises';
import { join } from 'path';
import { SessionManager } from './session-manager';
import { T00L5ETBridge } from './t00l5et-bridge';
import { ScreenshotProcessor } from './screenshot-processor';
import { CdpClient } from './cdp-client';
import type { PlatformConfig, StepRecord, CanvasBounds } from './types';
import { spawn, exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

async function main() {
  const args = process.argv.slice(2);
  const command = args.find(arg => arg.startsWith('--'))?.split('=')[0];

  if (command === '--init') {
    await handleInit(args);
  } else if (command === '--step') {
    await handleStep(args);
  } else if (command === '--diag') {
    await handleDiag(args);
  } else if (command === '--login') {
    await handleLogin(args);
  } else {
    printUsage();
  }
}

async function handleInit(args: string[]) {
  const platform = getArg(args, '--platform') as 'firekirin' | 'orionstars' || 'firekirin';
  const decision = getArg(args, '--decision') || 'DECISION_077';
  const baseDir = getArg(args, '--base-dir') || 'C:\\P4NTHE0N\\DECISION_077\\sessions';

  console.log(`Initializing session for ${platform}...`);
  
  const session = await SessionManager.initialize(platform, decision, baseDir);
  const metadata = session.getMetadata();

  console.log(`\n✅ Session initialized`);
  console.log(`Session ID: ${metadata.sessionId}`);
  console.log(`Session Directory: ${metadata.baseDir}`);
  console.log(`Screenshot Directory: ${metadata.screenshotDir}`);
  console.log(`Log File: ${metadata.logFile}`);
  console.log(`Markdown Report: ${metadata.markdownFile}`);
  console.log(`\nNext: Provide first screenshot and run:`);
  console.log(`bun run recorder.ts --step --phase=Login --screenshot=001.png --session-dir="${metadata.baseDir}" --run-tool=diag`);
}

async function handleStep(args: string[]) {
  const phase = getArg(args, '--phase') || 'Login';
  const screenshot = getArg(args, '--screenshot') || '001.png';
  const sessionDir = getArg(args, '--session-dir');
  const runTool = getArg(args, '--run-tool');

  if (!sessionDir) {
    console.error('Error: --session-dir is required for --step');
    process.exit(1);
  }

  // Auto-create session directory if it doesn't exist
  const { mkdir } = await import('fs/promises');
  const { existsSync } = await import('fs');
  
  if (!existsSync(sessionDir)) {
    console.log(`Session directory not found. Creating: ${sessionDir}`);
    await mkdir(sessionDir, { recursive: true });
    await mkdir(join(sessionDir, 'screenshots'), { recursive: true });
    
    // Initialize session files
    const { writeFile } = await import('fs/promises');
    await writeFile(join(sessionDir, 'session.ndjson'), '');
    await writeFile(
      join(sessionDir, 'session.md'),
      `# DECISION_077 Navigation Session\n\n` +
      `**Session Directory**: ${sessionDir}\n` +
      `**Start Time**: ${new Date().toISOString()}\n\n` +
      `---\n\n`
    );
    console.log(`✅ Session directory initialized`);
  }

  // ARCH-081: Support custom CDP port and profile dir
  const cdpPort = parseInt(getArg(args, '--cdp-port') || '9222', 10);
  const profileDir = getArg(args, '--profile-dir');
  await ensureChromeWithCDP(cdpPort, profileDir);

  const metadataPath = join(sessionDir, 'session.ndjson');
  const configPath = join('C:\\P4NTHE0N\\H4ND\\config\\firekirin', 'phase-definitions.json');
  
  const configContent = await readFile(configPath, 'utf-8');
  const config: PlatformConfig = JSON.parse(configContent);
  
  const processor = new ScreenshotProcessor(config);
  const bridge = new T00L5ETBridge();

  const startTime = Date.now();
  const step: StepRecord = {
    stepNumber: 0,
    phase,
    timestamp: new Date().toISOString(),
    screenshot,
    status: 'success',
  };

  if (runTool) {
    step.tool = runTool;
    console.log(`\nExecuting tool: ${runTool}...`);
    
    let result;
    if (runTool === 'diag') {
      result = await bridge.diag();
    } else if (runTool === 'login') {
      result = await bridge.login();
    } else if (runTool === 'credcheck') {
      result = await bridge.credcheck();
    } else {
      result = await bridge.executeTool(runTool);
    }

    step.toolOutput = result.stdout;
    step.duration = result.duration;
    step.status = result.success ? 'success' : 'failure';

    const parsed = bridge.parseOutput(result);
    step.cdpVerification = {
      'CDP Connected': parsed.cdp || false,
      'MongoDB Connected': parsed.mongodb || false,
    };

    if (parsed.url) {
      step.cdpVerification['URL check'] = parsed.url;
    }
    if (parsed.readyState) {
      step.cdpVerification['Ready state'] = parsed.readyState;
    }
    if (parsed.loginSuccess) {
      step.cdpVerification['Login success indicator'] = '✅ "SLOT" found in body text';
    }
  }

  const phaseAnalysis = processor.analyzePhase(phase, screenshot);
  step.phaseTransition = {
    entryGate: phaseAnalysis.entryGate,
    exitGate: phaseAnalysis.exitGate,
  };

  // ARCH-081: Capture canvas bounds for coordinate validation
  try {
    const cdp = new CdpClient('127.0.0.1', cdpPort);
    await cdp.connect();
    const canvasBounds = await cdp.getCanvasBounds();
    if (canvasBounds.width > 0 && canvasBounds.height > 0) {
      step.canvasBounds = canvasBounds;
      console.log(`[ARCH-081] Canvas bounds captured: ${JSON.stringify(canvasBounds)}`);
    }
    cdp.close();
  } catch (e: any) {
    console.log(`[ARCH-081] Canvas bounds capture skipped: ${e.message}`);
  }

  const phaseDef = processor.getPhaseDefinition(phase);
  if (phaseDef) {
    step.coordinates = {};
    for (const [name, action] of Object.entries(phaseDef.actions)) {
      if ('rx' in action && 'ry' in action && 'x' in action && 'y' in action) {
        // ARCH-081: Full RelativeCoordinate
        step.coordinates[name] = { rx: (action as any).rx, ry: (action as any).ry, x: (action as any).x, y: (action as any).y };
      } else if ('x' in action && 'y' in action) {
        step.coordinates[name] = { x: (action as any).x, y: (action as any).y };
      }
    }
  }

  const sessionManager = new SessionManager({
    sessionId: '',
    platform: 'firekirin',
    decision: 'DECISION_077',
    startTime: '',
    baseDir: sessionDir,
    screenshotDir: join(sessionDir, 'screenshots'),
    logFile: join(sessionDir, 'session.ndjson'),
    markdownFile: join(sessionDir, 'session.md'),
  });

  await sessionManager.recordStep(step);

  console.log(`\n✅ Step ${step.stepNumber} Complete: ${phase}`);
  console.log(`Status: ${step.status}`);
  console.log(`Screenshot: screenshots/${screenshot}`);
  if (step.tool) console.log(`Tool: ${step.tool}`);
  if (step.duration) console.log(`Duration: ${step.duration}ms`);
  
  console.log(`\nSee ${join(sessionDir, 'session.md')} for full report`);
}

async function handleDiag(args: string[]) {
  const bridge = new T00L5ETBridge();
  console.log('Running diagnostic...');
  const result = await bridge.diag();
  console.log(result.stdout);
  if (result.stderr) console.error(result.stderr);
  process.exit(result.exitCode);
}

async function handleLogin(args: string[]) {
  const bridge = new T00L5ETBridge();
  const username = getArg(args, '--username');
  const password = getArg(args, '--password');
  
  console.log('Running login...');
  const result = await bridge.login(username, password);
  console.log(result.stdout);
  if (result.stderr) console.error(result.stderr);
  process.exit(result.exitCode);
}

// ARCH-081: Support custom CDP port and profile directory for Chrome profile isolation
async function ensureChromeWithCDP(port: number = 9222, profileDir?: string): Promise<void> {
  console.log(`\n[CDP Check] Verifying Chrome is running on port ${port}...`);
  
  try {
    const response = await fetch(`http://127.0.0.1:${port}/json/version`);
    if (response.ok) {
      const data = await response.json();
      console.log(`[CDP Check] ✅ Chrome ${data.Browser} connected on port ${port}`);
      return;
    }
  } catch (err) {
    console.log(`[CDP Check] ⚠️  Chrome not running on port ${port}`);
  }

  // Only kill existing Chrome if using default port (avoid killing other workers' instances)
  if (port === 9222) {
    console.log('[CDP Check] Checking for existing Chrome processes...');
    try {
      const { stdout } = await execAsync('tasklist /FI "IMAGENAME eq chrome.exe" /FO CSV /NH');
      if (stdout.includes('chrome.exe')) {
        console.log('[CDP Check] Found Chrome running without CDP. Killing...');
        await execAsync('taskkill /F /IM chrome.exe');
        await new Promise(resolve => setTimeout(resolve, 2000));
      }
    } catch (err) {
      // No Chrome running, continue
    }
  }

  // ARCH-081: Use provided profile dir or default temp dir
  const userDataDir = profileDir
    || `C:\\ProgramData\\P4NTHE0N\\chrome-profiles\\Profile-Recorder-${port}`;

  console.log(`[CDP Check] Starting Chrome with CDP on port ${port} (profile: ${userDataDir})...`);
  const chromeArgs = [
    `--remote-debugging-port=${port}`,
    '--remote-debugging-address=127.0.0.1',
    '--incognito',
    '--no-first-run',
    '--no-default-browser-check',
    '--ignore-certificate-errors',
    '--disable-web-security',
    '--allow-running-insecure-content',
    '--disable-features=SafeBrowsing',
    `--user-data-dir=${userDataDir}`
  ];

  spawn('chrome.exe', chromeArgs, {
    detached: true,
    stdio: 'ignore'
  }).unref();

  // Wait for Chrome to start
  console.log('[CDP Check] Waiting for Chrome to initialize...');
  for (let i = 0; i < 10; i++) {
    await new Promise(resolve => setTimeout(resolve, 1000));
    try {
      const response = await fetch(`http://127.0.0.1:${port}/json/version`);
      if (response.ok) {
        const data = await response.json();
        console.log(`[CDP Check] ✅ Chrome ${data.Browser} started on port ${port}`);
        return;
      }
    } catch {}
  }

  console.error(`[CDP Check] ❌ Failed to start Chrome with CDP on port ${port}`);
  throw new Error(`Chrome CDP initialization failed on port ${port}`);
}

function getArg(args: string[], name: string): string | undefined {
  const arg = args.find(a => a.startsWith(`${name}=`));
  return arg ? arg.split('=')[1] : undefined;
}

function printUsage() {
  console.log(`
P4NTHE0N Recorder - Navigation Workflow Recording Tool

Usage:
  bun run recorder.ts --init --platform=<platform> [--decision=<decision>]
  bun run recorder.ts --step --phase=<phase> --screenshot=<file> --session-dir=<dir> [--run-tool=<tool>]
  bun run recorder.ts --diag
  bun run recorder.ts --login [--username=<user>] [--password=<pass>]

Commands:
  --init              Initialize a new recording session
  --step              Record a navigation step
  --diag              Run CDP/MongoDB diagnostics
  --login             Execute login via T00L5ET

Options:
  --platform          Platform: firekirin | orionstars (default: firekirin)
  --decision          Decision ID (default: DECISION_077)
  --phase             Navigation phase: Login | GameSelection | Spin
  --screenshot        Screenshot filename (e.g., 001.png)
  --session-dir       Session directory path
  --run-tool          Tool to execute: diag | login | credcheck | nav
  --cdp-port          CDP port (default: 9222, ARCH-081 profile isolation)
  --profile-dir       Chrome profile directory (ARCH-081 isolation)
  --username          Login username
  --password          Login password

Examples:
  bun run recorder.ts --init --platform=firekirin --decision=DECISION_077
  bun run recorder.ts --step --phase=Login --screenshot=001.png --session-dir=C:\\P4NTHE0N\\DECISION_077\\sessions\\firekirin-2026-02-21 --run-tool=diag
`);
}

main().catch(console.error);
