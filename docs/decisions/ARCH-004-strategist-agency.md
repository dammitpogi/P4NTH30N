# Strategist Agency Over Implementors Decision
## DECISION: ARCH-004

**Status:** Proposed  
**Category:** Architecture  
**Priority:** Critical  
**Proposed Date:** 2026-02-19  
**Author:** Nexus  
**Parent:** None (Top-level architectural decision)

---

## Executive Summary

Grant Strategist direct agency over three Implementor agents: **WindFixer**, **OpenFixer**, and **Forgewright**. Eliminate prompt-passing through Nexus. Enable direct communication via RAG Context Layer and FileSystems. Each Implementor has a dedicated C# project for tools, unit tests, and automation. Forgewright specializes in bug triage with test-driven fixes.

---

## Oracle Validation Scorecard

| Validation Item | Status | Details |
|-----------------|--------|---------|
| [✓] Clear interfaces defined | YES | IImplementor, IWindFixer, IOpenFixer, IForgewright |
| [✓] Communication paths specified | YES | RAG + FileSystems |
| [✓] Role boundaries defined | YES | 3 Implementors with distinct responsibilities |
| [✓] Fallback mechanism | YES | Nexus override remains available |
| [✓] Observability included | YES | Decision logging + metrics |
| [✓] C# projects specified | YES | W1NDF1X3R, OP3NF1X3R, F0RG3WR1GH7 |
| [✓] Self-learning mechanism | YES | Role evolution via T4CT1CS |

**Predicted Approval:** 90% (Ready for Oracle review)

---

## 1. Current State

### Problem
- Nexus acts as bottleneck for all Implementor communication
- Prompt passing creates latency and context loss
- Strategist lacks direct control over execution agents
- No standardized interface for agent-to-agent communication

### Existing Projects
- `W1NDF1X3R/` - Windows-focused implementation
- `OP3NF1X3R/` - Cross-platform/OpenCode integration
- `F0RG3WR1GH7/` - Bug fixing and test generation

---

## 2. Proposed Architecture

### 2.1 Direct Agency Model

```
┌─────────────────────────────────────────────────────────────────┐
│                    STRATEGIST AGENCY MODEL                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   ┌──────────────┐                                               │
│   │  STRATEGIST  │◄──────────────────────────────────┐         │
│   │              │                                    │         │
│   │  - Decides   │         ┌──────────────┐          │         │
│   │  - Delegates │────────►│     RAG      │──────────┘         │
│   │  - Reviews   │         │   Context    │                    │
│   └──────────────┘         │   Layer      │                    │
│          │                 └──────────────┘                    │
│          │                        ▲                             │
│          │                        │                             │
│          ▼                        │                             │
│   ┌──────────────────────────────────────────────────┐         │
│   │              IMPLEMENTOR POOL                     │         │
│   ├──────────────┬──────────────┬────────────────────┤         │
│   │  W1NDF1X3R   │  OP3NF1X3R   │   F0RG3WR1GH7      │         │
│   │              │              │                    │         │
│   │ Windows      │ Cross-       │ Bug Triage         │         │
│   │ Tools        │ Platform     │ Test-Driven        │         │
│   │ Automation   │ OpenCode     │ Fixes              │         │
│   │              │ Integration  │                    │         │
│   └──────────────┴──────────────┴────────────────────┘         │
│                                                                  │
│   Communication: RAG Context + FileSystem                        │
│   Nexus Role: Override/escalation only                          │
└─────────────────────────────────────────────────────────────────┘
```

### 2.2 Communication Protocol

#### Via RAG Context Layer
```csharp
// Strategist queries RAG for Implementor status
var context = await _ragContext.SearchAsync(
    query: "WindFixer current task status",
    agent: "WindFixer",
    limit: 5
);

// Implementor reports completion to RAG
await _ragContext.IndexAsync(
    content: taskCompletionReport,
    agent: "WindFixer",
    metadata: new { taskId, status, decisionId }
);
```

#### Via FileSystem
```csharp
// Strategist writes task assignment
await File.WriteAllTextAsync(
    $"T4CT1CS/handoffs/windfixer/TASK-{taskId}.md",
    taskSpecification
);

// Implementor writes completion report
await File.WriteAllTextAsync(
    $"T4CT1CS/handoffs/strategist/COMPLETION-{taskId}.md",
    completionReport
);
```

---

## 3. Implementor Specifications

### 3.1 WindFixer (W1NDF1X3R)

**Specialization:** Windows-native implementation, system-level tools, registry manipulation, Windows-specific automation

**Responsibilities:**
- Windows service management
- Registry operations
- PowerShell script generation
- Windows API integration
- Process manipulation
- File system operations (Windows-specific)

