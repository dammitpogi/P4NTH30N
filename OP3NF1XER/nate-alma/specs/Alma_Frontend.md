# Executive Summary  
We will implement a 3‑column, editorial-style interface (TOC | Reader | Agent panel) that strictly emphasizes book-based learning. The left-hand TOC uses a vertical nav, which users naturally scan more than other areas【3†L136-L139】. The center Reader displays richly formatted content (styled via Tailwind’s Typography plugin for clean, readable prose【11†L111-L119】), and the right Agent panel hosts AI learning tools. All components derive from a unified Tailwind-based design system (e.g. [shadcn/ui]) for consistency【7†L19-L22】【27†L98-L102】. We will use semantic colors (charcoal greys + one accent) and consistent spacing/radii across all pages. Every async process (search, highlights saving, agent queries, indexing, etc.) will provide explicit status and results – turning background jobs “into a visible, predictable, and trustworthy experience”【25†L90-L99】【22†L180-L188】. In keeping with UX best practices, no page will ever be blank: each empty state will show a helpful message and a clear “next action” (e.g. “No notes yet. Click 🔖 in the Reader to bookmark a section”)【18†L134-L142】【18†L242-L248】. The deliverables below cover the information architecture, wireframe specifications for each page, interaction flows, component inventory, and a prioritized MVP build plan. We will complete the Library and Reader UI **first** (per governance) before other areas. Success criteria for “Book UI” include: users can navigate the TOC, load sections, highlight/add notes/bookmarks, and see progress – all without dead-ends or silent failures.  

## IA + Routing  
- **Top Navigation:** Includes a logo/home link, a global search box, a “Continue Reading” button (jump to last-read section), a bookmarks icon, and the user profile menu. Search uses `/api/book/search`.  
- **Left Rail (TOC):** Persistent sidebar showing a collapsible Parts → Chapters → Sections tree. Each node shows a progress indicator (e.g. percentage or checkmark) for that section’s reading progress. (E.g. “Part II ▶ Chapter 3 ▶ Section 3.1 (75%)”.) Clicking a section opens the Reader. The left rail is a `Sidebar` or `ScrollArea` with nested lists (using shadcn components like Accordion/NavigationMenu as needed). Vertically placing the TOC here helps users form a mental model of the book structure【3†L136-L139】.  
- **Right Rail (Agent Panel):** Fixed column with titled sections (e.g. “Learning Tools”) listing the agent skills (Explain, Quiz, etc., see below). It stays visible on Reader pages. On Library, the right rail instead shows “Today’s Focus” (1–3 recommended sections) and “Recent Notes”.  
- **Main Content Area:** Varies by route: Library page (section list) or Reader page (section content).  
- **Routes & Deep Links:** We use Next.js pages or layouts: e.g. `/library` (or root `/`) for the Library page, `/reader/[slug]` for a section view. Each section heading in a Reader has an HTML anchor (and URL fragment) so deep links work – e.g. `/reader/options-intro#delta-strategy`. This mirrors common TOC behavior【33†L127-L135】 and even allows link sharing of specific subtopics. Other routes: `/notes` for Notes listing, `/playbooks` for the Playbook dashboard, and admin-only pages like `/admin/status`. Placeholders: `/dashboard`, `/journal`, `/alerts` lead to simple “coming soon” pages.  

## (1) Library Wireframe Spec  
- **Purpose:** Provide an overview of the book’s sections and allow navigation, search, and quick resumption of reading. Also surface “Today’s focus” and recent notes to encourage continuity.  
- **Layout:** Three columns:
  - **Left Rail (TOC):** Collapsible tree of Parts→Chapters→Sections. Use a shadcn `Sidebar` or vertical nav component. Each section node shows a small progress bar or badge (e.g. “🟢● 60%”) reflecting how much of that section is read【5†L63-L69】. Unread sections are grey, completed are green.  
  - **Header (top of main area):** Contains a search input (`Input` with search icon) to query `/api/book/search`, a prominent “Continue Reading” (`Button primary`) linking to the last-opened section, and a bookmarks list or icon.  
  - **Main List:** Below the header, show each **Section** as a Card or list row (using shadcn `Card` or `Data Table`). Each item shows the section title, a one-line summary, and a progress indicator (e.g. a small `Progress` bar or “x% read” text). If bookmarked, show a star icon. Clicking the title opens the Reader on that section.  
  - **Right Rail:** “Today’s Focus” box: list 1–3 curated sections (Cards) for today (with title and short reason), each clickable. “Recent Notes” box: list latest notes (or “no notes” message), each linking to the note context.  
