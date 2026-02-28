# C0MMON Component Guide

Shared library — The foundation of P4NTHE0N providing cross-cutting concerns.

## Overview

C0MMON is the shared kernel that all other components depend on. It provides data persistence, domain logic, infrastructure services, LLM integration, RAG capabilities, security, and utilities following Clean Architecture and DDD principles.

### Responsibilities

- **Data Persistence**: MongoDB access via Repository pattern
- **Domain Logic**: Entities, value objects, validation
- **Infrastructure**: Caching, configuration, monitoring
- **Security**: Encryption, key management
- **AI Integration**: LLM client, RAG system
- **Utilities**: Helper functions, extensions

## Architecture

```
C0MMON/
├── Domain/
│   └── (future migration)
├── Interfaces/
│   ├── IRepoCredentials.cs
│   ├── IRepoSignals.cs
│   ├── IRepoJackpots.cs
│   ├── IRepoHouses.cs
│   ├── IReceiveSignals.cs
│   ├── IStoreEvents.cs
│   └── IStoreErrors.cs
├── Infrastructure/
│   ├── Persistence/
│   │   ├── MongoDatabaseProvider.cs
│   │   ├── MongoUnitOfWork.cs
│   │   ├── Repositories.cs
│   │   └── ValidatedMongoRepository.cs
│   ├── Caching/
│   │   └── CacheService.cs
│   ├── Configuration/
│   │   ├── P4NTHE0NOptions.cs
│   │   ├── ConfigurationExtensions.cs
│   │   └── SecretsProvider.cs
│   ├── Monitoring/
│   │   ├── HealthChecks.cs
│   │   └── MetricsService.cs
│   └── LLM/
│       ├── ILlmClient.cs
│       └── LlmClient.cs
├── RAG/
│   ├── IContextBuilder.cs
│   ├── IEmbeddingService.cs
│   ├── IVectorStore.cs
│   ├── IHybridSearch.cs
│   ├── ContextBuilder.cs
│   ├── EmbeddingService.cs
│   ├── FaissVectorStore.cs
│   └── HybridSearch.cs
├── Security/
│   ├── IEncryptionService.cs
│   ├── IKeyManagement.cs
│   ├── EncryptionService.cs
│   ├── KeyManagement.cs
│   └── EncryptedValue.cs
├── Actions/
│   ├── Login.cs
│   ├── Logout.cs
│   ├── Launch.cs
│   └── Overwrite.cs
├── Games/
│   ├── FireKirin.cs
│   ├── OrionStars.cs
│   └── Gold777.cs
├── Entities/
│   ├── Credential.cs
│   ├── Signal.cs
│   ├── Jackpot.cs
│   ├── ErrorLog.cs
│   └── DPD.cs
├── Support/
│   ├── Thresholds.cs
│   ├── GameSettings.cs
│   └── JackpotValues.cs
├── Services/
│   └── Dashboard.cs
├── EF/
│   └── AnalyticsContext.cs
├── Monitoring/
│   └── DataCorruptionMonitor.cs
└── Utilities/
    └── SafeDateTime.cs
```

## Clean Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    C0MMON Architecture                       │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌─────────────────────────────────────────────────────────┐│
│  │  Presentation Layer (NOT IN C0MMON)                     ││
│  │  - H0UND Dashboard                                      ││
│  │  - PROF3T Console                                       ││
│  └─────────────────────────────────────────────────────────┘│
│                            │                                  │
│                            ▼                                  │
│  ┌─────────────────────────────────────────────────────────┐│
│  │  Application Layer                                      ││
│  │  - Actions (Login, Logout, Launch)                      ││
│  │  - Services (Dashboard)                                 ││
│  └─────────────────────────────────────────────────────────┘│
│                            │                                  │
│                            ▼                                  │
│  ┌─────────────────────────────────────────────────────────┐│
│  │  Domain Layer                                           ││
│  │  - Entities (Credential, Signal, Jackpot)               ││
│  │  - Value Objects (Thresholds, DPD, JackpotValues)       ││
│  │  - Support (GameSettings)                               ││
│  └─────────────────────────────────────────────────────────┘│
│                            │                                  │
│                            ▼                                  │
│  ┌─────────────────────────────────────────────────────────┐│
│  │  Infrastructure Layer                                   ││
│  │  - Persistence (MongoDB, EF)                            ││
│  │  - Caching (CacheService)                               ││
│  │  - Configuration (Options, Secrets)                     ││
│  │  - Monitoring (Health, Metrics)                         ││
│  │  - LLM (LlmClient)                                      ││
│  │  - RAG (Embeddings, VectorStore)                        ││
│  │  - Security (Encryption, KeyManagement)                 ││
│  └─────────────────────────────────────────────────────────┘│
│                            │                                  │
│                            ▼                                  │
│  ┌─────────────────────────────────────────────────────────┐│
│  │  Interfaces Layer (Contracts)                           ││
│  │  - IRepo* (Repository contracts)                        ││
│  │  - IStore* (Store contracts)                            ││
│  │  - IReceive* (Receiver contracts)                       ││
│  └─────────────────────────────────────────────────────────┘│
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

