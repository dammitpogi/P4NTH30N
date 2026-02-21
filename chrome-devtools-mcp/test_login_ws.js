#!/usr/bin/env node

/**
 * FireKirin WebSocket API Test
 * Try to connect and authenticate
 */

import WebSocket from 'ws';

const HOST = '34.213.5.211';
const WS_URL = `ws://${HOST}:8600`;

console.log('=== FireKirin WebSocket API Test ===\n');
console.log('Connecting to:', WS_URL);

const ws = new WebSocket(WS_URL);

ws.on('open', () => {
  console.log('Connected!');

  // Try different authentication methods
  console.log('\nTrying login...');
  
  // Method 1: Login with username/password
  ws.send(JSON.stringify({
    action: 'Login',
    account: 'test',
    password: 'test'
  }));
});

ws.on('message', (data) => {
  const msg = data.toString();
  console.log('\nReceived:', msg);
  
  try {
    const obj = JSON.parse(msg);
    console.log('Parsed:', JSON.stringify(obj, null, 2));
  } catch (e) {
    console.log('Not JSON');
  }
});

ws.on('error', (err) => {
  console.log('\nError:', err.message);
});

ws.on('close', () => {
  console.log('\nClosed');
  process.exit(0);
});

// Timeout
setTimeout(() => {
  console.log('\nTimeout');
  ws.close();
  process.exit(1);
}, 15000);
