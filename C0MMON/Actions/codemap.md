# C0MMON/Actions/

## Responsibility

C0MMON/Actions provides reusable automation operations for game platform interactions. These actions encapsulate browser automation patterns used across H4ND and other agents, focusing on credential lifecycle management and platform-specific operations.

**Core Functions:**
- **Login**: Authenticate users to game platforms with retry logic
- **Logout**: Clean session termination and resource cleanup  
- **Launch**: Initialize browser drivers and configure automation environment
- **Overwrite**: Update credential data with validation and error handling

## Design

**Key Patterns:**

1. **Static Utility Methods**
   - All actions are static methods for easy reuse across agents
   - Consistent error handling with try/catch and logging
   - Return boolean success indicators for flow control

2. **Browser Abstraction**
   - Selenium WebDriver management (ChromeDriver initialization)
   - JavaScript execution for platform-specific interactions
   - Resource cleanup (driver.Quit()) in finally blocks

3. **Credential Integration**
   - Direct integration with Credential entity validation
   - MongoDB operations via UnitOfWork pattern
   - Error logging to ERR0R collection on failures

4. **Retry Logic**
   - Login attempts with configurable retry counts
   - Network resilience with exponential backoff patterns
   - Extension failure detection via JavaScript execution

## Flow

```
Login Action Flow:
├── Validate credential (IsValid check)
├── Initialize ChromeDriver (Launch action)
├── Navigate to platform URL
├── Execute login sequence (platform-specific)
│   ├── Find username/password elements
│   ├── Input credentials
│   └── Submit form
├── Verify login success (URL or element check)
├── Update credential state
└── Return success/failure

Logout Action Flow:
├── Check if driver is active
├── Navigate to logout or close session
├── Clear cookies/local storage
├── Quit driver (resource cleanup)
└── Return success/failure
```

## Integration

**Dependencies:**
- **Selenium WebDriver**: ChromeDriver for browser automation
- **Credential Entity**: Validation and state management
- **MongoUnitOfWork**: Database operations (Credentials, Errors)
- **Games Namespace**: Platform-specific login/logout implementations

**Used By:**
- **H4ND**: Primary consumer for automation workflows
- **H0UND**: Potential use for balance polling authentication
- **Future Agents**: Reusable automation building blocks

**Error Handling:**
- Validation errors logged via ErrorLog.Create()
- Network failures handled with retry patterns
- Browser crashes detected and recovered gracefully
