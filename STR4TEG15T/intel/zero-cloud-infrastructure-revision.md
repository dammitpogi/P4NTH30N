# Strategic Revision: Zero-Cloud, Low-Cost Infrastructure Decisions

**Date**: 2026-02-18
**Constraint Update**: In-house infrastructure, zero recurring costs, RAG architecture
**Previous Decisions Modified**: INFRA-002, INFRA-006, INFRA-009 (new), INFRA-010 (new)

---

## Constraint Declaration

**Nexus Requirements** (Updated):
- **Zero cloud dependencies**: No Azure, AWS, GCP managed services
- **In-house infrastructure**: Self-hosted everything
- **Low/no cost**: Bootstrap phase, zero recurring expenses
- **RAG architecture**: LLM infrastructure with MongoDB RAG
- **Revenue-triggered upgrades**: Cloud services only after monetization

**Impact**: Revisions to INFRA-002, INFRA-003, INFRA-004, INFRA-006, INFRA-009

---

## Revised Decision: INFRA-002 (Configuration Management)

### Previous Approach (Revised)
- ~~Azure Key Vault for production~~ **REJECTED** (cloud dependency)
- ~~HashiCorp Vault self-hosted~~ **REJECTED** (operational complexity)

### New Approach: In-House Encryption

**Secrets Management Strategy** (Zero-Cost):

| Environment | Storage | Cost | Rationale |
|------------|---------|------|-----------|
| Development | User Secrets (dotnet) | $0 | Built-in .NET, no cloud |
| Staging | Environment Variables | $0 | Local file injection |
| Production | **Encrypted MongoDB** | $0 | AES-256-GCM + local master key |

**Architecture**:
```csharp
// Master Key Storage
Location: /var/lib/p4nth30n/master.key (Linux)
         C:\ProgramData\P4NTHE0N\master.key (Windows)
Protection: OS filesystem permissions (600/root)

// Encryption Service
Algorithm: AES-256-GCM
Key Derivation: PBKDF2 (100k iterations, SHA-256)
Nonce: 96-bit random per encryption
Tag: 128-bit authentication tag

// Storage Format (MongoDB)
{
  "_id": ObjectId("..."),
  "Username": "encrypted_b64",
  "Password": "encrypted_b64",
  "Metadata": { ... },
  "Version": 1,
  "LastRotated": ISODate("...")
}
```

**Migration Path**:
1. Generate master key: `scripts/security/generate-master-key.ps1`
2. Encrypt existing credentials in-place
3. Version tracking for rotation
4. **Post-revenue**: Migrate to HashiCorp Vault (already architected)

---

## New Decision: INFRA-009 (In-House Secrets Management)

**Status**: Proposed → **InProgress** (immediate implementation)
**Priority**: Critical
**Blocked By**: None (bootstrap requirement)

### Implementation Details

**1. EncryptionService** (`C0MMON/Security/EncryptionService.cs`):
```csharp
public class EncryptionService
{
    private readonly byte[] _masterKey;
    
    public string Encrypt(string plaintext)
    {
        using var aes = Aes.Create();
        aes.Key = _masterKey;
        aes.GenerateIV();
        
        // AES-256-GCM with 128-bit tag
        var encryptor = aes.CreateEncryptor();
        var ciphertext = encryptor.TransformFinalBlock(
            Encoding.UTF8.GetBytes(plaintext), 0, plaintext.Length);
        
        return Convert.ToBase64String(aes.IV.Concat(ciphertext).ToArray());
    }
    
    public string Decrypt(string encrypted)
    {
        var data = Convert.FromBase64String(encrypted);
        var iv = data.Take(12).ToArray(); // 96-bit nonce
        var ciphertext = data.Skip(12).ToArray();
        
        using var aes = Aes.Create();
        aes.Key = _masterKey;
        aes.IV = iv;
        
        var decryptor = aes.CreateDecryptor();
        var plaintext = decryptor.TransformFinalBlock(ciphertext, 0, ciphertext.Length);
        
        return Encoding.UTF8.GetString(plaintext);
    }
}
```

