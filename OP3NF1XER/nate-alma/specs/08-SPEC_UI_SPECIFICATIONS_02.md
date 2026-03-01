---
title: UI Consultation 02 - Detailed Layouts
kind: spec
status: accepted
owner: Nexus
last_updated: 2026-02-28
topics:
  - ui
  - layouts
  - specifications
related:
  - SPEC_UI_LAYOUTS.md
  - SPEC_UI_CONSULTATION_01.md
---

# SPEC_UI_LAYOUTS v1

## 1) Library (/book)
A) **ASCII Wireframe:**

```
+-----------------------------------------------------------+
| [App Bar: Logo | Nav Links | User Menu]                  |
+-----------------------------------------------------------+
|  [Left Rail: TOC Tree (Parts → Chapters → Sections)]   |
|  [                    Center: Library Content            ]|
|  [  (Page header, Continue card, Part cards, Recently    ]|
|  [   viewed sections)                                     ]|
|  [                                                       ]|
|  [                  Right Rail: Focus & Goals            ]|
|  [  (Today's focus, Recent notes, Skill goal)            ]|
+-----------------------------------------------------------+
```

B) **Layout Constraints:**
- **Container:** Max width 1280px (`max-w-[1280px]`), centered (`mx-auto`) with horizontal padding `px-6` (24px).
- **Left Rail:** Fixed width 280px (`w-[280px]`), sticky under App Bar. Contains the Library navigation (scrollable if content overflows).
- **Right Rail:** Fixed width 360px (`w-[360px]`), sticky under App Bar. Agent panel (initially empty or with placeholder) scrollable.
- **Center:** Max width 900px (`max-w-[900px]`) for the book-list grid (fits ~3-4 cards per row). Gap between columns uses spacing token 24px (e.g., `gap-x-6` in Tailwind).
- **Sticky Behavior:** Top App Bar is sticky at top; Left and Right rails are also sticky so navigation and agent panel remain visible when scrolling center content.
- **Scroll Containers:** Center column (Books list) scrolls vertically for content; Left Rail scrolls independently if TOC list is long; Right Rail scrolls independently if agent panel content is long (e.g. outputs). The App Bar does not scroll away.
- **Spacing Tokens:** Use spacing scale 8/12/16/24/32/48/64 (e.g., `p-6` for 24px padding, `gap-4` for 16px gap between cards).

C) **Component Inventory:**
- **App Bar:** Simple `<header className="...">` with shadcn `NavigationMenu` (optional), logo (left), nav links (Library, Notes, Playbooks, Admin) and user avatar/menu (right). Variant: transparent or default.
- **Left Rail (TOC Tree):** Styled `<nav>` with shadcn `Button variant="ghost"` items. Hierarchy: Parts (collapsible via `Accordion`) → Chapters → Section links. Use `pl-4` for nesting.
- **Center (Library Content):** 
  - Page header with book title
  - **Continue card:** Shows last read section with progress
  - **Part cards:** Overview cards for each Part (collapsible)
  - **Recently viewed (optional):** List of recently accessed sections
- **Search Input:** Shadcn `<Input type="search">` at top of center (e.g., with `placeholder="Search sections..."`).
- **Right Rail (Focus & Goals):**
  - Today's focus card (current learning goal)
  - Recent notes list
  - Skill goal progress
- **Buttons:** Shadcn `<Button>` for actions. Admin only: "Import/Publish" button (plus icon from Lucide). Secondary/ghost buttons for any in-card actions (like "Continue").
- **Toast/Alert:** Shadcn `<Toast>` or `<Alert>` to show success/error messages (e.g., "Content imported", "Error loading library").

D) **State Table:**

| State   | UI / Description                                            | Microcopy (exact)                                    |
|---------|-------------------------------------------------------------|------------------------------------------------------|
| Loading | Show centered spinner in content area                       | *(Spinner with `aria-label="Loading library..."`)*     |
| Empty   | No sections published; show explanation + next action       | "No sections published yet." **(Admin only):** "Import/Publish content to begin." |
| Error   | Fetch failed; show error message + retry button             | "Failed to load library. Please **Retry** or check your connection." |
| Success | Display TOC and content cards                               | *(Each card shows section title/part; no extra microcopy)* |

- **Empty State Next Action:** In the empty state, the "Import/Publish" button (admin only) in the App Bar or center is the clear primary action.
- **No Silent Failure:** Async fetch uses `try/catch` and sets state. Errors show above.

E) **A11y & Keyboard:**
- **Focus Order:** Top App Bar elements → Left Rail nav items → Center search input → Center list items (book cards) → pagination → Right Rail (if active) → Down the list.
- **Aria Labels:** 
  - App Bar logo as `aria-label="Home"`. 
  - "Import/Publish" button (admin only) with `aria-label="Import or publish content"`. 
  - Each TOC item: `aria-label` includes section name. 
  - Search input: `aria-label="Search sections"`.
