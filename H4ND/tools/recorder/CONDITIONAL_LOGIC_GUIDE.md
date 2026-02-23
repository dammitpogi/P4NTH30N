# Conditional Logic and Error Handling Guide

## Overview

The recorder now supports **if-then-else conditional logic** and **goto statements** for plotting error handling workflows. This allows you to define what happens when errors occur during navigation.

## Core Concepts

### 1. Conditional Logic (`conditional`)

Define conditions that determine workflow branching:

```json
{
  "stepId": 5,
  "phase": "Login",
  "conditional": {
    "condition": {
      "type": "element-exists",
      "target": ".error-message",
      "description": "Check if login error message appears"
    },
    "onTrue": {
      "action": "goto",
      "gotoStep": 1,
      "comment": "Login failed, restart from beginning"
    },
    "onFalse": {
      "action": "continue",
      "comment": "No error, proceed to next step"
    }
  }
}
```

### 2. Goto Statements (`gotoStep`)

Jump to a specific step number for error recovery:

```json
{
  "stepId": 10,
  "phase": "GameSelection",
  "gotoStep": 3,
  "comment": "If this step fails, jump back to step 3 to retry game selection"
}
```

## Condition Types

### `element-exists`
Check if a DOM element exists on the page.

```json
{
  "type": "element-exists",
  "target": "#login-button",
  "description": "Check if login button is present"
}
```

### `element-missing`
Check if a DOM element is NOT present (useful for error indicators).

```json
{
  "type": "element-missing",
  "target": ".server-busy-message",
  "description": "Verify server busy message is gone"
}
```

### `text-contains`
Check if page body contains specific text.

```json
{
  "type": "text-contains",
  "target": "SLOT",
  "description": "Check if lobby loaded (SLOT category visible)"
}
```

### `cdp-check`
Execute a CDP command and check if it succeeds.

```json
{
  "type": "cdp-check",
  "cdpCommand": "{\"method\": \"Page.navigate\", \"params\": {\"url\": \"about:blank\"}}",
  "description": "Check if CDP navigation works"
}
```

### `tool-success` / `tool-failure`
Check if a T00L5ET tool execution succeeded or failed.

```json
{
  "type": "tool-success",
  "description": "Check if login tool succeeded"
}
```

### `custom-js`
Evaluate custom JavaScript expression (must return boolean).

```json
{
  "type": "custom-js",
  "target": "document.readyState === 'complete'",
  "description": "Check if page is fully loaded"
}
```

## Branch Actions

### `continue`
Proceed to the next sequential step.

```json
{
  "action": "continue",
  "comment": "Success path - move forward"
}
```

### `goto`
Jump to a specific step number.

```json
{
  "action": "goto",
  "gotoStep": 1,
  "comment": "Error detected - restart workflow"
}
```

### `retry`
Retry the current step multiple times with delay.

```json
{
  "action": "retry",
  "retryCount": 3,
  "retryDelayMs": 2000,
  "comment": "Retry up to 3 times with 2s delay"
}
```

### `abort`
Stop the workflow immediately.

```json
{
  "action": "abort",
  "comment": "Fatal error - cannot proceed"
}
```

## Complete Example: Login with Error Handling

