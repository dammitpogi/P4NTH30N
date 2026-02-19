# Decision Implementation

## Description
Implement a Decision from the P4NTH30N decision framework. Follow the decision specifications and update status upon completion.

## Steps

1. **Load Decision Details**
   - Query decision-server for Decision ID
   - Read specifications: title, description, target files
   - Check dependencies - DO NOT proceed if incomplete
   - Verify priority and scope

2. **Analyze Requirements**
   - Review existing code in target files
   - Understand integration points
   - Identify required tests
   - Note any blockers or concerns

3. **Implement Changes**
   - Write code following P4NTH30N conventions
   - Add/update unit tests
   - Update documentation if needed
   - Run formatter: `dotnet csharpier .`

4. **Verification**
   - Build: `dotnet build P4NTH30N.slnx --no-restore`
   - Test: `dotnet test UNI7T35T/UNI7T35T.csproj`
   - Check: `dotnet csharpier check`
   - Validate against Decision requirements

5. **Update Decision Status**
   - Mark Decision as Completed in decision-server
   - Add implementation notes
   - Report completion to Strategist
   - Log any deviations or blockers

## Example Invocation
```
/decision-implementation WIND-001
/decision-implementation INFRA-010 --priority High
```

## Quality Gates
Before marking complete:
- [ ] Code compiles without errors
- [ ] Unit tests pass
- [ ] No new warnings
- [ ] Build succeeds
- [ ] Code matches Decision requirements
- [ ] Decision status updated in server