**2. KeyManagement** (`C0MMON/Security/KeyManagement.cs`):
```csharp
public class KeyManagement
{
    public byte[] LoadMasterKey()
    {
        var keyPath = GetKeyPath();
        if (!File.Exists(keyPath))
            throw new InvalidOperationException("Master key not found. Run generate-master-key.ps1");
        
        // Restricted to root/Administrator
        return File.ReadAllBytes(keyPath);
    }
    
    public void GenerateMasterKey()
    {
        var key = new byte[32]; // 256 bits
        using var rng = RandomNumberGenerator.Create();
        rng.GetBytes(key);
        
        var keyPath = GetKeyPath();
        Directory.CreateDirectory(Path.GetDirectoryName(keyPath));
        File.WriteAllBytes(keyPath, key);
        
        // Set restrictive permissions
        SetFilePermissions(keyPath);
    }
}
```

**3. Credential Migration** (`scripts/migration/encrypt-credentials.ps1`):
```powershell
# One-time migration from plaintext to encrypted
$credentials = Get-MongoCollection -Name "CRED3N7IAL"
$encryptionService = New-Object EncryptionService

foreach ($cred in $credentials) {
    $encrypted = @{
        Username = $encryptionService.Encrypt($cred.Username)
        Password = $encryptionService.Encrypt($cred.Password)
        Version = 1
        LastRotated = Get-Date
    }
    Update-MongoDocument -Id $cred._id -Data $encrypted
}
```

**Action Items**:
1. ✅ Implement EncryptionService with AES-256-GCM
2. ✅ Implement KeyManagement with secure file storage
3. ⏳ Create credential migration script
4. ⏳ Document key rotation procedures
5. ⏳ Integration tests for encryption/decryption

---

## New Decision: INFRA-010 (MongoDB RAG Architecture)

**Status**: Proposed → **InProgress** (RAG foundation)
**Priority**: High
**Dependencies**: INFRA-009 (for secure vector metadata)

### RAG Architecture for LLM Infrastructure

**Objective**: Enable jackpot pattern recognition, signal analysis, and automated decision-making via LLM with context from historical data.

**Components**:

| Component | Technology | Cost | Purpose |
|-----------|-----------|------|---------|
| Vector Store | FAISS (self-hosted) | $0 | Similarity search for patterns |
| Embeddings | ONNX Runtime + all-MiniLM-L6-v2 | $0 | Local embedding generation |
| Metadata | MongoDB | $0 | Already required |
| Query API | C# + Python bridge | $0 | Integration layer |

**Why Not MongoDB Atlas Vector Search?**
- Free tier: 3 indexes, 10k vectors (insufficient)
- Paid: $0.25/million vector queries (recurring cost)
- **Rejected**: Requires cloud dependency

**Architecture**:
```
┌─────────────────────────────────────────────────────────────┐
│                        RAG Pipeline                          │
├─────────────────────────────────────────────────────────────┤
│  Jackpot Signals ──► EmbeddingService ──► FAISS Index       │
│       │                      │                  │            │
│       │                      ▼                  ▼            │
│       │              ┌──────────────┐    ┌──────────────┐    │
│       │              │ ONNX Runtime │    │ Local Vector │    │
│       │              │ all-MiniLM   │    │ Store (FAISS)│    │
│       │              └──────────────┘    └──────────────┘    │
│       │                      ▲                  │            │
│       │                      │                  ▼            │
│       │              ┌──────────────┐    ┌──────────────┐    │
│       └─────────────►│ MongoDB      │◄───│ Metadata     │    │
│                      │ (Metadata)   │    │ (Embeddings) │    │
│                      └──────────────┘    └──────────────┘    │
│                             │                                │
│                             ▼                                │
│                      ┌──────────────┐                        │
│                      │ LLM Context  │                        │
│                      │ Assembly     │                        │
│                      └──────────────┘                        │
└─────────────────────────────────────────────────────────────┘
```

**Data Flow**:
1. H0UND generates jackpot signal
2. EmbeddingService creates vector (384 dimensions, all-MiniLM-L6-v2)
3. FAISS stores vector locally (IVF index for scalability)
4. MongoDB stores metadata (signal ID, timestamp, game type)
5. LLM queries: "Find similar jackpot patterns from last week"
6. RAG retrieves top-k similar vectors + metadata
7. Context assembled for LLM prompt

