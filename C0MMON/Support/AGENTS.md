# C0MMON/Support

## Responsibility

Contains value objects, configuration structures, and utility types that support core domain logic. These supporting types encapsulate complex data structures, business rules, and calculations reused across the P4NTH30N system.

## When Working Here

- **Value object pattern**: Immutable data structures with equality based on values
- **Domain logic encapsulation**: Business rules contained within support types
- **Mathematical precision**: Use decimal arithmetic for financial calculations
- **Configuration management**: Centralized settings for platform-specific behavior
- **State management**: Manage toggle patterns and thresholds

## Core Support Types

- **DPD**: Days Past Due calculations and toggle management for jackpot detection
- **Jackpots**: 4-tier jackpot system with value tracking and validation
- **Thresholds**: Dynamic threshold calculations for jackpot reset detection
- **GameSettings**: Platform-specific configuration and settings management

## Key Patterns

1. **Value Object Pattern**
   - Immutable data structures
   - Business logic and calculations encapsulated
   - Validation rules embedded within objects

2. **Domain Logic Encapsulation**
   - Calculation methods for complex domain operations
   - State management for toggle patterns
   - Business rules contained within types

3. **Configuration Management**
   - Environment-aware configuration loading
   - Validation of configuration values
   - Platform-specific settings

4. **Mathematical Precision**
   - Decimal arithmetic for financial calculations
   - Rounding and precision control for monetary values
   - Statistical calculations for forecasting

## Business Rules

**Jackpot Detection (DPD):**
- Two consecutive drops required for confirmation
- First drop: Toggle DPD state
- Second consecutive drop: Confirm jackpot pop
- Reset toggle after processing

**Threshold Calculation:**
- Default thresholds: Grand=1785, Major=565, Minor=117, Mini=23
- Statistical analysis of pop patterns
- Apply minimum/maximum bounds
- Recalculate after confirmed jackpot pop

**Validation:**
- NaN, Infinity, and negative value protection
- Decimal arithmetic for financial accuracy
- Range validation for jackpot values

## Dependencies

- C0MMON/Entities (embedded within Credential entity)
- C0MMON/Games (GameSettings used by platform implementations)
- System.Math (statistical calculations)
- System.Decimal (precise financial calculations)

## Used By

- H4ND (jackpot detection and threshold management)
- H0UND (DPD data for forecasting and analytics)
- C0MMON/Games (GameSettings for platform configuration)
- C0MMON/Entities (value objects embedded in domain entities)

## Benefits

- **Encapsulation**: Complex business logic in dedicated types
- **Reusability**: Shared across multiple agents
- **Testability**: Isolated business logic for unit testing
- **Maintainability**: Centralized business rules
