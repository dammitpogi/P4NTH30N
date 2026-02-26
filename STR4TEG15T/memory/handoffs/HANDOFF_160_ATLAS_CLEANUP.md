# ATLAS CLEANUP HANDOFF CONTRACT

**Decision:** DECISION_160_ATLAS_CLEANUP_SLUG_REMOVAL  
**Target:** C:\P4NTH30N\Atlas\  
**Handoff Date:** 2026-02-26  
**Assigned To:** @openfixer (text processing and JSON editing)  
**Priority:** High  
**Estimated Effort:** 4-6 hours

---

## EXECUTIVE SUMMARY

Clean up 4 files in Atlas directory by removing all slug/referencing systems, eliminating cryptic abbreviations (R4K, UVK), reorganizing content, and updating versioning to Base36 two-digit system.

**Files Modified:**
1. CANON_Atlas_Old_Testsment.txt
2. FORGE_Operations_Ledger_v0058_verified.json
3. VAULT_Oath_Archive_v0058_verified.json
4. OpenAI.txt (minimal changes)

**Backups Created:** All originals saved to C:\P4NTH30N\Atlas\archive\

---

## SPECIFIC REQUIREMENTS

### 1. Remove All Slug/Referencing Systems

**REMOVE COMPLETELY:**
- All `[§‡:XX]` notation (e.g., `[§‡:0G]`, `[§‡:8O]`)
- All `ŧ§:XX` inline references (e.g., `ŧ§:P9A`)
- All `slug` fields in JSON
- All `slugRef` objects
- All `canonRefs` arrays with slug references
- Section ID cross-references between documents

**JSON CHANGES:**
```json
// REMOVE these structures:
{ "slug": "8O" }
{ "slugRef": { "type": "canonSlug", "id": "8O" } }
{ "canonRefs": [ { "type": "canonSlug", "id": "XX" } ] }

// KEEP the data, just remove the referencing:
{ "sectionName": "Governance" }  // Use readable names instead
```

### 2. Remove R4K References (Rewrite Sentences)

**Current:**
- Line 23: "Untrusted for R4K: prior chat not reflected..."
- Line 26: "Trusted R4K only from Nexus-provided..."
- Line 50: "Any discrepancy is an R4K fault; re-send the bundle."

**Replace with:**
- Line 23: "Untrusted sources: prior chat not reflected..."
- Line 26: "Trusted sources come only from Nexus-provided..."
- Line 50: "Any discrepancy is a data integrity fault; re-send the bundle."

**FIND AND REWRITE ALL:**
- "R4K" → Remove entirely, rewrite sentences to convey same meaning
- "R4K merge" → "merge records" or "consolidate data"
- "R4K bias" → "prefer complete records" or similar

### 3. Remove UVK References (Rewrite Sentences)

**FIND AND REWRITE ALL:**
- "UVK outputs" → "verified evidence outputs" or just "evidence outputs"
- "UVK pipeline" → "evidence processing pipeline"
- "UVK bundle" → "evidence bundle"
- "UVK standards" → "evidence standards"

### 4. B36.2UC Treatment

**Current usage:**
- Line 80: "identities: canonical typed registry with B36.2UC IDs; IDs < 0A are reserved."

**Replace with:**
- "identities: canonical typed registry with Base36 IDs (2 uppercase characters); IDs 00-09 are reserved."

**JSON files:**
- Remove all `B36.2UC` type annotations
- Just use the IDs directly as string values
- Example: `"id": "D5"` (no type field needed)

### 5. Keep CU as "Conversation Unit"

**DO NOT CHANGE:**
- Line 4: "Rosebud (CU-scoped analysis..." - KEEP AS IS
- All other "CU" references - these are correct

### 6. Reorganize and Deduplicate

**CANON_Atlas_Old_Testsment.txt:**
- File has ~1366 lines with significant duplication
- Lines 223-400: Repeated Trust & Authority section
- Lines 513-560: Another repeat
- **ACTION:** Consolidate to single copy of each section
- **ACTION:** Remove empty placeholder sections (2.2.2, 2.3.2, etc.)