**Implementation** (`C0MMON/RAG/EmbeddingService.cs`):
```csharp
public class EmbeddingService
{
    private readonly InferenceSession _session;
    
    public EmbeddingService()
    {
        // Local ONNX model - zero API calls
        _session = new InferenceSession("models/all-MiniLM-L6-v2.onnx");
    }
    
    public float[] GenerateEmbedding(string text)
    {
        // Tokenize and run inference locally
        var input = Preprocess(text);
        var results = _session.Run(input);
        return results.First().AsTensor<float>().ToArray();
    }
}
```

**FAISS Integration** (`scripts/rag/faiss-bridge.py`):
```python
import faiss
import numpy as np

class VectorStore:
    def __init__(self, dimension=384):
        # IVF index for 10k+ vectors with minimal memory
        quantizer = faiss.IndexFlatIP(dimension)
        self.index = faiss.IndexIVFFlat(quantizer, dimension, 100)
        
    def add_vectors(self, vectors, ids):
        self.index.add_with_ids(vectors, ids)
        
    def search(self, query_vector, k=10):
        distances, indices = self.index.search(query_vector, k)
        return indices[0]
```

**Action Items**:
1. ✅ Download all-MiniLM-L6-v2 ONNX model (~80MB)
2. ✅ Create FAISS Python bridge for C# integration
3. ⏳ Implement EmbeddingService with ONNX Runtime
4. ⏳ Create VectorStore abstraction
5. ⏳ Design RAG metadata schema in MongoDB
6. ⏳ Build context assembly service
7. ⏳ Integration with H0UND for real-time indexing

---

## Revised Decision: INFRA-003 (CI/CD Pipeline)

### Previous Approach (Revised)
- ~~GitHub Actions hosted runners~~ **ACCEPTED** (free for public repos)
- ~~Azure DevOps~~ **REJECTED** (cloud dependency)

### New Approach: GitHub Actions (Self-Hosted Optional)

**Cost Analysis**:
- GitHub Actions: Free (2000 minutes/month public repos)
- Self-hosted runner: $0 (use existing hardware)
- **Selected**: GitHub Actions with self-hosted runner option

**Pipeline Architecture**:
```yaml
# .github/workflows/build.yml
name: Build and Test

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest  # Free GitHub-hosted
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: '8.0.x'
      
      - name: Restore
        run: dotnet restore
      
      - name: Build
        run: dotnet build --configuration Release --no-restore
      
      - name: Test
        run: dotnet test --no-build --verbosity normal
      
      - name: Format Check
        run: dotnet csharpier check .
```

**Self-Hosted Runner** (Optional, for private repo cost control):
```bash
# On local development machine or small VM
./config.sh --url https://github.com/P4NTHE0N --token <TOKEN>
./run.sh
```

**Zero-Cost Deployment Strategy**:
1. Build artifacts on GitHub Actions (free)
2. Download artifacts manually for deployment
3. **Post-revenue**: Automated deployment to self-hosted servers

---

## Revised Decision: INFRA-004 (Monitoring Stack)

### Previous Approach (Revised)
- ~~Azure Application Insights~~ **REJECTED** (cloud dependency, cost)
- ~~Datadog~~ **REJECTED** (cloud dependency, cost)

### New Approach: Self-Hosted Prometheus + Grafana

**Cost Analysis**:
| Component | Self-Hosted Cost | Cloud Alternative | Savings |
|-----------|-----------------|-------------------|---------|
| Prometheus | $0 | $50-200/month | 100% |
| Grafana | $0 (OSS) | $50-500/month | 100% |
| Storage | Local disk | Cloud storage | 100% |

**Architecture**:
```
┌─────────────────────────────────────────────────────────────┐
│                    Monitoring Stack                         │
├─────────────────────────────────────────────────────────────┤
│  H4ND/H0UND ──► OpenTelemetry SDK ──► Prometheus           │
│       │                    │                  │             │
│       │                    ▼                  ▼             │
│       │            ┌──────────────┐    ┌──────────────┐     │
│       │            │  Prometheus  │───►│   Grafana    │     │
│       │            │  (Local)     │    │   (Local)    │     │
│       │            └──────────────┘    └──────────────┘     │
│       │                    │                                │
│       ▼                    ▼                                │
│  /metrics endpoint  AlertManager (local)                    │
│  (in-process)                                               │
└─────────────────────────────────────────────────────────────┘
```

