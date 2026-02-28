#!/usr/bin/env node
/**
 * Interactive Substack Post Scraper - prompts for email verification code
 */

import { chromium } from 'playwright';
import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';
import readline from 'readline';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const COOKIES_FILE = path.join(__dirname, 'session-cookies.json');
const OUTPUT_DIR = path.join(__dirname, '../../memory/substack');
const SUBSTACK_URL = 'https://stochvoltrader.substack.com';

const DELAY_MS = 2000;
const delay = ms => new Promise(resolve => setTimeout(resolve, ms));

function askQuestion(query) {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });

  return new Promise(resolve => rl.question(query, ans => {
    rl.close();
    resolve(ans);
  }));
}

async function saveCookies(context) {
  const cookies = await context.cookies();
  await fs.writeFile(COOKIES_FILE, JSON.stringify(cookies, null, 2));
  console.log(`✓ Saved ${cookies.length} cookies to ${COOKIES_FILE}`);
}

async function loadCookies(context) {
  try {
    const cookiesData = await fs.readFile(COOKIES_FILE, 'utf-8');
    const cookies = JSON.parse(cookiesData);
    await context.addCookies(cookies);
    console.log(`✓ Loaded ${cookies.length} cookies from ${COOKIES_FILE}`);
    return true;
  } catch (err) {
    console.log('No saved cookies found, will need to login');
    return false;
  }
}

async function login(page, email, password) {
  console.log('Logging in to Substack...');
  
  try {
    await page.goto('https://substack.com/sign-in', { waitUntil: 'networkidle', timeout: 30000 });
    await delay(DELAY_MS);
    
    console.log('  Entering email...');
    await page.fill('input[type="email"]', email);
    await page.click('button[type="submit"]');
    await delay(DELAY_MS * 2);
    
    // Check if we're on the "check your email" page or password page
    const currentUrl = page.url();
    const pageText = await page.textContent('body');
    
    if (pageText.includes('Check your email')) {
      console.log('\n📧 Substack sent a verification code to your email.');
      console.log('Check your email and enter the code below.\n');
      
      const code = await askQuestion('Enter verification code: ');
      
      // Look for code input field
      const codeInput = page.locator('input[type="text"], input[inputmode="numeric"]').first();
      await codeInput.fill(code.trim());
      
      // Click submit/continue
      await page.click('button[type="submit"]');
      await delay(DELAY_MS);
      
    } else if (pageText.includes('sign in using your password')) {
      // Password-based login
      console.log('  Clicking "sign in using your password"...');
      await page.click('a:has-text("sign in using your password")');
      await delay(DELAY_MS);
      
      console.log('  Entering password...');
      await page.fill('input[type="password"]', password);
      await page.click('button[type="submit"]');
      await delay(DELAY_MS * 2);
    }
    
    // Check if login succeeded
    const finalUrl = page.url();
    if (finalUrl.includes('sign-in')) {
      const errorText = await page.evaluate(() => {
        const errors = Array.from(document.querySelectorAll('[class*="error"]'));
        return errors.map(el => el.textContent.trim()).join(' ');
      });
      throw new Error(errorText || 'Login failed - still on sign-in page');
    }
    
    console.log('✓ Logged in successfully\n');
    
  } catch (err) {
    await page.screenshot({ path: '/tmp/login-error.png', fullPage: true }).catch(() => {});
    throw new Error(`Login failed: ${err.message}`);
  }
}

async function getAllPostUrls(page) {
  console.log('Finding all posts...');
  
  await page.goto(`${SUBSTACK_URL}/archive`, { waitUntil: 'networkidle', timeout: 30000 });
  await delay(DELAY_MS);
  
  // Scroll to load all posts
  let previousHeight = 0;
  let scrollAttempts = 0;
  const MAX_SCROLLS = 50;
  
  while (scrollAttempts < MAX_SCROLLS) {
    const currentHeight = await page.evaluate(() => document.body.scrollHeight);
    
    if (currentHeight === previousHeight) {
      break;
    }
    
    await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));
    await delay(1000);
    
    previousHeight = currentHeight;
    scrollAttempts++;
    
    if (scrollAttempts % 10 === 0) {
      console.log(`  Scrolling... (${scrollAttempts}/${MAX_SCROLLS})`);
    }
  }
  
  const postUrls = await page.evaluate((baseUrl) => {
    const links = Array.from(document.querySelectorAll('a[href*="/p/"]'));
    const urls = [...new Set(links.map(a => a.href))];
    return urls.filter(url => url.startsWith(baseUrl) && url.includes('/p/'));
  }, SUBSTACK_URL);
  
  console.log(`✓ Found ${postUrls.length} posts\n`);
  return postUrls;
}

