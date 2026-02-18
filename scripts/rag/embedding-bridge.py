"""
Embedding Bridge for P4NTH30N RAG Architecture (INFRA-010).

Runs as a subprocess, communicating with C# via stdin/stdout JSON protocol.
Uses sentence-transformers to generate embeddings from the all-MiniLM-L6-v2 model.

Supported commands:
    init       - Load the embedding model
    embed      - Generate embedding for a single text
    embed_batch - Generate embeddings for multiple texts
    shutdown   - Gracefully exit

Requirements:
    pip install sentence-transformers torch

Usage:
    Started automatically by EmbeddingService.cs via Process.Start("python", "embedding-bridge.py")
"""

import sys
import json
import traceback

try:
    from sentence_transformers import SentenceTransformer
    import numpy as np
except ImportError as e:
    print(json.dumps({
        "status": "error",
        "error": f"Missing dependency: {e}. Install with: pip install sentence-transformers torch"
    }))
    sys.stdout.flush()
    sys.exit(1)


class EmbeddingBridge:
    """Manages a sentence-transformers model with stdin/stdout JSON protocol."""

    def __init__(self):
        self.model = None
        self.model_name = None
        self.dimensions = 0

    def handle_init(self, params):
        """Load the embedding model into memory."""
        self.model_name = params.get("model", "all-MiniLM-L6-v2")

        try:
            # Load model (downloads on first use, cached thereafter)
            self.model = SentenceTransformer(self.model_name)
            # Get dimensions from a test encoding
            test_embedding = self.model.encode(["test"], convert_to_numpy=True)
            self.dimensions = test_embedding.shape[1]

            return {
                "status": "ok",
                "model": self.model_name,
                "dimensions": self.dimensions
            }
        except Exception as e:
            return {"status": "error", "error": f"Failed to load model '{self.model_name}': {e}"}

    def handle_embed(self, params):
        """Generate embedding for a single text."""
        if self.model is None:
            return {"status": "error", "error": "Model not initialized"}

        text = params.get("text", "")
        if not text:
            return {"status": "error", "error": "Text is empty"}

        embedding = self.model.encode([text], convert_to_numpy=True, normalize_embeddings=True)
        return {
            "status": "ok",
            "embedding": embedding[0].tolist(),
            "dimensions": len(embedding[0])
        }

    def handle_embed_batch(self, params):
        """Generate embeddings for multiple texts in a single batch."""
        if self.model is None:
            return {"status": "error", "error": "Model not initialized"}

        texts = params.get("texts", [])
        if not texts:
            return {"status": "ok", "embeddings": [], "count": 0}

        embeddings = self.model.encode(texts, convert_to_numpy=True, normalize_embeddings=True, batch_size=32)
        return {
            "status": "ok",
            "embeddings": embeddings.tolist(),
            "count": len(embeddings)
        }

    def run(self):
        """Main event loop: read JSON commands from stdin, write JSON responses to stdout."""
        for line in sys.stdin:
            line = line.strip()
            if not line:
                continue

            try:
                cmd = json.loads(line)
                command = cmd.get("command", "")

                if command == "init":
                    result = self.handle_init(cmd)
                elif command == "embed":
                    result = self.handle_embed(cmd)
                elif command == "embed_batch":
                    result = self.handle_embed_batch(cmd)
                elif command == "shutdown":
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
    bridge = EmbeddingBridge()
    bridge.run()
