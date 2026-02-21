#!/usr/bin/env node

/**
 * CDP Jackpot Reader - Quick Test
 */

import WebSocket from 'ws';

const CDP_HOST = '192.168.56.1';
const CDP_PORT = '9222';

async function main() {
  console.log('CDP Jackpot Reader - Quick Test');
  console.log('='.repeat(50));

  // Get current page
  const targets = await (await fetch(`http://${CDP_HOST}:${CDP_PORT}/json/list`)).json();
  const page = targets.find(t => t.type === 'page');
  
  console.log('Page:', page?.title);
  console.log('URL:', page?.url);

  if (!page) {
    console.log('No page found');
    process.exit(1);
  }

  // Fix WebSocket URL
  let wsUrl = page.webSocketDebuggerUrl
    .replace(/ws:\/\/localhost:/g, `ws://${CDP_HOST}:`)
    .replace(/ws:\/\/127\.0\.0\.1:/g, `ws://${CDP_HOST}:`);

  const ws = new WebSocket(wsUrl);
  let id = 1;
  const pending = new Map();

  await new Promise(r => ws.on('open', r));

  function send(method, params = {}) {
    return new Promise((resolve, reject) => {
      const reqId = id++;
      pending.set(reqId, { resolve, reject });
      ws.send(JSON.stringify({ id: reqId, method, params }));
      setTimeout(() => { pending.delete(reqId); reject(new Error('Timeout')); }, 8000);
    });
  }

  console.log('\n--- Reading Jackpot Values ---\n');

  const probes = [
    'window.Grand',
    'window.Major', 
    'window.Minor',
    'window.Mini',
    'window.jackpot',
    'window.jackpots',
    'window.bonus',
    'window.Hall',
    'window.Hall?.grand',
    'window.Hall?.major',
    'window.game',
    'window.game?.jackpot',
    'window.app',
    'window.vm'
  ];

  for (const probe of probes) {
    try {
      const result = await send('Runtime.evaluate', { 
        expression: `(${probe})`,
        returnByValue: true,
        silent: true
      });
      
      const val = result.result?.value;
      if (val !== undefined && val !== null && val !== 'null') {
        const str = JSON.stringify(val).substring(0, 80);
        console.log(`✓ ${probe}: ${str}`);
      }
    } catch (e) {
      // Silent
    }
  }

  // Check DOM
  console.log('\n--- DOM Elements ---\n');
  
  const domProbes = [
    '[class*="jackpot"]',
    '[id*="jackpot"]',
    '.grand',
    '.major', 
    '.minor',
    '.mini',
    'canvas'
  ];

  for (const sel of domProbes) {
    try {
      const result = await send('Runtime.evaluate', { 
        expression: `(() => { const el = document.querySelector('${sel}'); return el ? { exists: true, tag: el.tagName, text: el.textContent?.substring(0,50) } : null; })()`,
        returnByValue: true
      });
      
      const val = result.result?.value;
      if (val?.exists) {
        console.log(`✓ ${sel}: <${val.tag}> "${val.text}"`);
      }
    } catch (e) {
      // Silent
    }
  }

  console.log('\n--- Done ---');
  ws.close();
}

main().catch(console.error);
