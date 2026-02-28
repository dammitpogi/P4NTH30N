# OpenClaw Chat Integration for Doctrine Bible

## Executive Summary

This document defines the complete architecture for wiring the Doctrine Bible chat widget to the OpenClaw Railway deployment without modifying the deployment itself. The integration leverages the existing WebSocket proxy capabilities of the wrapper server.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           DOCTRINE BIBLE SITE                               │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │   Lesson Page   │  │  Chat Widget    │  │  "Ask Alma?"    │             │
│  │   (Static HTML) │  │  (Vanilla JS)   │  │    Buttons      │             │
│  └────────┬────────┘  └────────┬────────┘  └────────┬────────┘             │
└───────────┼────────────────────┼────────────────────┼──────────────────────┘
            │                    │                    │
            │                    │ WebSocket          │ Click handler
            │                    │ wss://host/chat    │ injects context
            │                    │                    │
            ▼                    ▼                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                        RAILWAY / OPENCLAW DEPLOYMENT                        │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Wrapper Express Server (server.js)                                 │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐               │   │
│  │  │  HTTP /setup │  │  HTTP /      │  │  WS /chat    │               │   │
│  │  │  (protected) │  │  (OpenClaw)  │  │  (proxy)     │               │   │
│  │  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘               │   │
│  │         │                  │                │                       │   │
│  │         │                  │                │                       │   │
│  │         ▼                  ▼                ▼                       │   │
│  │  ┌───────────────────────────────────────────────────────────────┐ │   │
│  │  │              OpenClaw Gateway (port 18789)                    │ │   │
│  │  │  • Chat sessions                                              │ │   │
│  │  │  • Context handling                                           │ │   │
│  │  │  • Tool execution                                             │ │   │
│  │  └───────────────────────────────────────────────────────────────┘ │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Integration Points

### 1. WebSocket Connection (No Deployment Changes)

The wrapper already proxies WebSocket traffic. The Bible widget connects to:

```javascript
// Bible site JavaScript
const ws = new WebSocket('wss://railway-domain.up.railway.app/chat');
// Or for local development:
// const ws = new WebSocket('ws://localhost:3000/chat');
```

The wrapper's existing proxy configuration (server.js lines 194-215) handles the passthrough:

```javascript
// From server.js - already exists
gatewayProc = childProcess.spawn(OPENCLAW_NODE, clawArgs(args), {
  stdio: "inherit",
  env: { ...process.env, OPENCLAW_STATE_DIR: STATE_DIR }
});
```

### 2. Authentication Flow

**Setup Password (SETUP_PASSWORD)**:
- Generated by: `npm run password:generate`
- Stored in: Railway Variables
- Used for: `/setup` and `/openclaw` access
- Passed to Bible widget via: Environment or build-time injection

**Gateway Token (OPENCLAW_GATEWAY_TOKEN)**:
- Auto-generated on first boot if not set
- Stored in: `$STATE_DIR/gateway.token`
- Used for: Gateway WebSocket authentication
- Bible widget receives token via: Setup flow or pre-shared config

### 3. Context Injection Protocol

When user clicks "[Ask Alma?]" button:

