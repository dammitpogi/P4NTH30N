#!/usr/bin/env python3
"""
Memory Dump Analyzer for WindSurf
Extracts conversation data and keys from process memory dumps

Tools needed:
- Process Hacker: https://processhacker.sourceforge.io/
- ProcDump: https://docs.microsoft.com/en-us/sysinternals/downloads/procdump
- WinDbg (optional): https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/
"""

import os
import sys
import argparse
import re
import struct
from pathlib import Path
from typing import List, Dict, Optional, Tuple
from dataclasses import dataclass
import json


@dataclass
class MemoryFinding:
    """A finding from memory analysis"""

    type: str
    offset: int
    content: bytes
    confidence: float
    context: str


class MemoryDumpAnalyzer:
    """Analyze WindSurf process memory dumps"""

    # Patterns to search for
    CONVERSATION_PATTERNS = [
        rb"User:\s*(.{0,500})",  # User messages
        rb"Cascade:\s*(.{0,500})",  # Cascade responses
        rb"assistant\x00+(.{0,500})",  # Assistant role marker
        rb"user\x00+(.{0,500})",  # User role marker
    ]

    # Potential key patterns (AES keys are 16, 24, or 32 bytes)
    KEY_PATTERNS = [
        rb"[\x00-\xff]{16}(?=\x00)",  # 16-byte key candidate
        rb"[\x00-\xff]{24}(?=\x00)",  # 24-byte key candidate
        rb"[\x00-\xff]{32}(?=\x00)",  # 32-byte key candidate
    ]

    # UUID pattern for conversation identification
    UUID_PATTERN = rb"[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}"

    def __init__(self, dump_file: str):
        self.dump_file = Path(dump_file)
        self.findings: List[MemoryFinding] = []
        self.stats = {
            "total_size": 0,
            "strings_found": 0,
            "conversation_fragments": 0,
            "key_candidates": 0,
            "uuids_found": 0,
        }

    def analyze(self) -> Dict:
        """Main analysis routine"""
        print(f"Analyzing memory dump: {self.dump_file}")
        print("=" * 60)

        if not self.dump_file.exists():
            raise FileNotFoundError(f"Dump file not found: {self.dump_file}")

        self.stats["total_size"] = self.dump_file.stat().st_size
        print(
            f"Dump size: {self.stats['total_size']:,} bytes ({self.stats['total_size'] / (1024 * 1024):.2f} MB)"
        )

        # Read dump in chunks to handle large files
        chunk_size = 10 * 1024 * 1024  # 10MB chunks

        with open(self.dump_file, "rb") as f:
            offset = 0
            while True:
                chunk = f.read(chunk_size)
                if not chunk:
                    break

                self._analyze_chunk(chunk, offset)
                offset += len(chunk)

                # Progress indicator
                if offset % (50 * 1024 * 1024) == 0:  # Every 50MB
                    print(f"  Processed {offset / (1024 * 1024):.1f} MB...")

        print("\n" + "=" * 60)
        print("Analysis Complete")
        print("=" * 60)

        return self._generate_report()

    def _analyze_chunk(self, chunk: bytes, base_offset: int):
        """Analyze a chunk of memory"""
        # Search for conversation patterns
        for pattern in self.CONVERSATION_PATTERNS:
            for match in re.finditer(pattern, chunk, re.DOTALL):
                finding = MemoryFinding(
                    type="conversation_fragment",
                    offset=base_offset + match.start(),
                    content=match.group(1),
                    confidence=0.8,
                    context=f"Pattern: {pattern[:30]}...",
                )
                self.findings.append(finding)
                self.stats["conversation_fragments"] += 1

        # Search for UUIDs
        for match in re.finditer(self.UUID_PATTERN, chunk):
            finding = MemoryFinding(
                type="uuid",
                offset=base_offset + match.start(),
                content=match.group(0),
                confidence=0.95,
                context="Conversation UUID",
            )
            self.findings.append(finding)
            self.stats["uuids_found"] += 1

        # Search for key candidates
        for pattern in self.KEY_PATTERNS:
            for match in re.finditer(pattern, chunk):
                # Filter out low-entropy candidates (likely not keys)
                candidate = match.group(0)
                if self._is_high_entropy(candidate):
                    finding = MemoryFinding(
                        type="key_candidate",
                        offset=base_offset + match.start(),
                        content=candidate,
                        confidence=0.6,
                        context=f"{len(candidate)}-byte high-entropy block",
                    )
                    self.findings.append(finding)
                    self.stats["key_candidates"] += 1

        # Extract readable strings
        strings = self._extract_strings(chunk, min_length=20)
        self.stats["strings_found"] += len(strings)

    def _is_high_entropy(self, data: bytes, threshold: float = 7.0) -> bool:
        """Check if data has high entropy (random-like)"""
        if len(data) == 0:
            return False

        # Calculate byte frequency
        byte_counts = {}
        for byte in data:
            byte_counts[byte] = byte_counts.get(byte, 0) + 1

        # Calculate entropy
        import math

        entropy = 0.0
        length = len(data)
        for count in byte_counts.values():
            probability = count / length
            entropy -= probability * math.log2(probability)

        return entropy > threshold

    def _extract_strings(
        self, data: bytes, min_length: int = 10
    ) -> List[Tuple[int, str]]:
        """Extract readable ASCII/UTF-8 strings from binary data"""
        strings = []
        current_string = ""
        current_offset = 0

        for i, byte in enumerate(data):
            # Check if printable ASCII or common UTF-8
            if 32 <= byte <= 126 or byte in (9, 10, 13):  # Printable or tab/newline
                if not current_string:
                    current_offset = i
                current_string += chr(byte)
            else:
                if len(current_string) >= min_length:
                    strings.append((current_offset, current_string))
                current_string = ""

        # Don't forget the last string
        if len(current_string) >= min_length:
            strings.append((current_offset, current_string))

        return strings

    def _generate_report(self) -> Dict:
        """Generate analysis report"""
        report = {"file": str(self.dump_file), "stats": self.stats, "findings": []}

        print(f"\nStrings found: {self.stats['strings_found']}")
        print(f"Conversation fragments: {self.stats['conversation_fragments']}")
        print(f"UUIDs found: {self.stats['uuids_found']}")
        print(f"Key candidates: {self.stats['key_candidates']}")

        # Group findings by type
        by_type = {}
        for finding in self.findings:
            if finding.type not in by_type:
                by_type[finding.type] = []
            by_type[finding.type].append(finding)

        # Print top findings by type
        for ftype, findings in by_type.items():
            print(f"\n{ftype.upper()} FINDINGS ({len(findings)} total):")
            print("-" * 60)

            # Sort by confidence
            sorted_findings = sorted(findings, key=lambda f: f.confidence, reverse=True)

            # Show top 10
            for i, finding in enumerate(sorted_findings[:10], 1):
                content_preview = str(finding.content[:100]).replace("\n", " ")
                print(
                    f"{i}. Offset 0x{finding.offset:08x} (confidence: {finding.confidence:.2f})"
                )
                print(f"   Content: {content_preview}...")
                print(f"   Context: {finding.context}")
                print()

                report["findings"].append(
                    {
                        "type": finding.type,
                        "offset": finding.offset,
                        "confidence": finding.confidence,
                        "content_preview": content_preview,
                        "context": finding.context,
                    }
                )

        return report

    def extract_conversations(self, output_dir: str = "./extracted") -> List[str]:
        """Extract and save conversation fragments"""
        output_path = Path(output_dir)
        output_path.mkdir(exist_ok=True)

        extracted_files = []

        # Get conversation findings
        conversations = [f for f in self.findings if f.type == "conversation_fragment"]

        if not conversations:
            print("No conversation fragments found")
            return extracted_files

        # Group by proximity (same conversation)
        groups = self._group_by_proximity(conversations, max_distance=4096)

        for i, group in enumerate(groups, 1):
            output_file = output_path / f"conversation_{i:03d}.txt"

            with open(output_file, "w", encoding="utf-8") as f:
                f.write(f"# Extracted Conversation {i}\n")
                f.write(f"# Source: {self.dump_file}\n")
                f.write("#" + "=" * 58 + "\n\n")

                for finding in sorted(group, key=lambda f: f.offset):
                    try:
                        content = finding.content.decode("utf-8", errors="replace")
                    except:
                        content = str(finding.content)

                    f.write(f"[Offset 0x{finding.offset:08x}]\n")
                    f.write(content)
                    f.write("\n\n" + "-" * 60 + "\n\n")

            extracted_files.append(str(output_file))

        print(f"\nExtracted {len(extracted_files)} conversation files to {output_dir}")
        return extracted_files

    def _group_by_proximity(
        self, findings: List[MemoryFinding], max_distance: int = 4096
    ) -> List[List[MemoryFinding]]:
        """Group findings that are close together in memory"""
        if not findings:
            return []

        # Sort by offset
        sorted_findings = sorted(findings, key=lambda f: f.offset)

        groups = []
        current_group = [sorted_findings[0]]

        for finding in sorted_findings[1:]:
            last_offset = current_group[-1].offset
            if finding.offset - last_offset <= max_distance:
                current_group.append(finding)
            else:
                groups.append(current_group)
                current_group = [finding]

        if current_group:
            groups.append(current_group)

        return groups

    def search_for_keys(self) -> List[Dict]:
        """Search for potential encryption keys"""
        key_findings = [f for f in self.findings if f.type == "key_candidate"]

        print(f"\nAnalyzing {len(key_findings)} key candidates...")

        validated_keys = []

        for finding in key_findings:
            # Additional validation
            key_data = finding.content

            # Check if it looks like an AES key
            if len(key_data) in [16, 24, 32]:
                entropy = self._calculate_entropy(key_data)

                if entropy > 7.5:  # High entropy = likely key
                    validated_keys.append(
                        {
                            "offset": hex(finding.offset),
                            "size": len(key_data),
                            "entropy": entropy,
                            "hex": key_data.hex(),
                            "confidence": finding.confidence,
                        }
                    )

        # Sort by entropy (highest first)
        validated_keys.sort(key=lambda k: k["entropy"], reverse=True)

        print(f"Found {len(validated_keys)} high-quality key candidates")

        if validated_keys:
            print("\nTop key candidates:")
            for i, key in enumerate(validated_keys[:5], 1):
                print(
                    f"{i}. Offset {key['offset']}, {key['size']} bytes, entropy: {key['entropy']:.2f}"
                )
                print(f"   Hex: {key['hex'][:32]}...")

        return validated_keys

    def _calculate_entropy(self, data: bytes) -> float:
        """Calculate Shannon entropy"""
        import math

        if not data:
            return 0.0

        byte_counts = {}
        for byte in data:
            byte_counts[byte] = byte_counts.get(byte, 0) + 1

        entropy = 0.0
        length = len(data)
        for count in byte_counts.values():
            probability = count / length
            entropy -= probability * math.log2(probability)

        return entropy


