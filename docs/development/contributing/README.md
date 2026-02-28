# Contributing Guide

Guidelines for contributing to P4NTHE0N.

## Quick Links

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Code Style](#code-style)
- [Pull Request Process](#pull-request-process)
- [Testing Requirements](#testing-requirements)
- [Documentation](#documentation)

## Code of Conduct

### Our Standards

- **Be respectful**: Treat everyone with respect and professionalism
- **Be constructive**: Provide helpful feedback and suggestions
- **Be patient**: Remember that contributors have varying experience levels
- **Be collaborative**: Work together toward the best solution

### Unacceptable Behavior

- Harassment or discrimination of any kind
- Trolling, insulting/derogatory comments
- Personal or political attacks
- Publishing others' private information

## Getting Started

### Prerequisites

1. **Git**: Version control
2. **.NET 10.0 SDK**: Development environment
3. **MongoDB**: Local database for testing
4. **Visual Studio 2022** or **VS Code**: IDE

### Setup Development Environment

```bash
# 1. Fork the repository
# Click "Fork" button on GitHub

# 2. Clone your fork
git clone https://github.com/YOUR_USERNAME/P4NTHE0N.git
cd P4NTHE0N

# 3. Add upstream remote
git remote add upstream https://github.com/original/P4NTHE0N.git

# 4. Setup environment
.\scripts\setup\check-prerequisites.ps1
.\scripts\setup\setup-mongodb.ps1 -StartService

# 5. Build and test
dotnet build P4NTHE0N.slnx
dotnet test UNI7T35T/UNI7T35T.csproj
```

## Development Workflow

### 1. Create a Branch

```bash
# Sync with main
git checkout main
git pull upstream main

# Create feature branch
git checkout -b feature/my-feature-name

# Or for bug fixes
git checkout -b fix/issue-description
```

**Branch Naming:**
- `feature/description` - New features
- `fix/description` - Bug fixes
- `docs/description` - Documentation
- `refactor/description` - Code refactoring

### 2. Make Changes

```bash
# Edit files
# ... make your changes ...

# Check formatting
dotnet csharpier check

# Fix formatting if needed
dotnet csharpier .

# Run tests
dotnet test UNI7T35T/UNI7T35T.csproj

# Build solution
dotnet build P4NTHE0N.slnx
```

### 3. Commit Changes

```bash
# Stage changes
git add .

# Commit with descriptive message
git commit -m "feat: add jackpot detection algorithm

- Implements vision-based jackpot detection
- Adds OCR integration for balance reading
- Includes unit tests for detection logic

Fixes #123"
```

**Commit Message Format:**
```
<type>: <subject>

<body>

<footer>
```

**Types:**
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation
- `style:` Formatting
- `refactor:` Code restructuring
- `test:` Tests
- `chore:` Maintenance

### 4. Push and Create PR

```bash
# Push to your fork
git push origin feature/my-feature-name

# Create Pull Request via GitHub
```

## Code Style

### C# Style Guidelines

```csharp
// Use explicit types (avoid var)
List<string> items = new List<string>();  // ✓ Good
var items = new List<string>();            // ✗ Avoid

// Use predefined types
int count = 0;     // ✓ Good
Int32 count = 0;   // ✗ Avoid

// File-scoped namespaces
namespace P4NTHE0N.C0MMON;  // ✓ Good

// Primary constructors
public class MyClass(IMyService service)  // ✓ Good
{
    private readonly IMyService _service = service;
}

// Expression-bodied members
public int Count => _items.Count;  // ✓ Good

// Pattern matching
if (obj is Credential cred)  // ✓ Good

// Null propagation
var name = credential?.Username;  // ✓ Good
```

### Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Classes | PascalCase | `CredentialManager` |
| Interfaces | PascalCase + I | `ICredentialService` |
| Methods | PascalCase | `GetCredentialAsync` |
| Properties | PascalCase | `UserName` |
| Fields (private) | _camelCase | `_userName` |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| Local variables | camelCase | `userName` |
| Parameters | camelCase | `userName` |

### Formatting Rules

```csharp
// Line endings: CRLF
// Indentation: Tabs (width 4)
// Line length: Max 170 characters
// Braces: Same line (K&R style)

public class Example
{
    public void Method()
    {
        if (condition)
        {
            DoSomething();
        }
    }
}
```

### Documentation Comments

```csharp
/// <summary>
/// Calculates the DPD (Dollars Per Day) for a credential.
/// </summary>
/// <param name="history">Historical jackpot data</param>
/// <param name="minimumPoints">Minimum data points required</param>
/// <returns>DPD value or null if insufficient data</returns>
/// <exception cref="ArgumentNullException">Thrown when history is null</exception>
public double? CalculateDPD(List<Jackpot> history, int minimumPoints = 25)
{
    // Implementation
}
```

## Pull Request Process

### Before Submitting

- [ ] Code builds without errors
- [ ] All tests pass (`dotnet test`)
- [ ] Code formatted (`dotnet csharpier`)
- [ ] New tests added for new functionality
- [ ] Documentation updated
- [ ] No sensitive data committed
- [ ] Commit messages follow format

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests added
- [ ] Integration tests added
- [ ] All tests pass

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes (or documented)

## Related Issues
Fixes #123
```

### Review Process

1. **Automated Checks**
   - Build verification
   - Test execution
   - Code formatting check

2. **Code Review**
   - At least one reviewer approval required
   - Address all comments
   - Resolve conflicts

3. **Merge**
   - Squash and merge
   - Delete branch after merge

## Testing Requirements

### Unit Tests

Required for:
- Business logic
- Calculations
- Validation rules
- Utility functions

```csharp
[Fact]
public void CalculateDPD_WithValidData_ReturnsCorrectValue()
{
    // Arrange
    var service = new ForecastingService();
    var history = CreateTestData();
    
    // Act
    var result = service.CalculateDPD(history);
    
    // Assert
    result.Should().BeApproximately(100.0, 0.1);
}
```

### Integration Tests

Required for:
- Repository operations
- External service calls
- Component interactions

```csharp
[Fact]
public async Task CredentialRepository_SavesAndRetrieves()
{
    // Arrange
    var repo = new CredentialsRepository(_database);
    var credential = MockFactory.CreateCredential();
    
    // Act
    await repo.AddAsync(credential);
    var retrieved = await repo.GetAsync(credential.Id);
    
    // Assert
    retrieved.Should().BeEquivalentTo(credential);
}
```

### Test Coverage Goals

| Component | Minimum Coverage |
|-----------|------------------|
| C0MMON | 80% |
| H0UND | 70% |
| H4ND | 70% |
| W4TCHD0G | 70% |

## Documentation

### Code Documentation

Document:
- Public APIs
- Complex algorithms
- Configuration options
- Error handling

```csharp
/// <summary>
/// Activates the kill switch to immediately halt all automation.
/// </summary>
/// <param name="reason">Reason for activation (logged for audit)</param>
/// <remarks>
/// Once activated, the kill switch can only be deactivated using the override code.
/// All in-progress operations will be gracefully terminated.
/// </remarks>
public void ActivateKillSwitch(string reason)
```

### Documentation Updates

Update when changing:
- Public interfaces
- Configuration options
- Architecture decisions
- API behavior

Update files:
- `docs/api-reference/` - Interface changes
- `docs/data-models/` - Schema changes
- `docs/components/` - Component changes
- `README.md` - User-facing changes

## Architecture Decisions

### When to Create ADR

Create Architecture Decision Record (ADR) for:
- New major dependencies
- Structural changes
- Technology choices
- Design pattern changes

### ADR Template

```markdown
# ADR-XXX: Title

## Status
Proposed / Accepted / Deprecated

## Context
What is the issue we're facing?

## Decision
What decision was made?

## Consequences
Positive and negative impacts

## Alternatives Considered
Other options and why rejected
```

## Security

### Sensitive Data

**NEVER commit:**
- Passwords
- API keys
- Encryption keys
- Connection strings with credentials

**DO:**
- Use environment variables
- Reference secure key storage
- Use configuration templates

```csharp
// ✗ BAD - Hardcoded
var password = "secret123";

// ✓ GOOD - From configuration
var password = _configuration["Database:Password"];
```

### Security Review

Required for changes to:
- Authentication
- Encryption
- Access control
- Input validation

## Performance

### Performance Considerations

- Use async/await for I/O
- Minimize database round trips
- Cache frequently accessed data
- Use efficient algorithms

```csharp
// ✓ GOOD - Async database call
var result = await _repository.GetAsync(id);

// ✗ BAD - Synchronous wait
var result = _repository.GetAsync(id).Result;
```

## Database Changes

### Migration Process

1. Create migration script in `docs/migration/`
2. Test on development database
3. Document breaking changes
4. Include rollback script

### Schema Changes

```javascript
// Migration: add new field
db.CRED3N7IAL.updateMany(
    {},
    { $set: { "NewField": defaultValue } }
);
```

## Release Process

### Version Numbering

Follow Semantic Versioning:
- `MAJOR.MINOR.PATCH`
- Major: Breaking changes
- Minor: New features (backward compatible)
- Patch: Bug fixes

### Release Checklist

- [ ] All tests passing
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Version bumped
- [ ] Tag created
- [ ] Release notes written

## Getting Help

### Resources

- [Documentation Hub](../INDEX.md)
- [API Reference](../../api-reference/)
- [Component Guides](../../components/)
- [Troubleshooting](../../operations/runbooks/TROUBLESHOOTING.md)

### Questions?

- Open an issue for bugs
- Start a discussion for questions
- Tag maintainers for review

## Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Credited in relevant documentation

Thank you for contributing to P4NTHE0N!

---

**Related**: [Testing Guide](../testing/) | [Code Style](code-style.md) | [Documentation Guide](documentation.md)
