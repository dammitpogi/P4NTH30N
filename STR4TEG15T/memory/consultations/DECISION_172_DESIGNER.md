# Designer Consultation: DECISION_172

## Executive Summary

DECISION_172 establishes a well-architected Book-First MVP.

The specification suite is comprehensive, covering architecture, security, data modeling, design systems, and endpoint contracts. The pivot from OpenClaw-first to Book-first is sound, prioritizing educational content delivery over agent-centric interaction. The Calm Research UI design system provides a strong foundation with shadcn/ui components, though the 3-column responsive strategy and Core container bundling require additional attention during implementation.

## Architecture Assessment

### Feasibility: High

The 3-service architecture is well-defined and aligns with modern deployment patterns:
- Next.js as sole public entry point simplifies security and identity management
- Internal-only Core container (OpenClaw + QMD + SFTPGo) provides clean service boundaries
- MongoDB for persistence with comprehensive schema covering all MVP entities
- Railway deployment with sleep/scale-to-zero tolerance is practical for MVP stage

### Coherence: Strong

The architecture demonstrates strong internal consistency:
- Clear public/private boundary enforcement (browser to Next.js only)
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

All required components are available in shadcn/ui:

**Navigation and Layout:**
- NavigationMenu - Top app bar navigation
- ScrollArea - Independent column scrolling (3-column shell)
- CommandDialog - Global Ctrl+K command palette
- DropdownMenu - Profile/actions menu
- Sheet - Mobile navigation drawer
- Breadcrumb - Reader location (Part/Chapter/Section)
- Separator - Minimal dividers

**Core Controls:**
- Button - All button variants (primary, secondary, ghost, link)
- Input - Form inputs
- Textarea - Note composition
- Select - Dropdown selections
- Combobox - Tag filtering, section search
- Toggle / Switch - Boolean preferences
- Tabs - Simple/Technical/Analogy modes, Draft/Published playbooks
- Tooltip - Help text, icon explanations
- Dialog - Modals, confirmations
- Toast / Sonner - Notifications, save confirmations
- Accordion - TOC tree (Parts/Chapters), Playbook sections

**Content Display:**
- Card - Part cards, status cards, agent output
- Badge - Tags, status indicators, New labels
- Progress - Reading progress bars
- Table - Audit logs, admin lists
- Skeleton - Loading states

**Specialized:**
- Popover - Tag filter dropdowns
- Alert - Error messages, admin status

### Needs Custom

1. **Highlight Tool** - Text selection to floating toolbar for highlight/note/copy
2. **Note Composer** - Multi-field form with tags, anchor linking
3. **Bookmark Toggle** - Animated save state indicator
4. **Agent Output Renderer** - Structured display for different skill output types (text, Q and A, cards, checklist, tree)
5. **TOC Tree** - Collapsible Part/Chapter/Section navigation (can build from Accordion primitives)
6. **Reader Typography Wrapper** - prose prose-invert with custom overrides

### Gaps

1. **OTP Input** - Mentioned in login spec but not critical for MVP
2. **Stepper** - Onboarding flow - can use Tabs or custom build
3. **Flashcard/Quiz Renderer** - Agent panel output format needs custom component
4. **Scenario Tree Visualizer** - If/Then tree for playbooks needs custom implementation

## Layout Validation

### 3-Column Shell: Concerns

The specified layout dimensions:
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
- Greater than or equal to 1440px: Full 3-column layout
- 1280-1439px: Collapse right rail to collapsible panel (toggle button)
- Less than 1280px: Left rail becomes hamburger menu, right rail becomes bottom sheet or tab

### Responsive Strategy: Needs Specification

The specs do not define responsive behavior for the 3-column shell. Critical decisions needed:

1. **Tablet (768-1024px)**: Stack columns or convert to tabbed interface?
2. **Mobile (less than 768px)**: Single column with navigation drawer + bottom sheet for agent panel?
3. **Right rail agent panel**: How to access on small screens? Fixed toggle? Slide-out?

**Recommended approach**:
- Use Sheet component for left rail on mobile
- Use Sheet or bottom Dialog for right rail agent panel on mobile
- Maintain center Reader as primary viewport at all sizes

## Data Flow Validation

### Next.js to Core: Valid

The internal API contract is well-defined:
- POST /internal/search - QMD retrieval
- POST /internal/agent/run - OpenClaw agent execution
- POST /internal/index/rebuild|status - Indexing operations
- GET /internal/health - Health checks

**Authentication**: Authorization: Bearer service token with JWT claims or trusted headers (X-User-Id, X-User-Role)

**Validation**: Contract supports all required flows:
- Reader to QMD for related content (optional)
- Agent panel to OpenClaw for skill execution
- Admin to Indexing operations

### Core to MongoDB: Valid

MongoDB is internal-only, no public port. Access from Service A (Next.js) and optionally Service B (Core). Preferred: Web (Next.js) owns DB access; Core accesses only if necessary.

