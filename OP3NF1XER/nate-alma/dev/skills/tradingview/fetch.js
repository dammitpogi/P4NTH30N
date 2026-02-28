#!/usr/bin/env node
/**
 * TradingView Data Fetcher
 * Fetches real-time price data and technical indicators
 * Uses TradingView Scanner API + Yahoo Finance fallback
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// Symbol mappings for TradingView Scanner API
const TV_SYMBOL_MAP = {
  'SPY': 'AMEX:SPY',
  'SPX': 'SP:SPX',
  'VIX': 'CBOE:VIX',
  'QQQ': 'NASDAQ:QQQ',
  'IWM': 'AMEX:IWM',
  'DIA': 'AMEX:DIA',
};

// Symbols that need Yahoo Finance (futures, some indices)
const YAHOO_SYMBOLS = {
  'ES': 'ES=F',      // E-mini S&P 500 futures
  'NQ': 'NQ=F',      // E-mini Nasdaq futures  
  'XSP': '^XSP',     // Mini-SPX
  'VVIX': '^VVIX',   // VIX of VIX
};

// Indicators for TradingView
const TV_COLUMNS = [
  'open', 'high', 'low', 'close', 'volume',
  'change', 'change_abs',
  'RSI', 'MACD.macd', 'MACD.signal',
  'Stoch.K', 'Stoch.D', 'ATR',
  'EMA20', 'EMA50', 'EMA200',
  'SMA20', 'SMA50', 'SMA200',
  'Recommend.All',
];

const OUTPUT_DIR = '/data/workspace/trading/market-data';

// Fetch from TradingView Scanner API
async function fetchTradingView(symbols) {
  const tvSymbols = symbols.map(s => TV_SYMBOL_MAP[s]).filter(Boolean);
  if (tvSymbols.length === 0) return {};

  const payload = {
    symbols: { tickers: tvSymbols, query: { types: [] } },
    columns: TV_COLUMNS,
  };

  try {
    const response = await fetch('https://scanner.tradingview.com/america/scan', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    });

    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    const data = await response.json();
    return parseTVResponse(data, symbols);
  } catch (error) {
    console.error('TradingView error:', error.message);
    return {};
  }
}

function parseTVResponse(data, userSymbols) {
  const results = {};
  const timestamp = new Date().toISOString();

  for (const item of data.data || []) {
    // Find user symbol from TV symbol
    const tvSym = item.s;
    const userSym = Object.entries(TV_SYMBOL_MAP).find(([k, v]) => v === tvSym)?.[0];
    if (!userSym) continue;

    const d = item.d;
    results[userSym] = {
      symbol: userSym,
      source: 'tradingview',
      timestamp,
      price: {
        open: d[0], high: d[1], low: d[2], close: d[3],
        volume: d[4], change: d[5], changeAbs: d[6],
      },
      indicators: {
        rsi: d[7], macd: d[8], macdSignal: d[9],
        stochK: d[10], stochD: d[11], atr: d[12],
        ema20: d[13], ema50: d[14], ema200: d[15],
        sma20: d[16], sma50: d[17], sma200: d[18],
      },
      signal: interpretSignal(d[19]),
    };
  }
  return results;
}

// Use curl for HTTP requests (more reliable in sandboxed environments)
function curlGet(url) {
  try {
    const result = execSync(`curl -s -m 10 '${url}' -H 'User-Agent: Mozilla/5.0'`, {
      encoding: 'utf8',
      maxBuffer: 1024 * 1024,
    });
    return JSON.parse(result);
  } catch (e) {
    throw new Error(e.message || 'curl failed');
  }
}

// Fetch from Yahoo Finance (for futures and indices not in TV scanner)
async function fetchYahoo(symbols) {
  const results = {};
  const timestamp = new Date().toISOString();

  for (const sym of symbols) {
    const yahooSym = YAHOO_SYMBOLS[sym];
    if (!yahooSym) continue;

    try {
      const url = `https://query1.finance.yahoo.com/v8/finance/chart/${encodeURIComponent(yahooSym)}?interval=1d&range=1d`;
      const data = curlGet(url);
      const quote = data.chart?.result?.[0];
      if (!quote) continue;

      const meta = quote.meta;
      const price = meta.regularMarketPrice;
      const prevClose = meta.previousClose || meta.chartPreviousClose;
      const change = prevClose ? ((price - prevClose) / prevClose * 100) : null;

      results[sym] = {
        symbol: sym,
        source: 'yahoo',
        timestamp,
        price: {
          open: quote.indicators?.quote?.[0]?.open?.[0] || meta.regularMarketOpen,
          high: quote.indicators?.quote?.[0]?.high?.[0] || meta.regularMarketDayHigh,
          low: quote.indicators?.quote?.[0]?.low?.[0] || meta.regularMarketDayLow,
          close: price,
          volume: meta.regularMarketVolume,
          change: change,
          changeAbs: price - prevClose,
        },
        indicators: {}, // Yahoo doesn't provide indicators
        signal: 'n/a',
      };
    } catch (error) {
      console.error(`Yahoo error for ${sym}:`, error.message);
    }
  }
  return results;
}

function interpretSignal(value) {
  if (value === null || value === undefined) return 'neutral';
  if (value >= 0.5) return 'strong_buy';
  if (value >= 0.1) return 'buy';
  if (value <= -0.5) return 'strong_sell';
  if (value <= -0.1) return 'sell';
  return 'neutral';
}

function formatForContext(results) {
  const lines = [
    '# Market Data',
    `**Updated:** ${new Date().toLocaleString('en-US', { timeZone: 'America/Denver' })} MT`,
    ''
  ];

  // Group by type
  const indices = ['SPX', 'VIX', 'VVIX'];
  const etfs = ['SPY', 'QQQ', 'IWM', 'DIA', 'XSP'];
  const futures = ['ES', 'NQ'];

  const formatSymbol = (sym) => {
    const data = results[sym];
    if (!data) return null;
    
    const p = data.price;
    const emoji = (p.change >= 0) ? '🟢' : '🔴';
    const changeStr = p.change !== null 
      ? (p.change >= 0 ? `+${p.change.toFixed(2)}%` : `${p.change.toFixed(2)}%`)
      : 'n/a';
    
    let line = `**${sym}** ${emoji} ${p.close?.toFixed(2)} (${changeStr})`;
    
    // Add key indicators if available
    const ind = data.indicators;
    if (ind?.rsi) {
      line += ` | RSI: ${ind.rsi.toFixed(0)}`;
    }
    
    return line;
  };

  // Indices
  const indexLines = indices.map(formatSymbol).filter(Boolean);
  if (indexLines.length) {
    lines.push('## Indices');
    lines.push(...indexLines);
    lines.push('');
  }

  // ETFs
  const etfLines = etfs.map(formatSymbol).filter(Boolean);
  if (etfLines.length) {
    lines.push('## ETFs');
    lines.push(...etfLines);
    lines.push('');
  }

  // Futures
  const futureLines = futures.map(formatSymbol).filter(Boolean);
  if (futureLines.length) {
    lines.push('## Futures');
    lines.push(...futureLines);
    lines.push('');
  }

  return lines.join('\n');
}

async function main() {
  let symbols = process.argv.slice(2).map(s => s.toUpperCase());
  
  if (symbols.length === 0) {
    symbols = ['SPY', 'SPX', 'ES', 'XSP', 'VIX', 'VVIX'];
  }

  console.log(`Fetching: ${symbols.join(', ')}`);

  // Split symbols by source
  const tvSymbols = symbols.filter(s => TV_SYMBOL_MAP[s]);
  const yahooSymbols = symbols.filter(s => YAHOO_SYMBOLS[s]);

  // Fetch in parallel
  const [tvResults, yahooResults] = await Promise.all([
    fetchTradingView(tvSymbols),
    fetchYahoo(yahooSymbols),
  ]);

  const results = { ...tvResults, ...yahooResults };
  const fetchedCount = Object.keys(results).length;

  if (fetchedCount === 0) {
    console.error('No data fetched');
    process.exit(1);
  }

  console.log(`Got data for ${fetchedCount}/${symbols.length} symbols`);

  // Ensure output directory
  if (!fs.existsSync(OUTPUT_DIR)) {
    fs.mkdirSync(OUTPUT_DIR, { recursive: true });
  }

  // Save current.json
  const currentPath = path.join(OUTPUT_DIR, 'current.json');
  fs.writeFileSync(currentPath, JSON.stringify(results, null, 2));

  // Save context.md
  const contextPath = path.join(OUTPUT_DIR, 'context.md');
  fs.writeFileSync(contextPath, formatForContext(results));

  // Append to history files (keep last 100 per symbol)
  for (const [sym, data] of Object.entries(results)) {
    const histPath = path.join(OUTPUT_DIR, `${sym}-history.json`);
    let history = [];
    try {
      if (fs.existsSync(histPath)) {
        history = JSON.parse(fs.readFileSync(histPath, 'utf8'));
      }
    } catch (e) {}
    
    history.push(data);
    if (history.length > 100) history = history.slice(-100);
    fs.writeFileSync(histPath, JSON.stringify(history, null, 2));
  }

  // Output summary
  console.log('\n' + formatForContext(results));
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
