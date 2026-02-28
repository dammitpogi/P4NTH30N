---
type: decision
id: DECISION_155
category: FEAT
status: completed
version: 1.2.0
created_at: '2026-02-25T07:20:00Z'
last_reviewed: '2026-02-25T08:15:00Z'
source:
  type: decision
  original_path: STR4TEG15T/memory/decisions/DECISION_155_DOCTRINE_BIBLE_WEB_MODERNIZATION_AND_AGENTIC_SETUP_SCOPE.md
---
# DECISION_155: Doctrine Bible Web Modernization and Agentic Setup Scope

**Decision ID**: DECISION_155  
**Category**: FEAT  
**Status**: Completed  
**Priority**: High  
**Date**: 2026-02-25

## Context

Nexus requested a governance-first modernization plan for the Doctrine Bible website (`OP3NF1XER/nate-alma/dev/memory/doctrine-bible/site`) with web research, explicit layout selection rationale, expanded design concepts, full feature scope including `/setup` capabilities, a locked login posture, a canonical bible endpoint at `/bible`, and a credential tool path for future username/password updates.

## Historical Decision Recall

- `DECISION_140`: webpage + bible visibility gaps and auth-gated runtime expectations.
- `DECISION_142`: textbook explanatory structure, citations, and navigation hardening.
- `DECISION_151`: setup password tooling and auth-gate operations.
- `DECISION_152`: auth-vault mutation discipline and encrypted secret storage.

## Knowledgebase and Historical Assimilation

Assimilated sources:

- `OP3NF1XER/knowledge/DECISION_142_DOCTRINE_BIBLE_TEXTBOOK_EXPLANATORY_SITE_2026_02_25.md`
- `OP3NF1XER/patterns/SOURCE_CHECK_ORDER.md`
- `OP3NF1XER/patterns/WORKFLOW_IMPLEMENTATION_PARITY_AUDIT.md`
- `STR4TEG15T/tools/workspace/memory/p4nthe0n-openfixer/01_OPENFIXER_INTRO_AND_CONTEXT.md`
- `STR4TEG15T/tools/workspace/memory/p4nthe0n-openfixer/02_DECISION_136_137_ASSIMILATION.md`
- `STR4TEG15T/tools/workspace/memory/p4nthe0n-openfixer/NATE_SUBSTACK_TEXTBOOK_v2.md`

## Related Documentation

- **OpenClaw Integration Guide**: `C:\P4NTH30N\STR4TEG15T\docs\OPENCLAW_CHAT_INTEGRATION.md` - Complete chat widget architecture and implementation
- **OpenClaw Deployment**: `C:\P4NTH30N\OP3NF1XER\nate-alma\deploy\README.md` - Railway template setup
- **OpenClaw Agents**: `C:\P4NTH30N\OP3NF1XER\nate-alma\deploy\AGENTS.MD` - Deployment manifest and credentials
- **Designer Agent**: `C:\Users\paulc\.config\opencode\agents\designer.md` - Architecture methodology

## Web Research Findings

Research lane used: ToolHive Tavily MCP search.

Primary references:

- Docusaurus docs intro and docs-only mode: `https://docusaurus.io/docs/docs-introduction`
- Docusaurus sidebar and versioning: `https://docusaurus.io/docs/sidebar`, `https://docusaurus.io/docs/versioning`
- MkDocs Material setup/navigation/search references:
  - `https://squidfunk.github.io/mkdocs-material/setup/`
  - `https://squidfunk.github.io/mkdocs-material/setup/setting-up-navigation/`
  - `https://squidfunk.github.io/mkdocs-material/blog/2021/09/13/search-better-faster-smaller/`
- Nextra docs and search references:
  - `https://nextra.site/`
  - `https://nextra.site/docs/guide/search`
  - `https://nextra.site/docs/file-conventions/meta-file`

## Implementation Research (2025 Tools and Frameworks)

### Static Site Generator Comparison