**C# Project:** `W1NDF1X3R/W1NDF1X3R.csproj`

**Interface:**
```csharp
public interface IWindFixer : IImplementor
{
    Task<WindowsTaskResult> ExecuteWindowsTaskAsync(WindowsTask task);
    Task<RegistryResult> ModifyRegistryAsync(RegistryOperation operation);
    Task<PowerShellResult> ExecutePowerShellAsync(string script);
    Task<ServiceResult> ManageServiceAsync(ServiceOperation operation);
}
```

**Handoff Directory:** `T4CT1CS/handoffs/windfixer/`

---

### 3.2 OpenFixer (OP3NF1X3R)

**Specialization:** Cross-platform implementation, OpenCode integration, MCP tools, external API integration

**Responsibilities:**
- Cross-platform tooling
- OpenCode agent integration
- MCP server/tool management
- External API integration
- Docker/container operations
- Cloud service integration

**C# Project:** `OP3NF1X3R/OP3NF1X3R.csproj`

**Interface:**
```csharp
public interface IOpenFixer : IImplementor
{
    Task<McpResult> ExecuteMcpToolAsync(string server, string tool, object parameters);
    Task<OpenCodeResult> IntegrateWithOpenCodeAsync(OpenCodeTask task);
    Task<ApiResult> CallExternalApiAsync(ApiRequest request);
    Task<ContainerResult> ManageContainerAsync(ContainerOperation operation);
}
```

**Handoff Directory:** `T4CT1CS/handoffs/openfixer/`

---

### 3.3 Forgewright (F0RG3WR1GH7)

**Specialization:** Bug triage, test-driven development, specialized unit test creation, bug reproduction

**Responsibilities:**
- Bug triage and analysis
- Create unit tests that reproduce bugs
- Ensure bug fixes are complete
- Regression test creation
- Edge case identification
- Test coverage improvement

**C# Project:** `F0RG3WR1GH7/F0RG3WR1GH7.csproj`

**Interface:**
```csharp
public interface IForgewright : IImplementor
{
    Task<BugAnalysis> TriageBugAsync(BugReport bug);
    Task<TestResult> CreateReproductionTestAsync(BugReport bug);
    Task<FixResult> FixBugWithTestsAsync(BugReport bug);
    Task<CoverageResult> AnalyzeTestCoverageAsync(string projectPath);
    Task<RegressionResult> CreateRegressionTestsAsync(FixResult fix);
}
```

**Handoff Directory:** `T4CT1CS/handoffs/forgewright/`

**Unique Process:**
```
1. Receive bug report
2. Create unit test that REPRODUCES the bug
3. Verify test FAILS (confirms bug exists)
4. Implement fix
5. Verify test PASSES (confirms fix works)
6. Create additional edge case tests
7. Report completion with test evidence
```

---

## 4. Base Implementor Interface

```csharp
// C0MMON/Interfaces/IImplementor.cs
namespace P4NTH30N.C0MMON.Interfaces;

public interface IImplementor
{
    string AgentName { get; }
    string HandoffDirectory { get; }
    
    Task<TaskAcknowledgment> AcceptTaskAsync(TaskAssignment task);
    Task<TaskStatus> GetStatusAsync(string taskId);
    Task<TaskResult> CompleteTaskAsync(string taskId, TaskOutput output);
    Task<IEnumerable<TaskSummary>> GetActiveTasksAsync();
    
    // RAG Integration
    Task ReportToRagAsync(string content, Dictionary<string, object> metadata);
    Task<IEnumerable<RagDocument>> QueryRagAsync(string query);
}

public class TaskAssignment
{
    public string TaskId { get; set; } = Guid.NewGuid().ToString();
    public string DecisionId { get; set; }
    public string Description { get; set; }
    public string[] AcceptanceCriteria { get; set; }
    public Priority Priority { get; set; }
    public DateTime? Deadline { get; set; }
    public Dictionary<string, string> Context { get; set; }
}

public enum Priority
{
    Critical,
    High,
    Medium,
    Low
}
```

---

## 5. Strategist Workflow

### 5.1 Task Delegation

