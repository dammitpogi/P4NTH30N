# Smoke Test Specification: FireKirin Login Verification

**Test ID**: SMOKE-001  
**Purpose**: Verify FireKirin login works with Canvas typing before 24-hour burn-in  
**Prerequisites**: Chrome installed, MongoDB accessible at 192.168.56.1:27017  

## Test Steps

### Step 1: Environment Verification
```powershell
# Verify Chrome is installed
Get-Command chrome -ErrorAction SilentlyContinue
# Expected: Path to chrome.exe

# Verify MongoDB connection
mongosh "mongodb://192.168.56.1:27017/P4NTH30N?directConnection=true" --eval "db.CR3D3N7IAL.countDocuments()"
# Expected: Number > 0
```

### Step 2: Build and Run Smoke Test
```powershell
cd C:\P4NTH30N
dotnet build H4ND/H4ND.csproj -c Release

# Run smoke test executable
H4ND\bin\Release\net9.0\H4ND.exe SMOKE --platform firekirin --profile W0
```

### Step 3: Manual Verification via CDP

If automated smoke test not available, use CDP directly:

```javascript
// Connect to Chrome on port 9222
const CDP = require('chrome-remote-interface');

async function smokeTest() {
    const client = await CDP({ port: 9222 });
    const { Page, Runtime, Input } = client;
    
    // 1. Navigate to FireKirin
    await Page.navigate({ url: 'http://web.orionstars.org/hot_play/orionstars/' });
    await Page.loadEventFired();
    
    // 2. Get canvas bounds
    const canvasBounds = await Runtime.evaluate({
        expression: `
            const canvas = document.querySelector('canvas');
            const rect = canvas.getBoundingClientRect();
            ({ x: rect.x, y: rect.y, width: rect.width, height: rect.height })
        `,
        returnByValue: true
    });
    console.log('Canvas bounds:', canvasBounds.result.value);
    
    // 3. Transform relative to absolute coordinates
    // Account field: rx=0.4946, ry=0.4243
    const accountX = canvasBounds.result.value.x + (0.4946 * canvasBounds.result.value.width);
    const accountY = canvasBounds.result.value.y + (0.4243 * canvasBounds.result.value.height);
    
    // 4. Click account field
    await Input.dispatchMouseEvent({
        type: 'mousePressed',
        x: accountX,
        y: accountY,
        button: 'left',
        clickCount: 1
    });
    await Input.dispatchMouseEvent({
        type: 'mouseReleased',
        x: accountX,
        y: accountY,
        button: 'left',
        clickCount: 1
    });
    
    // 5. Type username (6-strategy fallback)
    await typeWithFallback(Input, Runtime, 'testuser');
    
    // 6. Click password field
    const passwordX = canvasBounds.result.value.x + (0.4946 * canvasBounds.result.value.width);
    const passwordY = canvasBounds.result.value.y + (0.5052 * canvasBounds.result.value.height);
    await Input.dispatchMouseEvent({ type: 'mousePressed', x: passwordX, y: passwordY, button: 'left', clickCount: 1 });
    await Input.dispatchMouseEvent({ type: 'mouseReleased', x: passwordX, y: passwordY, button: 'left', clickCount: 1 });
    
    // 7. Type password
    await typeWithFallback(Input, Runtime, 'testpass');
    
    // 8. Click login
    const loginX = canvasBounds.result.value.x + (0.5946 * canvasBounds.result.value.width);
    const loginY = canvasBounds.result.value.y + (0.6556 * canvasBounds.result.value.height);
    await Input.dispatchMouseEvent({ type: 'mousePressed', x: loginX, y: loginY, button: 'left', clickCount: 1 });
    await Input.dispatchMouseEvent({ type: 'mouseReleased', x: loginX, y: loginY, button: 'left', clickCount: 1 });
    
    // 9. Verify login (wait for balance)
    await new Promise(r => setTimeout(r, 3000));
    const balance = await Runtime.evaluate({
        expression: `window.parent?.Grand || document.querySelector('[data-balance]')?.textContent`,
        returnByValue: true
    });
    console.log('Balance:', balance.result.value);
    
    await client.close();
}

async function typeWithFallback(Input, Runtime, text) {
    // Strategy 1: Interceptor approach
    try {
        await Runtime.evaluate({
            expression: `
                window.__canvasInputInterceptor = { text: '${text}' };
                document.querySelector('canvas').dispatchEvent(new CustomEvent('canvasinput', { detail: { text: '${text}' } }));
            `
        });
        return;
    } catch (e) { console.log('Strategy 1 failed:', e.message); }
    
    // Strategy 2: EditBox direct
    try {
        await Runtime.evaluate({
            expression: `
                const editBox = cc.find('EditBox')?._components?.[0];
                if (editBox) { editBox.string = '${text}'; editBox._updateString(); }
            `
        });
        return;
    } catch (e) { console.log('Strategy 2 failed:', e.message); }
    
    // Strategy 3: Canvas key events
    for (const char of text) {
        await Input.dispatchKeyEvent({ type: 'char', text: char });
        await new Promise(r => setTimeout(r, 50));
    }
}

smokeTest().catch(console.error);
```

## Expected Results

| Checkpoint | Expected | Actual |
|------------|----------|--------|
| Chrome launches on port 9222 | ✅ | |
| Canvas bounds retrieved | width > 0, height > 0 | |
| Account field clicked | Cursor visible | |
| Username appears | Text visible in field | |
| Password field clicked | Field focused | |
| Password appears | Dots visible | |
| Login clicked | Page transitions | |
| Balance verified | Value > 0 | |

## Success Criteria

- All checkpoints pass
- No exceptions thrown
- Total time < 30 seconds
- Balance query returns valid number

## Failure Modes

| Issue | Diagnosis | Resolution |
|-------|-----------|------------|
| Chrome not on port 9222 | Chrome not running | Launch Chrome with --remote-debugging-port=9222 |
| Canvas bounds = 0 | Page not loaded | Increase delay, check URL |
| Typing doesn't appear | Canvas not accepting input | Try different typing strategy |
| Login fails | Wrong credentials | Verify MongoDB credential |
| Balance = null | Not logged in | Check login success indicators |

## Next Steps After Success

1. ✅ Smoke test passed
2. Update DECISION_047 status to "READY"
3. Execute 24-hour burn-in with 5 parallel workers
4. Monitor via BurnInDashboardServer