**Schema alignment**: 10 collections defined that support all UI flows:
- book_sections + book_toc to Library, Reader
- notes + highlights + bookmarks + reading_progress to Reader interactions
- playbooks to Playbooks module
- agent_runs + audit_log to Admin, observability

### Caching Strategy: Recommendation

**Current spec gaps**: No caching strategy is defined. Recommendations:

1. **Book TOC**: Cache aggressively - changes only on publish/reindex
   - Next.js ISR: revalidate 3600 (1 hour) with on-demand revalidation on publish

2. **Book Sections**: Cache at edge
   - ISR: revalidate 86400 (24 hours) - content is static once published

3. **User Data (notes, highlights, progress)**: No caching
   - Always fresh from MongoDB
   - Optimistic UI updates for mutations

4. **QMD Search Results**: Short cache
   - 5-minute client-side cache for identical queries

5. **Agent Outputs**: Cache selectively
   - Same section + same skill = potentially cacheable
   - But agent responses may vary - consider no caching for MVP

## Approval Score: 88/100

### Scoring Breakdown

| Criterion | Score | Max | Rationale |
|-----------|-------|-----|-----------|
| Architecture coherence | 18/20 | 20 | Clean 3-service topology with clear boundaries. Core container bundling adds slight complexity. |
| Component feasibility | 19/20 | 20 | All shadcn/ui components available. Only 6 custom components needed, all straightforward. |
| Layout viability | 16/20 | 20 | 3-column shell works but responsive strategy is underspecified. Width calculations exceed common screens. |
| Data flow correctness | 18/20 | 20 | Solid endpoint contracts, proper auth boundary. MongoDB schema supports all flows. Minor gap: caching strategy. |
| Implementation clarity | 17/20 | 20 | Well-specified overall. Core container startup order, health checks, and responsive breakpoints need detail. |

**Total**: 88/100

## Recommendations

### Must Address

1. **Define Responsive Breakpoints for 3-Column Collapse**
   - Specify exact breakpoints where right rail collapses
   - Define mobile navigation pattern (Sheet vs tab bar)
   - Document agent panel access on small screens

2. **Clarify Core Container Startup Order**
   - Document OpenClaw vs QMD vs SFTPGo initialization sequence
   - Define health check endpoints for each component
   - Specify failure mode: what happens if one component fails?

3. **Add MongoDB Connection Pooling Guidance**
   - Connection pool size for Railway deployment
   - Retry logic for transient connection failures
   - Connection string best practices

4. **Specify Sleep/Scale-to-Zero UX**
   - Loading states for agent panel when Core is sleeping
   - Fallback messaging for search when QMD unavailable
   - Retry mechanism with exponential backoff

### Should Consider

1. **Add Redis for Session Store**
   - If scale-to-zero causes auth issues with in-memory sessions
   - Railway Redis add-on is low-effort
   - Enables horizontal scaling later

2. **Consider PWA Offline Support for Reader Content**
   - Cache book sections for offline reading
   - Service worker for continue reading offline
   - Background sync for notes/highlights when reconnected

3. **Add Image Optimization Strategy**
   - If book content includes diagrams/charts
   - Next.js Image component configuration
   - CDN or Railway volume for image assets

4. **Define Animation Standards**
   - Page transitions (if any)
   - Loading state animations
   - Micro-interactions (button hovers, toggle states)

### Nice to Have

1. **Theme Switching (Light/Dark)**
   - Spec says dark baseline only
   - Consider light mode for accessibility
   - next-themes integration is straightforward

2. **Keyboard Shortcut Customization**
   - MVP defines fixed shortcuts (Ctrl+K, n, b, ?)
   - Future: user-customizable shortcuts
   - Store preferences in users.prefs

3. **Reader Font Size Preferences**
   - Add to users.prefs schema
   - 3 sizes: small (14px), medium (16px), large (18px)
   - Apply via CSS custom properties

4. **Progressive Web App (PWA) Manifest**
   - Installable app experience
   - Standalone display mode
   - App icons and splash screen

5. **Analytics Integration**
   - Privacy-focused (Plausible or Fathom)
   - Track: section views, skill usage, playbook creation
   - No Google Analytics (privacy-conscious users)

## Consultation Log

- Date: 2026-02-28
- Models: Kimi K2
- Time spent: ~20 minutes
- Documents reviewed:
  - DECISION_172_BOOK_FIRST_MVP_ARCHITECTURE.md
  - 00-DECISION_UI_FOUNDATION.md
  - 01-SPEC_RAILWAY_ARCHITECTURE.md
  - 02-SPEC_NETWORKING_SECURITY.md
  - 03-SPEC_MONGO_SCHEMA.md
  - 04-TECHP_DESIGN_SYSTEM.md
  - 06-SPEC_UI_LAYOUTS.md
  - 09-SPEC_ENDPOINT_CONTRACT.md

---

*Designer Consultation for DECISION_172*
*Book-First MVP Architecture Assessment*
*2026-02-28*
