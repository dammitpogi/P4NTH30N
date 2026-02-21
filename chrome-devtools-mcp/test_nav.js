#!/usr/bin/env node

import WebSocket from 'ws';

const CDP_HOST = '127.0.0.1';
const CDP_PORT = '9222';

async function main() {
  // Get targets
  const targets = await (await fetch(`http://${CDP_HOST}:${CDP_PORT}/json/list`)).json();
  const browser = targets.find(t => t.type === 'browser');
  
  console.log('Browser:', browser?.id);
  
  // Create new page
  const createResp = await fetch(`http://${CDP_HOST}:${CDP_PORT}/json/create`, {
    method: 'POST',
    body: JSON.stringify({ url: 'http://play.firekirin.in/h5-firekirin/' })
  });
  
  const newPage = await createResp.json();
  console.log('New page:', newPage.id, newPage.url);
  
  // Connect to page
  const wsUrl = newPage.webSocketDebuggerUrl;
  console.log('Connecting to:', wsUrl);
  
  const ws = new WebSocket(wsUrl);
  
  let id = 1;
  
  await new Promise(r => ws.on('open', r));
  console.log('Connected!');
  
  function send(method, params = {}) {
    return new Promise((resolve, reject) => {
      const reqId = id++;
      ws.send(JSON.stringify({ id: reqId, method, params }));
      
      ws.once('message', (data) => {
        const msg = JSON.parse(data.toString());
        if (msg.id === reqId) {
          if (msg.error) reject(new Error(msg.error.message));
          else resolve(msg.result);
        }
      });
      
      setTimeout(() => reject(new Error('Timeout')), 10000);
    });
  }
  
  // Wait for load
  await new Promise(r => setTimeout(r, 5000));
  
  // Read jackpot
  console.log('\n--- Reading jackpot values ---');
  
  const probes = [
    'window.Grand',
    'window.Major',
    'window.Minor',
    'window.Mini',
    'window.jackpot',
    'window.Hall',
    'window.game'
  ];
  
  for (const probe of probes) {
    try {
      const result = await send('Runtime.evaluate', {
        expression: `(${probe})`,
        returnByValue: true
      });
      const val = result.result?.value;
      if (val !== undefined && val !== null) {
        console.log(`✓ ${probe}:`, JSON.stringify(val).substring(0, 100));
      }
    } catch (e) {
      console.log(`✗ ${probe}:`, e.message);
    }
  }
  
  ws.close();
  process.exit(0);
}

main().catch(e => {
  console.error('Error:', e.message);
  process.exit(1);
});