```csharp
// Strategist decides which Implementor to use
public class StrategistAgency
{
    private readonly IWindFixer _windFixer;
    private readonly IOpenFixer _openFixer;
    private readonly IForgewright _forgewright;
    private readonly IRagContext _ragContext;
    
    public async Task<TaskResult> DelegateTaskAsync(TaskRequirements requirements)
    {
        IImplementor implementor = requirements switch
        {
            // Bug-related tasks go to Forgewright
            { IsBugFix: true } => _forgewright,
            
            // Windows-specific tasks go to WindFixer
            { Platform: Platform.Windows, RequiresSystemLevel: true } => _windFixer,
            
            // Cross-platform or OpenCode tasks go to OpenFixer
            { Platform: Platform.CrossPlatform } => _openFixer,
            { RequiresOpenCode: true } => _openFixer,
            
            // Default based on task type
            { TaskType: TaskType.WindowsTool } => _windFixer,
            { TaskType: TaskType.Integration } => _openFixer,
            { TaskType: TaskType.BugFix } => _forgewright,
            
            _ => throw new NotSupportedException($"No implementor for {requirements}")
        };
        
        // Create task assignment
        var task = new TaskAssignment
        {
            DecisionId = requirements.DecisionId,
            Description = requirements.Description,
            AcceptanceCriteria = requirements.AcceptanceCriteria,
            Priority = requirements.Priority,
            Deadline = requirements.Deadline,
            Context = requirements.Context
        };
        
        // Write to handoff directory
        var handoffPath = $"{implementor.HandoffDirectory}/TASK-{task.TaskId}.md";
        await WriteTaskToFileAsync(task, handoffPath);
        
        // Index to RAG
        await _ragContext.IndexAsync(
            content: $"Task {task.TaskId} assigned to {implementor.AgentName}",
            agent: "Strategist",
            metadata: new { task.TaskId, implementor.AgentName, requirements.DecisionId }
        );
        
        // Acknowledge
        return await implementor.AcceptTaskAsync(task);
    }
}
```

### 5.2 Decision Matrix

| Task Type | Primary Implementor | Secondary | Escalation |
|-----------|---------------------|-----------|------------|
| Windows registry/service | WindFixer | OpenFixer | Nexus |
| PowerShell automation | WindFixer | Forgewright | Nexus |
| Cross-platform tool | OpenFixer | WindFixer | Nexus |
| MCP tool integration | OpenFixer | WindFixer | Nexus |
| Bug reproduction/fix | Forgewright | WindFixer/OpenFixer | Nexus |
| Unit test creation | Forgewright | Any | Nexus |
| Edge case testing | Forgewright | Any | Nexus |
| Docker/container | OpenFixer | WindFixer | Nexus |
| API integration | OpenFixer | WindFixer | Nexus |

---

## 6. Self-Learning & Role Evolution

### 6.1 T4CT1CS Integration

Each Implementor maintains their own documentation:

```
T4CT1CS/
├── handoffs/
│   ├── windfixer/
│   │   ├── ROLE.md              # Current role definition
│   │   ├── CAPABILITIES.md      # What WindFixer can do
│   │   ├── LEARNED.md           # Lessons learned
│   │   └── TASK-*.md            # Task assignments
│   ├── openfixer/
│   │   ├── ROLE.md
│   │   ├── CAPABILITIES.md
│   │   ├── LEARNED.md
│   │   └── TASK-*.md
│   └── forgewright/
│       ├── ROLE.md
│       ├── CAPABILITIES.md
│       ├── LEARNED.md
│       ├── BUG-PATTERNS.md      # Common bug patterns
│       └── TASK-*.md
```

### 6.2 Role Update Process

```csharp
// Implementor self-updates role based on experience
public async Task EvolveRoleAsync(LearningExperience experience)
{
    // Read current role
    var rolePath = $"{HandoffDirectory}/ROLE.md";
    var currentRole = await File.ReadAllTextAsync(rolePath);
    
    // Analyze what was learned
    var newCapability = ExtractNewCapability(experience);
    var limitation = ExtractLimitation(experience);
    
    // Update role document
    var updatedRole = UpdateRoleDocument(currentRole, newCapability, limitation);
    await File.WriteAllTextAsync(rolePath, updatedRole);
    
    // Log to LEARNED.md
    var learnedEntry = FormatLearnedEntry(experience);
    await File.AppendAllTextAsync($"{HandoffDirectory}/LEARNED.md", learnedEntry);
    
    // Index to RAG for Strategist awareness
    await ReportToRagAsync(
        $"{AgentName} evolved: {newCapability}",
        new { type = "evolution", capability = newCapability }
    );
}
```

---

## 7. Implementation Plan

### Phase 1: Interface Definition (Week 1)

**Deliverable:** All interfaces defined and implemented

**Tasks:**
1. Create `C0MMON/Interfaces/IImplementor.cs`
2. Create `C0MMON/Interfaces/IWindFixer.cs`
3. Create `C0MMON/Interfaces/IOpenFixer.cs`
4. Create `C0MMON/Interfaces/IForgewright.cs`
5. Implement base classes in each project

