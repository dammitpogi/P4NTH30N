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

| Platform | File | Description |
|----------|------|-------------|
| **FireKirin** | `FireKirin.cs` | Slot machine automation with WebSocket-based balance queries and spin operations |
| **OrionStars** | `OrionStars.cs` | Multi-game platform with Fortune Piggy integration |
| **FortunePiggy** | `FortunePiggy.cs` | Specific game implementation within OrionStars |
| **Gold777** | `Gold777.cs` | Additional platform support |
| **Quintuple5X** | `Quintuple5X.cs` | Specialized slot game implementation |

## Core Operations

1. **Login Sequence**
   - Validate credentials
   - Initialize ChromeDriver
   - Navigate to platform URL
   - Execute login (find elements, input credentials, submit)
   - Verify login success

2. **Balance Queries**
   - FireKirin uses WebSocket protocol for real-time balance and jackpot queries
   - Parse jackpot values (Grand/Major/Minor/Mini)
   - Validate numeric values (NaN, Infinity checks)
   - Returns `FireKirinBalances` record

3. **Game Spins**
   - Navigate to specific game
   - Locate and click spin elements
   - Wait for spin completion
   - Return structured results (Signal? for override signals)

4. **Logout**
   - Clear session data
   - Navigate to logout or close browser
   - Cleanup resources

## FireKirin Implementation Details

```csharp
// WebSocket-based balance query
public static FireKirinBalances QueryBalances(string username, string password)
{
    FireKirinNetConfig config = FetchNetConfig();
    string wsUrl = $"{config.GameProtocol}{config.BsIp}:{config.WsPort}";
    using var ws = new ClientWebSocket();
    
    // Connect and authenticate via WebSocket
    ws.ConnectAsync(new Uri(wsUrl), connectCts.Token);
    
    // Query balance
    SendJson(ws, new { mainID = 100, subID = 6, account = username, password = md5Password });
    
    // Query jackpots
    SendJson(ws, new { mainID = 100, subID = 10, bossid = bossId });
    
    return new FireKirinBalances(balance, grand, major, minor, mini);
}

// Spin with platform override detection
public static Signal? SpinSlots(ChromeDriver driver, Credential credential, Signal signal, IUnitOfWork uow)
{
    // Check for FortunePiggy or Gold777 overlay
    bool FortunePiggyLoaded = Games.FortunePiggy.LoadSucessfully(driver, credential, signal, uow);
    bool Gold777Loaded = FortunePiggyLoaded ? false : Games.Gold777.LoadSucessfully(driver, credential, signal, uow);
    
    // Override signal if alternative platform loaded
    if (FortunePiggyLoaded)
        overrideSignal = Games.FortunePiggy.Spin(driver, credential, signal, uow);
    // ... navigate to FireKirin and spin
}
```

## Error Handling

- Element not found exceptions with retry logic
- Network timeout handling (10-second timeouts)
- Invalid balance data detection (NaN, Infinity, negative)
- Session expiration detection and recovery
- WebSocket connection failures with fallback

## Dependencies

- Selenium WebDriver (ChromeDriver)
- C0MMON/Actions for browser initialization
- C0MMON/Entities for credential data
- C0MMON/Support for GameSettings configuration

## Platform-Specific Notes

**FireKirin:**
- Uses WebSocket protocol (port 8600) for real-time data
- Config fetched from `http://play.firekirin.in/web_mobile/plat/config/hall/firekirin/config.json`
- Supports FortunePiggy and Gold777 overlay detection
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
