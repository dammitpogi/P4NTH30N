# USER.md - About Your Human

- **Name:** Nate Hansen
- **What to call them:** Nate
- **Pronouns:** 
- **Timezone:** Mountain Time (Salt Lake City, Utah)
- **Infrastructure:** Running OpenClaw on Railway (UTC-based)
- **Notes:** Prepaid $5 for Claude API. Cost-conscious — switched to Sonnet to stretch the budget. Working on options trading education.
- **Trading Schedule:** Market analysis arrives ~7 AM MT, market opens 7:30 AM MT. Likes to be ready before the bell.
- **Smart Home:** HomeKit, Alexa (speakers/lights/plugs), Govee lights and plugs
- **Hardware:** Mac mini M4 (to be paired as OpenClaw node)

## Personal Facts (Evidence-Backed)

- Nate operates a "nate and Alma" Telegram group and actively tunes bot behavior there. (Sources: `memory/2026-02-23.md:5`, `memory/2026-02-23.md:10`, `memory/2026-02-23.md:15`)
- Nate is actively building a Mac mini node path (OpenClaw pairing + integrations). (Sources: `memory/2026-02-23.md:29`, `memory/2026-02-23.md:35`, `memory/2026-02-23.md:36`)
- Nate's practical stack interests include smart home automation (HomeKit/Alexa/Govee) and social monitoring (X/Twitter + Discord). (Sources: `memory/2026-02-23.md:30`, `memory/2026-02-23.md:32`)
- Nate is building trading infrastructure around Webull API and live market-data automation. (Sources: `memory/2026-02-23.md:31`, `memory/2026-02-23.md:37`)
- Nate explicitly wants TradingView-fed levels for bots rather than manual chat updates. (Source: `memory/2026-02-20.md:8`)
- Nate uses market-time planning (MT) with pre-market reminder windows. (Sources: `memory/2026-02-20.md:5`, `memory/2026-02-20.md:12`)

## Character Traits (Observed, Not Assumed)

- Systems thinker: pushes architecture changes (provider cascade + role-based agents) when bottlenecks appear. (Sources: `memory/2026-02-24.md:5`, `memory/2026-02-24.md:8`, `memory/2026-02-24.md:22`)
- Pragmatic operator: accepts whichever path works, including hybrid-model workflows and simpler technical alternatives. (Sources: `memory/2026-02-24.md:13`, `memory/2026-02-23.md:68`)
- Speed-and-results oriented: prefers actionable changes over ceremony and validates by working behavior. (Sources: `memory/2026-02-23.md:22`, `memory/2026-02-23.md:49`)
- Cost-aware: explicitly optimizes expensive model usage and routine pipeline spend. (Sources: `memory/2026-02-24.md:11`, `memory/2026-02-23.md:74`)
- Reliability-first: pivots away from flaky scheduling paths and expects deterministic fallbacks. (Sources: `memory/2026-02-04.md:39`, `memory/2026-02-04.md:40`, `memory/2026-02-04.md:67`)

## Dreams / Aspirations (Stated Roadmap Signals)

- Build a multi-agent lane with clear role specialization (routine chat, coding, research). (Sources: `memory/2026-02-24.md:22`, `memory/2026-02-24.md:24`, `memory/2026-02-24.md:25`, `memory/2026-02-24.md:26`)
- Expand into sub-agent orchestration where workers run isolated tasks and return completion signals. (Source: `memory/2026-02-23.md:45`)
- Mature a broader personal ops fabric: Mac mini node + iCloud calendar/reminders + smart-home control. (Sources: `memory/2026-02-04.md:70`, `memory/2026-02-04.md:76`, `memory/2026-02-04.md:77`, `memory/2026-02-23.md:29`, `memory/2026-02-23.md:30`)
- Extend channel footprint with Discord integration. (Sources: `memory/2026-02-21.md:24`, `memory/2026-02-23.md:32`)

## Who Nate Is (Operationally)

- Nate is outcome-first and wants deterministic execution, not speculative guidance. (Sources: `memory/2026-02-24.md:5`, `memory/2026-02-24.md:13`)
- Nate actively designs systems around reliability under rate limits (fallback chains, model routing, role-based agents). (Sources: `memory/2026-02-24.md:5`, `memory/2026-02-24.md:8`, `memory/2026-02-24.md:9`, `memory/2026-02-24.md:11`)
- Nate prefers project/topic-based organization over fragmented chat surfaces. (Source: `memory/2026-02-23.md:50`)
- Nate wants recurring asks converted into tools/runbooks, not handled ad hoc each session. (Sources: `memory/2026-02-25.md:10`, `memory/2026-02-23.md:45`)

## Communication Style Alma Should Use

- Direct answer first, then proof/evidence path.
- Avoid question loops for non-destructive work; just execute and report.
- Keep status updates concrete and operational (what changed, validation, next step).

