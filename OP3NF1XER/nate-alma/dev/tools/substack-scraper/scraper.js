#!/usr/bin/env node
/**
 * Substack Comment Scraper
 * Extracts Alma's comments from stochvoltrader.substack.com
 * Usage: node scraper.js <email> <password> [--reuse-cookies]
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
  
  // Navigate to Substack homepage
  await page.goto(SUBSTACK_URL);
  await delay(DELAY_MS);
  
  // Look for "Sign in" button
  const signInButton = page.locator('text=Sign in').first();
  if (await signInButton.isVisible({ timeout: 5000 })) {
    await signInButton.click();
    await delay(DELAY_MS);
  }
  
  // Fill in email
  await page.fill('input[type="email"]', email);
  await page.click('button:has-text("Continue")');
  await delay(DELAY_MS);
  
  // Fill in password
  await page.fill('input[type="password"]', password);
  await page.click('button:has-text("Sign in")');
  
  // Wait for navigation
  await page.waitForLoadState('networkidle');
  await delay(DELAY_MS);
  
  console.log('✓ Logged in successfully');
}

async function extractComments(page) {
  const comments = [];
  
  // Scroll through comments section
  let previousHeight = 0;
  let scrollAttempts = 0;
  const MAX_SCROLLS = 100; // Adjust based on how many comments exist
  
  while (scrollAttempts < MAX_SCROLLS) {
    // Get current scroll height
    const currentHeight = await page.evaluate(() => document.body.scrollHeight);
    
    if (currentHeight === previousHeight) {
      // No more content loaded
      break;
    }
    
    // Scroll down
    await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));
    await delay(DELAY_MS);
    
    previousHeight = currentHeight;
    scrollAttempts++;
    
    console.log(`Scrolling... (${scrollAttempts}/${MAX_SCROLLS})`);
  }
  
  // Extract all comments from Alma
  const almaComments = await page.evaluate(() => {
    const comments = [];
    
    // Substack comment selectors (may need adjustment based on actual structure)
    const commentElements = document.querySelectorAll('[class*="comment"]');
    
    commentElements.forEach(comment => {
      // Look for author name
      const authorElement = comment.querySelector('[class*="author"], [class*="name"]');
      const author = authorElement?.textContent?.trim() || '';
      
      // Check if it's from Alma (case-insensitive, flexible matching)
      if (author.toLowerCase().includes('alma')) {
        const contentElement = comment.querySelector('[class*="body"], [class*="content"], p');
        const content = contentElement?.textContent?.trim() || '';
        
        const timestampElement = comment.querySelector('[class*="timestamp"], time');
        const timestamp = timestampElement?.textContent?.trim() || 
                         timestampElement?.getAttribute('datetime') || '';
        
        if (content) {
          comments.push({
            author,
            content,
            timestamp,
            html: comment.innerHTML
          });
        }
      }
    });
    
    return comments;
  });
  
  return almaComments;
}

async function saveComments(comments) {
  // Ensure output directory exists
  await fs.mkdir(OUTPUT_DIR, { recursive: true });
  
  // Group comments by date (if we have timestamps)
  const grouped = {};
  
  comments.forEach((comment, idx) => {
    // Extract date from timestamp or use index
    const dateMatch = comment.timestamp.match(/\d{4}-\d{2}-\d{2}/);
    const date = dateMatch ? dateMatch[0] : `batch-${Math.floor(idx / 50)}`;
    
    if (!grouped[date]) {
      grouped[date] = [];
    }
    grouped[date].push(comment);
  });
  
  // Save each group to a markdown file
  for (const [date, commentGroup] of Object.entries(grouped)) {
    const filename = path.join(OUTPUT_DIR, `${date}-alma-comments.md`);
    
    let markdown = `# Alma's Comments - ${date}\n\n`;
    markdown += `> Extracted from ${SUBSTACK_URL}\n`;
    markdown += `> Total comments: ${commentGroup.length}\n\n`;
    markdown += `---\n\n`;
    
    commentGroup.forEach((comment, idx) => {
      markdown += `## Comment ${idx + 1}\n\n`;
      markdown += `**Timestamp:** ${comment.timestamp}\n\n`;
      markdown += `${comment.content}\n\n`;
      markdown += `---\n\n`;
    });
    
    await fs.writeFile(filename, markdown);
    console.log(`✓ Saved ${commentGroup.length} comments to ${filename}`);
  }
  
  // Also save raw JSON
  const jsonFile = path.join(OUTPUT_DIR, 'all-comments.json');
  await fs.writeFile(jsonFile, JSON.stringify(comments, null, 2));
  console.log(`✓ Saved raw data to ${jsonFile}`);
}

async function scrapeSubstack(email, password, reuseCookies = false) {
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext();
  const page = await context.newPage();
  
  try {
    // Try to reuse cookies if available
    let needsLogin = true;
    if (reuseCookies) {
      needsLogin = !(await loadCookies(context));
    }
    
    // Login if needed
    if (needsLogin) {
      await login(page, email, password);
      await saveCookies(context);
    } else {
      // Just verify we're logged in
      await page.goto(SUBSTACK_URL);
      await delay(DELAY_MS);
    }
    
    // Navigate to posts/comments
    console.log('Navigating to posts...');
    
    // Get all post links
    const postLinks = await page.evaluate(() => {
      const links = Array.from(document.querySelectorAll('a[href*="/p/"]'));
      return links.map(a => a.href).filter(href => href.includes('/p/'));
    });
    
    console.log(`Found ${postLinks.length} posts`);
    
    let allComments = [];
    
    // Visit each post and extract Alma's comments
    for (let i = 0; i < postLinks.length; i++) {
      const postUrl = postLinks[i];
      console.log(`\nScraping post ${i + 1}/${postLinks.length}: ${postUrl}`);
      
      await page.goto(postUrl);
      await delay(DELAY_MS);
      
      const comments = await extractComments(page);
      console.log(`  Found ${comments.length} comments from Alma`);
      
      allComments = allComments.concat(comments);
    }
    
    console.log(`\nTotal comments extracted: ${allComments.length}`);
    
    if (allComments.length > 0) {
      await saveComments(allComments);
    } else {
      console.log('⚠ No comments found. The page selectors may need adjustment.');
    }
    
  } finally {
    await browser.close();
  }
}

// CLI entry point
const args = process.argv.slice(2);

if (args.length < 2) {
  console.error('Usage: node scraper.js <email> <password> [--reuse-cookies]');
  process.exit(1);
}

const [email, password] = args;
const reuseCookies = args.includes('--reuse-cookies');

scrapeSubstack(email, password, reuseCookies)
  .then(() => {
    console.log('\n✓ Scraping complete!');
    process.exit(0);
  })
  .catch(err => {
    console.error('\n✗ Error:', err.message);
    process.exit(1);
  });
