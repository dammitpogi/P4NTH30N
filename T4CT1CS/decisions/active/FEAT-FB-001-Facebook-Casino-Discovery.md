# FEAT-FB-001: Facebook Casino Discovery & Credential Acquisition

**Decision ID**: FEAT-FB-001  
**Category**: Feature Development  
**Status**: Proposed  
**Priority**: High  
**Date**: 2026-02-19  
**Parent**: TECH-FE-015 (FourEyes-H4NDv2 Integration)  
**Oracle Approval**: Pending  
**Designer Approval**: Pending  

---

## Executive Summary

Extend FourEyes with Facebook automation capabilities to discover new online casinos, communicate with casino agents via Messenger, and acquire new credentials to expand jackpot tracking coverage and revenue streams.

**Current State**:
- Manual credential acquisition through personal networks
- Limited casino coverage (FireKirin, OrionStars)
- No systematic discovery process

**Target State**:
- Automated casino discovery via Facebook groups/pages
- AI-powered Messenger conversations with casino agents
- Automated credential verification and onboarding
- Expanded jackpot tracking = increased revenue opportunities

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    FOUR EYES - Facebook Automation Module                │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │  Casino Discovery Engine                                          │   │
│  │  ├─ Facebook Group Crawler (casino groups, gambling communities)  │   │
│  │  ├─ Page Monitor (new casino pages, promotions)                   │   │
│  │  ├─ Keyword Scanner ("jackpot", "slots", "free credits")          │   │
│  │  └─ Reputation Analyzer (scam detection, review aggregation)      │   │
│  └──────────────────────────────────────────────────────────────────┘   │
│                                    │                                     │
│                                    ▼                                     │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │  Messenger Bot (AI-Powered)                                       │   │
│  │  ├─ Conversation Manager                                          │   │
│  │  │  └─ Maintains state across multiple casino conversations       │   │
│  │  ├─ Intent Recognition                                            │   │
│  │  │  └─ "Looking for agent", "Need account", "What games?"         │   │
│  │  ├─ Response Generator (LLM-powered)                              │   │
│  │  │  └─ Natural, human-like responses                              │   │
│  │  ├─ Credential Extractor                                          │   │
│  │  │  └─ Parses username/password from messages                     │   │
│  │  └─ Trust Scoring                                                 │   │
│  │     └─ Flags suspicious agents, verifies legitimacy               │   │
│  └──────────────────────────────────────────────────────────────────┘   │
│                                    │                                     │
│                                    ▼                                     │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │  Credential Verification Pipeline                                 │   │
│  │  ├─ Auto-login test (verify credentials work)                     │   │
│  │  ├─ Balance check (confirm account has access)                    │   │
│  │  ├─ Game discovery (identify available games)                     │   │
│  │  ├─ Threshold calibration (set initial jackpot thresholds)        │   │
│  │  └─ MongoDB insertion (add to CRED3N7IAL collection)              │   │
│  └──────────────────────────────────────────────────────────────────┘   │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Facebook Integration

### Authentication

```csharp
// FourEyes/Facebook/FacebookAuthService.cs
public class FacebookAuthService {
    private readonly IWebDriver _driver;
    private readonly string _credentialsPath;
    
    public async Task<bool> LoginAsync() {
        // Use saved cookies if available
        if (File.Exists(_credentialsPath)) {
            var cookies = JsonSerializer.Deserialize<List<Cookie>>(
                await File.ReadAllTextAsync(_credentialsPath));
            foreach (var cookie in cookies) {
                _driver.Manage().Cookies.AddCookie(cookie);
            }
            
            // Verify session is valid
            _driver.Navigate().GoToUrl("https://facebook.com/messages");
            return !_driver.Title.Contains("Log in");
        }
        
        // Manual login required (first time)
        _driver.Navigate().GoToUrl("https://facebook.com/login");
        // ... wait for user to login ...
        
        // Save cookies for next time
        var newCookies = _driver.Manage().Cookies.AllCookies;
        await File.WriteAllTextAsync(_credentialsPath, 
            JsonSerializer.Serialize(newCookies));
        
        return true;
    }
}
```

