# DESIGNER IMPLEMENTATION PROPOSAL
## ARCH-003-PIVOT: Model Testing Platform + Rule-Based Validation

**Status**: Awaiting Oracle approval on revised plan
**Timeline**: 5 days (pending Oracle confirmation)
**Deliverables**: Model Testing Platform, Rule-Based Validator, Two-Stage Pipeline

---

## PHASE 0: MODEL TESTING PLATFORM (Days 1-2)

### Component 1: ModelTestHarness.cs

**Purpose**: Automated testing framework for LM Studio models

**Interface Design**:
```csharp
namespace P4NTHE0N.ModelTesting;

public interface ILlmBackend {
    Task<LlmResponse> CompleteAsync(LlmRequest request, CancellationToken ct);
    Task<bool> IsReadyAsync(CancellationToken ct);
    Task<ModelInfo> GetModelInfoAsync(CancellationToken ct);
}

public sealed class LmStudioBackend : ILlmBackend {
    private readonly HttpClient _client;
    private readonly string _baseUrl = "http://localhost:1234";
    
    public async Task<LlmResponse> CompleteAsync(LlmRequest request, CancellationToken ct) {
        var body = new {
            model = request.ModelId,
            messages = new[] {
                new { role = "system", content = request.SystemPrompt },
                new { role = "user", content = request.UserPrompt }
            },
            temperature = request.Temperature,
            top_p = request.TopP,
            top_k = request.TopK,
            do_sample = request.DoSample,
            max_tokens = request.MaxTokens
        };
        
        var response = await _client.PostAsJsonAsync(
            $"{_baseUrl}/v1/chat/completions", body, ct);
        
        return await ParseResponseAsync(response);
    }
}
```

**Key Features**:
- Direct HTTP to LM Studio (localhost:1234)
- Configurable temperature, top_p, top_k, do_sample
- Async with cancellation token support
- Response parsing with error handling

### Component 2: PromptConsistencyTester

**Purpose**: Measure output variance across n runs

```csharp
public sealed class PromptConsistencyTester {
    public async Task<ConsistencyReport> MeasureConsistencyAsync(
        ILlmBackend backend,
        TestCase testCase,
        int nRuns = 10,
        double temperature = 0.0,
        CancellationToken ct = default) {
        
        var results = new List<LlmResponse>();
        
        // Warmup runs (2)
        for (int i = 0; i < 2; i++) {
            await backend.CompleteAsync(
                CreateRequest(testCase, temperature), ct);
        }
        
        // Actual test runs (n=10)
        for (int i = 0; i < nRuns; i++) {
            results.Add(await backend.CompleteAsync(
                CreateRequest(testCase, temperature), ct));
        }
        
        return AnalyzeResults(results, testCase);
    }
    
    private ConsistencyReport AnalyzeResults(List<LlmResponse> results, TestCase testCase) {
        var validCount = results.Count(r => r.ParsedOutput?.Valid == true);
        double p = validCount / (double)results.Count;
        
        return new ConsistencyReport {
            TestCaseId = testCase.Id,
            Runs = results.Count,
            ExactMatchRate = CalculateExactMatch(results),
            SemanticMatchRate = CalculateSemanticMatch(results, testCase.ExpectedOutput),
            VarianceScore = Math.Sqrt(p * (1 - p) / results.Count), // Standard error
            OutputValidityRate = results.Count(r => r.IsValidJson) / (double)results.Count,
            MeanLatencyMs = results.Average(r => r.LatencyMs),
            Accuracy = results.Count(r => IsCorrect(r, testCase)) / (double)results.Count
        };
    }
}
```

**Acceptance Criteria**:
- Variance Score < 0.05 (5%): Production ready
- Variance Score 0.05-0.15: Conditional use
- Variance Score > 0.15: Inadequate

### Component 3: TemperatureSweep

**Purpose**: Find optimal temperature for deterministic tasks

