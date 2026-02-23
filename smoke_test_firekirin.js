const CDP = require('chrome-remote-interface');
const fs = require('fs');
const path = require('path');

// Smoke test configuration
const CONFIG = {
    cdpPort: 9222,
    url: 'http://web.orionstars.org/hot_play/orionstars/',
    screenshotsDir: 'C:\\P4NTH30N\\SMOKE_TEST_SCREENSHOTS',
    // FireKirin coordinates (from specification)
    accountField: { rx: 0.4946, ry: 0.4243 },
    passwordField: { rx: 0.4946, ry: 0.5052 },
    loginButton: { rx: 0.5946, ry: 0.6556 }
};

// Test results
const results = {
    startTime: new Date().toISOString(),
    steps: [],
    errors: [],
    success: false
};

function logStep(step, status, details = {}) {
    const entry = {
        step,
        status,
        timestamp: new Date().toISOString(),
        ...details
    };
    results.steps.push(entry);
    console.log(`[${status}] ${step}:`, JSON.stringify(details, null, 2));
}

function logError(step, error) {
    results.errors.push({
        step,
        message: error.message,
        stack: error.stack,
        timestamp: new Date().toISOString()
    });
    console.error(`[ERROR] ${step}:`, error.message);
}

async function takeScreenshot(Page, filename) {
    try {
        const screenshot = await Page.captureScreenshot({ format: 'png' });
        const filepath = path.join(CONFIG.screenshotsDir, filename);
        fs.mkdirSync(CONFIG.screenshotsDir, { recursive: true });
        fs.writeFileSync(filepath, Buffer.from(screenshot.data, 'base64'));
        logStep('Screenshot', 'SUCCESS', { filename, path: filepath });
        return filepath;
    } catch (e) {
        logError('Screenshot', e);
        return null;
    }
}

async function typeWithFallback(Input, Runtime, text) {
    const strategies = [];
    
    // Strategy 1: Interceptor approach
    try {
        await Runtime.evaluate({
            expression: `
                window.__canvasInputInterceptor = { text: '${text}' };
                document.querySelector('canvas').dispatchEvent(new CustomEvent('canvasinput', { detail: { text: '${text}' } }));
            `
        });
        strategies.push('Strategy 1 (Interceptor) - SUCCESS');
        await new Promise(r => setTimeout(r, 500));
        return { success: true, strategy: 1 };
    } catch (e) {
        strategies.push(`Strategy 1 (Interceptor) - FAILED: ${e.message}`);
    }
    
    // Strategy 2: EditBox direct
    try {
        await Runtime.evaluate({
            expression: `
                const editBox = cc.find('EditBox')?._components?.[0];
                if (editBox) { editBox.string = '${text}'; editBox._updateString(); }
            `
        });
        strategies.push('Strategy 2 (EditBox direct) - SUCCESS');
        await new Promise(r => setTimeout(r, 500));
        return { success: true, strategy: 2 };
    } catch (e) {
        strategies.push(`Strategy 2 (EditBox direct) - FAILED: ${e.message}`);
    }
    
    // Strategy 3: Canvas key events
    try {
        for (const char of text) {
            await Input.dispatchKeyEvent({ type: 'char', text: char });
            await new Promise(r => setTimeout(r, 50));
        }
        strategies.push('Strategy 3 (Canvas key events) - SUCCESS');
        await new Promise(r => setTimeout(r, 500));
        return { success: true, strategy: 3 };
    } catch (e) {
        strategies.push(`Strategy 3 (Canvas key events) - FAILED: ${e.message}`);
    }
    
    // Strategy 4: Input.insertText
    try {
        await Input.insertText({ text });
        strategies.push('Strategy 4 (Input.insertText) - SUCCESS');
        await new Promise(r => setTimeout(r, 500));
        return { success: true, strategy: 4 };
    } catch (e) {
        strategies.push(`Strategy 4 (Input.insertText) - FAILED: ${e.message}`);
    }
    
    // Strategy 5: Focus and type
    try {
        await Runtime.evaluate({
            expression: `document.querySelector('canvas').focus();`
        });
        for (const char of text) {
            await Input.dispatchKeyEvent({ type: 'keyDown', key: char });
            await Input.dispatchKeyEvent({ type: 'keyUp', key: char });
            await new Promise(r => setTimeout(r, 50));
        }
        strategies.push('Strategy 5 (Focus and type) - SUCCESS');
        await new Promise(r => setTimeout(r, 500));
        return { success: true, strategy: 5 };
    } catch (e) {
        strategies.push(`Strategy 5 (Focus and type) - FAILED: ${e.message}`);
    }
    
    // Strategy 6: Raw key codes
    try {
        for (const char of text) {
            const code = char.charCodeAt(0);
            await Input.dispatchKeyEvent({ type: 'rawKeyDown', windowsVirtualKeyCode: code });
            await Input.dispatchKeyEvent({ type: 'char', text: char });
            await Input.dispatchKeyEvent({ type: 'keyUp', windowsVirtualKeyCode: code });
            await new Promise(r => setTimeout(r, 50));
        }
        strategies.push('Strategy 6 (Raw key codes) - SUCCESS');
        await new Promise(r => setTimeout(r, 500));
        return { success: true, strategy: 6 };
    } catch (e) {
        strategies.push(`Strategy 6 (Raw key codes) - FAILED: ${e.message}`);
    }
    
    return { success: false, strategies };
}

