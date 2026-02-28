---
name: context-memory
description: Manage context (active, inbox, ideas, blockers, urgent) and memory (projects, goals, lessons, decisions) as JSON. Use when tracking tasks, ideas, goals, or managing work context.
---

# Context & Memory

JSON-based task and memory management. Structure your thinking with context (ephemeral) and memory (persistent).

## Structure

**Context** (current, temporary):
- `active` — Current work
- `inbox` — Things to process
- `ideas` — Quick brainstorms
- `blockers` — Stuck on what?
- `urgent` — High priority

**Memory** (persistent, curated):
- `projects` — Active/completed projects
- `goals` — Long-term goals
- `lessons` — Things learned
- `decisions` — Important decisions
- `people` — People & relationships

## Quick Commands

### Add item
```bash
scripts/add.py --category inbox --text "Review API docs"
scripts/add.py --category ideas --text "Build feature X"
scripts/add.py --category projects --text "Rewrite auth system"
```

### List category
```bash
scripts/list.py --category active
scripts/list.py --category inbox
scripts/list.py --category projects
```

### List everything
```bash
scripts/list.py --all
```

### Mark done / archive
```bash
scripts/done.py --id abc123                    # Just mark as done
scripts/done.py --id abc123 --move-to-memory projects  # Archive to memory
```

### View raw JSON
```bash
scripts/view.py
```

## Workflow

1. **Quick capture:** Add to inbox or ideas
2. **Process inbox:** Move important items to active or projects
3. **Complete work:** Mark as done, archive to memory if needed
4. **Review memory:** Periodically review lessons, decisions, goals

## Reminders

Add timed reminders that fire during heartbeat checks:

```bash
# Add a reminder in 30 minutes (normal priority)
scripts/remind_add.py --text "Review trading notes" --minutes 30

# Add urgent reminder in 2 hours
scripts/remind_add.py --text "Send files to Alma" --hours 2 --priority high

# Low priority reminder
scripts/remind_add.py --text "Update docs" --minutes 45 --priority low
```

**Priorities:**
- `high` — Shows at top with ❗ formatting
- `normal` — Regular reminders (default)
- `low` — Bottom of list, easy to ignore

**How it works:**
- Reminders are stored in `data.json` with due times
- During heartbeat (~every 30min), `remind_check.py` fires due reminders
- High-priority reminders get your attention immediately
- Fired reminders are marked so they don't repeat

## File Location

Data stored at: `/data/workspace/skills/context-memory/data.json`

Direct edits welcome! It's just JSON.
