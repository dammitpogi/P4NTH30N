/**
 * google-health.js
 *
 * Fast Google/Gemini health snapshot for quota-aware chain updates.
 */

const fs = require('fs');
const path = require('path');

const SKILL_DIR = __dirname;
const ROOT_DIR = path.resolve(SKILL_DIR, '..', '..');
const AUTH_FILE = path.join(process.env.USERPROFILE || 'C:/Users/paulc', '.local', 'share', 'opencode', 'auth.json');
const THESEUS_PATH = path.join(ROOT_DIR, 'oh-my-opencode-theseus.json');
const PROPOSAL_DIR = path.join(SKILL_DIR, 'proposals');

function loadJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

function ensureDir(dirPath) {
  if (!fs.existsSync(dirPath)) fs.mkdirSync(dirPath, { recursive: true });
}

function getGoogleKey() {
  const auth = loadJson(AUTH_FILE);
  return String(auth?.google?.key || '');
}

function collectGoogleModelsFromChains() {
  const theseus = loadJson(THESEUS_PATH);
  const models = new Set();
  for (const agentCfg of Object.values(theseus?.agents || {})) {
    for (const modelId of agentCfg?.models || []) {
      if (String(modelId).startsWith('google/')) models.add(String(modelId));
    }
  }
  return [...models];
}

function summarizeStage(results) {
  if (results.length === 0) {
    return { stage: 'critical', reason: 'no-google-models-found', successRate: 0 };
  }

  const total = results.length;
  const ok = results.filter((r) => r.ok).length;
  const quotaExceeded = results.filter((r) => r.quotaExceeded).length;
  const successRate = ok / total;

  if (quotaExceeded > 0) {
    return { stage: 'critical', reason: 'quota-exceeded-per-model', successRate };
  }
  if (successRate < 0.5) {
    return { stage: 'low', reason: 'low-google-success-rate', successRate };
  }
  if (successRate < 0.85) {
    return { stage: 'medium', reason: 'degraded-google-success-rate', successRate };
  }
  return { stage: 'healthy', reason: 'google-models-healthy', successRate };
}

async function testGoogleModel(modelId, apiKey) {
  const model = modelId.replace(/^google\//, '');
  const endpoint = `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${apiKey}`;

  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 12000);
  try {
    const res = await fetch(endpoint, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        contents: [{ parts: [{ text: 'OK' }] }],
        generationConfig: { maxOutputTokens: 5 },
      }),
      signal: controller.signal,
    });

    const text = await res.text();
    const quotaExceeded =
      res.status === 429 ||
      /quota exceeded|generate_requests_per_model_per_day|rate[- ]?limits?/i.test(text);

    return {
      modelId,
      status: res.status,
      ok: res.status === 200,
      quotaExceeded,
      detail: quotaExceeded ? 'quota-exceeded' : res.status === 200 ? 'ok' : 'request-failed',
    };
  } catch (error) {
    return {
      modelId,
      status: 0,
      ok: false,
      quotaExceeded: false,
      detail: error?.name === 'AbortError' ? 'timeout' : `error:${error.message}`,
    };
  } finally {
    clearTimeout(timeout);
  }
}

async function main() {
  if (!fs.existsSync(AUTH_FILE)) {
    throw new Error(`auth file missing: ${AUTH_FILE}`);
  }

  const googleKey = getGoogleKey();
  if (!googleKey) {
    throw new Error('Google API key missing in auth.json');
  }

  const models = collectGoogleModelsFromChains();
  const results = [];
  for (const modelId of models) {
    // eslint-disable-next-line no-await-in-loop
    const result = await testGoogleModel(modelId, googleKey);
    results.push(result);
    const icon = result.ok ? '✅' : result.quotaExceeded ? '🚫' : '❌';
    console.log(`${icon} ${modelId} (${result.status || result.detail})`);
  }

  const summary = summarizeStage(results);
  const snapshot = {
    timestamp: new Date().toISOString(),
    source: 'google-api-generate-content',
    stage: summary.stage,
    reason: summary.reason,
    successRate: Number(summary.successRate.toFixed(4)),
    tested: results.length,
    ok: results.filter((r) => r.ok).length,
    quotaExceededCount: results.filter((r) => r.quotaExceeded).length,
    unhealthyModels: results.filter((r) => !r.ok).map((r) => r.modelId),
    quotaExceededModels: results.filter((r) => r.quotaExceeded).map((r) => r.modelId),
    results,
  };

  ensureDir(PROPOSAL_DIR);
  const stamp = new Date().toISOString().replace(/[:.]/g, '-');
  const outPath = path.join(PROPOSAL_DIR, `google-health.${stamp}.json`);
  fs.writeFileSync(outPath, JSON.stringify(snapshot, null, 2) + '\n', 'utf8');

  console.log(`Google health proposal written: ${outPath}`);
  console.log(`Google health stage: ${snapshot.stage}`);
}

main().catch((error) => {
  console.error(`Google health refresh error: ${error.message}`);
  process.exit(1);
});