**Validation:**
```bash
dotnet build W1NDF1X3R/W1NDF1X3R.csproj
dotnet build OP3NF1X3R/OP3NF1X3R.csproj
dotnet build F0RG3WR1GH7/F0RG3WR1GH7.csproj
```

---

### Phase 2: RAG Integration (Week 1-2)

**Deliverable:** Implementors can read/write to RAG Context Layer

**Tasks:**
1. Implement `ReportToRagAsync` in each project
2. Implement `QueryRagAsync` in each project
3. Create RAG document schemas for tasks
4. Test RAG integration

**Validation:**
```bash
# Verify RAG integration
dotnet test UNI7T35T/UNI7T35T.csproj --filter "RagIntegration"
```

---

### Phase 3: FileSystem Handoffs (Week 2)

**Deliverable:** File-based task assignment working

**Tasks:**
1. Create handoff directory structure
2. Implement file watchers for task detection
3. Implement task completion reporting
4. Create task format templates

**Validation:**
```bash
# Test handoff system
dotnet test UNI7T35T/UNI7T35T.csproj --filter "HandoffSystem"
```

---

### Phase 4: Forgewright Specialization (Week 2-3)

**Deliverable:** Forgewright bug triage system operational

**Tasks:**
1. Implement `TriageBugAsync`
2. Implement `CreateReproductionTestAsync`
3. Implement `FixBugWithTestsAsync`
4. Create bug report templates
5. Integrate with existing test framework

**Validation:**
```bash
# Test Forgewright with sample bug
dotnet run --project F0RG3WR1GH7/F0RG3WR1GH7.csproj -- --test-bug
```

---

### Phase 5: Strategist Integration (Week 3)

**Deliverable:** Strategist can delegate to all 3 Implementors

**Tasks:**
1. Create `StrategistAgency` class
2. Implement decision matrix
3. Create task delegation UI/logging
4. Test end-to-end workflow

**Validation:**
```bash
# Full integration test
dotnet test UNI7T35T/UNI7T35T.csproj --filter "StrategistAgency"
```

---

## 8. File Structure

```
P4NTH30N/
├── C0MMON/
│   └── Interfaces/
│       ├── IImplementor.cs
│       ├── IWindFixer.cs
│       ├── IOpenFixer.cs
│       └── IForgewright.cs
│
├── W1NDF1X3R/
│   ├── W1NDF1X3R.csproj
│   ├── Program.cs
│   └── Services/
│       └── WindFixerService.cs
│
├── OP3NF1X3R/
│   ├── OP3NF1X3R.csproj
│   ├── Program.cs
│   └── Services/
│       └── OpenFixerService.cs
│
├── F0RG3WR1GH7/
│   ├── F0RG3WR1GH7.csproj
│   ├── Program.cs
│   └── Services/
│       ├── BugTriageService.cs
│       └── TestGenerationService.cs
│
└── T4CT1CS/
    └── handoffs/
        ├── windfixer/
        │   ├── ROLE.md
        │   ├── CAPABILITIES.md
        │   └── LEARNED.md
        ├── openfixer/
        │   ├── ROLE.md
        │   ├── CAPABILITIES.md
        │   └── LEARNED.md
        └── forgewright/
            ├── ROLE.md
            ├── CAPABILITIES.md
            ├── LEARNED.md
            └── BUG-PATTERNS.md
```

---

## 9. Success Criteria

### Phase 1-2
- [ ] All interfaces compile without errors
- [ ] RAG integration tested
- [ ] Implementors can report status to RAG

### Phase 3-4
- [ ] File-based handoffs working
- [ ] Forgewright creates reproduction tests
- [ ] Bug fixes include test evidence

### Phase 5
- [ ] Strategist delegates tasks successfully
- [ ] Decision matrix routing correct
- [ ] No Nexus bottleneck for standard tasks

---

## 10. Rollback Plan

If direct agency causes issues:

1. **Immediate**: Re-enable Nexus as intermediary
2. **Short-term**: Revert to prompt-passing workflow
3. **Long-term**: Analyze failure mode, redesign interfaces

---

## 11. Approval Decision

**Oracle Review Required:**

This decision fundamentally changes the agent hierarchy:
- Strategist gains direct control over 3 Implementors
- Nexus becomes escalation-only
- Communication via RAG + FileSystems
- Each Implementor has dedicated C# project
- Forgewright specializes in bug triage with TDD

**Recommended Action:** Approve with Phase 1 pilot (interface definition only) before full implementation.

---

## Consultation Log

- 2026-02-19: Decision created by Nexus
- [Pending] Oracle review
- [Pending] Designer interface specification
- [Pending] Fixer implementation

---

## References

- RAG-001: RAG Context Layer
- RAG-002: File Ingestion
- RAG-003: WindSurf Capture (PAUSED)
