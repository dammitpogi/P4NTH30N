#!/usr/bin/env node
/**
 * SPX to SPY Converter
 * Converts SPX price levels to SPY equivalents
 * 
 * Usage: 
 *   node spx-to-spy.js 6850
 *   node spx-to-spy.js 6850 6820 6900
 *   echo "SPX 6850" | node spx-to-spy.js
 */

const fs = require('fs');
const MARKET_DATA_PATH = '/data/workspace/trading/market-data/current.json';

// Get live ratio from TradingView data, fallback to 10.015
function getLiveRatio() {
  try {
    const data = JSON.parse(fs.readFileSync(MARKET_DATA_PATH, 'utf8'));
    const spx = data.SPX?.price?.close;
    const spy = data.SPY?.price?.close;
    if (spx && spy) {
      return spx / spy;
    }
  } catch (e) {}
  return 10.015; // fallback
}

const RATIO = getLiveRatio();

function spxToSpy(spxPrice) {
  return (spxPrice / RATIO).toFixed(2);
}

function spyToSpx(spyPrice) {
  return (spyPrice * RATIO).toFixed(2);
}

function convertText(text) {
  // Find all 4-digit numbers that look like SPX prices (6000-7500 range)
  return text.replace(/\b(6\d{3}|7[0-4]\d{2})(\.\d+)?\b/g, (match) => {
    const spx = parseFloat(match);
    const spy = spxToSpy(spx);
    return `${match} (SPY: ${spy})`;
  });
}

// Main
const args = process.argv.slice(2);

if (args.length > 0) {
  // Convert command line arguments
  args.forEach(arg => {
    const price = parseFloat(arg);
    if (!isNaN(price)) {
      if (price > 1000) {
        // Assume SPX
        console.log(`SPX ${price} → SPY ${spxToSpy(price)}`);
      } else {
        // Assume SPY
        console.log(`SPY ${price} → SPX ${spyToSpx(price)}`);
      }
    }
  });
} else {
  // Read from stdin
  let input = '';
  process.stdin.setEncoding('utf8');
  process.stdin.on('data', chunk => input += chunk);
  process.stdin.on('end', () => {
    console.log(convertText(input));
  });
}