- **Keyboard:** 
  - Tab navigates through App Bar, then Sidebar (using arrow keys or tab), then into search input, then into content cards (Enter opens selected section). 
  - Left/Right arrow keys can expand/collapse Parts in TOC if designed as accordions. 
  - Pressing `/` focuses search. 
  - "Enter" on a focused section card opens it.
  - "Escape" closes any open modal/dropdown (though Library has none).
  - Skip link not needed if all main nav visible, but an option: a hidden "Skip to content" link to bypass sidebar.
  
## 2) Reader (/book/[...slug])
A) **ASCII Wireframe:**

```
+------------------------------------------------------------+
| [App Bar: Logo | Book Title (breadcrumb) | User Menu]     |
+------------------------------------------------------------+
|  [Left Rail: Book TOC (Parts/Chapters)]    ||  [Right Rail: Agent Panel]  |
|  [  (Part 1)                                ][  (Skills / Output)       ]|
|  [    Chapter 1                            ]|  [                         ]|
|  [    Chapter 2                            ]|  [                         ]|
|  [  (Part 2)                              ]|  [                         ]|
|  [    Chapter 3                            ]|  [                         ]|
|  [    Chapter 4                            ]|  [                         ]|
|  [                                          ]|  [  [ Run Skill ]         ]|
|  [Center: Content (Article text, prose, etc.)   ]|  [                         ]|
|  [ (Sticky highlight actions toolbar appears on selection) ]|  [  [ Output scrolls] ]|
+------------------------------------------------------------+
```

B) **Layout Constraints:**
- **Container:** Same 1280px max-width, `mx-auto px-6`.
- **Left Rail:** 280px width, sticky under App Bar. Contains scrollable TOC tree (`<ScrollArea>` if needed). Uses smaller text; highlight current chapter.
- **Right Rail:** 360px width, sticky. Contains Agent skill UI (tabs or selects at top) and output area below (scrollable).
- **Center:** Max width 760px (`max-w-[760px]`) for reader content (per STYLE_GUIDE on typography). Content scrolls vertically; this is the main scroll region. Use `prose prose-invert` class for markdown content.
- **Sticky Behavior:** Left and Right rails scroll with page (sticky top) or independently if designed. Often, left TOC can scroll if long, right panel scroll if output long.
- **Scroll:** The main content area scrolls independently (the user scrolls to read). Highlight toolbar floats over content when needed (absolute positioning).
- **Spacing:** Maintain 24px outer padding and 16px gaps inside content.

C) **Component Inventory:**
- **Breadcrumb/Header:** Show book title and section (optional) in App Bar or subheader. Use Shadcn `<Breadcrumb>` or plain `<Text>`.
- **Left Rail (TOC):** Shadcn `<Tree>` or `<Accordion>` for Parts/Chapters. Use `<SidebarNav>` styled list with `pl-4` for nesting. Variants: ghost, since minimal UI (maybe `<NavbarSub>`).
- **Center (Content):** Shadcn `<Prose>` (via Typography plugin) for formatted text. Use `<Image>` (next/image) for figures with alt text. Use `<Link>` for hyperlinks.
- **Structured Blocks (TL;DR / Checklist / Mistakes / Drill):**
  - If present: render as specified card components.
  - If missing: show a small stub card:
    - Title: "TL;DR (coming soon)" (or "Checklist (coming soon)", etc.)
    - Body: "This section's summary will appear here."
- **Highlight Toolbar:** Custom floating div with action icons (Lucide icons wrapped in `<Button variant="ghost">`): Highlight (marker icon), Add Note (note icon), Copy (clipboard icon), Dismiss (x icon). These appear on text selection.
- **Modal/Popover:** On clicking "Add Note" or "Highlight", use Shadcn `<Dialog>` or `<Popover>` with a small form (Text area for note) and save/cancel buttons.
- **Buttons:** After run, inside agent panel, use primary `<Button>` for "Run", "Save as Note", "Save as Playbook Draft", etc.
- **Toasts:** Shadcn `<Toast>` to show "Highlight saved", "Note added" etc.
- **Text:** `<Typography>` for content. Use `<Heading>` components for content headings if needed for custom styling.

D) **State Table:**

| State    | UI / Description                                          | Microcopy (exact)                                          |
|----------|-----------------------------------------------------------|------------------------------------------------------------|
| Loading  | Center shows spinner, or skeleton of text blocks          | *(Spinner with `aria-label="Loading content..."`)*         |
| Empty    | No content (should not happen if book exists)             | "This section has no content yet." *and* one next action (e.g., link to add content if allowed).* |
| Error    | Fetch failed or 404: show error panel with retry option   | "Unable to load section. **Retry** or return to Library."     |
| Success  | Show content normally with all structured blocks (or stubs)| *(No extra microcopy; content displays as is)*             |