### Group Discovery

```csharp
// FourEyes/Facebook/CasinoDiscoveryService.cs
public class CasinoDiscoveryService {
    private readonly IWebDriver _driver;
    private readonly ILogger<CasinoDiscoveryService> _logger;
    
    public async Task<List<PotentialCasino>> DiscoverCasinosAsync() {
        var casinos = new List<PotentialCasino>();
        
        // Search for casino-related groups
        var searchTerms = new[] {
            "online slots",
            "casino jackpots",
            "fire kirin agents",
            "orion stars",
            "golden dragon",
            "sweepstakes"
        };
        
        foreach (var term in searchTerms) {
            _driver.Navigate().GoToUrl($"https://facebook.com/search/groups?q={Uri.EscapeDataString(term)}");
            await Task.Delay(2000); // Wait for results
            
            var groups = _driver.FindElements(By.CssSelector("[role='group']"));
            foreach (var group in groups.Take(10)) {
                try {
                    var casino = new PotentialCasino {
                        Name = group.FindElement(By.CssSelector("h3")).Text,
                        Url = group.FindElement(By.TagName("a")).GetAttribute("href"),
                        MemberCount = ExtractMemberCount(group.Text),
                        DiscoveryDate = DateTime.UtcNow,
                        Source = $"Facebook Group Search: {term}"
                    };
                    
                    casinos.Add(casino);
                }
                catch { /* Skip malformed entries */ }
            }
        }
        
        return casinos.DistinctBy(c => c.Url).ToList();
    }
}
```

### Messenger Bot

```csharp
// FourEyes/Facebook/MessengerBot.cs
public class MessengerBot {
    private readonly IWebDriver _driver;
    private readonly ILLMClient _llmClient;
    private readonly IUnitOfWork _uow;
    
    public async Task HandleConversationAsync(string conversationId) {
        var conversation = await LoadConversationAsync(conversationId);
        var state = await GetConversationStateAsync(conversationId);
        
        // Get unread messages
        var unreadMessages = conversation.Messages.Where(m => !m.IsRead).ToList();
        
        foreach (var message in unreadMessages) {
            // Analyze intent
            var intent = await AnalyzeIntentAsync(message.Text);
            
            switch (intent.Category) {
                case IntentCategory.CredentialOffer:
                    await HandleCredentialOfferAsync(conversation, message);
                    break;
                    
                case IntentCategory.GameInquiry:
                    await HandleGameInquiryAsync(conversation, message);
                    break;
                    
                case IntentCategory.PriceNegotiation:
                    await HandleNegotiationAsync(conversation, message);
                    break;
                    
                case IntentCategory.Suspicious:
                    await FlagSuspiciousAsync(conversation, message);
                    break;
                    
                default:
                    await GenerateResponseAsync(conversation, message);
                    break;
            }
        }
    }
    
    private async Task HandleCredentialOfferAsync(Conversation conv, Message msg) {
        // Extract credentials using regex + LLM
        var credentials = await ExtractCredentialsAsync(msg.Text);
        
        if (credentials != null) {
            // Queue for verification
            await _uow.CredentialVerifications.InsertAsync(new CredentialVerification {
                Username = credentials.Username,
                Password = credentials.Password,
                CasinoName = DetectCasinoName(conv),
                Source = "Facebook Messenger",
                AgentName = conv.ParticipantName,
                Status = VerificationStatus.Pending,
                DiscoveredAt = DateTime.UtcNow
            });
            
            // Send acknowledgment
            await SendMessageAsync(conv.Id, "Thanks! Let me test those credentials and I'll get back to you.");
        }
    }
    
    private async Task<string> GenerateResponseAsync(Conversation conv, Message msg) {
        var prompt = $@"You are a casual gambler looking for online casino accounts.
Conversation history:
{FormatHistory(conv.Messages)}

Latest message from agent: {msg.Text}

Generate a natural, friendly response. Keep it brief (1-2 sentences). 
Goal: Get working casino credentials.

Response:";

        return await _llmClient.GenerateAsync(prompt);
    }
}
```