- **Components:**  
  - `Sidebar` or `ScrollArea` + nested `Button`/`List` for TOC.  
  - `Input` (search), `Button` (Continue, bookmarks toggle) in header.  
  - `Card` or `Alert`/`Badge` for section items.  
  - `Progress` bar or styled badge for progress.  
  - `Badge` or `Tag` for section tags.  
  - `DataTable` (alternative) for listing sections.  
  - `Tabs` or filter controls to switch between “All sections” vs “Unread”.  
  - `Card` or `Popover` in right rail for focus items and notes.  
- **Primary Actions:**  
  - Click section → open Reader (via `/reader/[slug]`).  
  - Search as-you-type → show dropdown results (maybe use shadcn `Command` or `Autocomplete`).  
  - Click “Continue” → resume last page.  
  - Toggle bookmark (star icon) on a section row.  
  - Expand/collapse parts and chapters in TOC.  
- **Empty States:**  
  - **No Search Results:** Show “No sections found. Try different keywords.” with an action to clear search.  
  - **No Focus / No Notes:** Show helper text. E.g. *“No focus sections selected. Mark a section to study as ‘Today’s Focus’.”* and *“No recent notes. As you read you can add notes to see them here.”* These messages follow NN/g advice to teach users about the feature【18†L242-L248】.  
  - **Error Loading Book:** Show an `Alert` saying “Failed to load book. Refresh or contact support.”  
- **States:**  
  - **Loading:** Skeletons for TOC (shadcn `Skeleton` lines) and a spinner or skeleton for section cards.  
  - **Error:** Inline error banner (`Alert variant="destructive"`) with retry.  
  - **Success:** TOC expanded as normal and list populated.  
- **“Full” Feel:** Even with minimal content, the page feels populated by:
  - The sidebar always shows the full TOC (no blank area).  
  - The header search bar and Continue button are always present.  
  - “Today’s Focus” and “Recent Notes” boxes (even if empty, they contain instructive text).  

## (1) Reader Wireframe Spec  
- **Purpose:** Display one section’s content for focused reading, and enable annotations (highlights, notes, bookmarks) and AI-assisted learning (via the Agent panel).  
- **Layout:** 
  - **Left Rail:** Same TOC sidebar (persistent) showing current section highlighted.  
  - **Header (above content):** Section title (and optional subtitle), with a bookmark toggle icon on right. Possibly breadcrumb of Part/Chapter.  
  - **Main Content (Center):** Section text in a typographically rich container (`<article class="prose">` via Tailwind Typography【11†L111-L119】). Required blocks within content (in a consistent order for every section):  
    1. **TL;DR:** Three bullet points summarizing the section. Place immediately under the title in a callout style. (Implement as a small `Card` or use a styled list with an info icon.)  
    2. **Body Text:** Paragraphs, headings, lists, etc., as authored. All headings should have `id` anchors for deep-linking【33†L114-L122】.  
    3. **Checklist:** A list (max 5 items) of key tasks or review questions related to the section. Use bullet list with checkmark icons (or a non-interactive Checkbox style).  
    4. **Common Mistakes:** Up to 3 pitfalls. Display in a red `Alert variant="destructive"` callout (with an “⚠️ Common Mistakes” title).  
    5. **Drill:** A single exercise or question. Show as a shaded `Card` or `Callout` box with label (e.g. “Drill: Try this exercise”).  
  - **Right Rail (Agent Panel):** List of skill buttons (see next section) for AI help.  
