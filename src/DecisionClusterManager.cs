using System.Text.Json;
using System.Text.Json.Serialization;

namespace P4NTH30N.SWE;

/// <summary>
/// Manages decision clustering for batch execution within 30-turn session limits.
/// Groups 122 decisions into 20-24 clusters with dependency resolution and priority ordering.
/// </summary>
public sealed class DecisionClusterManager {
	private readonly List<Decision> _decisions = new();
	private readonly List<DecisionCluster> _clusters = new();
	private readonly int _maxDecisionsPerCluster;
	private readonly int _maxTurnsPerSession;

	public IReadOnlyList<DecisionCluster> Clusters => _clusters.AsReadOnly();
	public int TotalDecisions => _decisions.Count;
	public int TotalClusters => _clusters.Count;

	public DecisionClusterManager(int maxDecisionsPerCluster = 6, int maxTurnsPerSession = 30) {
		_maxDecisionsPerCluster = maxDecisionsPerCluster;
		_maxTurnsPerSession = maxTurnsPerSession;
	}

	/// <summary>
	/// Registers a decision for clustering.
	/// </summary>
	public void AddDecision(Decision decision) {
		if (_decisions.Any(d => d.Id == decision.Id)) return;
		_decisions.Add(decision);
	}

	/// <summary>
	/// Registers multiple decisions.
	/// </summary>
	public void AddDecisions(IEnumerable<Decision> decisions) {
		foreach (Decision decision in decisions) {
			AddDecision(decision);
		}
	}

	/// <summary>
	/// Builds clusters using topological sort of dependency graph then greedy bin-packing.
	/// </summary>
	public List<DecisionCluster> BuildClusters() {
		_clusters.Clear();

		// Topological sort by dependencies
		List<Decision> sorted = TopologicalSort(_decisions);

		// Group into clusters respecting dependencies and size limits
		DecisionCluster? currentCluster = null;
		HashSet<string> completedInPriorClusters = new();

		foreach (Decision decision in sorted) {
			// Check if decision can join current cluster
			bool canJoinCurrent = currentCluster != null &&
				currentCluster.Decisions.Count < _maxDecisionsPerCluster &&
				decision.Dependencies.All(d => completedInPriorClusters.Contains(d) ||
					currentCluster.Decisions.Any(cd => cd.Id == d)) &&
				currentCluster.EstimatedTurns + decision.EstimatedTurns <= _maxTurnsPerSession &&
				currentCluster.Category == decision.Category;

			if (!canJoinCurrent) {
				// Start new cluster
				if (currentCluster != null) {
					_clusters.Add(currentCluster);
					foreach (Decision d in currentCluster.Decisions) {
						completedInPriorClusters.Add(d.Id);
					}
				}

				currentCluster = new DecisionCluster {
					ClusterId = $"CLUSTER-{_clusters.Count + 1:D3}",
					Category = decision.Category,
					Priority = decision.Priority,
				};
			}

			currentCluster!.Decisions.Add(decision);
			currentCluster.EstimatedTurns += decision.EstimatedTurns;
		}

		// Add last cluster
		if (currentCluster != null && currentCluster.Decisions.Count > 0) {
			_clusters.Add(currentCluster);
		}

		// Assign session numbers
		for (int i = 0; i < _clusters.Count; i++) {
			_clusters[i].SessionNumber = i + 1;
		}

		return _clusters;
	}

	/// <summary>
	/// Creates a session plan for executing clusters.
	/// </summary>
	public SessionPlan CreateSessionPlan() {
		if (_clusters.Count == 0) BuildClusters();

		return new SessionPlan {
			TotalClusters = _clusters.Count,
			TotalDecisions = _decisions.Count,
			EstimatedSessions = _clusters.Count,
			EstimatedTotalTurns = _clusters.Sum(c => c.EstimatedTurns),
			Clusters = new List<DecisionCluster>(_clusters),
		};
	}

	/// <summary>
	/// Gets the dependency map as an adjacency list.
	/// </summary>
	public Dictionary<string, List<string>> GetDependencyMap() {
		Dictionary<string, List<string>> map = new();

		foreach (Decision decision in _decisions) {
			map[decision.Id] = new List<string>(decision.Dependencies);
		}

		return map;
	}

