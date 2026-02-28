#!/usr/bin/env node
/**
 * Substack Post Scraper
 * Extracts all posts (articles, analysis) from stochvoltrader.substack.com
 * Usage: node scrape-posts.js <email> <password> [--reuse-cookies]
 */

import { chromium } from 'playwright';
import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const COOKIES_FILE = path.join(__dirname, 'session-cookies.json');
const OUTPUT_DIR = path.join(__dirname, '../../memory/substack');
const SUBSTACK_URL = 'https://stochvoltrader.substack.com';

// Rate limiting
const DELAY_MS = 2000; // 2 seconds between requests
const delay = ms => new Promise(resolve => setTimeout(resolve, ms));

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
    // Navigate directly to sign-in page
    await page.goto('https://substack.com/sign-in', { waitUntil: 'networkidle', timeout: 30000 });
    await delay(DELAY_MS);
    
    // Fill in email
    console.log('  Entering email...');
    await page.waitForSelector('input[type="email"]', { timeout: 10000 });
    await page.fill('input[type="email"]', email);
    
    // Click continue/next
    console.log('  Clicking continue...');
    await page.click('button[type="submit"]');
    await delay(DELAY_MS * 2); // Wait longer for magic link page
    
    // Look for "sign in using your password" link
    console.log('  Looking for password login option...');
    const passwordLink = page.locator('a:has-text("sign in using your password")');
    const linkVisible = await passwordLink.isVisible({ timeout: 5000 }).catch(() => false);
    
    if (linkVisible) {
      console.log('  Clicking "sign in using your password"...');
      await passwordLink.click();
      await delay(DELAY_MS);
    }
    
    // Fill in password
    console.log('  Entering password...');
    await page.waitForSelector('input[type="password"]', { timeout: 10000 });
    await page.fill('input[type="password"]', password);
    
    // Click sign in
    console.log('  Signing in...');
    await page.click('button[type="submit"]');
    await delay(DELAY_MS * 2);
    
    // Check current URL and page state
    const currentUrl = page.url();
    console.log(`  Current URL: ${currentUrl}`);
    
    // Take a screenshot for debugging
    await page.screenshot({ path: '/tmp/after-login.png', fullPage: true });
    console.log('  Screenshot saved to /tmp/after-login.png');
    
    // Check if we're still on sign-in page (login failed)
    if (currentUrl.includes('sign-in')) {
      // Look for error messages
      const errorText = await page.evaluate(() => {
        const errors = Array.from(document.querySelectorAll('[class*="error"], [class*="alert"]'));
        return errors.map(el => el.textContent.trim()).join(' | ');
      });
      
      if (errorText) {
        throw new Error(`Login failed: ${errorText}`);
      } else {
        throw new Error('Login failed: still on sign-in page');
      }
    }
    
    console.log('✓ Logged in successfully');
  } catch (err) {
    console.error('Login failed:', err.message);
    // Save error screenshot
    await page.screenshot({ path: '/tmp/login-error.png', fullPage: true }).catch(() => {});
    throw err;
  }
}

async function getAllPostUrls(page) {
  console.log('Finding all posts...');
  
  await page.goto(`${SUBSTACK_URL}/archive`, { waitUntil: 'networkidle', timeout: 30000 });
  await delay(DELAY_MS);
  
  // Scroll to load all posts in archive
  let previousHeight = 0;
  let scrollAttempts = 0;
  const MAX_SCROLLS = 50;
  
  while (scrollAttempts < MAX_SCROLLS) {
    const currentHeight = await page.evaluate(() => document.body.scrollHeight);
    
    if (currentHeight === previousHeight) {
      break;
    }
    
    await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));
    await delay(1000); // Shorter delay for scrolling
    
    previousHeight = currentHeight;
    scrollAttempts++;
    
    if (scrollAttempts % 10 === 0) {
      console.log(`  Scrolling archive... (${scrollAttempts}/${MAX_SCROLLS})`);
    }
  }
  
  // Extract all post URLs
  const postUrls = await page.evaluate((baseUrl) => {
    const links = Array.from(document.querySelectorAll('a[href*="/p/"]'));
    const urls = [...new Set(links.map(a => a.href))]; // Deduplicate
    return urls.filter(url => url.startsWith(baseUrl) && url.includes('/p/'));
  }, SUBSTACK_URL);
  
  console.log(`✓ Found ${postUrls.length} posts`);
  return postUrls;
}