- **Components:**  
  - Content typography: use the Tailwind Typography plugin so raw HTML is automatically styled【11†L111-L119】.  
  - `Button` for “Add Note” or “Highlight” in content actions.  
  - For TL;DR and Mistakes, use `Card` or shadcn `Alert` (info/warning variants). E.g. “Checklist” might just be a styled list.  
  - `Avatar` or `Tag` for any tags attached to the section.  
- **Primary Actions:**  
  - **Highlighting/Notes:** Select text → a context-menu pops up (Popover) with options “Highlight”, “Add Note”, “Tag”. This flow echoes other readers (Adobe Digital Editions) which allow bookmarking and commenting on text【16†L108-L111】. Choosing “Highlight” marks the text (yellow). “Add Note” opens a side panel (or small dialog) to enter a note tied to that text. The resulting note is saved via `/api/notes`.  
  - **Bookmark Section:** Click star icon next to title to toggle bookmark for the whole section. This calls `/api/bookmarks/toggle`.  
  - **Follow Anchor Links:** Heading links can be clicked to jump or shared (the URL updates with `#anchor`).  
- **Empty States:**  
  - If a section has no TL;DR/checklist written by author, simply omit that block. (No empty placeholder needed if the author didn’t define it.)  
  - If user hasn’t taken any notes/highlights yet in this section, show subtle empty guidance, e.g. *“No highlights yet – select text to highlight or add notes.”*  
- **States:**  
  - **Loading:** Show a spinner in the content area or a skeleton of text lines.  
  - **Error:** `Alert` saying “Failed to load section. Try reloading.”  
- **“Full” Feel:** To avoid blank look, always display the standard blocks (TL;DR/checklist/mistakes) even if minimal. The Agent panel is always visible (so right side never empty). We also may show the section’s “Part > Chapter” context in header to fill space.  

## (2) Agent Panel Skill Specs (Contracts + UI)  
The right-hand Agent panel lists interactive learning tools. Each tool is a button or menu item; clicking it may open a small result pane or dialog. Below are each skill’s details:

- **Explain/Rephrase (Simple / Technical / Analogy):**   
  - *Label:* “Explain” (with a dropdown or segmented control offering “Simple”, “Technical”, “Analogy”).  
  - *Microcopy:* Tooltip or subtext: “Get a clear explanation in your chosen style.”  
  - *Input Context:* Uses the current section’s text (or the user’s selected text, if any) as context. The user first chooses style, then clicks “Run”.  
  - *Output:* 1–3 concise paragraphs or bullets summarizing/rephrasing the text. For analogy mode, uses metaphors. All output is shown in a scrollable panel below the button (or in a modal). Each explanation shows a note icon “Save as Note” to add it to user notes.  
  - *Save:* Can be copied or saved as a new note (via `/api/notes`). We may auto-tag it with “explanation”.  
  - *Guardrails:* Prepend or footer: “⚠️ Educational use only – not trading advice.” (Ensure no financial tips.) Keep tone factual.  
- **Socratic Tutor (Quiz Questions):**  
  - *Label:* “Socratic Tutor” (or “Tutor Q&A”).  
  - *Microcopy:* “Ask key questions to test your understanding.”  
  - *Context:* Uses current section content.  
  - *Output:* A list of 3–5 open-ended questions (e.g. “What is the main risk of a bear call spread?”). Display as numbered list. Below each question, user could “Check Answer” – we may show hints if answered. For MVP, we can skip interactive answering and just show questions.  
  - *Save:* Option to “Save as Note” each question, or “Save Q&A to Notes”.  
  - *Guardrails:* Emphasize learning intent (“Test your understanding – no trading advice.”).  
- **Flashcards/Quiz Generator:**  
  - *Label:* “Generate Quiz” (or “Flashcards”).  
  - *Microcopy:* “Create flashcards (Q&A) from this section.”  
  - *Context:* Section text.  
  - *Output:* 5–10 question-answer pairs. Format as a list of **Q:** … **A:** …. Include key terms.  
  - *Save:* Provide a “Copy to Notes” or “Export” button to save these pairs to user notes.  
  - *Guardrails:* “For study only. Review carefully.”  
