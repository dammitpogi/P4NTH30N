#!/usr/bin/env python3
"""
WindSurf Crypto Analysis Toolkit
Rosetta Stone approach to analyzing WindSurf's conversation encryption

Priority 1: Known Plaintext Injection - ECB mode detection
Priority 2: Memory Analysis - Plaintext extraction from dumps
Priority 3: Key Derivation - Weak randomness detection
Priority 4: Protobuf Structure - Encrypted format analysis
"""

import os
import sys
import argparse
import hashlib
import struct
from pathlib import Path
from typing import List, Dict, Tuple, Optional
from dataclasses import dataclass
from collections import Counter
import json


@dataclass
class AnalysisResult:
    """Results from crypto analysis"""

    vector: str
    confidence: float  # 0-1
    findings: List[str]
    recommendation: str


class WindSurfCryptoAnalyzer:
    """Main analyzer for WindSurf encryption"""

    # Test phrases for known plaintext injection (all exactly 16 bytes)
    TEST_PHRASES = [
        "AAAAAAAAAAAAAAAA",  # All same character - ECB creates identical blocks
        "BBBBBBBBBBBBBBBB",  # Different character - tests block independence
        "ABCDEFGHIJKLMNOP",  # Sequential - tests pattern preservation
        "1234567890123456",  # Numeric - tests character class handling
    ]

    def __init__(self, data_dir: str = "./test_data"):
        self.data_dir = Path(data_dir)
        self.data_dir.mkdir(exist_ok=True)
        self.results: List[AnalysisResult] = []

    def generate_test_script(self, output_file: str = "test_script.md") -> str:
        """Generate a test script for known plaintext injection"""
        script = """# WindSurf Crypto Test Script

## Instructions
1. Open WindSurf
2. Start a new Cascade conversation
3. Copy and paste EACH test phrase below
4. Wait for response
5. Close WindSurf
6. Copy the .pb file from `~/.codeium/windsurf/cascade/`
7. Run analysis: `python3 crypto_analysis.py --analyze-pb <file.pb>`

## Test Phrases

"""
        for i, phrase in enumerate(self.TEST_PHRASES, 1):
            script += f"### Test {i}\n```\n{phrase}\n```\n\n"

        output_path = self.data_dir / output_file
        output_path.write_text(script)
        return str(output_path)

    def analyze_pb_file(self, pb_file: str) -> AnalysisResult:
        """Analyze a .pb file for encryption patterns"""
        findings = []

        with open(pb_file, "rb") as f:
            data = f.read()

        # Check 1: Entropy measurement
        entropy = self._calculate_entropy(data)
        findings.append(f"File entropy: {entropy:.2f} bits/byte")

        if entropy < 7.5:
            findings.append(
                "WARNING: Low entropy suggests weak encryption or compression"
            )
        elif entropy > 7.9:
            findings.append("High entropy confirms strong encryption")

        # Check 2: ECB mode detection (identical 16-byte blocks)
        blocks = self._get_blocks(data, 16)
        duplicate_blocks = self._find_duplicate_blocks(blocks)

        if duplicate_blocks:
            findings.append(
                f"ECB DETECTED: {len(duplicate_blocks)} duplicate 16-byte blocks"
            )
            findings.append(
                f"Duplicate positions: {duplicate_blocks[:5]}"
            )  # Show first 5
        else:
            findings.append("No ECB pattern detected (no duplicate blocks)")

        # Check 3: File structure analysis
        structure = self._analyze_structure(data)
        findings.append(f"File size: {len(data)} bytes")
        findings.append(f"Structure: {structure}")

        # Check 4: Protobuf wire format markers
        protobuf_markers = self._find_protobuf_markers(data)
        if protobuf_markers:
            findings.append(f"Possible protobuf markers found: {len(protobuf_markers)}")

        confidence = 0.9 if duplicate_blocks else 0.3

        return AnalysisResult(
            vector="Known Plaintext Injection",
            confidence=confidence,
            findings=findings,
            recommendation="ECB vulnerability found! Use identical plaintext to derive key."
            if duplicate_blocks
            else "Try memory analysis approach",
        )

    def _calculate_entropy(self, data: bytes) -> float:
        """Calculate Shannon entropy of data"""
        if not data:
            return 0.0

        byte_counts = Counter(data)
        total = len(data)
        entropy = 0.0

        for count in byte_counts.values():
            probability = count / total
            entropy -= probability * (probability.bit_length() - 1)

        return entropy

    def _get_blocks(self, data: bytes, block_size: int) -> List[bytes]:
        """Split data into blocks"""
        return [data[i : i + block_size] for i in range(0, len(data), block_size)]

    def _find_duplicate_blocks(self, blocks: List[bytes]) -> List[Tuple[int, int]]:
        """Find positions of duplicate blocks (ECB detection)"""
        seen = {}
        duplicates = []

        for i, block in enumerate(blocks):
            if block in seen:
                duplicates.append((seen[block], i))
            else:
                seen[block] = i

        return duplicates

    def _analyze_structure(self, data: bytes) -> str:
        """Analyze file structure"""
        # Look for common patterns
        patterns = []

        # Check for header
        if len(data) > 16:
            header = data[:16]
            if header[:4] == b"\x08\x00\x10\x00":  # Common protobuf header
                patterns.append("protobuf-like header")

        # Check for footer
        if len(data) > 4:
            footer = data[-4:]
            if footer == b"\x00\x00\x00\x00":
                patterns.append("null footer")

        return ", ".join(patterns) if patterns else "unknown"

    def _find_protobuf_markers(self, data: bytes) -> List[int]:
        """Find potential protobuf wire format markers"""
        markers = []

        # Protobuf wire types: 0=varint, 1=64bit, 2=length-delimited, 3=startgroup, 4=endgroup, 5=32bit
        # Field numbers are shifted left by 3, then OR with wire type
        # Common markers: 0x08 (field 1, varint), 0x12 (field 2, length-delimited)

        common_markers = [0x08, 0x12, 0x1A, 0x22, 0x2A]

        for i, byte in enumerate(data):
            if byte in common_markers:
                markers.append(i)

        return markers

    def analyze_key_derivation(self, pb_files: List[str]) -> AnalysisResult:
        """Analyze key derivation patterns across multiple files"""
        findings = []

        if len(pb_files) < 2:
            return AnalysisResult(
                vector="Key Derivation",
                confidence=0.0,
                findings=["Need at least 2 .pb files for comparison"],
                recommendation="Collect more conversation files",
            )

        # Load all files
        files_data = []
        for pb_file in pb_files:
            with open(pb_file, "rb") as f:
                files_data.append(
                    {"path": pb_file, "data": f.read(), "uuid": Path(pb_file).stem}
                )

        findings.append(f"Analyzing {len(files_data)} files")

        # Check for common prefixes (same key scenario)
        prefix_lengths = [8, 16, 32]
        for length in prefix_lengths:
            prefixes = [f["data"][:length] for f in files_data]
            if len(set(prefixes)) == 1:
                findings.append(
                    f"ALERT: All files share {length}-byte prefix - possible IV reuse"
                )

        # Check for entropy variance
        entropies = [self._calculate_entropy(f["data"]) for f in files_data]
        entropy_variance = max(entropies) - min(entropies)
        findings.append(f"Entropy range: {min(entropies):.2f} - {max(entropies):.2f}")

        if entropy_variance < 0.1:
            findings.append("Consistent entropy suggests uniform encryption")
        else:
            findings.append(
                "Entropy variance detected - possible different encryption modes"
            )

        # Check file sizes
        sizes = [len(f["data"]) for f in files_data]
        findings.append(
            f"File sizes: min={min(sizes)}, max={max(sizes)}, avg={sum(sizes) // len(sizes)}"
        )

        confidence = 0.5 if entropy_variance > 0.1 else 0.2

        return AnalysisResult(
            vector="Key Derivation",
            confidence=confidence,
            findings=findings,
            recommendation="Check for IV reuse or key derivation patterns"
            if confidence > 0.3
            else "Keys appear properly randomized",
        )

    def run_all_analyses(self, pb_files: List[str]) -> Dict:
        """Run all analysis vectors"""
        print("=" * 60)
        print("WindSurf Crypto Analysis - Rosetta Stone Approach")
        print("=" * 60)

        results = {
            "timestamp": str(Path.cwd()),
            "files_analyzed": len(pb_files),
            "analyses": [],
        }

        # Priority 1: Known Plaintext (if single file)
        if len(pb_files) == 1:
            print("\n[Priority 1] Known Plaintext Injection Analysis")
            print("-" * 60)
            result = self.analyze_pb_file(pb_files[0])
            self._print_result(result)
            results["analyses"].append(
                {
                    "vector": result.vector,
                    "confidence": result.confidence,
                    "findings": result.findings,
                    "recommendation": result.recommendation,
                }
            )

        # Priority 2: Memory Analysis (handled by separate tool)
        print("\n[Priority 2] Memory Analysis")
        print("-" * 60)
        print("Use: python3 memory_dump_analyzer.py <dump.dmp>")

        # Priority 3: Key Derivation
        if len(pb_files) >= 2:
            print("\n[Priority 3] Key Derivation Analysis")
            print("-" * 60)
            result = self.analyze_key_derivation(pb_files)
            self._print_result(result)
            results["analyses"].append(
                {
                    "vector": result.vector,
                    "confidence": result.confidence,
                    "findings": result.findings,
                    "recommendation": result.recommendation,
                }
            )

        # Priority 4: Protobuf Structure
        print("\n[Priority 4] Protobuf Structure Analysis")
        print("-" * 60)
        print("Analyzing encrypted protobuf structure...")
        for pb_file in pb_files[:1]:  # Just first file
            with open(pb_file, "rb") as f:
                data = f.read()
            markers = self._find_protobuf_markers(data)
            print(f"  Found {len(markers)} potential protobuf markers")
            if markers:
                print(f"  Positions: {markers[:10]}...")  # First 10

        # Save results
        results_file = self.data_dir / "analysis_results.json"
        with open(results_file, "w") as f:
            json.dump(results, f, indent=2)
        print(f"\nResults saved to: {results_file}")

        return results

    def _print_result(self, result: AnalysisResult):
        """Print analysis result"""
        print(f"\nVector: {result.vector}")
        print(f"Confidence: {result.confidence * 100:.1f}%")
        print("Findings:")
        for finding in result.findings:
            print(f"  - {finding}")
        print(f"Recommendation: {result.recommendation}")


