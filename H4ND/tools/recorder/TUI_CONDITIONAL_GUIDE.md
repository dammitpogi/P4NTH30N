# TUI Conditional Logic & Goto - User Guide

## Overview

The TUI now supports **conditional logic (if-then-else)** and **goto statements** for plotting error handling workflows directly in the interface.

## Key Bindings

### Step List View
- **`C`** - Add/Edit Conditional logic for selected step
- **`G`** - Set Goto target for selected step
- **`V`** - View conditional logic (if present)
- **`X`** - Clear conditional logic

### Step Detail View
- **`C`** - Edit conditional logic
- **`G`** - Edit goto target
- Shows conditional preview if present

### Step Edit View
- **`gotoStep`** field - Enter step number to jump to on failure
- **`conditional`** field - Press Enter to open conditional editor

## Conditional Editor Interface

When you press **`C`** on a step, the conditional editor opens with three sections:

### 1. CONDITION Section (What to Check)
```
▶ CONDITION (what to check)
→ Type        : element-exists
  Target      : .error-message
  CDP Cmd     : (empty)
  Description : Check if error message appeared
```

**Fields:**
- **Type** - Condition type (cycle with Tab):
  - `element-exists` - Check if DOM element exists
  - `element-missing` - Check if element is absent
  - `text-contains` - Check if page contains text
  - `cdp-check` - Run CDP command
  - `tool-success` - Check if tool passed
  - `tool-failure` - Check if tool failed
  - `custom-js` - Run custom JavaScript

- **Target** - Element selector, text, or JS expression
- **CDP Cmd** - CDP command JSON (for cdp-check type)
- **Description** - Human-readable explanation

### 2. ON TRUE Section (What to Do If True)
```
▶ ON TRUE (what to do)
→ Action      : goto
  Goto Step   : 1
  Retry Count : (empty)
  Retry Delay : (empty)
  Comment     : Error detected - restart
```

**Fields:**
- **Action** - What to do (cycle with Tab):
  - `continue` - Proceed to next step
  - `goto` - Jump to specific step
  - `retry` - Retry current step
  - `abort` - Stop workflow

- **Goto Step** - Step number (required for goto action)
- **Retry Count** - Number of retries (required for retry action)
- **Retry Delay** - Milliseconds between retries
- **Comment** - Explanation of this branch

### 3. ON FALSE Section (What to Do If False)
Same fields as ON TRUE section.

### 4. Preview Section
Shows formatted preview of your conditional logic:
```
Preview:
  IF Check if error message appeared
    THEN goto step 1 (Error detected - restart)
    ELSE continue to next step (No error - proceed)
```

## Conditional Editor Controls

- **Up/Down Arrow** - Navigate between fields
- **Tab** - Switch between sections (Condition → OnTrue → OnFalse)
- **Enter** - Edit selected field
- **Esc** - Cancel field edit or exit editor
- **Ctrl+S** - Save conditional logic
- **Ctrl+D** - Delete conditional logic
- **Ctrl+C** - Cancel and exit without saving

## Simple Goto (Without Conditional)

For simple error recovery without conditions:

1. Select step in list view
2. Press **`G`**
3. Enter step number to jump to
4. Press Enter

This sets a goto target that will be used if the step fails during execution.

## Workflow Examples

### Example 1: Check for Error Message
```
Step 5: Click LOGIN button
Conditional:
  IF element-exists ".error-message" (Check if login error appears)
    THEN goto step 1 (Login failed - restart)
    ELSE continue (No error - proceed)
```

### Example 2: Wait for Element to Load
```
Step 10: Wait for lobby
Conditional:
  IF element-missing "#lobby-container" (Check if lobby not loaded)
    THEN retry 5 times with 2000ms delay (Wait for loading)
    ELSE continue (Lobby ready)
```

### Example 3: Handle Server Busy
```
Step 3: Submit login
Conditional:
  IF text-contains "server is busy" (Check for server busy message)
    THEN retry 10 times with 5000ms delay (Server busy - wait and retry)
    ELSE continue (Server ready)
```

### Example 4: Tool Success/Failure
```
Step 2: Run diagnostic tool
Tool: diag
Conditional:
  IF tool-failure (Check if diagnostic failed)
    THEN abort (Cannot proceed safely)
    ELSE continue (Diagnostic passed)
```

## Visual Indicators in Step List

Steps with conditional logic or goto show indicators:

- **`[IF]`** - Has conditional logic
- **`[→5]`** - Has goto to step 5
- **`[IF→5]`** - Has both conditional and goto

## Execution Behavior

During workflow execution (Run Mode):

1. **Step executes normally**
2. **If conditional exists:**
   - Condition is evaluated
   - Appropriate branch (onTrue/onFalse) is executed
   - May continue, goto, retry, or abort
3. **If step fails and goto exists:**
   - Jumps to specified step number
4. **Status indicators:**
   - Green = condition met, success path
   - Red = condition not met, error path
   - Yellow = retrying

## Best Practices

1. **Use descriptive condition descriptions** - Makes debugging easier
2. **Add comments to branches** - Explain why each path is taken
3. **Test both paths** - Verify success and error scenarios
4. **Limit retry counts** - Avoid infinite loops (max 10)
5. **Use appropriate delays** - Give system time to recover (2-5 seconds)
6. **Reserve abort for fatal errors** - Use sparingly
7. **Prefer retry for transient issues** - Network delays, loading times
8. **Use goto for recoverable errors** - Session expired, need re-login

## Keyboard Shortcuts Summary

| Key | Action | Context |
|-----|--------|---------|
| `C` | Edit conditional | Step list/detail |
| `G` | Set goto target | Step list/detail |
| `V` | View conditional | Step list (if present) |
| `X` | Clear conditional | Step list |
| `↑↓` | Navigate fields | Conditional editor |
| `Tab` | Switch sections | Conditional editor |
| `Enter` | Edit field | Conditional editor |
| `Esc` | Cancel/Exit | Conditional editor |
| `Ctrl+S` | Save | Conditional editor |
| `Ctrl+D` | Delete | Conditional editor |

## Tips

- **Start simple**: Add conditionals to critical steps first (login, page load)
- **Use goto for restart**: Jump back to step 1 when session expires
- **Use retry for loading**: Wait for elements to appear
- **Use abort for fatal errors**: Account banned, system down
- **Chain conditions**: Multiple steps can have conditionals for complex flows
- **Test incrementally**: Add one conditional at a time and test

## Troubleshooting

**Q: Conditional not triggering?**
- Check condition type matches what you're testing
- Verify target selector/text is correct
- Use custom-js for complex checks

**Q: Goto not working?**
- Ensure target step number exists
- Check step hasn't been deleted/renumbered

**Q: Retry looping forever?**
- Set reasonable retry count (3-10)
- Add sufficient delay between retries
- Consider using goto instead for persistent errors

**Q: Can't see conditional in step list?**
- Look for `[IF]` indicator next to step
- Press `V` to view details
- Press `C` to edit

## Integration with Existing Features

- **Breakpoints**: Work alongside conditionals (breakpoint triggers first)
- **Screenshots**: Captured before condition evaluation
- **Tools**: Tool result can be used in conditional (tool-success/tool-failure)
- **Coordinates**: Conditionals can check if elements exist at coordinates
- **Phases**: Conditionals work across all phases (Login, GameSelection, Spin)