- **Checklist Builder (Pre/During/Post):**  
  - *Label:* “Build Checklist”. Possibly a dropdown for “Pre-trade”, “During Trade”, “Post-trade”.  
  - *Microcopy:* “Outline steps to follow before/during/after trading this strategy.”  
  - *Context:* Section/topic focus.  
  - *Output:* A checklist of 3–5 actionable items (bulleted with checkboxes or similar). E.g. “Before: Confirm market conditions.”  
  - *Save:* “Save as Playbook Checklist” – creates/updates a draft playbook entry under “Checklists” for this section.  
  - *Guardrails:* Clearly state “Checklist items are guidelines for review, not specific trade instructions.”  
- **Scenario Tree Builder:**  
  - *Label:* “Build Scenario Tree”.  
  - *Microcopy:* “Map out If/Then outcomes for this strategy.”  
  - *Context:* Section text.  
  - *Output:* Textual decision tree (if… then… else…) with branches. Example: “If SPY rises → do X; if SPY falls → do Y.” Use indentation or bullet tree format.  
  - *Save:* “Save as Playbook Draft” – stores this decision tree under a draft playbook structure (via `/api/playbooks`).  
  - *Guardrails:* “This is a hypothetical model for learning, not a trading plan.”  
- **Notes Assistant:**  
  - *Label:* “Add Note”.  
  - *Microcopy:* “Create a note linked to this section.”  
  - *Context:* Pre-fills with selected text or section title.  
  - *UI:* Opens a small rich-text editor panel. User writes a note, chooses tags (autocomplete), and can link to any heading (anchor).  
  - *Output:* A new note entry (with optional tags/links).  
  - *Save:* Saves via `/api/notes`. The note appears on the Notes page. Also auto-saves highlights if text was selected.  
  - *Guardrails:* Standard note disclaimer.  
- **Optional – “Where does this show up in SPY?”:**  
  - *Label:* (Could be under Notes Assistant as “Backtest?”)  
  - *Microcopy:* “Find historical SPY occurrences of this concept (text only).”  
  - *Output:* Text summary linking concept to historical SPY events (no chart).  
  - *Guardrails:* *Text only – no live data or advice.*  

*(For all skills, we’ll prepend a short disclaimer like “For educational purposes only; not financial advice” in the UI.)*  

<hr>

**Stop Condition Summary:** The above completes the **Book UI** (Library & Reader) and **Agent panel** specifications in detail. Next, we will cover (3) Notes/Highlights/Bookmarks, (4) Playbook workflow, (5) Admin tools, and (6) placeholder pages, followed by the design system details, login/onboarding, build sequence, and final questions. Ready to continue.  

## (3) Notes / Highlights / Bookmarks / Progress  
- **Notes Page (Overview):** A page listing all user notes. Show note titles (linking to context), tags (using `Badge` chips), and an excerpt. Include filters: by tag (multi-select `Checkbox` list or `Input` search for tags) and by section (a dropdown of chapters/sections). Allow sorting by date or chapter. Each note row could have a backlink indicator (e.g. “Appears in Section 3.2”). *Recent Notes* on the Library and Reader are just snippets of this page.  
- **Backlinks:** Each note will list the section(s) it’s linked to (the Reader sends context on save). Optionally a “View in Section” link on each note to jump back to that Reader page/anchor.  
- **Highlighting Flow (Reader):** When user selects text in Reader, show a floating action toolbar (use shadcn `Popover` or custom menu) with options: “Highlight”, “Add Note”, “Tag”. “Highlight” simply colors the selection (stores the range via `/api/highlights`). This matches standard reader tools【5†L63-L69】【16†L108-L111】. If “Add Note” is chosen, open the Notes Assistant pre-filled with the text and section context. We ensure highlights and notes synchronize: clicking a highlighted span could also open its note.  
- **Bookmarks:** A bookmark icon (e.g. Lucide ⭐) next to the section title in the Reader and in the Library list. Toggling it calls `POST /api/bookmarks/toggle`. Bookmarks can be by section or by heading anchor if implemented. The UI will indicate bookmarked status (filled star vs outline). If a section is bookmarked, Library can also mark it with an icon.  
- **Reading Progress:** Upon loading each section, call `POST /api/progress` to mark it read. The Library aggregates these (via `/api/progress/summary`) to show overall progress. The “Continue” button directs to the most recent incomplete section. We may visualize progress in Library (e.g. progress bar on TOC) to satisfy the known expectation of tracking reading progress【5†L63-L69】.  

