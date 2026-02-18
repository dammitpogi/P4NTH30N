# C0MMON/EF

## Responsibility

Entity Framework Core data access layer for analytics and complex queries. Provides LINQ-based querying capabilities for reporting and analytics workloads.

## When Working Here

- **Analytics focus**: Complex queries for reporting
- **LINQ operations**: Type-safe querying
- **Read-heavy**: Optimized for read operations
- **Projection**: Use Select to minimize data transfer
- **No tracking**: Use AsNoTracking() for read-only queries

## Core Components

### P4NTH30NDbContext.cs
Main EF Core database context:
- Entity configurations
- Relationship mappings
- Query filters
- Connection management

### AnalyticsRepositories.cs
Specialized repositories for analytics:
- Trend analysis queries
- Aggregation operations
- Time-series data retrieval
- Custom DTO projections

### AnalyticsServices.cs
High-level analytics operations:
- DPD analysis (`DPDAnalysisResult`, `DPDCredentialData`)
- Jackpot forecasting (`JackpotForecast`)
- Credential health reporting (`CredentialHealthReport`, `HouseHealth`)
- House summaries (`HouseSummary`)
- Uses repositories for data access

### AnalyticsEntities.cs
> **Note**: Entity configurations are embedded in `P4NTH30NDbContext.cs` OnModelCreating - no separate file exists.

EF Core entity configurations (in P4NTH30NDbContext.cs):
- Table mappings for Credential, Signal, Jackpot, House, ProcessEvent, Received, ErrorLog
- Key definitions
- Property configurations

## Key Patterns

1. **Repository Pattern**: Abstract data access behind interfaces
2. **Specification Pattern**: Encapsulate query criteria
3. **DTO Projection**: Return only needed fields
4. **Async Operations**: Use async/await for scalability

## When to Use EF vs MongoDB Driver

**Use EF Core for:**
- Complex JOIN operations
- Aggregations and GROUP BY
- Reporting queries
- Ad-hoc analysis

**Use MongoDB Driver for:**
- Simple CRUD operations
- Real-time data access
- High-write scenarios
- Document-centric operations

## Example Queries

```csharp
// Trend analysis
var trends = await context.Jackpots
    .Where(j => j.Date > DateTime.UtcNow.AddDays(-7))
    .GroupBy(j => j.Game)
    .Select(g => new { Game = g.Key, AvgGrand = g.Average(j => j.Grand) })
    .ToListAsync();

// Forecast accuracy
var accuracy = await context.Forecasts
    .Where(f => f.ActualHitTime != null)
    .Select(f => Math.Abs((f.PredictedHitTime - f.ActualHitTime).Value.TotalHours))
    .AverageAsync();
```

## Dependencies

- EF Core: Entity Framework Core
- MongoDB EF Provider: MongoDB integration
- C0MMON/Entities: Domain models
- C0MMON/Interfaces: Repository contracts

## Configuration

Connection string in appsettings.json:
```json
{
  "ConnectionStrings": {
    "Analytics": "mongodb://localhost:27017/P4NTH30N_Analytics"
  }
}
```

## Performance

- Enable query logging in development
- Use indexes on frequently queried fields
- Limit result sets with Take()
- Use compiled queries for hot paths
