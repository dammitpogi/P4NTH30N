#!/usr/bin/env node

/**
 * Direct CDP Test - Navigate to game and test jackpot reading
 */

import WebSocket from 'ws';

const CDP_HOST = process.argv[2] || '192.168.56.1';
const CDP_PORT = process.argv[3] || '9222';

async function main() {
  console.log('='.repeat(60));
  console.log('CDP Direct Test - Game Navigation');
  console.log(`Target: ${CDP_HOST}:${CDP_PORT}`);
  console.log('='.repeat(60));

  // Get CDP targets
  const targetsResp = await fetch(`http://${CDP_HOST}:${CDP_PORT}/json/list`);
  const targets = await targetsResp.json();
  
  const page = targets.find(t => t.type === 'page');
  console.log('Current page:', page?.title || 'none');
  console.log('Page URL:', page?.url || 'none');

  if (!page?.webSocketDebuggerUrl) {
    console.log('No page target found');
    process.exit(1);
  }

  // Fix WebSocket URL for remote
  let wsUrl = page.webSocketDebuggerUrl;
  wsUrl = wsUrl.replace(/ws:\/\/localhost:/g, `ws://${CDP_HOST}:`);
  wsUrl = wsUrl.replace(/ws:\/\/127\.0\.0\.1:/g, `ws://${CDP_HOST}:`);
  console.log('WebSocket URL:', wsUrl);

  // Connect to CDP
  console.log('\nConnecting to CDP...');
  const ws = new WebSocket(wsUrl);
  
  let id = 1;
  const pending = new Map();

  ws.on('open', () => {
    console.log('Connected!\n');
    
    // Navigate to FireKirin
    sendCommand('Page.navigate', { url: 'https://play.firekirin.in' });
  });

  ws.on('message', (data) => {
    const msg = JSON.parse(data.toString());
    
    if (msg.id && pending.has(msg.id)) {
      const { resolve, reject } = pending.get(msg.id);
      pending.delete(msg.id);
      if (msg.error) {
        reject(new Error(msg.error.message));
      } else {
        resolve(msg.result);
      }
    } else if (msg.method) {
      console.log('Event:', msg.method);
      if (msg.method === 'Page.loadEventFired') {
        console.log('Page loaded!');
      }
    }
  });

  function sendCommand(method, params = {}) {
    return new Promise((resolve, reject) => {
      const reqId = id++;
      pending.set(reqId, { resolve, reject });
      ws.send(JSON.stringify({ id: reqId, method, params }));
      
      // Timeout
      setTimeout(() => {
        if (pending.has(reqId)) {
          pending.delete(reqId);
          reject(new Error('Timeout'));
        }
      }, 10000);
    });
  }

  // Wait for navigation
  await new Promise(r => setTimeout(r, 3000));

  // Get updated page info
  const newTargetsResp = await fetch(`http://${CDP_HOST}:${CDP_PORT}/json/list`);
  const newTargets = await newTargetsResp.json();
  const newPage = newTargets.find(t => t.type === 'page');
  console.log('\nNew page:', newPage?.title);
  console.log('New URL:', newPage?.url);

  // Test jackpot reading
  console.log('\n--- Testing Jackpot Reading ---');
  
  const testExpressions = [
    '() => window.Grand',
    '() => window.Major',
    '() => window.Minor',
    '() => window.Mini',
    '() => window.jackpot',
    '() => window.game',
    '() => window.Hall',
    '() => document.querySelector(".jackpot")',
    '() => document.querySelector("[class*=jackpot]")',
    '() => document.querySelector("canvas")',
    '() => document.body.innerText.substring(0, 500)',
  ];

  for (const expr of testExpressions) {
    try {
      const result = await sendCommand('Runtime.evaluate', { 
        expression: expr,
        returnByValue: true
      });
      
      const value = result.result?.value;
      if (value !== undefined && value !== null) {
        console.log(`✓ ${expr.substring(4, 40)}: ${String(value).substring(0, 80)}`);
      }
    } catch (e) {
      // Silent fail for probes
    }
  }

  console.log('\n--- Done ---');
  ws.close();
  process.exit(0);
}

main().catch(console.error);
