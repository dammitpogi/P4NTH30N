/**
 * INFRA-037: Connection health monitor with pre-flight checks and keepalive pings.
 * Monitors endpoint health before task dispatch and during execution.
 */

export interface EndpointHealth {
  endpoint: string;
  isHealthy: boolean;
  lastChecked: Date;
  lastSuccessful: Date | null;
  consecutiveFailures: number;
  averageLatencyMs: number;
  latencySamples: number[];
}

export interface HealthMonitorConfig {
  /** Interval between health checks in ms (default: 30000) */
  checkIntervalMs: number;
  /** Timeout for health check requests in ms (default: 5000) */
  checkTimeoutMs: number;
  /** Number of consecutive failures before marking unhealthy (default: 3) */
  failureThreshold: number;
  /** Maximum latency samples to keep for averaging (default: 10) */
  maxLatencySamples: number;
  /** Custom health check function */
  healthCheckFn?: (endpoint: string) => Promise<boolean>;
}

const DEFAULT_CONFIG: HealthMonitorConfig = {
  checkIntervalMs: 30000,
  checkTimeoutMs: 5000,
  failureThreshold: 3,
  maxLatencySamples: 10,
};

export class ConnectionHealthMonitor {
  private config: HealthMonitorConfig;
  private endpoints: Map<string, EndpointHealth> = new Map();
  private intervals: Map<string, ReturnType<typeof setInterval>> = new Map();
  private listeners: Array<(endpoint: string, healthy: boolean) => void> = [];

  constructor(config?: Partial<HealthMonitorConfig>) {
    this.config = { ...DEFAULT_CONFIG, ...config };
  }

  /**
   * Registers an endpoint for health monitoring.
   */
  register(endpoint: string): void {
    if (this.endpoints.has(endpoint)) return;

    this.endpoints.set(endpoint, {
      endpoint,
      isHealthy: true, // Assume healthy until proven otherwise
      lastChecked: new Date(),
      lastSuccessful: null,
      consecutiveFailures: 0,
      averageLatencyMs: 0,
      latencySamples: [],
    });
  }

  /**
   * Starts periodic health checks for a registered endpoint.
   */
  startMonitoring(endpoint: string): void {
    this.register(endpoint);

    // Clear existing interval if any
    const existing = this.intervals.get(endpoint);
    if (existing) clearInterval(existing);

    // Perform initial check
    this.checkHealth(endpoint);

    // Set up periodic checks
    const interval = setInterval(() => {
      this.checkHealth(endpoint);
    }, this.config.checkIntervalMs);

    this.intervals.set(endpoint, interval);
  }

  /**
   * Stops monitoring an endpoint.
   */
  stopMonitoring(endpoint: string): void {
    const interval = this.intervals.get(endpoint);
    if (interval) {
      clearInterval(interval);
      this.intervals.delete(endpoint);
    }
  }

  /**
   * Stops all monitoring.
   */
  stopAll(): void {
    this.intervals.forEach((interval) => clearInterval(interval));
    this.intervals.clear();
  }

  /**
   * Performs a pre-flight health check. Returns true if the endpoint is healthy.
   */
  async preFlightCheck(endpoint: string): Promise<boolean> {
    this.register(endpoint);
    await this.checkHealth(endpoint);
    return this.isHealthy(endpoint);
  }

  /**
   * Returns whether an endpoint is currently considered healthy.
   */
  isHealthy(endpoint: string): boolean {
    const health = this.endpoints.get(endpoint);
    return health?.isHealthy ?? false;
  }

  /**
   * Gets the health status for an endpoint.
   */
  getHealth(endpoint: string): EndpointHealth | undefined {
    return this.endpoints.get(endpoint);
  }

  /**
   * Gets health status for all registered endpoints.
   */
  getAllHealth(): EndpointHealth[] {
    return Array.from(this.endpoints.values());
  }

  /**
   * Registers a listener for health state changes.
   */
  onHealthChange(listener: (endpoint: string, healthy: boolean) => void): void {
    this.listeners.push(listener);
  }

  /**
   * Records a successful operation (resets failure count, updates latency).
   */
  recordSuccess(endpoint: string, latencyMs: number): void {
    const health = this.endpoints.get(endpoint);
    if (!health) return;

    const wasUnhealthy = !health.isHealthy;
    health.isHealthy = true;
    health.consecutiveFailures = 0;
    health.lastSuccessful = new Date();

    // Update latency tracking
    health.latencySamples.push(latencyMs);
    if (health.latencySamples.length > this.config.maxLatencySamples) {
      health.latencySamples.shift();
    }
    health.averageLatencyMs =
      health.latencySamples.reduce((a, b) => a + b, 0) / health.latencySamples.length;

    if (wasUnhealthy) {
      this.notifyListeners(endpoint, true);
    }
  }

  /**
   * Records a failed operation.
   */
  recordFailure(endpoint: string): void {
    const health = this.endpoints.get(endpoint);
    if (!health) return;

    health.consecutiveFailures++;

    if (health.consecutiveFailures >= this.config.failureThreshold && health.isHealthy) {
      health.isHealthy = false;
      this.notifyListeners(endpoint, false);
    }
  }

  private async checkHealth(endpoint: string): Promise<void> {
    const health = this.endpoints.get(endpoint);
    if (!health) return;

    health.lastChecked = new Date();

    if (this.config.healthCheckFn) {
      try {
        const start = Date.now();
        const healthy = await Promise.race([
          this.config.healthCheckFn(endpoint),
          new Promise<boolean>((_, reject) =>
            setTimeout(() => reject(new Error('Health check timeout')), this.config.checkTimeoutMs)
          ),
        ]);
        const latency = Date.now() - start;

        if (healthy) {
          this.recordSuccess(endpoint, latency);
        } else {
          this.recordFailure(endpoint);
        }
      } catch {
        this.recordFailure(endpoint);
      }
    }
  }

  private notifyListeners(endpoint: string, healthy: boolean): void {
    for (const listener of this.listeners) {
      try {
        listener(endpoint, healthy);
      } catch {
        // Don't let listener errors break the monitor
      }
    }
  }
}
