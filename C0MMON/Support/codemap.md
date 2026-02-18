# C0MMON/Support/

## Responsibility

C0MMON/Support contains value objects, configuration structures, and utility types that support the core domain logic. These supporting types encapsulate complex data structures, business rules, and calculations that are reused across the P4NTH30N system.

**Core Support Types:**
- **DPD**: Days Past Due calculations and toggle management for jackpot detection
- **Jackpots**: 4-tier jackpot system with value tracking and validation
- **Thresholds**: Dynamic threshold calculations for jackpot reset detection
- **GameSettings**: Platform-specific configuration and settings management

## Design

**Key Patterns:**

1. **Value Object Pattern**
   - Immutable data structures with equality based on values
   - Encapsulation of business logic and calculations
   - Validation rules embedded within objects

2. **Domain Logic Encapsulation**
   - Business rules contained within support types
   - Calculation methods for complex domain operations
   - State management for toggle patterns and thresholds

3. **Configuration Management**
   - Centralized settings for platform-specific behavior
   - Environment-aware configuration loading
   - Validation of configuration values

4. **Mathematical Precision**
   - Decimal arithmetic for financial calculations
   - Rounding and precision control for monetary values
   - Statistical calculations for forecasting

## Flow

```
DPD (Days Past Due) Flow:
├── Initialize DPD toggles for jackpot detection
├── Monitor jackpot value changes
│   ├── Detect value drops (> 0.1 threshold)
│   ├── Toggle DPD state on first drop
│   ├── Confirm jackpot pop on second consecutive drop
│   └── Reset toggle after processing
├── Calculate Days Past Due
│   ├── Track time since last jackpot pop
│   ├── Calculate average intervals
│   └── Forecast next expected pop
└── Integration with Credential entity
    ├── Store DPD state within credential
    ├── Update toggle states during automation
    └── Provide forecasting data to H0UND

Thresholds Flow:
├── Initialize default thresholds (Grand: 1785, Major: 565, Minor: 117, Mini: 23)
├── Monitor jackpot values
├── Detect jackpot pops via DPD confirmation
├── Calculate new thresholds based on pop history
│   ├── Analyze recent pop patterns
│   ├── Calculate statistical averages
│   ├── Apply business rules for minimum/maximum
│   └── Generate new threshold values
└── Update credential thresholds
    ├── Store new thresholds in credential
    ├── Reset DPD toggles
    └── Log threshold change events

Jackpots Flow:
├── Initialize 4-tier jackpot structure
├── Track current values (Grand/Major/Minor/Mini)
├── Validate jackpot values (NaN, Infinity, negative checks)
├── Compare with stored values for change detection
├── Update stored values on changes
└── Provide jackpot data for automation decisions
```

## Integration

**Key Components:**

**DPD (Days Past Due):**
- **Purpose**: Jackpot pop detection and forecasting
- **Integration**: Embedded in Credential entity for state persistence
- **Used By**: H4ND for jackpot detection, H0UND for forecasting
- **Features**: Toggle-based detection, interval tracking, statistical analysis

**Jackpots:**
- **Purpose**: 4-tier jackpot value management
- **Structure**: Grand, Major, Minor, Mini tiers with validation
- **Integration**: Core component of Credential entity
- **Used By**: All agents for jackpot monitoring and automation

**Thresholds:**
- **Purpose**: Dynamic threshold calculation for jackpot resets
- **Integration**: Stored within Credential entity
- **Business Logic**: Statistical analysis of pop patterns
- **Used By**: H4ND for automation decisions, H0UND for analytics

**GameSettings:**
- **Purpose**: Platform-specific configuration management
- **Integration**: Used by Games namespace for platform behavior
- **Features**: URL configuration, element selectors, timing settings
- **Used By**: C0MMON/Games for platform-specific automation

**Dependencies:**
- **C0MMON/Entities**: Embedded within Credential entity
- **C0MMON/Games**: GameSettings used by platform implementations
- **System.Math**: Statistical calculations and mathematical operations
- **System.Decimal**: Precise financial calculations

**Used By:**
- **H4ND**: Primary consumer for jackpot detection and threshold management
- **H0UND**: DPD data for forecasting and analytics
- **C0MMON/Games**: GameSettings for platform configuration
- **C0MMON/Entities**: Value objects embedded in domain entities

**Business Rules:**
- **Jackpot Detection**: Two consecutive drops required for confirmation
- **Threshold Calculation**: Statistical analysis with minimum/maximum bounds
- **Validation**: NaN, Infinity, and negative value protection
- **Precision**: Decimal arithmetic for financial accuracy

**Benefits:**
- **Encapsulation**: Complex business logic contained in dedicated types
- **Reusability**: Shared across multiple agents and components
- **Testability**: Isolated business logic for unit testing
- **Maintainability**: Centralized business rules and calculations
