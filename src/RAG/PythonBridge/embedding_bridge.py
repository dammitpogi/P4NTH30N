"""
P4NTH30N RAG Embedding Bridge
FastAPI service wrapping ONNX Runtime for sentence embedding generation.
Serves as the Python bridge for Oracle condition #3 (C# -> Python -> ONNX).
"""

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import onnxruntime as ort
import numpy as np
import tokenizers
from pathlib import Path
import logging
import time
import signal
import sys

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger("embedding_bridge")

app = FastAPI(title="P4NTH30N RAG Embedding Bridge", version="1.0.0")

# Configuration
MODEL_PATH = Path("C:/ProgramData/P4NTH30N/models/all-MiniLM-L6-v2.onnx")
TOKENIZER_PATH = Path("C:/ProgramData/P4NTH30N/models/tokenizer.json")
PORT = 5000

# Global model session
session = None
tokenizer_instance = None


class EmbedRequest(BaseModel):
    texts: list[str]
    batch_size: int = 32


class EmbedResponse(BaseModel):
    embeddings: list[list[float]]
    dimensions: int
    model_name: str
    processing_time_ms: float


@app.on_event("startup")
async def load_model():
    global session, tokenizer_instance
    logger.info(f"Loading ONNX model from {MODEL_PATH}")

    if not MODEL_PATH.exists():
        raise RuntimeError(f"Model not found: {MODEL_PATH}")

    # Initialize ONNX Runtime
    sess_options = ort.SessionOptions()
    sess_options.graph_optimization_level = ort.GraphOptimizationLevel.ORT_ENABLE_ALL
    sess_options.inter_op_num_threads = 4
    sess_options.intra_op_num_threads = 4
    session = ort.InferenceSession(str(MODEL_PATH), sess_options)

    # Load tokenizer
    if TOKENIZER_PATH.exists():
        tokenizer_instance = tokenizers.Tokenizer.from_file(str(TOKENIZER_PATH))
        # Enable padding and truncation
        tokenizer_instance.enable_padding(pad_id=0, pad_token="[PAD]", length=128)
        tokenizer_instance.enable_truncation(max_length=512)
        logger.info("Tokenizer loaded from file")
    else:
        raise RuntimeError(f"Tokenizer not found: {TOKENIZER_PATH}")

    # Log model input/output info
    inputs = session.get_inputs()
    outputs = session.get_outputs()
    logger.info(
        f"Model loaded - inputs: {[i.name for i in inputs]}, "
        f"outputs: {[o.name for o in outputs]}"
    )
    logger.info(f"Providers: {session.get_providers()}")
    logger.info("Model loaded successfully")


@app.get("/health")
async def health():
    if session is None:
        raise HTTPException(status_code=503, detail="Model not loaded")
    return {
        "status": "healthy",
        "model_loaded": session is not None,
        "model_path": str(MODEL_PATH),
        "port": PORT,
    }


@app.get("/model-info")
async def model_info():
    if session is None:
        raise HTTPException(status_code=503, detail="Model not loaded")

    inputs = session.get_inputs()
    outputs = session.get_outputs()

    return {
        "model_name": "sentence-transformers/all-MiniLM-L6-v2",
        "onnx_version": ort.__version__,
        "input_names": [i.name for i in inputs],
        "input_shapes": [str(i.shape) for i in inputs],
        "output_names": [o.name for o in outputs],
        "output_shapes": [str(o.shape) for o in outputs],
        "providers": session.get_providers(),
    }


@app.post("/embed", response_model=EmbedResponse)
async def embed(request: EmbedRequest):
    if session is None:
        raise HTTPException(status_code=503, detail="Model not loaded")

    if not request.texts:
        return EmbedResponse(
            embeddings=[],
            dimensions=384,
            model_name="sentence-transformers/all-MiniLM-L6-v2",
            processing_time_ms=0.0,
        )

    start_time = time.time()

    try:
        embeddings = []

        for i in range(0, len(request.texts), request.batch_size):
            batch = request.texts[i : i + request.batch_size]

            # Tokenize using the tokenizers library
            encoded = tokenizer_instance.encode_batch(batch)
            input_ids = np.array([e.ids for e in encoded], dtype=np.int64)
            attention_mask = np.array(
                [e.attention_mask for e in encoded], dtype=np.int64
            )
            token_type_ids = np.zeros_like(input_ids, dtype=np.int64)

            # Build input dict based on model's expected inputs
            input_names = [inp.name for inp in session.get_inputs()]
            feed = {}
            if "input_ids" in input_names:
                feed["input_ids"] = input_ids
            if "attention_mask" in input_names:
                feed["attention_mask"] = attention_mask
            if "token_type_ids" in input_names:
                feed["token_type_ids"] = token_type_ids

            # Run inference
            outputs = session.run(None, feed)

            # Get sentence embeddings via mean pooling
            token_embeddings = outputs[0]
            input_mask_expanded = np.expand_dims(attention_mask, -1).astype(np.float32)
            sum_embeddings = np.sum(token_embeddings * input_mask_expanded, axis=1)
            sum_mask = np.clip(input_mask_expanded.sum(axis=1), a_min=1e-9, a_max=None)
            sentence_embeddings = sum_embeddings / sum_mask

            # L2 normalize
            norms = np.linalg.norm(sentence_embeddings, axis=1, keepdims=True)
            norms = np.clip(norms, a_min=1e-12, a_max=None)
            sentence_embeddings = sentence_embeddings / norms

            embeddings.extend(sentence_embeddings.tolist())

        processing_time = (time.time() - start_time) * 1000

        return EmbedResponse(
            embeddings=embeddings,
            dimensions=len(embeddings[0]) if embeddings else 384,
            model_name="sentence-transformers/all-MiniLM-L6-v2",
            processing_time_ms=round(processing_time, 2),
        )

    except Exception as e:
        logger.error(f"Embedding failed: {e}", exc_info=True)
        raise HTTPException(status_code=500, detail=str(e))


def signal_handler(sig, frame):
    """Clean shutdown handler."""
    logger.info("Shutdown signal received, cleaning up...")
    sys.exit(0)


if __name__ == "__main__":
    import uvicorn

    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)

    uvicorn.run(app, host="127.0.0.1", port=PORT, log_level="info")