- **Highlight Toolbar States:** When text selected:
  - **Idle (no selection):** No toolbar visible.
  - **Selection:** Toolbar appears above selection with icons. Icons have tooltips (e.g., "Highlight text", "Add note", "Copy text", "Cancel").
  - **Highlighting:** On click, call API to save; show temporary "Saving highlight..." (e.g., spinner or disabled state).
  - **Highlighted:** On success, show toast "Highlight saved." Highlighted text styled (e.g., background color).
  - **Error:** If save fails, show inline error near toolbar: "Failed to save highlight. **Retry**." Toolbar stays visible.
- **No Silent Failure:** On any async (fetch content, save highlight/note), show loading/ error as above. Show last run time for agent tasks (see agent flow).

E) **A11y & Keyboard:**
- **Focus Order:** App Bar → Left Rail TOC items (expandable with keyboard) → Main Content (headings, paragraphs) → highlight toolbar (via keyboard when selection made) → Right Rail controls.
- **Aria Labels:**
  - TOC items: `aria-label` = part/chapter name.
  - Buttons (highlight, copy, add note, run skill, save): `aria-label` describing action, e.g., `aria-label="Add note to selection"`.
  - Images have `alt` text.
  - Agent Run button: `aria-label="Run selected skill"`.
- **Keyboard:**
  - Arrow keys (or Tab) navigate TOC and select sections (Enter to jump to that section).
  - In content, allow text selection via keyboard (Shift+arrow). After selection, toolbar can be navigated via Tab (left-right arrow to move between buttons, Enter to activate).
  - Global: Press `/` or `Cmd+K` opens command palette.
  - Press `n`/`p` or Page Up/Down moves to next/prev chapter (if implemented; else use TOC).
  - Escape hides toolbar or modals.
  - The agent panel’s run button should be reachable via Tab after skill selection.

## 3) Agent Panel (Reader Right Rail; skill UI + output)
A) **ASCII Wireframe:**

```
+-----------------------------------+
| [Skills Dropdown / Tabs] [Run Btn]|
+-----------------------------------+
| [Parameters Form (if any)]        |
|                                   |
| [-- If idle: Hint or empty state] |
| [-- If running: Progress spinner] |
| [-- If streaming: live output]    |
| [-- If done: formatted output]    |
|                                   |
| [Buttons: Save as Note, Save Playbook (visible when done)] |
+-----------------------------------+
```

B) **Layout Constraints:**
- **Container:** The right rail content fits within the 360px width with 16px padding (`p-4`).
- **Skills Bar:** Top section (90px tall) contains a skill selector (e.g., `<Tabs>` or `<Select>` full width) and a "Run" `<Button>` on the right. Use spacing token 16px between elements.
- **Output Area:** Fills remaining vertical space, scrollable (`overflow-y-auto`). Each output block may be a Shadcn `<Card>` or `<ScrollArea>` container with 8px padding.
- **Sticky:** Agent panel is sticky under App Bar so it’s always visible while reading.
- **Spacing:** Use consistent spacing (24px between sections).

C) **Component Inventory:**
- **Skill Selector:** Shadcn `<Tabs>` or `<Select>` with skill names (e.g., Summarize, Quiz, Translate). Use the **default** variant for clarity.
- **Parameters Form:** For skills requiring input (e.g., word count), use Shadcn `<Input>` or `<Textarea>` fields inside a `<Form>`.
- **Run Button:** Shadcn `<Button variant="primary">Run [Skill]` (disabled when running). Lucide "Play" icon inside.
- **Loading Indicator:** Shadcn `<Spinner>` inline on Run button or inside panel when running.
- **Output Display:** Use Shadcn `<Card>` or `<ScrollArea>` to contain agent text output. For streaming, use a typewriter effect with gradual text addition (optionally with a spinner).
- **Save Actions:** Shadcn `<Button variant="secondary">Save as Note` and `<Button variant="secondary">Save as Playbook Draft` beneath output when done.
- **Error Alert:** Shadcn `<Alert>` within panel if agent fails, with Retry `<Button>` inside.

D) **State Table:**

| State       | UI / Description                                         | Microcopy (exact)                                         |
|-------------|----------------------------------------------------------|-----------------------------------------------------------|
| Idle        | No skill run yet. Show hint or default message.         | "Select a skill and click **Run** to analyze the text."   |
| Running     | Show spinner, disable Run button. Progress indicator.    | "Running **[SkillName]**..."                              |
| Streaming   | Output area appends text in real-time.                   | *(No new microcopy; use streaming text.)*                 |
| Done        | Final output shown; Run button re-enabled.               | "Skill **[SkillName]** completed."                        |
| Saved (Note)| When user saves output as note. Show toast or banner.    | "Output saved to **Notes**."                              |
| Saved (Playbook)| When saved as playbook draft.                     | "Saved as **Playbook draft**."                              |
| Error       | Agent service down or error. Show error alert with retry.| "Agent temporarily unavailable. **Retry** later."         |

- For **retry**, offer user a "Retry" button (Shadcn `<Button variant="link">Retry</Button>`).
- Show the timestamp of last successful run (e.g., "Last run: 2m ago") below the header in small text for transparency.