## (4) Playbooks (Draft → Review → Publish)  
- **Playbooks List:** Two tabs or filters: “Drafts” vs “Published”. Show each playbook name, creation date, and status. Use a `Table` or `Card` list. Published playbooks cannot be edited (shown as read-only). Include an “Archive” action for old ones (moves from Published to Archived).  
- **Playbook Detail:** Shows trigger(s), checklist(s), scenario tree, and linked sections:
  - **Triggers:** A list of conditions or titles defining when to use this playbook (editable only in draft).  
  - **Checklist:** Render the list of tasks (from Checklist Builder) with checkboxes (shadcn `Checkbox`), grouped by Pre/During/Post.  
  - **Scenario Tree:** Indent or bullet-format the If/Then branches (from Scenario builder). We can use a simple nested list for display.  
  - **Linked Sections:** Automatically show reference links to the book sections (anchors) that the playbook was derived from (e.g. “Based on Chapter 3”).  
  - Provide buttons: “Edit” (for draft), “Request Review” (moves draft to review state), “Publish” (for admin only), “Archive”.  
- **Lifecycle:** New playbooks start as Draft. User can “Submit for Review” (changes state, possibly notifying an admin). Admin can then “Publish” (via `POST /api/playbooks/:id/publish`). Once published, the playbook becomes active (and visible under Published, editable only by admin). Archiving a published playbook hides it. 

## (5) Admin (Minimal)  
- **Status Dashboard:** A simple panel (e.g. using `Card` or `Table`) showing: 
  - Last book import time/status, 
  - Last QMD reindex time/status (`/api/admin/book/reindex`), 
  - Last playbook publish time,
  - MongoDB health or version, 
  - Server health check (`/internal/health`). 
- **Controls:** 
  - **Reindex Book:** A button (“Reindex”) that calls `/api/admin/book/reindex` to trigger semantic index rebuild. Show spinner while running.  
  - **Publish All Drafts:** If any drafts exist, show a “Publish Drafts” button (admin-only) that approves pending playbooks.  
- **Audit Log:** A paginated table of recent admin actions (publish, archive, reindex) and agent runs (from `/internal/agent/run`). Columns: User, Action, Timestamp, Outcome. Provide simple filters (date range).  
- **Empty State:** If no issues (no errors to report), say “All systems are running normally.” with a green check icon. If no drafts, “No playbook drafts pending.” with brief instructions.

## (6) Placeholder Pages (Dashboard / Journal / Alerts)  
Each placeholder page will be lean:  
- **Dashboard:** Title “Dashboard (Coming Soon)”. Text: “Key metrics will appear here.” Show one clear action, e.g. “📖 Go to Library” or a disabled summary.  
- **Journal:** Title “Journal (Coming Soon)”. Text: “Your learning journal will be integrated here.” Action: “📕 View Notes” (link to Notes page).  
- **Alerts:** Title “Alerts (Coming Soon)”. Text: “Set up alert triggers to see notifications.” Action: “⚙️ Configure Alerts” (disabled or linking to filter controls).  
The tone is informative but empty. We avoid bulk — just a header, short text, and one stub action (button or link) per page to guide the user as per NN/g empty-state advice【18†L242-L248】.  