def create_dump_instructions():
    """Create instructions for creating memory dumps"""
    instructions = """# Creating WindSurf Memory Dumps

## Method 1: Process Hacker (Recommended)

1. Download Process Hacker: https://processhacker.sourceforge.io/
2. Run Process Hacker as Administrator
3. Find Windsurf.exe in the process list
4. Right-click → Create Dump File...
5. Choose "Full dump" (not Mini dump)
6. Save to known location

## Method 2: ProcDump (Command Line)

1. Download ProcDump: https://docs.microsoft.com/en-us/sysinternals/downloads/procdump
2. Open Command Prompt as Administrator
3. Run:
   ```
   procdump -ma Windsurf.exe windsurf.dmp
   ```
4. The -ma flag creates a full memory dump

## Method 3: WinDbg (Advanced)

1. Install WinDbg Preview from Microsoft Store
2. Attach to Windsurf.exe process
3. Run:
   ```
   .dump /ma C:\\path\\to\\windsurf.dmp
   ```

## Best Practices

- Create dump WHILE a conversation is active
- Dumps are large (500MB-2GB depending on RAM usage)
- Store dumps securely - they may contain sensitive data
- Analyze dumps offline on a secure machine

## Analyzing the Dump

```bash
python3 memory_dump_analyzer.py windsurf.dmp --extract --report analysis.txt
```
"""
    return instructions