## Repository Pattern

### Interface Definition
```csharp
// C0MMON/Interfaces/IRepoCredentials.cs
public interface IRepoCredentials
{
    Task<Credential> GetAsync(string id);
    Task<Credential> GetByUsernameAsync(string username);
    Task<IEnumerable<Credential>> GetActiveAsync();
    Task AddAsync(Credential credential);
    Task UpdateAsync(Credential credential);
    Task DeleteAsync(string id);
    Task<bool> ExistsAsync(string id);
}
```

### Implementation
```csharp
// C0MMON/Infrastructure/Persistence/Repositories.cs
public class CredentialsRepository : ValidatedMongoRepository<Credential>, IRepoCredentials
{
    public CredentialsRepository(IMongoDatabase database, IStoreErrors errorStore)
        : base(database, "CRED3N7IAL", errorStore)
    {
    }
    
    public async Task<Credential> GetByUsernameAsync(string username)
    {
        return await _collection
            .Find(c => c.Id == username)
            .FirstOrDefaultAsync();
    }
    
    public async Task<IEnumerable<Credential>> GetActiveAsync()
    {
        return await _collection
            .Find(c => c.Enabled && !c.Banned)
            .ToListAsync();
    }
}
```

### Unit of Work Pattern
```csharp
// C0MMON/Infrastructure/Persistence/MongoUnitOfWork.cs
public class MongoUnitOfWork : IMongoUnitOfWork
{
    private readonly IMongoDatabase _database;
    private readonly IStoreErrors _errorStore;
    private readonly IClientSessionHandle _session;
    
    public IRepoCredentials Credentials { get; }
    public IRepoSignals Signals { get; }
    public IRepoJackpots Jackpots { get; }
    public IRepoHouses Houses { get; }
    public IStoreEvents Events { get; }
    public IStoreErrors Errors { get; }
    
    public MongoUnitOfWork(IMongoDatabase database, IStoreErrors errorStore)
    {
        _database = database;
        _errorStore = errorStore;
        
        // Initialize repositories
        Credentials = new CredentialsRepository(database, errorStore);
        Signals = new SignalsRepository(database, errorStore);
        Jackpots = new JackpotsRepository(database, errorStore);
        Houses = new HousesRepository(database, errorStore);
        Events = new ProcessEventRepository(database);
        Errors = errorStore;
    }
    
    public async Task<IClientSessionHandle> StartTransactionAsync()
    {
        _session = await _database.Client.StartSessionAsync();
        _session.StartTransaction();
        return _session;
    }
    
    public async Task CommitAsync()
    {
        if (_session != null && _session.IsInTransaction)
        {
            await _session.CommitTransactionAsync();
        }
    }
    
    public async Task RollbackAsync()
    {
        if (_session != null && _session.IsInTransaction)
        {
            await _session.AbortTransactionAsync();
        }
    }
    
    public void Dispose()
    {
        _session?.Dispose();
    }
}
```

## Validation Pattern