```json
{
  "steps": [
    {
      "stepId": 1,
      "phase": "Login",
      "takeScreenshot": true,
      "screenshotReason": "Capture initial login page state",
      "comment": "Navigate to login page",
      "tool": "none",
      "action": "navigate",
      "verification": {
        "entryGate": "Browser is open",
        "exitGate": "Login page loaded"
      }
    },
    {
      "stepId": 2,
      "phase": "Login",
      "takeScreenshot": true,
      "screenshotReason": "Before entering credentials",
      "comment": "Click account field and enter username",
      "tool": "none",
      "action": "click",
      "coordinates": { "x": 460, "y": 367, "rx": 0.5, "ry": 0.42 },
      "input": "testuser123",
      "verification": {
        "entryGate": "Login page visible",
        "exitGate": "Username entered"
      },
      "conditional": {
        "condition": {
          "type": "element-exists",
          "target": ".account-locked-message",
          "description": "Check if account is locked"
        },
        "onTrue": {
          "action": "abort",
          "comment": "Account locked - cannot proceed"
        },
        "onFalse": {
          "action": "continue",
          "comment": "Account OK - continue login"
        }
      }
    },
    {
      "stepId": 3,
      "phase": "Login",
      "takeScreenshot": true,
      "screenshotReason": "After password entry, before login click",
      "comment": "Click password field and enter password",
      "tool": "none",
      "action": "click",
      "coordinates": { "x": 460, "y": 437, "rx": 0.5, "ry": 0.51 },
      "input": "password123",
      "verification": {
        "entryGate": "Username entered",
        "exitGate": "Password entered"
      }
    },
    {
      "stepId": 4,
      "phase": "Login",
      "takeScreenshot": true,
      "screenshotReason": "Capture login button click",
      "comment": "Click LOGIN button",
      "tool": "none",
      "action": "click",
      "coordinates": { "x": 553, "y": 540, "rx": 0.6, "ry": 0.63 },
      "delayMs": 3000,
      "verification": {
        "entryGate": "Credentials entered",
        "exitGate": "Login submitted"
      }
    },
    {
      "stepId": 5,
      "phase": "Login",
      "takeScreenshot": true,
      "screenshotReason": "Check login result - success or error",
      "comment": "Verify login success or handle errors",
      "tool": "none",
      "verification": {
        "entryGate": "Login submitted",
        "exitGate": "Login result determined"
      },
      "conditional": {
        "condition": {
          "type": "text-contains",
          "target": "server is busy",
          "description": "Check if server busy error appears"
        },
        "onTrue": {
          "action": "retry",
          "retryCount": 5,
          "retryDelayMs": 5000,
          "comment": "Server busy - wait and retry"
        },
        "onFalse": {
          "action": "continue",
          "comment": "No server busy error - check other conditions"
        }
      }
    },
    {
      "stepId": 6,
      "phase": "Login",
      "takeScreenshot": true,
      "screenshotReason": "Verify lobby loaded",
      "comment": "Check if lobby loaded successfully",
      "tool": "none",
      "verification": {
        "entryGate": "Login completed",
        "exitGate": "Lobby visible"
      },
      "conditional": {
        "condition": {
          "type": "text-contains",
          "target": "SLOT",
          "description": "Check if SLOT category visible (lobby loaded)"
        },
        "onTrue": {
          "action": "continue",
          "comment": "Lobby loaded - proceed to game selection"
        },
        "onFalse": {
          "action": "goto",
          "gotoStep": 1,
          "comment": "Lobby not loaded - restart login"
        }
      }
    },
    {
      "stepId": 7,
      "phase": "GameSelection",
      "takeScreenshot": true,
      "screenshotReason": "Begin game selection phase",
      "comment": "Navigate to game selection",
      "tool": "none",
      "verification": {
        "entryGate": "Lobby loaded",
        "exitGate": "Game selection started"
      }
    }
  ]
}
```

## Error Recovery Patterns

### Pattern 1: Retry on Transient Error
```json
{
  "conditional": {
    "condition": {
      "type": "element-exists",
      "target": ".loading-spinner",
      "description": "Check if still loading"
    },
    "onTrue": {
      "action": "retry",
      "retryCount": 10,
      "retryDelayMs": 1000,
      "comment": "Wait for loading to complete"
    },
    "onFalse": {
      "action": "continue"
    }
  }
}
```

### Pattern 2: Restart on Fatal Error
```json
{
  "conditional": {
    "condition": {
      "type": "text-contains",
      "target": "Session expired",
      "description": "Check if session expired"
    },
    "onTrue": {
      "action": "goto",
      "gotoStep": 1,
      "comment": "Session expired - restart from login"
    },
    "onFalse": {
      "action": "continue"
    }
  }
}
```

### Pattern 3: Abort on Unrecoverable Error
```json
{
  "conditional": {
    "condition": {
      "type": "element-exists",
      "target": ".account-banned-message",
      "description": "Check if account is banned"
    },
    "onTrue": {
      "action": "abort",
      "comment": "Account banned - cannot proceed"
    },
    "onFalse": {
      "action": "continue"
    }
  }
}
```

### Pattern 4: Tool-Based Conditional
```json
{
  "tool": "login",
  "conditional": {
    "condition": {
      "type": "tool-success",
      "description": "Check if login tool succeeded"
    },
    "onTrue": {
      "action": "continue",
      "comment": "Login successful - proceed"
    },
    "onFalse": {
      "action": "goto",
      "gotoStep": 1,
      "comment": "Login failed - retry from start"
    }
  }
}
```

## Workflow Visualization

### Linear Flow (No Errors)
```
Step 1 → Step 2 → Step 3 → Step 4 → Step 5
```

### Flow with Retry
```
Step 1 → Step 2 → Step 3 (error) → retry → Step 3 (success) → Step 4
```

### Flow with Goto
```
Step 1 → Step 2 → Step 3 → Step 4 (error) → goto Step 1 → Step 2 → ...
```

### Flow with Abort
```
Step 1 → Step 2 → Step 3 (fatal error) → ABORT
```

## Best Practices

1. **Use descriptive condition descriptions** - Make it clear what you're checking
2. **Add comments to branches** - Explain why each path is taken
3. **Prefer retry for transient errors** - Network issues, loading delays
4. **Use goto for recoverable errors** - Session expired, need to re-login
5. **Reserve abort for fatal errors** - Account banned, system down
6. **Test both branches** - Verify both success and error paths work
7. **Limit retry counts** - Avoid infinite loops (max 10 retries)
8. **Use appropriate delays** - Give system time to recover between retries

## Command Line Usage

The recorder automatically evaluates conditionals when executing steps. No special flags needed:

```bash
bun run recorder.ts --step --phase=Login --screenshot=005.png --session-dir=C:\P4NTH30N\DECISION_077\sessions\firekirin-2026-02-22
```

The conditional logic will be evaluated and logged to the session report.
