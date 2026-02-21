#!/usr/bin/env python3
"""
WindSurf Crypto Analysis Toolkit
Systematic analysis of WindSurf conversation encryption
"""

import os
import re
import glob
import struct
import argparse
from collections import Counter, defaultdict
from typing import List, Dict, Tuple, Optional

class CryptoAnalyzer:
    def __init__(self, data_dir: str = "."):
        self.data_dir = data_dir
        self.pb_files = glob.glob(os.path.join(data_dir, "*.pb"))
        
    def analyze_known_plaintext(self, test_phrase: str = "THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG 12345"):
        """Known Plaintext Injection Analysis"""
        print("=== KNOWN PLAINTEXT INJECTION ANALYSIS ===")
        
        if not self.pb_files:
            print("No .pb files found. Run tests first.")
            return
            
        # Analyze first file for repeating patterns
        pb_file = self.pb_files[0]
        with open(pb_file, 'rb') as f:
            data = f.read()
            
        print(f"Analyzing {pb_file} ({len(data)} bytes)")
        
        # Block analysis (16-byte AES blocks)
        blocks = [data[i:i+16] for i in range(0, len(data), 16)]
        unique_blocks = set(blocks)
        repeated_blocks = [(block, blocks.count(block)) for block in unique_blocks if blocks.count(block) > 1]
        
        print(f"Total blocks: {len(blocks)}")
        print(f"Unique blocks: {len(unique_blocks)}")
        print(f"Repeated blocks: {len(repeated_blocks)}")
        
        if repeated_blocks:
            print("\nRepeated blocks (potential ECB mode):")
            for block, count in sorted(repeated_blocks, key=lambda x: x[1], reverse=True)[:10]:
                print(f"  Block {block.hex()}: {count} occurrences")
                
            # Look for patterns matching our test phrase
            phrase_bytes = test_phrase.encode('utf-8')
            print(f"\nTest phrase bytes: {phrase_bytes.hex()}")
            
        return len(repeated_blocks) > 0
    
    def analyze_protobuf_structure(self):
        """Protobuf Structure Analysis"""
        print("\n=== PROTOBUF STRUCTURE ANALYSIS ===")
        
        structures = {}
        for pb_file in self.pb_files[:5]:  # Analyze first 5 files
            with open(pb_file, 'rb') as f:
                data = f.read()
                
            fields = self._extract_protobuf_fields(data)
            structures[pb_file] = fields
            
            print(f"\n{pb_file}: {len(fields)} fields")
            field_counts = Counter(f[0] for f in fields)
            for field_num, count in field_counts.most_common(10):
                print(f"  Field {field_num}: {count} occurrences")
                
        return structures
    
    def analyze_key_entropy(self):
        """Key Entropy Analysis"""
        print("\n=== KEY ENTROPY ANALYSIS ===")
        
        # Extract UUIDs and analyze following bytes as potential key material
        uuid_pattern = rb'[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}'
        
        for pb_file in self.pb_files:
            with open(pb_file, 'rb') as f:
                data = f.read()
                
            uuids = re.findall(uuid_pattern, data, re.IGNORECASE)
            print(f"\n{pb_file}: {len(uuids)} UUIDs found")
            
            for uuid in uuids[:3]:  # Analyze first 3 UUIDs
                uuid_str = uuid.decode()
                print(f"  UUID: {uuid_str}")
                
                # Extract bytes after UUID as potential key material
                uuid_pos = data.find(uuid)
                if uuid_pos != -1:
                    key_material = data[uuid_pos + len(uuid):uuid_pos + len(uuid) + 256]
                    if len(key_material) >= 32:
                        entropy = self._calculate_entropy(key_material)
                        print(f"    Key material entropy: {entropy:.2f} bits/byte")
                        print(f"    Random? {entropy > 7.5}")
    
    def _extract_protobuf_fields(self, data: bytes) -> List[Tuple[int, int, int]]:
        """Extract protobuf field numbers and wire types"""
        fields = []
        pos = 0
        
        while pos < len(data):
            key, pos = self._read_varint(data, pos)
            if key is None:
                break
                
            field_num = key >> 3
            wire_type = key & 0x07
            fields.append((field_num, wire_type, pos))
            
            # Skip based on wire type
            if wire_type == 0:  # varint
                _, pos = self._read_varint(data, pos)
            elif wire_type == 1:  # 64-bit
                pos += 8
            elif wire_type == 2:  # length-delimited
                length, pos = self._read_varint(data, pos)
                pos += length
            elif wire_type == 5:  # 32-bit
                pos += 4
            else:
                break
                
        return fields
    
    def _read_varint(self, data: bytes, offset: int) -> Tuple[Optional[int], int]:
        """Read varint from data at offset"""
        result = 0
        shift = 0
        pos = offset
        
        while pos < len(data):
            byte = data[pos]
            pos += 1
            result |= (byte & 0x7F) << shift
            
            if not (byte & 0x80):
                return result, pos
                
            shift += 7
            if shift >= 64:
                return None, pos
                
        return None, pos
    
    def _calculate_entropy(self, data: bytes) -> float:
        """Calculate Shannon entropy of byte data"""
        if not data:
            return 0.0
            
        byte_counts = Counter(data)
        data_len = len(data)
        
        entropy = 0.0
        for count in byte_counts.values():
            p = count / data_len
            entropy -= p * (p.bit_length() - 1)  # log2(p) approximation
            
        return entropy
    
    def generate_test_script(self, output_file: str = "test_script.md"):
        """Generate comprehensive test script"""
        script = f"""# WindSurf Crypto Analysis Test Script

## Setup
1. Install required tools:
   - Process Hacker (for memory dumps)
   - API Monitor (for API hooking)
   - Python 3.8+ with standard library

## Test 1: Known Plaintext Injection
```bash
# Create test conversations with these phrases:
THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG 12345
THE QUICK BROWN FOX THE QUICK BROWN FOX THE QUICK BROWN FOX
AAAAA BBBBB CCCCC DDDDD EEEEE FFFFF GGGGG HHHHH

# Run analysis:
python3 crypto_analysis.py --known-plaintext --data-dir ./test_data
```

## Test 2: Memory Analysis
```bash
# Start WindSurf, enter test conversation
# Use Process Hacker to dump memory:
procdump -ma WindSurf.exe winddump.dmp

# Analyze dump:
python3 crypto_analysis.py --memory-analysis --dump winddump.dmp
```

## Test 3: Key Derivation
```bash
# Create multiple conversations, collect .pb files
# Run analysis:
python3 crypto_analysis.py --key-analysis --data-dir ./test_data
```

## Test 4: Protobuf Structure
```bash
# Analyze protobuf structure:
python3 crypto_analysis.py --protobuf-analysis --data-dir ./test_data
```

## Expected Results
- ECB mode: Repeated 16-byte blocks in known plaintext test
- Memory leaks: Plaintext found in process dumps
- Weak keys: Low entropy or predictable key material
- Structure: Protobuf field patterns visible through encryption
"""
        
        with open(output_file, 'w') as f:
            f.write(script)
            
        print(f"Test script generated: {output_file}")