```csharp
public sealed class TemperatureSweep {
    public async Task<TemperatureReport> RunSweepAsync(
        ILlmBackend backend,
        TestCase testCase,
        List<double> temperatures = null,
        int runsPerTemp = 5,
        CancellationToken ct = default) {
        
        temperatures ??= new List<double> { 0.0, 0.1, 0.3, 0.5, 0.7, 1.0 };
        var results = new Dictionary<double, TemperatureResult>();
        
        foreach (var temp in temperatures) {
            var consistency = await _consistencyTester.MeasureConsistencyAsync(
                backend, testCase, runsPerTemp, temp, ct);
            
            results[temp] = new TemperatureResult {
                Temperature = temp,
                Accuracy = consistency.Accuracy,
                VarianceScore = consistency.VarianceScore,
                MeanLatencyMs = consistency.MeanLatencyMs
            };
        }
        
        return new TemperatureReport {
            TestCaseId = testCase.Id,
            Results = results,
            OptimalTemperature = results
                .Where(r => r.Value.VarianceScore < 0.05)
                .OrderByDescending(r => r.Value.Accuracy)
                .FirstOrDefault().Key
        };
    }
}
```

### Component 4: SmolLM2-1.7B Investigation

**Test Plan**:

1. **Baseline Test** (Current prompt, temp=0.1)
   - Document current 40% accuracy
   - Establish baseline for comparison

2. **Temperature 0.0 Test** (Current prompt, temp=0.0)
   - Use greedy decoding: `do_sample=false`
   - Expected: Reduced variance, potentially higher accuracy
   - Target: 50-60% accuracy

3. **Improved Prompt Test** (Enhanced prompt, temp=0.0)
   - Add chain-of-thought reasoning requirement
   - Include explicit failure demonstrations
   - Target: 60%+ accuracy

**Decision Gate** (End of Day 2):
- IF SmolLM2-1.7B ≥ 60%: Keep as secondary validation
- IF SmolLM2-1.7B < 60%: Pivot fully to rule-based

---

## PHASE 1: RULE-BASED VALIDATOR (Days 3-4)

### Component 5: JsonSchemaValidator.cs

**Purpose**: Deterministic JSON Schema validation

```csharp
using NJsonSchema;
using NJsonSchema.Validation;

namespace P4NTHE0N.DeployLogAnalyzer.Validation;

public sealed class JsonSchemaValidator {
    private readonly JsonSchema _schema;
    
    public JsonSchemaValidator() {
        _schema = BuildSchema();
    }
    
    private JsonSchema BuildSchema() {
        return new JsonSchemaBuilder()
            .Type(Object)
            .Required("username", "platform", "house", "thresholds", "enabled")
            .Properties(new Dictionary<string, JsonSchema> {
                ["username"] = new JsonSchemaBuilder()
                    .Type(String)
                    .MinimumLength(1)
                    .MaximumLength(50)
                    .Pattern("^[a-zA-Z0-9_]+$"),
                    
                ["platform"] = new JsonSchemaBuilder()
                    .Type(String)
                    .Enum("firekirin", "orionstars", "gamereel", "vegasx", "pandamaster"),
                    
                ["house"] = new JsonSchemaBuilder()
                    .Type(String)
                    .MinimumLength(1),
                    
                ["thresholds"] = new JsonSchemaBuilder()
                    .Type(Object)
                    .Required("Grand", "Major", "Minor", "Mini")
                    .Properties(new Dictionary<string, JsonSchema> {
                        ["Grand"] = new JsonSchemaBuilder().Type(Number).Minimum(1).Maximum(100000),
                        ["Major"] = new JsonSchemaBuilder().Type(Number).Minimum(1).Maximum(50000),
                        ["Minor"] = new JsonSchemaBuilder().Type(Number).Minimum(1).Maximum(10000),
                        ["Mini"] = new JsonSchemaBuilder().Type(Number).Minimum(1).Maximum(5000),
                    }),
                    
                ["enabled"] = new JsonSchemaBuilder().Type(Boolean),
                
                ["dpd"] = new JsonSchemaBuilder()
                    .Type(Object)
                    .Properties(new Dictionary<string, JsonSchema> {
                        ["WindowHours"] = new JsonSchemaBuilder().Type(Number).Minimum(1).Maximum(168),
                        ["MinSamples"] = new JsonSchemaBuilder().Type(Number).Minimum(5).Maximum(1000),
                    })
            })
            .Build();
    }
    
    public SchemaValidationResult Validate(JObject config) {
        var errors = _schema.Validate(config);
        
        if (errors.Any()) {
            return SchemaValidationResult.Invalid(errors.Select(e => new ValidationError {
                Property = e.Property,
                Message = e.Kind.ToString(),
                LineNumber = e.LineNumber,
                LinePosition = e.LinePosition
            }));
        }
        
        return SchemaValidationResult.Valid();
    }
}
```