### Entity Validation
```csharp
// C0MMON/Entities/Credential.cs
public class Credential
{
    public string Id { get; set; }
    public string Username { get; set; }
    public string Password { get; set; } // Encrypted
    public string House { get; set; }
    public double Balance { get; set; }
    public bool Enabled { get; set; }
    public bool Banned { get; set; }
    public JackpotValues Jackpots { get; set; }
    public Thresholds Thresholds { get; set; }
    public DPD DPD { get; set; }
    public GameSettings Settings { get; set; }
    
    public bool IsValid(IStoreErrors? errorStore = null)
    {
        bool isValid = true;
        
        // Required fields
        if (string.IsNullOrEmpty(Id))
        {
            errorStore?.LogError($"[{nameof(Credential)}] Id is null or empty");
            isValid = false;
        }
        
        if (string.IsNullOrEmpty(Password))
        {
            errorStore?.LogError($"[{nameof(Credential)}] Password is null or empty");
            isValid = false;
        }
        
        if (string.IsNullOrEmpty(House))
        {
            errorStore?.LogError($"[{nameof(Credential)}] House is null or empty");
            isValid = false;
        }
        
        // Balance validation
        if (double.IsNaN(Balance) || double.IsInfinity(Balance))
        {
            errorStore?.LogError($"[{Id}] Balance is NaN or Infinity");
            isValid = false;
        }
        
        if (Balance < 0)
        {
            errorStore?.LogError($"[{Id}] Balance is negative: {Balance}");
            isValid = false;
        }
        
        // Jackpot validation
        if (Jackpots != null)
        {
            if (double.IsNaN(Jackpots.Grand) || Jackpots.Grand < 0)
            {
                errorStore?.LogError($"[{Id}] Grand jackpot invalid");
                isValid = false;
            }
        }
        
        return isValid;
    }
}
```

### Validated Repository Base
```csharp
// C0MMON/Infrastructure/Persistence/ValidatedMongoRepository.cs
public abstract class ValidatedMongoRepository<T> where T : class
{
    protected readonly IMongoCollection<T> _collection;
    protected readonly IStoreErrors _errorStore;
    
    protected ValidatedMongoRepository(
        IMongoDatabase database, 
        string collectionName,
        IStoreErrors errorStore)
    {
        _collection = database.GetCollection<T>(collectionName);
        _errorStore = errorStore;
    }
    
    public virtual async Task AddAsync(T entity)
    {
        // Validate before insert
        if (entity is IValidatable validatable)
        {
            if (!validatable.IsValid(_errorStore))
            {
                throw new ValidationException($"Entity validation failed for {typeof(T).Name}");
            }
        }
        
        await _collection.InsertOneAsync(entity);
    }
    
    public virtual async Task UpdateAsync(T entity)
    {
        // Validate before update
        if (entity is IValidatable validatable)
        {
            if (!validatable.IsValid(_errorStore))
            {
                throw new ValidationException($"Entity validation failed for {typeof(T).Name}");
            }
        }
        
        var id = GetEntityId(entity);
        await _collection.ReplaceOneAsync(
            Builders<T>.Filter.Eq("_id", id),
            entity);
    }
}
```

## Security (AES-256-GCM)

### Encryption Service
```csharp
// C0MMON/Security/EncryptionService.cs
public class EncryptionService : IEncryptionService
{
    private readonly IKeyManagement _keyManagement;
    
    public EncryptionService(IKeyManagement keyManagement)
    {
        _keyManagement = keyManagement;
    }
    
    public string EncryptToString(string plaintext)
    {
        // Generate random nonce (12 bytes for GCM)
        byte[] nonce = new byte[12];
        RandomNumberGenerator.Fill(nonce);
        
        // Get encryption key
        byte[] key = _keyManagement.GetEncryptionKey();
        
        // Encrypt
        byte[] plaintextBytes = Encoding.UTF8.GetBytes(plaintext);
        byte[] ciphertext = new byte[plaintextBytes.Length];
        byte[] tag = new byte[16];
        
        using (var aes = new AesGcm(key, 16))
        {
            aes.Encrypt(nonce, plaintextBytes, ciphertext, tag);
        }
        
        // Format: base64(nonce):base64(ciphertext):base64(tag)
        return $"{Convert.ToBase64String(nonce)}:{Convert.ToBase64String(ciphertext)}:{Convert.ToBase64String(tag)}";
    }
    
    public string DecryptFromString(string encryptedValue)
    {
        // Parse components
        var parts = encryptedValue.Split(':');
        if (parts.Length != 3)
            throw new FormatException("Invalid encrypted value format");
        
        byte[] nonce = Convert.FromBase64String(parts[0]);
        byte[] ciphertext = Convert.FromBase64String(parts[1]);
        byte[] tag = Convert.FromBase64String(parts[2]);
        
        // Get encryption key
        byte[] key = _keyManagement.GetEncryptionKey();
        
        // Decrypt
        byte[] plaintextBytes = new byte[ciphertext.Length];
        
        using (var aes = new AesGcm(key, 16))
        {
            aes.Decrypt(nonce, ciphertext, tag, plaintextBytes);
        }
        
        return Encoding.UTF8.GetString(plaintextBytes);
    }
}
```

