/**
 * openai-budget.js
 *
 * Codex ChatGPT rate-limit snapshot for conservative OpenAI scoring.
 *
 * Source priority:
 *   1) codex app-server account/rateLimits/read (ChatGPT mode)
 *   2) manual snapshot (openai_limits_manual.json or CLI args)
 *
 * No OpenAI usage API fallback.
 */

const fs = require("fs");
const path = require("path");
const { spawn } = require("child_process");

const SKILL_DIR = __dirname;
const PROPOSAL_DIR = path.join(SKILL_DIR, "proposals");
const POLICY_PATH = path.join(SKILL_DIR, "openai_budget_policy.json");
const MANUAL_LIMITS_PATH = path.join(SKILL_DIR, "openai_limits_manual.json");

function loadJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function loadOptionalJson(filePath, fallback) {
  if (!fs.existsSync(filePath)) return fallback;
  return loadJson(filePath);
}

function saveJson(filePath, data) {
  fs.writeFileSync(filePath, JSON.stringify(data, null, 2) + "\n", "utf8");
}

function ensureDirectory(dirPath) {
  if (!fs.existsSync(dirPath)) fs.mkdirSync(dirPath, { recursive: true });
}

function parseArgs(argv) {
  const args = new Set(argv);
  const fiveIdx = argv.indexOf("--five-hour-remaining");
  const weeklyIdx = argv.indexOf("--weekly-remaining");
  const fiveHourRemainingPct = fiveIdx >= 0 ? Number(argv[fiveIdx + 1]) : null;
  const weeklyRemainingPct = weeklyIdx >= 0 ? Number(argv[weeklyIdx + 1]) : null;
  return {
    fiveHourRemainingPct: Number.isFinite(fiveHourRemainingPct) ? fiveHourRemainingPct : null,
    weeklyRemainingPct: Number.isFinite(weeklyRemainingPct) ? weeklyRemainingPct : null,
    noApi: args.has("--no-api"),
  };
}

function startCodexServer() {
  return new Promise(async (resolve, reject) => {
    const appData = process.env.APPDATA || "";
    const candidates = [
      { cmd: "codex", args: ["app-server"], shell: false },
      ...(appData
        ? [
            {
              cmd: "cmd.exe",
              args: ["/d", "/s", "/c", path.join(appData, "npm", "codex.cmd"), "app-server"],
              shell: false,
            },
          ]
        : []),
    ];

    for (const candidate of candidates) {
      const child = spawn(candidate.cmd, candidate.args, {
        stdio: ["pipe", "pipe", "pipe"],
        shell: Boolean(candidate.shell),
      });

      // eslint-disable-next-line no-await-in-loop
      const started = await new Promise((resolveSpawn) => {
        let settled = false;
        child.once("spawn", () => {
          settled = true;
          resolveSpawn(true);
        });
        child.once("error", () => {
          if (!settled) resolveSpawn(false);
        });
      });

      if (started) {
        resolve(child);
        return;
      }
    }

    reject(new Error("codex app-server command not available in PATH"));
  });
}

function readJsonLines(stream, onLine) {
  let buffer = "";
  stream.setEncoding("utf8");
  stream.on("data", (chunk) => {
    buffer += chunk;
    let idx;
    while ((idx = buffer.indexOf("\n")) !== -1) {
      const line = buffer.slice(0, idx).trim();
      buffer = buffer.slice(idx + 1);
      if (!line) continue;
      try {
        onLine(JSON.parse(line));
      } catch {
        // ignore non-json
      }
    }
  });
}

function rpcCallOverCodex(child, payload, timeoutMs = 10000) {
  return new Promise((resolve, reject) => {
    const timer = setTimeout(() => reject(new Error(`Timeout waiting for id=${payload.id}`)), timeoutMs);
    const onMessage = (message) => {
      if (message && message.id === payload.id) {
        clearTimeout(timer);
        resolve(message);
      }
    };
    readJsonLines(child.stdout, onMessage);
    child.stdin.write(JSON.stringify(payload) + "\n");
  });
}

async function fetchCodexRateLimitsChatGPT() {
  const child = await startCodexServer();
  try {
    const init = await rpcCallOverCodex(child, {
      method: "initialize",
      id: 0,
      params: {
        clientInfo: { name: "update-agent-models", version: "1.0.0" },
        capabilities: { experimentalApi: true },
      },
    });
    if (init?.error) throw new Error(init.error.message || "initialize failed");

    const accountRead = await rpcCallOverCodex(child, {
      method: "account/read",
      id: 1,
      params: { refreshToken: false },
    });
    if (accountRead?.error) throw new Error(accountRead.error.message || "account/read failed");

    const accountType = accountRead?.result?.account?.type || null;
    if (accountType !== "chatgpt" && accountType !== "chatgptAuthTokens") {
      const loginStart = await rpcCallOverCodex(child, {
        method: "account/login/start",
        id: 2,
        params: { type: "chatgpt" },
      });
      if (loginStart?.error) throw new Error(loginStart.error.message || "account/login/start failed");
      const authUrl = loginStart?.result?.authUrl || null;
      if (authUrl) {
        throw new Error(`ChatGPT login required. Complete browser auth: ${authUrl}`);
      }
      throw new Error("ChatGPT login required for codex app-server.");
    }

    const rateLimits = await rpcCallOverCodex(child, {
      method: "account/rateLimits/read",
      id: 3,
    });
    if (rateLimits?.error) throw new Error(rateLimits.error.message || "account/rateLimits/read failed");
    return rateLimits?.result?.rateLimits || null;
  } finally {
    child.kill();
  }
}