async function extractPostContent(page, url) {
  try {
    await page.goto(url, { waitUntil: 'networkidle', timeout: 30000 });
    await delay(DELAY_MS);
    
    const post = await page.evaluate(() => {
      // Extract title
      const titleElement = document.querySelector('h1.post-title, h1[class*="title"]');
      const title = titleElement?.textContent?.trim() || 'Untitled';
      
      // Extract date
      const dateElement = document.querySelector('time, [class*="date"]');
      const date = dateElement?.getAttribute('datetime') || 
                   dateElement?.textContent?.trim() || '';
      
      // Extract subtitle/description
      const subtitleElement = document.querySelector('.subtitle, [class*="subtitle"]');
      const subtitle = subtitleElement?.textContent?.trim() || '';
      
      // Extract main content
      const contentElement = document.querySelector('.body, .post-content, [class*="body"], article');
      const content = contentElement?.textContent?.trim() || '';
      
      // Get full HTML for backup
      const htmlContent = contentElement?.innerHTML || '';
      
      return {
        title,
        subtitle,
        date,
        content,
        htmlContent,
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
  // Ensure output directory exists
  await fs.mkdir(OUTPUT_DIR, { recursive: true });
  
  console.log(`\nSaving ${posts.length} posts...`);
  
  // Save each post as individual markdown file
  for (const post of posts) {
    if (!post) continue;
    
    // Generate filename from date and title
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
  
  // Save full dataset as JSON
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
    // Try to reuse cookies if available
    let needsLogin = true;
    if (reuseCookies) {
      const loaded = await loadCookies(context);
      if (loaded) {
        // Verify cookies still work
        await page.goto(SUBSTACK_URL);
        await delay(DELAY_MS);
        
        const isLoggedIn = await page.evaluate(() => {
          // Check for sign-out button or user menu
          return !!document.querySelector('[href*="sign-out"], [class*="user-menu"]');
        });
        
        if (isLoggedIn) {
          console.log('✓ Session still valid');
          needsLogin = false;
        } else {
          console.log('Session expired, logging in again...');
        }
      }
    }
    
    // Login if needed
    if (needsLogin) {
      await login(page, email, password);
      await saveCookies(context);
    }
    
    // Get all post URLs
    const postUrls = await getAllPostUrls(page);
    
    if (postUrls.length === 0) {
      console.log('⚠ No posts found. Check if the selectors need adjustment.');
      return;
    }
    
    // Extract content from each post
    const posts = [];
    for (let i = 0; i < postUrls.length; i++) {
      const url = postUrls[i];
      console.log(`\nScraping post ${i + 1}/${postUrls.length}`);
      console.log(`  ${url}`);
      
      const post = await extractPostContent(page, url);
      if (post) {
        posts.push(post);
        console.log(`  ✓ "${post.title}" (${post.date})`);
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
  console.error('Usage: node scrape-posts.js <email> <password> [--reuse-cookies]');
  process.exit(1);
}

const [email, password] = args;
const reuseCookies = args.includes('--reuse-cookies');

console.log('=== Substack Post Scraper ===\n');
console.log(`Target: ${SUBSTACK_URL}`);
console.log(`Output: ${OUTPUT_DIR}\n`);

scrapeSubstack(email, password, reuseCookies)
  .then(() => {
    console.log('\n✓ Scraping complete!');
    console.log(`\nYou can now search these posts with memory_search`);
    process.exit(0);
  })
  .catch(err => {
    console.error('\n✗ Scraping failed:', err.message);
    process.exit(1);
  });
