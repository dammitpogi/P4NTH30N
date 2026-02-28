/**
 * Alma Chat Configuration
 * Gateway URL and health endpoint for OpenClaw Railway deployment
 */
window.ALMA_CONFIG = {
  // Production Railway deployment
  gatewayUrl: 'wss://clawdbot-railway-template-production-461f.up.railway.app',
  healthUrl: 'https://clawdbot-railway-template-production-461f.up.railway.app/healthz',

  // Development (uncomment for local testing)
  // gatewayUrl: 'ws://localhost:3000',
  // healthUrl: 'http://localhost:3000/healthz',

  // Token from deployment (injected at build time or via setup flow)
  gatewayToken: null,

  version: '1.0.0'
};
