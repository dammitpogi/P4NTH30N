# PROF3T/drivers/

## Responsibility
Browser driver directory for Selenium WebDriver automation. Contains ChromeDriver executable required for browser-based operations (login testing, balance retrieval via web interfaces).

## Design
- **Content**: `chromedriver.exe` - ChromeDriver executable matching Chrome browser version
- **Purpose**: Enables programmatic browser control for:
  - Visiting gaming platform web interfaces
  - Executing JavaScript to read jackpot/balance values
  - Automating login/logout flows
- **Dependency**: Requires matching Chrome browser version on host machine

## Flow
1. **Launch**: `Actions.Launch()` in PROF3T.cs creates ChromeDriver instance
2. **Navigate**: Driver navigates to platform URLs (FireKirin, OrionStars)
3. **Extract**: JavaScript execution reads `window.parent.Grand`, `Balance`, etc.
4. **Cleanup**: Driver quit after operations complete

## Integration
- **Consumed by**: 
  - `LaunchBrowser()` method in PROF3T.cs
  - Legacy test methods (commented out) for automated gameplay
- **Required by**: Selenium WebDriver in `PROF3T.csproj`
- **Platform**: Windows executable (chromedriver.exe)
