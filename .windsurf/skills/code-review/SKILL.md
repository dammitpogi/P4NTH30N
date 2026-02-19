# Code Review

## Description
Perform comprehensive code review following P4NTH30N standards. Check for style compliance, security issues, performance concerns, and architectural alignment.

## When to Use
- Before committing changes
- When reviewing PRs
- For quality assurance
- During refactoring

## Usage

```markdown
@code-review
File: C0MMON/Services/NewService.cs
```

Or ask Cascade:
"Review this code for P4NTH30N compliance"

## Review Checklist

### Style & Formatting
- [ ] Follows C# naming conventions (PascalCase, camelCase, _camelCase)
- [ ] Uses primary constructors where appropriate
- [ ] File-scoped namespaces preferred
- [ ] No `var` (explicit types required)
- [ ] Lines < 170 characters
- [ ] CSharpier formatted

### Security
- [ ] No hardcoded credentials
- [ ] Input validation present
- [ ] SQL injection prevention (parameterized queries)
- [ ] Proper error handling (no stack traces to users)
- [ ] Encryption for sensitive data

### Performance
- [ ] No unnecessary allocations
- [ ] Async/await used correctly
- [ ] Proper disposal of resources
- [ ] Efficient LINQ queries
- [ ] No blocking calls in async methods

### Architecture
- [ ] Follows SOLID principles
- [ ] Interface segregation respected
- [ ] Dependency injection used
- [ ] No circular dependencies
- [ ] Clean Architecture compliance

### Testing
- [ ] Unit tests present
- [ ] Test coverage adequate
- [ ] Edge cases covered
- [ ] Mocks used appropriately

## Resources

- style-guide.md - P4NTH30N coding standards
- security-checklist.md - Security requirements
- review-template.md - Structured review format

## Output

Generates:
1. Summary of findings
2. Critical issues (must fix)
3. Warnings (should fix)
4. Suggestions (nice to have)
5. Approval status