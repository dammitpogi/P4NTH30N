# Designer Consultation: DECISION_172

## Executive Summary

DECISION_172 establishes a well-architected Book-First MVP with a clear 3-service topology (Next.js web, Core container, MongoDB) and a stable 3-column UI shell. The specification suite is comprehensive, covering architecture, security, data modeling, design systems, and endpoint contracts. The pivot from OpenClaw-first to Book-first is sound, prioritizing educational content delivery over agent-centric interaction. The "Calm Research UI" design system provides a strong foundation with shadcn/ui components, though the 3-column responsive strategy and Core container bundling require additional attention during implementation.

## Architecture Assessment

### Feasibility: High

The 3-service architecture is well-defined and aligns with modern deployment patterns:
- **Next.js as sole public entry point** simplifies security and identity management
- **Internal-only Core container** (OpenClaw + QMD + SFTPGo) provides clean service boundaries
- **MongoDB for persistence** with comprehensive schema covering all MVP entities
- **Railway deployment** with sleep/scale-to-zero tolerance is practical for MVP stage

### Coherence: Strong

The architecture demonstrates strong internal consistency:
- Clear public/private boundary enforcement (browser → Next.js only)
- Well-defined endpoint contracts between services
- MongoDB schema directly supports UI flows (Reader, Notes, Playbooks)
- Design system tokens align with layout specifications
- All specs reference each other appropriately (no contradictions found)

### Key Risks

1. **3-Column Layout Responsiveness**: The 280px left rail + 760px center + 360px right rail = 1400px minimum width exceeds typical laptop screens (1366px). Responsive collapse strategy is unspecified.

2. **Core Container Complexity**: Bundling OpenClaw + QMD + SFTPGo in one container creates operational complexity. Startup order, health checks, and failure modes need clarification.

3. **QMD Integration**: QMD is specified as primary retrieval engine but is a new component. Integration risk exists around indexing pipeline and search result formatting.

4. **Service-to-Service Auth**: JWT/shared token implementation is specified but not detailed. Token rotation, expiration, and revocation need implementation guidance.

5. **Sleep/Scale-to-Zero UX**: Core container sleeping will cause delayed agent/search responses. UI loading states and fallback messaging need specification.

## Component Inventory

### Available in shadcn/ui

