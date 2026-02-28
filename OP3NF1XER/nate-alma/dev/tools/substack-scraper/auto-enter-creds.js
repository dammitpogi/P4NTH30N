#!/usr/bin/env node

import { chromium } from 'playwright';
import fs from 'fs/promises';
import path from 'path';

const credsPath =
  'C:/Users/paulc/OneDrive/Desktop/New folder (2)/For Nate/Substack.md';

function parseCreds(text) {
  const lines = text
    .split(/\r?\n/)
    .map((x) => x.trim())
    .filter(Boolean);
  return { email: lines[0] || '', password: lines[1] || '' };
}

const OUT_DIR = process.cwd();
const LOG_FILE = path.join(OUT_DIR, 'ui-decision-log.jsonl');

async function logDecision(event, data = {}) {
  const line = JSON.stringify({
    ts: new Date().toISOString(),
    event,
    ...data,
  });
  await fs.appendFile(LOG_FILE, `${line}\n`, 'utf-8');
}

async function snap(page, name) {
  const safe = name.replace(/[^a-z0-9-_]/gi, '_').toLowerCase();
  const file = path.join(OUT_DIR, `ui-${safe}.png`);
  await page.screenshot({ path: file, fullPage: true });
  await logDecision('screenshot', { name, file });
}

async function isVisible(page, selector, timeout = 1200) {
  return page.locator(selector).first().isVisible({ timeout }).catch(() => false);
}

async function waitForAny(page, checks, timeoutMs = 30000, intervalMs = 1000) {
  const start = Date.now();
  while (Date.now() - start < timeoutMs) {
    for (const check of checks) {
      if (await check.test()) {
        return check.name;
      }
    }
    await page.waitForTimeout(intervalMs);
  }
  return null;
}

function parseOtpArg() {
  const args = process.argv.slice(2);
  const otpArg = args.find((x) => x.startsWith('--otp='));
  if (!otpArg) {
    return '';
  }
  return otpArg.split('=')[1].replace(/\D/g, '');
}

async function main() {
  await fs.writeFile(LOG_FILE, '', 'utf-8');

  const raw = await fs.readFile(credsPath, 'utf-8');
  const { email, password } = parseCreds(raw);
  const otpFromArg = parseOtpArg();
  if (!email || !password) {
    throw new Error('Missing email/password in Substack.md');
  }

  const browser = await chromium.launch({ headless: false, slowMo: 120 });
  const context = await browser.newContext({
    userAgent:
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
  });
  const page = await context.newPage();

  try {
    await logDecision('start', { mode: 'ui-decision', hasOtpArg: Boolean(otpFromArg) });

    await page.goto('https://substack.com/sign-in', {
      waitUntil: 'networkidle',
      timeout: 60000,
    });
    await snap(page, 'step-00-sign-in-loaded');
    await page.fill('input[type=email]', email);
    await logDecision('email_entered');
    await page.click('button[type=submit]');
    await logDecision('email_submitted');
    await page.waitForTimeout(2500);
    await snap(page, 'step-01-after-email-submit');

    // UI Decision Gate 1: OTP stage should come before password stage.
    const stage1 = await waitForAny(
      page,
      [
        {
          name: 'otp-input-visible',
          test: () => isVisible(page, 'input[type=text], input[inputmode=numeric]'),
        },
        {
          name: 'password-link-visible',
          test: () =>
            isVisible(page, 'a:has-text("sign in using your password")') ||
            isVisible(page, 'button:has-text("sign in using your password")'),
        },
        {
          name: 'throttle-visible',
          test: async () => {
            const body = ((await page.textContent('body')) || '').toLowerCase();
            return body.includes('too many login emails');
          },
        },
      ],
      30000,
      1000,
    );

    await logDecision('stage1_detected', { stage1 });
    await snap(page, `step-02-stage1-${stage1 || 'none'}`);

    if (stage1 === 'throttle-visible') {
      throw new Error('Provider throttle visible after email submit');
    }

    // OTP-first hardening: if OTP is visible, process it first.
    if (stage1 === 'otp-input-visible') {
      const otpCode = otpFromArg || '';
      if (!otpCode) {
        await logDecision('otp_required_no_code');
        throw new Error('OTP field visible but no --otp code provided');
      }

      await page.locator('input[type=text], input[inputmode=numeric]').first().fill(otpCode);
      await logDecision('otp_entered', { digits: otpCode.length });
      await page.click('button[type=submit]');
      await logDecision('otp_submitted');
      await page.waitForTimeout(3000);
      await snap(page, 'step-03-after-otp-submit');
    }

    const pwLink = page
      .locator('a:has-text("sign in using your password")')
      .first();
    const pwVisible = await pwLink.isVisible({ timeout: 4000 }).catch(() => false);
    await logDecision('password_link_visibility', { pwVisible });

    if (pwVisible) {
      await pwLink.click();
      await page.waitForTimeout(1200);
      await snap(page, 'step-04-password-form-visible');
      await page.fill('input[type=password]', password);
      await logDecision('password_entered');
      await page.click('button[type=submit]');
      await logDecision('password_submitted');
    }

    await page.waitForTimeout(10000);
    const body = ((await page.textContent('body')) || '').toLowerCase();
    const url = page.url();
    const otpVisible = await page
      .locator('input[type=text], input[inputmode=numeric]')
      .first()
      .isVisible({ timeout: 1200 })
      .catch(() => false);
    const throttle = body.includes('too many login emails');
    const authed = !url.includes('sign-in') && !throttle;

    await logDecision('final_state', { url, otpVisible, throttle, authed });
    console.log(JSON.stringify({ url, otpVisible, throttle, authed }));

    const cookies = await context.cookies();
    await fs.writeFile(
      path.join(process.cwd(), 'session-cookies.json'),
      JSON.stringify(cookies, null, 2),
      'utf-8',
    );
    await snap(page, 'step-05-final-auth-state');

    if (!authed) {
      await logDecision('hold_for_manual_completion_start', { seconds: 120 });
      console.log('Holding browser open 120s for manual OTP completion.');
      await page.waitForTimeout(120000);
      const body2 = ((await page.textContent('body')) || '').toLowerCase();
      const url2 = page.url();
      const authed2 = !url2.includes('sign-in') && !body2.includes('too many login emails');
      await logDecision('manual_hold_final_state', { url2, authed2 });
      console.log(JSON.stringify({ url2, authed2 }));
      const cookies2 = await context.cookies();
      await fs.writeFile(
        path.join(process.cwd(), 'session-cookies.json'),
        JSON.stringify(cookies2, null, 2),
        'utf-8',
      );
      await snap(page, 'step-06-post-manual-hold');
    }
  } finally {
    await context.close();
    await browser.close();
  }
}

main().catch((e) => {
  console.error('ERR', e.message);
  process.exit(1);
});