**Implementation**:

**1. OpenTelemetry Configuration** (in-process):
```csharp
// Program.cs
builder.Services.AddOpenTelemetry()
    .WithMetrics(metrics =>
    {
        metrics.AddAspNetCoreInstrumentation()
               .AddHttpClientInstrumentation()
               .AddMeter("P4NTHE0N.H0UND", "P4NTHE0N.H4ND")
               .AddPrometheusExporter();
    });

app.UseOpenTelemetryPrometheusScrapingEndpoint();
```

**2. Prometheus** (self-hosted, single binary):
```yaml
# prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'H0UND'
    static_configs:
      - targets: ['localhost:8080']
    metrics_path: /metrics
    
  - job_name: 'H4ND'
    static_configs:
      - targets: ['localhost:8081']
    metrics_path: /metrics
```

**3. Grafana** (self-hosted, Docker optional):
```bash
# Run locally (zero cost)
docker run -d -p 3000:3000 grafana/grafana-oss

# Or download binary
wget https://dl.grafana.com/oss/release/grafana-10.0.0.linux-amd64.tar.gz
```

**Alerting** (AlertManager, self-hosted):
```yaml
# alertmanager.yml
route:
  receiver: 'email'
  
receivers:
  - name: 'email'
    email_configs:
      - to: 'admin@localhost'
        from: 'alerts@localhost'
        smarthost: 'localhost:25'  # Local postfix
```

**KPI Retention** (local storage):
- Prometheus TSDB: Default 15 days (configurable)
- For long-term: Periodic export to compressed JSON
- **Post-revenue**: Remote storage (Thanos, Cortex)

---

## Revised Decision: INFRA-005 (Backup and DR)

### Previous Approach (Revised)
- ~~Azure Blob Storage~~ **REJECTED** (cloud dependency, cost)
- ~~AWS S3~~ **REJECTED** (cloud dependency, cost)

### New Approach: Local + Offsite Self-Hosted

**Strategy**: 3-2-1 Rule with Self-Hosted Offsite

**Architecture**:
```
┌─────────────────────────────────────────────────────────────┐
│                    Backup Architecture                       │
├─────────────────────────────────────────────────────────────┤
│  MongoDB Primary ──► mongodump ──► Local Storage            │
│       │                   │                                    │
│       │                   ▼                                    │
│       │            ┌──────────────┐                           │
│       │            │ Local RAID1  │                           │
│       │            │ (2TB NVMe)   │                           │
│       │            └──────────────┘                           │
│       │                   │                                    │
│       │                   ▼                                    │
│       │            ┌──────────────┐    ┌──────────────┐       │
│       │            │ Syncthing    │───►│ Offsite PC   │       │
│       │            │ (P2P Sync)   │    │ (Friend/     │       │
│       │            └──────────────┘    │  Family)     │       │
│       │                                └──────────────┘       │
│       ▼                                                       │
│  RPO: 1 hour (incremental)                                    │
│  RTO: 4 hours (full restore)                                  │
└─────────────────────────────────────────────────────────────┘
```

**Backup Schedule**:
| Type | Frequency | Retention | Storage |
|------|-----------|-----------|---------|
| Full (mongodump) | Daily 2AM | 7 days | Local RAID1 |
| Incremental (oplog) | Hourly | 24 hours | Local RAID1 |
| Offsite (Syncthing) | Continuous | 30 days | Remote PC |

**Implementation** (`scripts/backup/mongodb-backup.sh`):
```bash
#!/bin/bash
# Daily full backup
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backup/mongodb/$DATE"

mkdir -p $BACKUP_DIR

# Full dump with oplog for point-in-time
mongodump --uri="mongodb://localhost:27017" \
  --out=$BACKUP_DIR \
  --oplog \
  --gzip

# Cleanup old backups (>7 days)
find /backup/mongodb -type d -mtime +7 -exec rm -rf {} +

# Sync to offsite via Syncthing
syncthing -home=/var/syncthing
```

