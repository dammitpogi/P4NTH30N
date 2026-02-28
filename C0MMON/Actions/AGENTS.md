# C0MMON/Actions

## Responsibility

Provides reusable automation operations for game platform interactions. These actions encapsulate browser automation patterns used across H4ND and other agents, focusing on credential lifecycle management and platform-specific operations.

## When Working Here

- **Keep actions stateless**: All actions are static methods for easy reuse
- **Consistent error handling**: Use try/catch with logging, return boolean success indicators
- **Resource cleanup**: Always use finally blocks for driver.Quit()
- **Validate credentials**: Check IsValid before any automation operations
- **Retry logic**: Implement configurable retry counts with exponential backoff

## Core Actions

| Action | File | Description |
|--------|------|-------------|
| **Launch** | `Launch.cs` | Initializes browser and loads RUL3S Chrome extension (now CDP-compatible) |
| **Login** | `Login.cs` | Extension method for platform authentication (supports both Selenium and CDP) |
| **Logout** | `Logout.cs` | Static method for session termination and resource cleanup |
| **Overwrite** | `Overwrite.cs` | Contains Launch_v2() for alternate browser launch with DevTools |

## Chrome Extension Loading (Actions.Launch)

The `Launch()` method initializes ChromeDriver and loads the RUL3S Chrome extension for browser manipulation:

```csharp
public static ChromeDriver Launch()
{
    ChromeOptions options = new();
    ChromeDriverService service = ChromeDriverService.CreateDefaultService();
    // ... setup ...
    
    // Navigate to extensions page and load RUL3S via Mouse/Keyboard simulation
    driver.Navigate().GoToUrl("chrome://extensions/");
    Mouse.Click(1030, 180);  // Enable developer mode
    Mouse.Click(100, 230);   // Click load unpacked
    // ... input extension path via Keyboard ...
    return driver;
}
```

**Key Points:**
- Uses `WindowsInput` library for Mouse and Keyboard simulation
- Coordinates clicks at specific screen positions for Chrome UI automation
- Loads extension from `C:\OneDrive\P4NTHE0N\RUL3S\auto-override`
- Loads resource override rules from `C:\OneDrive\P4NTHE0N\RUL3S\resource_override_rules.json`

## Input Simulation

All actions use `WindowsInput` library for cross-platform input simulation:

```csharp
using WindowsInput;

// Mouse operations
Mouse.Click(x, y);
Mouse.RtClick(x, y);  // Right-click
Mouse.Move(x, y);

// Keyboard operations
Keyboard.Send("text").Enter();
Keyboard.PressPageDown().PageDown();
Keyboard.DevTools();  // Opens Chrome DevTools
```

## Key Patterns

1. **Static Partial Class**: All actions are in `public static partial class Actions`
2. **Extension Methods**: Login is an extension method on `ChromeDriver`
3. **Browser Abstraction**: Selenium WebDriver management, JavaScript execution
4. **Credential Integration**: Direct integration with Credential entity validation
5. **MongoDB Operations**: Use UnitOfWork pattern, log errors to ERR0R collection

## Dependencies

- Selenium WebDriver (ChromeDriver)
- WindowsInput (Mouse/Keyboard simulation)
- Credential entity validation
- MongoUnitOfWork for database operations
- Games namespace for platform-specific implementations

## Error Handling

- Validation errors logged via ErrorLog.Create()
- Network failures handled with retry patterns
- Browser crashes detected and recovered gracefully
- Line numbers logged for debugging using StackTrace

## Used By

- H4ND (primary consumer for automation workflows)
- H0UND (potential use for balance polling authentication)
- Future agents (reusable automation building blocks)