```javascript
// Bible page embeds context
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

OpenClaw receives and stores context for the session.

## Implementation Components

### Component A: AlmaChat Widget (Bible Site)

**File**: `site/js/alma-chat.js`

```javascript
/**
 * AlmaChat - OpenClaw Integration Widget
 * Connects Doctrine Bible to OpenClaw Railway deployment
 */

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
  
  init() {
    this.loadFromStorage();
    this.connect();
    this.renderWidget();
  }
  
  generateSessionId() {
    return 'alm_' + Math.random().toString(36).substr(2, 9);
  }
  
  connect() {
    try {
      const wsUrl = `${this.config.gatewayUrl}/chat?session=${this.sessionId}`;
      this.ws = new WebSocket(wsUrl);
      
      this.ws.onopen = () => {
        console.log('[AlmaChat] Connected to OpenClaw');
        this.reconnectAttempts = 0;
        this.flushQueue();
        this.sendAuth();
      };
      
      this.ws.onmessage = (event) => {
        const msg = JSON.parse(event.data);
        this.handleMessage(msg);
      };
      
      this.ws.onclose = () => {
        console.log('[AlmaChat] Disconnected');
        this.attemptReconnect();
      };
      
      this.ws.onerror = (err) => {
        console.error('[AlmaChat] WebSocket error:', err);
      };
    } catch (err) {
      console.error('[AlmaChat] Connection failed:', err);
      this.attemptReconnect();
    }
  }
  
  attemptReconnect() {
    if (this.reconnectAttempts >= this.config.maxReconnectAttempts) {
      console.error('[AlmaChat] Max reconnect attempts reached');
      return;
    }
    
    this.reconnectAttempts++;
    setTimeout(() => this.connect(), this.config.reconnectInterval);
  }
  
  sendAuth() {
    // Auth packet with gateway token
    this.send({
      type: 'auth',
      token: this.config.gatewayToken, // From build-time or setup
      client: 'doctrine-bible',
      version: '1.0'
    });
  }
  
  send(message) {
    if (this.ws?.readyState === WebSocket.OPEN) {
      this.ws.send(JSON.stringify(message));
    } else {
      this.messageQueue.push(message);
    }
  }
  
  flushQueue() {
    while (this.messageQueue.length > 0) {
      const msg = this.messageQueue.shift();
      this.ws.send(JSON.stringify(msg));
    }
  }
  
  injectContext(contextPacket) {
    this.context = contextPacket;
    this.send({
      type: 'context',
      ...contextPacket
    });
    this.open();
  }
  
  askQuestion(text) {
    this.send({
      type: 'message',
      content: text,
      context: this.context,
      timestamp: Date.now()
    });
  }
  
  handleMessage(msg) {
    switch (msg.type) {
      case 'response':
        this.displayResponse(msg.content);
        break;
      case 'error':
        this.displayError(msg.message);
        break;
      case 'ping':
        this.send({ type: 'pong' });
        break;
    }
  }
  
  // UI Methods
  renderWidget() {
    // Inject floating chat button and panel
    const widget = document.createElement('div');
    widget.id = 'alma-chat-widget';
    widget.innerHTML = `
      <div class="alma-chat-button" onclick="almaChat.toggle()">
        <span>💬</span>
      </div>
      <div class="alma-chat-panel" id="alma-panel">
        <div class="alma-chat-header">
          <span>Ask Alma</span>
          <button onclick="almaChat.close()">×</button>
        </div>
        <div class="alma-chat-messages" id="alma-messages"></div>
        <div class="alma-chat-input">
          <input type="text" id="alma-input" placeholder="Ask about this lesson..."
                 onkeypress="if(event.key==='Enter')almaChat.submit()">
          <button onclick="almaChat.submit()">Send</button>
        </div>
      </div>
    `;
    document.body.appendChild(widget);
  }
  
  open() {
    document.getElementById('alma-panel')?.classList.add('open');
  }
  
  close() {
    document.getElementById('alma-panel')?.classList.remove('open');
  }
  
  toggle() {
    document.getElementById('alma-panel')?.classList.toggle('open');
  }
  
  submit() {
    const input = document.getElementById('alma-input');
    const text = input.value.trim();
    if (text) {
      this.displayUserMessage(text);
      this.askQuestion(text);
      input.value = '';
    }
  }
  
  displayUserMessage(text) {
    const container = document.getElementById('alma-messages');
    const msg = document.createElement('div');
    msg.className = 'alma-message user';
    msg.textContent = text;
    container.appendChild(msg);
    container.scrollTop = container.scrollHeight;
  }
  
  displayResponse(text) {
    const container = document.getElementById('alma-messages');
    const msg = document.createElement('div');
    msg.className = 'alma-message alma';
    msg.innerHTML = text;
    container.appendChild(msg);
    container.scrollTop = container.scrollHeight;
    this.persistMessage('alma', text);
  }
  
  displayError(message) {
    const container = document.getElementById('alma-messages');
    const msg = document.createElement('div');
    msg.className = 'alma-message error';
    msg.textContent = `Error: ${message}`;
    container.appendChild(msg);
  }
  
  // Persistence
  persistMessage(sender, text) {
    const history = JSON.parse(localStorage.getItem('alma-history') || '[]');
    history.push({ sender, text, timestamp: Date.now() });
    // Keep last 100 messages
    if (history.length > 100) history.shift();
    localStorage.setItem('alma-history', JSON.stringify(history));
  }
  
  loadFromStorage() {
    const saved = localStorage.getItem('alma-session');
    if (saved) {
      const data = JSON.parse(saved);
      this.sessionId = data.sessionId || this.sessionId;
      this.context = data.context || null;
    }
  }
  
  saveToStorage() {
    localStorage.setItem('alma-session', JSON.stringify({
      sessionId: this.sessionId,
      context: this.context,
      timestamp: Date.now()
    }));
  }
}

