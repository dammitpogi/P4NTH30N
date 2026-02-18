# C0MMON/DomainServices

## Responsibility

Domain services that encapsulate complex business logic that doesn't naturally fit within entities. These services coordinate multiple entities and external systems to fulfill business requirements.

## When Working Here

- **Complex logic**: Multi-entity operations
- **External coordination**: Integration with external systems
- **Business rules**: Domain-specific rule enforcement
- **Transaction coordination**: Multiple operation coordination
- **Pure domain**: No infrastructure dependencies

## Core Services

### CredentialPriorityService.cs
Manages credential processing priority:
- `CalculatePriority`: Static method calculating priority (1-7) based on jackpot estimations, DPD, and funding status
- `SortByPriority`: Orders credentials by priority, overdue status, and last updated time
- Priority 1 = immediate (jackpot within 0.12 or mini within 0.07)
- Priority 7 = lowest (no jackpot data or distant projections)
- ProcessBy deadlines: 4min (P1) to 1 day (P7)

## Key Patterns

1. **Domain Service**: Stateless business logic
2. **Strategy Pattern**: Pluggable algorithms
3. **Specification Pattern**: Encapsulate business rules
4. **Factory Pattern**: Create complex objects

## Service Characteristics

- **Stateless**: No internal state between calls
- **Pure**: No side effects except return values
- **Testable**: Easy to unit test in isolation
- **Reusable**: Used across multiple contexts

## Example Service

```csharp
public class CredentialPriorityService
{
    // Calculate priority based on jackpot estimations and DPD
    public static (int priority, DateTime processBy, bool isOverdue) CalculatePriority(
        Credential credential,
        List<Jackpot> estimations,
        Jackpot? mini,
        DateTime now)
    {
        // Priority 1 = immediate action required
        // Priority 7 = lowest priority, can wait
        // Returns (priority, processBy deadline, isOverdue)
    }

    // Sort by priority, then overdue status, then last updated
    public static List<Credential> SortByPriority(
        List<(Credential credential, int priority, DateTime by, bool overdue)> prioritized)
    {
        return prioritized
            .OrderBy(p => p.priority)
            .ThenByDescending(p => p.overdue)
            .ThenBy(p => p.credential.LastUpdated)
            .Select(p => p.credential)
            .ToList();
    }
}
```

## When to Create a Domain Service

Create a domain service when:
- Logic spans multiple entities
- Complex calculations needed
- External system integration required
- Business rule too complex for entity method

## When NOT to Create a Domain Service

Don't create a domain service when:
- Logic fits naturally in an entity
- Simple CRUD operations suffice
- Infrastructure concerns involved (use Application Service)
- Just data transformation (use Mapper)

## Dependencies

- C0MMON/Entities: Domain models
- C0MMON/Support: Value objects
- No infrastructure dependencies (pure domain)

## Testing

Domain services are easily testable:
```csharp
[Test]
public void CalculatePriority_ReturnsPriority1_WhenJackpotImminent()
{
    var credential = new Credential { Balance = 100, CashedOut = false };
    var estimations = new List<Jackpot>
    {
        new Jackpot { Current = 1780, Threshold = 1785, EstimatedDate = DateTime.UtcNow.AddHours(1) }
    };
    var now = DateTime.UtcNow;

    var (priority, processBy, isOverdue) = CredentialPriorityService.CalculatePriority(
        credential, estimations, null, now);

    Assert.AreEqual(1, priority);
}
```

## Integration

- Used by H4ND for credential ordering
- Used by H0UND for polling prioritization
- Called from Application layer services
