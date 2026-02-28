# HEARTBEAT.md

Heartbeat is active in lightweight mode.

Run this sequence on each heartbeat unless explicitly paused by Nate.

1. Check Anthropic usage pressure first:
`python skills/anthropic-usage/scripts/check_usage.py`

2. If usage is high, adapt behavior:
- >80% token window: summarize shorter, avoid long analysis
- >90% token window: use compact responses and defer heavy tasks

3. Check task/notification surfaces if configured:
- Calendar/reminders/email skills from `skills/` that are already connected
- Group mentions and active asks in latest `memory/YYYY-MM-DD.md`

4. If urgent signal is found, send one concise update with proof path.

5. If nothing new, reply `HEARTBEAT_OK`.

Night quiet hours: 23:00-08:00 local unless urgent.

## Alma Heartbeat Checklist

Use this as the default runbook unless Nate says pause.

1. Usage pressure check
- `python skills/anthropic-usage/scripts/check_usage.py`

2. Context pull
- Read today's `memory/YYYY-MM-DD.md`
- If near date boundary, also read yesterday

3. Priority scan
- Upcoming market prep window (~07:00 MT)
- Pending reminders/scheduling drift
- Group operation issues (mentions, response lag)

4. Report policy
- If actionable signal exists: send one concise update with file/command evidence path
- If no signal: `HEARTBEAT_OK`

## Escalation Triggers

- Token usage >90%
- Failed reminder/schedule operation
- Group behavior regression (mention required again)
- Trading data pipeline stale or missing