def main():
    parser = argparse.ArgumentParser(description="WindSurf Crypto Analysis Toolkit")
    parser.add_argument("--data-dir", default=".", help="Directory containing .pb files")
    parser.add_argument("--known-plaintext", action="store_true", help="Run known plaintext analysis")
    parser.add_argument("--protobuf-analysis", action="store_true", help="Run protobuf structure analysis")
    parser.add_argument("--key-analysis", action="store_true", help="Run key entropy analysis")
    parser.add_argument("--generate-script", help="Generate test script")
    parser.add_argument("--all", action="store_true", help="Run all analyses")
    
    args = parser.parse_args()
    
    analyzer = CryptoAnalyzer(args.data_dir)
    
    if args.generate_script:
        analyzer.generate_test_script(args.generate_script)
        return
    
    if args.all or args.known_plaintext:
        analyzer.analyze_known_plaintext()
    
    if args.all or args.protobuf_analysis:
        analyzer.analyze_protobuf_structure()
    
    if args.all or args.key_analysis:
        analyzer.analyze_key_entropy()
    
    if not any([args.all, args.known_plaintext, args.protobuf_analysis, args.key_analysis, args.generate_script]):
        print("Use --help to see available options")
        print("Example: python3 crypto_analysis.py --all --data-dir ./test_data")

if __name__ == "__main__":
    main()