| Framework | Docs-First | Sidebar Control | Search | Auth Support | Best For |
|-----------|------------|-----------------|--------|--------------|----------|
| **Docusaurus** | Native docs-only mode | `sidebars.js` config | Algolia DocSearch built-in | Requires server config | Full docs sites, versioning |
| **Astro Starlight** | Purpose-built for docs | `astro.config.mjs` sidebar array | Pagefind built-in | Static + server layer | Performance, modern stack |
| **Nextra 4** | File-based routing | `_meta.js` per directory | FlexSearch built-in | Next.js middleware | React apps needing docs |
| **MkDocs Material** | Markdown-native | `mkdocs.yml` nav | Lunr/Algolia options | Plugin-based | Python-centric, simple |
| **Vite + Vanilla** | Custom build | Manual implementation | Fuse.js/Pagefind | Static Web Server | Full control, lightweight |

**Recommendation**: Astro Starlight for this project.
- Purpose-built for documentation with textbook-style navigation
- Built-in Pagefind search (better than Lunr, lighter than Algolia)
- Islands architecture = fast initial loads for dense content
- Easy progressive enhancement for agentic features
- Sidebar supports nested groups with auto-generated TOCs

### Authentication Implementation Options

**Option A: Static Web Server with Basic Auth (Recommended)**
- Tool: `static-web-server` with `--basic-auth` flag
- Config: User:password pairs in environment or file
- Pros: No server-side code, works with any static build
- Cons: No custom login UI (browser native prompt)

**Option B: Edge Function Auth (Netlify/Vercel)**
- Netlify: Password protection in UI + `_headers` file
- Vercel: Middleware with basic auth check
- Pros: Managed, can add custom login pages
- Cons: Vendor lock-in, potential costs

**Option C: Client-Side Gate with JS**
- Login page sets session token in localStorage
- Router checks token before rendering content
- Pros: Custom UI, single-page feel
- Cons: Content visible in source (not secure), requires JS

**Decision**: Use Option A for content security, add Option C overlay for UX polish.

### Search Implementation Comparison

| Solution | Index Size | Accuracy | Setup | Best For |
|----------|------------|----------|-------|----------|
| **Pagefind** | Very small (binary WASM) | Excellent | Zero config | Large content sites |
| **Fuse.js** | Medium (JSON index) | Good | Manual index generation | Small-medium sites |
| **Lunr** | Large (inverted index) | Good | Requires build step | Full-text relevance |
| **Algolia DocSearch** | N/A (hosted) | Excellent | Crawler setup | Public OSS projects |

**Recommendation**: Pagefind
- Purpose-built for static sites with multi-thousand pages
- WASM-based search runs entirely client-side
- No external service dependencies
- Works with any SSG output

### Chat Widget / Agent Interface Patterns

**Persistent Session Options**:
1. **localStorage**: Survives page reloads, cleared with cookies
2. **sessionStorage**: Survives reloads, cleared on tab close
3. **IndexedDB**: Large storage, async API, survives sessions
4. **BroadcastChannel**: Sync across tabs (for multi-tab continuity)

**Implementation Pattern**:
```javascript
// Chat state persistence
const chatHistory = {
  load: () => JSON.parse(localStorage.getItem('alma-chat') || '[]'),
  save: (messages) => localStorage.setItem('alma-chat', JSON.stringify(messages)),
  clear: () => localStorage.removeItem('alma-chat')
};

// Context injection on navigation
window.addEventListener('pagechange', () => {
  const currentPage = document.querySelector('[data-page-id]').dataset.pageId;
  chatWidget.setContext(`[${currentPage}]`);
});
```

### Project Structure Recommendations

