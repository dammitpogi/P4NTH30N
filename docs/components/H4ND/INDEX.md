# H4ND Component Guide

Automation agent — "The Hands" of P4NTHE0N.

## Overview

H4ND consumes automation signals from H0UND and executes gameplay via browser automation. It orchestrates credential management, jackpot monitoring, and automated spins across casino platforms.

### Responsibilities

- **Signal Processing**: Consume SIGN4L records from queue
- **Credential Management**: Lock, validate, update credentials
- **Browser Automation**: Login, navigate, spin via Selenium
- **Jackpot Monitoring**: Track 4-tier jackpot system
- **DPD Toggles**: Detect jackpot resets via double-drop pattern

## Architecture

```
H4ND/
├── H4ND.cs                     # Entry point and main loop
├── Actions/
│   ├── Login.cs                # Platform authentication
│   ├── Logout.cs               # Clean session termination
│   ├── Launch.cs               # Browser initialization
│   └── Overwrite.cs            # Resource override management
└── Games/
    ├── FireKirin.cs            # FireKirin platform
    ├── OrionStars.cs           # OrionStars platform
    └── FortunePiggy.cs         # Fortune Piggy game
```

## Data Flow

```
┌─────────────────────────────────────────────────────────┐
│                        H4ND                             │
│                                                         │
│  ┌──────────────┐                                       │
│  │   MongoDB    │                                       │
│  │  ┌────────┐  │      ┌──────────────┐                │
│  │  │ SIGN4L │──┼──────▶│ Main Loop    │                │
│  │  └────────┘  │      │              │                │
│  │  ┌────────┐  │      └──────┬───────┘                │
│  │  │CRED3N7│  │             │                         │
│  │  │ -IAL  │◀─┼─────────────┤                         │
│  │  └────────┘  │             ▼                         │
│  └──────────────┘      ┌──────────────┐                │
│                        │ Credential   │                │
│                        │ Lifecycle    │                │
│                        └──────┬───────┘                │
│                               │                         │
│                               ▼                         │
│                        ┌──────────────┐                │
│                        │  Selenium    │                │
│                        │  ChromeDriver│                │
│                        └──────┬───────┘                │
│                               │                         │
│                               ▼                         │
│                        ┌──────────────┐                │
│                        │ Casino Site  │                │
│                        │ (FireKirin)  │                │
│                        └──────────────┘                │
└─────────────────────────────────────────────────────────┘
```

## Main Loop

```csharp
// H4ND.cs - Main automation loop
while (!cancellationToken.IsCancellationRequested)
{
    try
    {
        // 1. Get next signal (optional)
        var signal = await signalRepo.GetNextAsync();
        
        // 2. Get credential (from signal or round-robin)
        var credential = await GetCredentialAsync(signal);
        
        // 3. Lock credential
        if (!await LockCredentialAsync(credential))
        {
            continue; // Try next credential
        }
        
        // 4. Login to platform
        await LoginAsync(credential);
        
        // 5. Check jackpot values
        var jackpots = await GetBalancesWithRetryAsync(credential);
        
        // 6. Update DPD toggles
        UpdateDpdToggles(credential, jackpots);
        
        // 7. If signal, spin game
        if (signal != null)
        {
            await SpinAsync(credential, signal);
            await AcknowledgeSignalAsync(signal);
        }
        
        // 8. Update credential
        credential.Jackpots = jackpots;
        await UpdateCredentialAsync(credential);
        
        // 9. Logout
        await LogoutAsync(credential);
        
        // 10. Unlock credential
        await UnlockCredentialAsync(credential);
    }
    catch (Exception ex)
    {
        // Log with line number
        var frame = new StackTrace(ex, true).GetFrame(0);
        int line = frame?.GetFileLineNumber() ?? 0;
        errorStore.LogError($"[{line}] Processing failed: {ex.Message}");
        
        // Cleanup
        await CleanupAsync();
        await Task.Delay(TimeSpan.FromSeconds(5));
    }
}
```

