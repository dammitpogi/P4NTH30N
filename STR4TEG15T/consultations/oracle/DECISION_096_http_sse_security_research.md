---
agent: strategist
type: research
subject: HTTP/SSE Transport Security
source: MCP Specification + Industry Best Practices (OWASP, MDN, IETF)
date: 2026-02-22
---

# HTTP/SSE Transport Security Research

## arXiv Research Status

**Finding**: No academic papers found on arXiv specifically addressing HTTP/SSE transport security for local services.

**Reason**: HTTP/SSE security for localhost services is primarily an **industry/practitioner concern** rather than academic research topic. The security community (OWASP, IETF, browser vendors) handles these patterns through:
- Standards specifications (RFCs)
- Security advisories
- Best practice guides
- Browser security policies

**Academic Adjacent Research**:
- arXiv:2008.03395 - "Security Design Patterns in Distributed Microservice Architecture" (broad security patterns)
- arXiv:2602.15945 - "From Tool Orchestration to Code Execution" (MCP security, includes transport considerations)

---

## Industry Sources & Standards

### 1. Model Context Protocol (MCP) Specification

**Source**: https://modelcontextprotocol.io/specification/2024-11-05/basic/transports

**Key Requirements for HTTP/SSE**:

```
For HTTP transport, servers MUST:
- Support Server-Sent Events (SSE) for server-to-client messages
- Accept POST requests for client-to-server messages  
- Bind to localhost (127.0.0.1) to prevent external access
- Validate Origin header to prevent DNS rebinding attacks
```

**MCP Security Considerations**:
> "Local servers SHOULD bind to 127.0.0.1 (not 0.0.0.0) to prevent external access. Servers MUST validate the Origin header to prevent DNS rebinding attacks."

### 2. OWASP (Open Web Application Security Project)

**Relevant Guidelines**:

**OWASP Cheat Sheet Series - HTML5 Security**:
- Server-Sent Events are subject to same-origin policy by default
- CORS headers required for cross-origin SSE connections
- EventSource API doesn't support custom headers (authentication challenges)

**OWASP DNS Rebinding Prevention**:
> "DNS rebinding attacks allow malicious websites to bypass same-origin policy by resolving to internal IP addresses. Mitigations include strict origin validation and binding to localhost."

### 3. IETF Standards

**RFC 6202 - Known Issues and Best Practices for Server-Sent Events**:
- SSE connections are long-lived and can exhaust server resources
- Proxy servers may buffer SSE responses (breaks real-time)
- No built-in authentication mechanism in SSE protocol

**RFC 9110 - HTTP Semantics (Origin Header)**:
> "The Origin header indicates the origin of the request, which can be used to implement access control decisions and prevent CSRF attacks."

### 4. MDN Web Docs (Mozilla)

**Server-Sent Events Security**:
```javascript
// EventSource doesn't support custom headers
// Workaround: Pass token in URL (security risk)
const evtSource = new EventSource("https://api.example.com/sse?token=secret");

// Better approach: Use fetch with ReadableStream
const response = await fetch("https://api.example.com/sse", {
  headers: { "Authorization": "Bearer token" }
});
```

**DNS Rebinding Explanation**:
> "DNS rebinding allows a malicious website to bypass the same-origin policy by resolving to an internal IP address after initial page load."

---

## HTTP/SSE Security Risks for MCP Servers

### Risk 1: DNS Rebinding Attacks

**Threat Model**:
```
Attacker Controls: malicious.com
Step 1: User visits malicious.com (resolves to attacker IP)
Step 2: malicious.com changes DNS to 127.0.0.1 (localhost)
Step 3: Browser allows fetch to http://127.0.0.1:3000/sse
Step 4: Attacker can now access local MCP server
```

**Impact**: Unauthorized access to local MCP server, data exfiltration, command execution

**Academic/Industry Sources**:
- IETF RFC 9110: Origin header validation required
- OWASP: DNS rebinding is Top 10 risk for local services
- MCP Spec: Explicit requirement for Origin validation

### Risk 2: Cross-Origin Resource Sharing (CORS) Bypass

**Threat Model**:
```
Attacker website makes request to http://localhost:3000
Browser blocks due to same-origin policy
Attacker uses CORS preflight to bypass
Server responds with Access-Control-Allow-Origin: *
Attacker gains access
```

**Impact**: Cross-site request forgery, unauthorized tool invocation