E) **A11y & Keyboard:**
- **Focus Order:** Skill selector → Run button → (parameters inputs if any) → Output area → Save buttons.
- **Aria Labels:** 
  - Skill selector: `aria-label="Select agent skill"`. 
  - Run button: e.g., `aria-label="Run [SkillName] skill"`. 
  - Save buttons: "Save as Note", "Save as Playbook".
  - If streaming, use `aria-live="polite"` on output container so screen readers announce new text gradually.
- **Keyboard:** 
  - Tab through selector, run, and any parameter fields. Enter in Run button triggers action. 
  - Output area is focusable (scrollable region) so user can navigate text with arrow keys. 
  - "s" key when focus is on output could act as save note shortcut (if implemented). 
  - ESC stops streaming or closes alerts.
  - Command Palette (Ctrl/Cmd+K) available globally.

---

## STOP CHECKPOINT
- Pages 1–3 (Library, Reader, Agent panel) fully specified with layouts, components, states, and A11y details.
- Agent panel specifics complete (skill UI, states, microcopy).
- Ensured "no empty pages" and "no silent failure" on all above.
- Remaining pages to detail: Notes, Playbooks (list & detail), Admin, Login, Onboarding, and placeholder pages.
- Additionally: Implement state machines (Highlight toolbar, Note flow, Agent runs, Save flows, Reindex).
- Also create: Command Palette spec, Microcopy pack, Design tokens, Compliance checklist.

Proceeding to detail pages 4–10 and additional sections.

## 4) Notes (/notes)
A) **ASCII Wireframe:**

```
+---------------------------------------------------------+
| [App Bar: Logo | Notes | + New Note Button | User Menu] |
+---------------------------------------------------------+
| [Left Rail: Note Categories / Recent] | [ Center: Note List / Detail ] | [Right Rail: Agent Panel] |
| [ (All, By Topic, By Date)                 ] [ Search + Grid of Notes (cards) ] |
| [                                          ] [ Each with title, summary, action ]   |
+---------------------------------------------------------+
```

B) **Layout Constraints:**
- **Left Rail:** 280px wide, listing note categories or filters (All notes, by date). Sticky.
- **Center:** If listing notes: max 900px; if showing a single note detail: max 760px (like reader). A state toggle (list vs detail).
- **Right Rail:** 360px, same agent panel structure for notes. Sticky.
- **Container:** Same 1280px, with `px-6`.
- **Scroll:** Note list scrolls; note content scrolls; TOC and agent panel scroll individually.
- **Spacing:** Standard spacing as before.

C) **Component Inventory:**
- **App Bar:** Include "+ New Note" `<Button variant="primary">` with note icon.
- **Left Rail:** `<SidebarNav>` or `<Tabs>` for note filters/categories.
- **Center (List):** `<Table>` or `<List>` of notes (with title, snippet, date) or `<Card>` list.
- **Search/Filter:** `<Input type="search">` for notes with `aria-label="Search notes"`.
- **Detail View:** `<Prose>` for note content (markdown).
- **Right Rail:** Agent panel as above, with note context when applicable.

D) **State Table:**

| State   | UI                                              | Microcopy                                           |
|---------|-------------------------------------------------|-----------------------------------------------------|
| Loading | Spinner in center or skeleton cards             | `aria-label="Loading notes..."`                     |
| Empty   | "No notes yet" with explanation and action      | "No notes yet. Click **New Note** to add one."      |
| Error   | Error alert in center                            | "Failed to load notes. **Retry**."                  |
| List View Success | Show list of notes with title/date      | *(Each list item shows title, date)*                |
| Detail View Success | Show note content                        | *(No extra microcopy)*                              |

E) **A11y & Keyboard:**
- **Focus:** +New Note → Filters → Search → Note items → Agent.
- **Aria:** 
  - "+ New Note" button `aria-label="Create new note"`.
  - Each note in list: `aria-label="Note titled [Title], created on [Date]"`.
- **Keyboard:** 
  - Press "n" for new note (when not typing in input).
  - Enter on selected note item opens detail.
  - Escape from detail returns to list.

## 5) Playbooks List (/playbooks)
A) **ASCII Wireframe:**

```
+----------------------------------------------------+
| [App Bar: Logo | Playbooks | + New Playbook | User]|
+----------------------------------------------------+
| [Left Rail: Playbook Categories] [Center: Playbook Grid/List] [Right Rail: Agent] |
| [ (Scenarios, Checklists)               ] [ Search + Grid of Playbooks (cards) ] |
| [                                        ] [ Each with title, summary, action ]   |
+----------------------------------------------------+
```

B) **Layout Constraints:**
- Similar to Library: Left 280px, Center max 900px (grid), Right 360px.
- Grid of playbook cards (2 or 3 columns).
- "+ New Playbook" primary button in App Bar or center header.

C) **Components:**
- **Left Rail:** `<SidebarNav>` with categories (Scenarios, Checklists).
- **Center:** `<Card>` for each playbook with title, description, tags. `<Button>` "Edit" or "View".
- **Search:** `<Input type="search">`.
- **New Playbook:** `<Button variant="primary">`.
- **Agent Panel:** Possibly not needed on this page if playbooks not directly tied to agent (but the shell says agent rail exists).