## Credential Lifecycle

### Lock → Validate → Process → Unlock

```csharp
public async Task ProcessCredentialAsync(Credential credential)
{
    try
    {
        // 1. LOCK - Prevent concurrent access
        var locked = await credentialRepo.UpdateOneAsync(
            filter: c => c.Id == credential.Id && c.Locked == false,
            update: Builders<Credential>.Update.Set(c => c.Locked, true)
        );
        
        if (!locked)
        {
            return; // Another instance has it
        }
        
        // 2. VALIDATE - Check credential is valid
        if (!credential.IsValid(errorStore))
        {
            await UnlockCredentialAsync(credential);
            return;
        }
        
        // 3. PROCESS - Execute automation
        await ExecuteAutomationAsync(credential);
        
        // 4. UNLOCK - Release for next use
        await UnlockCredentialAsync(credential);
    }
    catch (Exception ex)
    {
        // Always unlock on error
        await UnlockCredentialAsync(credential);
        throw;
    }
}
```

## Browser Automation

### ChromeDriver Management

```csharp
public class BrowserManager
{
    private IWebDriver _driver;
    
    public async Task<IWebDriver> GetOrCreateDriverAsync()
    {
        if (_driver != null)
        {
            try
            {
                // Test if still responsive
                _ = _driver.Title;
                return _driver;
            }
            catch
            {
                // Driver dead, recreate
                await QuitAsync();
            }
        }
        
        // Create new driver
        var options = new ChromeOptions();
        options.AddExtension("RUL3S/auto-override");
        
        _driver = new ChromeDriver(options);
        _driver.Manage().Timeouts().ImplicitWait = TimeSpan.FromSeconds(10);
        
        return _driver;
    }
    
    public async Task QuitAsync()
    {
        _driver?.Quit();
        _driver = null;
    }
}
```

### Login Flow

```csharp
public async Task LoginAsync(Credential credential)
{
    var driver = await browserManager.GetOrCreateDriverAsync();
    
    // Navigate to platform
    await driver.Navigate().GoToUrlAsync($"https://{credential.House}.com/login");
    
    // Decrypt password
    var password = encryptionService.DecryptFromString(credential.Password);
    
    // Fill login form
    await driver.FindElement(By.Id("username")).SendKeysAsync(credential.Username);
    await driver.FindElement(By.Id("password")).SendKeysAsync(password);
    
    // Submit
    await driver.FindElement(By.Id("login-btn")).ClickAsync();
    
    // Wait for game to load
    await WaitForGameLoadAsync(driver);
}
```

## Jackpot Monitoring

### Reading Values via JavaScript

```csharp
public async Task<JackpotValues> GetBalancesAsync(Credential credential)
{
    var driver = await browserManager.GetOrCreateDriverAsync();
    
    // Execute JS to get jackpot values from game
    var grand = await ExecuteJsAsync<double>("return window.parent.Grand;");
    var major = await ExecuteJsAsync<double>("return window.parent.Major;");
    var minor = await ExecuteJsAsync<double>("return window.parent.Minor;");
    var mini = await ExecuteJsAsync<double>("return window.parent.Mini;");
    
    // Validate values
    if (double.IsNaN(grand) || double.IsInfinity(grand) || grand < 0)
    {
        errorStore.LogError($"[{credential.Id}] Invalid Grand value: {grand}");
        throw new InvalidDataException("Invalid jackpot value");
    }
    
    // Verify Grand > 0 (game loaded check)
    for (int i = 0; i < 40; i++)
    {
        if (grand > 0) break;
        await Task.Delay(500);
        grand = await ExecuteJsAsync<double>("return window.parent.Grand;");
    }
    
    return new JackpotValues
    {
        Grand = grand,
        Major = major,
        Minor = minor,
        Mini = mini
    };
}
```

