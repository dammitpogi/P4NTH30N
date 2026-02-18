using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace P4NTH30N.C0MMON.RAG;

/// <summary>
/// Represents a document stored in the RAG vector store.
/// Contains the original text, its vector embedding, and searchable metadata.
/// </summary>
/// <remarks>
/// Documents are stored with embeddings in FAISS (for fast similarity search)
/// and metadata in MongoDB (for filtering, full-text search, and durability).
/// </remarks>
[BsonIgnoreExtraElements]
public class RagDocument
{
	/// <summary>
	/// Unique identifier for this document. Auto-generated if not provided.
	/// </summary>
	[BsonId]
	[BsonRepresentation(BsonType.ObjectId)]
	public string Id { get; set; } = ObjectId.GenerateNewId().ToString();

	/// <summary>
	/// The collection/namespace this document belongs to.
	/// Examples: "signals", "jackpot_patterns", "game_rules", "credential_metadata"
	/// </summary>
	[BsonElement("collection")]
	public string Collection { get; set; } = string.Empty;

	/// <summary>
	/// The original text content that was embedded.
	/// Stored for retrieval and LLM context injection.
	/// </summary>
	[BsonElement("content")]
	public string Content { get; set; } = string.Empty;

	/// <summary>
	/// The vector embedding of the content. 384 dimensions for all-MiniLM-L6-v2.
	/// Stored in FAISS for similarity search; not stored in MongoDB to save space.
	/// </summary>
	[BsonIgnore]
	public float[]? Embedding { get; set; }

	/// <summary>
	/// FAISS internal index position for this document.
	/// Used to correlate FAISS search results back to MongoDB documents.
	/// </summary>
	[BsonElement("faissIndex")]
	public long FaissIndex { get; set; } = -1;

	/// <summary>
	/// Searchable metadata key-value pairs for filtering.
	/// Examples: { "house": "CasinoX", "game": "SlotA", "type": "grand_jackpot" }
	/// </summary>
	[BsonElement("metadata")]
	public Dictionary<string, string> Metadata { get; set; } = new();

	/// <summary>
	/// Source identifier — where this document originated.
	/// Examples: "H0UND:signal", "H4ND:jackpot_read", "manual:import"
	/// </summary>
	[BsonElement("source")]
	public string Source { get; set; } = string.Empty;

	/// <summary>
	/// Timestamp when this document was created/ingested.
	/// </summary>
	[BsonElement("createdAt")]
	public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

	/// <summary>
	/// Timestamp when this document's embedding was last updated.
	/// </summary>
	[BsonElement("embeddedAt")]
	public DateTime? EmbeddedAt { get; set; }

	/// <summary>
	/// BM25-searchable keywords extracted from the content.
	/// Used for hybrid search (vector + keyword).
	/// </summary>
	[BsonElement("keywords")]
	public List<string> Keywords { get; set; } = new();
}
