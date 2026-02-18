"""
FAISS Vector Store Bridge for P4NTH30N RAG Architecture (INFRA-010).

Runs as a subprocess, communicating with C# via stdin/stdout JSON protocol.
Each command is a single-line JSON object; each response is a single-line JSON object.

Supported commands:
    init     - Initialize FAISS index with given dimensions
    add      - Add vectors with IDs to the index
    search   - Find nearest neighbors for a query vector
    save     - Persist index to disk
    load     - Load index from disk
    count    - Return number of vectors in index
    shutdown - Gracefully exit

Requirements:
    pip install faiss-cpu numpy

Usage:
    Started automatically by FaissVectorStore.cs via Process.Start("python", "faiss-bridge.py")
"""

import sys
import json
import os
import traceback

try:
    import numpy as np
    import faiss
except ImportError as e:
    # Output error as JSON so C# can handle it gracefully
    print(json.dumps({"status": "error", "error": f"Missing dependency: {e}. Install with: pip install faiss-cpu numpy"}))
    sys.stdout.flush()
    sys.exit(1)


class FaissBridge:
    """Manages a FAISS index with stdin/stdout JSON protocol."""

    def __init__(self):
        self.index = None
        self.index_path = None
        self.dimensions = 0
        # Map from external IDs to internal FAISS positions
        self.id_map = {}
        # Map from internal positions to external IDs
        self.pos_to_id = {}

    def handle_init(self, params):
        """Initialize or load a FAISS index."""
        self.dimensions = params.get("dimensions", 384)
        self.index_path = params.get("index_path", "vectors.faiss")

        if os.path.exists(self.index_path):
            # Load existing index
            self.index = faiss.read_index(self.index_path)
            count = self.index.ntotal
            # Rebuild ID maps from metadata file
            self._load_id_map()
            return {"status": "ok", "count": count, "loaded": True}
        else:
            # Create new index with L2 distance (Euclidean)
            # Using IndexFlatL2 for exact search - good for <100k vectors
            # DECISION: Switch to IndexIVFFlat if vectors exceed 100k
            self.index = faiss.IndexFlatL2(self.dimensions)
            self.id_map = {}
            self.pos_to_id = {}
            return {"status": "ok", "count": 0, "loaded": False}

    def handle_add(self, params):
        """Add vectors with external IDs to the index."""
        if self.index is None:
            return {"status": "error", "error": "Index not initialized"}

        vectors = np.array(params["vectors"], dtype=np.float32)
        ids = params["ids"]

        if vectors.ndim == 1:
            vectors = vectors.reshape(1, -1)

        if vectors.shape[1] != self.dimensions:
            return {
                "status": "error",
                "error": f"Vector dimensions mismatch: expected {self.dimensions}, got {vectors.shape[1]}"
            }

        # Track position-to-ID mapping
        start_pos = self.index.ntotal
        for i, ext_id in enumerate(ids):
            pos = start_pos + i
            self.id_map[ext_id] = pos
            self.pos_to_id[pos] = ext_id

        # Normalize vectors for better cosine-like behavior with L2
        faiss.normalize_L2(vectors)

        self.index.add(vectors)

        return {"status": "ok", "added": len(ids), "total": self.index.ntotal}

    def handle_search(self, params):
        """Search for nearest neighbors."""
        if self.index is None:
            return {"status": "error", "error": "Index not initialized"}

        if self.index.ntotal == 0:
            return {"status": "ok", "ids": [], "distances": []}

        vector = np.array(params["vector"], dtype=np.float32).reshape(1, -1)
        top_k = min(params.get("top_k", 5), self.index.ntotal)

        # Normalize query vector to match indexed vectors
        faiss.normalize_L2(vector)

        distances, indices = self.index.search(vector, top_k)

        # Convert internal positions back to external IDs
        result_ids = []
        result_distances = []
        for i in range(len(indices[0])):
            pos = int(indices[0][i])
            dist = float(distances[0][i])
            ext_id = self.pos_to_id.get(pos, pos)
            result_ids.append(ext_id)
            result_distances.append(dist)

        return {"status": "ok", "ids": result_ids, "distances": result_distances}

    def handle_save(self, params=None):
        """Persist index to disk."""
        if self.index is None:
            return {"status": "error", "error": "Index not initialized"}

        if self.index_path:
            # Ensure directory exists
            os.makedirs(os.path.dirname(self.index_path) or ".", exist_ok=True)
            faiss.write_index(self.index, self.index_path)
            self._save_id_map()
            return {"status": "ok", "path": self.index_path, "count": self.index.ntotal}

        return {"status": "error", "error": "No index path configured"}

    def handle_load(self, params=None):
        """Load index from disk."""
        if not self.index_path or not os.path.exists(self.index_path):
            return {"status": "error", "error": f"Index file not found: {self.index_path}"}

        self.index = faiss.read_index(self.index_path)
        self._load_id_map()
        return {"status": "ok", "count": self.index.ntotal}

    def handle_count(self, params=None):
        """Return vector count."""
        count = self.index.ntotal if self.index else 0
        return {"status": "ok", "count": count}

    def _save_id_map(self):
        """Save ID mapping to a JSON sidecar file."""
        map_path = self.index_path + ".idmap.json"
        with open(map_path, "w") as f:
            # Convert keys to strings for JSON serialization
            json.dump({
                "id_map": {str(k): v for k, v in self.id_map.items()},
                "pos_to_id": {str(k): v for k, v in self.pos_to_id.items()},
            }, f)

    def _load_id_map(self):
        """Load ID mapping from sidecar file."""
        map_path = self.index_path + ".idmap.json"
        if os.path.exists(map_path):
            with open(map_path, "r") as f:
                data = json.load(f)
                self.id_map = {int(k): v for k, v in data.get("id_map", {}).items()}
                self.pos_to_id = {int(k): v for k, v in data.get("pos_to_id", {}).items()}

    def run(self):
        """Main event loop: read JSON commands from stdin, write JSON responses to stdout."""
        bridge = self

        for line in sys.stdin:
            line = line.strip()
            if not line:
                continue

            try:
                cmd = json.loads(line)
                command = cmd.get("command", "")

                if command == "init":
                    result = bridge.handle_init(cmd)
                elif command == "add":
                    result = bridge.handle_add(cmd)
                elif command == "search":
                    result = bridge.handle_search(cmd)
                elif command == "save":
                    result = bridge.handle_save(cmd)
                elif command == "load":
                    result = bridge.handle_load(cmd)
                elif command == "count":
                    result = bridge.handle_count(cmd)
                elif command == "shutdown":
                    # Save before exit if possible
                    if bridge.index is not None and bridge.index_path:
                        bridge.handle_save()
                    print(json.dumps({"status": "ok", "message": "shutting down"}))
                    sys.stdout.flush()
                    break
                else:
                    result = {"status": "error", "error": f"Unknown command: {command}"}

                print(json.dumps(result))
                sys.stdout.flush()

            except json.JSONDecodeError as e:
                print(json.dumps({"status": "error", "error": f"Invalid JSON: {e}"}))
                sys.stdout.flush()
            except Exception as e:
                print(json.dumps({
                    "status": "error",
                    "error": str(e),
                    "traceback": traceback.format_exc()
                }))
                sys.stdout.flush()


if __name__ == "__main__":
    bridge = FaissBridge()
    bridge.run()
