# ADR-001: Core Systems Architecture (CORE-001)

## Status
**Accepted** — Hybrid Monolithic with Containerization Path

## Context
P4NTHE0N consists of H4ND (automation), H0UND (analytics), and C0MMON (shared library) deployed as separate processes sharing a MongoDB database. Need to lock in the architecture pattern that governs deployment, scaling, and operational complexity.

## Decision
**Maintain hybrid monolithic architecture** with documented containerization migration path.

### Rationale
1. **Simplicity**: Two processes + MongoDB is manageable for current scale
2. **Shared code**: C0MMON library enables code reuse without RPC overhead
3. **Strong consistency**: MongoDB as single source of truth avoids distributed state
4. **Team size**: Single developer — microservices overhead not justified
5. **Performance**: In-process calls to C0MMON are faster than network hops

### Architecture

```
┌─────────────────────────────────────────────────┐
│                   HOST MACHINE                   │
│                                                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────────┐  │
│  │  H0UND   │  │  H4ND    │  │  FourEyes    │  │
│  │ (polling) │  │ (auto)   │  │ (W4TCHD0G)   │  │
│  └────┬─────┘  └────┬─────┘  └──────┬───────┘  │
│       │              │               │           │
│       └──────┬───────┘               │           │
│              │                       │           │
│       ┌──────┴──────┐        ┌──────┴───────┐   │
│       │   C0MMON    │        │   Synergy    │   │
│       │  (shared)   │        │   (input)    │   │
│       └──────┬──────┘        └──────┬───────┘   │
│              │                      │            │
│       ┌──────┴──────┐        ┌──────┴───────┐   │
│       │   MongoDB   │        │   VM (exec)  │   │
│       │  P4NTHE0N   │        │   Chrome+OBS │   │
│       └─────────────┘        └──────────────┘   │
└─────────────────────────────────────────────────┘
```

### Deployment Model
- **Current**: Separate .NET executables on same Windows host
- **Data**: Single MongoDB instance (P4NTHE0N database)
- **Communication**: Shared database (no message queues)
- **Configuration**: Shared appsettings.json + environment variables

## Consequences

### Positive
- Simple deployment and debugging
- No container orchestration overhead
- Shared C0MMON library avoids code duplication
- Strong data consistency via MongoDB

### Negative
- Cannot scale H4ND/H0UND independently
- Single host = single point of failure
- Technology locked to .NET/C#

### Risks
- If scale requires >1 host, need to refactor to containers
- MongoDB becomes bottleneck at high query volumes

## Containerization Migration Path

If future scale requires it:

1. **Phase 1**: Dockerize each agent (H0UND, H4ND, FourEyes)
2. **Phase 2**: Docker Compose for local orchestration
3. **Phase 3**: Kubernetes if multi-node required
4. **Prerequisites**: Externalize all config, add health endpoints, remove shared filesystem assumptions

Estimated migration effort: 2-3 weeks when needed. Not needed until >10 concurrent casino sessions.