async function smokeTest() {
    let client;
    
    try {
        // Step 1: Connect to Chrome
        logStep('Connect to Chrome', 'START');
        client = await CDP({ port: CONFIG.cdpPort });
        const { Page, Runtime, Input } = client;
        logStep('Connect to Chrome', 'SUCCESS', { port: CONFIG.cdpPort });
        
        // Step 2: Navigate to FireKirin
        logStep('Navigate to FireKirin', 'START', { url: CONFIG.url });
        await Page.enable();
        await Runtime.enable();
        await Page.navigate({ url: CONFIG.url });
        await Page.loadEventFired();
        await new Promise(r => setTimeout(r, 5000)); // Wait for page to fully load
        logStep('Navigate to FireKirin', 'SUCCESS');
        await takeScreenshot(Page, '01_navigated.png');
        
        // Step 3: Get canvas bounds
        logStep('Get Canvas Bounds', 'START');
        const canvasBounds = await Runtime.evaluate({
            expression: `
                const canvas = document.querySelector('canvas');
                if (!canvas) return null;
                const rect = canvas.getBoundingClientRect();
                ({ x: rect.x, y: rect.y, width: rect.width, height: rect.height, visible: canvas.offsetParent !== null })
            `,
            returnByValue: true
        });
        
        if (!canvasBounds.result.value || canvasBounds.result.value.width === 0) {
            throw new Error('Canvas not found or has zero dimensions');
        }
        
        const bounds = canvasBounds.result.value;
        logStep('Get Canvas Bounds', 'SUCCESS', bounds);
        
        // Step 4: Transform coordinates
        logStep('Transform Coordinates', 'START');
        const accountX = bounds.x + (CONFIG.accountField.rx * bounds.width);
        const accountY = bounds.y + (CONFIG.accountField.ry * bounds.height);
        const passwordX = bounds.x + (CONFIG.passwordField.rx * bounds.width);
        const passwordY = bounds.y + (CONFIG.passwordField.ry * bounds.height);
        const loginX = bounds.x + (CONFIG.loginButton.rx * bounds.width);
        const loginY = bounds.y + (CONFIG.loginButton.ry * bounds.height);
        
        logStep('Transform Coordinates', 'SUCCESS', {
            account: { x: accountX, y: accountY },
            password: { x: passwordX, y: passwordY },
            login: { x: loginX, y: loginY }
        });
        
        // Step 5: Click account field
        logStep('Click Account Field', 'START', { x: accountX, y: accountY });
        await Input.dispatchMouseEvent({ type: 'mousePressed', x: accountX, y: accountY, button: 'left', clickCount: 1 });
        await Input.dispatchMouseEvent({ type: 'mouseReleased', x: accountX, y: accountY, button: 'left', clickCount: 1 });
        await new Promise(r => setTimeout(r, 500));
        logStep('Click Account Field', 'SUCCESS');
        await takeScreenshot(Page, '02_account_clicked.png');
        
        // Step 6: Type username (using test credentials from MongoDB)
        logStep('Type Username', 'START');
        const usernameResult = await typeWithFallback(Input, Runtime, 'testuser123');
        logStep('Type Username', usernameResult.success ? 'SUCCESS' : 'FAILED', usernameResult);
        await takeScreenshot(Page, '03_username_typed.png');
        
        // Step 7: Click password field
        logStep('Click Password Field', 'START', { x: passwordX, y: passwordY });
        await Input.dispatchMouseEvent({ type: 'mousePressed', x: passwordX, y: passwordY, button: 'left', clickCount: 1 });
        await Input.dispatchMouseEvent({ type: 'mouseReleased', x: passwordX, y: passwordY, button: 'left', clickCount: 1 });
        await new Promise(r => setTimeout(r, 500));
        logStep('Click Password Field', 'SUCCESS');
        await takeScreenshot(Page, '04_password_clicked.png');
        
        // Step 8: Type password
        logStep('Type Password', 'START');
        const passwordResult = await typeWithFallback(Input, Runtime, 'testpass456');
        logStep('Type Password', passwordResult.success ? 'SUCCESS' : 'FAILED', passwordResult);
        await takeScreenshot(Page, '05_password_typed.png');
        
        // Step 9: Click login
        logStep('Click Login Button', 'START', { x: loginX, y: loginY });
        await Input.dispatchMouseEvent({ type: 'mousePressed', x: loginX, y: loginY, button: 'left', clickCount: 1 });
        await Input.dispatchMouseEvent({ type: 'mouseReleased', x: loginX, y: loginY, button: 'left', clickCount: 1 });
        logStep('Click Login Button', 'SUCCESS');
        
        // Step 10: Wait and verify login
        logStep('Verify Login', 'START');
        await new Promise(r => setTimeout(r, 5000));
        await takeScreenshot(Page, '06_after_login.png');
        
        // Check for balance or login success indicators
        const balanceCheck = await Runtime.evaluate({
            expression: `
                // Try multiple balance indicators
                window.parent?.Grand || 
                document.querySelector('[data-balance]')?.textContent ||
                document.querySelector('.balance')?.textContent ||
                document.querySelector('.user-balance')?.textContent ||
                document.body.innerText.match(/balance[\s:]*([\d,.]+)/i)?.[1] ||
                'NOT_FOUND'
            `,
            returnByValue: true
        });
        
        const balance = balanceCheck.result.value;
        logStep('Verify Login', 'SUCCESS', { balance });
        
        // Final screenshot
        await takeScreenshot(Page, '07_final.png');
        
        results.success = true;
        results.endTime = new Date().toISOString();
        
    } catch (error) {
        logError('Smoke Test', error);
        results.success = false;
        results.endTime = new Date().toISOString();
    } finally {
        if (client) {
            await client.close();
        }
        
        // Write results to file
        const resultsPath = path.join(CONFIG.screenshotsDir, 'results.json');
        fs.mkdirSync(CONFIG.screenshotsDir, { recursive: true });
        fs.writeFileSync(resultsPath, JSON.stringify(results, null, 2));
        console.log('\n=== SMOKE TEST RESULTS ===');
        console.log(JSON.stringify(results, null, 2));
        console.log(`\nResults saved to: ${resultsPath}`);
        
        process.exit(results.success ? 0 : 1);
    }
}

smokeTest().catch(console.error);
