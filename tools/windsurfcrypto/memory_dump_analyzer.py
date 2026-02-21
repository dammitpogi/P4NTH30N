#!/usr/bin/env python3
"""
Memory Dump Analysis for WindSurf
Extracts plaintext conversations and encryption keys from process memory dumps
"""

import os
import re
import struct
import argparse
from typing import List, Dict, Tuple, Optional

class MemoryDumpAnalyzer:
    def __init__(self, dump_file: str):
        self.dump_file = dump_file
        self.data = self._load_dump()
        
    def _load_dump(self) -> bytes:
        """Load memory dump file"""
        try:
            with open(self.dump_file, 'rb') as f:
                return f.read()
        except FileNotFoundError:
            print(f"Memory dump file not found: {self.dump_file}")
            return b""
        except Exception as e:
            print(f"Error loading dump file: {e}")
            return b""
    
    def extract_plaintext_conversations(self) -> List[str]:
        """Extract plaintext conversation strings from memory dump"""
        print("=== PLAINTEXT CONVERSATION EXTRACTION ===")
        
        # Common conversation patterns
        patterns = [
            rb'(?i)(user|assistant|system|message|conversation):?\s*["\']?([a-zA-Z0-9\s.,!?]{20,})',
            rb'(?i)(hello|hi|hey|good morning|good afternoon|good evening)[a-zA-Z0-9\s.,!?]{10,200}',
            rb'(?i)(the quick brown fox|jumps over the lazy dog)[a-zA-Z0-9\s.,!?]{0,100}',
            rb'[A-Z][a-z]+\s+[A-Z][a-z]+\s+[A-Z][a-z]+\s+[A-Z][a-z]+',  # Capitalized words
            rb'[a-zA-Z0-9\s]{50,}',  # Long alphanumeric strings
        ]
        
        conversations = []
        for pattern in patterns:
            matches = re.findall(pattern, self.data, re.IGNORECASE)
            for match in matches:
                if isinstance(match, tuple):
                    match = match[1] if len(match) > 1 else match[0]
                
                if isinstance(match, bytes):
                    try:
                        text = match.decode('utf-8', errors='ignore')
                    except:
                        continue
                else:
                    text = str(match)
                
                if len(text.strip()) > 20 and len(text.strip()) < 1000:
                    conversations.append(text.strip())
        
        # Remove duplicates and filter
        unique_conversations = list(set(conversations))
        filtered = [c for c in unique_conversations if self._is_likely_conversation(c)]
        
        print(f"Found {len(filtered)} potential conversation fragments")
        for i, conv in enumerate(filtered[:10]):  # Show first 10
            print(f"  {i+1}: {conv[:100]}...")
            
        return filtered
    
    def extract_encryption_keys(self) -> List[Dict]:
        """Extract potential encryption keys from memory dump"""
        print("\n=== ENCRYPTION KEY EXTRACTION ===")
        
        keys = []
        
        # Look for AES key patterns (16, 24, 32 bytes)
        for key_size in [16, 24, 32]:
            potential_keys = self._find_key_patterns(key_size)
            for key_data, offset, entropy in potential_keys:
                keys.append({
                    'size': key_size,
                    'data': key_data.hex(),
                    'offset': hex(offset),
                    'entropy': entropy,
                    'type': 'AES-' + str(key_size * 8)
                })
        
        # Look for UUID patterns (potential key identifiers)
        uuid_pattern = rb'[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}'
        uuids = re.findall(uuid_pattern, self.data, re.IGNORECASE)
        
        for uuid in uuids[:20]:  # Limit to first 20
            uuid_str = uuid.decode()
            offset = self.data.find(uuid)
            keys.append({
                'size': 16,
                'data': uuid_str,
                'offset': hex(offset),
                'entropy': 0.0,
                'type': 'UUID'
            })
        
        print(f"Found {len(keys)} potential keys/identifiers")
        for key in keys[:15]:  # Show first 15
            print(f"  {key['type']}: {key['data']} at {key['offset']}")
            if key['entropy'] > 0:
                print(f"    Entropy: {key['entropy']:.2f} bits/byte")
                
        return keys
    
    def extract_protobuf_patterns(self) -> List[Dict]:
        """Extract protobuf patterns from memory dump"""
        print("\n=== PROTOBUF PATTERN EXTRACTION ===")
        
        patterns = []
        
        # Look for protobuf wire format patterns
        pos = 0
        field_count = 0
        
        while pos < len(self.data) - 10 and field_count < 1000:
            # Look for varint key (field number + wire type)
            if self.data[pos] & 0x80:  # Multi-byte varint
                pos += 1
                continue
                
            key = self.data[pos]
            field_num = key >> 3
            wire_type = key & 0x07
            
            if field_num > 0 and field_num < 1000 and wire_type in [0, 1, 2, 5]:
                patterns.append({
                    'offset': hex(pos),
                    'field': field_num,
                    'wire_type': wire_type,
                    'key_byte': hex(key)
                })
                field_count += 1
                
                # Skip to next potential field
                pos += 1
            else:
                pos += 1
        
        print(f"Found {len(patterns)} protobuf field patterns")
        field_counts = {}
        for pattern in patterns:
            field_counts[pattern['field']] = field_counts.get(pattern['field'], 0) + 1
            
        print("Most common field numbers:")
        for field, count in sorted(field_counts.items(), key=lambda x: x[1], reverse=True)[:10]:
            print(f"  Field {field}: {count} occurrences")
            
        return patterns
    
    def _find_key_patterns(self, key_size: int) -> List[Tuple[bytes, int, float]]:
        """Find potential encryption keys of specified size"""
        potential_keys = []
        
        for i in range(len(self.data) - key_size):
            key_data = self.data[i:i+key_size]
            
            # Calculate entropy
            entropy = self._calculate_entropy(key_data)
            
            # Look for high entropy (likely random/key material)
            if entropy > 6.0:  # Threshold for potential keys
                potential_keys.append((key_data, i, entropy))
        
        # Sort by entropy and return top candidates
        potential_keys.sort(key=lambda x: x[2], reverse=True)
        return potential_keys[:20]
    
    def _calculate_entropy(self, data: bytes) -> float:
        """Calculate Shannon entropy of byte data"""
        if not data:
            return 0.0
            
        byte_counts = {}
        for byte in data:
            byte_counts[byte] = byte_counts.get(byte, 0) + 1
            
        data_len = len(data)
        entropy = 0.0
        
        for count in byte_counts.values():
            p = count / data_len
            entropy -= p * (p.bit_length() - 1)  # log2(p) approximation
            
        return entropy
    
    def _is_likely_conversation(self, text: str) -> bool:
        """Determine if text is likely a conversation fragment"""
        # Filter out common non-conversation patterns
        exclude_patterns = [
            r'^[0-9a-f]{32,}$',  # Hex strings
            r'^[A-Z]{20,}$',  # All caps long strings
            r'^[a-z]{20,}$',  # All lowercase long strings
            r'^\d{20,}$',  # Long numbers
            r'^[^\w\s]{10,}$',  # Special characters
        ]
        
        for pattern in exclude_patterns:
            if re.match(pattern, text):
                return False
        
        # Look for conversation indicators
        conversation_indicators = [
            r'\b(the|and|or|but|if|when|where|what|how|why)\b',
            r'\b(hello|hi|hey|good|thank|please|sorry)\b',
            r'\b(you|your|I|me|my|we|us|our)\b',
            r'[.!?]',  # Sentence endings
        ]
        
        matches = sum(1 for pattern in conversation_indicators if re.search(pattern, text, re.IGNORECASE))
        return matches >= 2
    
    def generate_report(self, output_file: str = "memory_analysis_report.txt"):
        """Generate comprehensive analysis report"""
        conversations = self.extract_plaintext_conversations()
        keys = self.extract_encryption_keys()
        patterns = self.extract_protobuf_patterns()
        
        report = f"""WindSurf Memory Dump Analysis Report
========================================
Dump File: {self.dump_file}
Dump Size: {len(self.data):,} bytes
Analysis Date: {__import__('datetime').datetime.now()}

PLAINTEXT CONVERSATIONS
----------------------
Found {len(conversations)} potential conversation fragments

"""
        
        for i, conv in enumerate(conversations[:20]):
            report += f"{i+1}. {conv}\n\n"
        
        report += f"""
ENCRYPTION KEYS / IDENTIFIERS
------------------------------
Found {len(keys)} potential keys/identifiers

"""
        
        for key in keys[:30]:
            report += f"{key['type']}: {key['data']} at {key['offset']}\n"
            if key['entropy'] > 0:
                report += f"  Entropy: {key['entropy']:.2f} bits/byte\n"
        
        report += f"""
PROTOBUF PATTERNS
------------------
Found {len(patterns)} protobuf field patterns

"""
        
        field_counts = {}
        for pattern in patterns:
            field_counts[pattern['field']] = field_counts.get(pattern['field'], 0) + 1
            
        for field, count in sorted(field_counts.items(), key=lambda x: x[1], reverse=True)[:20]:
            report += f"Field {field}: {count} occurrences\n"
        
        with open(output_file, 'w') as f:
            f.write(report)
            
        print(f"\nReport generated: {output_file}")

def main():
    parser = argparse.ArgumentParser(description="WindSurf Memory Dump Analyzer")
    parser.add_argument("dump_file", help="Process memory dump file")
    parser.add_argument("--report", help="Output report file")
    parser.add_argument("--conversations", action="store_true", help="Extract conversations only")
    parser.add_argument("--keys", action="store_true", help="Extract keys only")
    parser.add_argument("--protobuf", action="store_true", help="Extract protobuf patterns only")
    
    args = parser.parse_args()
    
    analyzer = MemoryDumpAnalyzer(args.dump_file)
    
    if not analyzer.data:
        return
    
    if args.report:
        analyzer.generate_report(args.report)
    elif args.conversations:
        analyzer.extract_plaintext_conversations()
    elif args.keys:
        analyzer.extract_encryption_keys()
    elif args.protobuf:
        analyzer.extract_protobuf_patterns()
    else:
        # Run all analyses
        analyzer.extract_plaintext_conversations()
        analyzer.extract_encryption_keys()
        analyzer.extract_protobuf_patterns()

if __name__ == "__main__":
    main()