### Component 6: BusinessRulesValidator.cs

**Purpose**: C# business rules for cross-field validation

```csharp
public sealed class BusinessRulesValidator {
    public BusinessValidationResult ValidateBusinessRules(CredentialConfig config) {
        var errors = new List<BusinessValidationError>();
        
        // Rule 1: Threshold ordering (Grand > Major > Minor > Mini)
        if (config.Thresholds.Grand <= config.Thresholds.Major) {
            errors.Add(new BusinessValidationError {
                Rule = "threshold_ordering",
                Message = $"Grand ({config.Thresholds.Grand}) must exceed Major ({config.Thresholds.Major})",
                Severity = ValidationSeverity.Error
            });
        }
        
        if (config.Thresholds.Major <= config.Thresholds.Minor) {
            errors.Add(new BusinessValidationError {
                Rule = "threshold_ordering",
                Message = $"Major ({config.Thresholds.Major}) must exceed Minor ({config.Thresholds.Minor})",
                Severity = ValidationSeverity.Error
            });
        }
        
        if (config.Thresholds.Minor <= config.Thresholds.Mini) {
            errors.Add(new BusinessValidationError {
                Rule = "threshold_ordering",
                Message = $"Minor ({config.Thresholds.Minor}) must exceed Mini ({config.Thresholds.Mini})",
                Severity = ValidationSeverity.Error
            });
        }
        
        // Rule 2: DPD window sanity check
        if (config.Dpd?.WindowHours > 24 && config.Dpd?.MinSamples < 10) {
            errors.Add(new BusinessValidationError {
                Rule = "dpd_sanity",
                Message = "WindowHours > 24 requires MinSamples >= 10 for statistical significance",
                Severity = ValidationSeverity.Warning
            });
        }
        
        // Rule 3: Platform-specific thresholds
        var platformMaxThresholds = new Dictionary<string, int> {
            ["firekirin"] = 50000,
            ["orionstars"] = 75000,
            ["gamereel"] = 100000,
            ["vegasx"] = 25000,
            ["pandamaster"] = 50000
        };
        
        if (platformMaxThresholds.TryGetValue(config.Platform, out var maxThreshold)) {
            if (config.Thresholds.Grand > maxThreshold) {
                errors.Add(new BusinessValidationError {
                    Rule = "platform_threshold_limit",
                    Message = $"Platform {config.Platform} has maximum Grand threshold of {maxThreshold}",
                    Severity = ValidationSeverity.Error
                });
            }
        }
        
        return errors.Any() 
            ? BusinessValidationResult.Invalid(errors) 
            : BusinessValidationResult.Valid();
    }
}
```

---

## PHASE 2: TWO-STAGE PIPELINE (Day 5)

### Component 7: ValidationPipeline.cs (Refactored)

**Purpose**: Conditional two-stage validation

