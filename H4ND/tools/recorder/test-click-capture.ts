#!/usr/bin/env bun
/**
 * Minimal click capture test — isolates CDP mousedown detection
 */
import { CdpClient, sleep } from './cdp-client';

async function main() {
  console.log('Connecting to Chrome CDP...');
  const cdp = new CdpClient('127.0.0.1', 9222);
  await cdp.connect();
  console.log('Connected.\n');

  // Step 1: Check what page we're on
  const url = await cdp.evaluate<string>('window.location.href');
  console.log(`Current page: ${url}`);

  // Step 2: Inject mousedown listener (same code as runner)
  console.log('\nInjecting mousedown listener...');
  await cdp.evaluate(`
    window.__clickResult = null;
    window.__clickHandler = function(e) {
      var el = e.target;
      var text = '';
      try { text = (el.innerText || el.textContent || '').trim().slice(0, 50); } catch(ex) {}
      var tag = el.tagName ? el.tagName.toLowerCase() : '';
      var id = el.id ? '#' + el.id : '';
      window.__clickResult = {
        x: e.clientX,
        y: e.clientY,
        text: text,
        tag: tag,
        id: id
      };
      document.removeEventListener('mousedown', window.__clickHandler, true);
    };
    document.addEventListener('mousedown', window.__clickHandler, true);
    void 0;
  `);
  console.log('Listener injected. Click anywhere in Chrome within 15s...\n');

  // Step 3: Poll for result
  const start = Date.now();
  while (Date.now() - start < 15000) {
    try {
      const result = await cdp.evaluate<any>('window.__clickResult');
      if (result) {
        console.log('✅ CLICK DETECTED!');
        console.log(`   x=${result.x}, y=${result.y}`);
        console.log(`   tag=${result.tag}, id=${result.id}`);
        console.log(`   text="${result.text}"`);
        cdp.close();
        return;
      }
    } catch (e: any) {
      console.log(`Poll error: ${e.message}`);
    }
    
    const elapsed = ((Date.now() - start) / 1000).toFixed(1);
    process.stdout.write(`\r  Polling... ${elapsed}s `);
    await sleep(200);
  }

  console.log('\n❌ No click detected in 15 seconds.');
  
  // Diagnostic: check if listener is still there
  try {
    const stillNull = await cdp.evaluate<any>('window.__clickResult');
    console.log(`window.__clickResult = ${JSON.stringify(stillNull)}`);
    const handlerExists = await cdp.evaluate<boolean>('typeof window.__clickHandler === "function"');
    console.log(`window.__clickHandler exists: ${handlerExists}`);
  } catch (e: any) {
    console.log(`Diagnostic error: ${e.message}`);
  }

  cdp.close();
}

main().catch(err => {
  console.error('Failed:', err.message);
  process.exit(1);
});