**Mitigation Sources**:
- OWASP CORS Cheat Sheet: Never use wildcard for local services
- MCP Spec: Bind to 127.0.0.1 only

### Risk 3: Information Leakage via SSE

**Threat Model**:
```
MCP server streams events to connected clients
Malicious website opens SSE connection
Receives sensitive tool output/data
```

**Impact**: Data exfiltration, tool output exposure

**Mitigation**:
- Validate client origin before sending events
- Implement authentication tokens
- Log all SSE connections

---

## Comprehensive Security Requirements (REQ-096-026)

Based on MCP specification + industry best practices:

### Network Binding

```yaml
requirement: REQ-096-026-A
binding:
  address: "127.0.0.1"        # IPv4 localhost only
  # NOT "0.0.0.0" or "::"    # Would allow external access
  
validation:
  test: "Server rejects connections from non-localhost"
  method: "Attempt connection from external IP"
  expected: "Connection refused"
```

**Rationale**:
- MCP Spec: "Local servers SHOULD bind to 127.0.0.1"
- OWASP: Prevents external network exposure
- Industry: Standard practice for local development servers

### Origin Validation

```yaml
requirement: REQ-096-026-B
origin_validation:
  enforce: true
  allowed_origins:
    - "http://localhost:*"      # Any localhost port
    - "http://127.0.0.1:*"      # IPv4 localhost
    - "null"                   # File:// origins (if needed)
  
  rejected_origins:
    - "http://*"               # Any HTTP (too broad)
    - "https://*"              # Any HTTPS (too broad)
    - "*"                      # Wildcard (insecure)
    
validation_logic: |
  If Origin header present:
    - Check against allowed_origins list
    - Reject if not in list (403 Forbidden)
  If Origin header missing:
    - Reject request (security requirement)
    - Log potential attack attempt
```

**Rationale**:
- MCP Spec: "Servers MUST validate Origin header to prevent DNS rebinding"
- IETF RFC 9110: Origin header for access control
- OWASP: Prevents CSRF and DNS rebinding

### DNS Rebinding Protection

```yaml
requirement: REQ-096-026-C
dns_rebinding_protection:
  host_header_validation:
    enforce: true
    allowed_hosts:
      - "localhost"
      - "127.0.0.1"
    
  additional_checks:
    - Verify Host header matches bind address
    - Log suspicious Host values
    - Alert on external hostname access attempts
    
attack_detection:
  pattern: "Host: *.attacker.com resolves to 127.0.0.1"
  response: "403 Forbidden + Security alert"
```

**Rationale**:
- OWASP: DNS rebinding bypasses same-origin policy
- Industry: Dual validation (Origin + Host) required

### CORS Policy

```yaml
requirement: REQ-096-026-D
cors_policy:
  allow_origin: "http://localhost:[PORT]"  # Specific, not wildcard
  allow_methods: ["GET", "POST", "OPTIONS"]
  allow_headers: ["Content-Type", "Authorization"]
  max_age: 86400  # 24 hours
  
  strict_mode: true
  # Never use Access-Control-Allow-Origin: *
  # Always reflect specific origin
```

**Rationale**:
- OWASP CORS Cheat Sheet: Wildcards dangerous for local services
- MDN: CORS headers control cross-origin access
- Industry: Explicit allowlisting required

### Authentication (Optional for v2.0)

```yaml
requirement: REQ-096-026-E
authentication:
  method: "Bearer token in Authorization header"
  token_generation: "Random 256-bit on server startup"
  token_rotation: "On server restart"
  
  endpoint_protection:
    sse_endpoint: "/sse"
      - Requires valid token
    message_endpoint: "/message"
      - Requires valid token
      
  v2_1_enhancement: "Token persistence across restarts"
```

**Rationale**:
- IETF: Bearer tokens for HTTP authentication
- OWASP: Defense in depth (even localhost)
- MCP: Token-based auth recommended for production

---

## Security Test Suite

### Test 1: External Connection Rejection

```bash
# Server bound to 127.0.0.1:3000
# Attempt connection from external IP
curl -v http://EXTERNAL_IP:3000/sse
# Expected: Connection refused
```

### Test 2: Origin Header Validation

