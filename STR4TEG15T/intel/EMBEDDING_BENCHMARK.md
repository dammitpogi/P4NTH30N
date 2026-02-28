# Embedding Model Benchmark
## Discovery Task 4: Embedding Quality Assessment

**Date**: 2026-02-18
**Status**: COMPLETE (analysis-based — live benchmark requires Python environment)
**Auditor**: WindFixer (Opus 4.6)

---

## 1. Current Embedding Model

### all-MiniLM-L6-v2 (via embedding-bridge.py)

| Property | Value |
|----------|-------|
| **Architecture** | MiniLM (distilled from BERT) |
| **Parameters** | 22.7M |
| **Dimensions** | 384 |
| **Max Sequence Length** | 256 tokens |
| **Training Data** | 1B+ sentence pairs |
| **MTEB Score** | 56.26 (average) |
| **Speed** | ~2,800 sentences/sec on CPU |
| **Size on Disk** | ~80MB |
| **License** | Apache 2.0 |

---

## 2. Test Cases for P4NTHE0N Use Cases

### Category 1: Similar Game Names
| Text A | Text B | Expected Similarity |
|--------|--------|---------------------|
| "firekirin ocean king" | "fire kirin ocean king 3" | High (>0.85) |
| "orionstars vblink" | "orion stars vb link" | High (>0.85) |
| "firekirin" | "orionstars" | Low (<0.3) |

### Category 2: Threshold Descriptions
| Text A | Text B | Expected Similarity |
|--------|--------|---------------------|
| "Grand jackpot threshold 500" | "Grand threshold set to 500" | High (>0.8) |
| "Minor threshold exceeded" | "Mini threshold exceeded" | Medium (0.5-0.7) |
| "Grand jackpot" | "balance minimum" | Low (<0.3) |

### Category 3: Error Messages
| Text A | Text B | Expected Similarity |
|--------|--------|---------------------|
| "Connection pool exhausted" | "MongoDB connection pool at capacity" | High (>0.8) |
| "NullReferenceException at H0UND.cs" | "Null reference in H0UND agent" | High (>0.8) |
| "Build succeeded" | "Unhandled exception" | Low (<0.2) |

---

## 3. Alternative Models Comparison

| Model | Dimensions | MTEB Score | Speed (CPU) | Size | Notes |
|-------|-----------|-----------|-------------|------|-------|
| **all-MiniLM-L6-v2** (current) | 384 | 56.26 | ~2,800/s | 80MB | Good balance |
| all-MiniLM-L12-v2 | 384 | 56.53 | ~1,400/s | 120MB | Slightly better, 2x slower |
| all-mpnet-base-v2 | 768 | 57.80 | ~800/s | 420MB | Best quality, 3.5x slower |
| bge-small-en-v1.5 | 384 | 62.17 | ~2,500/s | 130MB | Better quality, similar speed |
| gte-small | 384 | 61.36 | ~2,400/s | 67MB | Smallest, good quality |
| nomic-embed-text-v1.5 | 768 | 62.28 | ~600/s | 550MB | Matryoshka dimensions |

---

## 4. Benchmark Execution Plan

Run with existing `embedding-bridge.py`:

```python
import json, sys, time

# Connect to embedding-bridge
bridge = subprocess.Popen(["python", "embedding-bridge.py"], stdin=PIPE, stdout=PIPE)

# Init
send({"command": "init", "model": "all-MiniLM-L6-v2"})

# Benchmark: single embed latency
for text in test_texts:
    start = time.time()
    send({"command": "embed", "text": text})
    result = recv()
    latency = time.time() - start

# Benchmark: batch embed throughput
send({"command": "embed_batch", "texts": all_test_texts})

# Benchmark: search accuracy (requires faiss-bridge)
# Index known documents, search with queries, measure top-k relevance
```

---

## 5. Metrics to Measure (Live)

| Metric | Target | Notes |
|--------|--------|-------|
| Single embed latency | <50ms | For real-time queries |
| Batch throughput | >100/s | For bulk indexing |
| Search accuracy (top-1) | >80% | Correct doc in first result |
| Search accuracy (top-5) | >95% | Correct doc in top 5 |
| Memory usage | <500MB | Including model + index |

---

## 6. Recommendation

**Keep all-MiniLM-L6-v2** for initial deployment:
- Good speed/quality tradeoff
- 384 dimensions keeps FAISS index small
- Already configured in embedding-bridge.py

**Consider upgrading to bge-small-en-v1.5** if search quality is insufficient:
- Same dimensions (384), easy drop-in
- ~6 MTEB points better
- Similar speed characteristics
- Slightly larger model (130MB vs 80MB)

**Do NOT use 768-dimensional models** unless quality is critical — doubles FAISS memory and search time.
