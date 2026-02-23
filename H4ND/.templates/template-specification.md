# H4ND Template System Specification

## Overview

The H4ND template system provides standardized templates for creating directory-specific AGENTS.md documentation files. This ensures consistency across all H4ND subdirectories and maintains the established documentation standards.

## Template Structure

### File Locations
- **Template**: `H4ND/.templates/AGENTS-template.md`
- **Validator**: `H4ND/.templates/validate-codemaps.ps1`
- **Specification**: `H4ND/.templates/template-specification.md`
- **Git Ignore**: `H4ND/.templates/.gitignore`

### Template Placeholders

The template uses the following placeholders that must be replaced with directory-specific content:

#### Required Sections
- `{{DIRECTORY_NAME}}` - Name of the directory (e.g., H0UND, H4ND, C0MMON)
- `{{RESPONSIBILITY_DESCRIPTION}}` - Brief description of the directory's responsibility
- `{{KEY_CONCEPTS_LIST}}` - List of key architectural concepts and patterns
- `{{CORE_FUNCTIONS_LIST}}` - List of core functions and capabilities
- `{{MAIN_LOOP_DIAGRAM_OR_DESCRIPTION}}` - ASCII diagram or description of main processing flow
- `{{KEY_PATTERNS_LIST}}` - List of architectural patterns and design principles
- `{{COMMON_DEPENDENCIES_LIST}}` - Dependencies from C0MMON namespace
- `{{DIRECTORY_DEPENDENCIES_LIST}}` - Directory-specific infrastructure dependencies
- `{{EXTERNAL_DEPENDENCIES_LIST}}` - External dependencies and tools
- `{{DATA_COLLECTIONS_LIST}}` - MongoDB collections and their purposes
- `{{PLATFORM_SUPPORT_LIST}}` - Supported platforms and their characteristics
- `{{RECENT_UPDATES_SECTION}}` - Recent updates and changes
- `{{INFRASTRUCTURE_COMPONENTS_SECTION}}` - Infrastructure components
- `{{NEW_COMPONENTS_SECTION}}` - New additions to the directory
- `{{RECENT_MODIFICATIONS_SECTION}}` - Recent code modifications
- `{{CURRENT_DATE}}` - Current date in YYYY-MM-DD format

### Required Sections (Template Validation)

All template-based AGENTS.md files must include the following sections:

1. **Responsibility** - Clear description of the directory's purpose
2. **When Working Here** - Key architectural concepts and patterns
3. **Core Functions** - Primary functions and capabilities
4. **Key Patterns** - Design patterns and principles used
5. **Dependencies** - C0MMON, directory-specific, and external dependencies
6. **Data Collections** - MongoDB collections and their purposes

## Validation Script

### Usage

```powershell
# Basic validation
.\validate-codemaps.ps1

# Validation with verbose output
.\validate-codemaps.ps1 -Verbose

# Validation from specific root path
.\validate-codemaps.ps1 -RootPath "C:\path\to\directory"
```

### Validation Criteria

The validation script checks for:

1. **Required Sections**: Validates all template-required sections are present
2. **Template Placeholders**: Ensures no template placeholders remain
3. **Formatting Consistency**: Checks for proper 2-space indentation
4. **Content Completeness**: Validates documentation completeness

### Exit Codes

- `0`: All files are valid
- `1`: One or more files have validation errors

## Template Usage Guidelines

### Creating a New Directory Documentation

1. **Copy the Template**:
   ```bash
   cp H4ND/.templates/AGENTS-template.md H4ND/{{DIRECTORY_NAME}}/AGENTS.md
   ```

2. **Replace Placeholders**:
   - Replace all `{{PLACEHOLDER}}` values with directory-specific content
   - Use consistent formatting with 2-space indentation
   - Maintain ASCII diagrams where appropriate

3. **Validate the Documentation**:
   ```powershell
   .\validate-codemaps.ps1
   ```

### Formatting Standards

- **Indentation**: Use 2 spaces for all indentation
- **Headings**: Use `##` for section headers
- **Lists**: Use bullet points (`-`) for unordered lists
- **Code Blocks**: Use triple backticks for code blocks and diagrams
- **Links**: Use relative paths for internal links

### Content Guidelines

1. **Be Specific**: Replace placeholders with concrete, directory-specific information
2. **Keep Updated**: Regularly update the Recent Updates section
3. **Include Dependencies**: List all dependencies from C0MMON and other namespaces
4. **Document Collections**: Clearly describe all MongoDB collections
5. **Maintain Consistency**: Follow the established documentation style

## Integration with Development Workflow

### Pre-commit Validation
The validation script should be integrated into the pre-commit workflow to ensure documentation quality:

```powershell
# Example pre-commit hook
.\H4ND\.templates\validate-codemaps.ps1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Documentation validation failed. Please fix issues before committing." -ForegroundColor Red
    exit 1
}
```

### Code Review Checklist
When reviewing directory documentation:

1. [ ] All template placeholders replaced
2. [ ] Required sections present and complete
3. [ ] Formatting consistent (2-space indentation)
4. [ ] Dependencies accurately listed
5. [ ] Collections properly documented
6. [ ] Recent updates section current

## Troubleshooting

### Common Issues

1. **Missing Sections**:
   - Check that all required sections are included
   - Verify section headers use exact formatting (`## Section Name`)

2. **Template Placeholders Remaining**:
   - Search for `{{` and `}}` in the file
   - Replace all occurrences with directory-specific content

3. **Formatting Issues**:
   - Check for consistent 2-space indentation
   - Ensure no tabs are used for indentation

4. **Validation Script Errors**:
   - Verify PowerShell execution policy allows script execution
   - Check that the script has read access to all AGENTS.md files

## Future Enhancements

Planned improvements to the template system:

1. **Automated Template Generation**: Script to create new directory documentation from template
2. **Enhanced Validation**: More sophisticated link validation and cross-reference checking
3. **Template Variants**: Support for different directory types (core, infrastructure, utilities)
4. **Integration with Documentation Generators**: Automatic generation of unified documentation

## Version History

- **v1.0**: Initial template system with basic validation
- **v1.1**: Enhanced validation criteria and documentation guidelines
- **v1.2**: Added troubleshooting and future enhancements sections