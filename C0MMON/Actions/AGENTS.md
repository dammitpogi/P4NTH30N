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

- **Login**: Authenticate users to game platforms (FireKirin, OrionStars)
- **Logout**: Clean session termination and resource cleanup
- **Launch**: Initialize browser drivers and configure automation environment
- **Overwrite**: Update credential data with validation and error handling

## Key Patterns

1. **Static Utility Methods**: Stateless operations for reuse across agents
2. **Browser Abstraction**: Selenium WebDriver management, JavaScript execution
3. **Credential Integration**: Direct integration with Credential entity validation
4. **MongoDB Operations**: Use UnitOfWork pattern, log errors to ERR0R collection

## Dependencies

- Selenium WebDriver (ChromeDriver)
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