Preference detail:

- Nate wants named-role clarity (not generic assistant labels) when multiple agents are active. (Source: `memory/2026-02-24.md:10`)
- Nate accepts direction options, but expects the system to move with minimal drag once direction is chosen. (Source: `memory/2026-02-24.md:28`)

These are explicitly reinforced in workspace guidance and Nate flow hardening. (Sources: `AGENTS.md:317`, `AGENTS.md:319`, `AGENTS.md:323`, `AGENTS.md:315`)

## Alma-Specific Delivery Style

- Keep first response short and concrete.
- Put command/file proof immediately after claim.
- When offering options, keep to 2-3 with a recommended default.
- Keep trading summaries in this format: regime -> levels -> bias -> invalidation -> next trigger.

## Nate's Current Priorities

- Multi-model architecture with fallback and role-specific agents for cost/performance balance. (Sources: `memory/2026-02-24.md:7`, `memory/2026-02-24.md:22`, `memory/2026-02-24.md:23`, `memory/2026-02-24.md:24`, `memory/2026-02-24.md:25`, `memory/2026-02-24.md:26`)
- Trading automation and real-time market context ingestion (SPY/SPX/ES/XSP/VIX/VVIX). (Sources: `memory/2026-02-23.md:31`, `memory/2026-02-23.md:60`, `memory/2026-02-23.md:61`, `memory/2026-02-23.md:63`, `memory/2026-02-23.md:81`)
- Infrastructure freshness via fast OpenClaw release upgrades and production-safe restarts. (Sources: `memory/2026-02-19.md:3`, `memory/2026-02-19.md:24`, `memory/2026-02-21.md:3`, `memory/2026-02-21.md:12`)
- Group-chat operational usability (no forced @mention requirement). (Sources: `memory/2026-02-23.md:5`, `memory/2026-02-23.md:10`, `memory/2026-02-23.md:15`, `memory/2026-02-23.md:22`)
- Reliable remindering/scheduling before market prep windows. (Sources: `memory/2026-02-20.md:10`, `memory/2026-02-20.md:12`, `memory/2026-02-20.md:16`)

## How Nate Thinks About Trading Content

- Expects weekly thesis -> intraday execution continuity. (Sources: `memory/decision-engine/NATE_SUBSTACK_TEACHINGS_SEARCH_2026-02-24.md:32`, `memory/decision-engine/NATE_SUBSTACK_AI_FRIENDLY_BIBLE_v2.md:13`)
- Uses event-pressure framing (CPI/NFP/FOMC/OpEx/PCE/geopolitics) and volatility regime context. (Sources: `memory/decision-engine/NATE_SUBSTACK_TEACHINGS_SEARCH_2026-02-24.md:30`, `memory/decision-engine/NATE_SUBSTACK_AI_FRIENDLY_BIBLE_v2.md:14`, `memory/decision-engine/NATE_SUBSTACK_AI_FRIENDLY_BIBLE_v2.md:8`)
- Requires level language translation (pivot/support/target) as a practical execution layer. (Sources: `memory/decision-engine/NATE_SUBSTACK_AI_FRIENDLY_BIBLE_v2.md:15`, `memory/decision-engine/NATE_SUBSTACK_AI_FRIENDLY_BIBLE_v2.md:24`)
- Wants actionable outputs that include invalidation logic, not only directional bias. (Source: `memory/decision-engine/NATE_SUBSTACK_AI_FRIENDLY_BIBLE_v2.md:26`)

## Frictions To Avoid

- Do not treat internal confidence/telemetry as runtime truth; Nate expects runtime evidence (deployment ids, logs, endpoint probes). (Sources: `memory/p4nthe0n-openfixer/05_AGENT_QA_ANSWERS.md:3`, `memory/p4nthe0n-openfixer/05_AGENT_QA_ANSWERS.md:5`)
- Do not leave recurring requests undocumented; convert to repeatable ops kits/runbooks. (Sources: `memory/2026-02-25.md:10`, `memory/p4nthe0n-openfixer/09_CHATLOG_REQUEST_TOOLMAP.md:1`)
- Do not block on unnecessary prompts during non-destructive tasks. (Source: `AGENTS.md:319`)

## Little Things (Second-Pass Detail Sweep)

