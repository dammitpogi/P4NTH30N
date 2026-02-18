# C0MMON/Games/

## Responsibility

C0MMON/Games provides platform-specific automation implementations for different gaming platforms. Each game class encapsulates the unique login, logout, balance querying, and game spinning mechanics required for automated interaction across supported platforms.

**Supported Platforms:**
- **FireKirin**: Slot machine automation with balance queries and spin operations
- **OrionStars**: Multi-game platform with Fortune Piggy integration
- **FortunePiggy**: Specific game implementation within OrionStars ecosystem
- **Gold777**: Additional platform support for slot automation
- **Quintuple5X**: Specialized slot game implementation

## Design

**Key Patterns:**

1. **Platform Abstraction**
   - Each platform implements consistent interface patterns
   - Static methods for stateless operations (Login, Logout, QueryBalances)
   - Platform-specific element selectors and interaction patterns

2. **Selenium WebDriver Integration**
   - ChromeDriver automation for web-based platforms
   - Element location strategies (By.Id, By.CssSelector, By.XPath)
   - JavaScript execution for complex interactions and data extraction

3. **Error Resilience**
   - Try/catch blocks around all web interactions
   - Element wait strategies with timeout handling
   - Network failure detection and retry logic

4. **Game-Specific Logic**
   - Unique spin mechanics per platform/game
   - Balance extraction patterns (JavaScript vs DOM parsing)
   - Platform-specific login flows and session management

## Flow

```
Platform Interaction Flow:
├── Initialize WebDriver (shared across operations)
├── Navigate to platform URL
├── Execute Login sequence
│   ├── Find username input element
│   ├── Enter credentials
│   ├── Find password input element
│   ├── Enter password
│   ├── Locate and click submit button
│   └── Wait for login confirmation
├── Query Balances
│   ├── Execute JavaScript for balance extraction
│   ├── Parse jackpot values (Grand/Major/Minor/Mini)
│   ├── Validate numeric values (NaN, Infinity checks)
│   └── Return structured balance data
├── Execute Game Spin
│   ├── Navigate to specific game
│   ├── Locate spin button/element
│   ├── Click spin action
│   ├── Wait for spin completion
│   └── Return to main screen
└── Execute Logout
    ├── Clear session data
    ├── Navigate to logout or close browser
    └── Cleanup resources
```

## Integration

**Dependencies:**
- **Selenium WebDriver**: ChromeDriver for browser automation
- **C0MMON/Actions**: Launch action for WebDriver initialization
- **C0MMON/Entities**: Credential data for authentication
- **C0MMON/Support**: GameSettings for platform configuration

**Platform-Specific Details:**

**FireKirin:**
- Direct web interface with standard login form
- JavaScript balance extraction from page variables
- Slot machine automation with button click patterns
- Session management via cookie handling

**OrionStars:**
- More complex login flow with additional security steps
- Multi-game platform navigation
- FortunePiggy specific spin implementation
- Enhanced session validation

**FortunePiggy:**
- Nested within OrionStars platform
- Specialized spin mechanics
- Unique balance extraction patterns
- Game-specific element selectors

**Used By:**
- **H4ND**: Primary consumer for automation workflows
- **H0UND**: Balance polling operations
- **Future Agents**: Platform expansion support

**Error Handling:**
- Element not found exceptions with retry logic
- Network timeout handling
- Invalid balance data detection
- Session expiration detection and recovery