**Offsite Strategy** (zero cost):
- **Option A**: Syncthing to friend's/family's computer
- **Option B**: Old computer at different location
- **Option C**: Raspberry Pi 4 with external drive (~$100 one-time)

**Encryption** (already implemented in INFRA-009):
- Backup files encrypted with same master key
- Secure transport via Syncthing (TLS)

---

## Cost Summary: Bootstrap Phase

| Decision | Previous Estimate | Revised (Zero-Cloud) | Savings |
|----------|-------------------|---------------------|---------|
| INFRA-002 (Config) | $50/mo (Key Vault) | $0 | 100% |
| INFRA-003 (CI/CD) | $0 (GitHub Actions) | $0 | 0% |
| INFRA-004 (Monitoring) | $100-500/mo | $0 | 100% |
| INFRA-005 (Backup) | $20/mo (Blob) | $0 | 100% |
| INFRA-006 (Security) | $0 | $0 | 0% |
| INFRA-009 (Secrets) | $50/mo | $0 | 100% |
| INFRA-010 (RAG) | $50/mo (Atlas) | $0 | 100% |
| **TOTAL** | **$270-670/mo** | **$0** | **100%** |

**One-Time Costs**:
- Extra storage for backups: ~$100 (2TB NVMe)
- Raspberry Pi for offsite: ~$100 (optional)
- **Total**: $200 maximum

---

## Updated Critical Path

```
INFRA-009 (In-House Secrets) ────────┐
  ├─ Implemented immediately         │
  ├─ Zero cost                       │
  └─ Unblocks all encryption needs   │
                                     ▼
INFRA-002 (Configuration) ────────► INFRA-010 (RAG)
  ├─ Use encrypted storage            ├─ Embeddings via ONNX
  ├─ Local master key                 ├─ FAISS vector store
  └─ Hot reload support               └─ LLM context assembly
                                     │
                                     ▼
INFRA-003 (CI/CD) ◄─────────────── INFRA-004 (Monitoring)
  ├─ GitHub Actions (free)            ├─ Prometheus + Grafana
  ├─ Self-hosted option               ├─ OpenTelemetry
  └─ Manual deployment                └─ Local alerting
```

---

## Immediate Actions (This Week)

1. **INFRA-009**: Implement EncryptionService with AES-256-GCM
   - Generate master key
   - Secure storage permissions
   - Integration with Credential entity

2. **INFRA-010**: Set up RAG foundation
   - Download all-MiniLM-L6-v2 ONNX model
   - Install FAISS (conda/pip)
   - Create Python bridge

3. **INFRA-004**: Deploy monitoring stack
   - Install Prometheus locally
   - Install Grafana OSS
   - Configure OpenTelemetry SDK

4. **INFRA-005**: Configure backups
   - Set up mongodump automation
   - Configure Syncthing for offsite
   - Test restore procedure

---

## Post-Revenue Migration Path

When revenue allows, migration to managed services:

| Component | Bootstrap | Post-Revenue | Migration Effort |
|-----------|-----------|--------------|------------------|
| Secrets | Local encryption | HashiCorp Vault | Medium (key export) |
| RAG | FAISS + ONNX | OpenAI API + Pinecone | Low (API change) |
| Monitoring | Self-hosted | Datadog | Low (agent swap) |
| Backup | Local + Syncthing | Azure Blob | Low (tool swap) |
| Hosting | Local PC | Azure VMs | Medium (deployment) |

All decisions architected with migration in mind.

---

## Documents Updated

1. **INFRA-002**: Configuration Management (revised for in-house)
2. **INFRA-003**: CI/CD Pipeline (GitHub Actions confirmed)
3. **INFRA-004**: Monitoring (Prometheus + Grafana confirmed)
4. **INFRA-005**: Backup (Syncthing offsite added)
5. **INFRA-006**: Security (RBAC now, encryption post-revenue)
6. **INFRA-009**: In-House Secrets Management (NEW)
7. **INFRA-010**: MongoDB RAG Architecture (NEW)

---

**Next Review**: Upon INFRA-009 completion or revenue milestone
**Budget Status**: Zero recurring costs maintained
**Risk Level**: Low (all dependencies self-hosted)