## Design System, Tokens, & Component Inventory  
- **Style & Tokens:** We adopt a calm, dark “research” palette: charcoal backgrounds, subtle grey surfaces, and a single accent color (e.g. teal or blue for buttons/links). Text uses a strong sans-serif (e.g. Inter) at 16–18px base with ~1.6 line-height (target ~60–66 characters per line for readability【52†L23-L27】). Spacing follows a scale (e.g. 0.5rem, 1rem, 1.5rem, 3rem, etc.). Rounded corners ~4–6px, slight shadows on cards. We’ll define design tokens in Tailwind’s theme (using the new `@theme` approach) so colors, fonts, and spacing come from one source【9†L58-L62】【27†L260-L264】. For example, Tailwind v4 allows declaring tokens (colors, radii, shadows) in `@theme`, generating utilities and CSS variables【9†L58-L62】.  
- **Accessibility Baseline:** All controls support keyboard and focus styles. We will use semantic HTML (e.g. `<button>`, `<label>`, etc.) and provide visible focus rings. Icons from Lucide should always be accompanied by text or `aria-label` (per Lucide guidance) so meaning isn’t conveyed by icon alone【51†L98-L104】. Contrast ratios exceed WCAG 2.1 AA. Interactive icons (star, info, etc.) are large enough (≥44×44px) for touch.  
- **Component Inventory (Tailwind+shadcn/ui):** We standardize on these components, preventing one-off widgets:  
  - **Buttons:** `Button` (primary/solid, secondary/outline, ghost, link variants) for all actions. For example, “Continue” uses Primary, “Cancel” uses Secondary, “Help” uses Link.  
  - **Inputs/Forms:** `Input` for text fields (search box), `Textarea` for note editing, `NativeSelect` or `Combobox` for dropdowns (e.g. filter by tag). `Form/Field` wrappers handle labels & errors.  
  - **Dropdowns/Menus:** `DropdownMenu` for any menu of actions (e.g. user menu, bookmarks list). `Popover` for context menus (e.g. text highlight menu). `Dialog` for modal interactions (e.g. confirm delete or login OTP).  
  - **Cards & Containers:** `Card` for section summaries and focus boxes; `Alert` for callouts (info/warning). `Separator` to divide sections.  
  - **Sidebar/Rails:** Use `Sidebar` or a flex container for left & right columns.  
  - **Tables/Data:** `DataTable` for lists (e.g. Playbooks list, Audit log), with pagination.  
  - **Chips/Tags:** Use `Badge` to display tags or statuses (e.g. “Draft”, or content tags).  
  - **Lists & Feedback:** `Accordion` or `Tabs` where needed. `Progress` bar (for section progress), `Spinner` for loading, `Skeleton` for blank loading content.  
  - **Notifications:** `Toast` for transient messages (e.g. “Note saved”).  
  - **Misc:** `Avatar` for user icon, `Kbd` for showing keyboard shortcuts (if any).  
- **Alternative Stack (Radix + Tailwind):** If not using shadcn, we would use Radix primitives for each element (e.g. Radix Dialog, Radix DropdownMenu, Radix Accordion, etc.) and then style them with Tailwind classes. Radix provides the same accessible foundations (unstyled, accessible primitives【40†L14-L18】); we’d build out variants and wrappers. In either stack, **no** custom one-off controls: all UIs must use these components. For consistency, we’ll enforce naming (e.g. “btn-primary”, “alert-destructive”) and have shared style guidelines in code reviews.  

## Login + Onboarding UX  
- **Login Screen:** A clean card centered on page. Fields: Email and Password (`Input` components) with clear labels. A “Login” button (`primary`). A “Forgot password?” link. Optionally a “Sign in with Google” button for convenience. Show error messages inline (e.g. “Invalid credentials.”) in red text under the form【46†L5-L8】. After 5 failed attempts, display: *“Too many attempts. Please try again in 5 minutes.”* (simple rate-limit feedback). Use secure patterns but keep UX light (no captcha unless needed). On success, redirect to `/library`.  
- **Onboarding Steps:** After first login, a quick wizard (3–4 steps) collects optional info:  
  1. **Name/Handle:** “What should we call you?” – an input pre-filled with profile name.  
  2. **Notifications (Placeholder):** “Stay tuned for updates.” (option to enable email notifications later).  
  3. **Learning Goal:** Ask “What’s your primary trading goal?” with a short answer input (helps personalize content focus).  
  4. **Guardrails Pref:** Brief note on “We provide education only; you can review our policy here.” (no real input, just acknowledgement).  
  5. **Finish:** “Let’s explore the Book!” with a start button.  
  Users can skip steps. Provide a progress indicator (step 1 of 3). UX must handle errors (e.g. email already used) clearly. Minimal fluff – each screen has 1–2 inputs/instructions.  

