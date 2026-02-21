# Designer Implementation Strategies

## DECISION_025: Atypicality-Based Anomaly Detection

**Status**: Approved (Oracle: 98%)

### Phase 1: Core Implementation
1. Create `AtypicalityScore.cs` in `C0MMON/Support`
   - Implement compression ratio calculation using `System.IO.Compression`
   - Use GZipStream or DeflateStream for compression
2. Create `AnomalyDetector.cs` in `H0UND/Services`
   - Wire into jackpot data stream from DPD calculator
   - Implement sliding window buffer (50 values) using `Queue<double>`
3. Calculate atypicality: `compression(window) / expected_size` ratio

### Phase 2: Integration
1. Integrate with H0UND main loop - call `AnomalyDetector.Check(jackpotValues)` after each DPD calculation
2. Add threshold configuration in `appsettings.json`
3. Log anomalies to ERR0R collection with severity 'Warning'

### Phase 3: Testing
1. Unit test with synthetic jackpot sequences
2. Integration test with historical data
3. Tune threshold based on false positive rate

### Technical Specifications
- **Files**: `C0MMON/Support/AtypicalityScore.cs`, `H0UND/Services/AnomalyDetector.cs`, `C0MMON/Entities/AnomalyEvent.cs`
- **Fallback**: If compression fails, use statistical deviation (std dev > 3 from mean)
- **Complexity**: Low

---

## DECISION_026: CDP Automation Enhancement

**Status**: Approved (Oracle: 95%)

### Phase 1: CDP Network Interception
1. Add Network domain methods to `CDPManager.cs`: `Enable()`, `Disable()`, `RequestPaused()`, `FulfillRequest()`
2. Implement `RequestMatcher` to identify jackpot API calls by URL pattern
3. Create `ApiResponseParser` to extract jackpot values from JSON responses

### Phase 2: Session Pool
1. Create `SessionPool.cs` - manages collection of isolated CDP connections
2. Implement `GetSession(credentialId)` with lazy initialization
3. Implement `ReturnSession()` with health check before reuse
4. Add `SessionMetrics` to track connection health

### Phase 3: Tracing & Debugging
1. Add Tracing domain: `start()`, `end()`, `getCategories()`
2. Implement `TraceBuffer` to collect events during automation
3. Create `AutomationTrace` entity for MongoDB storage
4. Add trace upload on error conditions

### Phase 4: Migration
1. Feature flag `EnableNetworkInterception` default false
2. Gradual rollout: 10%, 50%, 100% of credentials
3. Dual-read: Compare DOM parse vs API parse, log discrepancies
4. Remove DOM parsing after validation period

### Technical Specifications
- **Files**: `H4ND/Services/CDPManager.cs`, `H4ND/Services/SessionPool.cs`, `H4ND/Services/NetworkInterceptor.cs`, `C0MMON/Entities/AutomationTrace.cs`
- **Fallback**: If API interception fails, fall back to DOM parsing with warning logged
- **Complexity**: Medium

---

## DECISION_027: AgentNet-Style Coordination

**Status**: Approved (Oracle: 92%)

### Phase 1: EventBus Enhancement
1. Add `CapabilityRegistry` to `EventBus.cs`
   - `RegisterCapability(agentId, capability)`
   - `GetAgentsWithCapability(capability)`
   - `UnregisterCapability(agentId)`
2. Add priority-based message routing

### Phase 2: Agent Role Interfaces
1. Create `IAgent.cs` base interface in `C0MMON/Interfaces`
2. Create specialized roles:
   - `IPredictor` - Jackpot forecasting
   - `IOptimizer` - Threshold tuning  
   - `IExecutor` - Spin execution
   - `IMonitor` - Health checks
3. Create `AgentRegistry` for dynamic registration

### Phase 3: H0UND Agent Implementation
1. Create `H0UND/Agents/PredictorAgent.cs`
2. Create `H0UND/Agents/OptimizerAgent.cs`
3. Implement message handlers for each role

### Phase 4: H4ND Agent Implementation
1. Create `H4ND/Agents/ExecutorAgent.cs`
2. Create `H4ND/Agents/MonitorAgent.cs`
3. Implement coordination protocols

### Phase 5: Migration
1. Maintain backward compatibility with existing SIGN4L format
2. Dual-mode: Polling + Event-driven during transition
3. Remove polling after full validation

### Technical Specifications
- **Files**: `C0MMON/Services/EventBus.cs`, `C0MMON/Interfaces/IAgent.cs`, `H0UND/Agents/`, `H4ND/Agents/`
- **Dependency**: DECISION_026 (CDP Enhancement must complete first)
- **Complexity**: High

---

## DECISION_028: XGBoost Dynamic Wager Placement

**Status**: Approved (Oracle: 90%)

### Phase 1: Feature Engineering
1. Create `WagerFeatures.cs` in `C0MMON/Support`
   - Current jackpot value
   - Time since last win
   - Historical hit frequency
   - Day of week, hour of day
   - Pattern features (from Decision 029)
2. Create `WagerOutcome.cs` for training labels

### Phase 2: Model Training Pipeline
1. Set up training data pipeline from MongoDB
2. Configure XGBoost model with appropriate hyperparameters
3. Implement cross-validation
4. Create model serialization (save/load)

### Phase 3: WagerOptimizer Service
1. Create `WagerOptimizer.cs` in `H0UND/Services`
   - `Predict(jackpotContext)` returns spin decision + bet amount
   - `UpdateModel(outcome)` for continuous learning
2. Integrate with signal generation pipeline

### Phase 4: Continuous Learning
1. Implement nightly retraining job
2. A/B testing framework for model updates
3. Rollback capability for bad updates

### Technical Specifications
- **Files**: `C0MMON/Support/WagerFeatures.cs`, `H0UND/Services/WagerOptimizer.cs`, `H0UND/ML/`
- **Dependency**: DECISION_027 (Agent Coordination required)
- **Complexity**: Medium

---

## Implementation Order

| Decision | Phase | Duration | Dependencies |
|----------|-------|----------|--------------|
| DECISION_025 | 1 | 2-3 days | None |
| DECISION_026 | 1-2 | 4-5 days | None |
| DECISION_027 | 1-3 | 7-10 days | DECISION_026 |
| DECISION_028 | 1-2 | 5-7 days | DECISION_027 |

## Validation Strategy

Each decision includes:
- Unit tests
- Integration tests with historical data
- Gradual rollout with feature flags
- Fallback mechanisms for reliability
