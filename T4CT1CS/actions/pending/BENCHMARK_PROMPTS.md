# BENCHMARK TASK PROMPTS

## Task 1: Simple Refactor (LOW Complexity)

### SWE-1.5 Prompt

```
BENCHMARK TASK 1 - SIMPLE REFACTOR (SWE-1.5)

Task: Refactor T4CT1CS/Program.cs to use modern C# 12 features

Current code uses traditional property syntax and older patterns.

Requirements:
1. Convert any traditional properties to primary constructor syntax where applicable
2. Use file-scoped namespace (already done - verify)
3. Add null-checking with pattern matching if missing
4. Ensure all existing functionality is preserved

Success Criteria:
- Code compiles: dotnet build T4CT1CS/T4CT1CS.csproj
- No functionality changes
- Uses modern C# patterns

Provide the complete refactored file.
```

### Opus 4.6 Prompt

```
BENCHMARK TASK 1 - SIMPLE REFACTOR (Opus 4.6)

Task: Refactor T4CT1CS/Program.cs to use modern C# 12 features

Current code uses traditional property syntax and older patterns.

Requirements:
1. Convert any traditional properties to primary constructor syntax where applicable
2. Use file-scoped namespace (already done - verify)
3. Add null-checking with pattern matching if missing
4. Ensure all existing functionality is preserved

Success Criteria:
- Code compiles: dotnet build T4CT1CS/T4CT1CS.csproj
- No functionality changes
- Uses modern C# patterns

Provide the complete refactored file.
```

---

## Task 2: Multi-File Feature (MEDIUM Complexity)

### SWE-1.5 Prompt

```
BENCHMARK TASK 2 - MULTI-FILE FEATURE (SWE-1.5)

Task: Add logging interface and implementation to T4CT1CS

Requirements:
1. Create ILogger interface in T4CT1CS/Interfaces/ILogger.cs with:
   - void LogInfo(string message)
   - void LogError(string message, Exception ex)
   - void LogDebug(string message)

2. Create ConsoleLogger implementation in T4CT1CS/Services/ConsoleLogger.cs

3. Update T4CT1CS/Program.cs to:
   - Use ILogger
   - Log startup message
   - Log any errors

Success Criteria:
- All files compile: dotnet build T4NTH30N.slnx
- Interface properly defined
- Implementation follows interface
- Program uses logger correctly

Provide all modified/created files.
```

### Opus 4.6 Prompt

```
BENCHMARK TASK 2 - MULTI-FILE FEATURE (Opus 4.6)

Task: Add logging interface and implementation to T4CT1CS

Requirements:
1. Create ILogger interface in T4CT1CS/Interfaces/ILogger.cs with:
   - void LogInfo(string message)
   - void LogError(string message, Exception ex)
   - void LogDebug(string message)

2. Create ConsoleLogger implementation in T4CT1CS/Services/ConsoleLogger.cs

3. Update T4CT1CS/Program.cs to:
   - Use ILogger
   - Log startup message
   - Log any errors

Success Criteria:
- All files compile: dotnet build T4NTH30N.slnx
- Interface properly defined
- Implementation follows interface
- Program uses logger correctly

Provide all modified/created files.
```

---

## Task 3: Complex Refactoring (HIGH Complexity)

### SWE-1.5 Prompt

```
BENCHMARK TASK 3 - COMPLEX REFACTORING (SWE-1.5)

Task: Refactor T4CT1CS to use dependency injection pattern

Current: Direct instantiation in Program.cs

Requirements:
1. Create IServiceProvider interface
2. Create simple ServiceProvider implementation
3. Refactor existing services to use DI:
   - Register services in composition root
   - Inject dependencies via constructor
   - Remove direct instantiation
4. Update Program.cs to:
   - Configure services
   - Resolve root service
   - Run application

Success Criteria:
- Code compiles: dotnet build T4CT1CS/T4CT1CS.csproj
- Services use constructor injection
- No direct instantiation of services
- Application runs correctly

Provide all modified/created files with explanation of changes.
```

### Opus 4.6 Prompt

```
BENCHMARK TASK 3 - COMPLEX REFACTORING (Opus 4.6)

Task: Refactor T4CT1CS to use dependency injection pattern

Current: Direct instantiation in Program.cs

Requirements:
1. Create IServiceProvider interface
2. Create simple ServiceProvider implementation
3. Refactor existing services to use DI:
   - Register services in composition root
   - Inject dependencies via constructor
   - Remove direct instantiation
4. Update Program.cs to:
   - Configure services
   - Resolve root service
   - Run application

Success Criteria:
- Code compiles: dotnet build T4CT1CS/T4CT1CS.csproj
- Services use constructor injection
- No direct instantiation of services
- Application runs correctly

Provide all modified/created files with explanation of changes.
```

---

## BENCHMARK EXECUTION CHECKLIST

### Run Order (Randomized)
1. ⬜ Task 1 - SWE-1.5 Attempt 1
2. ⬜ Task 1 - Opus 4.6 Attempt 1
3. ⬜ Task 1 - SWE-1.5 Attempt 2
4. ⬜ Task 1 - Opus 4.6 Attempt 2
5. ⬜ Task 2 - SWE-1.5 Attempt 1
6. ⬜ Task 2 - Opus 4.6 Attempt 1
7. ⬜ Task 2 - SWE-1.5 Attempt 2
8. ⬜ Task 2 - Opus 4.6 Attempt 2
9. ⬜ Task 3 - SWE-1.5 Attempt 1
10. ⬜ Task 3 - Opus 4.6 Attempt 1
11. ⬜ Task 3 - SWE-1.5 Attempt 2
12. ⬜ Task 3 - Opus 4.6 Attempt 2

### Metrics to Capture Per Run
- [ ] Start time
- [ ] End time
- [ ] Build result (Pass/Fail)
- [ ] Test result (Pass/Fail)
- [ ] Token usage (if available)
- [ ] Quality rating (1-5)
- [ ] Notes/issues

---

## EXECUTION INSTRUCTIONS

1. Open WindSurf Cascade
2. Select model (SWE-1.5 or Opus 4.6)
3. Copy prompt for appropriate task
4. Record start time
5. Execute prompt
6. Apply changes to codebase
7. Run `dotnet build T4CT1CS/T4CT1CS.csproj`
8. Record build result
9. Record end time
10. Rate quality (1-5)
11. Move to next run

**Estimated Total Time: 2-3 hours**