### Key Management
```csharp
// C0MMON/Security/KeyManagement.cs
public class KeyManagement : IKeyManagement
{
    private readonly string _masterKeyPath;
    private byte[]? _masterKey;
    
    public KeyManagement(string masterKeyPath)
    {
        _masterKeyPath = masterKeyPath;
    }
    
    public byte[] GetMasterKey()
    {
        if (_masterKey != null)
            return _masterKey;
        
        if (!File.Exists(_masterKeyPath))
        {
            throw new FileNotFoundException(
                $"Master key not found at {_masterKeyPath}. " +
                "Run scripts/security/generate-master-key.ps1");
        }
        
        // Read and decrypt master key
        string encryptedKey = File.ReadAllText(_masterKeyPath);
        _masterKey = Convert.FromBase64String(encryptedKey);
        
        return _masterKey;
    }
    
    public byte[] GetEncryptionKey()
    {
        var masterKey = GetMasterKey();
        
        // Derive encryption key using HKDF
        return HKDF.DeriveKey(
            hashAlgorithmName: HashAlgorithmName.SHA256,
            ikm: masterKey,
            outputLength: 32,
            salt: Encoding.UTF8.GetBytes("P4NTHE0N"),
            info: Encoding.UTF8.GetBytes("encryption-v1"));
    }
}
```

## LLM Integration

### LLM Client
```csharp
// C0MMON/LLM/LlmClient.cs
public class LlmClient : ILlmClient
{
    private readonly HttpClient _httpClient;
    private readonly string _baseUrl;
    
    public LlmClient(string baseUrl = "http://localhost:1234")
    {
        _baseUrl = baseUrl;
        _httpClient = new HttpClient();
        _httpClient.Timeout = TimeSpan.FromSeconds(30);
    }
    
    public async Task<LlmResponse> CompleteAsync(LlmRequest request)
    {
        var payload = new
        {
            model = request.Model,
            messages = new[]
            {
                new { role = "user", content = request.Prompt }
            },
            max_tokens = request.MaxTokens,
            temperature = request.Temperature
        };
        
        var response = await _httpClient.PostAsJsonAsync(
            $"{_baseUrl}/v1/chat/completions", 
            payload);
        
        response.EnsureSuccessStatusCode();
        
        var result = await response.Content.ReadFromJsonAsync<LlmApiResponse>();
        
        return new LlmResponse
        {
            Text = result.Choices[0].Message.Content,
            TokensUsed = result.Usage.TotalTokens,
            Confidence = result.Choices[0].FinishReason == "stop" ? 0.95 : 0.7
        };
    }
}
```

## RAG System

