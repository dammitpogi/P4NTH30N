#!/usr/bin/env node

/**
 * CDP Jackpot Value Reader
 */

import WebSocket from 'ws';

const CDP_HOST = process.argv[2] || '192.168.56.1';
const CDP_PORT = process.argv[3] || '9222';

async function main() {
  console.log('='.repeat(60));
  console.log('CDP Jackpot Reader');
  console.log(`Target: ${CDP_HOST}:${CDP_PORT}`);
  console.log('='.repeat(60));

  // Get CDP targets
  const targetsResp = await fetch(`http://${CDP_HOST}:${CDP_PORT}/json/list`);
  const targets = await targetsResp.json();
  const page = targets.find(t => t.type === 'page');

  if (!page?.webSocketDebuggerUrl) {
    console.log('No page target found');
    process.exit(1);
  }

  // Fix WebSocket URL
  let wsUrl = page.webSocketDebuggerUrl;
  wsUrl = wsUrl.replace(/ws:\/\/localhost:/g, `ws://${CDP_HOST}:`);
  wsUrl = wsUrl.replace(/ws:\/\/127\.0\.0\.1:/g, `ws://${CDP_HOST}:`);

  const ws = new WebSocket(wsUrl);
  let id = 1;
  const pending = new Map();

  await new Promise(resolve => ws.on('open', resolve));

  function sendCommand(method, params = {}) {
    return new Promise((resolve, reject) => {
      const reqId = id++;
      pending.set(reqId, { resolve, reject });
      ws.send(JSON.stringify({ id: reqId, method, params }));
      setTimeout(() => {
        if (pending.has(reqId)) { pending.delete(reqId); reject(new Error('Timeout')); }
      }, 10000);
    });
  }

  // First, navigate to FireKirin
  console.log('\nNavigating to FireKirin...');
  await sendCommand('Page.navigate', { url: 'https://play.firekirin.in' });
  await new Promise(r => setTimeout(r, 5000));

  // Check page state
  const newTargets = await (await fetch(`http://${CDP_HOST}:${CDP_PORT}/json/list`)).json();
  const currPage = newTargets.find(t => t.type === 'page');
  console.log('Page title:', currPage?.title);
  console.log('Page URL:', currPage?.url);

  // Bypass SSL error by clicking "Proceed" if possible
  console.log('\n--- Attempting to handle SSL error ---');
  
  // Try to get page content
  console.log('\n--- Reading Jackpot Values ---');
  
  // Direct value reads
  const probes = [
    { name: 'window.Grand', expr: 'window.Grand' },
    { name: 'window.Major', expr: 'window.Major' },
    { name: 'window.Minor', expr: 'window.Minor' },
    { name: 'window.Mini', expr: 'window.Mini' },
    { name: 'window.jackpot', expr: 'window.jackpot' },
    { name: 'window.jackpots', expr: 'window.jackpots' },
    { name: 'window.bonus', expr: 'window.bonus' },
    { name: 'Hall.grand', expr: 'window.Hall?.grand' },
    { name: 'Hall.major', expr: 'window.Hall?.major' },
    { name: 'game.jackpot', expr: 'window.game?.jackpot' },
    { name: 'game.jackpots', expr: 'window.game?.jackpots' },
  ];

  for (const probe of probes) {
    try {
      const result = await sendCommand('Runtime.evaluate', { 
        expression: `(${probe.expr})`,
        returnByValue: true
      });
      
      const value = result.result?.value;
      if (value !== undefined && value !== null) {
        console.log(`✓ ${probe.name}: ${JSON.stringify(value).substring(0, 100)}`);
      } else {
        console.log(`  ${probe.name}: undefined/null`);
      }
    } catch (e) {
      console.log(`✗ ${probe.name}: Error`);
    }
  }

  // Try WebSocket API as backup
  console.log('\n--- Testing WebSocket API (Authoritative Source) ---');
  
  try {
    // FireKirin WebSocket API
    const wsApi = new WebSocket('wss://play.firekirin.in/ws');
    
    await new Promise((resolve, reject) => {
      wsApi.on('open', resolve);
      wsApi.on('error', reject);
      setTimeout(() => reject(new Error('Timeout')), 5000);
    });

    // Send QueryBalances
    wsApi.send(JSON.stringify({ action: 'QueryBalances', sessionId: 'test' }));
    
    const response = await new Promise((resolve, reject) => {
      wsApi.on('message', data => resolve(JSON.parse(data.toString())));
      setTimeout(() => reject(new Error('Timeout')), 5000);
    });
    
    console.log('WebSocket API Response:', JSON.stringify(response, null, 2).substring(0, 500));
    wsApi.close();
  } catch (e) {
    console.log('WebSocket API Error:', e.message);
  }

  console.log('\n--- Done ---');
  ws.close();
  process.exit(0);
}

main().catch(console.error);
