# Address PR Comments

## Description
Process and address pull request comments systematically. Review each comment, make necessary code changes, verify with tests, and update status.

## Steps

1. **Load PR Comments**
   - Fetch all open PR comments from GitHub API
   - Categorize comments by type: bug, style, architecture, documentation
   - Prioritize by severity and file location

2. **Analyze Each Comment**
   - Read the relevant code sections
   - Understand the context and requirement
   - Determine if the suggestion is valid

3. **Implement Changes**
   - Make code modifications per comment
   - Follow P4NTH30N coding standards (see AGENTS.md)
   - Add or update tests as needed
   - Run formatter: `dotnet csharpier .`

4. **Verify Changes**
   - Build the solution: `dotnet build P4NTH30N.slnx`
   - Run unit tests: `dotnet test UNI7T35T/UNI7T35T.csproj`
   - Check for new warnings or errors

5. **Update PR Status**
   - Mark addressed comments as resolved
   - Add explanatory comments where needed
   - Request re-review if appropriate

## Example Invocation
```
/address-pr-comments
```

## Notes
- Skip comments that are questions or discussions
- Flag architectural concerns for human review
- Maintain backward compatibility unless explicitly requested