D) **State Table:**

| State   | UI                            | Microcopy                                     |
|---------|-------------------------------|-----------------------------------------------|
| Empty   | "No playbooks" state         | "No playbooks yet. Click **New Playbook** to create one." |
| Loading | Spinner/list skeleton        | `aria-label="Loading playbooks..."`           |
| Error   | Error alert                  | "Failed to load playbooks. **Retry**."        |
| Success | Grid of playbook cards       | *(Cards display content)*                     |

E) **A11y & Keyboard:**
- **Focus:** New Playbook → Search → Playbook cards.
- **Aria:** New Playbook `aria-label="Create new playbook"`.
- Each card: `aria-label` with playbook title/description.
- **Keyboard:** Tab to New Playbook, then cards with Enter to open/edit.

## 6) Playbook Detail (/playbooks/[id])
A) **ASCII Wireframe:**

```
+--------------------------------------------------------+
| [App Bar: Logo | Playbooks > [Playbook Name] | User]  |
+--------------------------------------------------------+
| [Left Rail: Outline of playbook (if multi-step)] [Center: Playbook Content] [Right Rail: Agent] |
| [ (Sections or steps) ] [ Title, description, checklist/scenario ] [ (Agent for assistance) ] |
+--------------------------------------------------------+
```

B) **Layout Constraints:**
- Left 280px listing playbook sections or steps (scrollable).
- Center max 760px (detailed view like reader).
- Right 360px agent panel.
- Use `prose` styling for content (lists for checklist items).
- Steps or sections sticky at top of center.

C) **Components:**
- **Left Rail:** `<Tabs>` or styled `<nav>` with `Button variant="ghost"` for sections or steps.
- **Center:** `<Heading>` for playbook title; `<Card>` for summary/description; `<ul>` or styled list for scenario steps; collapsible sections for checklists.
- **Agent Panel:** For help with playbook (maybe suggestions).
- **Read-Only Design (MVP):** Playbook detail is read-only-ish:
  - Triggers
  - Checklist
  - Scenario tree
  - Linked sections
  - (Admin) publish/archive
  - No interactive "Start / Save Progress" buttons for MVP

D) **State Table:**

| State   | UI                         | Microcopy                               |
|---------|----------------------------|-----------------------------------------|
| Empty   | If no content: show info   | "This playbook is empty."               |
| Loading | Spinner in center         | `aria-label="Loading playbook..."`      |
| Error   | Error alert               | "Error loading playbook. **Retry**."    |
| Success | Show playbook steps/content| *(Content as written)*                  |

E) **A11y & Keyboard:**
- **Focus:** Sections nav → Content headings → Interactive elements (e.g., checkboxes for checklist).
- **Aria:** Each step with aria-labels. If checkboxes: `<Checkbox>` with label.
- **Keyboard:** Tab through items; Space toggles checklist items; Enter on "Start" button.

## 7) Admin (/admin)
A) **ASCII Wireframe:**

```
+----------------------------------------------------------+
| [App Bar: Logo | Admin | User Menu]                      |
+----------------------------------------------------------+
| [Left Rail: Admin Nav] [Center: Admin Dashboard] [Right Rail: (blank or status)] |
| [ (Metrics, Reindex, Users)   ] [ Cards or tables of system info ] [ (Optional) ]|
+----------------------------------------------------------+
```

B) **Layout Constraints:**
- Left 280px: admin sections (Reindex, Audit Log).
- Center: max 900px, shows cards or tables (system status, reindex button).
- Right: Could be blank or show last run times (if fits).
- Buttons/controls use spacing token 16px.

C) **Components:**
- **Left Rail:** `<SidebarNav>` (Analytics, Re-index, Users).
- **Center:** `<Card>` for each admin function:
  - "Reindex Data" card with button `<Button variant="primary">Reindex Now`.
  - "System Status" card with metrics.
  - `<DataTable>` (if available in shadcn) for audit logs.
- **Forms:** Reindex progress uses `<Progress>` and `<Alert>` for errors.
- **Toasts:** On success (e.g., "Reindex completed successfully").

D) **State Table:**

| State     | UI                              | Microcopy                               |
|-----------|---------------------------------|-----------------------------------------|
| Idle      | Dashboard with buttons/cards    | *(Cards with descriptions)*             |
| Reindexing| Show progress bar/spinner       | "Reindex in progress... [Cancel]"      |
| Success   | Show success toast              | "Reindex completed successfully."       |
| Error     | Show error alert with retry     | "Reindex failed. **Retry**."            |

- Show last reindex time (e.g., "Last run: Jan 1, 12:34").

E) **A11y & Keyboard:**
- **Focus:** Left Nav → Center controls (Reindex button).
- **Aria:** Reindex button `aria-label="Reindex database now"`.
- **Keyboard:** Enter triggers reindex. Tab through controls. 
- **No silent failures:** Always surface status/progress/errors.

