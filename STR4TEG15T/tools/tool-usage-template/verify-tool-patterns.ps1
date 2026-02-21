# Verification script for DECISION_062
# Checks that all agent prompts use correct ToolHive patterns

$ErrorActionPreference = "Continue"
$agentsDir = "C:\Users\paulc\.config\opencode\agents"
$errors = @()
$warnings = @()
$passed = @()

Write-Host "DECISION_062 Tool Pattern Verification Script" -ForegroundColor Cyan
Write-Host "================================================`n" -ForegroundColor Cyan

$agents = @(
    "orchestrator.md",
    "strategist.md", 
    "librarian.md",
    "openfixer.md",
    "designer.md",
    "oracle.md",
    "explorer.md",
    "fixer.md",
    "forgewright.md",
    "four_eyes.md"
)

foreach ($agent in $agents) {
    $agentPath = Join-Path $agentsDir $agent
    
    if (-not (Test-Path $agentPath)) {
        $errors += "$agent : File not found at $agentPath"
        continue
    }
    
    Write-Host "Checking $agent..." -NoNewline
    
    $content = Get-Content $agentPath -Raw -ErrorAction SilentlyContinue
    
    if (-not $content) {
        $errors += "$agent : Could not read file content"
        Write-Host " ERROR" -ForegroundColor Red
        continue
    }
    
    $agentErrors = @()
    $agentWarnings = @()
    
    # Check for INCORRECT patterns (ERROR)
    
    # 1. YAML-style server.tool notation
    if ($content -match "rag-server\.rag_query") {
        $agentErrors += "Contains 'rag-server.rag_query' YAML notation (should use toolhive_call_tool)"
    }
    if ($content -match "decisions-server\.findById") {
        $agentErrors += "Contains 'decisions-server.findById' YAML notation (should use toolhive_call_tool)"
    }
    if ($content -match "tavily-mcp\.tavily_search") {
        $agentErrors += "Contains 'tavily-mcp.tavily_search' YAML notation (should use toolhive_call_tool)"
    }
    if ($content -match "p4nth30n-mcp\.get_system_status") {
        $agentErrors += "Contains 'p4nth30n-mcp.get_system_status' YAML notation (should use toolhive_call_tool)"
    }
    
    # 2. Direct function calls
    if ($content -match "(?<![a-zA-Z0-9_-])rag_query\s*\(") {
        $agentErrors += "Contains 'rag_query(' direct call (should use toolhive_call_tool)"
    }
    if ($content -match "(?<![a-zA-Z0-9_-])tavily_search\s*\(") {
        $agentErrors += "Contains 'tavily_search(' direct call (should use toolhive_call_tool)"
    }
    if ($content -match "(?<![a-zA-Z0-9_-])scrape_as_markdown\s*\(") {
        $agentErrors += "Contains 'scrape_as_markdown(' direct call (should use toolhive_call_tool)"
    }
    
    # 3. Bash-style tool calls
    if ($content -match "toolhive-mcp-optimizer_call_tool\s+[a-z-]+") {
        $agentErrors += "Contains bash-style 'toolhive-mcp-optimizer_call_tool' (should use JavaScript toolhive_call_tool)"
    }
    if ($content -match "--arg\s+[a-zA-Z_]+") {
        $agentErrors += "Contains '--arg' bash syntax (should use JavaScript parameters object)"
    }
    
    # 4. websearch/webfetch direct calls (definitely don't exist)
    if ($content -match "(?<![a-zA-Z0-9_-])websearch\s*\(") {
        $agentErrors += "Contains 'websearch(' - this tool does NOT exist (use tavily-mcp via ToolHive)"
    }
    if ($content -match "(?<![a-zA-Z0-9_-])webfetch\s*\(") {
        $agentErrors += "Contains 'webfetch(' - this tool does NOT exist (use brightdata-mcp via ToolHive)"
    }
    
    # Check for REQUIRED patterns (WARNING if missing)
    
    # 5. ToolHive find_tool mention
    if (-not ($content -match "toolhive_find_tool")) {
        $agentWarnings += "Missing 'toolhive_find_tool' documentation"
    }
    
    # 6. ToolHive call_tool mention
    if (-not ($content -match "toolhive_call_tool")) {
        $agentWarnings += "Missing 'toolhive_call_tool' documentation"
    }
    
    # 7. ToolHive in YAML frontmatter
    if (-not ($content -match "toolhive-mcp-optimizer_find_tool:\s*true")) {
        $agentWarnings += "YAML frontmatter missing 'toolhive-mcp-optimizer_find_tool: true'"
    }
    if (-not ($content -match "toolhive-mcp-optimizer_call_tool:\s*true")) {
        $agentWarnings += "YAML frontmatter missing 'toolhive-mcp-optimizer_call_tool: true'"
    }
    
    # 8. ToolHive Gateway explanation
    if (-not ($content -match "ToolHive Gateway" -or $content -match "ToolHive")) {
        $agentWarnings += "Missing 'ToolHive Gateway' explanation"
    }
    
    # 9. Check for JavaScript/TypeScript syntax in examples
    $hasJSSyntax = $content -match "await toolhive_call_tool" -or 
                   $content -match "const result = await" -or
                   $content -match "parameters:\s*\{"
    
    if (-not $hasJSSyntax) {
        $agentWarnings += "No JavaScript/TypeScript syntax found in tool examples"
    }
    
    # Report results
    if ($agentErrors.Count -eq 0 -and $agentWarnings.Count -eq 0) {
        Write-Host " PASS" -ForegroundColor Green
        $passed += $agent
    } elseif ($agentErrors.Count -eq 0) {
        Write-Host " WARNINGS" -ForegroundColor Yellow
        $warnings += @{ Agent = $agent; Issues = $agentWarnings }
    } else {
        Write-Host " FAIL" -ForegroundColor Red
        $errors += @{ Agent = $agent; Issues = $agentErrors }
    }
}