## MVP Build Sequence & Acceptance Criteria  
1. **Design System Setup:** Install Next.js/Tailwind/shadcn (or Radix) framework. Define theme tokens (colors, spacing, fonts) per above. Build basic layout and navigation components.  
   - *Accept:* Basic layout loads without empty space; theming variables work.  
2. **Library UI:** Implement the TOC sidebar (`/api/book/toc`), section listing (calls `/api/book/section?slug` on click), search input (`/api/book/search`), and progress indicators. Include progress saving (`POST /api/progress`) and “Continue” logic. Ensure collapsible chapters work.  
   - *Accept:* User can see all sections, expand/collapse parts, click to open Reader, and see “Continue” scroll to last section. Loading and error states display properly (skeletons or alerts).  
3. **Reader UI:** Render section content with typography plugin. Add TL;DR, checklist, mistakes, drill blocks (even if empty). Implement text highlighting: selection → toolbar with “Highlight/Add Note” actions. Save highlights via `/api/highlights` and notes via `/api/notes`. Bookmarks call `/api/bookmarks/toggle`.  
   - *Accept:* Section content appears formatted. Highlighting and note-taking works end-to-end (saved to DB and visible). Bookmark icon toggles correctly.  
4. **Agent Panel Skills:** Build the right column UI with buttons/dropdowns for each skill. Hook up to `/api/agent/skill` (single endpoint, send skill name + context). Display returned structured output (formatted Q&A, lists, etc.) in the panel. Include “Save to Note/Playbook” actions.  
   - *Accept:* Each skill button generates output (mock or actual AI). Users can copy or save results as notes or drafts. Guardrail disclaimer is visible.  
5. **Notes & Progress:** Create the Notes page with filterable note list (`/api/notes`). Ensure notes and highlights persist and are linked to sections. Show reading progress summary on Library (using `/api/progress/summary`). Implement “Recent Notes” component on Library.  
   - *Accept:* Notes are searchable by tag or text, backlinks show section context, and reading progress updates as sections are viewed.  
6. **Playbooks:** Build the Playbooks list (`GET /api/playbooks`) and detail view. Implement draft editing (title, triggers, add checklist items, scenario nodes). Admin “Publish” button calls `POST /api/playbooks/:id/publish`. Archive toggles call `:archive`.  
   - *Accept:* Create and edit a draft, then as admin publish it. Published playbooks appear in list as read-only. Checklist and scenario items can be added and saved.  
7. **Admin Tools:** Add an admin-only `/admin` page. Show status via `GET /api/admin/status`. “Reindex” button calls `/api/admin/book/reindex`. Show a basic audit log.  
   - *Accept:* Admin sees current statuses, can trigger reindex (and see success/error), and view recent admin actions.  
8. **Placeholders:** Create simple pages for Dashboard/Journal/Alerts as described.  
   - *Accept:* Visiting those routes shows the “coming soon” messages and suggested actions (no blank UI).  

**Acceptance Criteria for Shippable Book UI:** Users must be able to fully navigate the Library and Reader without encountering empty screens or silent failures. All specified blocks (TOC, search, content blocks, highlights, notes) function, and all API calls show status/errors. Typography and spacing are implemented as planned.  

## Minimal Open Questions  
- Should we assume any existing branding (specific accent color, logo) to use, or shall we define a new accent (e.g. teal/blue) ourselves?  
- Is “Journal” intended to be the same as the Notes page or a separate concept? Clarifying this will ensure we don’t duplicate functionality.  
- For mobile users, should the UI collapse to a 1‑column view, or is desktop the primary target? (This affects how the 3-column layout should adapt.)  
- Are users expected to have social login (Google/GitHub), or is email/password sufficient for MVP?  

