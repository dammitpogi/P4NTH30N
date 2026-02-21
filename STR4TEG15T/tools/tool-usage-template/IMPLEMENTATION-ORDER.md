# DECISION_062 Implementation Order

## Phase 1: Foundation (Do First)

1. **Create template files** (already created)
   - TOOL-USAGE-TEMPLATE.md
   - agent-prompt-header-template.md
   
2. **Update orchestrator.md** (reference implementation)
   - Already has correct ToolHive Gateway pattern
   - Minor standardization of examples
   - Verify consistency across all examples

3. **Test pattern with simple query**
   - Verify ToolHive Gateway works as documented
   - Confirm `find_tool` → `call_tool` flow
   - Validate error handling

## Phase 2: Primary Agents

4. **strategist.md** (highest impact)
   - Lines 287-315: Fix RAG Integration section
   - Change YAML-style `rag-server.rag_query` to proper ToolHive calls
   - Update mongodb examples to ToolHive pattern

5. **librarian.md** (highest tool usage)
   - Lines 331-405: Fix RAG Integration section
   - Lines 388-405: Fix Tool Usage section
   - Change direct `rag_query()` calls to ToolHive pattern
   - Update web search examples

6. **openfixer.md** (CLI operations)
   - Lines 104-165: Fix all tool call examples
   - Change bash-style `toolhive-mcp-optimizer_call_tool` to JavaScript syntax
   - Update all decision-server examples
   - Update all RAG examples

## Phase 3: Subagents  

7. **designer.md**
   - Lines 88-104: Fix RAG Integration section
   - Lines 319-341: Fix decision tool examples
   - Change bash-style calls to ToolHive pattern

8. **oracle.md**
   - Lines 226-236: Fix platform data queries
   - Lines 257-288: Fix RAG integration examples
   - Lines 296-322: Fix decision tool examples
   - Change direct calls to ToolHive pattern

9. **explorer.md**
   - Lines 28-31: Clarify RAG access through ToolHive
   - Lines 276-315: Fix RAG integration examples
   - Ensure JSON tools are shown through ToolHive

10. **fixer.md**
    - Lines 24-29: Expand ToolHive examples
    - Add concrete `find_tool` → `call_tool` examples
    - Show RAG query and ingest patterns

## Phase 4: Specialist Agents

11. **forgewright.md**
    - Lines 21-26: Verify ToolHive pattern (already correct)
    - Ensure consistency with new template
    - No major changes needed

12. **four_eyes.md**
    - Lines 28-38: Standardize vision tool patterns
    - Show foureyes-mcp tools through ToolHive
    - Update lines 82-87, 210-232: Fix decision tool examples

## Phase 5: Documentation

13. **AGENTS.md troubleshooting section**
    - After line 58: Add ToolHive troubleshooting section
    - Add common error patterns and solutions
    - Reference new templates

14. **Update DECISION_062**
    - Add verification criteria section
    - Document completion status
    - Reference this implementation order

## Dependencies

- **strategist.md** depends on understanding correct pattern
- **librarian.md** is referenced by other agents - must be accurate
- **openfixer.md** shows concrete CLI examples - must match SKILL.md
- **AGENTS.md** should be updated after all agent prompts
- All agents should reference TOOL-USAGE-TEMPLATE.md for detailed examples

## Testing Strategy

After each batch:
1. Verify YAML frontmatter is valid
2. Confirm tool examples match SKILL.md pattern
3. Ensure no direct tool calls remain
4. Run PowerShell verification script
5. Check for consistent terminology

### Verification Checklist Per Agent

- [ ] YAML frontmatter has ToolHive tools enabled
- [ ] All tool examples use `find_tool` → `call_tool` pattern
- [ ] No bash-style syntax (`toolhive-mcp-optimizer_call_tool \\`)
- [ ] No YAML-style syntax (`server.tool:`)
- [ ] No direct function calls (`rag_query()`)
- [ ] All examples use JavaScript/TypeScript syntax
- [ ] Troubleshooting section includes tool failures
- [ ] Examples show both success and fallback patterns

## Rollback Plan

If issues are discovered:
1. Identify which agent has incorrect pattern
2. Revert to previous version if needed
3. Fix template in tool-usage-template
4. Re-apply to affected agents
5. Re-run verification script

## Success Criteria

- All 11 agent prompts use consistent ToolHive Gateway pattern
- PowerShell verification script reports 0 issues
- SKILL.md patterns match agent prompt examples
- No direct tool access shown in any agent
- Clear troubleshooting guidance available

---

**Implementation Order Version**: 1.0 - DECISION_062