**VAULT_Oath_Archive_v0058_verified.json:**
- Contains 40+ historical change entries
- **ACTION:** Trim to last 20 entries maximum
- **ACTION:** Remove legacy vault change IDs (keep current format only)

**FORGE_Operations_Ledger_v0058_verified.json:**
- Schemas duplicated in multiple locations
- **ACTION:** Consolidate to single schema section
- **ACTION:** Flatten unnecessarily nested objects

### 7. Versioning Update to Base36 Two-Digit

**Current:** v0058 (decimal)
**New:** v0Z (Base36, 2 digits)

**Base36 digits:** 0-9, then A-Z (total 36 values)
- 00-09: Reserved (as per current spec)
- 0A-0Z: Valid versions (0A, 0B, 0C... 0Z)
- 10-1Z: Next series
- etc.

**UPDATE IN:**
- File headers
- Version fields in JSON
- References to versions in text

**Example conversions:**
- v0058 → v1M (58 in base36 = 1M)
- v0001 → v01
- v0042 → v16 (42 in base36 = 16)

### 8. Terminology Standardization

**REPLACE:**
- `tenetShards` → `canonReferences`
- `conductShards` → `operationalValues`
- `SearchArchive` → `searchHistory`
- `canonIndex` → `sectionIndex`
- `canonJson` → `canonData`
- `idRef` → `identifier` (simplify)
- `legacyId` → `oldId` or remove if unused

---

## VALIDATION CHECKLIST

After editing, verify:

- [ ] No `[§‡:` patterns remain
- [ ] No `ŧ§:` patterns remain
- [ ] No `slug` fields in JSON
- [ ] No `R4K` text remains
- [ ] No `UVK` text remains
- [ ] No `B36.2UC` text remains
- [ ] All JSON files parse successfully
- [ ] File sizes reduced (deduplication worked)
- [ ] Version numbers use Base36 format (vXX)

---

## FILES TO MODIFY

### Primary Files (Major Changes):
1. `C:\P4NTH30N\Atlas\CANON_Atlas_Old_Testsment.txt`
   - Remove all slug notation
   - Remove R4K/UVK references
   - Deduplicate sections
   - Update version to Base36

2. `C:\P4NTH30N\Atlas\FORGE_Operations_Ledger_v0058_verified.json`
   - Remove all slug fields
   - Consolidate schemas
   - Update version references
   - Flatten structures

3. `C:\P4NTH30N\Atlas\VAULT_Oath_Archive_v0058_verified.json`
   - Remove slug references from payloads
   - Trim to 20 most recent changes
   - Update version references

### Secondary File (Minimal Changes):
4. `C:\P4NTH30N\Atlas\OpenAI.txt`
   - Add brief intro if needed
   - Check for any R4K/UVK references

---

## BACKUP VERIFICATION

**Confirm backups exist in:**
- `C:\P4NTH30N\Atlas\archive\CANON_Atlas_Old_Testsment.txt.backup`
- `C:\P4NTH30N\Atlas\archive\FORGE_Operations_Ledger_v0058_verified.json.backup`
- `C:\P4NTH30N\Atlas\archive\VAULT_Oath_Archive_v0058_verified.json.backup`
- `C:\P4NTH30N\Atlas\archive\OpenAI.txt.backup`

---

## SUCCESS CRITERIA

1. All slug/referencing systems removed
2. R4K and UVK completely eliminated (sentences rewritten)
3. B36.2UC treated as plain Base36 numbering
4. Content reorganized and deduplicated
5. Versioning updated to Base36 two-digit format
6. Files are significantly more readable
7. All JSON remains valid
8. Original functionality preserved (just clearer)

---

## ROLLBACK PLAN

If issues arise:
1. Copy backup files from `Atlas/archive/` to `Atlas/`
2. Remove `.backup` extension
3. Verify file integrity

---

**Ready for implementation. Execute with precision.**
