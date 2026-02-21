# WindSurf Crypto Analysis Toolkit

Systematic analysis toolkit for WindSurf conversation encryption using "Rosetta Stone" approach.

## Overview

This toolkit provides a comprehensive approach to analyzing WindSurf's conversation encryption without brute-force decryption. Instead, it focuses on:

1. **Known Plaintext Injection** - Testing for ECB mode and deterministic encryption
2. **Memory Analysis** - Extracting unencrypted data from process memory
3. **Key Derivation Analysis** - Analyzing key generation patterns
4. **Protobuf Structure Analysis** - Identifying message structure through encryption

## Tools

### crypto_analysis.py
Main analysis toolkit for systematic encryption analysis.

```bash
# Run all analyses
python3 crypto_analysis.py --all --data-dir ./test_data

# Specific analyses
python3 crypto_analysis.py --known-plaintext --data-dir ./test_data
python3 crypto_analysis.py --protobuf-analysis --data-dir ./test_data
python3 crypto_analysis.py --key-analysis --data-dir ./test_data

# Generate test script
python3 crypto_analysis.py --generate-script test_script.md
```

### memory_dump_analyzer.py
Extracts plaintext conversations and encryption keys from process memory dumps.

```bash
# Analyze memory dump
python3 memory_dump_analyzer.py winddump.dmp

# Generate report
python3 memory_dump_analyzer.py winddump.dmp --report analysis_report.txt

# Specific extractions
python3 memory_dump_analyzer.py winddump.dmp --conversations
python3 memory_dump_analyzer.py winddump.dmp --keys
python3 memory_dump_analyzer.py winddump.dmp --protobuf
```

## Attack Vectors

### 1. Known Plaintext Injection (Highest Priority)

**Theory**: If WindSurf uses ECB mode or deterministic encryption, identical plaintext blocks produce identical ciphertext blocks.

**Test Steps**:
1. Input: `THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG 12345`
2. Input: `THE QUICK BROWN FOX THE QUICK BROWN FOX THE QUICK BROWN FOX`
3. Analyze for repeating 16-byte blocks

**Success Indicators**:
- Identical 16-byte blocks found → ECB mode confirmed
- Some patterns with variations → CBC with predictable IV
- No patterns → Proper encryption with random IV

### 2. Memory Analysis Side-Channel

**Theory**: Conversations exist unencrypted in memory before encryption.

**Test Steps**:
1. Start WindSurf, enter test conversation
2. Use Process Hacker to dump process memory
3. Search dump for plaintext strings and keys

**Success Indicators**:
- Plaintext conversation found in memory dump
- Encryption keys or intermediate buffers found
- No recoverable plaintext → secure memory handling

### 3. Key Derivation Analysis

**Theory**: Per-UUID keys may be derived from predictable sources.

**Test Steps**:
1. Create multiple conversations with different UUIDs
2. Extract and analyze key material
3. Look for environmental correlations

**Success Indicators**:
- Predictable key derivation pattern
- Weak randomness or environmental correlation
- Strong, unpredictable key generation

### 4. Protobuf Structure Analysis

**Theory**: Encrypted protobuf maintains wire format structure.

**Test Steps**:
1. Analyze byte patterns in encrypted .pb files
2. Look for protobuf wire type markers
3. Identify message boundaries

**Success Indicators**:
- Clear protobuf structure visible
- Some structural patterns but encryption obscures most
- Encryption completely hides protobuf structure

## Required Tools

### System Tools
- **Process Hacker** - GUI memory dump tool
- **API Monitor** - API hooking for key generation
- **ProcDump** - Command-line memory dumps

### Python Requirements
- Python 3.8+
- Standard library only (no external dependencies)

## Setup

1. Create test directory:
```bash
mkdir windsurfcrypto_test
cd windsurfcrypto_test
```

2. Copy analysis tools:
```bash
cp crypto_analysis.py .
cp memory_dump_analyzer.py .
```

3. Generate test script:
```bash
python3 crypto_analysis.py --generate-script my_test_script.md
```

## Expected Outcomes

### Best Case (Multiple Vectors Successful)
- ECB mode vulnerability discovered
- Plaintext conversations in memory
- Predictable key derivation
- Protobuf structure visible

### Partial Success
- One or two vectors show weaknesses
- Some patterns but strong encryption overall
- Side-channel leaks but strong crypto

### Strong Security
- No detectable patterns
- Secure memory handling
- Strong key generation
- Complete protobuf obfuscation

## Safety and Ethics

This toolkit is designed for:
- Security research and analysis
- Understanding encryption implementations
- Educational purposes

**Do not use for**:
- Unauthorized access to conversations
- Privacy violations
- Malicious activities

## Technical Notes

### Entropy Analysis
- Random data: ~7.99 bits/byte
- Compressed data: ~6-7 bits/byte  
- Text: ~4-6 bits/byte
- Structured data: ~3-5 bits/byte

### Protobuf Wire Types
- 0: Varint
- 1: 64-bit
- 2: Length-delimited
- 5: 32-bit

### AES Block Size
- AES uses 16-byte (128-bit) blocks
- ECB mode vulnerability: identical blocks → identical ciphertext
- CBC/CTR/GCM modes should show no patterns

## Contributing

To extend this toolkit:
1. Add new analysis vectors
2. Improve pattern detection
3. Add support for other encryption formats
4. Enhance reporting capabilities

## License

Educational and research use only.
