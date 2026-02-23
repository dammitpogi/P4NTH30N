# Conditional Logic Quick Reference

## Basic Syntax

### If-Then-Else Structure
```json
{
  "conditional": {
    "condition": { /* what to check */ },
    "onTrue": { /* what to do if true */ },
    "onFalse": { /* what to do if false */ }
  }
}
```

### Goto Statement
```json
{
  "gotoStep": 5  // Jump to step 5 if this step fails
}
```

---

## Condition Types Cheat Sheet

| Type | Purpose | Example |
|------|---------|---------|
| `element-exists` | Check if element is present | `"target": ".login-button"` |
| `element-missing` | Check if element is absent | `"target": ".error-message"` |
| `text-contains` | Check if page has text | `"target": "SLOT"` |
| `cdp-check` | Run CDP command | `"cdpCommand": "{\"method\":\"Page.navigate\"}"` |
| `tool-success` | Check if tool passed | Used after tool execution |
| `tool-failure` | Check if tool failed | Used after tool execution |
| `custom-js` | Run custom JS | `"target": "document.readyState === 'complete'"` |

---

## Branch Actions Cheat Sheet

| Action | Purpose | Required Fields | Example |
|--------|---------|----------------|---------|
| `continue` | Next step | None | `{"action": "continue"}` |
| `goto` | Jump to step | `gotoStep` | `{"action": "goto", "gotoStep": 1}` |
| `retry` | Retry current | `retryCount`, `retryDelayMs` | `{"action": "retry", "retryCount": 3, "retryDelayMs": 2000}` |
| `abort` | Stop workflow | None | `{"action": "abort"}` |

---

## Common Patterns (Copy-Paste Ready)

### Pattern: Check for Error Message
```json
{
  "conditional": {
    "condition": {
      "type": "element-exists",
      "target": ".error-message",
      "description": "Check if error message appeared"
    },
    "onTrue": {
      "action": "goto",
      "gotoStep": 1,
      "comment": "Error - restart"
    },
    "onFalse": {
      "action": "continue",
      "comment": "No error - proceed"
    }
  }
}
```

### Pattern: Wait for Element to Load
```json
{
  "conditional": {
    "condition": {
      "type": "element-missing",
      "target": "#loading-spinner",
      "description": "Check if loading spinner is gone"
    },
    "onTrue": {
      "action": "continue",
      "comment": "Loading complete"
    },
    "onFalse": {
      "action": "retry",
      "retryCount": 10,
      "retryDelayMs": 1000,
      "comment": "Still loading - wait"
    }
  }
}
```

### Pattern: Verify Page Loaded
```json
{
  "conditional": {
    "condition": {
      "type": "text-contains",
      "target": "SLOT",
      "description": "Check if lobby loaded"
    },
    "onTrue": {
      "action": "continue",
      "comment": "Lobby ready"
    },
    "onFalse": {
      "action": "goto",
      "gotoStep": 1,
      "comment": "Lobby failed - restart"
    }
  }
}
```

### Pattern: Handle Server Busy
```json
{
  "conditional": {
    "condition": {
      "type": "text-contains",
      "target": "server is busy",
      "description": "Check for server busy message"
    },
    "onTrue": {
      "action": "retry",
      "retryCount": 5,
      "retryDelayMs": 5000,
      "comment": "Server busy - wait 5s and retry"
    },
    "onFalse": {
      "action": "continue",
      "comment": "Server ready"
    }
  }
}
```

### Pattern: Tool Success/Failure
```json
{
  "tool": "login",
  "conditional": {
    "condition": {
      "type": "tool-success",
      "description": "Check if login succeeded"
    },
    "onTrue": {
      "action": "continue",
      "comment": "Login OK"
    },
    "onFalse": {
      "action": "goto",
      "gotoStep": 1,
      "comment": "Login failed - retry"
    }
  }
}
```

### Pattern: Fatal Error Abort
```json
{
  "conditional": {
    "condition": {
      "type": "element-exists",
      "target": ".account-banned",
      "description": "Check if account banned"
    },
    "onTrue": {
      "action": "abort",
      "comment": "Account banned - cannot proceed"
    },
    "onFalse": {
      "action": "continue",
      "comment": "Account OK"
    }
  }
}
```

### Pattern: Custom JavaScript Check
```json
{
  "conditional": {
    "condition": {
      "type": "custom-js",
      "target": "document.readyState === 'complete' && document.querySelector('canvas') !== null",
      "description": "Check if page ready and canvas exists"
    },
    "onTrue": {
      "action": "continue",
      "comment": "Page ready"
    },
    "onFalse": {
      "action": "retry",
      "retryCount": 3,
      "retryDelayMs": 1000,
      "comment": "Not ready - wait"
    }
  }
}
```

---

## Flow Diagrams

### Linear (No Errors)
```
Step 1 → Step 2 → Step 3 → Step 4 → Done
```

### With Retry
```
Step 1 → Step 2 → Step 3 (fail) ──retry──> Step 3 (success) → Step 4
                      ↓
                   (max retries)
                      ↓
                    ABORT
```

### With Goto
```
Step 1 → Step 2 → Step 3 → Step 4 (error)
  ↑                                  ↓
  └──────────────────────────────goto
```

### With Conditional Branching
```
Step 1 → Step 2 → Step 3 (check)
                      ├─ TRUE → continue → Step 4
                      └─ FALSE → goto Step 1
```

---

## Validation Checklist

Before running your workflow, verify:

- [ ] All `gotoStep` numbers exist in your workflow
- [ ] `goto` actions have `gotoStep` field
- [ ] `retry` actions have `retryCount` and `retryDelayMs`
- [ ] Condition `description` is clear and descriptive
- [ ] Branch `comment` explains why this path is taken
- [ ] No infinite loops (goto doesn't create circular references)
- [ ] Retry counts are reasonable (max 10)
- [ ] Both `onTrue` and `onFalse` branches are defined

---

## Tips

1. **Start simple** - Add conditionals to critical steps first
2. **Test both paths** - Manually verify both success and error branches
3. **Use descriptive names** - Clear descriptions help debugging
4. **Limit retries** - Avoid infinite loops (max 10 retries)
5. **Add delays** - Give system time to recover (2-5 seconds typical)
6. **Document goto targets** - Comment why you're jumping to that step
7. **Reserve abort for fatal errors** - Use sparingly
8. **Prefer retry for transient issues** - Network delays, loading times
