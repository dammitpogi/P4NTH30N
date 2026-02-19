# Test Execution

## Description
Execute and manage unit and integration tests for P4NTH30N. Run specific tests, analyze failures, and generate coverage reports.

## When to Use
- Before committing code
- After implementing features
- When debugging test failures
- For coverage analysis

## Usage

```markdown
@test-execution
Filter: Category=Unit
```

Or ask Cascade:
"Run tests for the changes I just made"

## Commands

### Run All Tests
```bash
dotnet test UNI7T35T/UNI7T35T.csproj
```

### Run Filtered Tests
```bash
dotnet test --filter "FullyQualifiedName~TestClassName"
dotnet test --filter "Category=Unit"
dotnet test --filter "Priority=High"
```

### Run With Coverage
```bash
dotnet test --collect:"XPlat Code Coverage"
```

### Watch Mode
```bash
dotnet watch test --project ./UNI7T35T/UNI7T35T.csproj
```

## Resources

- test-template.py - Test structure template
- coverage-config.json - Coverage thresholds
- ci-workflow.yaml - CI test configuration

## Test Categories

- **Unit**: Fast, isolated tests
- **Integration**: Database/service tests
- **Slow**: Long-running tests
- **Critical**: Must-pass tests

## Output

Provides:
1. Test run summary
2. Pass/fail counts
3. Failed test details
4. Coverage percentage
5. Recommendations for uncovered code