- Nate is latency-sensitive in group ops; degraded responsiveness is noticed quickly, and "fixed" should include before/after behavior notes. (Source: `memory/2026-02-23.md:49`)
- Nate likes low-noise channels: broad group usability without forced mentions and without creating extra chat fragmentation. (Sources: `memory/2026-02-23.md:22`, `memory/2026-02-23.md:50`)
- Nate uses a concrete trigger phrase for trading assistance: "what's the setup?"; Claude should be ready with immediate context-backed output when asked. (Source: `memory/2026-02-23.md:81`)
- Preferred delivery pattern for data pipelines is silent background updates + on-demand interpretation, not constant proactive chatter. (Source: `memory/2026-02-23.md:73`)
- Nate is pragmatic about tooling spend: upgraded TradingView Plus, but accepted a cheaper technical path when it solved the requirement. (Source: `memory/2026-02-23.md:68`)
- Scheduling reliability matters more than ideology: if cron is flaky, switch to the reliable mechanism (heartbeat + JSON reminders). (Sources: `memory/2026-02-04.md:39`, `memory/2026-02-04.md:40`, `memory/2026-02-04.md:67`)
- Nate works in market-time windows (MT) and values reminders tied to pre-market execution timing. (Sources: `memory/2026-02-20.md:5`, `memory/2026-02-20.md:12`)
- Nate wants sub-agents to be outcome-oriented workers that return results ("ping back when done"), not just parallel thinkers. (Source: `memory/2026-02-23.md:45`)
- Nate explicitly requested storytelling delivery support; voice style preference captured: warm/raspy female tone for story moments. (Sources: `memory/2026-02-23.md:40`, `memory/2026-02-25.md:10`)
- Nate is comfortable with hybrid-model workflows (ChatGPT for troubleshooting path + Opus for fix pass) when it reduces turnaround time. (Source: `memory/2026-02-24.md:13`)

## Preferences Cheat-Sheet (Claude Quick Behavior)

- Organize by project/topic, not by spinning up extra chat silos. (Source: `memory/2026-02-23.md:50`)
- Use deterministic tools for recurring asks instead of re-explaining manually each time. (Source: `memory/2026-02-25.md:10`)
- For trading asks, provide immediate setup readout tied to current context files. (Source: `memory/2026-02-23.md:81`)
- For channels, prioritize low-friction usability (open group policy, no unnecessary mention gates). (Sources: `memory/2026-02-23.md:15`, `memory/2026-02-23.md:16`)
- For narrative moments, voice storytelling is welcome and explicitly requested. (Source: `memory/2026-02-23.md:40`)

## Subscriber/Community Signal (from captured chat comments)

These comments indicate the audience context Nate tracks around Alma's stream:

- Audience values deep, meticulous market synthesis and geopolitical-risk framing. (Source: `memory/substack/2025-01-29-board-of-peace-greenland-hidden-left-tail-and-kurtosis-geopo.md:39`)
- Audience asks for concrete structure translation (e.g., skew/odds interpretation), not abstract theory only. (Sources: `memory/substack/2025-01-29-intraday-post-28-feb.md:19`, `memory/substack/2025-01-29-window-of-risk-pt-2-flows-update.md:49`)
- Trust and retention are tied to consistency and clarity of output. (Sources: `memory/substack/2025-01-29-theory-of-reflexivity-by-george-soros.md:39`, `memory/substack/2025-01-29-weekly-post-09-feb-14-feb.md:39`)
- Subscription continuity questions surface and should be answered clearly when relevant. (Source: `memory/substack/2025-01-29-articles-predictions-education.md:39`)
- A portion of users explicitly struggle with complexity; include a compact plain-language summary layer when possible. (Source: `memory/substack/2025-01-29-weekly-post-09-feb-14-feb.md:39`)
- Technical Q&A appetite is high (skew, odds mispricing, long-gamma interpretation, liquidity-risk mechanics); concrete examples are valued. (Sources: `memory/substack/2025-01-29-intraday-post-28-feb.md:19`, `memory/substack/2025-01-29-window-of-risk-pt-2-flows-update.md:49`, `memory/substack/2025-01-29-window-of-risk-pt-2-flows-update.md:44`)
- Reliability/availability issues do appear in audience feedback, so include fallback delivery checks for critical updates. (Source: `memory/substack/2025-01-29-intraday-post-28-aug.md:39`)

## Default Claude Operating Contract For Nate

1. Start with the answer, then show evidence.
2. For ops work, include exact mutation + validation output.
3. For trading synthesis, output: regime state, event pressure, level map, execution bias, invalidation.
4. Convert repeated asks into tools or scripts and document usage.
5. Keep momentum: do not stall on avoidable clarifications.

Grounding references for this contract: `AGENTS.md:315`, `AGENTS.md:317`, `AGENTS.md:319`, `memory/decision-engine/NATE_SUBSTACK_AI_FRIENDLY_BIBLE_v2.md:20`, `memory/decision-engine/NATE_SUBSTACK_AI_FRIENDLY_BIBLE_v2.md:22`, `memory/decision-engine/NATE_SUBSTACK_AI_FRIENDLY_BIBLE_v2.md:26`, `memory/2026-02-25.md:10`.

---

The more you know, the better you can help. But remember — you're learning about a person, not building a dossier. Respect the difference.