### Retry Logic

```csharp
public async Task<JackpotValues> GetBalancesWithRetryAsync(Credential credential)
{
    int attempts = 0;
    Exception lastError = null;
    
    while (attempts < 3)
    {
        try
        {
            return await GetBalancesAsync(credential);
        }
        catch (Exception ex)
        {
            lastError = ex;
            attempts++;
            
            // Exponential backoff with jitter
            var delay = TimeSpan.FromSeconds(Math.Pow(2, attempts)) 
                + TimeSpan.FromMilliseconds(Random.Shared.Next(100, 500));
            
            await Task.Delay(delay);
        }
    }
    
    throw new Exception($"Failed after 3 attempts: {lastError?.Message}");
}
```

## DPD Toggle Detection

### Jackpot Pop Detection

```csharp
public void UpdateDpdToggles(Credential credential, JackpotValues current)
{
    // Check Grand tier
    CheckTierToggle(credential, Tier.Grand, current.Grand, credential.Jackpots.Grand);
    
    // Check Major tier
    CheckTierToggle(credential, Tier.Major, current.Major, credential.Jackpots.Major);
    
    // Check Minor tier
    CheckTierToggle(credential, Tier.Minor, current.Minor, credential.Jackpots.Minor);
    
    // Check Mini tier
    CheckTierToggle(credential, Tier.Mini, current.Mini, credential.Jackpots.Mini);
}

private void CheckTierToggle(Credential credential, Tier tier, double current, double previous)
{
    double drop = previous - current;
    
    if (current < previous && drop > 0.1)
    {
        // Value dropped significantly
        if (credential.DPD.Toggles.Get(tier))
        {
            // Second consecutive drop - JACKPOT POP CONFIRMED
            ResetThreshold(credential, tier);
            credential.DPD.Toggles.Set(tier, false);
            
            LogInfo($"[{credential.Id}] {tier} jackpot popped! Reset threshold.");
        }
        else
        {
            // First drop - set toggle, wait for confirmation
            credential.DPD.Toggles.Set(tier, true);
        }
    }
    else
    {
        // Value increased or stable - reset toggle
        credential.DPD.Toggles.Set(tier, false);
    }
}
```

### Threshold Reset

```csharp
public void ResetThreshold(Credential credential, Tier tier)
{
    switch (tier)
    {
        case Tier.Grand:
            credential.Thresholds.Grand = credential.Jackpots.Grand * 1.2;
            break;
        case Tier.Major:
            credential.Thresholds.Major = credential.Jackpots.Major * 1.2;
            break;
        case Tier.Minor:
            credential.Thresholds.Minor = credential.Jackpots.Minor * 1.2;
            break;
        case Tier.Mini:
            credential.Thresholds.Mini = credential.Jackpots.Mini * 1.2;
            break;
    }
}
```

## Game Automation

### Spinning Slots

```csharp
public async Task SpinAsync(Credential credential, Signal signal)
{
    var driver = await browserManager.GetOrCreateDriverAsync();
    
    // Get starting balance
    double startBalance = await GetBalanceAsync(driver);
    
    // Click spin button
    await driver.FindElement(By.Id("spin-btn")).ClickAsync();
    
    // Wait for spin to complete (animation)
    await Task.Delay(3000);
    
    // Wait for result (win/loss)
    await WaitForResultAsync(driver);
    
    // Get ending balance
    double endBalance = await GetBalanceAsync(driver);
    
    // Log result
    double change = endBalance - startBalance;
    await eventStore.StoreEventAsync(new Event
    {
        Agent = "H4ND",
        Action = "Spin",
        Username = credential.Id,
        Metadata = new { BalanceChange = change, Tier = signal.Priority }
    });
}
```

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `H4ND_POLL_INTERVAL` | 5s | Seconds between signal checks |
| `H4ND_SPIN_TIMEOUT` | 30s | Maximum spin duration |
| `H4ND_RETRY_ATTEMPTS` | 3 | Network retry attempts |
| `H4ND_HEALTH_CHECK_INTERVAL` | 5min | Health check frequency |

