/**
 * Health Check Integration
 * Monitors OpenClaw deployment health via /healthz endpoint
 */

class OpenClawHealth {
  constructor(config) {
    this.healthUrl = config.healthUrl || 'https://clawdbot-railway-template-production-461f.up.railway.app/healthz';
    this.checkInterval = config.checkInterval || 30000;
    this.onStatusChange = config.onStatusChange || (() => {});
    this.status = 'unknown';
    this.lastCheck = null;
    this.interval = null;
  }

  async check() {
    try {
      const controller = new AbortController();
      const timeout = setTimeout(() => controller.abort(), 10000);

      const response = await fetch(this.healthUrl, {
        signal: controller.signal,
        mode: 'cors'
      });
      clearTimeout(timeout);

      const data = await response.json();
      this.lastCheck = Date.now();

      const newStatus = data.gateway?.reachable ? 'healthy' : 'degraded';
      if (newStatus !== this.status) {
        this.status = newStatus;
        this.onStatusChange(newStatus, data);
      }

      return data;
    } catch (err) {
      this.lastCheck = Date.now();
      if (this.status !== 'offline') {
        this.status = 'offline';
        this.onStatusChange('offline', { error: err.message });
      }
      return { ok: false, error: err.message };
    }
  }

  start() {
    this.check();
    this.interval = setInterval(() => this.check(), this.checkInterval);
  }

  stop() {
    if (this.interval) {
      clearInterval(this.interval);
      this.interval = null;
    }
  }

  getStatus() {
    return this.status;
  }
}

// Initialize health monitor
let healthMonitor;

document.addEventListener('DOMContentLoaded', () => {
  healthMonitor = new OpenClawHealth({
    healthUrl: window.ALMA_CONFIG?.healthUrl,
    onStatusChange: (status, data) => {
      console.log(`[OpenClaw] Status: ${status}`, data);

      // Update health dot on chat button
      const healthDot = document.querySelector('.alma-chat-button .health-dot');
      if (healthDot) {
        healthDot.className = `health-dot ${status}`;
      }

      // Update status indicator in chat header
      const indicator = document.getElementById('openclaw-status');
      if (indicator) {
        indicator.className = `status-indicator ${status}`;
        indicator.title = status === 'healthy'
          ? 'OpenClaw connected'
          : status === 'degraded'
            ? 'OpenClaw degraded'
            : 'OpenClaw unavailable';
      }

      // Disable/enable chat input when offline
      const chatInput = document.getElementById('alma-input');
      const chatSend = document.querySelector('.alma-chat-input button');
      if (status === 'offline') {
        if (chatInput) chatInput.placeholder = 'OpenClaw is offline...';
        if (chatSend) chatSend.disabled = true;
      } else {
        if (chatInput) chatInput.placeholder = 'Ask about this lesson...';
        if (chatSend) chatSend.disabled = false;
      }
    }
  });

  healthMonitor.start();
});

window.OpenClawHealth = OpenClawHealth;
