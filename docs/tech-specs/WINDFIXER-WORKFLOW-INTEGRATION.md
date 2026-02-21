# WindSurf Workflow Integration for WindFixer
## Technical Specification

**Status:** Draft  
**Date:** 2026-02-19  
**Purpose:** Enable Strategist to invoke WindFixer via WindSurf Cascade workflows

---

## Key Findings from Research

### WindSurf Workflows
- **Location**: `.windsurf/workflows/` directory in workspace
- **Format**: Markdown files (max 12,000 characters)
- **Invocation**: `/[workflow-name]` slash command in Cascade
- **Features**:
  - Sequential step execution
  - Can call other workflows (`/workflow-1` can call `/workflow-2`)
  - Saved per-workspace (not necessarily git root)

### Cascade Hooks
- **11 hook events** covering agent workflow
- **JSON input** to shell commands
- **Parameters**: `command`, `show_output`, `working_directory`
- **Hooks include**: `pre_user_prompt`, `post_cascade_response`, `post_mcp_tool_use`, etc.

### Limitations
- **No direct API** for external control
- **No CLI** for workflow invocation
- **GUI-only** interaction model
- **Session-based** (conversations auto-delete)

---

## Integration Architecture

### Option 1: File-Based Workflow Trigger (Recommended)

```
┌─────────────────────────────────────────────────────────────────┐
│              WINDFIXER WORKFLOW INTEGRATION                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────┐     ┌──────────────┐     ┌──────────────┐    │
│  │  STRATEGIST  │────▶│  Handoff     │────▶│  FileSystem  │    │
│  │              │     │  File        │     │  Watcher     │    │
│  └──────────────┘     └──────────────┘     └──────────────┘    │
│                                                    │             │
│                                                    ▼             │
│  ┌──────────────┐     ┌──────────────┐     ┌──────────────┐    │
│  │   WindSurf   │◀────│   Workflow   │◀────│  Auto-Open   │    │
│  │   Cascade    │     │   Trigger    │     │  WindSurf    │    │
│  └──────────────┘     └──────────────┘     └──────────────┘    │
│         │                                            ▲          │
│         │                                            │          │
│         ▼                                            │          │
│  ┌──────────────┐     ┌──────────────┐              │          │
│  │  WindFixer   │────▶│  Cascade     │──────────────┘          │
│  │  Workflow    │     │  Response    │                         │
│  └──────────────┘     └──────────────┘                         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Workflow File Structure

```markdown
# .windsurf/workflows/windfixer.md

name: WindFixer
description: Execute Windows-specific implementation tasks

---

# WindFixer Task Execution

You are WindFixer, a Windows implementation specialist.

## Task Input

Read the task specification from: `T4CT1CS/handoffs/windfixer/TASK-{taskId}.md`

## Your Responsibilities

1. Read and understand the task
2. Implement Windows-specific solution
3. Create/modify C# code in W1NDF1X3R project
4. Write unit tests
5. Report completion to T4CT1CS/handoffs/strategist/COMPLETION-{taskId}.md

## Execution Steps

1. Read task file
2. Analyze requirements
3. Implement solution
4. Test locally
5. Write completion report

## Output Format

Write completion report with:
- Task summary
- Files modified
- Tests created
- Any issues encountered
```

---

## Implementation

### 1. Create Workflow File

**File**: `.windsurf/workflows/windfixer.md`

```markdown
# WindFixer

name: WindFixer

description: Execute Windows-specific implementation tasks via Strategist delegation

---

# WindFixer Implementation Protocol

## Role
You are WindFixer, a Windows-native implementation specialist within the P4NTH30N system.

## Task Acquisition

1. Check for pending tasks in `T4CT1CS/handoffs/windfixer/`
2. Read the most recent `TASK-*.md` file
3. Extract: TaskId, DecisionId, Description, AcceptanceCriteria

## Implementation Standards

### Code Quality
- Follow C# conventions in P4NTH30N
- Use primary constructors where appropriate
- Add XML documentation for public APIs
- Maintain null safety

### Testing
- Create unit tests for all new functionality
- Use xUnit framework
- Aim for >80% coverage
- Include edge cases

### Windows-Specific
- Use Windows APIs via P/Invoke when needed
- Handle registry operations safely
- Manage services with proper error handling
- Use PowerShell for automation scripts

## Output

Write completion to: `T4CT1CS/handoffs/strategist/COMPLETION-{TaskId}.md`

Include:
- Summary of work completed
- Files created/modified
- Test results
- Any blockers or issues
```

### 2. C# Integration Service

**File**: `W1NDF1X3R/Services/WindFixerWorkflowService.cs`

```csharp
using System;
using System.IO;
using System.Threading.Tasks;
using P4NTH30N.C0MMON.Interfaces;

namespace W1NDF1X3R.Services;

public class WindFixerWorkflowService : IWindFixer
{
    private readonly string _handoffDirectory;
    private readonly string _workflowPath;
    
    public string AgentName => "WindFixer";
    public string HandoffDirectory => _handoffDirectory;
    