// Initialize on page load
let almaChat;
document.addEventListener('DOMContentLoaded', () => {
  almaChat = new AlmaChat({
    gatewayUrl: window.ALMA_CONFIG?.gatewayUrl || 'wss://railway-domain.up.railway.app',
    gatewayToken: window.ALMA_CONFIG?.gatewayToken || null
  });
});
```

### Component B: "Ask Alma?" Button Integration

**File**: `site/js/ask-alma-buttons.js`

```javascript
/**
 * "Ask Alma?" Button Integration
 * Embeds context-aware help buttons throughout lesson content
 */

document.addEventListener('DOMContentLoaded', () => {
  // Find all concept markers in lesson content
  const concepts = document.querySelectorAll('[data-concept]');
  
  concepts.forEach(el => {
    const concept = el.dataset.concept;
    const button = document.createElement('button');
    button.className = 'ask-alma-btn';
    button.innerHTML = '[Ask Alma?]';
    button.onclick = () => {
      const context = {
        type: 'concept',
        concept: concept,
        lesson: {
          id: document.body.dataset.lessonId,
          title: document.title,
          chapter: document.body.dataset.chapter
        },
        paragraph: el.closest('p')?.textContent?.slice(0, 200) + '...'
      };
      
      if (window.almaChat) {
        almaChat.injectContext(context);
      }
    };
    
    el.appendChild(button);
  });
});

// Auto-detect lesson filename for context injection
(function injectFilenameContext() {
  const path = window.location.pathname;
  const match = path.match(/lesson-(.+)\.html/);
  if (match) {
    document.body.dataset.lessonId = match[1];
    
    // Auto-inject on chat open if no manual context set
    document.addEventListener('alma-chat-open', () => {
      if (window.almaChat && !window.almaChat.context) {
        window.almaChat.injectContext({
          type: 'auto',
          lesson: {
            id: match[1],
            title: document.title,
            url: window.location.href
          }
        });
      }
    });
  }
})();
```

### Component C: Health Check Integration

**File**: `site/js/health-monitor.js`

```javascript
/**
 * Health Check Integration
 * Monitors OpenClaw deployment health via /healthz endpoint
 */

class OpenClawHealth {
  constructor(config) {
    this.healthUrl = config.healthUrl || 'https://railway-domain.up.railway.app/healthz';
    this.checkInterval = 30000; // 30 seconds
    this.onStatusChange = config.onStatusChange || (() => {});
    this.status = 'unknown';
  }
  
  async check() {
    try {
      const response = await fetch(this.healthUrl);
      const data = await response.json();
      
      const newStatus = data.gateway?.reachable ? 'healthy' : 'degraded';
      if (newStatus !== this.status) {
        this.status = newStatus;
        this.onStatusChange(newStatus, data);
      }
      
      return data;
    } catch (err) {
      if (this.status !== 'offline') {
        this.status = 'offline';
        this.onStatusChange('offline', { error: err.message });
      }
      return { ok: false, error: err.message };
    }
  }
  
  start() {
    this.check(); // Immediate check
    this.interval = setInterval(() => this.check(), this.checkInterval);
  }
  
  stop() {
    if (this.interval) {
      clearInterval(this.interval);
      this.interval = null;
    }
  }
}

// Usage in Bible site
const healthMonitor = new OpenClawHealth({
  healthUrl: window.ALMA_CONFIG?.healthUrl,
  onStatusChange: (status, data) => {
    console.log(`[OpenClaw] Status: ${status}`, data);
    
    // Update UI indicator
    const indicator = document.getElementById('openclaw-status');
    if (indicator) {
      indicator.className = `status-indicator ${status}`;
      indicator.title = status === 'healthy' 
        ? 'OpenClaw connected' 
        : 'OpenClaw unavailable';
    }
    
    // Disable chat if offline
    if (status === 'offline' && window.almaChat) {
      window.almaChat.displayError('OpenClaw service is currently unavailable. Please try again later.');
    }
  }
});

healthMonitor.start();
```

### Component D: Setup Tools Integration

The OpenClaw deployment provides these setup endpoints:

| Endpoint | Method | Description | Bible Integration |
|----------|--------|-------------|-------------------|
| `/setup/healthz` | GET | Wrapper health check | Health monitor uses this |
| `/healthz` | GET | Public health endpoint | No auth required |
| `/setup/api/status` | GET | Detailed setup status | For admin dashboard |
| `/setup/api/debug` | GET | Debug information | Troubleshooting |
| `/setup/api/run` | POST | Execute commands | Advanced operations |

**Python Setup Client** (for local development):

```python
# scripts/setup_client.py
import requests
import json
import os
from pathlib import Path