### appsettings.json
```json
{
  "H4ND": {
    "Automation": {
      "PollIntervalSeconds": 5,
      "SpinTimeoutSeconds": 30,
      "RetryAttempts": 3,
      "GrandCheckRetries": 40,
      "GrandCheckIntervalMs": 500
    },
    "Browser": {
      "Headless": false,
      "ExtensionPath": "RUL3S/auto-override",
      "UserDataDir": "./chrome-data"
    },
    "Safety": {
      "HealthCheckIntervalMinutes": 5,
      "MaxConsecutiveErrors": 10
    }
  }
}
```

## Health Monitoring

### Periodic Health Checks

```csharp
public async Task PerformHealthCheckAsync()
{
    // Every 5 minutes
    if (DateTime.UtcNow - lastHealthCheck < TimeSpan.FromMinutes(5))
    {
        return;
    }
    
    lastHealthCheck = DateTime.UtcNow;
    
    // Check error rate
    var recentErrors = await errorRepo.GetRecentAsync(TimeSpan.FromMinutes(5));
    if (recentErrors.Count > 10)
    {
        LogWarning($"High error rate: {recentErrors.Count} errors in 5 minutes");
    }
    
    // Check ChromeDriver health
    try
    {
        _ = _driver?.Title;
    }
    catch
    {
        LogError("ChromeDriver unresponsive, will recreate");
        await browserManager.QuitAsync();
    }
}
```

## Troubleshooting

### Login Failures
1. Check credential not banned
2. Verify password decrypts correctly
3. Check casino site accessible
4. Look for CAPTCHA or 2FA

### Spin Failures
1. Check game still loaded
2. Verify spin button visible
3. Check for error dialogs
4. Review console JavaScript errors

### High Error Rate
1. Check ChromeDriver version matches Chrome
2. Verify extension loaded
3. Review network connectivity
4. Check for casino site updates

### Jackpot Values Not Reading
1. Verify game fully loaded (Grand > 0)
2. Check JavaScript injection working
3. Review RUL3S extension status
4. Try page refresh

## Integration Points

### Consumes
- **MongoDB**: SIGN4L (from EV3NT), CRED3N7IAL
- **H0UND**: Signals via database

### Produces
- **MongoDB**: EV3NT (events), ERR0R (errors)
- **Logs**: Console, file

### Uses
- **Selenium**: Browser automation
- **Chrome**: Game platform
- **RUL3S**: JavaScript injection

## Security Considerations

1. **Password Decryption**: Only in memory, never logged
2. **Credential Locking**: Prevents concurrent use
3. **Session Cleanup**: Always logout
4. **Error Masking**: Don't expose passwords in errors

## Code Examples

### Custom Game Handler
```csharp
public class CustomGameHandler : IGameHandler
{
    public async Task SpinAsync(IWebDriver driver, Signal signal)
    {
        // Custom spin logic
        await driver.FindElement(By.CssSelector(".spin-button")).ClickAsync();
        
        // Custom wait condition
        await new WebDriverWait(driver, TimeSpan.FromSeconds(10))
            .Until(d => d.FindElement(By.CssSelector(".result")).Displayed);
    }
}
```

### Custom Balance Provider
```csharp
public async Task<double> GetCustomBalanceAsync(IWebDriver driver)
{
    // Custom JavaScript for balance extraction
    var script = @"
        var el = document.querySelector('.balance-display');
        return el ? parseFloat(el.textContent.replace('$', '')) : 0;
    ";
    
    return await driver.ExecuteScriptAsync<double>(script);
}
```

---

**Related**: [H0UND Component](../H0UND/) | [Data Models](../../data-models/) | [API Reference](../../api-reference/)