    public WindFixerWorkflowService()
    {
        _handoffDirectory = Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.UserProfile),
            "P4NTH30N", "T4CT1CS", "handoffs", "windfixer"
        );
        _workflowPath = Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.UserProfile),
            "P4NTH30N", ".windsurf", "workflows", "windfixer.md"
        );
    }
    
    public async Task<TaskAcknowledgment> AcceptTaskAsync(TaskAssignment task)
    {
        // Write task to handoff directory
        var taskFile = Path.Combine(_handoffDirectory, $"TASK-{task.TaskId}.md");
        var content = FormatTaskAsMarkdown(task);
        await File.WriteAllTextAsync(taskFile, content);
        
        // Ensure workflow exists
        await EnsureWorkflowExistsAsync();
        
        // Trigger WindSurf (via file watcher or manual)
        await TriggerWindSurfAsync();
        
        return new TaskAcknowledgment
        {
            TaskId = task.TaskId,
            Accepted = true,
            EstimatedCompletion = DateTime.Now.AddHours(1)
        };
    }
    
    private string FormatTaskAsMarkdown(TaskAssignment task)
    {
        return $"""# Task {task.TaskId}

**Decision:** {task.DecisionId}  
**Priority:** {task.Priority}  
**Assigned:** {DateTime.Now:yyyy-MM-dd HH:mm:ss}

## Description

{task.Description}

## Acceptance Criteria

{string.Join("\n", task.AcceptanceCriteria.Select(c => $"- [ ] {c}"))}

## Context

```json
{System.Text.Json.JsonSerializer.Serialize(task.Context)}
```

---

*This task is ready for WindFixer execution via /windfixer workflow*
""";
    }
    
    private async Task EnsureWorkflowExistsAsync()
    {
        if (File.Exists(_workflowPath)) return;
        
        Directory.CreateDirectory(Path.GetDirectoryName(_workflowPath)!);
        
        var workflowContent = await File.ReadAllTextAsync(
            "Templates/windfixer-workflow.md"
        );
        
        await File.WriteAllTextAsync(_workflowPath, workflowContent);
    }
    
    private async Task TriggerWindSurfAsync()
    {
        // Option 1: Use Windows APIs to bring WindSurf to foreground
        // Option 2: Write trigger file that WindSurf extension watches
        // Option 3: Manual notification to user
        
        // For now, write a trigger file
        var triggerFile = Path.Combine(_handoffDirectory, ".trigger");
        await File.WriteAllTextAsync(triggerFile, 
            $"Trigger WindFixer workflow: /windfixer\nCreated: {DateTime.Now}");
    }
    
    public async Task<TaskStatus> GetStatusAsync(string taskId)
    {
        // Check for completion file
        var completionFile = Path.Combine(
            Path.GetDirectoryName(_handoffDirectory)!,
            "strategist",
            $"COMPLETION-{taskId}.md"
        );
        
        if (File.Exists(completionFile))
        {
            var content = await File.ReadAllTextAsync(completionFile);
            return new TaskStatus
            {
                TaskId = taskId,
                State = TaskState.Completed,
                CompletionReport = content
            };
        }
        
        // Check if task file still exists (not picked up yet)
        var taskFile = Path.Combine(_handoffDirectory, $"TASK-{taskId}.md");
        if (File.Exists(taskFile))
        {
            return new TaskStatus
            {
                TaskId = taskId,
                State = TaskState.Pending
            };
        }
        
        return new TaskStatus
        {
            TaskId = taskId,
            State = TaskState.InProgress
        };
    }
    
    // ... other interface implementations
}
```

### 3. Auto-Trigger Mechanism

**File**: `W1NDF1X3R/Services/WindSurfAutoLauncher.cs`

```csharp
using System;
using System.Diagnostics;
using System.IO;
using System.Threading;
using System.Threading.Tasks;

namespace W1NDF1X3R.Services;

public class WindSurfAutoLauncher : IDisposable
{
    private readonly FileSystemWatcher _watcher;
    private readonly string _windsurfPath;
    
