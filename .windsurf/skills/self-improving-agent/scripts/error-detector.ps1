# Self-Improvement Error Detector Hook (Windows PowerShell version)
# Triggers on PostToolUse for Bash to detect command failures
# Reads CLAUDE_TOOL_OUTPUT environment variable

# Check if tool output indicates an error
# CLAUDE_TOOL_OUTPUT contains the result of the tool execution
$OUTPUT = $env:CLAUDE_TOOL_OUTPUT

if (-not $OUTPUT) {
    $OUTPUT = ""
}

# Patterns indicating errors (case-insensitive matching)
$ERROR_PATTERNS = @(
    "error:",
    "Error:", 
    "ERROR:",
    "failed",
    "FAILED",
    "command not found",
    "No such file",
    "Permission denied",
    "fatal:",
    "Exception",
    "Traceback",
    "npm ERR!",
    "ModuleNotFoundError",
    "SyntaxError",
    "TypeError",
    "exit code",
    "non-zero"
)

# Check if output contains any error pattern
$containsError = $false
foreach ($pattern in $ERROR_PATTERNS) {
    if ($OUTPUT -match [regex]::Escape($pattern)) {
        $containsError = $true
        break
    }
}

# Only output reminder if error detected
if ($containsError) {
    Write-Host @"
<error-detected>
A command error was detected. Consider logging this to .learnings/ERRORS.md if:
- The error was unexpected or non-obvious
- It required investigation to resolve
- It might recur in similar contexts
- The solution could benefit future sessions

Use the self-improvement skill format: [ERR-YYYYMMDD-XXX]
</error-detected>
"@
}