class SetupClient:
    def __init__(self, base_url, password):
        self.base_url = base_url
        self.auth = ('admin', password)  # Any username works
        
    def healthz(self):
        """Check wrapper health"""
        r = requests.get(f"{self.base_url}/setup/healthz", auth=self.auth)
        return r.json()
    
    def gateway_health(self):
        """Check gateway health via public endpoint"""
        r = requests.get(f"{self.base_url}/healthz")
        return r.json()
    
    def get_status(self):
        """Get detailed setup status"""
        r = requests.get(f"{self.base_url}/setup/api/status", auth=self.auth)
        return r.json()
    
    def run_command(self, command, args=None):
        """Run command via setup API"""
        r = requests.post(
            f"{self.base_url}/setup/api/run",
            auth=self.auth,
            json={'command': command, 'args': args or []}
        )
        return r.json()

# Usage
if __name__ == '__main__':
    import sys
    
    url = sys.argv[1] if len(sys.argv) > 1 else 'http://localhost:3000'
    password = os.environ.get('SETUP_PASSWORD', '@Q5PDS9zoc2eSnNr%-itS9Eqo!d^')
    
    client = SetupClient(url, password)
    
    print("=== Wrapper Health ===")
    print(json.dumps(client.healthz(), indent=2))
    
    print("\n=== Gateway Health ===")
    print(json.dumps(client.gateway_health(), indent=2))
    
    print("\n=== Setup Status ===")
    print(json.dumps(client.get_status(), indent=2))
```

## Deployment Configuration

### Railway Variables (Already Configured)

```env
# Required
SETUP_PASSWORD=@Q5PDS9zoc2eSnNr%-itS9Eqo!d^

# Recommended
OPENCLAW_STATE_DIR=/data/.openclaw
OPENCLAW_WORKSPACE_DIR=/data/workspace

# Optional - Gateway token (auto-generated if not set)
# OPENCLAW_GATEWAY_TOKEN=your-secure-token-here
```

### Bible Site Build Configuration

**File**: `site/config/alma-config.js` (generated at build time)

```javascript
// This file is generated by build script from environment variables
window.ALMA_CONFIG = {
  // Production Railway deployment
  gatewayUrl: 'wss://railway-domain.up.railway.app',
  healthUrl: 'https://railway-domain.up.railway.app/healthz',
  
  // Development
  // gatewayUrl: 'ws://localhost:3000',
  // healthUrl: 'http://localhost:3000/healthz',
  
  // Token from deployment (injected at build time)
  gatewayToken: null,  // User authenticates via SETUP_PASSWORD flow
  
  version: '1.0.0'
};
```

## Styling

**File**: `site/css/alma-chat.css`

```css
/* Alma Chat Widget Styles */
#alma-chat-widget {
  position: fixed;
  bottom: 20px;
  right: 20px;
  z-index: 1000;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

.alma-chat-button {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  transition: transform 0.2s, box-shadow 0.2s;
}

.alma-chat-button:hover {
  transform: scale(1.05);
  box-shadow: 0 6px 20px rgba(0,0,0,0.2);
}

.alma-chat-button span {
  font-size: 28px;
}

.alma-chat-panel {
  position: absolute;
  bottom: 80px;
  right: 0;
  width: 380px;
  height: 500px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 10px 40px rgba(0,0,0,0.2);
  display: none;
  flex-direction: column;
  overflow: hidden;
}

.alma-chat-panel.open {
  display: flex;
}

.alma-chat-header {
  padding: 16px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.alma-chat-header button {
  background: none;
  border: none;
  color: white;
  font-size: 24px;
  cursor: pointer;
}

.alma-chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 16px;
  background: #f8f9fa;
}

.alma-message {
  margin-bottom: 12px;
  padding: 12px;
  border-radius: 12px;
  max-width: 80%;
  word-wrap: break-word;
}

.alma-message.user {
  background: #667eea;
  color: white;
  margin-left: auto;
  border-bottom-right-radius: 4px;
}

.alma-message.alma {
  background: white;
  border: 1px solid #e0e0e0;
  border-bottom-left-radius: 4px;
}

.alma-message.error {
  background: #fee;
  color: #c00;
  border: 1px solid #fcc;
}

.alma-chat-input {
  padding: 12px;
  background: white;
  border-top: 1px solid #e0e0e0;
  display: flex;
  gap: 8px;
}