```csharp
public sealed class ValidationPipeline {
    private readonly JsonSchemaValidator _schemaValidator;
    private readonly BusinessRulesValidator _businessValidator;
    private readonly LlmSemanticValidator _llmValidator; // Optional, based on decision gate
    private readonly ILogger<ValidationPipeline> _logger;
    
    public async Task<ValidationResult> ValidateAsync(
        JObject config, 
        ValidationOptions options = null,
        CancellationToken ct = default) {
        
        var stopwatch = Stopwatch.StartNew();
        
        // Stage 1: Rule-based validation (always runs)
        var schemaResult = _schemaValidator.Validate(config);
        if (!schemaResult.IsValid) {
            return ValidationResult.Fail(schemaResult.Errors, 
                latencyMs: stopwatch.ElapsedMilliseconds,
                stage: ValidationStage.Schema);
        }
        
        var businessResult = _businessValidator.ValidateBusinessRules(
            config.ToObject<CredentialConfig>());
        if (businessResult.HasErrors) {
            return ValidationResult.Fail(businessResult.Errors,
                latencyMs: stopwatch.ElapsedMilliseconds,
                stage: ValidationStage.BusinessRules);
        }
        
        // Check if uncertain (needs semantic analysis)
        if (options?.RequireSemanticAnalysis == true || IsUncertain(config)) {
            // Stage 2: LLM secondary (only if available and needed)
            if (_llmValidator != null) {
                var semanticResult = await _llmValidator.ValidateSemanticAsync(config, ct);
                return ValidationResult.FromSemantic(semanticResult,
                    latencyMs: stopwatch.ElapsedMilliseconds,
                    stage: ValidationStage.Semantic);
            }
        }
        
        return ValidationResult.Pass(
            latencyMs: stopwatch.ElapsedMilliseconds,
            stage: ValidationStage.RuleBased);
    }
    
    private bool IsUncertain(JObject config) {
        // Determine if config needs semantic analysis
        // Examples: new schema version, unknown fields, edge cases
        return config.ContainsKey("_uncertain") || 
               config.ContainsKey("experimental") ||
               !IsKnownSchemaVersion(config);
    }
}
```

**Performance Targets**:
- Rule-based (85% of cases): <10ms
- LLM secondary (15% of cases): ~8s
- Overall: 95% of validations complete in <50ms

---

## DELIVERABLES SUMMARY

| Phase | Component | File | Purpose |
|-------|-----------|------|---------|
| 0 | ModelTestHarness | `tests/ModelTesting/ModelTestHarness.cs` | Automated LM Studio testing |
| 0 | PromptConsistencyTester | `tests/ModelTesting/PromptConsistencyTester.cs` | n=10 variance measurement |
| 0 | TemperatureSweep | `tests/ModelTesting/TemperatureSweep.cs` | Find optimal temp |
| 0 | Test Results | `tests/pre-validation/phase0-results.json` | SmolLM2 temp=0.0 results |
| 1 | JsonSchemaValidator | `scripts/DeployLogAnalyzer/JsonSchemaValidator.cs` | Deterministic validation |
| 1 | BusinessRulesValidator | `scripts/DeployLogAnalyzer/BusinessRulesValidator.cs` | Cross-field rules |
| 1 | Schema Definitions | `scripts/DeployLogAnalyzer/schemas/credential.json` | JSON Schema files |
| 2 | ValidationPipeline | `scripts/DeployLogAnalyzer/ValidationPipeline.cs` | Two-stage pipeline |
| 2 | Integration Tests | `scripts/DeployLogAnalyzer/Tests/ValidationPipelineTests.cs` | End-to-end tests |

---

## DECISION GATE (End of Phase 0)

**Criteria**:
```
IF SmolLM2-1.7B (temp=0.0, improved prompt) >= 60% accuracy:
    → Keep LLM as secondary validation
    → Proceed with Phase 1-2 as planned
    
IF SmolLM2-1.7B < 60% accuracy:
    → Remove LLM secondary entirely
    → Phase 2 becomes pure rule-based
    → Add "human review" flag for UNCERTAIN cases
```

**Rationale**: 
- Designer believes 60% is minimum viable for secondary validation
- Even 60% may be inadequate (Designer verdict: INADEQUATE for production)
- But empirical data should drive final decision

---

## AWAITING ORACLE APPROVAL

Before implementation begins, Oracle must confirm:

1. ✅ **Hybrid approach approval**: Rule-based primary + conditional LLM secondary
2. ✅ **Decision gate criteria**: 60% threshold for SmolLM2 retention
3. ✅ **Timeline validation**: 5 days with Day 2 decision gate
4. ✅ **Risk assessment**: Any additional concerns or requirements
5. ✅ **Final approval rating**: Updated approval percentage for ARCH-003-PIVOT

Once Oracle approves, implementation begins immediately.
