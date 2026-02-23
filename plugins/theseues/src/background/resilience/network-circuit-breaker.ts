/**
 * Network Circuit Breaker
 *
 * Per-endpoint circuit breaker for network-level failures.
 * Shorter cooldown (5 minutes) compared to model-level breaker (1 hour).
 *
 * States:
 * - CLOSED:    Normal operation, requests pass through
 * - OPEN:      Failures exceeded threshold, requests blocked
 * - HALF_OPEN: Cooldown expired, one probe request allowed
 *
 * DECISION_037 (INFRA-037-004)
 */

import { log } from '../../utils/debug';

export type CircuitState = 'closed' | 'open' | 'half-open';

export interface CircuitStatus {
  state: CircuitState;
  failures: number;
  lastFailure?: number;
  lastSuccess?: number;
  totalFailures: number;
  totalSuccesses: number;
}

export interface NetworkCircuitBreakerConfig {
  /** Number of consecutive failures before opening circuit */
  failureThreshold: number;
  /** Cooldown in ms before trying half-open probe */
  cooldownMs: number;
  /** Successes required in half-open to close circuit */
  halfOpenSuccessThreshold: number;
}

const DEFAULT_CONFIG: NetworkCircuitBreakerConfig = {
  failureThreshold: 5,
  cooldownMs: 300_000, // 5 minutes
  halfOpenSuccessThreshold: 1,
};

interface EndpointCircuit {
  state: CircuitState;
  consecutiveFailures: number;
  halfOpenSuccesses: number;
  lastFailure: number;
  lastSuccess: number;
  totalFailures: number;
  totalSuccesses: number;
}

export class NetworkCircuitBreaker {
  private circuits = new Map<string, EndpointCircuit>();
  private config: NetworkCircuitBreakerConfig;

  constructor(config?: Partial<NetworkCircuitBreakerConfig>) {
    this.config = { ...DEFAULT_CONFIG, ...config };
  }

  /**
   * Check if a request to this endpoint should be allowed.
   */
  canAttempt(endpoint: string): boolean {
    const circuit = this.circuits.get(endpoint);
    if (!circuit) return true; // Unknown endpoint = assume healthy

    switch (circuit.state) {
      case 'closed':
        return true;

      case 'open': {
        const elapsed = Date.now() - circuit.lastFailure;
        if (elapsed >= this.config.cooldownMs) {
          // Transition to half-open: allow one probe
          circuit.state = 'half-open';
          circuit.halfOpenSuccesses = 0;
          log(
            `[network-cb] Circuit for ${endpoint} transitioning to half-open after ${elapsed}ms cooldown`,
          );
          return true;
        }
        log(
          `[network-cb] Circuit for ${endpoint} is OPEN, blocking request (${Math.ceil((this.config.cooldownMs - elapsed) / 1000)}s remaining)`,
        );
        return false;
      }

      case 'half-open':
        // Allow probe request in half-open state
        return true;
    }
  }

  /**
   * Record a successful request to an endpoint.
   */
  recordSuccess(endpoint: string): void {
    const circuit = this.circuits.get(endpoint);
    if (!circuit) {
      // First interaction — create healthy circuit
      this.circuits.set(endpoint, {
        state: 'closed',
        consecutiveFailures: 0,
        halfOpenSuccesses: 1,
        lastFailure: 0,
        lastSuccess: Date.now(),
        totalFailures: 0,
        totalSuccesses: 1,
      });
      return;
    }

    circuit.lastSuccess = Date.now();
    circuit.totalSuccesses++;

    if (circuit.state === 'half-open') {
      circuit.halfOpenSuccesses++;
      if (
        circuit.halfOpenSuccesses >= this.config.halfOpenSuccessThreshold
      ) {
        // Enough successes in half-open → close circuit
        circuit.state = 'closed';
        circuit.consecutiveFailures = 0;
        log(
          `[network-cb] Circuit for ${endpoint} CLOSED after ${circuit.halfOpenSuccesses} successful probes`,
        );
      }
    } else {
      // Reset consecutive failures on success
      circuit.consecutiveFailures = 0;
    }
  }

  /**
   * Record a failed request to an endpoint.
   */
  recordFailure(endpoint: string): void {
    let circuit = this.circuits.get(endpoint);
    if (!circuit) {
      circuit = {
        state: 'closed',
        consecutiveFailures: 0,
        halfOpenSuccesses: 0,
        lastFailure: Date.now(),
        lastSuccess: 0,
        totalFailures: 0,
        totalSuccesses: 0,
      };
      this.circuits.set(endpoint, circuit);
    }

    circuit.consecutiveFailures++;
    circuit.lastFailure = Date.now();
    circuit.totalFailures++;

    if (circuit.state === 'half-open') {
      // Failed during probe — reopen circuit
      circuit.state = 'open';
      log(
        `[network-cb] Circuit for ${endpoint} re-OPENED after half-open probe failure`,
      );
      return;
    }

    if (circuit.consecutiveFailures >= this.config.failureThreshold) {
      circuit.state = 'open';
      log(
        `[network-cb] Circuit for ${endpoint} OPENED after ${circuit.consecutiveFailures} consecutive failures`,
      );
    }
  }

  /**
   * Get the current status of a circuit.
   */
  getStatus(endpoint: string): CircuitStatus {
    const circuit = this.circuits.get(endpoint);
    if (!circuit) {
      return {
        state: 'closed',
        failures: 0,
        totalFailures: 0,
        totalSuccesses: 0,
      };
    }
    return {
      state: circuit.state,
      failures: circuit.consecutiveFailures,
      lastFailure:
        circuit.lastFailure > 0 ? circuit.lastFailure : undefined,
      lastSuccess:
        circuit.lastSuccess > 0 ? circuit.lastSuccess : undefined,
      totalFailures: circuit.totalFailures,
      totalSuccesses: circuit.totalSuccesses,
    };
  }

  /**
   * Get a summary of all circuits (for logging / visibility).
   */
  getAllStatuses(): Record<string, CircuitStatus> {
    const result: Record<string, CircuitStatus> = {};
    for (const [endpoint] of this.circuits) {
      result[endpoint] = this.getStatus(endpoint);
    }
    return result;
  }

  /**
   * Reset a specific circuit back to closed.
   */
  reset(endpoint: string): void {
    this.circuits.delete(endpoint);
    log(`[network-cb] Circuit for ${endpoint} manually reset`);
  }

  /**
   * Reset all circuits.
   */
  resetAll(): void {
    this.circuits.clear();
    log('[network-cb] All circuits reset');
  }
}
