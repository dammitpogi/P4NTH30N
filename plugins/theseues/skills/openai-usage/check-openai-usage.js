/**
 * check-openai-usage.js
 *
 * Prints current OpenAI usage/rate-limit health.
 * Source:
 *   codex app-server account/rateLimits/read (ChatGPT mode)
 */

const path = require("path");
const { spawn } = require("child_process");

const DEFAULT_THRESHOLDS = {
  critical: { five_hour: 10, weekly: 10 },
  low: { five_hour: 25, weekly: 20 },
  medium: { five_hour: 50, weekly: 30 },
};

function clampPct(value) {
  return Math.max(Math.min(Number(value), 100), 0);
}

function stageFromRemainingPct(fiveHourPct, weeklyPct, thresholds = DEFAULT_THRESHOLDS) {
  const t = thresholds || DEFAULT_THRESHOLDS;
  const five = Number(fiveHourPct);
  const weekly = Number(weeklyPct);

  if (five <= Number(t.critical?.five_hour || 10) || weekly <= Number(t.critical?.weekly || 10)) return "critical";
  if (five <= Number(t.low?.five_hour || 25) || weekly <= Number(t.low?.weekly || 20)) return "low";
  if (five <= Number(t.medium?.five_hour || 50) || weekly <= Number(t.medium?.weekly || 30)) return "medium";
  return "healthy";
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
        // ignore non-json lines
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
        clientInfo: { name: "openai-usage", version: "1.0.0" },
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
      throw new Error("ChatGPT account mode required for account/rateLimits/read");
    }

    const rateLimits = await rpcCallOverCodex(child, {
      method: "account/rateLimits/read",
      id: 2,
    });
    if (rateLimits?.error) throw new Error(rateLimits.error.message || "account/rateLimits/read failed");

    return rateLimits?.result?.rateLimits || null;
  } finally {
    child.kill();
  }
}

function getSnapshot(codexRateLimits) {
  const codexPrimaryUsed = Number(codexRateLimits?.primary?.usedPercent);
  const codexSecondaryUsed = Number(codexRateLimits?.secondary?.usedPercent);
  const codexPrimaryRemaining = Number.isFinite(codexPrimaryUsed) ? 100 - codexPrimaryUsed : null;
  const codexSecondaryRemaining = Number.isFinite(codexSecondaryUsed) ? 100 - codexSecondaryUsed : null;

  const fiveHourPct = Number.isFinite(codexPrimaryRemaining)
    ? clampPct(codexPrimaryRemaining)
    : null;

  const weeklyPct = Number.isFinite(codexSecondaryRemaining)
    ? clampPct(codexSecondaryRemaining)
    : null;

  if (!Number.isFinite(fiveHourPct) && !Number.isFinite(weeklyPct)) {
    throw new Error("No usage data returned from codex rate limits API");
  }

  const remainingRatio = Math.min(
    Number.isFinite(fiveHourPct) ? fiveHourPct / 100 : 1,
    Number.isFinite(weeklyPct) ? weeklyPct / 100 : 1
  );
  const stage = stageFromRemainingPct(fiveHourPct, weeklyPct, DEFAULT_THRESHOLDS);

  return {
    timestamp: new Date().toISOString(),
    five_hour_remaining_pct: fiveHourPct,
    weekly_remaining_pct: weeklyPct,
    remaining_ratio: remainingRatio,
    stage,
  };
}

function printHuman(snapshot, source, note) {
  const fiveHour = Number.isFinite(snapshot.five_hour_remaining_pct)
    ? `${snapshot.five_hour_remaining_pct.toFixed(1)}%`
    : "n/a";
  const weekly = Number.isFinite(snapshot.weekly_remaining_pct)
    ? `${snapshot.weekly_remaining_pct.toFixed(1)}%`
    : "n/a";

  console.log(`OpenAI Usage Health: ${snapshot.stage.toUpperCase()}`);
  console.log(`5-hour remaining: ${fiveHour}`);
  console.log(`Weekly remaining: ${weekly}`);
  console.log(`Source: ${source}`);
  if (note) console.log(`Note: ${note}`);
}

async function main() {
  const wantJson = process.argv.includes("--json");
  const codexRateLimits = await fetchCodexRateLimitsChatGPT();
  const snapshot = getSnapshot(codexRateLimits);

  if (wantJson) {
    console.log(
      JSON.stringify(
        {
          ...snapshot,
          source: "codex-rate-limits",
        },
        null,
        2
      )
    );
    return;
  }

  printHuman(snapshot, "codex-rate-limits", null);
}

main().catch((error) => {
  console.error(`OpenAI usage check failed: ${error.message}`);
  process.exit(1);
});