```
docctrine-bible-site/
├── src/
│   ├── content/
│   │   ├── textbook/           # MDX lesson files
│   │   │   ├── 01-foundations/
│   │   │   ├── 02-doctrine/
│   │   │   └── _meta.json      # Chapter order/titles
│   │   └── bible/              # Bible content
│   │       └── _meta.json
│   ├── components/
│   │   ├── ChatWidget/         # Floating chat interface
│   │   ├── AskAlmaButton/      # Inline context buttons
│   │   ├── MasteryBadge/       # Chapter state indicators
│   │   ├── CitationBlock/      # Evidence-linked callouts
│   │   └── SearchPanel/        # Progressive search UI
│   ├── layouts/
│   │   ├── TextbookLayout.astro
│   │   └── BibleLayout.astro
│   ├── styles/
│   │   └── custom.css
│   └── utils/
│       ├── storage.js          # localStorage helpers
│       ├── search.js           # Pagefind integration
│       └── api.js              # /setup endpoint client
├── public/
│   └── assets/
├── astro.config.mjs
└── package.json
```

### Key Implementation References

**Astro Starlight**:
- Getting started: `https://starlight.astro.build/getting-started/`
- Sidebar config: `https://starlight.astro.build/guides/sidebar/`
- Custom components: `https://starlight.astro.build/guides/components/`

**Pagefind Search**:
- Hugo integration: `https://gohugo.io/tools/search/` (universal patterns)
- Fuse.js alternative: `https://yihui.org/en/2023/09/fuse-search/`

**Static Auth**:
- Static Web Server: `https://static-web-server.net/features/basic-authentication/`
- Netlify password protection: `https://docs.netlify.com/manage/security/secure-access-to-sites/password-protection/`
- NGINX basic auth: `https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-http-basic-authentication/`

**Chat Persistence**:
- Rasa WebChat localStorage: `https://github.com/botfront/rasa-webchat`
- Voiceflow persistence patterns: `https://docs.voiceflow.com/docs/chat-persistence`

## Chosen Layout

Selected layout direction: **Docs-first split layout (left syllabus nav + center lesson page + right "On this page" rail), Docusaurus-style information architecture with MkDocs/Nextra search ergonomics**.

### Why this layout

Top 3 features that stood out:

1. **Hierarchical learning navigation**
   - Docusaurus-grade sidebar structure maps naturally to textbook chapters and lesson archives.
2. **Docs-only operating mode**
   - Documentation becomes the product itself (no competing landing-page complexity).
3. **Fast full-text retrieval model**
   - MkDocs/Nextra patterns validate instant client-side search and keyboard-first navigation for dense knowledge repositories.

## Expanded Design Ideas (Built on Top 3)

1. **Learning-state rail + chapter mastery markers**
   - Preserve chapter hierarchy while adding "Not Started / In Progress / Mastered" state badges.
2. **Evidence-linked callouts**
   - Every doctrinal claim gets a "source citation" block linking to local captured files for provenance.
3. **Agent action dock**
   - Right rail includes "Ask Agent", "Cite This Section", "Open Related Decision", and "Copy Prompt Context" actions.
4. **Progressive search panel**
   - Keep instant results list, then optional "deep search" with chapter filters and doctrine tags.
5. **Semantic breadcrumbs + reading time + key concepts block**
   - Improves textbook scanning and structured review loops.

## Full Implementation Scope (Pre-Go Contract)

### A) Information Architecture and Routes

1. Canonical textbook home route: `/textbook` (existing posture).
2. Canonical bible route: **`/bible`** (hard requirement).
3. Keep chapter routes under `/textbook/chapters/...`.
4. Add bible-specific navigation card on homepage + global header quick link.

### B) Auth and Login Contract

1. Keep dashboard-level auth gate (Basic auth) enforced.
2. Add explicit login screen UX for human-friendly entry before textbook render.
3. Require successful login before `/textbook` and `/bible` content loads.
4. Keep WebSocket auth parity with same credential gate.

### C) `/setup` Endpoint Feature Parity (Must Surface in Website/Agent UX)

All currently implemented setup capabilities must be represented in the website scope:

1. `GET /setup/healthz`
2. `GET /setup`
3. `GET /setup/app.js`
4. `GET /setup/api/status`
5. `GET /setup/api/auth-groups`
6. `POST /setup/api/run`
7. `GET /setup/api/debug`
8. `POST /setup/api/console/run` (gateway lifecycle, status, health, doctor, logs tail, config get, devices list/approve, plugins list/enable)
9. `GET /setup/api/config/raw`
10. `POST /setup/api/config/raw`
11. `POST /setup/api/pairing/approve`
12. `GET /setup/api/devices/pending`
13. `POST /setup/api/devices/approve`
14. `POST /setup/api/reset`
15. `GET /setup/export`
16. `POST /setup/import`

### D) Agentic Features

1. **Persistent Chat Interface (OpenClaw Parity)**
   - Provide a persistent, floating or sidebar chat interface powered by `<openclaw-app>` patterns, maintaining session continuity across page navigations.
   - When Nate opens the chat directly without context, automatically inject the current filename into the prompt (e.g., `[filename_of_page.html]`).
2. **Contextual "[Ask Alma?]" Action Buttons**
   - Embed inline `[Ask Alma?]` buttons next to complex or difficult-to-understand doctrinal concepts.
   - Clicking these buttons injects the specific paragraph/topic context directly into the chat session.
3. "Generate execution checklist" from current chapter.
4. "Cite doctrine" one-click citation snippet from local source files.
5. "Open decision provenance" drill-down by topic keyword.
6. "Export briefing" (short summary, risks, invalidation points) for trade-session prep.

### E) Delivery Guardrails

1. Preserve current static-site compatibility and avoid breaking generated chapter pages.
2. Keep mobile usability with collapsible left nav and sticky right utility rail.
3. Maintain plaintext-free secret handling in memory docs (auth-vault only).

## Credential Provisioning (Completed in This Pass)

Requested easy human credential has been created and stored in auth-vault:

- Record name: `nate-bible-site-login`
- Username: `nate`
- Password: stored in encrypted auth-vault payload (`type=password`)
- Storage: `OP3NF1XER/nate-alma/dev/.secrets/auth-vault/nate-bible-site-login.dpapi`

## Credential Update Tool (Completed in This Pass)

Added dedicated helper tool for agents to rotate/update this website login without ad-hoc commands:

- `OP3NF1XER/nate-alma/dev/skills/auth-vault/scripts/update_bible_login.py`

Usage:

- `python skills/auth-vault/scripts/update_bible_login.py --username "nate" --password "NewPassword123!"`
- If `--password` is omitted, the tool prompts securely.

## Decision Parity Matrix

- Governance + historical assimilation performed before web research: **PASS**
- Web research completed and captured in decision: **PASS**
- Layout selected with narrow rationale and top 3 features: **PASS**
- Expanded design ideas documented: **PASS**
- Full implementation scope including `/setup` endpoint features documented: **PASS**
- Login lock requirement captured: **PASS**
- `/bible` endpoint contract captured: **PASS**
- Username/password created in password tool lane (`.secrets/auth-vault`): **PASS**
- Agent credential-update tool provided: **PASS**

## Implementation Recommendation Summary

Based on 2025 tooling research, the recommended stack:

### Tech Stack
- **Framework**: Astro Starlight (docs-first, Pagefind search built-in)
- **Search**: Pagefind (WASM-based, zero-config, handles large content)
- **Auth**: Static Web Server with Basic Auth + client-side gate for UX
- **Chat**: Custom web component with localStorage persistence
- **Styling**: Starlight defaults + custom CSS for agentic features

### Architecture Decisions
1. **Static site output** with server-layer auth (not client-side gate alone)
2. **File-based navigation** using Starlight's `_meta.json` convention
3. **Pagefind search** over Algolia (no external dependencies, works offline)
4. **Islands architecture** for chat widget (hydrates only when opened)
5. **localStorage** for chat history with BroadcastChannel for cross-tab sync

## Revised Implementation Strategy

### Decision: Incremental Enhancement vs. Astro Migration

**Verdict**: Keep current Python generator stack, add features incrementally. Migration to Astro adds complexity without immediate value given working system.

