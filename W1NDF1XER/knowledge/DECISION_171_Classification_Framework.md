# DECISION_171 Classification Framework

**Created**: 2026-02-28  
**Purpose**: Clear criteria for classifying files as documentation vs non-documentation

## Documentation Files

### Definition
Files with primary purpose to inform, instruct, or document:

### File Types
**Always Documentation**:
- `.md` - Markdown files
- `.txt` - Plain text files with explanatory content
- `.rst` - reStructuredText files
- Files named: README, INSTALL, CHANGELOG, GUIDE, TUTORIAL, MANUAL

**Conditionally Documentation**:
- `.doc/.docx` - Word documents (assess content)
- `.pdf` - PDF files (assess if text extraction feasible)
- Code files with >30% comment ratio

### Content Indicators
- Explanatory text > 50% of file content
- Step-by-step instructions
- API documentation
- Configuration examples with explanations
- Architectural diagrams or descriptions

## Non-Documentation Files

### File Types
**Always Non-Documentation**:
- Binary executables (`.exe`, `.dll`, `.so`, `.dylib`)
- Compiled libraries
- Build artifacts
- Temporary files (`.tmp`, `.temp`, `.swp`, `.bak`)

**Conditionally Non-Documentation**:
- Configuration files (`.json`, `.yaml`, `.ini`, `.conf`) - assess if contain explanatory comments
- Source code files with <30% comment ratio
- Test data files
- Database files
- Log files

### Content Indicators
- Primarily functional code
- Data structures without explanation
- Configuration values only
- Binary data
- Repetitive machine-generated content

## Conversion Rules

### .txt → .md
- Always convert
- Add basic markdown formatting for headers
- Preserve code blocks with ```
- Convert URLs to markdown links

### .doc/.docx
- Extract text if possible
- Assess complexity:
  - Simple text → convert to .md
  - Complex formatting → preserve original

### PDF Files
- Attempt text extraction
- If successful and content is documentation → convert
- If extraction fails or binary-heavy → archive

### Code Files
- Calculate comment ratio
- If >30% comments and documentation value → preserve
- Otherwise → archive

## Archive Strategy

### Archive Directory Structure
```
refs_archive/
├── manifest.json (inventory of all archived files)
├── original_structure/
│   ├── mongo-master/
│   ├── openclaw/
│   └── ...
└── deleted_after_30_days/
    └── [date-stamped deletions]
```

### Manifest Format
```json
{
  "archived_at": "2026-02-28T08:00:00Z",
  "files": [
    {
      "original_path": "refs/mongo-master/file.exe",
      "archive_path": "refs_archive/original_structure/mongo-master/file.exe",
      "classification": "non-documentation",
      "reason": "Binary executable",
      "size_bytes": 1024000,
      "hash": "sha256:..."
    }
  ]
}
```

## Quality Gates

### Classification Audit
- Sample 10% of classified files
- Verify classification accuracy
- Target: >95% accuracy

### Archive Integrity
- Verify all files moved to archive
- Hash verification of critical files
- Manifest completeness check

### Conversion Quality
- Review 5% of converted files
- Verify formatting preservation
- Target: >90% acceptable conversions
