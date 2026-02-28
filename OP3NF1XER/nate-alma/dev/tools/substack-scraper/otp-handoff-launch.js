#!/usr/bin/env node

import { chromium } from 'playwright';
import fs from 'fs/promises';
import path from 'path';

const CREDS_PATH =
  'C:/Users/paulc/OneDrive/Desktop/New folder (2)/For Nate/Substack.md';
const PROFILE_DIR = path.join(process.cwd(), 'otp-handoff-profile');
const STATE_FILE = path.join(process.cwd(), 'otp-handoff-state.json');

function parseCreds(raw) {
  const lines = raw
    .split(/\r?\n/)
    .map((x) => x.trim())
    .filter(Boolean);
  return { email: lines[0] || '', password: lines[1] || '' };
}

async function clickContinue(page) {
  const clicked = await page.evaluate(() => {
    const isVisible = (e) => {
      const s = getComputedStyle(e);
      const r = e.getBoundingClientRect();
      return s.display !== 'none' && s.visibility !== 'hidden' &&
        r.width > 0 && r.height > 0;
    };
    const btn = [...document.querySelectorAll('button')].find((b) =>
      isVisible(b) && (
        (b.type || '').toLowerCase() === 'submit' ||
        (b.textContent || '').toLowerCase().includes('continue')
      ),
    );
    if (btn) {
      btn.click();
      return true;
    }
    return false;
  });
  return clicked;
}

async function detectState(page) {
  const body = ((await page.textContent('body')) || '').toLowerCase();
  const otpVisible = await page
    .locator('input[type=text], input[inputmode=numeric]')
    .first()
    .isVisible({ timeout: 800 })
    .catch(() => false);
  return {
    url: page.url(),
    hasThrottle: body.includes('too many login emails'),
    hasCheckEmail: body.includes('check your email'),
    otpVisible,
  };
}

async function main() {
  const credsRaw = await fs.readFile(CREDS_PATH, 'utf-8');
  const { email } = parseCreds(credsRaw);
  if (!email) {
    throw new Error('Missing email in Substack.md');
  }

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
  await page.fill('input[type=email]', email);
  const clicked = await clickContinue(page);
  await page.waitForTimeout(3000);

  const state = await detectState(page);
  await page.screenshot({ path: 'handoff-otp-ready.png', fullPage: true });

  await fs.writeFile(
    STATE_FILE,
    JSON.stringify(
      {
        ts: new Date().toISOString(),
        phase: 'otp_handoff_ready',
        clicked,
        ...state,
        note: 'User should complete OTP then password manually in this browser.',
      },
      null,
      2,
    ),
    'utf-8',
  );

  // Keep browser/session alive for manual completion.
  setInterval(async () => {
    try {
      const live = await detectState(page);
      await fs.writeFile(
        STATE_FILE,
        JSON.stringify(
          {
            ts: new Date().toISOString(),
            phase: 'waiting_for_user_done',
            ...live,
          },
          null,
          2,
        ),
        'utf-8',
      );
    } catch {
      // keep alive despite transient UI navigation states
    }
  }, 3000);
}

main().catch(async (err) => {
  await fs.writeFile(
    'otp-handoff-error.log',
    `${new Date().toISOString()} ${err.message}\n`,
    'utf-8',
  );
  process.exit(1);
});
