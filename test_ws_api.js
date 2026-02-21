#!/usr/bin/env node

/**
 * Test WebSocket API for FireKirin
 * The authoritative source for jackpot values
 */

const GAME_HOST = 'play.firekirin.in';
const GAME_WS = `wss://${GAME_HOST}/ws`;

async function main() {
  console.log('=== FireKirin WebSocket API Test ===\n');
  
  console.log('Connecting to:', GAME_WS);
  
  try {
    const ws = new WebSocket(GAME_WS);
    
    ws.on('open', () => {
      console.log('Connected! Sending QueryBalances...');
      
      // Send QueryBalances request
      ws.send(JSON.stringify({
        action: 'QueryBalances',
        userId: 'test',
        sessionId: Date.now().toString()
      }));
    });
    
    ws.on('message', (data) => {
      console.log('\nReceived:', data.toString());
      ws.close();
    });
    
    ws.on('error', (err) => {
      console.log('Error:', err.message);
    });
    
    ws.on('close', () => {
      console.log('\nClosed');
      process.exit(0);
    });
    
    // Timeout
    setTimeout(() => {
      console.log('Timeout - closing');
      ws.close();
      process.exit(1);
    }, 10000);
    
  } catch (e) {
    console.log('Exception:', e.message);
    process.exit(1);
  }
}

main();