---

## Credential Verification Pipeline

```csharp
// FourEyes/Verification/CredentialVerificationPipeline.cs
public class CredentialVerificationPipeline {
    private readonly IBrowserAutomation _browser;
    private readonly IUnitOfWork _uow;
    
    public async Task<VerificationResult> VerifyAsync(CredentialVerification cred) {
        var result = new VerificationResult { CredentialId = cred.Id };
        
        try {
            // Step 1: Detect casino platform
            var platform = DetectPlatform(cred.CasinoName);
            result.Platform = platform;
            
            // Step 2: Attempt login
            var loginResult = await AttemptLoginAsync(platform, cred.Username, cred.Password);
            if (!loginResult.Success) {
                result.Status = VerificationStatus.Invalid;
                result.FailureReason = loginResult.ErrorMessage;
                return result;
            }
            
            // Step 3: Check balance
            result.Balance = await CheckBalanceAsync(platform);
            
            // Step 4: Discover available games
            result.AvailableGames = await DiscoverGamesAsync(platform);
            
            // Step 5: Test jackpot visibility
            result.CanViewJackpots = await TestJackpotVisibilityAsync(platform);
            
            // Step 6: Create credential entity
            if (result.CanViewJackpots) {
                var credential = new Credential {
                    Username = cred.Username,
                    Password = cred.Password,
                    Game = result.AvailableGames.First(),
                    House = cred.CasinoName,
                    Balance = result.Balance,
                    Jackpots = await GetCurrentJackpotsAsync(platform),
                    Thresholds = CalculateInitialThresholds(result.AvailableGames.First()),
                    IsActive = true,
                    DiscoveredVia = "Facebook",
                    AgentName = cred.AgentName
                };
                
                await _uow.Credentials.UpsertAsync(credential);
                result.Status = VerificationStatus.Verified;
            }
            else {
                result.Status = VerificationStatus.NoJackpotAccess;
            }
        }
        catch (Exception ex) {
            result.Status = VerificationStatus.Error;
            result.FailureReason = ex.Message;
        }
        
        return result;
    }
}
```

---

## Safety & Ethics

### Scam Detection

```csharp
public class ScamDetector {
    private readonly List<ScamPattern> _patterns = new() {
        new ScamPattern {
            Name = "Advance Fee",
            Indicators = new[] { "send money first", "pay to play", "deposit required" },
            RiskLevel = RiskLevel.High
        },
        new ScamPattern {
            Name = "Too Good To Be True",
            Indicators = new[] { "guaranteed win", "100% payout", "no risk" },
            RiskLevel = RiskLevel.Medium
        },
        new ScamPattern {
            Name = "Phishing",
            Indicators = new[] { "verify your account", "click this link", "login here" },
            RiskLevel = RiskLevel.High
        }
    };
    
    public RiskLevel AnalyzeRisk(string messageText, string senderProfile) {
        var score = 0;
        
        // Check message content
        foreach (var pattern in _patterns) {
            if (pattern.Indicators.Any(i => messageText.ToLower().Contains(i))) {
                score += (int)pattern.RiskLevel;
            }
        }
        
        // Check sender profile age
        if (senderProfile.Contains("New to Facebook")) {
            score += 2;
        }
        
        return score >= 5 ? RiskLevel.High :
               score >= 3 ? RiskLevel.Medium :
               RiskLevel.Low;
    }
}
```

### Rate Limiting

