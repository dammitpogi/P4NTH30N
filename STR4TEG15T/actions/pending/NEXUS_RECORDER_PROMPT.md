## PROMPT FOR NEXUS - Navigation Mapping with Recorder

**Context Without Ceremony**

Nexus, we are blind. The Canvas is a black box. Our agents report success but the screenshots show empty fields. We need human eyes to map what the machine cannot see. You are the cartographer.

**Emotional Weight**

You have guided us through THE_LONG_NIGHT when chaos reigned and the decision engine was born. You commanded THE_FORGE_AWAKENING when five decisions were forged. You witnessed the BURN_IN_READINESS assessment and the CANVAS_TYPING_FAILURE that humbled us.

Now you take up the Recorder. Not to fight, but to see. To map. To draw the path that others will follow.

Remember the CONVERGENCE_ACHIEVED moment when all pieces came together. That convergence happens now as three paths run parallel: WindFixer forging the breach, OpenFixer restoring memory, and you mapping the way.

**Absolute Clarity of Next Step**

Use the Recorder at `C:\P4NTH30N\H4ND\tools\recorder` to map the FireKirin navigation path:

**PHASE 1: Login Phase**
1. Launch Recorder: `bun run tui`
2. Navigate to FireKirin: `https://play.firekirin.in`
3. Press F to connect CDP (auto-spawns Chrome if needed)
4. Record each step:
   - Initial login screen state (screenshot + coordinates)
   - Username field location (canvas-relative coordinates)
   - Password field location (canvas-relative coordinates)
   - Login button location (canvas-relative coordinates)
   - Any intermediate states
5. Document the JavaScript that sets input values:
   - Open DevTools (F12)
   - Inspect Canvas element
   - Try: `document.querySelector('canvas').value = 'username'`
   - Try: `document.querySelector('#GameCanvas').dispatchEvent(new Event('input'))`
   - Find what actually works
6. Record successful login verification:
   - Balance display location
   - Balance value format
   - Any post-login navigation elements

**PHASE 2: Game Selection Phase**
1. From logged-in state, navigate to SLOT category
2. Record:
   - SLOT category button location
   - Page navigation (if pagination exists)
   - Fortune Piggy game icon location
   - Game load verification (what indicates game is ready)
3. Document timing:
   - How long between click and game load
   - Any loading indicators
   - When is game "ready" for spin

**PHASE 3: Spin Phase**
1. From game loaded state, locate spin button
2. Record:
   - Spin button location (canvas-relative)
   - Auto-spin toggle location (if exists)
   - Bet amount controls (if exists)
3. Document:
   - Spin animation duration
   - Win detection (jackpot splash, balance change)
   - How to detect spin completion

**Recording Format**

Create navigation map entries in this format:
```json
{
  "platform": "FireKirin",
  "game": "FortunePiggy",
  "verifiedAt": "2026-02-21T20:00:00Z",
  "phases": [
    {
      "name": "Login",
      "durationMs": 15000,
      "verification": "Balance displayed: $XX.XX",
      "coordinates": {
        "accountField": {"x": 460, "y": 367, "relativeTo": "canvas"},
        "passwordField": {"x": 460, "y": 437, "relativeTo": "canvas"},
        "loginButton": {"x": 553, "y": 567, "relativeTo": "canvas"}
      },
      "canvasTypingStrategy": "JavaScript injection: document.querySelector(...).value = ...",
      "screenshots": ["login_initial.png", "login_filled.png", "login_success.png"]
    },
    {
      "name": "GameSelection",
      "durationMs": 8000,
      "verification": "Fortune Piggy loaded",
      "coordinates": {
        "slotCategory": {"x": 37, "y": 513, "relativeTo": "canvas"},
        "fortunePiggyIcon": {"x": 80, "y": 510, "relativeTo": "canvas"}
      }
    },
    {
      "name": "Spin",
      "durationMs": 5000,
      "verification": "Auto-spin activated / Balance changed",
      "coordinates": {
        "spinButton": {"x": 860, "y": 655, "relativeTo": "canvas"}
      }
    }
  ]
}
```

**Resources**
- Recorder location: `C:\P4NTH30N\H4ND\tools\recorder`
- Operator manual: `H4ND/tools/recorder/OPERATOR_MANUAL.md`
- Step schema: `H4ND/tools/recorder/STEP_SCHEMA.json`
- Quick start: `H4ND/tools/recorder/QUICK_START.md`
- TUI docs: `H4ND/tools/recorder/docs/TUI_LIVE_EXECUTION.md`

**Recorder Controls**
- F: Connect CDP (auto-spawns Chrome)
- R: Enter run mode
- Space: Execute one step
- A: Auto-run all steps
- S: Capture screenshot
- Esc: Abort execution

**Report Format**
After each phase, save to:
`STR4TEG15T/navigation-maps/FireKirin_FortunePiggy_YYYYMMDD_HHMMSS.json`

Include:
1. Phase completed: [Login | GameSelection | Spin]
2. Screenshots captured: [count]
3. Coordinates recorded: [count]
4. JavaScript injection method: [what worked]
5. Timing data: [durations]
6. Verification points: [what confirms success]

**Parallel Context**
While you map, WindFixer builds the tools to automate what you discover. OpenFixer restores the knowledge base that will guide future automation. Your discoveries become their specifications. The three paths converge.

**Final Success Criteria**
- Complete navigation map for FireKirin → Fortune Piggy
- Canvas-relative coordinates for all interactive elements
- Working JavaScript injection method documented
- Timing data for each phase
- Verification criteria for each transition
- Screenshots for key states

You are the eyes. You are the cartographer. You are the human in the loop that makes the machine vision possible.

Map the path. Record the truth. Show us the way.

Execute.

---

*Strategist Command*  
*DECISION_077 - Navigation Phase*  
*2026-02-21*
