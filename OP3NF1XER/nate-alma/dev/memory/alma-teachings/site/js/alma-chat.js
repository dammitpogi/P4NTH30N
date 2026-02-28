/**
 * AlmaChat - OpenClaw Integration Widget
 * Connects Doctrine Bible to OpenClaw Railway deployment
 */

class AlmaChat {
  constructor(config) {
    this.config = {
      gatewayUrl: config.gatewayUrl || 'wss://clawdbot-railway-template-production-461f.up.railway.app',
      reconnectInterval: 5000,
      maxReconnectAttempts: 10,
      maxHistory: 50,
      ...config
    };

    this.ws = null;
    this.reconnectAttempts = 0;
    this.reconnectTimer = null;
    this.messageQueue = [];
    this.context = null;
    this.sessionId = null;
    this.isOpen = false;

    this.init();
  }

  init() {
    this.loadFromStorage();
    if (!this.sessionId) {
      this.sessionId = this.generateSessionId();
    }
    this.renderWidget();
    this.restoreHistory();
    this.connect();
  }

  generateSessionId() {
    return 'alm_' + Math.random().toString(36).substr(2, 9) + '_' + Date.now().toString(36);
  }

  // ==========================================
  // WebSocket Connection
  // ==========================================

  connect() {
    if (this.ws && (this.ws.readyState === WebSocket.OPEN || this.ws.readyState === WebSocket.CONNECTING)) {
      return;
    }

    try {
      const wsUrl = `${this.config.gatewayUrl}/chat?session=${this.sessionId}`;
      this.ws = new WebSocket(wsUrl);

      this.ws.onopen = () => {
        console.log('[AlmaChat] Connected to OpenClaw');
        this.reconnectAttempts = 0;
        this.flushQueue();
        this.sendAuth();
        this.updateConnectionStatus('connected');
      };

      this.ws.onmessage = (event) => {
        try {
          const msg = JSON.parse(event.data);
          this.handleMessage(msg);
        } catch (err) {
          console.warn('[AlmaChat] Failed to parse message:', err);
        }
      };

      this.ws.onclose = (event) => {
        console.log('[AlmaChat] Disconnected:', event.code, event.reason);
        this.updateConnectionStatus('disconnected');
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
      this.updateConnectionStatus('failed');
      return;
    }

    if (this.reconnectTimer) {
      clearTimeout(this.reconnectTimer);
    }

    this.reconnectAttempts++;
    const delay = this.config.reconnectInterval * Math.min(this.reconnectAttempts, 3);
    console.log(`[AlmaChat] Reconnecting in ${delay}ms (attempt ${this.reconnectAttempts}/${this.config.maxReconnectAttempts})`);

    this.reconnectTimer = setTimeout(() => this.connect(), delay);
  }

  updateConnectionStatus(status) {
    const statusEl = document.getElementById('alma-connection-status');
    if (statusEl) {
      statusEl.textContent = status === 'connected' ? 'Connected' : status === 'failed' ? 'Connection failed' : 'Reconnecting...';
    }
  }

  sendAuth() {
    this.send({
      type: 'auth',
      token: this.config.gatewayToken,
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
      if (this.ws?.readyState === WebSocket.OPEN) {
        this.ws.send(JSON.stringify(msg));
      }
    }
  }

  // ==========================================
  // Context Injection
  // ==========================================

  injectContext(contextPacket) {
    this.context = contextPacket;
    this.send({
      type: 'context',
      ...contextPacket
    });

    // Show context banner
    this.showContextBanner(contextPacket);

    this.open();
    this.saveToStorage();
  }

  clearContext() {
    this.context = null;
    const banner = document.getElementById('alma-context-banner');
    if (banner) banner.style.display = 'none';
    this.saveToStorage();
  }

  showContextBanner(ctx) {
    const banner = document.getElementById('alma-context-banner');
    if (!banner) return;

    const label = ctx.concept
      ? `Context: ${ctx.concept}`
      : ctx.lesson?.title
        ? `Context: ${ctx.lesson.title}`
        : 'Context loaded';

    banner.querySelector('.alma-context-label').textContent = label;
    banner.style.display = 'flex';
  }

  // ==========================================
  // Message Handling
  // ==========================================

  askQuestion(text) {
    const msg = {
      type: 'message',
      content: text,
      context: this.context,
      timestamp: Date.now()
    };
    this.send(msg);
    this.persistMessage('user', text);
  }

  handleMessage(msg) {
    switch (msg.type) {
      case 'response':
        this.displayResponse(msg.content);
        break;
      case 'error':
        this.displayError(msg.message || msg.content || 'Unknown error');
        break;
      case 'ping':
        this.send({ type: 'pong' });
        break;
      case 'auth_ok':
        this.displaySystem('Connected to Alma');
        break;
      case 'typing':
        this.showTypingIndicator(true);
        break;
      case 'typing_stop':
        this.showTypingIndicator(false);
        break;
      default:
        console.log('[AlmaChat] Unknown message type:', msg.type, msg);
    }
  }

  // ==========================================
  // UI Rendering
  // ==========================================

  renderWidget() {
    const widget = document.createElement('div');
    widget.id = 'alma-chat-widget';
    widget.innerHTML = `
      <div class="alma-chat-button" onclick="almaChat.toggle()" title="Ask Alma">
        <span>&#x1F4AC;</span>
        <div class="health-dot unknown" id="alma-health-dot"></div>
      </div>
      <div class="alma-chat-panel" id="alma-panel">
        <div class="alma-chat-header">
          <div class="alma-chat-header-left">
            <span class="status-indicator unknown" id="openclaw-status"></span>
            <span>Ask Alma</span>
          </div>
          <button onclick="almaChat.close()" title="Close">&times;</button>
        </div>
        <div class="alma-context-banner" id="alma-context-banner" style="display:none">
          <span class="alma-context-label"></span>
          <button onclick="almaChat.clearContext()" title="Clear context">&times;</button>
        </div>
        <div class="alma-chat-messages" id="alma-messages"></div>
        <div class="alma-chat-input">
          <input type="text" id="alma-input" placeholder="Ask about this lesson..."
                 onkeydown="if(event.key==='Enter'&&!event.shiftKey){event.preventDefault();almaChat.submit();}">
          <button onclick="almaChat.submit()">Send</button>
        </div>
      </div>
    `;
    document.body.appendChild(widget);
  }

  open() {
    const panel = document.getElementById('alma-panel');
    if (panel) {
      panel.classList.add('open');
      this.isOpen = true;
      document.dispatchEvent(new CustomEvent('alma-chat-open'));

      // Focus input
      setTimeout(() => {
        const input = document.getElementById('alma-input');
        if (input) input.focus();
      }, 100);
    }
  }

  close() {
    const panel = document.getElementById('alma-panel');
    if (panel) {
      panel.classList.remove('open');
      this.isOpen = false;
    }
  }

  toggle() {
    if (this.isOpen) {
      this.close();
    } else {
      this.open();
    }
  }

  submit() {
    const input = document.getElementById('alma-input');
    if (!input) return;

    const text = input.value.trim();
    if (!text) return;

    this.displayUserMessage(text);
    this.askQuestion(text);
    input.value = '';
  }

  displayUserMessage(text) {
    const container = document.getElementById('alma-messages');
    if (!container) return;

    const msg = document.createElement('div');
    msg.className = 'alma-message user';
    msg.textContent = text;
    container.appendChild(msg);
    this.scrollToBottom();
  }

  displayResponse(text) {
    this.showTypingIndicator(false);
    const container = document.getElementById('alma-messages');
    if (!container) return;

    const msg = document.createElement('div');
    msg.className = 'alma-message alma';
    msg.innerHTML = this.formatResponse(text);
    container.appendChild(msg);
    this.scrollToBottom();
    this.persistMessage('alma', text);
  }

  displayError(message) {
    const container = document.getElementById('alma-messages');
    if (!container) return;

    const msg = document.createElement('div');
    msg.className = 'alma-message error';
    msg.textContent = `Error: ${message}`;
    container.appendChild(msg);
    this.scrollToBottom();
  }

  displaySystem(message) {
    const container = document.getElementById('alma-messages');
    if (!container) return;

    const msg = document.createElement('div');
    msg.className = 'alma-message system';
    msg.textContent = message;
    container.appendChild(msg);
    this.scrollToBottom();
  }

  showTypingIndicator(show) {
    let indicator = document.getElementById('alma-typing');
    if (show && !indicator) {
      const container = document.getElementById('alma-messages');
      if (!container) return;
      indicator = document.createElement('div');
      indicator.id = 'alma-typing';
      indicator.className = 'alma-message alma';
      indicator.innerHTML = '<em>Alma is thinking...</em>';
      container.appendChild(indicator);
      this.scrollToBottom();
    } else if (!show && indicator) {
      indicator.remove();
    }
  }

  formatResponse(text) {
    // Basic markdown-like formatting
    let html = text;
    html = html.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>');
    html = html.replace(/\*(.+?)\*/g, '<em>$1</em>');
    html = html.replace(/`(.+?)`/g, '<code>$1</code>');
    html = html.replace(/\n/g, '<br>');
    return html;
  }

  scrollToBottom() {
    const container = document.getElementById('alma-messages');
    if (container) {
      container.scrollTop = container.scrollHeight;
    }
  }

  // ==========================================
  // Persistence (localStorage)
  // ==========================================

  persistMessage(sender, text) {
    const history = JSON.parse(localStorage.getItem('alma-history') || '[]');
    history.push({ sender, text, timestamp: Date.now() });
    // Keep last N messages
    while (history.length > this.config.maxHistory) {
      history.shift();
    }
    localStorage.setItem('alma-history', JSON.stringify(history));
  }

  restoreHistory() {
    const history = JSON.parse(localStorage.getItem('alma-history') || '[]');
    const container = document.getElementById('alma-messages');
    if (!container || history.length === 0) return;

    history.forEach(entry => {
      const msg = document.createElement('div');
      msg.className = `alma-message ${entry.sender === 'user' ? 'user' : 'alma'}`;
      if (entry.sender === 'user') {
        msg.textContent = entry.text;
      } else {
        msg.innerHTML = this.formatResponse(entry.text);
      }
      container.appendChild(msg);
    });

    this.scrollToBottom();
  }

  loadFromStorage() {
    const saved = localStorage.getItem('alma-session');
    if (saved) {
      try {
        const data = JSON.parse(saved);
        this.sessionId = data.sessionId || null;
        this.context = data.context || null;
      } catch {
        // corrupted storage, start fresh
      }
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
    gatewayUrl: window.ALMA_CONFIG?.gatewayUrl || 'wss://clawdbot-railway-template-production-461f.up.railway.app',
    gatewayToken: window.ALMA_CONFIG?.gatewayToken || null,
    maxHistory: 50
  });
});

window.AlmaChat = AlmaChat;