## 8) Login (/login)
A) **ASCII Wireframe:**

```
+-----------------------------+
| [Centered Card]             |
| [Title: Login]              |
| [Email Input] [Password]    |
| [Login Button] [Forgot PW]  |
| [Create Account link]       |
+-----------------------------+
```

B) **Layout Constraints:**
- Centered card (max width 400px).
- Spacing tokens 16px between fields.
- Full width inputs.
- Padding 32px inside card.

C) **Components:**
- **Card:** Shadcn `<Card>` as form container.
- **Inputs:** `<Input type="email">`, `<Input type="password">`.
- **Buttons:** Primary `<Button>` for "Log in". Secondary link `<Link>` for "Forgot password?" or "Sign up".
- **Error Text:** `<FormMessage>` or small `<Text>` in red for validation.
- **Toast:** If login fails, show `<Toast>` or `<Alert>`.

D) **State Table:**

| State    | UI                           | Microcopy                                         |
|----------|------------------------------|---------------------------------------------------|
| Idle     | Show login form             | *(Labels as placeholders or above fields)*        |
| Submitting| Disable form, show spinner | *(Spinner overlay on Login button)*               |
| Error    | Show error message or toast | "Invalid credentials. Please try again."          |
| Success  | Redirect to Library        | *(No microcopy on success)*                       |

- Prevent silent failure: show spinner on submit, display error toasts.

E) **A11y & Keyboard:**
- **Focus:** Email → Password → Login Button → Links.
- **Aria:** Each input labelled; use `<label>` tags. 
- **Keyboard:** Enter in password triggers login. "Tab" cycles inputs. "Forgot Password?" link `aria-label="Reset your password"`.
- Rate-limit error: "Too many attempts, please try again later." (no mention account existence).

## 9) Onboarding (/onboarding)
A) **ASCII Wireframe:**

```
+----------------------------------------+
| [App Bar Hidden or minimal]            |
+----------------------------------------+
| [Stepper: 1) Display Name  2) Channel ]|
| [         3) Learning Goal  4) Prefs   ]|
| [Center: Current Step Form             ]|
| [  Step 1: [Display Name Input]      ]|
| [  Step 2: [Notification placeholder]]|
| [  Step 3: [Section selector]        ]|
| [  Step 4: [Guardrails placeholder]  ]|
| [                                       ]|
| [    [Back]  [Next / Open Library]     ]|
+----------------------------------------+
```

B) **Layout Constraints:**
- Full viewport height container.
- Center content vertically/horizontally.
- Max width ~600px for step content.
- Padding 32px.
- Stepper at top shows progress (3-4 steps).

C) **Components:**
- **Stepper/Tabs:** Shadcn `<Tabs>` or custom stepper showing steps 1-4 with active state.
- **Logo:** Top centered.
- **Heading/Text:** `<Heading>` for step title; `<Text>` for step description.
- **Form Inputs:** Shadcn `<Input>` for display name; `<Select>` for learning goal (starting section).
- **Buttons:** `<Button variant="secondary">Back` (disabled on step 1), `<Button variant="primary">Next` (steps 1-3) or "Open Library" (step 4).
- **Link:** "Already have an account? Log in" as `<Link>` below.

D) **State Table:**

| State   | UI                         | Microcopy                                |
|---------|----------------------------|------------------------------------------|
| Step 1  | Display name form          | "What should we call you?"               |
| Step 2  | Notification channel (placeholder) | "How would you like to be notified? (Coming soon)" |
| Step 3  | Learning goal selector     | "Where would you like to start?"          |
| Step 4  | Guardrails prefs (placeholder) | "Set your learning preferences. (Coming soon)" |
| Final   | Ready to start             | "All set! Open your Library to begin."    |
| Error   | (If error in setup)        | "Unable to proceed. **Retry** or skip for now." |

- **Next Action:** Step navigation or "Open Library" CTA on final step.

E) **A11y & Keyboard:**
- **Focus:** First input of current step (display name on step 1).
- **Aria:** Each step has `aria-label="Step X of 4: [Step Name]"`. "Open Library" has `aria-label="Start onboarding and open library"`.
- **Keyboard:** Enter on input advances to next (if valid). Tab cycles inputs. Arrow keys navigate between steps if using tabs.

## 10) Placeholder Pages (Dashboard/Journal/Alerts)
- **Empty State Required:** Each should have an icon or illustration, a brief explanation, and a call to action.
- **Example (Dashboard):** "Dashboard coming soon. Start by [action]" e.g., "Add a new note" or "Create a playbook".
- **Example (Journal):** "Your journal is empty. [Write your first entry]."
- **Example (Alerts):** "No alerts. When something happens, you'll see it here."
- **Next Action:** Each should include one button or link (e.g., go to Library, write entry).
- Use `<Card>` or centered `<div>` with an icon (from Lucide) and `<Button>`.

## State Machines (Flows)
### A) Highlight Selection Toolbar

