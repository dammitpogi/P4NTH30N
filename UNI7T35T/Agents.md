# UNI7T35T

## Responsibility

Unit testing project for P4NTHE0N. Contains automated tests for validating core functionality, preventing regressions, and ensuring code quality.

## When Working Here

- **Test coverage**: Aim for high coverage of critical paths
- **Isolation**: Tests should not depend on external systems
- **Naming**: Clear test names describing behavior
- **Arrange-Act-Assert**: Structure tests clearly
- **Mocks**: Use mocks for external dependencies

## Test Structure

- **Program.cs**: Test runner entry point

## Test Categories

### Unit Tests
- Entity validation tests
- Business logic tests
- Helper method tests

### Integration Tests
- Database operation tests
- Service integration tests
- Workflow validation tests

### Edge Cases
- Null handling
- Boundary values
- Error conditions
- Concurrent access

### New Test Files (2026-02-19)
- **CircuitBreakerTests.cs**: Circuit breaker pattern testing
- **DpdCalculatorTests.cs**: DPD calculation validation
- **EncryptionServiceTests.cs**: Encryption/decryption testing
- **ContextWindowDiscovery.cs**: Model context window testing
- **ConfigValidationBenchmark.cs**: Configuration validation performance

## Running Tests

```bash
# Run all tests
dotnet test UNI7T35T/UNI7T35T.csproj

# Run with coverage
dotnet test UNI7T35T/UNI7T35T.csproj --collect:"XPlat Code Coverage"

# Run specific test
dotnet test UNI7T35T/UNI7T35T.csproj --filter "FullyQualifiedName~TestClassName"

# Watch mode for development
dotnet watch test --project ./UNI7T35T/UNI7T35T.csproj
```

## Test Patterns

```csharp
[Test]
public void Credential_Validation_RejectsNegativeBalance()
{
    // Arrange
    var credential = new Credential { Balance = -100 };
    
    // Act
    bool isValid = credential.IsValid();
    
    // Assert
    Assert.IsFalse(isValid);
}
```

## Dependencies

- NUnit/xUnit: Testing frameworks
- Moq: Mocking library
- C0MMON: Entities and interfaces under test
- MongoDB.Driver: For integration test setup

## CI Integration

Tests run automatically on:
- Pull request creation
- Merge to main branch
- Release builds

## Coverage Goals

- Core entities: >90%
- Infrastructure: >80%
- Integration points: >70%

## Adding Tests

1. Create test class mirroring target class structure
2. Use descriptive test names
3. Group related tests in regions
4. Include negative test cases
5. Document complex setup