.alma-chat-input input {
  flex: 1;
  padding: 10px 16px;
  border: 1px solid #ddd;
  border-radius: 20px;
  outline: none;
}

.alma-chat-input button {
  padding: 10px 20px;
  background: #667eea;
  color: white;
  border: none;
  border-radius: 20px;
  cursor: pointer;
}

.alma-chat-input button:hover {
  background: #5568d3;
}

/* "Ask Alma?" Buttons */
.ask-alma-btn {
  display: inline-block;
  margin-left: 8px;
  padding: 2px 8px;
  background: #f0f0f0;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 12px;
  color: #667eea;
  cursor: pointer;
  transition: all 0.2s;
}

.ask-alma-btn:hover {
  background: #667eea;
  color: white;
  border-color: #667eea;
}

/* Status Indicator */
.status-indicator {
  display: inline-block;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  margin-right: 8px;
}

.status-indicator.healthy { background: #28a745; }
.status-indicator.degraded { background: #ffc107; }
.status-indicator.offline { background: #dc3545; }

/* Mobile Responsive */
@media (max-width: 480px) {
  .alma-chat-panel {
    width: calc(100vw - 40px);
    height: calc(100vh - 100px);
    position: fixed;
    bottom: 80px;
    right: 20px;
    left: 20px;
  }
}
```

## Testing & Verification

### Local Development Test

```bash
# 1. Start OpenClaw deployment locally
cd C:\P4NTH30N\OP3NF1XER\nate-alma\deploy
npm run dev
# Server starts on localhost:3000

# 2. Complete setup wizard
open http://localhost:3000/setup
# Login with admin / @Q5PDS9zoc2eSnNr%-itS9Eqo!d^

# 3. Verify health
open http://localhost:3000/healthz

# 4. Serve Bible site
 cd site
 npx static-web-server --port 8080
 
 # 5. Test chat integration
 # Open http://localhost:8080
 # Click chat button, verify WebSocket connection
 ```
 
 ### Production Deployment Test
 
 ```bash
 # Health check
 curl https://railway-domain.up.railway.app/healthz
 
 # Setup status (requires auth)
 curl -u admin:@Q5PDS9zoc2eSnNr%-itS9Eqo!d^ \
      https://railway-domain.up.railway.app/setup/api/status
 
 # Debug info
 curl -u admin:@Q5PDS9zoc2eSnNr%-itS9Eqo!d^ \
      https://railway-domain.up.railway.app/setup/api/debug
 ```
 
 ## Troubleshooting
 
 | Issue | Cause | Solution |
 |-------|-------|----------|
 | "disconnected (1008): pairing required" | Gateway running but no device approved | Visit /setup, approve device in Debug Console |
 | "unauthorized: gateway token mismatch" | Token mismatch between UI and gateway | Re-run /setup to regenerate tokens |
 | WebSocket won't connect | Wrapper not proxying correctly | Check Railway logs for `Gateway not ready:` |
 | Chat history lost | localStorage cleared | Implement server-side session storage (future) |
 | Context not injected | Button handler not attached | Verify `[data-concept]` attributes in HTML |
 
 ## Security Considerations
 
 1. **SETUP_PASSWORD**: Never commit to repo. Use Railway Variables.
 2. **Gateway Token**: Auto-generated and stored in volume. Do not expose in client code.
 3. **WebSocket Auth**: Token passed in connection URL query param (standard practice).
 4. **CORS**: Bible site and OpenClaw on same domain (Railway domain) - no CORS issues.
 5. **Content Injection**: Validate all context packets server-side before processing.
 
 ## Future Enhancements
 
 - [ ] Server-side chat persistence (PostgreSQL via Railway)
 - [ ] Multi-user sessions with authentication
 - [ ] Rate limiting for chat messages
 - [ ] Export chat history to Markdown
 - [ ] Voice input integration
 - [ ] Embeddable widget for external sites
 
 ## References
 
 - OpenClaw Documentation: https://docs.openclaw.ai/
 - Railway Template: `C:\P4NTH30N\OP3NF1XER\nate-alma\deploy\README.md`
 - DECISION_155: Implementation scope for Doctrine Bible modernization
 - AGENTS.MD: `C:\P4NTH30N\OP3NF1XER\nate-alma\deploy\AGENTS.MD`
 
 ---
 
 **Document Version**: 1.0  
 **Last Updated**: 2026-02-25  
 **Governance**: OpenFixer Deployment Manifest v1.0  
 **Integration Status**: Ready for implementation