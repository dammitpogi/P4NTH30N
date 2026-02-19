/**
 * TECH-005: Mock model server for fallback system testing.
 * Simulates model provider responses including failures for testing.
 */

import { FailureType } from "./failure-scenarios";

export interface ModelResponse {
	id: string;
	model: string;
	content: string;
	usage: { prompt_tokens: number; completion_tokens: number; total_tokens: number };
}

export interface MockServerConfig {
	models: MockModel[];
	defaultLatencyMs: number;
}

export interface MockModel {
	id: string;
	available: boolean;
	failureMode?: FailureType;
	failAfterN?: number;
	latencyMs?: number;
}

export class MockModelServer {
	private _config: MockServerConfig;
	private _requestCounts: Map<string, number> = new Map();
	private _circuitBreakerState: Map<string, { failures: number; openUntil: number }> = new Map();

	constructor(config?: Partial<MockServerConfig>) {
		this._config = {
			models: config?.models ?? [
				{ id: "claude-opus-4-20250514", available: true },
				{ id: "claude-sonnet-4-20250514", available: true },
				{ id: "claude-haiku-3", available: true },
			],
			defaultLatencyMs: config?.defaultLatencyMs ?? 50,
		};
	}

	async complete(modelId: string, prompt: string): Promise<ModelResponse> {
		const model = this._config.models.find((m) => m.id === modelId);
		const count = (this._requestCounts.get(modelId) ?? 0) + 1;
		this._requestCounts.set(modelId, count);

		// Check circuit breaker
		const circuit = this._circuitBreakerState.get(modelId);
		if (circuit && Date.now() < circuit.openUntil) {
			throw new ModelError("Circuit breaker open", FailureType.ServerError, 503);
		}

		if (!model) {
			throw new ModelError(`Model '${modelId}' not found`, FailureType.ModelNotFound, 404);
		}

		if (!model.available) {
			throw new ModelError(`Model '${modelId}' is unavailable`, FailureType.ServerError, 503);
		}

		// Simulate failure after N requests
		if (model.failAfterN && count > model.failAfterN) {
			this.recordFailure(modelId);
			throw this.createFailure(model.failureMode ?? FailureType.ServerError);
		}

		// Simulate failure mode
		if (model.failureMode && !model.failAfterN) {
			this.recordFailure(modelId);
			throw this.createFailure(model.failureMode);
		}

		// Simulate latency
		const latency = model.latencyMs ?? this._config.defaultLatencyMs;
		await new Promise((resolve) => setTimeout(resolve, latency));

		return {
			id: `msg_${Date.now()}`,
			model: modelId,
			content: `Response from ${modelId}: ${prompt.substring(0, 50)}`,
			usage: { prompt_tokens: 100, completion_tokens: 50, total_tokens: 150 },
		};
	}

	getRequestCount(modelId: string): number {
		return this._requestCounts.get(modelId) ?? 0;
	}

	resetCounts(): void {
		this._requestCounts.clear();
		this._circuitBreakerState.clear();
	}

	setModelAvailability(modelId: string, available: boolean): void {
		const model = this._config.models.find((m) => m.id === modelId);
		if (model) model.available = available;
	}

	setModelFailureMode(modelId: string, mode: FailureType | undefined): void {
		const model = this._config.models.find((m) => m.id === modelId);
		if (model) model.failureMode = mode;
	}

	private recordFailure(modelId: string): void {
		const circuit = this._circuitBreakerState.get(modelId) ?? { failures: 0, openUntil: 0 };
		circuit.failures++;
		if (circuit.failures >= 5) {
			circuit.openUntil = Date.now() + 30_000; // 30s circuit open
		}
		this._circuitBreakerState.set(modelId, circuit);
	}

	private createFailure(type: FailureType): ModelError {
		switch (type) {
			case FailureType.Timeout:
				return new ModelError("Request timed out", type);
			case FailureType.RateLimit:
				return new ModelError("Rate limit exceeded", type, 429);
			case FailureType.ContextLength:
				return new ModelError("Context length exceeded", type, 400);
			case FailureType.AuthFailure:
				return new ModelError("Invalid API key", type, 401);
			case FailureType.ServerError:
				return new ModelError("Internal server error", type, 500);
			case FailureType.NetworkError:
				return new ModelError("ECONNREFUSED", type);
			default:
				return new ModelError("Unknown error", type, 500);
		}
	}
}

export class ModelError extends Error {
	type: FailureType;
	httpStatus?: number;

	constructor(message: string, type: FailureType, httpStatus?: number) {
		super(message);
		this.name = "ModelError";
		this.type = type;
		this.httpStatus = httpStatus;
	}
}
