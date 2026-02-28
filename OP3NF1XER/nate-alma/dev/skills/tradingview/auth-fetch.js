#!/usr/bin/env node
/**
 * TradingView Authenticated Data Fetcher
 * Pulls chart data including custom indicators using login credentials
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const SECRETS_PATH = '/data/workspace/.secrets/tradingview.json';
const OUTPUT_DIR = '/data/workspace/trading/market-data';

// Load credentials
function getCredentials() {
  try {
    return JSON.parse(fs.readFileSync(SECRETS_PATH, 'utf8'));
  } catch (e) {
    console.error('Failed to load credentials from', SECRETS_PATH);
    process.exit(1);
  }
}

// Authenticate and get session token
async function authenticate(username, password) {
  // TradingView auth endpoint
  const authData = `username=${encodeURIComponent(username)}&password=${encodeURIComponent(password)}&remember=on`;
  
  try {
    // Use curl to handle cookies properly
    const result = execSync(`
      curl -s -c - -X POST 'https://www.tradingview.com/accounts/signin/' \
        -H 'Content-Type: application/x-www-form-urlencoded' \
        -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36' \
        -H 'Origin: https://www.tradingview.com' \
        -H 'Referer: https://www.tradingview.com/' \
        -d '${authData}' 2>/dev/null
    `, { encoding: 'utf8', maxBuffer: 1024 * 1024 });
    
    // Extract sessionid from cookies
    const sessionMatch = result.match(/sessionid\s+(\S+)/);
    if (sessionMatch) {
      return sessionMatch[1];
    }
    
    // Check if we got a JSON response with error
    if (result.includes('error')) {
      console.error('Auth error:', result);
      return null;
    }
    
    return result; // Return full response for debugging
  } catch (e) {
    console.error('Auth request failed:', e.message);
    return null;
  }
}

// Get chart data for a symbol with session
async function getChartData(sessionId, symbol) {
  // TradingView uses a complex websocket protocol for real-time data
  // For now, let's try the chart export API
  try {
    const result = execSync(`
      curl -s 'https://www.tradingview.com/chart-token/' \
        -H 'Cookie: sessionid=${sessionId}' \
        -H 'User-Agent: Mozilla/5.0' 2>/dev/null
    `, { encoding: 'utf8' });
    
    return result;
  } catch (e) {
    console.error('Chart data fetch failed:', e.message);
    return null;
  }
}

// Get user's saved chart layouts
async function getChartLayouts(sessionId) {
  try {
    const result = execSync(`
      curl -s 'https://www.tradingview.com/api/v1/charts/' \
        -H 'Cookie: sessionid=${sessionId}' \
        -H 'User-Agent: Mozilla/5.0' 2>/dev/null
    `, { encoding: 'utf8' });
    
    return JSON.parse(result);
  } catch (e) {
    console.error('Failed to get chart layouts:', e.message);
    return null;
  }
}

// Get study templates (custom indicators)
async function getStudyTemplates(sessionId) {
  try {
    const result = execSync(`
      curl -s 'https://www.tradingview.com/api/v1/study-templates/' \
        -H 'Cookie: sessionid=${sessionId}' \
        -H 'User-Agent: Mozilla/5.0' 2>/dev/null
    `, { encoding: 'utf8' });
    
    return JSON.parse(result);
  } catch (e) {
    console.error('Failed to get study templates:', e.message);
    return null;
  }
}

async function main() {
  const creds = getCredentials();
  console.log(`Authenticating as ${creds.username}...`);
  
  const session = await authenticate(creds.username, creds.password);
  
  if (!session) {
    console.error('Authentication failed');
    process.exit(1);
  }
  
  console.log('Session obtained, fetching data...');
  
  // Try to get chart layouts
  const layouts = await getChartLayouts(session);
  if (layouts) {
    console.log('Chart layouts:', JSON.stringify(layouts, null, 2));
    
    // Save layouts
    fs.writeFileSync(
      path.join(OUTPUT_DIR, 'chart-layouts.json'),
      JSON.stringify(layouts, null, 2)
    );
  }
  
  // Try to get study templates
  const templates = await getStudyTemplates(session);
  if (templates) {
    console.log('Study templates:', JSON.stringify(templates, null, 2));
    
    fs.writeFileSync(
      path.join(OUTPUT_DIR, 'study-templates.json'),
      JSON.stringify(templates, null, 2)
    );
  }
  
  console.log('Done!');
}

main().catch(console.error);
