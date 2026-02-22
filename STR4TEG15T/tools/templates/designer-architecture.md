---
agent: designer
type: architecture
decision: DECISION-XXX
created: 2026-02-21T00:00:00Z
updated: 2026-02-21T00:00:00Z
status: draft
tags: [designer, architecture, specification]
priority: high
schemaVer: 1.0.0
---

# Architecture: [System/Feature Name]

**Architecture ID**: ARCH-[YYYYMMDD]-[NNN]  
**Type**: [System|Component|Integration|Refactor]  
**Scope**: [Decision ID or Epic]  
**Date**: [YYYY-MM-DD]  
**Designer**: Aegis  
**Status**: [Draft|Review|Approved|Deprecated]

---

## Executive Summary

[Brief overview of the architecture and key design decisions]

**Approval Rating**: [0-100]%  
**Recommendation**: [Proceed|Proceed with Conditions|Reject]

---

## Design Principles

1. [Principle 1]
2. [Principle 2]
3. [Principle 3]

---

## System Overview

```
[ASCII or text-based diagram showing system components]
```

### Components

| Component | Responsibility | Interface | Dependencies |
|-----------|---------------|-----------|--------------|
| [Name] | [What it does] | [API/Protocol] | [Other components] |

---

## Data Flow

1. [Step 1]
2. [Step 2]
3. [Step 3]

---

## Interface Specifications

### [Interface Name]
- **Type**: [REST|gRPC|Message Queue|File|etc.]
- **Format**: [JSON|Protobuf|etc.]
- **Endpoints/Methods**:
  - `[method] [path]`: [Description]

---

## File Structure

```
[directory]/
  ├── [subdir]/
  │   ├── [file].[ext]
  │   └── [file].[ext]
  └── [file].[ext]
```

---

## Error Handling

| Error Type | Strategy | Recovery |
|------------|----------|----------|
| [Type] | [Strategy] | [Recovery action] |

---

## Performance Considerations

- [Consideration 1]
- [Consideration 2]

---

## Security Considerations

- [Security requirement 1]
- [Security requirement 2]

---

## Migration Path

[If this replaces existing architecture, describe migration steps]

---

*Architecture by Designer*  
*[Date]*
