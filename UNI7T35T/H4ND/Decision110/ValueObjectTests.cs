using System;
using P4NTH30N.H4ND.Domains.Automation.ValueObjects;
using P4NTH30N.H4ND.Domains.Common;

namespace P4NTH30N.UNI7T35T.H4ND.Decision110;

/// <summary>
/// DECISION_110: Unit tests for value objects (CorrelationId, SessionId, OperationName, Timestamp)
/// and CorrelationContext + DomainEventEnvelope.
/// </summary>
public static class ValueObjectTests
{
	public static (int passed, int failed) RunAll()
	{
		int passed = 0, failed = 0;

		void Run(string name, Func<bool> test)
		{
			try
			{
				if (test()) { passed++; Console.WriteLine($"  ✅ {name}"); }
				else { failed++; Console.WriteLine($"  ❌ {name} — returned false"); }
			}
			catch (Exception ex) { failed++; Console.WriteLine($"  ❌ {name} — {ex.GetType().Name}: {ex.Message}"); }
		}

		// ── CorrelationId ────────────────────────────────────────────
		Run("VO-001 CorrelationId_New_NotEmpty", () =>
		{
			var id = CorrelationId.New();
			return id.Value != Guid.Empty;
		});

		Run("VO-002 CorrelationId_RejectsEmpty", () =>
		{
			try { _ = new CorrelationId(Guid.Empty); return false; }
			catch (ArgumentException) { return true; }
		});

		Run("VO-003 CorrelationId_Parse_Valid", () =>
		{
			var guid = Guid.NewGuid();
			var id = CorrelationId.Parse(guid.ToString());
			return id.Value == guid;
		});

		Run("VO-004 CorrelationId_Parse_Invalid", () =>
		{
			try { CorrelationId.Parse("not-a-guid"); return false; }
			catch (FormatException) { return true; }
		});

		Run("VO-005 CorrelationId_Equality", () =>
		{
			var guid = Guid.NewGuid();
			var a = new CorrelationId(guid);
			var b = new CorrelationId(guid);
			return a == b && a.Equals(b);
		});

		Run("VO-006 CorrelationId_ImplicitGuid", () =>
		{
			var id = CorrelationId.New();
			Guid g = id;
			return g == id.Value;
		});

		// ── SessionId ────────────────────────────────────────────────
		Run("VO-007 SessionId_New_NotEmpty", () =>
		{
			var id = SessionId.New();
			return !string.IsNullOrWhiteSpace(id.Value) && id.Value.Length <= 128;
		});

		Run("VO-008 SessionId_RejectsNull", () =>
		{
			try { _ = new SessionId(null!); return false; }
			catch (ArgumentException) { return true; }
		});

		Run("VO-009 SessionId_RejectsOverLength", () =>
		{
			try { _ = new SessionId(new string('x', 200)); return false; }
			catch (ArgumentException) { return true; }
		});

		Run("VO-010 SessionId_From_Valid", () =>
		{
			var id = SessionId.From("test-session-123");
			return id.Value == "test-session-123";
		});

		// ── OperationName ────────────────────────────────────────────
		Run("VO-011 OperationName_Valid", () =>
		{
			var op = new OperationName("Login.FireKirin");
			return op.Value == "Login.FireKirin";
		});

		Run("VO-012 OperationName_RejectsEmpty", () =>
		{
			try { _ = new OperationName(""); return false; }
			catch (ArgumentException) { return true; }
		});

		Run("VO-013 OperationName_RejectsInvalidChars", () =>
		{
			try { _ = new OperationName("has spaces"); return false; }
			catch (ArgumentException) { return true; }
		});

		Run("VO-014 OperationName_RejectsTooLong", () =>
		{
			try { _ = new OperationName(new string('A', 65)); return false; }
			catch (ArgumentException) { return true; }
		});

		Run("VO-015 OperationName_AllowsDotsUnderscoresHyphens", () =>
		{
			var op = OperationName.From("Spin_Execute-v2.1");
			return op.Value == "Spin_Execute-v2.1";
		});

		// ── Timestamp ────────────────────────────────────────────────
		Run("VO-016 Timestamp_Now_IsUtc", () =>
		{
			var ts = Timestamp.Now();
			return ts.Value.Kind == DateTimeKind.Utc;
		});

		Run("VO-017 Timestamp_RejectsNonUtc", () =>
		{
			try { _ = new Timestamp(DateTime.Now); return false; }
			catch (ArgumentException) { return true; }
		});

		Run("VO-018 Timestamp_RejectsMinValue", () =>
		{
			try { _ = new Timestamp(DateTime.MinValue); return false; }
			catch (ArgumentException) { return true; }
		});

		Run("VO-019 Timestamp_Elapsed_Positive", () =>
		{
			var ts = Timestamp.From(DateTime.UtcNow.AddSeconds(-5));
			return ts.Elapsed().TotalSeconds >= 4.5;
		});

		Run("VO-020 Timestamp_CompareTo", () =>
		{
			var earlier = Timestamp.From(DateTime.UtcNow.AddMinutes(-1));
			var later = Timestamp.Now();
			return earlier.CompareTo(later) < 0;
		});

		// ── CorrelationContext ────────────────────────────────────────
		Run("VO-021 CorrelationContext_Start_SetsCurrent", () =>
		{
			CorrelationContext.Clear();
			var session = SessionId.New();
			var ctx = CorrelationContext.Start(session);
			bool result = CorrelationContext.Current == ctx
				&& ctx.SessionId == session
				&& ctx.CorrelationId.Value != Guid.Empty;
			CorrelationContext.Clear();
			return result;
		});

		Run("VO-022 CorrelationContext_EnsureCurrent_ThrowsWhenNone", () =>
		{
			CorrelationContext.Clear();
			try { CorrelationContext.EnsureCurrent(); return false; }
			catch (InvalidOperationException) { return true; }
			finally { CorrelationContext.Clear(); }
		});

		Run("VO-023 CorrelationContext_WithOperation", () =>
		{
			CorrelationContext.Clear();
			var ctx = CorrelationContext.Start(SessionId.New());
			ctx.WithOperation(new OperationName("TestOp"));
			bool result = ctx.OperationName?.Value == "TestOp";
			CorrelationContext.Clear();
			return result;
		});

		Run("VO-024 CorrelationContext_WithWorker", () =>
		{
			CorrelationContext.Clear();
			var ctx = CorrelationContext.Start(SessionId.New());
			ctx.WithWorker("worker-1");
			bool result = ctx.WorkerId == "worker-1";
			CorrelationContext.Clear();
			return result;
		});

		Run("VO-025 CorrelationContext_Clear_NullsCurrent", () =>
		{
			CorrelationContext.Start(SessionId.New());
			CorrelationContext.Clear();
			return CorrelationContext.Current == null;
		});

		// ── DomainEventEnvelope ──────────────────────────────────────
		Run("VO-026 DomainEventEnvelope_Create_HasEventId", () =>
		{
			CorrelationContext.Clear();
			var env = DomainEventEnvelope.Create("TestEvent", "TestSource", "agg-1", 3, 2);
			return !string.IsNullOrWhiteSpace(env.EventId)
				&& env.EventType == "TestEvent"
				&& env.Source == "TestSource"
				&& env.SchemaVersion == 1
				&& env.EventVersion == 2
				&& env.AggregateVersion == 3
				&& env.AggregateId == "agg-1";
		});

		Run("VO-027 DomainEventEnvelope_Create_CapturesCorrelation", () =>
		{
			CorrelationContext.Clear();
			var ctx = CorrelationContext.Start(SessionId.From("sess-test"));
			ctx.WithWorker("w-1").WithOperation(OperationName.From("Op1"));
			var env = DomainEventEnvelope.Create("Evt", "Src", "agg-2", 9);
			bool result = env.CorrelationId == ctx.CorrelationId.ToString()
				&& env.SessionId == "sess-test"
				&& env.WorkerId == "w-1"
				&& env.OperationName == "Op1";
			CorrelationContext.Clear();
			return result;
		});

		Run("VO-028 DomainEventEnvelope_UniqueEventIds", () =>
		{
			var a = DomainEventEnvelope.Create("E", "S", "a", 1);
			var b = DomainEventEnvelope.Create("E", "S", "a", 2);
			return a.EventId != b.EventId;
		});

		Run("VO-029 DomainEventEnvelope_RejectsNullEventType", () =>
		{
			try { DomainEventEnvelope.Create(null!, "S", "a", 1); return false; }
			catch (ArgumentException) { return true; }
		});

		Run("VO-030 DomainEventEnvelope_RejectsNullSource", () =>
		{
			try { DomainEventEnvelope.Create("E", null!, "a", 1); return false; }
			catch (ArgumentException) { return true; }
		});

		return (passed, failed);
	}
}
