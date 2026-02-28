# WindSurf Crypto Analysis Toolkit

Rosetta Stone approach to analyzing WindSurf's AES-encrypted conversation storage.

## Overview

WindSurf stores conversations in encrypted Protobuf (.pb) files with the following characteristics:
- **Location**: `~/.codeium/windsurf/cascade/{uuid}.pb`
- **Encryption**: AES-level, 7.95-7.98 bits/byte entropy
- **Key Management**: Per-UUID unique keys
- **Auto-deletion**: After ~20 sessions
- **Recovery**: None (confirmed by support)

Instead of brute-force decryption, this toolkit uses side-channel analysis and pattern recognition.

## Attack Vectors (Prioritized)

### Priority 1: Known Plaintext Injection
**Goal**: Detect ECB mode through repeating 16-byte blocks

If WindSurf uses ECB mode, identical plaintext blocks produce identical ciphertext blocks.

**Test Method**:
1. Inject test phrases with repeating patterns
2. Analyze encrypted .pb files for duplicate 16-byte blocks
3. If found, derive key from known plaintext-ciphertext pairs

**Success Indicator**: Identical ciphertext blocks → ECB vulnerability confirmed

### Priority 2: Memory Analysis
**Goal**: Extract plaintext before encryption from process memory

WindSurf must hold conversation data in memory before encrypting and saving to disk.

**Test Method**:
1. Create memory dump while conversation is active
2. Search for conversation text in dump
3. Look for encryption keys in memory

**Tools**:
- Process Hacker
- ProcDump
- WinDbg

**Success Indicator**: Conversation fragments or keys found in memory

### Priority 3: Key Derivation Analysis
**Goal**: Find weaknesses in per-UUID key generation

If keys are derived from UUIDs using weak randomness, they may be predictable.

**Test Method**:
1. Collect multiple .pb files
2. Analyze entropy and patterns across files
3. Check for IV reuse or predictable sequences

**Success Indicator**: Weak randomness or predictable patterns discovered

### Priority 4: Protobuf Structure Analysis
**Goal**: Identify message boundaries through encrypted data

Even encrypted, protobuf wire format may leave structural markers.

**Test Method**:
1. Analyze encrypted files for protobuf wire type markers
2. Look for field number patterns
3. Identify message boundaries

**Success Indicator**: Structural patterns visible through encryption

## Quick Start

### Step 1: Generate Test Script

```bash
python3 crypto_analysis.py --generate-script test_script.md
```

This creates a test script with known plaintext phrases.

### Step 2: Create Test Conversations

1. Open WindSurf
2. Start a new Cascade conversation
3. Copy and paste EACH test phrase from the script
4. Wait for Cascade to respond
5. Close WindSurf completely

### Step 3: Collect .pb Files

```bash
# On Windows
copy %USERPROFILE%\.codeium\windsurf\cascade\*.pb .\test_data\

# On Mac/Linux
cp ~/.codeium/windsurf/cascade/*.pb ./test_data/
```

### Step 4: Analyze

```bash
# Run all analyses
python3 crypto_analysis.py --all --data-dir ./test_data

# Or analyze single file
python3 crypto_analysis.py --analyze-pb conversation.pb
```

### Step 5: Memory Analysis (if needed)

```bash
# Create memory dump first (see instructions below)
python3 memory_dump_analyzer.py windump.dmp --all --report analysis.txt
```

## Creating Memory Dumps

### Method 1: Process Hacker (Recommended)

1. Download Process Hacker: https://processhacker.sourceforge.io/
2. Run as Administrator
3. Find `Windsurf.exe` in process list
4. Right-click → Create Dump File...
5. Choose "Full dump" (not Mini dump)
6. Save to known location

### Method 2: ProcDump (Command Line)

```cmd
# Download ProcDump from Sysinternals
procdump -ma Windsurf.exe windsurf.dmp
```

The `-ma` flag creates a full memory dump including all process memory.

### Method 3: WinDbg (Advanced)

```
.attach 0n<Windsurf_PID>
.dump /ma C:\path\to\windsurf.dmp
```

## Tools Reference

### crypto_analysis.py

Main analysis toolkit for .pb files.

```bash
# Generate test script
python3 crypto_analysis.py --generate-script test.md

# Analyze single file
python3 crypto_analysis.py --analyze-pb file.pb

# Run all analyses on directory
python3 crypto_analysis.py --all --data-dir ./pb_files
```

### memory_dump_analyzer.py

Analyzes process memory dumps for conversation data and keys.

```bash
# Basic analysis
python3 memory_dump_analyzer.py windump.dmp

# Extract conversations
python3 memory_dump_analyzer.py windump.dmp --extract --output-dir ./conversations

# Search for keys
python3 memory_dump_analyzer.py windump.dmp --search-keys

# Do everything
python3 memory_dump_analyzer.py windump.dmp --all --report report.txt

# Show dump creation instructions
python3 memory_dump_analyzer.py --instructions
```

## Expected Outcomes

### Best Case: ECB Mode Detected
- Identical 16-byte blocks found in ciphertext
- Can derive AES key from known plaintext
- Full decryption possible

### Good Case: Memory Extraction
- Conversation fragments found in memory dump
- May find encryption keys
- Can decrypt current/future conversations

### Moderate Case: Key Pattern Found
- Weak randomness in key generation
- Can predict keys from UUIDs
- Decryption possible with UUID knowledge

### Worst Case: Strong Encryption
- No ECB patterns
- No memory leakage
- Proper key generation
- **Fallback**: Use capture-before-encryption approach (RAG-003)

## Interpreting Results

### Entropy Analysis
- **7.9-8.0 bits/byte**: Strong encryption (expected)
- **7.5-7.9 bits/byte**: Possible compression + encryption
- **< 7.5 bits/byte**: Weak encryption or only compression

### ECB Detection
- **Duplicate 16-byte blocks**: ECB mode confirmed, vulnerable
- **No duplicates**: Likely CBC or other mode, harder to break

### Memory Findings
- **Conversation text**: Can reconstruct conversations
- **Key candidates**: Potential AES keys for decryption
- **UUIDs**: Can correlate with .pb files

## Security Considerations

⚠️ **Warning**: This toolkit is for analyzing your own WindSurf data only.

- Only analyze dumps from your own machine
- Store dumps securely - they contain sensitive data
- Delete dumps after analysis
- Do not distribute encryption keys if found

## Troubleshooting

### "No .pb files found"
WindSurf may not have created any conversations yet, or they were deleted.

**Solution**: Create a test conversation and ensure WindSurf is closed before copying.

### "Memory dump too large"
Full dumps can be 500MB-2GB.

**Solution**: Use a machine with sufficient RAM, or analyze in chunks.

### "No conversation fragments found"
Memory may have been cleared or conversation wasn't active during dump.

**Solution**: Create dump while actively typing in Cascade panel.

### "High entropy but no patterns"
Encryption is likely strong.

**Solution**: Proceed with capture-before-encryption approach (RAG-003).

## Next Steps

1. Run known plaintext injection test
2. If ECB detected: Derive key and decrypt
3. If no ECB: Create memory dump during active conversation
4. If memory analysis fails: Implement real-time capture (RAG-003)

## References

- [GitHub Issue #127](https://github.com/Exafunction/codeium/issues/127) - WindSurf chat history export
- [GitHub Issue #136](https://github.com/Exafunction/codeium/issues/136) - Auto-deletion confirmation
- AES Encryption: https://en.wikipedia.org/wiki/Advanced_Encryption_Standard
- Protobuf Encoding: https://protobuf.dev/programming-guides/encoding/

## License

Internal use only for P4NTHE0N project.