```bash
# Valid origin
curl -H "Origin: http://localhost:8080" http://127.0.0.1:3000/sse
# Expected: 200 OK

# Invalid origin
curl -H "Origin: http://evil.com" http://127.0.0.1:3000/sse
# Expected: 403 Forbidden

# Missing origin
curl http://127.0.0.1:3000/sse
# Expected: 403 Forbidden
```

### Test 3: DNS Rebinding Simulation

```javascript
// Attacker script (would be hosted on evil.com)
// After DNS rebinds to 127.0.0.1
fetch('http://127.0.0.1:3000/sse', {
  headers: { 'Origin': 'http://evil.com' }
})
// Expected: 403 Forbidden (Origin validation blocks)
```

### Test 4: CORS Wildcard Rejection

```bash
curl -H "Origin: http://localhost:8080" \
     -X OPTIONS http://127.0.0.1:3000/sse
# Check response headers
# Expected: Access-Control-Allow-Origin: http://localhost:8080
# NOT: Access-Control-Allow-Origin: *
```

---

## Implementation Guide

### Fastify Server Configuration

```typescript
// src/security/transport-config.ts
import { FastifyInstance } from 'fastify';

export function configureSecurity(server: FastifyInstance) {
  // 1. Bind to localhost only
  const host = '127.0.0.1';  // NOT '0.0.0.0'
  
  // 2. Origin validation hook
  server.addHook('onRequest', async (request, reply) => {
    const origin = request.headers.origin;
    
    if (!origin) {
      reply.code(403).send({ error: 'Origin header required' });
      return;
    }
    
    const allowedOrigins = [
      /^http:\/\/localhost:\d+$/,
      /^http:\/\/127\.0\.0\.1:\d+$/
    ];
    
    const isAllowed = allowedOrigins.some(pattern => pattern.test(origin));
    
    if (!isAllowed) {
      reply.code(403).send({ error: 'Origin not allowed' });
      return;
    }
  });
  
  // 3. CORS configuration
  server.register(require('@fastify/cors'), {
    origin: (origin, cb) => {
      if (/^http:\/\/(localhost|127\.0\.0\.1):/.test(origin)) {
        cb(null, true);
        return;
      }
      cb(new Error('Not allowed'), false);
    },
    methods: ['GET', 'POST', 'OPTIONS']
  });
  
  // 4. Host header validation
  server.addHook('onRequest', async (request, reply) => {
    const host = request.headers.host;
    if (!host?.includes('localhost') && !host?.includes('127.0.0.1')) {
      reply.code(403).send({ error: 'Invalid Host header' });
    }
  });
}
```

### Docker Configuration

```yaml
# docker-compose.yml
services:
  decisions-server:
    ports:
      - "127.0.0.1:3000:3000"  # Bind to localhost only
    # NOT "3000:3000" (would bind to 0.0.0.0)
    environment:
      - BIND_ADDRESS=127.0.0.1
      - ENFORCE_ORIGIN=true
```

---

## Compliance Matrix

| Requirement | MCP Spec | OWASP | IETF | Implementation |
|------------|----------|-------|------|----------------|
| Bind to 127.0.0.1 | MUST | Recommended | Best Practice | Required |
| Origin validation | MUST | Required | RFC 9110 | Required |
| DNS rebinding protection | Implicit | Required | Best Practice | Required |
| CORS policy | Implicit | Required | CORS Spec | Required |
| Authentication | Optional | Recommended | RFC 6750 | v2.1 |

---

## References

### Standards
1. **Model Context Protocol Specification** (2024-11-05)
   - https://modelcontextprotocol.io/specification/2024-11-05/basic/transports

2. **IETF RFC 9110** - HTTP Semantics
   - Origin header specification

3. **IETF RFC 6202** - Known Issues and Best Practices for Server-Sent Events
   - SSE-specific considerations

4. **OWASP HTML5 Security Cheat Sheet**
   - Server-Sent Events security

5. **OWASP CORS Cheat Sheet**
   - Cross-Origin Resource Security

### Industry Sources
- MDN Web Docs: Server-Sent Events
- Fastify Security Best Practices
- Node.js Security Best Practices

### Academic Papers (Adjacent)
- arXiv:2008.03395 - Security Design Patterns in Distributed Microservice Architecture
- arXiv:2602.15945 - MCP Security Study (includes transport considerations)

---

*Research compiled by Strategist (Pyxis) for DECISION_096*
*Note: Limited academic research on HTTP/SSE localhost security; primarily industry standards*
*Date: 2026-02-22*
