/**
 * INFRA-037: Network circuit breaker with per-endpoint tracking.
 * States: Closed (normal) → Open (failing) → HalfOpen (testing recovery).
 * 5-minute cooldown before testing recovery.
 */

export enum CircuitState {
  /** Normal operation - requests pass through */
  Closed = 'closed',
  /** Circuit tripped - requests are rejected immediately */
  Open = 'open',
  /** Testing recovery - allowing a single request through */
  HalfOpen = 'half_open',
}

export interface CircuitBreakerConfig {
  /** Number of failures before opening the circuit (default: 5) */
  failureThreshold: number;
  /** Time in ms before attempting recovery (default: 300000 = 5 min) */
  recoveryTimeoutMs: number;
  /** Number of successes in half-open state before closing (default: 2) */
  successThreshold: number;
}

interface CircuitInfo {
  state: CircuitState;
  failures: number;
  successes: number;
  lastFailure: Date | null;
  lastStateChange: Date;
  totalTrips: number;
}

const DEFAULT_CONFIG: CircuitBreakerConfig = {
  failureThreshold: 5,
  recoveryTimeoutMs: 300000, // 5 minutes
  successThreshold: 2,
};

export class NetworkCircuitBreaker {
  private config: CircuitBreakerConfig;
  private circuits: Map<string, CircuitInfo> = new Map();
  private listeners: Array<(endpoint: string, state: CircuitState) => void> = [];

  constructor(config?: Partial<CircuitBreakerConfig>) {
    this.config = { ...DEFAULT_CONFIG, ...config };
  }

  /**
   * Checks if a request to the endpoint should be allowed.
   * Returns true if the circuit allows the request.
   */
  allowRequest(endpoint: string): boolean {
    const circuit = this.getOrCreate(endpoint);

    switch (circuit.state) {
      case CircuitState.Closed:
        return true;

      case CircuitState.Open: {
        // Check if recovery timeout has elapsed
        const elapsed = Date.now() - circuit.lastStateChange.getTime();
        if (elapsed >= this.config.recoveryTimeoutMs) {
          this.transition(endpoint, circuit, CircuitState.HalfOpen);
          return true; // Allow one test request
        }
        return false; // Still in cooldown
      }

      case CircuitState.HalfOpen:
        return true; // Allow test requests
    }
  }

  /**
   * Records a successful request.
   */
  recordSuccess(endpoint: string): void {
    const circuit = this.getOrCreate(endpoint);

    switch (circuit.state) {
      case CircuitState.Closed:
        circuit.failures = 0; // Reset failure count
        break;

      case CircuitState.HalfOpen:
        circuit.successes++;
        if (circuit.successes >= this.config.successThreshold) {
          this.transition(endpoint, circuit, CircuitState.Closed);
        }
        break;

      case CircuitState.Open:
        // Shouldn't happen, but handle gracefully
        break;
    }
  }

  /**
   * Records a failed request.
   */
  recordFailure(endpoint: string): void {
    const circuit = this.getOrCreate(endpoint);
    circuit.failures++;
    circuit.lastFailure = new Date();

    switch (circuit.state) {
      case CircuitState.Closed:
        if (circuit.failures >= this.config.failureThreshold) {
          this.transition(endpoint, circuit, CircuitState.Open);
        }
        break;

      case CircuitState.HalfOpen:
        // Recovery test failed — back to open
        this.transition(endpoint, circuit, CircuitState.Open);
        break;

      case CircuitState.Open:
        // Already open, just update failure count
        break;
    }
  }

  /**
   * Gets the current state of a circuit.
   */
  getState(endpoint: string): CircuitState {
    return this.getOrCreate(endpoint).state;
  }

  /**
   * Gets detailed circuit info for an endpoint.
   */
  getInfo(endpoint: string): CircuitInfo {
    return { ...this.getOrCreate(endpoint) };
  }

  /**
   * Forces a circuit to a specific state (for testing/manual override).
   */
  forceState(endpoint: string, state: CircuitState): void {
    const circuit = this.getOrCreate(endpoint);
    this.transition(endpoint, circuit, state);
  }

  /**
   * Registers a state change listener.
   */
  onStateChange(listener: (endpoint: string, state: CircuitState) => void): void {
    this.listeners.push(listener);
  }

  /**
   * Gets all circuit states.
   */
  getAllStates(): Map<string, CircuitState> {
    const states = new Map<string, CircuitState>();
    this.circuits.forEach((info, endpoint) => states.set(endpoint, info.state));
    return states;
  }

  private getOrCreate(endpoint: string): CircuitInfo {
    let circuit = this.circuits.get(endpoint);
    if (!circuit) {
      circuit = {
        state: CircuitState.Closed,
        failures: 0,
        successes: 0,
        lastFailure: null,
        lastStateChange: new Date(),
        totalTrips: 0,
      };
      this.circuits.set(endpoint, circuit);
    }
    return circuit;
  }

  private transition(endpoint: string, circuit: CircuitInfo, newState: CircuitState): void {
    const oldState = circuit.state;
    circuit.state = newState;
    circuit.lastStateChange = new Date();

    if (newState === CircuitState.Open) {
      circuit.totalTrips++;
      circuit.successes = 0;
    }
    if (newState === CircuitState.Closed) {
      circuit.failures = 0;
      circuit.successes = 0;
    }
    if (newState === CircuitState.HalfOpen) {
      circuit.successes = 0;
    }

    if (oldState !== newState) {
      for (const listener of this.listeners) {
        try { listener(endpoint, newState); } catch { /* ignore */ }
      }
    }
  }
}