Write-Host "`n================================================" -ForegroundColor Cyan
Write-Host "VERIFICATION RESULTS" -ForegroundColor Cyan
Write-Host "================================================`n" -ForegroundColor Cyan

# Report passed
Write-Host "PASSED ($($passed.Count)/$($agents.Count)):" -ForegroundColor Green
foreach ($agent in $passed) {
    Write-Host "  PASS: $agent" -ForegroundColor Green
}

# Report warnings
if ($warnings.Count -gt 0) {
    Write-Host "`nWARNINGS ($($warnings.Count)/$($agents.Count)):" -ForegroundColor Yellow
    foreach ($warning in $warnings) {
        Write-Host "  WARN: $($warning.Agent)" -ForegroundColor Yellow
        foreach ($issue in $warning.Issues) {
            Write-Host "    - $issue" -ForegroundColor DarkYellow
        }
    }
}

# Report errors
if ($errors.Count -gt 0) {
    Write-Host "`nERRORS ($($errors.Count)/$($agents.Count)):" -ForegroundColor Red
    foreach ($error in $errors) {
        if ($error -is [hashtable]) {
            Write-Host "  FAIL: $($error.Agent)" -ForegroundColor Red
            foreach ($issue in $error.Issues) {
                Write-Host "    - $issue" -ForegroundColor DarkRed
            }
        } else {
            Write-Host "  FAIL: $error" -ForegroundColor Red
        }
    }
}

# Summary
Write-Host "`n================================================" -ForegroundColor Cyan
$totalIssues = $errors.Count + $warnings.Count

if ($errors.Count -eq 0 -and $warnings.Count -eq 0) {
    Write-Host "✅ ALL AGENT PROMPTS USE CORRECT TOOLHIVE PATTERNS" -ForegroundColor Green
    exit 0
} elseif ($errors.Count -eq 0) {
    Write-Host "⚠️  VERIFICATION PASSED WITH WARNINGS" -ForegroundColor Yellow
    Write-Host "   Warnings: $($warnings.Count) agents need attention" -ForegroundColor Yellow
    exit 0
} else {
    Write-Host "❌ VERIFICATION FAILED" -ForegroundColor Red
    Write-Host "   Errors: $($errors.Count) agents have incorrect patterns" -ForegroundColor Red
    if ($warnings.Count -gt 0) {
        Write-Host "   Warnings: $($warnings.Count) agents need attention" -ForegroundColor Yellow
    }
    exit 1
}
