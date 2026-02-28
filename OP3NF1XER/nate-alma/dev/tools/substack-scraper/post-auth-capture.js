#!/usr/bin/env node

import { chromium } from 'playwright';
import fs from 'fs/promises';
import path from 'path';

const PROFILE_DIR = path.join(process.cwd(), 'otp-handoff-profile');
const COOKIES_FILE = path.join(process.cwd(), 'session-cookies.json');
const OUTPUT_DIR = path.join(process.cwd(), '../../memory/substack');
const SUBSTACK_URL = 'https://stochvoltrader.substack.com';

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function toSlug(value) {
  return (value || 'untitled')
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '')
    .slice(0, 60);
}

async function detectAuthenticated(page) {
  const body = ((await page.textContent('body')) || '').toLowerCase();
  return {
    authenticated:
      !page.url().includes('sign-in') &&
      !body.includes('too many login emails') &&
      !body.includes('please enter a valid email'),
    body,
  };
}

async function getArchivePostUrls(page) {
  await page.goto(`${SUBSTACK_URL}/archive`, {
    waitUntil: 'networkidle',
    timeout: 60000,
  });

  let previousHeight = -1;
  let attempts = 0;
  const maxAttempts = 60;

  while (attempts < maxAttempts) {
    const currentHeight = await page.evaluate(() => document.body.scrollHeight);
    if (currentHeight === previousHeight) {
      break;
    }
    previousHeight = currentHeight;
    attempts += 1;
    await page.evaluate(() => window.scrollTo(0, document.body.scrollHeight));
    await sleep(800);
  }

  return page.evaluate((base) => {
    const links = Array.from(document.querySelectorAll('a[href*="/p/"]'));
    const urls = links
      .map((a) => a.href)
      .filter((u) => typeof u === 'string' && u.startsWith(base) && u.includes('/p/'));
    return [...new Set(urls.map((u) => u.split('#')[0]))];
  }, SUBSTACK_URL);
}

async function extractPost(page, url) {
  await page.goto(url, { waitUntil: 'networkidle', timeout: 60000 });
  await sleep(800);

  return page.evaluate(() => {
    const title =
      document.querySelector('h1')?.textContent?.trim() ||
      document.querySelector('meta[property="og:title"]')?.getAttribute('content') ||
      'Untitled';

    const date =
      document.querySelector('time')?.getAttribute('datetime') ||
      document.querySelector('meta[property="article:published_time"]')?.getAttribute('content') ||
      '';

    const subtitle =
      document.querySelector('[class*="subtitle"]')?.textContent?.trim() ||
      document.querySelector('meta[property="og:description"]')?.getAttribute('content') ||
      '';

    const article =
      document.querySelector('article') ||
      document.querySelector('.post-content') ||
      document.querySelector('[class*="body"]');

    const content = article?.textContent?.trim() || '';

    const commentNodes = Array.from(
      document.querySelectorAll('[class*="comment"], [data-testid*="comment"]'),
    );
    const comments = commentNodes
      .map((node) => {
        const author =
          node.querySelector('[class*="author"], [class*="name"]')?.textContent?.trim() || '';
        const text =
          node.querySelector('[class*="body"], [class*="content"], p')?.textContent?.trim() || '';
        const ts =
          node.querySelector('time')?.getAttribute('datetime') ||
          node.querySelector('time')?.textContent?.trim() ||
          '';
        return { author, text, timestamp: ts };
      })
      .filter((x) => x.text);

    return {
      title,
      date,
      subtitle,
      content,
      comments,
      url: window.location.href,
    };
  });
}

async function saveArtifacts(posts) {
  await fs.mkdir(OUTPUT_DIR, { recursive: true });

  for (const post of posts) {
    const datePrefix = (post.date || '').match(/\d{4}-\d{2}-\d{2}/)?.[0] || 'unknown-date';
    const fileName = `${datePrefix}-${toSlug(post.title)}.md`;
    const filePath = path.join(OUTPUT_DIR, fileName);

    const lines = [];
    lines.push(`# ${post.title || 'Untitled'}`);
    lines.push('');
    if (post.subtitle) {
      lines.push(`> ${post.subtitle}`);
      lines.push('');
    }
    lines.push(`**Date:** ${post.date || 'unknown'}`);
    lines.push(`**Source:** ${post.url}`);
    lines.push('');
    lines.push('---');
    lines.push('');
    lines.push(post.content || '');
    lines.push('');
    lines.push('---');
    lines.push('');
    lines.push('## Captured Comments (Raw)');
    lines.push('');
    if (post.comments.length === 0) {
      lines.push('_No comments captured on this page load._');
    } else {
      post.comments.forEach((c, i) => {
        lines.push(`### Comment ${i + 1}`);
        lines.push(`- Author: ${c.author || 'unknown'}`);
        lines.push(`- Timestamp: ${c.timestamp || 'unknown'}`);
        lines.push(`- Text: ${c.text}`);
        lines.push('');
      });
    }

    await fs.writeFile(filePath, `${lines.join('\n')}\n`, 'utf-8');
  }

  await fs.writeFile(
    path.join(OUTPUT_DIR, 'all-posts.json'),
    JSON.stringify(posts, null, 2),
    'utf-8',
  );
}

async function main() {
  const context = await chromium.launchPersistentContext(PROFILE_DIR, {
    headless: true,
    userAgent:
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
  });
  const page = context.pages()[0] || (await context.newPage());

  try {
    await page.goto(SUBSTACK_URL, { waitUntil: 'networkidle', timeout: 60000 });
    const auth = await detectAuthenticated(page);
    await page.screenshot({ path: 'post-auth-state.png', fullPage: true });

    const cookies = await context.cookies();
    await fs.writeFile(COOKIES_FILE, JSON.stringify(cookies, null, 2), 'utf-8');

    if (!auth.authenticated) {
      throw new Error('Session is not authenticated in persistent profile');
    }

    const urls = await getArchivePostUrls(page);
    console.log(`Found ${urls.length} archive post URLs`);
    if (urls.length === 0) {
      throw new Error('No post URLs discovered from archive page');
    }

    const posts = [];
    for (let i = 0; i < urls.length; i += 1) {
      const url = urls[i];
      console.log(`Scraping ${i + 1}/${urls.length}: ${url}`);
      try {
        const post = await extractPost(page, url);
        posts.push(post);
      } catch (err) {
        console.log(`Skip due to extraction error: ${err.message}`);
      }
    }

    await saveArtifacts(posts);
    console.log(`Saved ${posts.length} posts to ${OUTPUT_DIR}`);
  } finally {
    await context.close();
  }
}

main().catch((err) => {
  console.error('Capture failed:', err.message);
  process.exit(1);
});
