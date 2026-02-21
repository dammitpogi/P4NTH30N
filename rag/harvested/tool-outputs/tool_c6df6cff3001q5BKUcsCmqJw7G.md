# Tool Output: tool_c6df6cff3001q5BKUcsCmqJw7G
**Date**: 2026-02-17 23:36:57 UTC
**Size**: 72,014 bytes

```
{
  "count": 12,
  "decisions": [
    {
      "_id": {
        "$oid": "69946b26a40de11d5c628ca0"
      },
      "decisionId": "DECISION_001",
      "title": "Circuit Breaker Pattern Implementation",
      "category": "Production Hardening",
      "description": "Implement circuit breakers with automatic recovery for external API calls, MongoDB operations, Selenium automation execution, and decision logging service",
      "status": "Approved",
      "details": {
        "failureThreshold": 3,
        "recoveryTimeout": "5 minutes",
        "states": [
          "Closed",
          "Open",
          "HalfOpen"
        ],
        "circuitStates": {
          "Closed": {
            "description": "Normal operation - requests flow through",
            "onEnter": "Reset failure count to 0",
            "onExit": "Failure threshold exceeded -> Open"
          },
          "Open": {
            "description": "Failing fast - reject all requests immediately",
            "onEnter": "Start recovery timer",
            "onExit": "Recovery timeout elapsed -> HalfOpen",
            "behavior": "Return CircuitOpenException immediately"
          },
          "HalfOpen": {
            "description": "Testing recovery - allow limited requests",
            "onEnter": "Allow single test request",
            "onExit": "Success -> Closed, Failure -> Open",
            "behavior": "Route single request, evaluate result"
          }
        },
        "events": {
          "onStateChange": "Log state transition with reason",
          "onFailure": "Increment counter, check threshold",
          "onSuccess": "Reset counter if Closed state",
          "onHalfOpenSuccess": "Transition to Closed",
          "onHalfOpenFailure": "Transition to Open, reset timer"
        },
        "failureThresholds": {
          "mongoDB": 3,
          "externalAPI": 5,
          "selenium": 3,
          "default": 3
        },
        "metrics": {
          "tracked": [
            "failureCount",
            "successCount",
            "lastFailureTime",
            "currentState",
            "consecutiveFailures"
          ],
          "reported": [
            "stateTransitions",
            "totalFailures",
            "totalSuccesses",
            "averageRecoveryTime"
          ]
        },
        "recoveryTimeouts": {
          "mongoDB": "30 seconds",
          "externalAPI": "60 seconds",
          "selenium": "2 minutes",
          "default": "5 minutes"
        },
        "advancedFeatures": {
          "manualControl": {
            "openManually": "Force circuit open for maintenance",
            "closeManually": "Force circuit closed after manual fix",
            "reset": "Clear all counters, return to Closed"
          },
          "healthEndpoint": "Expose circuit states via /health/circuits for monitoring",
          "cascadingFailures": "Parent circuit can track child circuit states",
          "rateLimiting": "Optional rate limiter in front of circuit breaker"
        },
        "configuration": {
          "failureThreshold": {
            "type": "int",
            "default": 3,
            "min": 1,
            "max": 10,
            "description": "Consecutive failures before opening circuit"
          },
          "successThreshold": {
            "type": "int",
            "default": 2,
            "min": 1,
            "max": 5,
            "description": "Successes in HalfOpen to close circuit"
          },
          "recoveryTimeout": {
            "type": "TimeSpan",
            "default": "00:05:00",
            "min": "00:00:30",
            "max": "00:30:00",
            "description": "Time before attempting recovery"
          },
          "halfOpenMaxCalls": {
            "type": "int",
            "default": 1,
            "min": 1,
            "max": 3,
            "description": "Max test calls allowed in HalfOpen"
          },
          "samplingDuration": {
            "type": "TimeSpan",
            "default": "00:01:00",
            "description": "Window for counting failures"
          },
          "minimumThroughput": {
            "type": "int",
            "default": 2,
            "description": "Minimum calls before evaluating threshold"
          }
        },
        "edgeCases": {
          "timeoutVsFailure": "Timeout counts as failure for circuit purposes",
          "exceptionFiltering": "Configurable exceptions that do NOT count as failures (e.g., ValidationException)",
          "nestedCircuitBreakers": "Supported - inner circuit failures propagate to outer",
          "circuitBreakerTimeout": "Operation timeout separate from circuit recovery timeout",
          "halfOpenConcurrentCalls": "Queue additional calls or reject? Default: reject with CircuitHalfOpenException"
        },
        "loggingIntegration": {
          "stateTransitions": "Log at Warning level with old state, new state, reason, failure count",
          "failures": "Log at Debug level with operation name, exception type, duration",
          "recovery": "Log at Information level when circuit recovers to Closed",
          "metrics": "Emit to metrics collector every state change"
        },
        "monitoring": {
          "metricsEmitted": [
            {
              "name": "circuit_breaker_state",
              "type": "gauge",
              "labels": [
                "circuit_name",
                "state"
              ],
              "value": "0=Closed, 1=HalfOpen, 2=Open"
            },
            {
              "name": "circuit_breaker_failures_total",
              "type": "counter",
              "labels": [
                "circuit_name"
              ]
            },
            {
              "name": "circuit_breaker_successes_total",
              "type": "counter",
              "labels": [
                "circuit_name"
              ]
            },
            {
              "name": "circuit_breaker_state_transitions_total",
              "type": "counter",
              "labels": [
                "circuit_name",
                "from_state",
                "to_state"
              ]
            },
            {
              "name": "circuit_breaker_open_duration_seconds",
              "type": "histogram",
              "labels": [
                "circuit_name"
              ]
            }
          ],
          "prometheus": "Standard Prometheus metrics format",
          "grafana": "Dashboard template with circuit state history, failure rates, recovery times"
        },
        "performanceImpact": {
          "overheadClosed": "~1-2 microseconds per call (state check + counter increment)",
          "overheadOpen": "~100 nanoseconds (immediate rejection)",
          "overheadHalfOpen": "~5-10 microseconds (state check + allowed call tracking)",
          "memoryFootprint": "~1KB per circuit breaker instance",
          "recommendation": "Use single instance per external dependency, not per operation"
        },
        "testingStrategy": {
          "unitTests": [
            "Circuit opens after failure threshold",
            "Circuit rejects calls when Open",
            "Circuit transitions to HalfOpen after timeout",
            "HalfOpen success closes circuit",
            "HalfOpen failure reopens circuit",
            "Exception filtering works correctly",
            "Thread safety under concurrent load"
          ],
          "integrationTests": [
            "MongoDB circuit breaker with real connection failures",
            "API circuit breaker with simulated timeouts",
            "Selenium circuit breaker with browser crashes"
          ],
          "chaosTesting": [
            "Random network failures during operation",
            "Sudden API rate limiting",
            "Database connection pool exhaustion"
          ]
        },
        "threadSafety": {
          "implementation": "Lock-free state transitions using Interlocked.CompareExchange",
          "concurrentAccess": "Multiple threads can check state simultaneously",
          "stateTransitions": "Atomic - only one thread can transition at a time",
          "counterUpdates": "Interlocked.Increment/Decrement for failure counters"
        },
        "actionItems": [
          {
            "priority": 1,
            "task": "Add ICircuitBreakerFactory interface to C0MMON/Infrastructure/Resilience",
            "files": [
              "C0MMON/Infrastructure/Resilience/ICircuitBreakerFactory.cs"
            ]
          },
          {
            "priority": 2,
            "task": "Implement CircuitBreakerFactory with per-dependency configuration",
            "files": [
              "C0MMON/Infrastructure/Resilience/CircuitBreakerFactory.cs"
            ]
          },
          {
            "priority": 3,
            "task": "Add exception filtering to CircuitBreaker.ExecuteAsync - skip counting ValidationException",
            "files": [
              "C0MMON/Infrastructure/Resilience/CircuitBreaker.cs:121-152"
            ]
          },
          {
            "priority": 4,
            "task": "Add HalfOpen success threshold (default: 2) to close circuit",
            "files": [
              "C0MMON/Infrastructure/Resilience/CircuitBreaker.cs:127-133"
            ]
          },
          {
            "priority": 5,
            "task": "Add metrics emission on state changes - push to Dashboard or metrics collector",
            "files": [
              "C0MMON/Infrastructure/Resilience/CircuitBreaker.cs:107,131,147"
            ]
          },
          {
            "priority": 6,
            "task": "Integrate _mongoCircuit in H0UND/H0UND.cs Main loop",
            "files": [
              "H0UND/H0UND.cs:21,87-96,279"
            ]
          },
          {
            "priority": 7,
            "task": "Integrate _mongoCircuit and _seleniumCircuit in H4ND/H4ND.cs Main loop",
            "files": [
              "H4ND/H4ND.cs:23,61,117-129,381"
            ]
          },
          {
            "priority": 8,
            "task": "Add circuit breaker state to health monitoring in H0UND/H0UND.cs:287-293",
            "files": [
              "H0UND/H0UND.cs:287-293"
            ]
          },
          {
            "priority": 9,
            "task": "Add circuit breaker state to health monitoring in H4ND/H4ND.cs:386-392",
            "files": [
              "H4ND/H4ND.cs:386-392"
            ]
          },
          {
            "priority": 10,
            "task": "Create unit tests in UNI7T35T for circuit breaker state transitions",
            "files": [
              "UNI7T35T/CircuitBreakerTests.cs"
            ]
          }
        ],
        "codebaseIntegration": {
          "existingImplementation": {
            "file": "C0MMON/Infrastructure/Resilience/CircuitBreaker.cs",
            "status": "IMPLEMENTED - Basic circuit breaker exists",
            "features": [
              "CircuitState enum (Closed/Open/HalfOpen)",
              "CircuitBreakerOpenException",
              "ExecuteAsync<T> method",
              "Configurable failureThreshold and recoveryTimeout",
              "Manual Reset() method"
            ],
            "missingFeatures": [
              "No integration in H0UND/H4ND",
              "No circuit per dependency type",
              "No metrics emission",
              "No exception filtering",
              "No HalfOpen success threshold"
            ]
          },
          "integrationPoints": [
            {
              "file": "H0UND/H0UND.cs",
              "line": 21,
              "currentCode": "private static readonly MongoUnitOfWork s_uow = new();",
              "action": "Wrap MongoUnitOfWork operations with circuit breaker",
              "example": "private static readonly CircuitBreaker _mongoCircuit = new(3, TimeSpan.FromMinutes(5), msg => Dashboard.AddLog(msg, \"yellow\"));"
            },
            {
              "file": "H0UND/H0UND.cs",
              "line": "87-96",
              "currentCode": "Credential credential = uow.Credentials.GetNext(UsePriorityCalculation); uow.Credentials.Lock(credential);",
              "action": "Wrap credential operations with circuit breaker",
              "example": "credential = await _mongoCircuit.ExecuteAsync(() => uow.Credentials.GetNext(UsePriorityCalculation));"
            },
            {
              "file": "H4ND/H4ND.cs",
              "line": 61,
              "currentCode": "Signal? signal = listenForSignals ? (overrideSignal ?? uow.Signals.GetNext()) : null;",
              "action": "Wrap signal retrieval with circuit breaker",
              "example": "Signal? signal = listenForSignals ? await _mongoCircuit.ExecuteAsync(() => uow.Signals.GetNext()) : null;"
            },
            {
              "file": "H4ND/H4ND.cs",
              "line": "117-129",
              "currentCode": "double extensionGrand = Convert.ToDouble(activeDriver.ExecuteScript(\"return window.parent.Grand\")) / 100;",
              "action": "Wrap Selenium extension calls with circuit breaker",
              "example": "double extensionGrand = await _seleniumCircuit.ExecuteAsync(() => Convert.ToDouble(activeDriver.ExecuteScript(\"return window.parent.Grand\")) / 100);"
            }
          ],
          "perDependencyConfig": {
            "mongoDB": {
              "failureThreshold": 3,
              "recoveryTimeout": "00:00:30",
              "class": "CircuitBreaker",
              "field": "_mongoCircuit"
            },
            "selenium": {
              "failureThreshold": 3,
              "recoveryTimeout": "00:02:00",
              "class": "CircuitBreaker",
              "field": "_seleniumCircuit"
            },
            "fireKirinAPI": {
              "failureThreshold": 5,
              "recoveryTimeout": "00:01:00",
              "class": "CircuitBreaker",
              "field": "_fireKirinCircuit"
            },
            "orionStarsAPI": {
              "failureThreshold": 5,
              "recoveryTimeout": "00:01:00",
              "class": "CircuitBreaker",
              "field": "_orionStarsCircuit"
            }
          }
        },
        "exceptionsToIgnore": [
          {
            "exceptionType": "InvalidOperationException",
            "condition": "Message.Contains(\"No enabled, non-banned credentials\")",
            "reason": "No credentials available is not a circuit failure"
          },
          {
            "exceptionType": "InvalidOperationException",
            "condition": "Message.Contains(\"No unlocked credentials\")",
            "reason": "All locked is expected during high load"
          }
        ]
      }
    },
    {
      "_id": {
        "$oid": "69946b26a40de11d5c628ca1"
      },
      "decisionId": "DECISION_002",
      "title": "Graceful Degradation Strategies",
      "category": "Production Hardening",
      "description": "Implement 4-level degradation system: Normal (full signal generation), Reduced (batch signals when API latency > 500ms), Minimal (priority 3-5 only at 50% capacity), Emergency (halt automation)",
      "status": "Approved",
      "details": {
        "levels": [
          "Normal",
          "Reduced",
          "Minimal",
          "Emergency"
        ],
        "triggers": {
          "reduced": {
            "apiLatency": "> 500ms",
            "workerUtil": "> 60%"
          },
          "minimal": {
            "apiLatency": "> 1000ms",
            "workerUtil": "> 80%"
          },
          "emergency": {
            "apiLatency": "> 2000ms",
            "workerUtil": "> 90%"
          }
        },
        "degradationLevels": {
          "Normal": {
            "level": 0,
            "apiLatency": "<500ms",
            "workerUtil": "<60%",
            "signalGeneration": "Full - all jackpots",
            "automationCapacity": "100%",
            "visionProcessing": "Full frame analysis",
            "mongoOps": "Full CRUD",
            "behavior": "Normal operations"
          },
          "Reduced": {
            "level": 1,
            "apiLatency": ">500ms",
            "workerUtil": ">60%",
            "signalGeneration": "Batched - every 30 seconds",
            "automationCapacity": "70%",
            "visionProcessing": "Reduced frame rate (1fps)",
            "mongoOps": "Read-heavy, defer writes",
            "behavior": "Batch signals, queue non-critical operations"
          },
          "Minimal": {
            "level": 2,
            "apiLatency": ">1000ms",
            "workerUtil": ">80%",
            "signalGeneration": "Priority 3-4 only (Major/Grand)",
            "automationCapacity": "50%",
            "visionProcessing": "Key frames only",
            "mongoOps": "Critical writes only",
            "behavior": "Focus on high-value jackpots only"
          },
          "Emergency": {
            "level": 3,
            "apiLatency": ">2000ms",
            "workerUtil": ">90%",
            "signalGeneration": "HALT",
            "automationCapacity": "0%",
            "visionProcessing": "Disabled",
            "mongoOps": "Emergency logging only",
            "behavior": "Halt all automation, preserve state, alert Nexus"
          }
        },
        "events": {
          "OnDegradationChanged": "Event<DegradationLevel, DegradationLevel> - old and new level",
          "OnThresholdApproaching": "Event<string> - warning before transition",
          "OnEmergencyEntered": "Critical alert to Nexus"
        },
        "metricsCollector": {
          "sources": [
            "Process.GetCurrentProcess()",
            "HttpClient response times",
            "MongoDB operation times",
            "Worker pool queue depth"
          ],
          "interval": "Every 5 seconds",
          "historyWindow": "5 minutes rolling average"
        },
        "transitions": {
          "NormalToReduced": {
            "trigger": "apiLatency > 500ms OR workerUtil > 60% for 30 seconds",
            "cooldown": "60 seconds"
          },
          "ReducedToMinimal": {
            "trigger": "apiLatency > 1000ms OR workerUtil > 80% for 60 seconds",
            "cooldown": "120 seconds"
          },
          "MinimalToEmergency": {
            "trigger": "apiLatency > 2000ms OR workerUtil > 90% for 30 seconds",
            "cooldown": "300 seconds"
          },
          "EmergencyToMinimal": {
            "trigger": "apiLatency < 1500ms AND workerUtil < 85% for 60 seconds",
            "cooldown": "60 seconds"
          },
          "MinimalToReduced": {
            "trigger": "apiLatency < 800ms AND workerUtil < 70% for 60 seconds",
            "cooldown": "30 seconds"
          },
          "ReducedToNormal": {
            "trigger": "apiLatency < 400ms AND workerUtil < 50% for 60 seconds",
            "cooldown": "30 seconds"
          }
        },
        "componentCommunication": {
          "protocol": "SignalR or Redis Pub/Sub for real-time notifications",
          "messageTypes": [
            {
              "type": "DegradationLevelChanged",
              "payload": "{ oldLevel, newLevel, reason, timestamp }"
            },
            {
              "type": "ThresholdApproaching",
              "payload": "{ currentLevel, metric, value, threshold }"
            },
            {
              "type": "EmergencyDeclared",
              "payload": "{ reason, affectedComponents, timestamp }"
            }
          ],
          "heartbeatInterval": "5 seconds",
          "timeoutBeforeIsolation": "30 seconds - if H0UND stops responding, H4ND assumes Emergency"
        },
        "dependencyMapping": {
          "hound": {
            "dependsOn": [
              "MongoDB",
              "ExternalAPI",
              "VisionStream"
            ],
            "canOperateWithout": [
              "VisionStream (fallback to polling)"
            ],
            "criticalFailure": "MongoDB down -> Emergency"
          },
          "hand": {
            "dependsOn": [
              "H0UND (for signals)",
              "Selenium",
              "GamePlatform"
            ],
            "canOperateWithout": [
              "None - automation requires all"
            ],
            "criticalFailure": "Selenium crash -> Reduce capacity, restart workers"
          },
          "watchdog": {
            "dependsOn": [
              "OBS",
              "LMStudio"
            ],
            "canOperateWithout": [
              "LMStudio (fallback to pattern matching)"
            ],
            "criticalFailure": "OBS down -> Disable vision, alert"
          }
        },
        "manualOverride": {
          "enabled": true,
          "commands": [
            {
              "command": "set-degradation <level>",
              "auth": "Admin only",
              "effect": "Override automatic detection"
            },
            {
              "command": "reset-degradation",
              "auth": "Admin only",
              "effect": "Return to automatic mode"
            },
            {
              "command": "get-degradation-status",
              "auth": "All",
              "effect": "Show current level and metrics"
            }
          ],
          "overrideTimeout": "30 minutes - then return to automatic",
          "auditLog": "All manual overrides logged to D3CISI0NS"
        },
        "metricsThresholds": {
          "apiLatency": {
            "normal": "< 500ms",
            "warning": "500-1000ms",
            "critical": "> 1000ms",
            "emergency": "> 2000ms"
          },
          "workerUtilization": {
            "normal": "< 60%",
            "warning": "60-80%",
            "critical": "80-90%",
            "emergency": "> 90%"
          },
          "errorRate": {
            "normal": "< 1%",
            "warning": "1-5%",
            "critical": "5-10%",
            "emergency": "> 10%"
          },
          "queueDepth": {
            "normal": "< 50",
            "warning": "50-100",
            "critical": "100-500",
            "emergency": "> 500"
          }
        },
        "priorityQueueImplementation": {
          "description": "When in Minimal mode, only process high-priority signals",
          "signalPriorities": {
            "Grand": {
              "priority": 4,
              "alwaysProcess": true,
              "reason": "Highest value, least frequent"
            },
            "Major": {
              "priority": 3,
              "processInMinimal": true,
              "reason": "High value, moderate frequency"
            },
            "Minor": {
              "priority": 2,
              "processInMinimal": false,
              "reason": "Lower value, higher frequency"
            },
            "Mini": {
              "priority": 1,
              "processInMinimal": false,
              "reason": "Lowest value, most frequent"
            }
          },
          "queueImplementation": "PriorityQueue<Signal, int> with concurrent access",
          "batchingInReduced": {
            "window": "30 seconds",
            "maxBatchSize": 50,
            "strategy": "Group by house/game, process together"
          }
        },
        "recoveryProcedures": {
          "fromEmergency": {
            "steps": [
              "Verify root cause resolved (check alerts)",
              "Wait for metrics to stabilize (60 seconds)",
              "Transition to Minimal",
              "Gradually increase load over 5 minutes",
              "Return to Normal if stable"
            ],
            "autoRecover": true,
            "requireManualApproval": false
          },
          "fromMinimal": {
            "steps": [
              "Monitor metrics for 60 seconds",
              "Transition to Reduced if improved",
              "Wait 30 seconds in Reduced",
              "Transition to Normal if stable"
            ],
            "autoRecover": true
          },
          "fromReduced": {
            "steps": [
              "Gradually restore full capacity over 2 minutes",
              "Transition to Normal"
            ],
            "autoRecover": true
          }
        },
        "resourceAllocation": {
          "Normal": {
            "workerThreads": 10,
            "memoryLimit": "2GB",
            "networkBandwidth": "unlimited"
          },
          "Reduced": {
            "workerThreads": 7,
            "memoryLimit": "1.5GB",
            "networkBandwidth": "70%"
          },
          "Minimal": {
            "workerThreads": 5,
            "memoryLimit": "1GB",
            "networkBandwidth": "50%"
          },
          "Emergency": {
            "workerThreads": 1,
            "memoryLimit": "500MB",
            "networkBandwidth": "10% (logs only)"
          }
        },
        "statePersistence": {
          "storage": "MongoDB collection: D3GR4D4T10N_ST4T3",
          "schema": {
            "_id": "ObjectId",
            "component": "string (H0UND/H4ND/W4TCHD0G)",
            "currentLevel": "string (Normal/Reduced/Minimal/Emergency)",
            "enteredAt": "DateTime",
            "reason": "string",
            "metrics": "{ apiLatency, workerUtil, queueDepth, errorRate }"
          },
          "purpose": "Recover degradation state after restart, audit trail",
          "ttl": "30 days"
        },
        "testingStrategy": {
          "unitTests": [
            "Level calculation from metrics",
            "Transition cooldown enforcement",
            "Priority queue filtering",
            "Resource allocation per level"
          ],
          "integrationTests": [
            "Full degradation flow: Normal -> Emergency -> Normal",
            "Multi-component coordination",
            "State persistence and recovery after restart"
          ],
          "chaosTests": [
            "Inject API latency spikes",
            "Simulate worker exhaustion",
            "Network partition scenarios"
          ]
        },
        "actionItems": [
          {
            "priority": 1,
            "task": "Create C0MMON/Infrastructure/Resilience/DegradationLevel.cs enum",
            "files": [
              "C0MMON/Infrastructure/Resilience/DegradationLevel.cs"
            ]
          },
          {
            "priority": 2,
            "task": "Create C0MMON/Infrastructure/Resilience/SystemMetrics.cs with latency/utilization tracking",
            "files": [
              "C0MMON/Infrastructure/Resilience/SystemMetrics.cs"
            ]
          },
          {
            "priority": 3,
            "task": "Create C0MMON/Infrastructure/Resilience/IDegradationManager.cs interface",
            "files": [
              "C0MMON/Infrastructure/Resilience/IDegradationManager.cs"
            ]
          },
          {
            "priority": 4,
            "task": "Create C0MMON/Infrastructure/Resilience/SystemDegradationManager.cs with state machine",
            "files": [
              "C0MMON/Infrastructure/Resilience/SystemDegradationManager.cs"
            ]
          },
          {
            "priority": 5,
            "task": "Add latency tracking to H0UND/Infrastructure/Polling/FireKirinBalanceProvider.cs",
            "files": [
              "H0UND/Infrastructure/Polling/FireKirinBalanceProvider.cs"
            ]
          },
          {
            "priority": 6,
            "task": "Add latency tracking to H0UND/Infrastructure/Polling/OrionStarsBalanceProvider.cs",
            "files": [
              "H0UND/Infrastructure/Polling/OrionStarsBalanceProvider.cs"
            ]
          },
          {
            "priority": 7,
            "task": "Extend DataCorruptionMonitor to collect system metrics",
            "files": [
              "C0MMON/Monitoring/DataCorruptionMonitor.cs:42-72"
            ]
          },
          {
            "priority": 8,
            "task": "Integrate degradation manager in H0UND/H0UND.cs Main loop",
            "files": [
              "H0UND/H0UND.cs:56-58"
            ]
          },
          {
            "priority": 9,
            "task": "Integrate degradation manager in H4ND/H4ND.cs Main loop",
            "files": [
              "H4ND/H4ND.cs:42,57-58"
            ]
          },
          {
            "priority": 10,
            "task": "Add degradation level display to Dashboard",
            "files": [
              "C0MMON/Services/Dashboard.cs"
            ]
          },
          {
            "priority": 11,
            "task": "Add D3GR4D4T10N_ST4T3 MongoDB collection for state persistence",
            "files": [
              "C0MMON/Infrastructure/Persistence/MongoCollectionNames.cs"
            ]
          },
          {
            "priority": 12,
            "task": "Create unit tests for degradation level transitions",
            "files": [
              "UNI7T35T/DegradationManagerTests.cs"
            ]
          }
        ],
        "codebaseIntegration": {
          "existingImplementation": {
            "status": "NOT IMPLEMENTED - Needs new classes",
            "relatedCode": [
              {
                "file": "H0UND/H0UND.cs:287-293",
                "description": "Basic health check exists - counts errors from ERR0R collection"
              },
              {
                "file": "H4ND/H4ND.cs:386-392",
                "description": "Basic health check exists - similar error counting"
              },
              {
                "file": "C0MMON/Monitoring/DataCorruptionMonitor.cs",
                "description": "Timer-based monitoring exists - can be extended"
              },
              {
                "file": "H0UND/H0UND.cs:68-73",
                "description": "Pause state exists - Dashboard.IsPaused can be reused for Emergency mode"
              }
            ]
          },
          "integrationPoints": [
            {
              "file": "H0UND/H0UND.cs",
              "line": 56,
              "action": "Add degradation check at start of main loop",
              "codeToAdd": "var degradationLevel = await _degradationManager.CheckDegradation(); if (degradationLevel == DegradationLevel.Emergency) { Dashboard.AddLog(\"EMERGENCY: Automation halted\", \"red\"); Thread.Sleep(60000); continue; }"
            },
            {
              "file": "H0UND/H0UND.cs",
              "line": "76-82",
              "action": "Skip analytics in Minimal/Emergency mode",
              "codeToAdd": "if (degradationLevel < DegradationLevel.Minimal) { analyticsWorker.RunAnalytics(uow); }"
            },
            {
              "file": "H0UND/H0UND.cs",
              "line": "87",
              "action": "Use priority calculation in Minimal mode",
              "currentCode": "Credential credential = uow.Credentials.GetNext(UsePriorityCalculation);",
              "codeToChange": "Credential credential = uow.Credentials.GetNext(degradationLevel >= DegradationLevel.Minimal ? true : UsePriorityCalculation);"
            },
            {
              "file": "H4ND/H4ND.cs",
              "line": 61,
              "action": "Skip low-priority signals in Minimal mode",
              "codeToAdd": "Signal? signal = listenForSignals ? (overrideSignal ?? uow.Signals.GetNext()) : null; if (signal != null && degradationLevel == DegradationLevel.Minimal && signal.Priority < 3) { signal = null; }"
            },
            {
              "file": "C0MMON/Services/Dashboard.cs",
              "action": "Add DegradationLevel property and display",
              "codeToAdd": "public static DegradationLevel CurrentDegradationLevel { get; set; } = DegradationLevel.Normal;"
            }
          ],
          "metricsSources": {
            "apiLatency": {
              "source": "H0UND/Infrastructure/Polling/FireKirinBalanceProvider.cs and OrionStarsBalanceProvider.cs",
              "measure": "Stopwatch around HTTP requests",
              "aggregation": "Rolling average over 5 minutes"
            },
            "workerUtil": {
              "source": "H4ND/H4ND.cs - credential processing",
              "measure": "Time spent processing vs idle time",
              "calculation": "(processingTime / totalTime) * 100"
            },
            "queueDepth": {
              "source": "MongoDB EV3NT collection",
              "measure": "db.SIGN4L.countDocuments({ Acknowledged: false })",
              "query": "uow.Signals.GetAll().Count(s => !s.Acknowledged)"
            },
            "errorRate": {
              "source": "MongoDB ERR0R collection",
              "measure": "Errors per minute",
              "existing": "uow.Errors.GetBySource(\"H0UND\").Count(e => e.Timestamp > DateTime.UtcNow.AddMinutes(-5))"
            }
          }
        },
        "signalPriorityBehavior": {
          "Normal": {
            "grand": true,
            "major": true,
            "minor": true,
            "mini": true
          },
          "Reduced": {
            "grand": true,
            "major": true,
            "minor": true,
            "mini": "batched every 30s"
          },
          "Minimal": {
            "grand": true,
            "major": true,
            "minor": false,
            "mini": false
          },
          "Emergency": {
            "grand": false,
            "major": false,
            "minor": false,
            "mini": false,
            "haltAll": true
          }
        }
      }
    },
    {
      "_id": {
        "$oid": "69946b26a40de11d5c628ca2"
      },
      "decisionId": "DECISION_003",
      "title": "Idempotency Guarantees",
      "category": "Production Hardening",
      "description": "Ensure all operations are idempotent using OperationTracker with 5-minute TTL deduplication to prevent duplicate operations (double-billing, double-spinning)",
      "status": "Approved",
      "details": {
        "operationIdTTL": "5 minutes",
        "pattern": "signal:{jackpot_id}:{timestamp}",
        "cleanupStrategy": {
          "method": "TTL-based expiration",
          "backgroundCleanup": "Every 5 minutes scan for expired entries",
          "maxEntries": "100,000 in-memory, unlimited with TTL index"
        },
        "duplicateHandling": {
          "strategy": "Return cached result or skip",
          "behaviors": {
            "signalAlreadyGenerated": "Return existing signal, do not create new one",
            "spinAlreadyExecuted": "Skip spin, log warning, continue",
            "updateAlreadyApplied": "Skip update, return success (already done)"
          }
        },
        "idempotencyPatterns": {
          "signalGeneration": {
            "pattern": "signal:{jackpotId}:{threshold}:{timestampMinute}",
            "example": "signal:FireKirin_House1_Grand:1785:202602171530",
            "ttl": "5 minutes",
            "scope": "Per jackpot per threshold per minute"
          },
          "automationSpin": {
            "pattern": "spin:{credentialId}:{jackpotType}:{timestampMinute}",
            "example": "spin:user123@House1:Grand:202602171530",
            "ttl": "2 minutes",
            "scope": "Per credential per jackpot type per minute"
          },
          "jackpotUpdate": {
            "pattern": "jackpot_update:{house}:{game}:{jackpotType}:{timestampMinute}",
            "example": "jackpot_update:House1:FireKirin:Grand:202602171530",
            "ttl": "1 minute",
            "scope": "Per house/game/jackpot per minute"
          },
          "credentialUpdate": {
            "pattern": "cred_update:{credentialId}:{operation}:{timestampMinute}",
            "example": "cred_update:user123:balance_sync:202602171530",
            "ttl": "5 minutes",
            "scope": "Per credential per operation per minute"
          }
        },
        "storageOptions": {
          "inMemory": {
            "implementation": "ConcurrentDictionary<string, DateTime>",
            "pros": [
              "Fast",
              "No dependencies"
            ],
            "cons": [
              "Lost on restart",
              "Not distributed"
            ],
            "useWhen": "Single instance, transient operations"
          },
          "redis": {
            "implementation": "IDistributedCache with TTL",
            "pros": [
              "Distributed",
              "Persistent",
              "Atomic TTL"
            ],
            "cons": [
              "External dependency",
              "Network latency"
            ],
            "useWhen": "Multi-instance H4ND/H0UND, critical operations"
          },
          "mongodb": {
            "implementation": "TTL index on dedicated collection",
            "pros": [
              "Already available",
              "Persistent",
              "Queryable"
            ],
            "cons": [
              "Slower than memory",
              "Write overhead"
            ],
            "useWhen": "Need audit trail, querying capability"
          }
        },
        "advancedPatterns": {
          "compositeOperationId": {
            "description": "Combine multiple factors for unique identification",
            "pattern": "{context}:{entity}:{action}:{hash}:{minute}",
            "example": "automation:cred123@House1:spin:abc123:202602171530",
            "hashFunction": "SHA256 of operation parameters (truncated to 8 chars)"
          },
          "hierarchicalOperations": {
            "description": "Parent-child operation tracking",
            "parentPattern": "batch:{batchId}:{timestamp}",
            "childPattern": "batch:{batchId}:item:{itemId}:{timestamp}",
            "behavior": "Parent tracks overall batch, children track individual items"
          },
          "conditionalIdempotency": {
            "description": "Idempotency based on operation result",
            "rules": [
              "Success: Mark as complete, return cached result on retry",
              "Failure (transient): Allow retry with same ID",
              "Failure (permanent): Mark as failed, reject retries"
            ]
          }
        },
        "distributedScenarios": {
          "multiInstanceH4ND": {
            "problem": "Multiple H4ND instances may process same credential",
            "solution": "Distributed lock + operation tracker",
            "lockProvider": "Redis or MongoDB findAndModify",
            "lockTimeout": "30 seconds",
            "lockAcquisition": "TryAcquireLock, if fails -> skip operation"
          },
          "concurrentSignalGeneration": {
            "problem": "H0UND generates signal while H4ND processes same jackpot",
            "solution": "Operation ID includes jackpot state hash",
            "stateHash": "Hash of (jackpot value + threshold + timestamp minute)",
            "behavior": "Same jackpot state = same operation = skip if exists"
          },
          "crossDatacenterRecovery": {
            "problem": "Operation completed but response lost before client received",
            "solution": "Client retries with same operation ID, server returns cached result",
            "resultTTL": "5 minutes",
            "storage": "MongoDB with TTL index"
          }
        },
        "errorHandling": {
          "duplicateDetectionStrategies": {
            "strict": "Reject duplicate immediately with exception",
            "returnCached": "Return previously stored result (if available)",
            "reExecute": "Execute again but only once (for read operations)",
            "configurable": "Per-operation strategy selection"
          },
          "conflictResolution": {
            "scenario": "Two operations with same ID complete simultaneously",
            "resolution": "First write wins, second is logged as duplicate attempt",
            "locking": "Optimistic concurrency with ETag/version check"
          },
          "partialFailure": {
            "scenario": "Multi-step operation fails partway through",
            "solution": "Compensating transactions or rollback markers",
            "example": "Signal created but notification failed -> mark for retry"
          }
        },
        "monitoring": {
          "metrics": [
            {
              "name": "idempotency_operations_total",
              "type": "counter",
              "labels": [
                "operation_type",
                "status"
              ]
            },
            {
              "name": "idempotency_duplicates_rejected_total",
              "type": "counter",
              "labels": [
                "operation_type"
              ]
            },
            {
              "name": "idempotency_cache_hits_total",
              "type": "counter",
              "labels": [
                "operation_type"
              ]
            },
            {
              "name": "idempotency_active_entries",
              "type": "gauge"
            }
          ],
          "alerts": [
            {
              "condition": "duplicate_rate > 10%",
              "severity": "warning",
              "message": "High duplicate operation rate - possible retry storm"
            },
            {
              "condition": "active_entries > 80,000",
              "severity": "warning",
              "message": "Approaching entry limit - consider cleanup"
            }
          ]
        },
        "performanceMetrics": {
          "idGeneration": "SHA256 hash: ~10 microseconds",
          "inMemoryCheck": "~1 microsecond (dictionary lookup)",
          "mongodbCheck": "~5-10ms (indexed query)",
          "redisCheck": "~1-2ms (network roundtrip)",
          "storageOverhead": "~500 bytes per operation entry",
          "recommendedLimit": "100,000 active entries before cleanup"
        },
        "storageSchema": {
          "inMemory": {
            "structure": "ConcurrentDictionary<string, OperationEntry>",
            "operationEntry": {
              "operationId": "string",
              "startedAt": "DateTime",
              "completedAt": "DateTime?",
              "status": "enum (InProgress, Completed, Failed)",
              "result": "object (serialized, optional)",
              "checksum": "string (for result validation)"
            }
          },
          "mongodb": {
            "collection": "1D3MP0T3NCY",
            "schema": {
              "_id": "ObjectId",
              "operationId": "string (indexed, unique)",
              "operationType": "string",
              "entityId": "string",
              "status": "string",
              "startedAt": "DateTime",
              "completedAt": "DateTime?",
              "result": "object (optional)",
              "error": "string (if failed)",
              "retryCount": "int",
              "ttl": "DateTime (TTL index, auto-delete)"
            },
            "indexes": [
              {
                "key": {
                  "operationId": 1
                },
                "unique": true
              },
              {
                "key": {
                  "entityId": 1,
                  "operationType": 1
                }
              },
              {
                "key": {
                  "ttl": 1
                },
                "expireAfterSeconds": 0
              }
            ]
          },
          "redis": {
            "keyPattern": "idempotent:{operationId}",
            "value": "JSON { status, result, timestamp }",
            "ttl": "300 seconds",
            "commands": [
              "SETNX",
              "GET",
              "SETEX"
            ]
          }
        },
        "testingStrategy": {
          "unitTests": [
            "Generate unique operation ID for same inputs",
            "Reject duplicate operation ID",
            "Return cached result on retry",
            "TTL expiration works correctly",
            "Thread-safe concurrent access"
          ],
          "integrationTests": [
            "End-to-end idempotent signal generation",
            "Multi-instance concurrent operation handling",
            "Recovery from crash during operation"
          ],
          "chaosTests": [
            "Kill process mid-operation",
            "Network partition during commit",
            "Race condition: two instances same operation"
          ]
        },
        "actionItems": [
          {
            "priority": 1,
            "task": "Create C0MMON/Infrastructure/Resilience/IOperationTracker.cs interface",
            "files": [
              "C0MMON/Infrastructure/Resilience/IOperationTracker.cs"
            ]
          },
          {
            "priority": 2,
            "task": "Create C0MMON/Infrastructure/Resilience/OperationTracker.cs with MongoDB storage",
            "files": [
              "C0MMON/Infrastructure/Resilience/OperationTracker.cs"
            ]
          },
          {
            "priority": 3,
            "task": "Add OperationId property to Signal entity",
            "files": [
              "C0MMON/Entities/Signal.cs"
            ]
          },
          {
            "priority": 4,
            "task": "Add 1D3MP0T3NCY to MongoCollectionNames",
            "files": [
              "C0MMON/Infrastructure/Persistence/MongoCollectionNames.cs"
            ]
          },
          {
            "priority": 5,
            "task": "Create IStoreIdempotency interface and repository",
            "files": [
              "C0MMON/Interfaces/IStoreIdempotency.cs",
              "C0MMON/Infrastructure/Persistence/Repositories.cs"
            ]
          },
          {
            "priority": 6,
            "task": "Add TTL index creation for 1D3MP0T3NCY collection on startup",
            "files": [
              "C0MMON/Infrastructure/Persistence/MongoDatabaseProvider.cs"
            ]
          },
          {
            "priority": 7,
            "task": "Integrate OperationTracker in SignalService.GenerateSignals",
            "files": [
              "H0UND/Domain/Signals/SignalService.cs:47-49"
            ]
          },
          {
            "priority": 8,
            "task": "Integrate OperationTracker in H4ND signal.Receive",
            "files": [
              "H4ND/H4ND.cs:193-204"
            ]
          },
          {
            "priority": 9,
            "task": "Integrate OperationTracker in spin operations",
            "files": [
              "C0MMON/Games/FireKirin.cs",
              "C0MMON/Games/FortunePiggy.cs"
            ]
          },
          {
            "priority": 10,
            "task": "Add idempotency status to health monitoring",
            "files": [
              "H0UND/H0UND.cs:287-293",
              "H4ND/H4ND.cs:386-392"
            ]
          },
          {
            "priority": 11,
            "task": "Create unit tests for operation ID generation and duplicate detection",
            "files": [
              "UNI7T35T/OperationTrackerTests.cs"
            ]
          }
        ],
        "codebaseIntegration": {
          "existingImplementation": {
            "status": "NOT IMPLEMENTED - Needs new classes",
            "relatedCode": [
              {
                "file": "H0UND/Domain/Signals/SignalService.cs:47-49",
                "description": "Signal generation - needs operation ID"
              },
              {
                "file": "H4ND/H4ND.cs:193-204",
                "description": "Signal.Receive() - needs idempotency check"
              },
              {
                "file": "H4ND/H4ND.cs:212-226",
                "description": "SpinSlots and Spin operations - needs operation ID"
              },
              {
                "file": "C0MMON/Infrastructure/Persistence/Repositories.cs:250-265",
                "description": "Signal.Upsert already has upsert logic - can extend with operation ID"
              }
            ]
          },
          "integrationPoints": [
            {
              "file": "H0UND/Domain/Signals/SignalService.cs",
              "method": "GenerateSignals",
              "line": "47-49",
              "action": "Add operation ID to signal generation",
              "currentCode": "Signal sig = new Signal(jackpot.Priority, cred) { Timeout = DateTime.UtcNow.AddSeconds(30), Acknowledged = false };",
              "codeToAdd": "string opId = $\"signal:{jackpot.House}:{jackpot.Game}:{jackpot.Priority}:{DateTime.UtcNow:yyyyMMddHHmm}\"; if (!await _operationTracker.TryBeginOperation(opId, TimeSpan.FromMinutes(5))) continue; Signal sig = new Signal(jackpot.Priority, cred) { OperationId = opId, Timeout = DateTime.UtcNow.AddSeconds(30), Acknowledged = false };"
            },
            {
              "file": "H4ND/H4ND.cs",
              "method": "Main",
              "line": "193-204",
              "action": "Add idempotency check for signal.Receive",
              "codeToAdd": "string opId = $\"receive:{signal.House}:{signal.Game}:{signal.Username}:{signal.Priority}:{DateTime.UtcNow:yyyyMMddHHmm}\"; if (await _operationTracker.TryBeginOperation(opId, TimeSpan.FromMinutes(2))) { signal.Receive(currentGrand, uow.Received); }"
            },
            {
              "file": "C0MMON/Games/FireKirin.cs",
              "method": "SpinSlots",
              "action": "Add operation ID to spin operations",
              "codeToAdd": "string opId = $\"spin:{credential.Username}:{credential.House}:{signal.Priority}:{DateTime.UtcNow:yyyyMMddHHmm}\";"
            },
            {
              "file": "C0MMON/Infrastructure/Persistence/Repositories.cs",
              "method": "RepoCredentials.Upsert",
              "line": "164-179",
              "action": "Add operation ID for credential updates",
              "note": "Credential upserts are frequent - consider lower TTL (1 minute)"
            }
          ],
          "storageImplementation": {
            "primary": "MongoDB",
            "collection": "1D3MP0T3NCY",
            "schema": {
              "_id": "ObjectId",
              "operationId": "string (indexed unique)",
              "operationType": "string (signal/receive/spin/update)",
              "entityId": "string",
              "status": "string (InProgress/Completed/Failed)

... (truncated)
```