	/// <summary>
	/// Generates a context handoff template for transitioning between clusters.
	/// </summary>
	public string GenerateHandoffTemplate(int clusterIndex) {
		if (clusterIndex < 0 || clusterIndex >= _clusters.Count) {
			return "{}";
		}

		DecisionCluster cluster = _clusters[clusterIndex];
		DecisionCluster? nextCluster = clusterIndex + 1 < _clusters.Count
			? _clusters[clusterIndex + 1]
			: null;

		object handoff = new {
			completedCluster = cluster.ClusterId,
			completedDecisions = cluster.Decisions.Select(d => d.Id).ToList(),
			nextCluster = nextCluster?.ClusterId ?? "NONE",
			nextDecisions = nextCluster?.Decisions.Select(d => new {
				id = d.Id,
				title = d.Title,
				estimatedTurns = d.EstimatedTurns,
			}).ToList() ?? new List<object>(),
			dependencies = nextCluster?.Decisions
				.SelectMany(d => d.Dependencies)
				.Distinct()
				.ToList() ?? new List<string>(),
		};

		return JsonSerializer.Serialize(handoff, new JsonSerializerOptions { WriteIndented = true });
	}

	/// <summary>
	/// Topological sort using Kahn's algorithm.
	/// </summary>
	private static List<Decision> TopologicalSort(List<Decision> decisions) {
		Dictionary<string, Decision> lookup = decisions.ToDictionary(d => d.Id);
		Dictionary<string, int> inDegree = decisions.ToDictionary(d => d.Id, _ => 0);

		// Calculate in-degrees
		foreach (Decision decision in decisions) {
			foreach (string dep in decision.Dependencies) {
				if (inDegree.ContainsKey(dep)) {
					// dep is depended upon by this decision - not what we want
					// We need: decisions that depend on dep have higher in-degree
				}
			}
		}

		// Recalculate: in-degree = number of unresolved dependencies
		foreach (Decision decision in decisions) {
			inDegree[decision.Id] = decision.Dependencies.Count(d => lookup.ContainsKey(d));
		}

		Queue<Decision> queue = new();
		foreach (Decision decision in decisions.Where(d => inDegree[d.Id] == 0).OrderBy(d => d.Priority)) {
			queue.Enqueue(decision);
		}

		List<Decision> sorted = new();

		while (queue.Count > 0) {
			Decision current = queue.Dequeue();
			sorted.Add(current);

			// Find decisions that depend on current
			foreach (Decision decision in decisions) {
				if (decision.Dependencies.Contains(current.Id)) {
					inDegree[decision.Id]--;
					if (inDegree[decision.Id] == 0) {
						queue.Enqueue(decision);
					}
				}
			}
		}

		// Add any remaining (circular dependencies) at the end
		foreach (Decision decision in decisions) {
			if (!sorted.Contains(decision)) {
				sorted.Add(decision);
			}
		}

		return sorted;
	}

	/// <summary>
	/// Saves cluster definitions to a directory.
	/// </summary>
	public async Task SaveClustersAsync(string directory, CancellationToken cancellationToken = default) {
		if (!Directory.Exists(directory)) Directory.CreateDirectory(directory);

		JsonSerializerOptions options = new() {
			WriteIndented = true,
			Converters = { new JsonStringEnumConverter() },
		};

		for (int i = 0; i < _clusters.Count; i++) {
			string filePath = Path.Combine(directory, $"{_clusters[i].ClusterId}.json");
			string json = JsonSerializer.Serialize(_clusters[i], options);
			await File.WriteAllTextAsync(filePath, json, cancellationToken);
		}

		// Save session plan
		SessionPlan plan = CreateSessionPlan();
		string planPath = Path.Combine(directory, "SESSION_PLAN.json");
		string planJson = JsonSerializer.Serialize(plan, options);
		await File.WriteAllTextAsync(planPath, planJson, cancellationToken);
	}
}

/// <summary>
/// A single decision to be clustered and executed.
/// </summary>
public sealed class Decision {
	public string Id { get; init; } = string.Empty;
	public string Title { get; init; } = string.Empty;
	public string Category { get; init; } = string.Empty;
	public int Priority { get; init; }
	public List<string> Dependencies { get; init; } = new();
	public int EstimatedTurns { get; init; } = 5;
	public DecisionStatus Status { get; set; } = DecisionStatus.Proposed;
}

/// <summary>
/// A cluster of decisions to execute in a single session.
/// </summary>
public sealed class DecisionCluster {
	public string ClusterId { get; init; } = string.Empty;
	public string Category { get; set; } = string.Empty;
	public int Priority { get; set; }
	public int SessionNumber { get; set; }
	public int EstimatedTurns { get; set; }
	public List<Decision> Decisions { get; init; } = new();
}

/// <summary>
/// Session execution plan across all clusters.
/// </summary>
public sealed class SessionPlan {
	public int TotalClusters { get; init; }
	public int TotalDecisions { get; init; }
	public int EstimatedSessions { get; init; }
	public int EstimatedTotalTurns { get; init; }
	public List<DecisionCluster> Clusters { get; init; } = new();
}

public enum DecisionStatus { Proposed, InProgress, Completed, Blocked, Rejected }
