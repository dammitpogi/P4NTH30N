# C0MMON/Games

## Responsibility

Provides platform-specific automation implementations for different gaming platforms using Chrome DevTools Protocol (CDP). Each game class encapsulates unique login, logout, balance querying, and game spinning mechanics.

## When Working Here

- **Platform abstraction**: Each platform implements consistent interface patterns
- **CDP-first approach**: Use Chrome DevTools Protocol instead of Selenium
- **CSS selectors**: Use CSS selector-based element interaction (no hardcoded coordinates)
- **Static methods**: Use static methods for stateless operations
- **Error resilience**: Try/catch around all web interactions, handle timeouts
- **Resource cleanup**: Proper CDP client disposal in finally blocks

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
   - Initialize CdpClient with WebSocket connection
   - Navigate to platform URL via CDP
   - Execute login (focus selectors, input text, click elements)
   - Verify login success via DOM queries

2. **Balance Queries**
   - FireKirin uses WebSocket protocol for real-time balance and jackpot queries
   - Parse jackpot values (Grand/Major/Minor/Mini)
   - Validate numeric values (NaN, Infinity checks)
   - Returns `FireKirinBalances` record
   - **Note**: Balance queries unchanged - still use WebSocket directly

3. **Game Spins**
   - Navigate to specific game via CDP
   - Locate and click spin elements using CSS selectors
   - Wait for spin completion
   - Return structured results (Signal? for override signals)

4. **Logout**
   - Clear session data via CDP
   - Navigate to logout or close browser
   - Cleanup CDP client resources

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

- **C0MMON/Infrastructure/Cdp**: ICdpClient, CdpClient, CdpConfig for browser automation
- **C0MMON/Actions**: Browser initialization (now CDP-compatible)
- **C0MMON/Entities**: Credential data, VisionCommand for FourEyes integration
- **C0MMON/Support**: GameSettings configuration
- **WebSocket**: ClientWebSocket for direct balance queries (unchanged)

## Platform-Specific Notes

**FireKirin:**
- Uses WebSocket protocol (port 8600) for real-time data (unchanged)
- Config fetched from `http://play.firekirin.in/web_mobile/plat/config/hall/firekirin/config.json`
- Supports FortunePiggy and Gold777 overlay detection
- CDP-based login/logout/spin operations via CSS selectors
- Session management via CDP WebSocket connection

**OrionStars:**
- Complex login flow with additional security steps (now CDP-based)
- Multi-game platform navigation via CDP
- Enhanced session validation through DOM queries
- Keyboard event simulation for login dialogs

**FortunePiggy:**
- Nested within OrionStars platform
- Specialized spin mechanics (CDP-compatible)
- Game-specific CSS selectors

## Recent Updates (2026-02-19)

### CDP Migration Complete
- **Replaced**: Selenium WebDriver with Chrome DevTools Protocol
- **New**: CSS selector-based element interaction
- **Improved**: WebSocket communication for reliable browser control
- **Maintained**: Direct WebSocket balance queries (unchanged for performance)

### H4ND Integration
- Games now support CdpGameActions static methods
- Login/Logout/Spin operations use CDP clients
- Element interaction via WaitForSelectorAndClickAsync, FocusSelectorAndClearAsync, TypeTextAsync