def main():
    parser = argparse.ArgumentParser(
        description="WindSurf Crypto Analysis Toolkit",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Generate test script
  %(prog)s --generate-script test.md
  
  # Analyze single .pb file
  %(prog)s --analyze-pb conversation.pb
  
  # Run known plaintext analysis (ECB detection)
  %(prog)s --known-plaintext --data-dir ./pb_files
  
  # Run all analyses on multiple files
  %(prog)s --all --data-dir ./pb_files
        """,
    )

    parser.add_argument(
        "--generate-script",
        metavar="FILE",
        help="Generate test script for known plaintext injection",
    )
    parser.add_argument(
        "--analyze-pb", metavar="FILE", help="Analyze a single .pb file"
    )
    parser.add_argument(
        "--known-plaintext",
        action="store_true",
        help="Run known plaintext injection analysis (ECB detection)",
    )
    parser.add_argument(
        "--all",
        action="store_true",
        help="Run all analyses on .pb files in data directory",
    )
    parser.add_argument(
        "--data-dir", default="./test_data", help="Directory for test data and results"
    )

    args = parser.parse_args()

    analyzer = WindSurfCryptoAnalyzer(args.data_dir)

    if args.generate_script:
        output = analyzer.generate_test_script(args.generate_script)
        print(f"Test script generated: {output}")
        print("\nNext steps:")
        print("1. Open the test script")
        print("2. Follow instructions to generate test conversations")
        print("3. Copy .pb files to the data directory")
        print("4. Run: python3 crypto_analysis.py --all")

    elif args.analyze_pb:
        if not os.path.exists(args.analyze_pb):
            print(f"Error: File not found: {args.analyze_pb}")
            sys.exit(1)
        result = analyzer.analyze_pb_file(args.analyze_pb)
        analyzer._print_result(result)

    elif args.known_plaintext:
        data_dir = Path(args.data_dir)
        pb_files = list(data_dir.glob("*.pb"))

        if not pb_files:
            print(f"No .pb files found in {data_dir}")
            print("\nTo get .pb files:")
            print(
                "1. Generate test script: python3 crypto_analysis.py --generate-script"
            )
            print("2. Follow instructions in the script")
            print("3. Copy .pb files from ~/.codeium/windsurf/cascade/")
            sys.exit(1)

        print("=" * 60)
        print("Known Plaintext Injection Analysis (ECB Detection)")
        print("=" * 60)
        print(f"Analyzing {len(pb_files)} .pb files...")
        print()

        all_blocks = []
        file_results = []

        for pb_file in pb_files:
            with open(pb_file, "rb") as f:
                data = f.read()

            blocks = analyzer._get_blocks(data, 16)
            duplicates = analyzer._find_duplicate_blocks(blocks)

            duplicate_percentage = (
                (len(duplicates) / len(blocks)) * 100 if blocks else 0
            )

            print(f"File: {pb_file.name}")
            print(f"  Total 16-byte blocks: {len(blocks)}")
            print(f"  Duplicate blocks: {len(duplicates)}")
            print(f"  Duplicate percentage: {duplicate_percentage:.2f}%")

            if duplicates:
                print(f"  ⚠️  ECB PATTERN DETECTED!")
                print(f"  Duplicate positions: {duplicates[:3]}")  # Show first 3

            print()

            all_blocks.extend(blocks)
            file_results.append(
                {
                    "file": pb_file.name,
                    "blocks": len(blocks),
                    "duplicates": len(duplicates),
                    "duplicate_percentage": duplicate_percentage,
                }
            )

        # Overall analysis
        total_blocks = len(all_blocks)
        unique_blocks = len(set(all_blocks))
        total_duplicates = total_blocks - unique_blocks
        overall_duplicate_percentage = (
            (total_duplicates / total_blocks) * 100 if total_blocks else 0
        )

        print("=" * 60)
        print("OVERALL ANALYSIS")
        print("=" * 60)
        print(f"Total blocks across all files: {total_blocks}")
        print(f"Unique blocks: {unique_blocks}")
        print(f"Total duplicates: {total_duplicates}")
        print(f"Overall duplicate percentage: {overall_duplicate_percentage:.2f}%")
        print()

        if overall_duplicate_percentage > 5:
            print("✅ ECB MODE CONFIRMED")
            print("   >5% duplicate blocks indicates ECB encryption")
            print("   You can derive the AES key from known plaintext-ciphertext pairs")
        elif overall_duplicate_percentage > 1:
            print("⚠️  SUSPICIOUS PATTERNS")
            print("   Some duplicate blocks detected but below ECB threshold")
            print("   May indicate compression or partial ECB")
        else:
            print("❌ ECB RULED OUT")
            print("   <1% duplicates indicates strong encryption (likely CBC or CTR)")
            print("   Proceed to memory analysis")

        # Save detailed results
        results = {
            "analysis_type": "known_plaintext_injection",
            "files_analyzed": len(pb_files),
            "file_results": file_results,
            "overall": {
                "total_blocks": total_blocks,
                "unique_blocks": unique_blocks,
                "total_duplicates": total_duplicates,
                "duplicate_percentage": overall_duplicate_percentage,
            },
            "ecb_detected": overall_duplicate_percentage > 5,
        }

        results_file = data_dir / "known_plaintext_analysis.json"
        with open(results_file, "w") as f:
            json.dump(results, f, indent=2)
        print(f"\nDetailed results saved to: {results_file}")

    elif args.all:
        data_dir = Path(args.data_dir)
        pb_files = list(data_dir.glob("*.pb"))

        if not pb_files:
            print(f"No .pb files found in {data_dir}")
            print("\nTo get .pb files:")
            print(
                "1. Generate test script: python3 crypto_analysis.py --generate-script"
            )
            print("2. Follow instructions in the script")
            print("3. Copy .pb files from ~/.codeium/windsurf/cascade/")
            sys.exit(1)

        analyzer.run_all_analyses([str(f) for f in pb_files])

    else:
        parser.print_help()
        print("\n" + "=" * 60)
        print("Quick Start:")
        print("=" * 60)
        print("1. Generate test script:")
        print("   python3 crypto_analysis.py --generate-script test.md")
        print("\n2. After collecting .pb files, run analysis:")
        print("   python3 crypto_analysis.py --all --data-dir ./pb_files")


if __name__ == "__main__":
    main()
