# Model Fallback System Tests

## Overview

Unit tests for the model fallback system ensuring reliable agent model switching when primary models fail.

## Test Suites

| File | Purpose |
|------|---------|
| `fallback-system.test.ts` | Main test suite: trigger, chain traversal, state recovery, circuit breaker, retry |
| `mock-model-server.ts` | Mock model server responses for testing |
| `failure-scenarios.ts` | Failure condition definitions (timeout, rate limit, context length, auth) |

## Running Tests

```bash
npx vitest run tests/fallback/
```

## Test Requirements

1. **Fallback Trigger Tests**: Verify fallback activates on specific failure conditions
2. **Chain Traversal Tests**: Ensure fallback properly iterates through agent model chains
3. **State Recovery Tests**: Verify system returns to primary model after recovery
4. **Circuit Breaker Tests**: Ensure circuit breaker prevents hammering failed models
5. **Retry Logic Tests**: Verify exponential backoff and retry counts

## Success Criteria

- 95%+ test coverage for fallback logic
- All failure scenarios tested
- No regressions in existing model chains

## Dependencies

- Vitest (test framework)
- Mock model server implementations