function stageFromRemainingPct(fiveHourPct, weeklyPct, policy) {
  const t = policy.health_thresholds_pct || {};
  const five = Number(fiveHourPct);
  const weekly = Number(weeklyPct);

  if (five <= Number(t.critical?.five_hour || 10) || weekly <= Number(t.critical?.weekly || 10)) return "critical";
  if (five <= Number(t.low?.five_hour || 25) || weekly <= Number(t.low?.weekly || 20)) return "low";
  if (five <= Number(t.medium?.five_hour || 50) || weekly <= Number(t.medium?.weekly || 30)) return "medium";
  return "healthy";
}

function clampPct(value) {
  return Math.max(Math.min(Number(value), 100), 0);
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  const policy = loadJson(POLICY_PATH);
  const manualLimits = loadOptionalJson(MANUAL_LIMITS_PATH, {});

  let source = "manual";
  let apiError = null;
  let codexRateLimits = null;

  if (!args.noApi) {
    try {
      codexRateLimits = await fetchCodexRateLimitsChatGPT();
      if (codexRateLimits) source = "codex-rate-limits";
    } catch (error) {
      apiError = `codex: ${error.message}`;
    }
  }

  const manualFive =
    args.fiveHourRemainingPct !== null ? args.fiveHourRemainingPct : Number(manualLimits?.five_hour_remaining_pct);
  const manualWeekly =
    args.weeklyRemainingPct !== null ? args.weeklyRemainingPct : Number(manualLimits?.weekly_remaining_pct);

  const codexPrimaryUsed = Number(codexRateLimits?.primary?.usedPercent);
  const codexSecondaryUsed = Number(codexRateLimits?.secondary?.usedPercent);
  const codexPrimaryRemaining = Number.isFinite(codexPrimaryUsed) ? 100 - codexPrimaryUsed : null;
  const codexSecondaryRemaining = Number.isFinite(codexSecondaryUsed) ? 100 - codexSecondaryUsed : null;

  const fiveHourPct =
    Number.isFinite(codexPrimaryRemaining) ? clampPct(codexPrimaryRemaining) : Number.isFinite(manualFive) ? clampPct(manualFive) : null;
  const weeklyPct =
    Number.isFinite(codexSecondaryRemaining)
      ? clampPct(codexSecondaryRemaining)
      : Number.isFinite(manualWeekly)
      ? clampPct(manualWeekly)
      : null;

  if (!Number.isFinite(fiveHourPct) && !Number.isFinite(weeklyPct)) {
    throw new Error(
      "Unable to read Codex ChatGPT rate limits. Please provide a manual snapshot: five-hour and weekly remaining percentages."
    );
  }

  const remainingRatio = Math.min(
    Number.isFinite(fiveHourPct) ? fiveHourPct / 100 : 1,
    Number.isFinite(weeklyPct) ? weeklyPct / 100 : 1
  );

  const fiveHourRatio = Number.isFinite(fiveHourPct) ? fiveHourPct / 100 : 1;
  const weeklyRatio = Number.isFinite(weeklyPct) ? weeklyPct / 100 : 1;
  const overallStage = stageFromRemainingPct(fiveHourPct, weeklyPct, policy);

  const snapshot = {
    timestamp: new Date().toISOString(),
    source,
    monthly_allowance_usd: Number(policy.monthly_allowance_usd || 0),
    spent_usd: null,
    remaining_usd: null,
    monetary_remaining_ratio: null,
    remaining_ratio: remainingRatio,
    five_hour_remaining_ratio: fiveHourRatio,
    weekly_remaining_ratio: weeklyRatio,
    budget_stage: overallStage,
    usage_limits: {
      five_hour_remaining_pct: fiveHourPct,
      weekly_remaining_pct: weeklyPct,
      codex_rate_limits: codexRateLimits,
      source_file: fs.existsSync(MANUAL_LIMITS_PATH) ? MANUAL_LIMITS_PATH : null,
    },
    model_costs_usd: {},
    api_error: apiError,
  };

  ensureDirectory(PROPOSAL_DIR);
  const stamp = new Date().toISOString().replace(/[:.]/g, "-");
  const outPath = path.join(PROPOSAL_DIR, `openai-budget.${stamp}.json`);
  saveJson(outPath, snapshot);
  console.log(`OpenAI budget proposal written: ${outPath}`);
  if (apiError) console.log(`OpenAI API note: ${apiError}`);
}

main().catch((error) => {
  console.error(`OpenAI budget refresh error: ${error.message}`);
  process.exit(1);
});