| State         | Event                      | Next State       | UI Effect                                          |
|---------------|----------------------------|------------------|----------------------------------------------------|
| Idle          | User selects text          | ToolbarVisible   | Show floating toolbar above selection              |
| ToolbarVisible| Click 'Highlight' icon     | SavingHighlight  | Disable highlight button; show spinner on icon     |
| SavingHighlight| API success               | Idle             | Highlight text styled; show toast "Highlight saved."|
| SavingHighlight| API error                 | Error            | Keep toolbar; show error message with Retry option |
| Error         | Click Retry on toolbar     | SavingHighlight  | Retry saving (show spinner again)                  |
| ToolbarVisible| Click 'Add Note'           | NoteDialogOpen   | Open note creation dialog (toolbar remains)        |
| NoteDialogOpen| Submit note text          | SavingNote       | Disable inputs; show spinner in dialog             |
| SavingNote    | API success               | Idle             | Close dialog; show toast "Note saved."             |
| SavingNote    | API error                | NoteError        | Show error in dialog; keep text; allow retry       |
| NoteError     | Click Retry in dialog     | SavingNote       | Retry saving note                                  |
| ToolbarVisible| Click 'Copy' icon         | Idle             | Copy text to clipboard; show toast "Copied to clipboard." |
| Any           | Click outside / Escape     | Idle             | Dismiss toolbar (close dialog if open, no action)  |

- **Undo Behavior:** After saving a highlight, clicking it again could show "Remove Highlight" in toolbar (optional).

### B) Note Attachment Flow

| State       | Event                   | Next State    | UI Effect                                      |
|-------------|-------------------------|---------------|------------------------------------------------|
| Idle        | User clicks 'Add Note'  | DialogOpen    | Open dialog with textarea (focus inside)       |
| DialogOpen  | User types & saves      | SavingNote    | Disable inputs; show spinner                   |
| SavingNote  | API success            | Saved         | Close dialog; show toast "Note saved." Link highlight |
| SavingNote  | API error               | ErrorDialog   | Show error text; "Retry" button, keep text     |
| ErrorDialog | Click Retry            | SavingNote    | Retry saving                                  |
| Saved       | (Optional undo click)   | Idle          | Delete note and remove highlight link (if implement)|

- **Never lose text:** On error, keep text in input.
- **Attach to Highlight:** On success, note doc created and its ID attached to highlight (via API).

### C) Agent Skill Run Flow

| State   | Event                   | Next State  | UI Effect                                                |
|---------|-------------------------|-------------|----------------------------------------------------------|
| Idle    | User clicks Run         | Running     | Show spinner; disable Run and inputs                      |
| Running | Agent responds/streams  | Streaming   | Append output text progressively in output area          |
| Streaming| Agent finishes output  | Done        | Show completed output; enable Save buttons; change Run to "Run again"|
| Done    | User clicks Save Note   | SavingNoteOutput | Save to Notes (POST to /api/notes); show spinner on button|
| SavingNoteOutput| Success         | Idle        | Toast "Output saved to Notes."                            |
| SavingNoteOutput| Error           | Error       | Show alert in panel: "Failed to save output. Retry?"     |
| Done    | User clicks Save Playbook | SavingPlaybook | Save to playbooks (POST /api/playbooks/draft or PATCH existing); spinner on button         |
| SavingPlaybook| Success         | Idle        | Toast "Saved as Playbook draft."                          |
| SavingPlaybook| Error           | Error       | Show alert: "Failed to save playbook. Retry."            |
| *Any*   | Agent service down      | ErrorUnavailable | Show alert "Agent unavailable. Retry."               |

- **Agent Unavailable:** If no response within timeout or connection fails.
- **Retry:** In Error, clicking Retry goes back to Idle.
- **No Silent Failure:** Always show status or error in panel.

### D) Save Agent Output As...
- **Note:** Fields saved: `notes.title` = first line or skill name, `notes.content` = output, `notes.source` = playbook/skill reference, `notes.highlightId` = null (or reference if attached). Appears in Notes list and detail.
- **Playbook Draft:** Fields: `playbooks.title` = skill name or prompt, `playbooks.content` = output as checklist or scenario, `playbooks.status` = "draft", `createdBy` user. Appears in Playbooks list (draft badge).
- After save, UI should either navigate to the new item or show toast with link.

### E) Reindex Flow (Admin)

| State       | Event               | Next State   | UI Effect                                         |
|-------------|---------------------|--------------|---------------------------------------------------|
| Idle        | Click "Reindex Now" | InProgress   | Show progress bar; disable button; show spinner    |
| InProgress  | Progress update     | InProgress   | Update progress indicator (e.g., "25% complete")   |
| InProgress  | Finish (100%)       | Success      | Show toast "Reindex complete"; update last run time|
| InProgress  | Error               | Error        | Show error alert "Reindex failed. Retry." Button   |
| Error       | Click Retry         | InProgress   | Restart reindex                                     |

