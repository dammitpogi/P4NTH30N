# Run Tests

## Description
Execute the full test suite with coverage reporting and quality checks.

## Steps

1. **Pre-Test Validation**
   - Check for uncommitted changes
   - Verify build compiles: `dotnet build P4NTH30N.slnx --no-restore`
   - Run formatter check: `dotnet csharpier check`

2. **Unit Tests**
   - Run all tests: `dotnet test UNI7T35T/UNI7T35T.csproj`
   - Filter by category if specified: `dotnet test --filter "Category=Unit"`
   - Collect code coverage: `dotnet test --collect:"XPlat Code Coverage"`

3. **Integration Tests**
   - Start required services (MongoDB, etc.)
   - Run integration test suite
   - Verify database connections and data integrity

4. **Coverage Analysis**
   - Generate coverage report
   - Identify uncovered code paths
   - Flag coverage below 80% threshold

5. **Post-Test Cleanup**
   - Stop test services
   - Clean up temporary files
   - Generate test summary report

## Example Invocation
```
/run-tests
/run-tests --filter "Category=Unit"
```

## Success Criteria
- All tests pass (exit code 0)
- Code coverage >= 80%
- No new compiler warnings
- Formatter check passes