#!/usr/bin/env node

import { chromium } from 'playwright';
import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';
import { spawn } from 'child_process';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const COOKIES_FILE = path.join(__dirname, 'session-cookies.json');
const PROFILE_DIR = path.join(__dirname, 'manual-login-profile');

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function runNodeScript(scriptName, args = []) {
  return new Promise((resolve, reject) => {
    const child = spawn('node', [scriptName, ...args], {
      cwd: __dirname,
      stdio: 'inherit',
    });
    child.on('exit', (code) => {
      if (code === 0) {
        resolve();
        return;
      }
      reject(new Error(`${scriptName} failed with exit code ${code}`));
    });
  });
}

async function isAuthenticated(page, context) {
  const url = page.url();
  if (url.includes('sign-in')) {
    return false;
  }

  const cookies = await context.cookies();
  const hasSessionCookie = cookies.some((c) =>
    c.name.toLowerCase().includes('substack') || c.name.toLowerCase().includes('sid')
  );

  if (!hasSessionCookie) {
    return false;
  }

  const body = ((await page.textContent('body')) || '').toLowerCase();
  return (
    body.includes('sign out') ||
    body.includes('account') ||
    body.includes('manage subscription') ||
    body.includes('chat')
  );
}

async function main() {
  const [email, password] = process.argv.slice(2);
  if (!email || !password) {
    console.error('Usage: node manual-login-capture.js <email> <password>');
    process.exit(1);
  }

  console.log('Starting manual-assisted login flow...');
  console.log('A browser window will open now.');
  console.log('1) Sign in manually (email/OTP/password as needed).');
  console.log('2) Stay on any authenticated Substack page.');
  console.log('3) This script will auto-detect login and continue capture.');

  const context = await chromium.launchPersistentContext(PROFILE_DIR, {
    headless: false,
    userAgent:
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
  });

  const page = context.pages()[0] || (await context.newPage());
  await page.goto('https://substack.com/sign-in', {
    waitUntil: 'networkidle',
    timeout: 60000,
  });

  const startedAt = Date.now();
  const timeoutMs = 15 * 60 * 1000;
  let authed = false;

  while (Date.now() - startedAt < timeoutMs) {
    try {
      authed = await isAuthenticated(page, context);
      if (authed) {
        break;
      }
    } catch {
      // Keep polling through transient navigation states.
    }
    await sleep(3000);
  }

  if (!authed) {
    await page.screenshot({ path: 'manual-login-timeout.png', fullPage: true });
    await context.close();
    throw new Error('Manual login was not detected within timeout window');
  }

  const cookies = await context.cookies();
  await fs.writeFile(COOKIES_FILE, JSON.stringify(cookies, null, 2), 'utf-8');
  await page.screenshot({ path: 'manual-login-success.png', fullPage: true });
  console.log(`Saved ${cookies.length} cookies to ${COOKIES_FILE}`);

  await context.close();

  console.log('Running post capture with saved session...');
  await runNodeScript('scrape-posts.js', [email, password, '--reuse-cookies']);

  console.log('Running comments capture with saved session...');
  await runNodeScript('scraper.js', [email, password, '--reuse-cookies']);

  console.log('Manual-assisted capture complete.');
}

main().catch((err) => {
  console.error('Capture failed:', err.message);
  process.exit(1);
});