- **Status:** Display "Last reindex: [timestamp]" on dashboard. 
- No silent failure: always display progress or error.

## 5) Command Palette (⌘K)
- **Trigger:** `Cmd+K` (Mac) / `Ctrl+K` (Win) opens modal.
- **Actions (grouped):**
  - **Book Navigation:** "Go to Library", "Open Previous Book", "Next Chapter", "Previous Chapter".
  - **Search:** "Search in Books", "Search in Notes".
  - **Notes:** "Create New Note", "Go to Notes".
  - **Playbooks:** "Create New Playbook", "Go to Playbooks".
  - **User:** "Open Settings", "Log out".
- **Grouping:** Use headings in palette like **Navigation**, **Create**, **Utilities**.
- **Search Behavior:** Typing filters available actions. If no match, show "No results. Try another command." with a dismiss hint.
- **Book/QMD vs fallback:** First match prioritized by relevance (if in a book, navigate within book; if not, fallback to global).
- **Empty/ Error:** If no commands (rare), show "No actions available."

## 6) Microcopy Pack
- **Empty States:**
  - Library: "No sections published yet."
  - Reader (no content): "This section has no content yet."
  - Agent panel idle: "Select a skill and click **Run** to analyze the text."
  - Notes: "No notes yet. Click **New Note** to add one."
  - Playbooks: "No playbooks yet. Create from a skill output or click **New Playbook**."
  - Dashboard: "Dashboard coming soon. Start by adding a note or playbook."
  - Journal: "Your journal is empty. Write your first entry."
  - Alerts: "No alerts to show. You're all caught up!"
- **Error States:**
  - Section load (any content): "Failed to load content. Please **retry**."
  - Search fail: "Search failed. Check your connection and try again."
  - Agent fail: "Agent temporarily unavailable. **Retry** later."
  - Auth fail: "Login failed. Check your email and password."
- **Saving States:**
  - "Highlight saved."
  - "Note saved."
  - "Playbook draft saved."
- **Login Errors:**
  - "Invalid credentials. Please try again." (do not specify if email exists)
  - "Too many attempts. Try again later." (for rate limit, no account info leak)

## 7) Design Tokens

| Token Category   | Values / Examples               |
|------------------|---------------------------------|
| **Typography:**  | Scale (base 16px); font family: **Inter** (neo-grotesk sans) for all text. Weights: 400 (body) and 600 (headings) only. Editorial feel via tighter heading tracking (-0.02em), relaxed body line-height (1.65), and constrained measure (max 760px). Sizes: h1 32px, h2 24px, h3 20px, body 16px, small 14px. Use Tailwind prose classes. |
| **Spacing:**     | 4 (16px), 6 (24px), 8 (32px), 12 (48px), 16 (64px) units (Tailwind spacing 4/6/8/12/16). |
| **Radii:**       | `rounded` (0.375rem, 6px) for general, `rounded-md` for cards, `rounded-full` (50%) for avatars/icons. |
| **Shadow:**      | Use subtle shadows (e.g., `shadow-sm` or custom HSL `0 0 0 10%`) on interactive cards. Focus shadow `0 0 0 2px var(--accent)`. |
| **Color Roles:** | 
- Background: `#121212` (dark charcoal), surfaces (cards): `#1E1E1E` (slightly lighter).  
- Text: primary `#E0E0E0`, secondary `#A0A0A0`.  
- Muted text: `#888888`.  
- Borders/dividers: `#303030`.  
- Accent: cool teal (`#2DD4BF` or `#06B6D4`).  
- Ring (focus): use accent color hue with 0.5 alpha (e.g., `rgba(13,148,136,0.5)`).  
- Danger: muted red (`#F87171`).  
- Success: muted green (`#34D399`). |
  
These align with STYLE_GUIDE: editorial, calm, single accent.

## No Drift Rules
- **Features:** Strictly no extra features outside MVP scope (e.g., no trading functions).
- **Architecture:** Only Next.js public API as specified; internal services hidden.
- **Auth Assumption:** We assume a JWT or session for user identity (label under ASSUMPTIONS).
- **Design System:** Use only Shadcn UI components and style tokens per STYLE_GUIDE.
- **Conventions:** Follow SPEC_MONGO_SCHEMA for data shape (e.g., notes attach highlightId, playbook fields as given).

---

## COMPLIANCE CHECKLIST
- [x] Book-first pages (Library, Reader, Agent) fully specified with layouts and states.  
- [x] Stable 3-column shell used on all app routes (TOC left, Reader center, Agent right).  
- [x] Every page has a non-empty intentional state plus one clear next action.  
- [x] Async actions (fetches, saves) show status, timestamps, errors, and retry options.  
- [x] Shadcn UI components used (Buttons, Inputs, Cards, etc.) following style guide (one accent, calm UI).  
- [x] Endpoint contract respected: Browser → Next.js only; Next.js → internal; no direct Mongo calls.  
- [x] Mongo schema alignment: references to sections, notes, highlights, bookmarks, progress, playbooks, audit log are correct.