def main():
    parser = argparse.ArgumentParser(
        description="Memory Dump Analyzer for WindSurf",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Analyze dump and generate report
  %(prog)s windump.dmp --report analysis.txt
  
  # Extract conversation fragments
  %(prog)s windump.dmp --extract --output-dir ./conversations
  
  # Search for encryption keys
  %(prog)s windump.dmp --search-keys
  
  # Do everything
  %(prog)s windump.dmp --all --report full_analysis.txt
        """,
    )

    parser.add_argument("dump_file", nargs="?", help="Memory dump file to analyze")
    parser.add_argument("--report", metavar="FILE", help="Save analysis report to file")
    parser.add_argument(
        "--extract", action="store_true", help="Extract conversation fragments"
    )
    parser.add_argument(
        "--output-dir",
        default="./extracted",
        help="Output directory for extracted files",
    )
    parser.add_argument(
        "--search-keys", action="store_true", help="Search for encryption keys"
    )
    parser.add_argument("--all", action="store_true", help="Run all analyses")
    parser.add_argument(
        "--instructions", action="store_true", help="Show dump creation instructions"
    )

    args = parser.parse_args()

    if args.instructions:
        print(create_dump_instructions())
        return

    if not args.dump_file:
        parser.print_help()
        print("\n" + "=" * 60)
        print("To create a memory dump:")
        print("=" * 60)
        print("python3 memory_dump_analyzer.py --instructions")
        return

    try:
        analyzer = MemoryDumpAnalyzer(args.dump_file)

        # Main analysis
        report = analyzer.analyze()

        # Save report if requested
        if args.report or args.all:
            report_file = args.report or "analysis_report.txt"
            with open(report_file, "w") as f:
                f.write(json.dumps(report, indent=2))
            print(f"\nReport saved to: {report_file}")

        # Extract conversations
        if args.extract or args.all:
            analyzer.extract_conversations(args.output_dir)

        # Search for keys
        if args.search_keys or args.all:
            keys = analyzer.search_for_keys()

            if keys:
                keys_file = "potential_keys.json"
                with open(keys_file, "w") as f:
                    json.dump(keys, f, indent=2)
                print(f"\nKey candidates saved to: {keys_file}")

    except FileNotFoundError as e:
        print(f"Error: {e}")
        print("\nTo create a memory dump, run:")
        print("python3 memory_dump_analyzer.py --instructions")
        sys.exit(1)
    except Exception as e:
        print(f"Error analyzing dump: {e}")
        import traceback

        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
