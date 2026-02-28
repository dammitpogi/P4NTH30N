#!/usr/bin/env node
/**
 * Debug Substack login flow - capture screenshots and HTML at each step
 */

import { chromium } from 'playwright';
import fs from 'fs/promises';

const DELAY_MS = 3000;
const delay = ms => new Promise(resolve => setTimeout(resolve, ms));

async function debugLogin(email, password) {
  const browser = await chromium.launch({ 
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });
  
  const context = await browser.newContext({
    userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
  });
  
  const page = await context.newPage();
  
  try {
    console.log('Step 1: Navigate to sign-in page');
    await page.goto('https://substack.com/sign-in', { waitUntil: 'networkidle', timeout: 30000 });
    await delay(DELAY_MS);
    
    // Screenshot 1
    await page.screenshot({ path: '/tmp/login-step1.png', fullPage: true });
    const html1 = await page.content();
    await fs.writeFile('/tmp/login-step1.html', html1);
    console.log('✓ Saved step1 screenshot and HTML');
    
    // Check what input fields exist
    const inputs = await page.evaluate(() => {
      const allInputs = Array.from(document.querySelectorAll('input'));
      return allInputs.map(input => ({
        type: input.type,
        name: input.name,
        placeholder: input.placeholder,
        id: input.id,
        className: input.className
      }));
    });
    console.log('Available inputs:', JSON.stringify(inputs, null, 2));
    
    // Check what buttons exist
    const buttons = await page.evaluate(() => {
      const allButtons = Array.from(document.querySelectorAll('button'));
      return allButtons.map(btn => ({
        text: btn.textContent?.trim().slice(0, 50),
        type: btn.type,
        className: btn.className
      }));
    });
    console.log('Available buttons:', JSON.stringify(buttons, null, 2));
    
    console.log('\nStep 2: Fill email field');
    // Try to find and fill email
    const emailInput = await page.locator('input[type="email"]').first();
    if (await emailInput.isVisible({ timeout: 5000 })) {
      await emailInput.fill(email);
      console.log('✓ Filled email');
      
      await page.screenshot({ path: '/tmp/login-step2.png', fullPage: true });
      console.log('✓ Saved step2 screenshot');
      
      // Find and click submit button
      console.log('\nStep 3: Click continue/submit');
      const submitBtn = page.locator('button[type="submit"]').first();
      await submitBtn.click();
      console.log('✓ Clicked submit');
      
      await delay(DELAY_MS);
      await page.screenshot({ path: '/tmp/login-step3.png', fullPage: true });
      const html3 = await page.content();
      await fs.writeFile('/tmp/login-step3.html', html3);
      console.log('✓ Saved step3 screenshot and HTML');
      
      // Check what's on the page now
      const inputs2 = await page.evaluate(() => {
        const allInputs = Array.from(document.querySelectorAll('input'));
        return allInputs.map(input => ({
          type: input.type,
          name: input.name,
          placeholder: input.placeholder,
          visible: input.offsetParent !== null
        }));
      });
      console.log('Available inputs after email submit:', JSON.stringify(inputs2, null, 2));
      
      // Check for password field
      const passwordInput = page.locator('input[type="password"]');
      const passwordVisible = await passwordInput.isVisible({ timeout: 5000 }).catch(() => false);
      
      if (passwordVisible) {
        console.log('\nStep 4: Password field found, filling it');
        await passwordInput.fill(password);
        await page.screenshot({ path: '/tmp/login-step4.png', fullPage: true });
        
        const loginBtn = page.locator('button[type="submit"]').first();
        await loginBtn.click();
        console.log('✓ Clicked login button');
        
        await delay(DELAY_MS);
        await page.screenshot({ path: '/tmp/login-step5.png', fullPage: true });
        console.log('✓ Saved final screenshot');
        
        console.log('\n✓ Login flow completed');
      } else {
        console.log('\n⚠ No password field found - might use magic link or different flow');
        console.log('Check the HTML in /tmp/login-step3.html to see what happened');
      }
      
    } else {
      console.log('✗ Email input not found');
    }
    
  } catch (err) {
    console.error('Error:', err.message);
    await page.screenshot({ path: '/tmp/login-error.png', fullPage: true });
    console.log('Saved error screenshot to /tmp/login-error.png');
  } finally {
    await browser.close();
    console.log('\nScreenshots and HTML saved to /tmp/login-step*.png and /tmp/login-step*.html');
    console.log('Review them to see the actual login flow.');
  }
}

const [email, password] = process.argv.slice(2);
if (!email || !password) {
  console.error('Usage: node debug-login.js <email> <password>');
  process.exit(1);
}

debugLogin(email, password);