async function extractPostContent(page, url) {
  try {
    await page.goto(url, { waitUntil: 'networkidle', timeout: 30000 });
    await delay(DELAY_MS);
    
    const post = await page.evaluate(() => {
      const titleElement = document.querySelector('h1.post-title, h1[class*="title"]');
      const title = titleElement?.textContent?.trim() || 'Untitled';
      
      const dateElement = document.querySelector('time, [class*="date"]');
      const date = dateElement?.getAttribute('datetime') || 
                   dateElement?.textContent?.trim() || '';
      
      const subtitleElement = document.querySelector('.subtitle, [class*="subtitle"]');
      const subtitle = subtitleElement?.textContent?.trim() || '';
      
      const contentElement = document.querySelector('.body, .post-content, [class*="body"], article');
      const content = contentElement?.textContent?.trim() || '';
      
      return {
        title,
        subtitle,
        date,
        content,
        url: window.location.href
      };
    });
    
    return post;
  } catch (err) {
    console.error(`  Error extracting ${url}:`, err.message);
    return null;
  }
}

async function savePosts(posts) {
  await fs.mkdir(OUTPUT_DIR, { recursive: true });
  
  console.log(`\nSaving ${posts.length} posts...`);
  
  for (const post of posts) {
    if (!post) continue;
    
    let dateStr = 'unknown';
    if (post.date) {
      const dateMatch = post.date.match(/\d{4}-\d{2}-\d{2}/);
      dateStr = dateMatch ? dateMatch[0] : post.date.slice(0, 10);
    }
    
    const titleSlug = post.title
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-|-$/g, '')
      .slice(0, 50);
    
    const filename = path.join(OUTPUT_DIR, `${dateStr}-${titleSlug}.md`);
    
    let markdown = `# ${post.title}\n\n`;
    if (post.subtitle) {
      markdown += `> ${post.subtitle}\n\n`;
    }
    markdown += `**Date:** ${post.date}\n\n`;
    markdown += `**Source:** ${post.url}\n\n`;
    markdown += `---\n\n`;
    markdown += post.content;
    markdown += `\n\n---\n\n`;
    markdown += `*Extracted from Alma's Substack: ${SUBSTACK_URL}*\n`;
    
    await fs.writeFile(filename, markdown);
  }
  
  const jsonFile = path.join(OUTPUT_DIR, 'all-posts.json');
  await fs.writeFile(jsonFile, JSON.stringify(posts, null, 2));
  
  console.log(`✓ Saved ${posts.length} posts to ${OUTPUT_DIR}`);
  console.log(`✓ JSON backup: ${jsonFile}`);
}

async function scrapeSubstack(email, password, reuseCookies = false) {
  const browser = await chromium.launch({ 
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });
  
  const context = await browser.newContext({
    userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
  });
  
  const page = await context.newPage();
  
  try {
    let needsLogin = true;
    
    if (reuseCookies) {
      const loaded = await loadCookies(context);
      if (loaded) {
        await page.goto(SUBSTACK_URL);
        await delay(DELAY_MS);
        
        const isLoggedIn = await page.evaluate(() => {
          return !!document.querySelector('[href*="sign-out"], [class*="user-menu"]');
        });
        
        if (isLoggedIn) {
          console.log('✓ Session still valid\n');
          needsLogin = false;
        } else {
          console.log('Session expired, logging in again...\n');
        }
      }
    }
    
    if (needsLogin) {
      await login(page, email, password);
      await saveCookies(context);
    }
    
    const postUrls = await getAllPostUrls(page);
    
    if (postUrls.length === 0) {
      console.log('⚠ No posts found.');
      return;
    }
    
    const posts = [];
    for (let i = 0; i < postUrls.length; i++) {
      const url = postUrls[i];
      console.log(`Scraping post ${i + 1}/${postUrls.length}`);
      console.log(`  ${url}`);
      
      const post = await extractPostContent(page, url);
      if (post) {
        posts.push(post);
        console.log(`  ✓ "${post.title}" (${post.date})\n`);
      }
    }
    
    console.log(`\n✓ Extracted ${posts.length} posts`);
    
    if (posts.length > 0) {
      await savePosts(posts);
    }
    
  } catch (err) {
    console.error('\n✗ Fatal error:', err.message);
    throw err;
  } finally {
    await browser.close();
  }
}

// CLI entry point
const args = process.argv.slice(2);

if (args.length < 2) {
  console.error('Usage: node scrape-interactive.js <email> <password> [--reuse-cookies]');
  process.exit(1);
}

const [email, password] = args;
const reuseCookies = args.includes('--reuse-cookies');

console.log('=== Interactive Substack Post Scraper ===\n');
console.log(`Target: ${SUBSTACK_URL}`);
console.log(`Output: ${OUTPUT_DIR}\n`);

scrapeSubstack(email, password, reuseCookies)
  .then(() => {
    console.log('\n✓ Scraping complete!');
    console.log(`\nAll posts saved to ${OUTPUT_DIR}`);
    console.log('You can now search these with memory_search');
    process.exit(0);
  })
  .catch(err => {
    console.error('\n✗ Scraping failed:', err.message);
    process.exit(1);
  });