    public WindSurfAutoLauncher()
    {
        var handoffDir = Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.UserProfile),
            "P4NTH30N", "T4CT1CS", "handoffs", "windfixer"
        );
        
        _watcher = new FileSystemWatcher(handoffDir, "TASK-*.md")
        {
            NotifyFilter = NotifyFilters.FileName | NotifyFilters.CreationTime
        };
        
        _watcher.Created += OnTaskFileCreated;
        
        _windsurfPath = FindWindSurfExecutable();
    }
    
    public void Start() => _watcher.EnableRaisingEvents = true;
    public void Stop() => _watcher.EnableRaisingEvents = false;
    
    private void OnTaskFileCreated(object sender, FileSystemEventArgs e)
    {
        // Wait a moment for file to be fully written
        Thread.Sleep(500);
        
        // Launch or bring WindSurf to foreground
        LaunchWindSurf();
        
        // Optionally: Use Windows APIs to send /windfixer command
        // This would require UI automation (more complex)
    }
    
    private void LaunchWindSurf()
    {
        if (string.IsNullOrEmpty(_windsurfPath))
        {
            Console.WriteLine("WindSurf not found. Please open manually and run /windfixer");
            return;
        }
        
        // Check if already running
        var processes = Process.GetProcessesByName("Windsurf");
        if (processes.Length > 0)
        {
            // Bring to foreground
            BringToForeground(processes[0].MainWindowHandle);
        }
        else
        {
            // Launch new instance
            Process.Start(new ProcessStartInfo
            {
                FileName = _windsurfPath,
                Arguments = "--new-window",
                UseShellExecute = true
            });
        }
    }
    
    private string FindWindSurfExecutable()
    {
        // Common installation paths
        var paths = new[]
        {
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), 
                "Programs", "Windsurf", "Windsurf.exe"),
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles), 
                "Windsurf", "Windsurf.exe"),
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86), 
                "Windsurf", "Windsurf.exe"),
        };
        
        foreach (var path in paths)
        {
            if (File.Exists(path)) return path;
        }
        
        return null!;
    }
    
    private void BringToForeground(IntPtr handle)
    {
        // Windows API to bring window to foreground
        // Requires P/Invoke to user32.dll
        // SetForegroundWindow(handle);
    }
    
    public void Dispose() => _watcher?.Dispose();
}
```

---

## Alternative: Cascade Hooks Integration

If we need deeper integration, use Cascade Hooks:

**File**: `~/.codeium/windsurf/hooks/windfixer-hook.json`

```json
{
  "pre_user_prompt": [
    {
      "command": "powershell.exe -File C:\\P4NTH30N\\W1NDF1X3R\\hooks\\check-for-tasks.ps1",
      "show_output": false
    }
  ]
}
```

**File**: `W1NDF1X3R/hooks/check-for-tasks.ps1`

```powershell
# Check if there are pending WindFixer tasks
$taskDir = "$env:USERPROFILE\P4NTH30N\T4CT1CS\handoffs\windfixer"
$tasks = Get-ChildItem -Path $taskDir -Filter "TASK-*.md" -ErrorAction SilentlyContinue

if ($tasks.Count -gt 0) {
    $mostRecent = $tasks | Sort-Object CreationTime -Descending | Select-Object -First 1
    Write-Host "WINDFIXER_TASK_PENDING:$($mostRecent.Name)"
}
```

---

## Usage Flow

### 1. Strategist Delegates Task

```csharp
var windFixer = new WindFixerWorkflowService();
var task = new TaskAssignment
{
    DecisionId = "ARCH-004",
    Description = "Implement Windows service manager",
    AcceptanceCriteria = new[] {
        "Can start/stop services",
        "Handles errors gracefully",
        "Has unit tests"
    },
    Priority = Priority.High
};

await windFixer.AcceptTaskAsync(task);
```

### 2. System Response

1. Task written to `T4CT1CS/handoffs/windfixer/TASK-{id}.md`
2. Workflow file ensured in `.windsurf/workflows/windfixer.md`
3. WindSurf launched/brought to foreground
4. Trigger file created with instructions

### 3. User Action Required

User sees notification/opens WindSurf and runs:
```
/windfixer
```

### 4. WindFixer Executes

1. Reads task from handoff directory
2. Implements solution in W1NDF1X3R project
3. Creates unit tests
4. Writes completion report
5. Reports to RAG Context Layer

### 5. Strategist Monitors

```csharp
var status = await windFixer.GetStatusAsync(taskId);
if (status.State == TaskState.Completed)
{
    var report = status.CompletionReport;
    // Review and approve
}
```

---

## Pros and Cons

### Pros
- ✅ Uses WindSurf's native workflow system
- ✅ No API required
- ✅ Leverages Cascade's capabilities
- ✅ File-based = reliable
- ✅ Can use other WindSurf features (MCP, web search, etc.)

### Cons
- ❌ Requires manual `/windfixer` invocation (no fully automated trigger)
- ❌ WindSurf must be installed and running
- ❌ User must be present to trigger workflow
- ❌ No direct programmatic control

---

## Future Enhancements

1. **UI Automation**: Use Windows APIs to automatically type `/windfixer`
2. **Extension**: Create WindSurf extension for automatic workflow triggering
3. **MCP Server**: Expose WindFixer as MCP tool for other agents
4. **GitHub Actions**: Trigger WindFixer via CI/CD for automated tasks

---

## Files to Create

1. `.windsurf/workflows/windfixer.md` - Workflow definition
2. `W1NDF1X3R/Services/WindFixerWorkflowService.cs` - Integration service
3. `W1NDF1X3R/Services/WindSurfAutoLauncher.cs` - Auto-launch helper
4. `W1NDF1X3R/Templates/windfixer-workflow.md` - Workflow template
5. `W1NDF1X3R/hooks/check-for-tasks.ps1` - Cascade hook (optional)

---

## Next Steps

1. Create workflow file in P4NTH30N repo
2. Implement WindFixerWorkflowService
3. Test manual workflow invocation
4. Add auto-launcher
5. Document for Strategist use