### Retrieval-Augmented Generation Flow
```csharp
// C0MMON/RAG/HybridSearch.cs
public class HybridSearch : IHybridSearch
{
    private readonly IEmbeddingService _embeddingService;
    private readonly IVectorStore _vectorStore;
    private readonly IContextBuilder _contextBuilder;
    
    public async Task<SearchResult> SearchAsync(string query, int topK = 5)
    {
        // 1. Generate query embedding
        var queryEmbedding = await _embeddingService.GenerateAsync(query);
        
        // 2. Vector search (semantic similarity)
        var vectorResults = await _vectorStore.SearchAsync(queryEmbedding, topK * 2);
        
        // 3. Keyword search (exact match)
        var keywordResults = await _vectorStore.KeywordSearchAsync(query, topK * 2);
        
        // 4. Hybrid scoring
        var combined = MergeResults(vectorResults, keywordResults);
        
        // 5. Return top K
        return new SearchResult
        {
            Documents = combined.Take(topK).ToList(),
            Query = query,
            TotalResults = combined.Count
        };
    }
    
    private List<RagDocument> MergeResults(
        List<RagDocument> vectorResults,
        List<RagDocument> keywordResults)
    {
        // Reciprocal Rank Fusion
        var scores = new Dictionary<string, double>();
        
        // Score vector results
        for (int i = 0; i < vectorResults.Count; i++)
        {
            scores[vectorResults[i].Id] = 1.0 / (60 + i + 1);
        }
        
        // Score keyword results
        for (int i = 0; i < keywordResults.Count; i++)
        {
            if (scores.ContainsKey(keywordResults[i].Id))
            {
                scores[keywordResults[i].Id] += 1.0 / (60 + i + 1);
            }
            else
            {
                scores[keywordResults[i].Id] = 1.0 / (60 + i + 1);
            }
        }
        
        // Sort by combined score
        return scores
            .OrderByDescending(s => s.Value)
            .Select(s => vectorResults.FirstOrDefault(d => d.Id == s.Key) 
                ?? keywordResults.First(d => d.Id == s.Key))
            .ToList();
    }
}
```

## Caching

### Cache Service
```csharp
// C0MMON/Infrastructure/Caching/CacheService.cs
public class CacheService : ICacheService
{
    private readonly IMemoryCache _memoryCache;
    private readonly TimeSpan _defaultExpiration;
    
    public CacheService(TimeSpan? defaultExpiration = null)
    {
        _memoryCache = new MemoryCache(new MemoryCacheOptions());
        _defaultExpiration = defaultExpiration ?? TimeSpan.FromMinutes(5);
    }
    
    public T? Get<T>(string key)
    {
        if (_memoryCache.TryGetValue(key, out T? value))
        {
            return value;
        }
        return default;
    }
    
    public void Set<T>(string key, T value, TimeSpan? expiration = null)
    {
        var options = new MemoryCacheEntryOptions()
            .SetAbsoluteExpiration(expiration ?? _defaultExpiration);
        
        _memoryCache.Set(key, value, options);
    }
    
    public void Remove(string key)
    {
        _memoryCache.Remove(key);
    }
    
    public bool TryGetValue<T>(string key, out T? value)
    {
        return _memoryCache.TryGetValue(key, out value);
    }
}
```

## Usage Examples

### Repository Usage
```csharp
// Inject via constructor
public class MyService
{
    private readonly IMongoUnitOfWork _unitOfWork;
    
    public MyService(IMongoUnitOfWork unitOfWork)
    {
        _unitOfWork = unitOfWork;
    }
    
    public async Task<Credential> GetCredentialAsync(string username)
    {
        return await _unitOfWork.Credentials.GetByUsernameAsync(username);
    }
}
```

### Encryption Usage
```csharp
// Encrypt sensitive data
var keyMgmt = new KeyManagement(@"C:\ProgramData\P4NTHE0N\master.key");
var encryption = new EncryptionService(keyMgmt);

string encrypted = encryption.EncryptToString("sensitive data");
string decrypted = encryption.DecryptFromString(encrypted);
```

### LLM Usage
```csharp
// Query LLM
var llm = new LlmClient("http://localhost:1234");
var response = await llm.CompleteAsync(new LlmRequest
{
    Model = "mistral-7b",
    Prompt = "Analyze this jackpot data...",
    MaxTokens = 500
});
```

## Global Usings

```csharp
// C0MMON/GlobalUsings.cs
global using P4NTHE0N.C0MMON.Interfaces;
global using P4NTHE0N.C0MMON.Infrastructure.Persistence;
global using MongoDB.Driver;
global using System.Text.Json;
```

## Testing

See [UNI7T35T tests](../../UNI7T35T/) for examples of testing C0MMON components:
- Mock repositories
- Encryption service tests
- Repository pattern tests

---

**Related**: [API Reference](../../api-reference/) | [Data Models](../../data-models/) | [H0UND Component](../H0UND/) | [H4ND Component](../H4ND/)
