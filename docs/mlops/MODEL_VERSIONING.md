# Model Registry and Artifact Versioning (TECH-001)

## Overview

Model versioning strategy for P4NTH30N ML components: RAG embeddings, LLM inference, and jackpot prediction experiments.

## Current Models

| Model | Type | Size | Location | Version |
|-------|------|------|----------|---------|
| all-MiniLM-L6-v2 | ONNX embeddings | 80MB | models/ | v1.0 |
| Pleias-RAG-1B | Local LLM | ~3GB | LM Studio | v1.0 |

## Versioning Strategy

### Phase 1: Git LFS (Current)

For models <100MB, use Git LFS:

```bash
# Track model files
git lfs track "models/*.onnx"
git lfs track "models/*.bin"

# .gitattributes
models/*.onnx filter=lfs diff=lfs merge=lfs -text
models/*.bin filter=lfs diff=lfs merge=lfs -text
```

### Phase 2: DVC (When Multiple Experiments)

Data Version Control for experiment reproducibility:

```bash
# Initialize DVC
dvc init

# Track large model files
dvc add models/all-MiniLM-L6-v2.onnx

# Configure local remote storage
dvc remote add -d local C:\P4NTH30N\model-store
```

### Phase 3: MLflow (Post-Revenue)

Full experiment tracking with MLflow:

```yaml
# docker-compose.yml
services:
  mlflow:
    image: mlflow/mlflow
    ports:
      - "5000:5000"
    volumes:
      - ./mlruns:/mlflow/mlruns
    command: mlflow server --host 0.0.0.0 --backend-store-uri sqlite:///mlflow.db
```

## Experiment Tracking

### Metrics to Track

| Experiment | Metrics | Frequency |
|------------|---------|-----------|
| Embedding quality | Spearman correlation, cosine similarity | Per model change |
| Jackpot prediction | Accuracy, precision, recall, F1 | Daily |
| Context retrieval | Precision@k, nDCG | Per query batch |
| LLM response | Latency, token/sec, quality score | Per model change |

### Experiment Naming Convention

```
{date}_{model}_{experiment_type}_{version}
Example: 20260218_miniLM_embedding_quality_v1
```

## Model Lifecycle

```
Development → Validation → Staging → Production
     │              │           │          │
     └─ Git branch  └─ Tests    └─ A/B     └─ Active
```

1. **Development**: Train/fine-tune, track with MLflow
2. **Validation**: Run quality benchmarks, compare to baseline
3. **Staging**: Deploy alongside production for A/B comparison
4. **Production**: Replace current model if staging metrics better

## Rollback Procedure

1. Identify failing model version from MLflow/DVC
2. Checkout previous model version: `dvc checkout models/model.onnx`
3. Restart inference service
4. Verify quality metrics restored