All required components are available in shadcn/ui [1](https://ui.shadcn.com/docs/components):

**Navigation & Layout:**
- `NavigationMenu` - Top app bar navigation
- `ScrollArea` - Independent column scrolling (3-column shell)
- `CommandDialog` - Global ⌘K command palette
- `DropdownMenu` - Profile/actions menu
- `Sheet` - Mobile navigation drawer
- `Breadcrumb` - Reader location (Part/Chapter/Section)
- `Separator` - Minimal dividers

**Core Controls:**
- `Button` - All button variants (primary, secondary, ghost, link)
- `Input` - Form inputs
- `Textarea` - Note composition
- `Select` - Dropdown selections
- `Combobox` - Tag filtering, section search
- `Toggle` / `Switch` - Boolean preferences
- `Tabs` - Simple/Technical/Analogy modes, Draft/Published playbooks
- `Tooltip` - Help text, icon explanations
- `Dialog` - Modals, confirmations
- `Toast` / `Sonner` - Notifications, save confirmations
- `Accordion` - TOC tree (Parts/Chapters), Playbook sections

**Content Display:**
- `Card` - Part cards, status cards, agent output
- `Badge` - Tags, status indicators, "New" labels
- `Progress` - Reading progress bars
- `Table` - Audit logs, admin lists
- `Skeleton` - Loading states

**Specialized:**
- `Popover` - Tag filter dropdowns
- `Alert` - Error messages, admin status

### Needs Custom

1. **Highlight Tool** - Text selection → floating toolbar for highlight/note/copy (per 06-SPEC_UI_LAYOUTS.md §7.1)
2. **Note Composer** - Multi-field form with tags, anchor linking (per 06-SPEC_UI_LAYOUTS.md §3.1)
3. **Bookmark Toggle** - Animated save state indicator (per 06-SPEC_UI_LAYOUTS.md §7.1)
4. **Agent Output Renderer** - Structured display for different skill output types (text, Q&A, cards, checklist, tree)
5. **TOC Tree** - Collapsible Part/Chapter/Section navigation (can build from Accordion primitives)
6. **Reader Typography Wrapper** - `prose prose-invert` with custom overrides (per 04-TECHP_DESIGN_SYSTEM.md)

### Gaps

1. **OTP Input** - Mentioned in login spec (06-SPEC_UI_LAYOUTS.md §6.1) but not critical for MVP
2. **Stepper** - Onboarding flow (06-SPEC_UI_LAYOUTS.md §6.2) - can use Tabs or custom build
3. **Flashcard/Quiz Renderer** - Agent panel output format needs custom component
4. **Scenario Tree Visualizer** - If/Then tree for playbooks needs custom implementation

## Layout Validation

### 3-Column Shell: Concerns

The specified layout dimensions from 06-SPEC_UI_LAYOUTS.md §1.1 and 04-TECHP_DESIGN_SYSTEM.md:
- Container: max-w-[1280px]
- Left rail: w-[280px]
- Right rail: w-[360px]
- Center: max-w-[760px] (reader)

**Total minimum width**: 280 + 760 + 360 = 1400px (excluding gaps)

**Concern**: This exceeds common laptop widths:
- 1366px (common laptop)
- 1440px (MacBook Air)
- 1920px (desktop)

**Recommendation**: Define responsive breakpoints:
- **≥1440px**: Full 3-column layout
- **1280-1439px**: Collapse right rail to collapsible panel (toggle button)
- **<1280px**: Left rail becomes hamburger menu, right rail becomes bottom sheet or tab

### Responsive Strategy: Needs Specification

The specs do not define responsive behavior for the 3-column shell. Critical decisions needed:

1. **Tablet (768-1024px)**: Stack columns or convert to tabbed interface?
2. **Mobile (<768px)**: Single column with navigation drawer + bottom sheet for agent panel?
3. **Right rail agent panel**: How to access on small screens? Fixed toggle? Slide-out?

**Recommended approach** (per 06-SPEC_UI_LAYOUTS.md §1.1 mentions `Sheet` for mobile):
- Use `Sheet` component for left rail on mobile
- Use `Sheet` or bottom `Dialog` for right rail agent panel on mobile
- Maintain center Reader as primary viewport at all sizes

## Data Flow Validation

### Next.js → Core: Valid

The internal API contract (09-SPEC_ENDPOINT_CONTRACT.md §3) is well-defined:
- `POST /internal/search` - QMD retrieval
- `POST /internal/agent/run` - OpenClaw agent execution
- `POST /internal/index/rebuild|status` - Indexing operations
- `GET /internal/health` - Health checks

**Authentication**: `Authorization: Bearer <service token>` with JWT claims or trusted headers (`X-User-Id`, `X-User-Role`)

**Validation**: Contract supports all required flows:
- Reader → QMD for related content (optional)
- Agent panel → OpenClaw for skill execution
- Admin → Indexing operations

### Core → MongoDB: Valid

Per 01-SPEC_RAILWAY_ARCHITECTURE.md §1:
- MongoDB is internal-only, no public port
- Access from Service A (Next.js) and optionally Service B (Core)
- Preferred: Web (Next.js) owns DB access; Core accesses only if necessary

**Schema alignment**: 03-SPEC_MONGO_SCHEMA.md defines 10 collections that support all UI flows:
- `book_sections` + `book_toc` → Library, Reader
- `notes` + `highlights` + `bookmarks` + `reading_progress` → Reader interactions
- `playbooks` → Playbooks module
- `agent_runs` + `audit_log` → Admin, observability

### Caching Strategy: Recommendation

**Current spec gaps**: No caching strategy is defined. Recommendations:

1. **Book TOC**: Cache aggressively - changes only on publish/reindex
   - Next.js ISR: `revalidate: 3600` (1 hour) with on-demand revalidation on publish
   - Or: Client-side cache with `stale-while-revalidate`

2. **Book Sections**: Cache at edge
   - ISR: `revalidate: 86400` (24 hours) - content is static once published
   - On-demand revalidation on content update

3. **User Data (notes, highlights, progress)**: No caching
   - Always fresh from MongoDB
   - Optimistic UI updates for mutations

4. **QMD Search Results**: Short cache
   - 5-minute client-side cache for identi