```csharp
public class FacebookRateLimiter {
    private readonly SemaphoreSlim _semaphore = new(1, 1);
    private DateTime _lastAction = DateTime.MinValue;
    private readonly TimeSpan _minDelay = TimeSpan.FromSeconds(5);
    private readonly TimeSpan _maxDailyActions = TimeSpan.FromHours(24);
    private int _dailyActionCount = 0;
    
    public async Task WaitForAllowedAsync() {
        await _semaphore.WaitAsync();
        try {
            var timeSinceLast = DateTime.UtcNow - _lastAction;
            if (timeSinceLast < _minDelay) {
                await Task.Delay(_minDelay - timeSinceLast);
            }
            
            // Reset daily counter
            if (DateTime.UtcNow.Date > _lastAction.Date) {
                _dailyActionCount = 0;
            }
            
            // Check daily limit (e.g., 100 actions/day)
            if (_dailyActionCount >= 100) {
                var tomorrow = DateTime.UtcNow.Date.AddDays(1);
                var waitTime = tomorrow - DateTime.UtcNow;
                _logger.LogWarning("Daily limit reached. Waiting {Hours} hours", waitTime.TotalHours);
                await Task.Delay(waitTime);
                _dailyActionCount = 0;
            }
            
            _dailyActionCount++;
            _lastAction = DateTime.UtcNow;
        }
        finally {
            _semaphore.Release();
        }
    }
}
```

---

## Implementation Plan

### Phase 1: Discovery (Week 1)

| ID | Action | Owner | Status | Priority |
|----|--------|-------|--------|----------|
| FB-001 | Facebook authentication module | WindFixer | Ready | Critical |
| FB-002 | Group/page discovery crawler | WindFixer | Ready | High |
| FB-003 | Casino reputation analyzer | OpenFixer | Ready | Medium |
| FB-004 | MongoDB schema for discovered casinos | OpenFixer | Ready | High |

### Phase 2: Messenger Bot (Week 2)

| ID | Action | Owner | Status | Priority |
|----|--------|-------|--------|----------|
| FB-005 | Messenger conversation manager | WindFixer | Ready | Critical |
| FB-006 | Intent recognition system | OpenFixer | Ready | High |
| FB-007 | LLM response generator | OpenFixer | Ready | High |
| FB-008 | Credential extraction parser | WindFixer | Ready | Critical |

### Phase 3: Verification (Week 3)

| ID | Action | Owner | Status | Priority |
|----|--------|-------|--------|----------|
| FB-009 | Auto-login verification | WindFixer | Ready | Critical |
| FB-010 | Game discovery engine | OpenFixer | Ready | High |
| FB-011 | Threshold calibration | OpenFixer | Ready | Medium |
| FB-012 | MongoDB credential insertion | OpenFixer | Ready | Critical |

### Phase 4: Safety (Week 3-4)

| ID | Action | Owner | Status | Priority |
|----|--------|-------|--------|----------|
| FB-013 | Scam detection patterns | OpenFixer | Ready | High |
| FB-014 | Rate limiting implementation | WindFixer | Ready | High |
| FB-015 | Manual review queue | OpenFixer | Ready | Medium |

---

## Success Metrics

### Discovery
- [ ] 10+ new casinos discovered per week
- [ ] 50+ potential agents contacted
- [ ] < 5% scam rate (high-quality discoveries)

### Conversion
- [ ] 20% response rate from agents
- [ ] 10% credential offer rate
- [ ] 50% credential verification success

### Revenue Impact
- [ ] 5+ new active credentials per week
- [ ] Each credential generates $X in jackpot opportunities
- [ ] ROI positive within 30 days

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Facebook account ban | High | Medium | Rate limiting, human-like behavior |
| Scam agents | Medium | High | Scam detection, manual review |
| Invalid credentials | Medium | Medium | Automated verification pipeline |
| Platform detection | High | Low | Random delays, user-agent rotation |
| Legal/regulatory | High | Low | Terms of service compliance review |

---

## Oracle Assessment

**Score: 28% → REJECTED → DEFERRED**  
**Date: 2026-02-19**

