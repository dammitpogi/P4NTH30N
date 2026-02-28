import { chromium } from 'playwright';
import fs from 'fs';

async function run() {
  const email = 'natehansen@me.com';
  const password = '28Moresubstack';

  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({ userAgent: 'Mozilla/5.0' });
  const page = await context.newPage();

  try {
    await page.goto('https://substack.com/sign-in', {
      waitUntil: 'networkidle',
      timeout: 60000,
    });

    await page.fill('input[type=email]', email);
    await page.evaluate(() => {
      const isVisible = (e) => {
        const s = getComputedStyle(e);
        const r = e.getBoundingClientRect();
        return s.display !== 'none' && s.visibility !== 'hidden' &&
          r.width > 0 && r.height > 0;
      };
      const btn = [...document.querySelectorAll('button')].find((b) =>
        isVisible(b) && ((b.type || '').toLowerCase() === 'submit' ||
          (b.textContent || '').toLowerCase().includes('continue')),
      );
      if (btn) btn.click();
    });

    await page.waitForTimeout(4000);

    const pwLink = page
      .locator('a:has-text("sign in using your password")')
      .first();
    const pwLinkVisible = await pwLink
      .isVisible({ timeout: 4000 })
      .catch(() => false);
    console.log('pwLinkVisible', pwLinkVisible);

    if (pwLinkVisible) {
      await pwLink.click();
      await page.waitForTimeout(1500);
      await page.fill('input[type=password]', password);
      await page.evaluate(() => {
        const isVisible = (e) => {
          const s = getComputedStyle(e);
          const r = e.getBoundingClientRect();
          return s.display !== 'none' && s.visibility !== 'hidden' &&
            r.width > 0 && r.height > 0;
        };
        const btn = [...document.querySelectorAll('button')].find((b) =>
          isVisible(b) && ((b.type || '').toLowerCase() === 'submit' ||
            (b.textContent || '').toLowerCase().includes('sign in')),
        );
        if (btn) btn.click();
      });
      await page.waitForTimeout(7000);
    }

    const url = page.url();
    const body = ((await page.textContent('body')) || '').toLowerCase();
    const authed = !url.includes('sign-in') &&
      !body.includes('invalid email or password') &&
      !body.includes('too many login emails');

    const cookies = await context.cookies();
    fs.writeFileSync('session-cookies.json', JSON.stringify(cookies, null, 2));

    console.log(
      JSON.stringify({
        authed,
        url,
        cookieCount: cookies.length,
        hasThrottle: body.includes('too many login emails'),
      }),
    );

    await page.goto('https://stochvoltrader.substack.com/archive', {
      waitUntil: 'networkidle',
      timeout: 60000,
    });
    await page.screenshot({ path: 'post-password-auth-attempt.png', fullPage: true });
  } catch (e) {
    console.error('ERR', e.message);
    process.exitCode = 1;
  } finally {
    await browser.close();
  }
}

run();
