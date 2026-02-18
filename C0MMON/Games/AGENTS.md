# C0MMON/Games

## Responsibility

Provides platform-specific automation implementations for different gaming platforms. Each game class encapsulates unique login, logout, balance querying, and game spinning mechanics.

## When Working Here

- **Platform abstraction**: Each platform implements consistent interface patterns
- **Static methods**: Use static methods for stateless operations
- **Element selectors**: Use By.Id, By.CssSelector, By.XPath strategies
- **Error resilience**: Try/catch around all web interactions, handle timeouts
- **Resource cleanup**: Always quit drivers in finally blocks

## Supported Platforms

- **FireKirin**: Slot machine automation with balance queries and spin operations
- **OrionStars**: Multi-game platform with Fortune Piggy integration
- **FortunePiggy**: Specific game implementation within OrionStars
- **Gold777**: Additional platform support
- **Quintuple5X**: Specialized slot game implementation

## Core Operations

1. **Login Sequence**
   - Validate credentials
   - Initialize ChromeDriver
   - Navigate to platform URL
   - Execute login (find elements, input credentials, submit)
   - Verify login success

2. **Balance Queries**
   - Execute JavaScript for balance extraction
   - Parse jackpot values (Grand/Major/Minor/Mini)
   - Validate numeric values (NaN, Infinity checks)

3. **Game Spins**
   - Navigate to specific game
   - Locate and click spin elements
   - Wait for spin completion
   - Return structured results

4. **Logout**
   - Clear session data
   - Navigate to logout or close browser
   - Cleanup resources

## Error Handling

- Element not found exceptions with retry logic
- Network timeout handling
- Invalid balance data detection (NaN, Infinity, negative)
- Session expiration detection and recovery

## Dependencies

- Selenium WebDriver (ChromeDriver)
- C0MMON/Actions for browser initialization
- C0MMON/Entities for credential data
- C0MMON/Support for GameSettings configuration

## Platform-Specific Notes

**FireKirin:**
- Direct web interface with standard login form
- JavaScript balance extraction from page variables
- Session management via cookie handling

**OrionStars:**
- Complex login flow with additional security steps
- Multi-game platform navigation
- Enhanced session validation

**FortunePiggy:**
- Nested within OrionStars platform
- Specialized spin mechanics
- Game-specific element selectors