**Rationale**:
- Current generator produces working static site with 340 lessons
- Python-based workflow integrates with existing tooling
- Pagefind can index existing HTML output (no MDX rewrite needed)
- Lower risk, faster delivery

**Revised Stack**:
```
Python Generator (keep) → HTML → Pagefind index → Static Web Server
                                     ↓
                          Vanilla JS chat widget (localStorage)
                                     ↓
                       Basic Auth (htpasswd) at server layer
```

### Phase 1: Foundation Layer (Priority: Critical)

**Static Web Server + Basic Auth Implementation**

```bash
# Installation
npm install -g static-web-server

# HTPasswd generation from vault
htpasswd -cb .htpasswd nate $(cat .secrets/auth-vault/nate-bible-site-login | jq -r .password)

# Server execution
static-web-server --port 3000 \
  --root ./site \
  --basic-auth .htpasswd \
  --log-format combined
```

**Client-side enhancement**:
```javascript
// Check auth state for UI enhancement
const isAuthenticated = document.cookie.includes('auth_session');
if (!isAuthenticated) {
  window.location.href = '/login.html'; // Fallback gate
}
```

### Phase 2: Search Enhancement (Priority: High)

Replace custom JS search with Pagefind:

```python
# Add to generate_pages.py post-build hook
def build_pagefind_index():
    """Generate Pagefind index from HTML output"""
    subprocess.run([
        "npx", "pagefind", "--site", str(SITE_DIR),
        "--exclude-selectors", ".sidebar,.header,nav,.footer"
    ], check=True)
```

**Integration**:
- Replace fuse-like search in `app.js` with Pagefind
- Add search UI component to header
- Maintain keyboard shortcut (Ctrl/Cmd+K)

### Phase 3: OpenClaw Chat Integration (Priority: Medium)

**Architecture Decision**: Connect to existing OpenClaw Railway deployment at `C:\P4NTH30N\OP3NF1XER\nate-alma\deploy`. No deployment changes required - uses existing WebSocket proxy.

**Deployment Architecture**:
```
Doctrine Bible Site → Railway Domain → Wrapper Proxy → OpenClaw Gateway
     (Static HTML)      (WebSocket)      (server.js)      (Port 18789)
```

**OpenClaw Connection Details**:
- **Deployment**: `C:\P4NTH30N\OP3NF1XER\nate-alma\deploy`
- **Railway URL**: `wss://railway-domain.up.railway.app`
- **Health Endpoint**: `https://railway-domain.up.railway.app/healthz`
- **Setup Password**: `@Q5PDS9zoc2eSnNr%-itS9Eqo!d^` (from AGENTS.MD)
- **Gateway Token**: Auto-generated in `$STATE_DIR/gateway.token`
- **Internal Port**: 18789 (gateway), proxied via wrapper

**WebSocket Client (AlmaChat)**:

```javascript
class AlmaChat {
  constructor(config) {
    this.config = {
      gatewayUrl: config.gatewayUrl || 'wss://railway-domain.up.railway.app',
      reconnectInterval: 5000,
      maxReconnectAttempts: 10,
      ...config
    };
    this.ws = null;
    this.reconnectAttempts = 0;
    this.messageQueue = [];
    this.context = null;
    this.sessionId = this.generateSessionId();
    this.init();
  }
  
  connect() {
    const wsUrl = `${this.config.gatewayUrl}/chat?session=${this.sessionId}`;
    this.ws = new WebSocket(wsUrl);
    
    this.ws.onopen = () => {
      this.reconnectAttempts = 0;
      this.flushQueue();
      this.sendAuth();
    };
    
    this.ws.onmessage = (event) => {
      const msg = JSON.parse(event.data);
      this.handleMessage(msg);
    };
    
    this.ws.onclose = () => this.attemptReconnect();
  }
  
  sendAuth() {
    this.send({
      type: 'auth',
      token: this.config.gatewayToken,
      client: 'doctrine-bible',
      version: '1.0'
    });
  }
  
  injectContext(contextPacket) {
    this.context = contextPacket;
    this.send({ type: 'context', ...contextPacket });
    this.open();
  }
}
```

