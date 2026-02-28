# P4NTHE0N Recorder TUI — Comprehensive Operation Guide

**Version**: 1.1  
**Created**: 2026-02-21  
**Updated**: 2026-02-22  
**Decision**: DECISION_078  
**Author**: WindFixer  
**Status**: Operational

---

## Table of Contents

1. [What Is This?](#what-is-this)
2. [Why a TUI?](#why-a-tui)
3. [Architecture Overview](#architecture-overview)
4. [Getting Started](#getting-started)
5. [The Interface](#the-interface)
6. [Step List View](#step-list-view)
7. [Step Detail View](#step-detail-view)
8. [Edit Mode](#edit-mode)
9. [Run Mode (Macro Playback)](#run-mode-macro-playback)
10. [Breakpoints](#breakpoints)
11. [Conditional Logic (If-Then-Else)](#conditional-logic-if-then-else)
12. [Goto Statements](#goto-statements)
13. [Screenshot Integration](#screenshot-integration)
14. [Workflow: Recording a New Macro](#workflow-recording-a-new-macro)
15. [Workflow: Editing Existing Steps](#workflow-editing-existing-steps)
16. [Workflow: Testing with Breakpoints](#workflow-testing-with-breakpoints)
17. [Workflow: Error Handling with Conditionals](#workflow-error-handling-with-conditionals)
18. [File Format](#file-format)
19. [Keyboard Reference](#keyboard-reference)
20. [Troubleshooting](#troubleshooting)
21. [Advanced Usage](#advanced-usage)
22. [Integration with T00L5ET](#integration-with-t00l5et)
23. [Future Enhancements](#future-enhancements)

---

## What Is This?

The **P4NTHE0N Recorder TUI** is a terminal-based macro editor for creating, editing, and testing navigation workflows for FireKirin and OrionStars game platforms. It provides a visual, interactive interface for building step-by-step automation sequences with precise coordinate control, breakpoints, and live execution preview.

Think of it as a **macro recorder meets debugger** — you define each action (click, type, wait), set verification gates, add breakpoints, and run the entire sequence step-by-step while watching it execute in real-time.

### Core Purpose

The TUI was built to solve a critical problem: **mapping complex Canvas-based game navigation workflows** where traditional DOM inspection fails. FireKirin and OrionStars use Cocos2d-x Canvas rendering, making it impossible to "inspect element" like a normal web app. Instead, you must:

1. Take screenshots at each step
2. Record exact pixel coordinates
3. Document what worked and what didn't
4. Build a reusable automation sequence

The TUI makes this process **visual, iterative, and precise**.

---

## Why a TUI?

### The Problem Before TUI

Before this tool, recording a workflow looked like this:

```bash
# Take screenshot manually
bun run recorder.ts --step --phase=Login --screenshot=001.png --session-dir="..." --run-tool=diag

# Edit step-config.json in a text editor
# Copy/paste coordinates from screenshots
# Hope you didn't break the JSON syntax
# Run again, repeat 50 times
```

**Pain points:**
- No visual feedback on what step you're editing
- Easy to break JSON syntax
- No way to test individual steps
- No breakpoints for debugging
- Coordinate editing required calculator + screenshot viewer

### The Solution: TUI

Now you:

1. Launch `bun run recorder-tui.ts`
2. See all 14 steps in a scrollable list
3. Press `E` to edit step 6
4. Use arrow keys to navigate fields
5. Press `Enter` to change coordinates from `(553, 567)` to `(560, 570)`
6. Press `Esc` to save
7. Press `R` to run from step 6 with a breakpoint
8. Watch it execute, pause at the breakpoint, verify it worked
9. Press `Space` to continue

**All in one interface. No context switching. No broken JSON. No guessing.**

---

## Architecture Overview

### Zero Dependencies

The TUI is built with **zero external dependencies** beyond Bun's built-in Node.js compatibility layer. It uses:

- **Raw ANSI escape codes** for colors, cursor movement, and box drawing
- **process.stdin in raw mode** for keyboard input
- **Pure TypeScript** for all logic

This makes it:
- ✅ Fast (no framework overhead)
- ✅ Portable (works anywhere Bun runs)
- ✅ Maintainable (no dependency hell)
- ✅ Debuggable (you can read every line)

### File Structure

```
H4ND/tools/recorder/
├── recorder-tui.ts          # Entry point
├── tui/
│   ├── types.ts             # MacroStep, AppState, ViewMode types
│   ├── screen.ts            # ANSI rendering primitives
│   └── app.ts               # Main TUI app (state machine + views)
├── step-config.json         # Your workflow data (14 steps)
└── TUI_README.md            # This file
```

### State Machine

The TUI operates as a **state machine** with 6 views:

| View | Purpose | Entry | Exit |
|------|---------|-------|------|
| `step-list` | Browse all steps | Default | Enter/E/R/? |
| `step-detail` | View single step details | Enter from list | Esc/Q/E |
| `step-edit` | Edit step fields | E from list/detail | Esc/Q |
| `run-mode` | Execute steps with breakpoints | R from list | Esc/Q/completion |
| `help` | Keyboard shortcuts | ? from list | Any key |

Each view has its own:
- **Render function** (draws the screen)
- **Input handler** (processes keystrokes)
- **State transitions** (moves to other views)

---

## Getting Started

### Prerequisites

1. **Bun installed** (`bun --version` should work)
2. **Terminal with ANSI support** (Windows Terminal, iTerm2, any modern terminal)
3. **Chrome with CDP** (for screenshot integration, optional for editing)

### Launch

```bash
cd C:\P4NTHE0N\H4ND\tools\recorder
bun run recorder-tui.ts
```

You'll see:

```
┌─ P4NTHE0N RECORDER v1.0  FireKirin [UNSAVED]  step-list ────────────────┐
│                                                                          │
│ ┌─ Steps ──────────────────────────────────────────────────────────────┐│
│ │  ▸  1 [Login] navigate (diag)                                       ││
│ │     2 [Login] click (460,367) 📸                                     ││
│ │     3 [Login] type "JustinHu21"                                      ││
│ │     4 [Login] click (460,437) 📸                                     ││
│ │     5 [Login] type "abc123"                                          ││
│ │  🔴 6 [Login] click (553,567) 📸 (login)                             ││
│ │     7 [Login] wait 3000ms 📸                                         ││
│ │  ...                                                                 ││
│ └──────────────────────────────────────────────────────────────────────┘│
│                                                                          │
│ Add  Edit  Del  Breakpt  Run  Screenshot  Clone  Up  JDown  Platform  ?Help  Quit
└──────────────────────────────────────────────────────────────────────────┘
 Steps: 14 | Breakpoints: 2 | Platform: firekirin
```

### First Actions

1. **Navigate**: Use `↑/↓` to move through steps
2. **View details**: Press `Enter` to see full step info
3. **Edit a step**: Press `E` to enter edit mode
4. **Add a step**: Press `A` to insert after cursor
5. **Save**: Press `Ctrl+S` (or just quit with `Q` — auto-saves)

---

## The Interface

### Header Bar

```
┌─ P4NTHE0N RECORDER v1.0  FireKirin [UNSAVED]  step-list ────────────────┐
```

- **Title**: Always shows "P4NTHE0N RECORDER v1.0"
- **Platform**: Current platform (FireKirin or OrionStars)
- **[UNSAVED]**: Appears when you have unsaved changes
- **View mode**: Current view (step-list, step-edit, run-mode, etc.)

### Main Panel

The center area changes based on the current view:
- **Step List**: Scrollable list of all steps
- **Step Detail**: Full details of selected step
- **Edit Mode**: Field editor with cursor
- **Run Mode**: Live execution with progress bar

### Hotkey Bar

```
 Add  Edit  Del  Breakpt  Run  Screenshot  Clone  Up  JDown  Platform  ?Help  Quit
```

Shows available actions for the current view. **Bold letters** indicate the key to press.

### Status Bar

```
 Steps: 14 | Breakpoints: 2 | Platform: firekirin
```

Shows:
- Total step count
- Number of breakpoints set
- Current platform
- Or: temporary status messages (e.g., "Saved!", "Screenshot captured")

---

## Step List View

This is the **main view** where you spend most of your time.

### Visual Elements

Each step shows:

```
  ▸  1 [Login] navigate (diag)
     2 [Login] click (460,367) 📸
  🔴 6 [Login] click (553,567) 📸 (login)
```

- **`▸`**: Cursor (current selection)
- **`🔴`**: Breakpoint marker
- **Step number**: Auto-renumbered when you add/delete
- **`[Login]`**: Phase badge (color-coded)
- **Action**: `click`, `type`, `wait`, `navigate`
- **Coordinates**: `(x, y)` for click actions
- **`📸`**: Screenshot indicator
- **Tool**: `(diag)`, `(login)`, `(nav)` if a tool is used

### Phase Colors

- **[Login]**: Green
- **[GameSelection]**: Blue
- **[Spin]**: Yellow
- **[Logout]**: Red
- **[DismissModals]**: Magenta

### Right Panel: Details

The right side shows details of the **currently selected step**:

```
┌─ Details ─────────────────────┐
│ Step 6                        │
│ Phase:  Login                 │
│ Action: click                 │
│ Tool:   login                 │
│ Coords: 553, 567              │
│ Delay:  2000ms                │
│ Screenshot: Yes               │
│ Breakpoint: Yes               │
│                               │
│ Click LOGIN button - loading  │
│ spinner appeared              │
│                               │
│ Entry: Credentials entered    │
│ Exit:  Login request sent     │
└───────────────────────────────┘
```

### Actions

| Key | Action | Description |
|-----|--------|-------------|
| `↑/↓` | Navigate | Move cursor up/down |
| `Enter` | View Detail | Open step detail view |
| `A` | Add Step | Insert new step after cursor |
| `E` | Edit Step | Open edit mode for current step |
| `D` | Delete Step | Remove current step (renumbers rest) |
| `C` | Clone Step | Duplicate current step |
| `B` | Toggle Breakpoint | Add/remove breakpoint marker |
| `U` | Move Up | Swap with previous step |
| `J` | Move Down | Swap with next step |
| `R` | Run | Start macro playback from cursor |
| `S` | Screenshot | Take CDP screenshot (requires Chrome) |
| `P` | Toggle Platform | Switch between FireKirin/OrionStars |
| `?` | Help | Show keyboard reference |
| `Q` | Quit | Save and exit |
| `Ctrl+S` | Save | Save without exiting |

---

## Step Detail View

Press `Enter` on any step to see full details.

### What You See

```
┌─ Step 6 Detail ───────────────────────────────────────────────────────┐
│                                                                        │
│ Step 6: Login                                                          │
│                                                                        │
│ Phase:           [Login]                                               │
│ Action:          click                                                 │
│ Tool:            login                                                 │
│ Coordinates:     (553, 567)                                            │
│ Input:           —                                                     │
│ Delay:           2000ms                                                │
│ Screenshot:      Yes                                                   │
│ Screenshot Why:  Login button clicked, authentication in progress     │
│ Breakpoint:      🔴 Yes                                                │
│                                                                        │
│ Comment:                                                               │
│ Click LOGIN button - loading spinner appeared                         │
│                                                                        │
│ Verification:                                                          │
│   Entry: Credentials entered                                          │
│   Exit:  Login request sent, waiting for response                     │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
 Edit  Breakpoint  Esc/Q Back
```

### Actions

| Key | Action |
|-----|--------|
| `E` or `Enter` | Edit this step |
| `B` | Toggle breakpoint |
| `Esc` or `Q` | Back to step list |

---

## Edit Mode

Press `E` from step list or detail view to edit a step.

### The Field Editor

```
┌─ Edit Step 6 ─────────────────────────────────────────────────────────┐
│                                                                        │
│   ▸ Phase              Login (Enter to cycle)                         │
│     Action             click (Enter to cycle)                         │
│     Tool               login (Enter to cycle)                         │
│     Coord X            553                                             │
│     Coord Y            567                                             │
│     Input Text         (empty)                                         │
│     Delay (ms)         2000                                            │
│     Screenshot         Yes (Enter to cycle)                           │
│     Screenshot Why     Login button clicked, authentication in...     │
│     Comment            Click LOGIN button - loading spinner appeared  │
│     Entry Gate         Credentials entered                            │
│     Exit Gate          Login request sent, waiting for response       │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
 ↑↓ Navigate  Enter Edit/Cycle  Tab Next  Esc/Q Save & Back
```

### Field Types

**Cycle Fields** (press `Enter` to cycle through options):
- **Phase**: Login → GameSelection → Spin → Logout → DismissModals
- **Action**: click → type → longpress → navigate → wait
- **Tool**: diag → login → nav → credcheck → none
- **Screenshot**: Yes → No

**Text Fields** (press `Enter` to edit):
- **Coord X/Y**: Type numbers, press `Enter` to commit
- **Input Text**: Type text (for `type` actions)
- **Delay (ms)**: Milliseconds to wait after action
- **Screenshot Why**: Reason for taking screenshot
- **Comment**: Free-form notes
- **Entry Gate**: Precondition for this step
- **Exit Gate**: Expected result after step

### Editing Text Fields

1. Navigate to field with `↑/↓`
2. Press `Enter` — field turns blue with cursor
3. Type your text (backspace works)
4. Press `Enter` to commit
5. Press `Esc` to cancel

### Example: Changing Coordinates

**Before:**
```
  Coord X            553
  Coord Y            567
```

**Steps:**
1. Navigate to "Coord X"
2. Press `Enter` — field becomes editable: `553█`
3. Backspace 3 times, type `560`
4. Press `Enter` — committed
5. Navigate to "Coord Y"
6. Press `Enter`, backspace 3 times, type `570`
7. Press `Enter`
8. Press `Esc` to save and return to list

**After:**
```
  Coord X            560
  Coord Y            570
```

### Actions

| Key | Action |
|-----|--------|
| `↑/↓` | Navigate fields |
| `Enter` | Edit text field / Cycle option |
| `Tab` | Jump to next field |
| `Esc` or `Q` | Save changes and return to list |

---

## Run Mode (Macro Playback)

Press `R` from step list to execute steps starting from the cursor.

### What Happens

1. All steps are marked as `pending` (gray circle `○`)
2. Current step is marked as `running` (yellow spinner `⟳`)
3. You press `Space` to execute the step
4. Step completes and is marked `passed` (green checkmark `✓`) or `failed` (red X `✗`)
5. Cursor advances to next step
6. If a breakpoint is hit, execution pauses
7. Press `Space` to continue, or `Esc` to abort

### The Interface

```
┌─ Run Mode ────────────────────────────────────────────────────────────┐
│                                                                        │
│ Progress: ████████████░░░░░░░░░░ 6/14                                 │
│                                                                        │
│  ✓  1 [Login] navigate (diag)                                         │
│  ✓  2 [Login] click (460,367)                                         │
│  ✓  3 [Login] type "JustinHu21"                                       │
│  ✓  4 [Login] click (460,437)                                         │
│  ✓  5 [Login] type "abc123"                                           │
│  ⟳ 🔴 6 [Login] click (553,567) (login)                               │
│  ○  7 [Login] wait 3000ms                                             │
│  ○  8 [GameSelection] click (37,465)                                  │
│  ...                                                                   │
│                                                                        │
│ ┌──────────────────────────────────────────────────────────────────┐ │
│ │ BREAKPOINT — Press Space to continue                             │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
 Space Step/Continue  Esc/Q Abort
```

### Status Icons

| Icon | Meaning |
|------|---------|
| `○` | Pending (not yet executed) |
| `⟳` | Running (currently executing) |
| `✓` | Passed (completed successfully) |
| `✗` | Failed (error occurred) |
| `🔴` | Breakpoint marker |

### Execution Flow

**Normal step:**
1. Step is marked `running`
2. You press `Space`
3. Step executes (simulated in TUI, real execution via T00L5ET integration)
4. Step is marked `passed`
5. Cursor advances

**Breakpoint step:**
1. Step is marked `running`
2. Red banner appears: "BREAKPOINT — Press Space to continue"
3. Execution pauses
4. You can inspect the state (e.g., check Chrome, verify screenshot)
5. Press `Space` to continue
6. Step executes
7. Cursor advances

### Actions

| Key | Action |
|-----|--------|
| `Space` | Execute current step / Continue past breakpoint |
| `Esc` or `Q` | Abort run and return to step list |

---

## Breakpoints

Breakpoints are **pause points** in your workflow. When you run a macro, execution stops at each breakpoint, allowing you to:

- Verify the game state visually
- Check Chrome DevTools
- Review screenshots
- Confirm coordinates are correct
- Debug why a step is failing

### Setting Breakpoints

**From Step List:**
1. Navigate to the step
2. Press `B`
3. A red dot `🔴` appears next to the step number

**From Edit Mode:**
- Breakpoints are not directly editable in edit mode
- Use step list or detail view

**From Detail View:**
1. Press `B` to toggle

### Strategic Breakpoint Placement

**Good places for breakpoints:**
- ✅ After login (verify lobby loaded)
- ✅ After game selection (verify game loaded)
- ✅ Before first spin (verify SPIN button visible)
- ✅ After critical navigation (verify page transition)

**Bad places for breakpoints:**
- ❌ Every single step (too slow)
- ❌ In the middle of a typing sequence (breaks flow)

### Example Workflow with Breakpoints

```
Step 1-5: Login sequence (no breakpoints)
Step 6:   Click LOGIN button (BREAKPOINT) ← Verify lobby loaded
Step 7-8: Navigate to SLOT category (no breakpoints)
Step 9:   Click first game (BREAKPOINT) ← Verify game loaded
Step 10-12: Spin sequence (no breakpoints)
```

When you run this:
1. Steps 1-5 execute automatically
2. Pause at step 6 — you check if lobby appeared
3. Press `Space` to continue
4. Steps 7-8 execute automatically
5. Pause at step 9 — you check if game loaded
6. Press `Space` to continue
7. Steps 10-12 execute automatically
8. Run complete

---

## Conditional Logic (If-Then-Else)

**New in v1.1** — The TUI now supports **conditional logic** for error handling workflows. Define what happens when errors occur during navigation.

### What Is Conditional Logic?

Conditional logic lets you define **if-then-else** branches in your workflow:

```
IF error message appears
  THEN restart from step 1
  ELSE continue to next step
```

This allows you to:
- ✅ Handle server busy errors automatically
- ✅ Retry when elements don't load
- ✅ Restart login when session expires
- ✅ Abort on fatal errors (account banned)

### Visual Indicators

Steps with conditional logic show `[IF]` in the step list:

```
  ▸  5 [Login] type "abc123"
  🔴 6 [Login] click (553,567) 📸 [IF] (login)
     7 [Login] wait 3000ms 📸
```

### Adding Conditional Logic

**From Step List:**
1. Navigate to the step
2. Press `C` (Edit Conditional)
3. Conditional editor opens

**From Edit Mode:**
1. Navigate to "conditional" field
2. Press `Enter`
3. Conditional editor opens

### The Conditional Editor

The editor has three sections:

#### 1. CONDITION Section (What to Check)

```
▶ CONDITION (what to check)
→ Type        : element-exists
  Target      : .error-message
  CDP Cmd     : (empty)
  Description : Check if error message appeared
```

**Condition Types:**
- `element-exists` — Check if DOM element exists
- `element-missing` — Check if element is absent
- `text-contains` — Check if page contains text
- `cdp-check` — Run CDP command
- `tool-success` — Check if tool passed
- `tool-failure` — Check if tool failed
- `custom-js` — Run custom JavaScript

**Fields:**
- **Type**: Cycle through condition types with `Enter`
- **Target**: Element selector, text, or JS expression
- **CDP Cmd**: CDP command JSON (for cdp-check type)
- **Description**: Human-readable explanation

#### 2. ON TRUE Section (What to Do If True)

```
▶ ON TRUE (what to do)
→ Action      : goto
  Goto Step   : 1
  Retry Count : (empty)
  Retry Delay : (empty)
  Comment     : Error detected - restart
```

**Branch Actions:**
- `continue` — Proceed to next step
- `goto` — Jump to specific step number
- `retry` — Retry current step N times
- `abort` — Stop workflow immediately

**Fields:**
- **Action**: What to do (cycle with `Enter`)
- **Goto Step**: Step number (required for goto)
- **Retry Count**: Number of retries (required for retry)
- **Retry Delay**: Milliseconds between retries
- **Comment**: Explanation of this branch

#### 3. ON FALSE Section (What to Do If False)

Same fields as ON TRUE section.

#### 4. Preview Section

Shows formatted preview:

```
Preview:
  IF Check if error message appeared
    THEN goto step 1 (Error detected - restart)
    ELSE continue to next step (No error - proceed)
```

### Conditional Editor Controls

| Key | Action |
|-----|--------|
| `↑/↓` | Navigate fields |
| `Tab` | Switch sections (Condition → OnTrue → OnFalse) |
| `Enter` | Edit selected field |
| `Esc` | Cancel field edit or exit editor |
| `Ctrl+S` | Save conditional logic |
| `Ctrl+D` | Delete conditional logic |
| `Ctrl+C` | Cancel and exit without saving |

### Example: Handle Server Busy Error

**Step 6: Click LOGIN button**

Conditional:
```
IF text-contains "server is busy"
  THEN retry 5 times with 5000ms delay
  ELSE continue
```

**What happens:**
1. Step 6 executes (click LOGIN)
2. Condition checks if "server is busy" appears
3. If TRUE: Retry step 6 up to 5 times with 5-second delays
4. If FALSE: Continue to step 7

### Example: Restart on Session Expired

**Step 10: Navigate to game**

Conditional:
```
IF text-contains "Session expired"
  THEN goto step 1
  ELSE continue
```

**What happens:**
1. Step 10 executes
2. Condition checks for "Session expired" message
3. If TRUE: Jump back to step 1 (restart login)
4. If FALSE: Continue to step 11

### Example: Abort on Fatal Error

**Step 2: Enter credentials**

Conditional:
```
IF element-exists ".account-banned"
  THEN abort
  ELSE continue
```

**What happens:**
1. Step 2 executes
2. Condition checks for account banned message
3. If TRUE: Abort entire workflow
4. If FALSE: Continue to step 3

### Best Practices

1. **Use descriptive descriptions** — "Check if login error appears" not "Check error"
2. **Add comments to branches** — Explain why each path is taken
3. **Prefer retry for transient errors** — Network issues, loading delays
4. **Use goto for recoverable errors** — Session expired, need re-login
5. **Reserve abort for fatal errors** — Account banned, system down
6. **Limit retry counts** — Max 10 to avoid infinite loops
7. **Use appropriate delays** — 2-5 seconds between retries

---

## Goto Statements

**New in v1.1** — Simple goto statements for error recovery without complex conditionals.

### What Is a Goto Statement?

A goto statement tells the workflow: **"If this step fails, jump to step N"**.

It's simpler than conditional logic — no if-then-else, just a fallback step number.

### Visual Indicators

Steps with goto show `[→N]` in the step list:

```
  ▸  5 [Login] type "abc123"
     6 [Login] click (553,567) 📸 [→1] (login)
     7 [Login] wait 3000ms 📸
```

This means: "If step 6 fails, jump to step 1".

### Setting a Goto Target

**From Step List:**
1. Navigate to the step
2. Press `G` (Set Goto)
3. Enter step number
4. Press `Enter`

**From Edit Mode:**
1. Navigate to "gotoStep" field
2. Press `Enter`
3. Type step number
4. Press `Enter`

### Example: Simple Error Recovery

**Step 6: Click LOGIN button**

Goto: `1`

**What happens:**
- If step 6 succeeds → Continue to step 7
- If step 6 fails → Jump to step 1 (restart login)

### Goto vs. Conditional Logic

**Use Goto when:**
- ✅ Simple failure recovery ("if fails, restart")
- ✅ No need to check specific conditions
- ✅ One fallback path is sufficient

**Use Conditional Logic when:**
- ✅ Need to check specific error messages
- ✅ Different actions for different errors
- ✅ Need retry with delay
- ✅ Need to abort on fatal errors

### Combining Goto and Conditional

You can use both on the same step:

```
Step 6: Click LOGIN button
  Goto: 1 (fallback if step fails)
  Conditional:
    IF text-contains "server is busy"
      THEN retry 5 times with 5000ms delay
      ELSE continue
```

**Execution order:**
1. Step 6 executes
2. Conditional is evaluated first
3. If conditional doesn't trigger, goto is used on failure

### Visual Indicators for Both

Steps with both show `[IF→N]`:

```
  🔴 6 [Login] click (553,567) 📸 [IF→1] (login)
```

---

## Screenshot Integration

The TUI integrates with Chrome DevTools Protocol (CDP) for screenshot capture.

### Taking Screenshots

**From Step List:**
1. Press `S`
2. TUI checks if Chrome is running on port 9222
3. If connected: "Screenshot captured (CDP connected)"
4. If not: "CDP not running — start Chrome first"

**Automatic Screenshots:**
- Steps with `takeScreenshot: true` will trigger screenshots during run mode
- Screenshot files are saved to the session directory
- Filenames match the step number (e.g., `002_account_focused.png`)

### Screenshot Workflow

**Manual Recording:**
1. Start Chrome with CDP: `chrome.exe --remote-debugging-port=9222`
2. Navigate to the game page
3. In TUI, navigate to step 2 (click account field)
4. Press `S` to capture current state
5. Perform the action manually in Chrome (click account field)
6. Navigate to step 3 in TUI
7. Press `S` to capture new state
8. Repeat for each step

**Automated Recording:**
- Use `recorder.ts --step` mode for automated screenshot capture
- TUI is for **editing** and **testing** the workflow
- For initial recording, use the CLI recorder

### Screenshot Metadata

Each step can have:
- **`takeScreenshot`**: Yes/No (toggle in edit mode)
- **`screenshotReason`**: Why this screenshot is important (text field)

Example:
```
Step 6:
  takeScreenshot: Yes
  screenshotReason: "Login button clicked, authentication in progress"
```

This helps you remember **why** you took a screenshot when reviewing the workflow later.

---

## Workflow: Recording a New Macro

### Scenario: You want to record OrionStars login

**Step 1: Start with an empty config**

```bash
cd C:\P4NTHE0N\H4ND\tools\recorder
cp step-config.json step-config-firekirin-backup.json
# Edit step-config.json, set steps: []
bun run recorder-tui.ts
```

**Step 2: Add first step**

1. Press `A` (add step)
2. TUI creates step 1 with defaults
3. Edit mode opens automatically
4. Navigate to "Phase" → press `Enter` until it shows "Login"
5. Navigate to "Action" → press `Enter` until it shows "navigate"
6. Navigate to "Tool" → press `Enter` until it shows "diag"
7. Navigate to "Comment" → press `Enter` → type "Navigate to OrionStars URL"
8. Press `Esc` to save

**Step 3: Add click step**

1. Press `A` (add step after step 1)
2. Navigate to "Action" → cycle to "click"
3. Navigate to "Coord X" → press `Enter` → type `465` → press `Enter`
4. Navigate to "Coord Y" → press `Enter` → type `690` → press `Enter`
5. Navigate to "Comment" → type "Click LOGIN button on guest lobby"
6. Navigate to "Screenshot" → press `Enter` to toggle to "Yes"
7. Navigate to "Screenshot Why" → type "Login form appeared"
8. Press `Esc`

**Step 4: Add type step**

1. Press `A`
2. Navigate to "Action" → cycle to "type"
3. Navigate to "Input Text" → type "JustinHU6os"
4. Navigate to "Comment" → type "Type username"
5. Press `Esc`

**Step 5: Test with breakpoints**

1. Navigate to step 2 (click LOGIN)
2. Press `B` to set breakpoint
3. Press `R` to run from step 1
4. Steps execute, pause at step 2
5. Verify login form appeared in Chrome
6. Press `Space` to continue

**Step 6: Save and iterate**

1. Press `Ctrl+S` to save
2. Continue adding steps
3. Test each section with breakpoints
4. Refine coordinates as needed

---

## Workflow: Editing Existing Steps

### Scenario: FireKirin login coordinates changed

**Problem:** The LOGIN button moved from `(553, 567)` to `(560, 570)`.

**Solution:**

1. Launch TUI: `bun run recorder-tui.ts`
2. Navigate to step 6 (LOGIN button click)
3. Press `E` to edit
4. Navigate to "Coord X"
5. Press `Enter` → backspace → type `560` → press `Enter`
6. Navigate to "Coord Y"
7. Press `Enter` → backspace → type `570` → press `Enter`
8. Press `Esc` to save
9. Press `R` to test from step 6
10. Set breakpoint on step 6 with `B`
11. Press `Space` to execute
12. Verify click hit the right spot
13. Press `Q` to quit (auto-saves)

**Time saved:** 30 seconds vs. 5 minutes of JSON editing + validation.

---

## Workflow: Testing with Breakpoints

### Scenario: OrionStars login is failing at step 3 (type username)

**Debugging Strategy:**

1. Set breakpoints on steps 2, 3, 4
2. Run from step 1
3. Pause at step 2 (click account field)
   - Check Chrome: Is the field focused?
   - Check screenshot: Does it match expected state?
4. Press `Space` to continue
5. Pause at step 3 (type username)
   - Check Chrome: Is the virtual keyboard visible?
   - Check DevTools console: Any errors?
6. Press `Space` to execute type action
7. Pause at step 4 (click password field)
   - Check Chrome: Did the username appear?
   - If not: The issue is in step 3

**Root Cause Found:** Canvas input doesn't accept CDP typing.

**Solution:** Document in step 3 comment:
```
Comment: "BLOCKED - Canvas field does not accept CDP typing. 
          Requires FourEyes integration or alternative input method."
```

Mark step 3 with a breakpoint permanently so you remember it's a known issue.

---

## Workflow: Error Handling with Conditionals

### Scenario: FireKirin login fails with "server is busy" error

**Problem:** Login sometimes fails with a server busy message that requires waiting and retrying.

**Solution with Conditional Logic:**

**Step 1: Navigate to step 6 (LOGIN button click)**
```bash
bun run recorder-tui.ts
# Navigate to step 6
```

**Step 2: Add conditional logic**
1. Press `C` to open conditional editor
2. Navigate to "Type" → press `Enter` until "text-contains"
3. Navigate to "Target" → press `Enter` → type "server is busy"
4. Navigate to "Description" → type "Check for server busy message"
5. Press `Tab` to switch to ON TRUE section

**Step 3: Configure retry on error**
1. Navigate to "Action" → press `Enter` until "retry"
2. Navigate to "Retry Count" → press `Enter` → type "5"
3. Navigate to "Retry Delay" → press `Enter` → type "5000"
4. Navigate to "Comment" → type "Server busy - wait 5s and retry"
5. Press `Tab` to switch to ON FALSE section

**Step 4: Configure success path**
1. Navigate to "Action" → ensure it shows "continue"
2. Navigate to "Comment" → type "Server ready - proceed"
3. Press `Ctrl+S` to save

**Step 5: Test the workflow**
1. Press `Esc` to return to step list
2. Set breakpoint on step 6 with `B`
3. Press `R` to run from step 1
4. When step 6 executes:
   - If "server is busy" appears → Automatically retries 5 times
   - If no error → Continues to step 7

**Result:** Workflow now handles server busy errors automatically without manual intervention.

### Scenario: Session expires during game selection

**Problem:** Session sometimes expires after login, requiring restart.

**Solution with Goto Statement:**

**Step 1: Navigate to step 9 (game selection)**

**Step 2: Set goto target**
1. Press `G` (Set Goto)
2. Type "1" (restart from login)
3. Press `Enter`

**Step 3: Add conditional for session check**
1. Press `C` to open conditional editor
2. Configure condition:
   - Type: `text-contains`
   - Target: `Session expired`
   - Description: `Check if session expired during navigation`
3. Configure ON TRUE:
   - Action: `goto`
   - Goto Step: `1`
   - Comment: `Session expired - restart login`
4. Configure ON FALSE:
   - Action: `continue`
   - Comment: `Session valid - continue`
5. Press `Ctrl+S` to save

**Step 4: Test**
1. Run workflow
2. If session expires at step 9 → Jumps to step 1
3. If session valid → Continues to step 10

**Result:** Workflow automatically recovers from session expiration.

---

## File Format

The TUI reads and writes `step-config.json` in this format:

```json
{
  "platform": "firekirin",
  "decision": "DECISION_077",
  "sessionNotes": "FireKirin workflow VERIFIED working.",
  "steps": [
    {
      "stepId": 1,
      "phase": "Login",
      "takeScreenshot": true,
      "screenshotReason": "Initial state - login page",
      "comment": "Navigate to FireKirin URL",
      "tool": "diag",
      "action": "navigate",
      "delayMs": 2000,
      "breakpoint": false,
      "verification": {
        "entryGate": "Chrome CDP running",
        "exitGate": "Page loaded, login form visible"
      }
    },
    {
      "stepId": 2,
      "phase": "Login",
      "takeScreenshot": true,
      "screenshotReason": "Account field focused",
      "comment": "Click account field",
      "tool": "none",
      "action": "click",
      "coordinates": { "x": 460, "y": 367 },
      "delayMs": 500,
      "breakpoint": false,
      "verification": {
        "entryGate": "Login form visible",
        "exitGate": "Account field has focus"
      }
    }
  ],
  "metadata": {
    "created": "2026-02-21",
    "modified": "2026-02-21",
    "coordinates": {
      "firekirin": {
        "account": { "x": 460, "y": 367 },
        "password": { "x": 460, "y": 437 },
        "login": { "x": 553, "y": 567 }
      }
    },
    "credentials": {
      "firekirin": {
        "username": "JustinHu21",
        "password": "abc123",
        "source": "MongoDB CRED3N7IAL collection"
      }
    }
  }
}
```

### Field Reference

| Field | Type | Description |
|-------|------|-------------|
| `stepId` | number | Auto-renumbered by TUI |
| `phase` | string | Login, GameSelection, Spin, Logout, DismissModals |
| `takeScreenshot` | boolean | Whether to capture screenshot |
| `screenshotReason` | string | Why this screenshot matters |
| `comment` | string | Free-form notes |
| `tool` | string | diag, login, nav, credcheck, none |
| `action` | string | click, type, longpress, navigate, wait |
| `coordinates` | object | `{x, y}` for click actions |
| `input` | string | Text to type (for type actions) |
| `delayMs` | number | Milliseconds to wait after action |
| `breakpoint` | boolean | Pause execution here |
| `gotoStep` | number | Step to jump to on failure (optional) |
| `conditional` | object | If-then-else logic (optional) |
| `conditional.condition` | object | Condition to check |
| `conditional.condition.type` | string | element-exists, element-missing, text-contains, cdp-check, tool-success, tool-failure, custom-js |
| `conditional.condition.target` | string | Element selector, text, or JS expression |
| `conditional.condition.description` | string | Human-readable condition explanation |
| `conditional.onTrue` | object | Branch to execute if condition is true |
| `conditional.onTrue.action` | string | continue, goto, retry, abort |
| `conditional.onTrue.gotoStep` | number | Step number (for goto action) |
| `conditional.onTrue.retryCount` | number | Number of retries (for retry action) |
| `conditional.onTrue.retryDelayMs` | number | Delay between retries in ms |
| `conditional.onTrue.comment` | string | Explanation of this branch |
| `conditional.onFalse` | object | Branch to execute if condition is false |
| `verification.entryGate` | string | Precondition |
| `verification.exitGate` | string | Expected result |

---

## Keyboard Reference

### Global Keys (All Views)

| Key | Action |
|-----|--------|
| `Ctrl+C` | Quit immediately (auto-saves) |
| `Ctrl+S` | Save without quitting |
| `Q` | Quit (auto-saves) |

### Step List View

| Key | Action |
|-----|--------|
| `↑/↓` | Navigate steps |
| `Enter` | View step detail |
| `A` | Add step after cursor |
| `E` | Edit current step |
| `D` | Delete current step |
| `C` | Clone current step |
| `B` | Toggle breakpoint |
| `C` | Edit conditional logic |
| `G` | Set goto target |
| `V` | View conditional (if present) |
| `X` | Clear conditional |
| `U` | Move step up |
| `J` | Move step down |
| `R` | Run from cursor |
| `S` | Take screenshot (CDP) |
| `P` | Toggle platform |
| `?` or `H` | Help screen |

### Step Detail View

| Key | Action |
|-----|--------|
| `E` or `Enter` | Edit step |
| `B` | Toggle breakpoint |
| `Esc` or `Q` | Back to list |

### Edit Mode

| Key | Action |
|-----|--------|
| `↑/↓` | Navigate fields |
| `Enter` | Edit text field / Cycle option / Open conditional editor |
| `Tab` | Next field |
| `Esc` or `Q` | Save and back to list |

### Conditional Editor

| Key | Action |
|-----|--------|
| `↑/↓` | Navigate fields |
| `Tab` | Switch sections (Condition → OnTrue → OnFalse) |
| `Enter` | Edit selected field |
| `Esc` | Cancel field edit or exit editor |
| `Ctrl+S` | Save conditional logic |
| `Ctrl+D` | Delete conditional logic |
| `Ctrl+C` | Cancel without saving |

**While Editing Text:**
| Key | Action |
|-----|--------|
| `Enter` | Commit changes |
| `Esc` | Cancel edit |
| `Backspace` | Delete character |
| Any printable char | Type |

### Run Mode

| Key | Action |
|-----|--------|
| `Space` | Execute step / Continue |
| `Esc` or `Q` | Abort run |

### Help Screen

| Key | Action |
|-----|--------|
| Any key | Return to step list |

---

## Troubleshooting

### TUI Won't Start

**Error:** `Error: TUI requires an interactive terminal (TTY).`

**Cause:** You piped the output or ran it in a non-interactive shell.

**Fix:** Run directly in a terminal:
```bash
bun run recorder-tui.ts
```

### Screen Looks Garbled

**Cause:** Terminal doesn't support ANSI escape codes.

**Fix:** Use a modern terminal:
- Windows: Windows Terminal (recommended), ConEmu
- macOS: iTerm2, Terminal.app
- Linux: Any terminal (they all support ANSI)

### Can't Type in Edit Mode

**Cause:** You're in navigation mode, not text input mode.

**Fix:** Press `Enter` on the field first, **then** type.

### Breakpoints Don't Work

**Cause:** Breakpoints only work in Run Mode (`R`), not in step list.

**Fix:** Press `R` to enter run mode, then `Space` to execute steps.

### Screenshot Says "CDP not running"

**Cause:** Chrome isn't running with remote debugging enabled.

**Fix:**
```bash
chrome.exe --remote-debugging-port=9222
```

Or use the recorder's auto-start (from `recorder.ts --step`).

### Changes Not Saving

**Cause:** You didn't press `Esc` to exit edit mode, or you force-quit with Ctrl+C before save.

**Fix:** Always press `Esc` or `Q` to exit gracefully. The TUI auto-saves on quit.

### Step Numbers Are Wrong

**Cause:** You deleted or added steps.

**Fix:** Step numbers auto-renumber. This is intentional. The `stepId` field is always sequential.

---

## Advanced Usage

### Custom Config Path

```bash
bun run recorder-tui.ts --config=C:\path\to\my-workflow.json
```

### Multiple Workflows

Keep separate configs for different games:

```bash
# FireKirin workflow
bun run recorder-tui.ts --config=step-config-firekirin.json

# OrionStars workflow
bun run recorder-tui.ts --config=step-config-orionstars.json
```

### Coordinate Precision

For pixel-perfect clicks:
1. Take a screenshot
2. Open in an image editor (Paint, GIMP, Photoshop)
3. Hover over the target element
4. Note the exact `(x, y)` coordinates
5. Enter in TUI edit mode

### Verification Gates

Use verification gates to document expected state:

**Entry Gate:** What must be true before this step runs?
- "Login form visible"
- "Balance > 0"
- "SPIN button clickable"

**Exit Gate:** What should be true after this step?
- "Lobby loaded"
- "Game started"
- "Reels spinning"

This helps you debug failures — if the entry gate isn't met, the step can't succeed.

### Progress Indicators

For long-running steps (e.g., waiting for lobby to load), add progress indicators:

```json
"verification": {
  "entryGate": "Login clicked",
  "exitGate": "Lobby visible",
  "progressIndicators": [
    "WebSocket frames > 0",
    "location.hash changed",
    "Grand jackpot value loaded"
  ]
}
```

This documents **how** you know the step succeeded.

---

## Integration with T00L5ET

The TUI is a **visual editor** for workflows. Actual execution happens via **T00L5ET** (the C# CDP automation tool).

### How They Work Together

1. **TUI**: You design the workflow (steps, coordinates, breakpoints)
2. **TUI**: You save to `step-config.json`
3. **T00L5ET**: Reads `step-config.json`
4. **T00L5ET**: Executes steps via CDP (click, type, navigate)
5. **T00L5ET**: Captures screenshots
6. **T00L5ET**: Writes results to session log

### Running a Workflow via T00L5ET

```bash
# From TUI, save your workflow
# Then run via T00L5ET:
cd C:\P4NTHE0N\T00L5ET\bin\Debug\net10.0-windows7.0
.\T00L5ET.exe login --platform=firekirin --username=JustinHu21 --password=abc123
```

T00L5ET will:
1. Read `step-config.json`
2. Execute each step in sequence
3. Respect breakpoints (if implemented in T00L5ET)
4. Save screenshots to session directory

### Future: TUI → T00L5ET Bridge

Planned enhancement: Press `R` in TUI to **actually execute** steps via T00L5ET, not just simulate.

This would require:
- TUI spawns T00L5ET process
- T00L5ET reports progress back to TUI
- TUI displays live execution status
- Breakpoints pause T00L5ET execution

---

## Future Enhancements

### Planned Features

1. **Live Execution via T00L5ET**
   - Press `R` to run steps for real
   - TUI spawns T00L5ET and monitors progress
   - Real-time status updates

2. **Screenshot Preview**
   - Press `V` to view screenshot inline (ASCII art or external viewer)
   - Compare before/after screenshots

3. **Coordinate Picker**
   - Press `K` to launch Chrome with crosshair overlay
   - Click on target element
   - Coordinates auto-fill in TUI

4. **Template Steps**
   - Press `T` to insert pre-configured step templates
   - Templates: "Login", "Navigate to Game", "Spin", "Logout"

5. **Undo/Redo**
   - `Ctrl+Z` to undo last edit
   - `Ctrl+Y` to redo

6. **Search/Filter**
   - `/` to search steps by comment or phase
   - Filter by phase, tool, or breakpoint status

7. **Export to Different Formats**
   - Export to Playwright script
   - Export to Selenium script
   - Export to human-readable Markdown

8. **Multi-Platform Workflows**
   - Single config with platform-specific steps
   - Toggle between FireKirin and OrionStars views

### Contribution Ideas

If you want to extend the TUI:

- **Add new actions**: `doubleclick`, `rightclick`, `hover`
- **Add new tools**: `balance`, `jackpot`, `screenshot`
- **Add new phases**: `BonusRound`, `FreeSpins`, `Settings`
- **Improve rendering**: Better box drawing, colors, icons
- **Add mouse support**: Click to select steps (requires terminal mouse events)

---

## Conclusion

The P4NTHE0N Recorder TUI transforms workflow recording from a tedious, error-prone process into a **visual, interactive, debuggable experience**.

### Key Takeaways

✅ **Zero dependencies** — pure TypeScript + ANSI  
✅ **Full CRUD** — add, edit, delete, clone, reorder steps  
✅ **Breakpoints** — pause execution to verify state  
✅ **Conditional logic** — if-then-else error handling (v1.1)  
✅ **Goto statements** — simple error recovery (v1.1)  
✅ **Live preview** — run mode shows execution in real-time  
✅ **Auto-save** — never lose your work  
✅ **Coordinate precision** — edit X/Y values with arrow keys  
✅ **Screenshot integration** — CDP screenshot capture  
✅ **Platform switching** — FireKirin ↔ OrionStars with one keypress  

### Next Steps

1. **Launch the TUI**: `bun run recorder-tui.ts`
2. **Explore the FireKirin workflow** (14 steps already loaded)
3. **Add a breakpoint** on step 6 (LOGIN button)
4. **Run from step 1** and watch it execute
5. **Edit step 2** to change coordinates
6. **Add a new step** for OrionStars
7. **Save and quit** with `Q`

### Support

- **Issues**: File in P4NTHE0N repo under `H4ND/tools/recorder/`
- **Questions**: Ask WindFixer or Nexus
- **Documentation**: This file + `OPERATOR_MANUAL.md` + `QUICK_START.md`

---

**Built by WindFixer for Nexus**  
**DECISION_078 — P4NTHE0N Recorder TUI**  
**v1.0: 2026-02-21 | v1.1: 2026-02-22**