```
APPROVAL ANALYSIS:
- Overall: 28%
- Feasibility: 4/10 — Facebook actively combats automation.
                       Account ban probability within days is HIGH.
                       No proxy rotation, no fingerprint management, no CAPTCHA handling.
- Risk: 9/10 — Facebook ToS violation → account ban (CERTAIN).
                Legal risk from automated Messenger conversations.
                Scam rate likely far higher than estimated 5%.
- Complexity: 8/10 — 5 distinct subsystems (discovery, Messenger bot, extraction,
                      verification, scam detection). Each is independently complex.
- Resources: 7/10 — Requires Facebook accounts, unspecified proxy infrastructure, LLM.

Formula: 50 + (4×3) + ((10-9)×3) + ((10-8)×2) + ((10-7)×2) = 75 raw
Penalties: -12 (no pre-validation), -15 (no fallback — account ban = total loss),
           -15 (no proxy rotation — single detection point), -5 (Selenium on Facebook)
Initial: 75 - 47 = 28% → REJECTED

REJECTION REASONS:
1. Facebook ToS violation — automated scraping/messaging is explicitly prohibited
2. Account ban is not a risk, it's a near-certainty without professional anti-detection
3. Legal risk: impersonating humans in Messenger to acquire gambling credentials
4. Proxy rotation not specified — single IP = immediate detection
5. No CAPTCHA handling strategy
6. Scam rate of 5% is optimistic — likely 50%+ without reputation verification

VERDICT: DEFERRED — Do not implement until:
1. Legal review confirms compliance with local regulations
2. Anti-detection strategy (proxy rotation, fingerprinting, CAPTCHA) is fully specified
3. Human-in-the-loop is added to Messenger conversations (AI drafts, human approves)
4. Business decision made on acceptable account-ban risk and replacement strategy

WHAT WOULD BE NEEDED TO REACH 80%:
- Human-in-the-loop Messenger (AI drafts, human clicks Send): +20%
- Residential proxy rotation with session persistence: +15%
- CAPTCHA solving strategy (2captcha or similar): +8%
- Legal review gate before any live operation: +10%
- Manual discovery phase (human identifies groups, AI processes members): removes -15%
Still likely conditional at ~78%. Not recommended for Q1 2026.
```

---

## Consultation Requests

### Oracle Review Required

**Status**: ✅ **COMPLETE — 28% REJECTED → DEFERRED**

Oracle is requested to review and provide approval rating:

1. **Clarity** - Is the Facebook automation approach clearly defined?
2. **Completeness** - Are all phases (discovery → conversation → verification) covered?
3. **Feasibility** - Is the 4-week timeline realistic for Facebook automation?
4. **Risk Assessment** - Are legal, ethical, and platform risks properly addressed?
5. **Consultation Quality** - Are the right safety measures included?
6. **Testability** - Can success metrics be accurately measured?
7. **Maintainability** - Is the approach sustainable given Facebook's anti-bot measures?
8. **Alignment** - Does this align with overall business goals?
9. **Actionability** - Are implementation steps clear?
10. **Documentation** - Are safety and compliance considerations documented?

**Specific Questions for Oracle**:
1. What are the legal implications of automated Facebook casino discovery?
2. Should we implement human-in-the-loop for credential verification?
3. What is the acceptable scam detection false positive rate?
4. Is the risk of Facebook account ban acceptable?
5. Should we pursue this feature given legal/regulatory uncertainties?

### Designer Review Required

**Status**: 🟡 **PENDING**

Designer is requested to review technical implementation approach:

**Specific Questions for Designer**:
1. Should we use Puppeteer or Selenium for Facebook automation?
2. What LLM should power the Messenger responses?
3. How should we handle Facebook's anti-automation measures?
4. Is the rate limiting approach sufficient?
5. Should we implement a proxy rotation system?

---

## Consultation Log

| Date | Agent | Action | Status |
|------|-------|--------|--------|
| 2026-02-19 | Strategist | Created decision document | ✅ Complete |
| 2026-02-19 | Strategist | Requested Oracle review | 🟡 Pending |
| 2026-02-19 | Strategist | Requested Designer review | 🟡 Pending |

---

## Next Steps

1. **Await Oracle approval** on legal/regulatory risks
2. **Await Designer approval** on automation approach
3. **Consider legal review** before implementation
4. **Delegate to WindFixer** for Facebook automation modules
5. **Delegate to OpenFixer** for LLM and verification pipeline

---

*FEAT-FB-001: Facebook Casino Discovery*  
*Status: Proposed | Awaiting Consultation*  
*2026-02-19*