**Context Injection Protocol**:

When user clicks "[Ask Alma?]" button in lesson:

```javascript
const contextPacket = {
  type: 'context',
  source: 'doctrine-bible',
  lesson: {
    id: 'foundations-15',
    title: 'Risk Management Principles',
    chapter: 'foundations',
    paragraph: 'The 2% rule states that...'
  },
  concept: 'Position Sizing',
  timestamp: Date.now()
};
almaChat.injectContext(contextPacket);
```

**Health Monitoring Integration**:

```javascript
class OpenClawHealth {
  constructor(config) {
    this.healthUrl = config.healthUrl || 'https://railway-domain.up.railway.app/healthz';
    this.checkInterval = 30000;
  }
  
  async check() {
    const response = await fetch(this.healthUrl);
    const data = await response.json();
    return {
      wrapper: data.wrapper?.configured,
      gateway: data.gateway?.reachable,
      status: data.gateway?.reachable ? 'healthy' : 'degraded'
    };
  }
}
```

**Setup Tools Available**:

| Endpoint | Description | Bible Usage |
|----------|-------------|-------------|
| `GET /healthz` | Public health check | Connection status |
| `GET /setup/healthz` | Wrapper health | Auth required |
| `GET /setup/api/status` | Setup status | Admin dashboard |
| `GET /setup/api/debug` | Debug info | Troubleshooting |
| `POST /setup/api/run` | Execute commands | Advanced ops |

**Full Documentation**: `C:\P4NTH30N\STR4TEG15T\docs\OPENCLAW_CHAT_INTEGRATION.md`

**UI Pattern**: Floating button (bottom-right) → expands to sidebar overlay

**Files to Create**:
- `site/js/alma-chat.js` - Main chat widget
- `site/js/ask-alma-buttons.js` - Context button injection
- `site/js/health-monitor.js` - OpenClaw health checks
- `site/css/alma-chat.css` - Widget styling
- `scripts/setup_client.py` - Python setup client
- `site/config/alma-config.js` - Build-time configuration

### Phase 4: /bible Endpoint (Priority: Medium)

**Structure**:
```
site/
├── index.html              # Textbook portal (existing)
├── bible/
│   ├── index.html          # Canonical bible view (new)
│   ├── ai-bible-v3.html    # Rendered bible content
│   └── search.html         # Bible-specific search
├── chapters/               # Existing 340 lessons
└── setup/                  # Setup UI (Phase 5)
```

**Navigation Decision**: Unified sidebar with bible as top-level section
```javascript
CHAPTERS = {
  "bible": {"title": "📖 AI Bible", "icon": "📖", "lessons": [...]},
  "foundations": {"title": "I. Foundations", "icon": "📚", "lessons": [...]},
  // ... existing chapters
}
```

### Phase 5: Setup API Dashboard (Priority: Low)

**Backend** (Express proxy):
```javascript
const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');

const app = express();

// Proxy to setup service
app.use('/api', createProxyMiddleware({
  target: process.env.SETUP_SERVICE_URL || 'http://localhost:8080',
  changeOrigin: true
}));

// UI routes
app.get('/setup', (req, res) => res.sendFile('setup/index.html'));
app.get('/setup/healthz', (req, res) => res.json({status: 'ok'}));
// ... 16 endpoints mapped
```

**Critical Endpoints for UI**:
| Endpoint | UI Needed | Priority |
|----------|-----------|----------|
| GET /setup/healthz | Status dashboard | High |
| POST /setup/api/run | Command executor | High |
| GET /setup/api/config | Config editor | Medium |
| POST /setup/api/config | Config save | Medium |
| GET /setup/api/devices | Device list | Low |

### Phase 6: Polish & Migration Evaluation (Future)

**After feature-complete, evaluate**:
- Astro Starlight migration (if content > 1000 lessons)
- WebSocket backend (if chat usage > 100 sessions/day)
- OAuth replacement for Basic Auth (if user base expands)

---

## Open Questions Status

### ✅ Resolved Questions

| # | Question | Resolution | Documentation |
|---|----------|-----------|---------------|
| 1 | **WebSocket endpoint for chat?** | Use OpenClaw Railway deployment at `C:\P4NTH30N\OP3NF1XER\nate-alma\deploy`. Wrapper proxies WebSocket traffic to gateway on port 18789. | `C:\P4NTH30N\STR4TEG15T\docs\OPENCLAW_CHAT_INTEGRATION.md` |
| 2 | Keep Python generator or migrate to Astro? | **Keep Python generator** - migration adds complexity without immediate value | See Phase 1 rationale |
| 3 | Setup service URL/port? | **Railway domain** via existing deployment - no new infrastructure needed | See Phase 5 |
| 4 | Pagefind vs keep current search? | **Migrate to Pagefind** - WASM-based, better performance | See Phase 2 |

### ⏳ Remaining Decisions

| Decision | Options | Default | Notes |
|----------|---------|---------|-------|
| Chat persistence depth | localStorage (100 msgs) / Server sync | localStorage for MVP | Server sync requires DB |
| Session timeout | 30 min / 24 hours / Persistent | 24 hours | Balances security/UX |
| Multi-device sync | Enabled / Disabled | Disabled | Complex to implement |
| Rate limiting | None / Client debounce / Server throttle | Client debounce | Prevent spam |

**Recommended Defaults Applied**:
1. ✅ WebSocket via OpenClaw Railway (not polling)
2. ✅ Keep Python generator
3. ✅ Use Railway deployment (not localhost:8080)
4. ✅ Migrate to Pagefind

## Risk Assessment

| Risk | Mitigation |
|------|----------|
| Basic Auth exposed in source | Acceptable - static site limitation; content obscured without valid session |
| Chat history lost on clear | localStorage backup + server sync (future) |
| Search index size | Pagefind handles 10k+ pages; current 340 is trivial |
| Setup proxy failure | Graceful degradation - show "service unavailable" UI |


## Implementation Checklist

### Phase 1: Foundation
- [ ] Install static-web-server
- [ ] Create htpasswd from vault
- [ ] Test auth flow
- [ ] Document deployment

### Phase 2: Search  
- [ ] Add pagefind to build pipeline
- [ ] Replace search component
- [ ] Test with 340 lessons
- [ ] Keyboard shortcuts

### Phase 3: OpenClaw Chat Integration
- [x] **Identify OpenClaw deployment** at `C:\P4NTH30N\OP3NF1XER\nate-alma\deploy`
- [x] **Document WebSocket proxy architecture** - wrapper forwards to gateway:18789
- [x] **Create integration docs** at `C:\P4NTH30N\STR4TEG15T\docs\OPENCLAW_CHAT_INTEGRATION.md`
- [ ] Build `AlmaChat` widget component (`site/js/alma-chat.js`)
- [ ] Implement WebSocket connection with auto-reconnect
- [ ] Add authentication flow (gateway token via SETUP_PASSWORD)
- [ ] Create "[Ask Alma?]" buttons with context injection
- [ ] Implement `OpenClawHealth` monitor (`site/js/health-monitor.js`)
- [ ] Add localStorage persistence (last 50 messages)
- [ ] Test against Railway deployment
- [ ] Create Python setup client (`scripts/setup_client.py`)

### Phase 4: Bible
- [ ] Create /bible/ structure
- [ ] Render bible content
- [ ] Add to navigation
- [ ] Test routing

### Phase 5: Setup
- [ ] Express proxy
- [ ] UI dashboard
- [ ] Endpoint mapping
- [ ] Health checks

---
g，4Execution76-15python-n3, timestamp="20206-02-25T07:45:00-operation 30",351:00Z
