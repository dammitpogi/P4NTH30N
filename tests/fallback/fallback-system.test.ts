/**
 * TECH-005: Model Fallback System Unit Tests
 * Tests fallback triggers, chain traversal, state recovery, circuit breaker, and retry logic.
 */

import { describe, it, expect, beforeEach } from "vitest";
import { MockModelServer, ModelError } from "./mock-model-server";
import { FailureType, FAILURE_SCENARIOS, getFallbackTriggerScenarios, getRetryableScenarios } from "./failure-scenarios";

describe("Model Fallback System", () => {
	let server: MockModelServer;
	const MODEL_CHAIN = ["claude-opus-4-20250514", "claude-sonnet-4-20250514", "claude-haiku-3"];

	beforeEach(() => {
		server = new MockModelServer();
		server.resetCounts();
	});

	// ── Fallback Trigger Tests ─────────────────────────────────────

	describe("Fallback Triggers", () => {
		it("should succeed on healthy primary model", async () => {
			const response = await server.complete(MODEL_CHAIN[0], "test prompt");
			expect(response.model).toBe(MODEL_CHAIN[0]);
			expect(response.content).toContain("Response from");
		});

		it.each(getFallbackTriggerScenarios())("should trigger fallback on $name", async (scenario) => {
			server.setModelFailureMode(MODEL_CHAIN[0], scenario.type);

			await expect(server.complete(MODEL_CHAIN[0], "test")).rejects.toThrow(ModelError);

			// Fallback to next model should work
			const fallback = await server.complete(MODEL_CHAIN[1], "test");
			expect(fallback.model).toBe(MODEL_CHAIN[1]);
		});

		it("should NOT trigger fallback on content filter", async () => {
			const contentFilter = FAILURE_SCENARIOS.find((s) => s.type === FailureType.ContentFilter);
			expect(contentFilter?.shouldTriggerFallback).toBe(false);
		});
	});

	// ── Chain Traversal Tests ──────────────────────────────────────

	describe("Chain Traversal", () => {
		it("should traverse full fallback chain", async () => {
			// Make first two models fail
			server.setModelFailureMode(MODEL_CHAIN[0], FailureType.ServerError);
			server.setModelFailureMode(MODEL_CHAIN[1], FailureType.ServerError);

			// First two should fail
			await expect(server.complete(MODEL_CHAIN[0], "test")).rejects.toThrow();
			await expect(server.complete(MODEL_CHAIN[1], "test")).rejects.toThrow();

			// Third should succeed
			const response = await server.complete(MODEL_CHAIN[2], "test");
			expect(response.model).toBe(MODEL_CHAIN[2]);
		});

		it("should fail if all models in chain are unavailable", async () => {
			for (const model of MODEL_CHAIN) {
				server.setModelFailureMode(model, FailureType.ServerError);
			}

			for (const model of MODEL_CHAIN) {
				await expect(server.complete(model, "test")).rejects.toThrow(ModelError);
			}
		});

		it("should try models in order", async () => {
			server.setModelFailureMode(MODEL_CHAIN[0], FailureType.Timeout);

			await expect(server.complete(MODEL_CHAIN[0], "test")).rejects.toThrow();
			expect(server.getRequestCount(MODEL_CHAIN[0])).toBe(1);
			expect(server.getRequestCount(MODEL_CHAIN[1])).toBe(0);

			const response = await server.complete(MODEL_CHAIN[1], "test");
			expect(response.model).toBe(MODEL_CHAIN[1]);
			expect(server.getRequestCount(MODEL_CHAIN[1])).toBe(1);
		});
	});

	// ── State Recovery Tests ───────────────────────────────────────

	describe("State Recovery", () => {
		it("should return to primary model after recovery", async () => {
			// Primary fails
			server.setModelFailureMode(MODEL_CHAIN[0], FailureType.ServerError);
			await expect(server.complete(MODEL_CHAIN[0], "test")).rejects.toThrow();

			// Use fallback
			const fallback = await server.complete(MODEL_CHAIN[1], "test");
			expect(fallback.model).toBe(MODEL_CHAIN[1]);

			// Primary recovers
			server.setModelFailureMode(MODEL_CHAIN[0], undefined);
			const recovered = await server.complete(MODEL_CHAIN[0], "test");
			expect(recovered.model).toBe(MODEL_CHAIN[0]);
		});

		it("should handle intermittent failures", async () => {
			// Model fails after 3 requests
			server = new MockModelServer({
				models: [
					{ id: MODEL_CHAIN[0], available: true, failAfterN: 3, failureMode: FailureType.ServerError },
					{ id: MODEL_CHAIN[1], available: true },
					{ id: MODEL_CHAIN[2], available: true },
				],
			});

			// First 3 requests succeed
			for (let i = 0; i < 3; i++) {
				const r = await server.complete(MODEL_CHAIN[0], "test");
				expect(r.model).toBe(MODEL_CHAIN[0]);
			}

			// 4th request fails
			await expect(server.complete(MODEL_CHAIN[0], "test")).rejects.toThrow();
		});
	});

	// ── Circuit Breaker Tests ──────────────────────────────────────

	describe("Circuit Breaker", () => {
		it("should open circuit after repeated failures", async () => {
			server.setModelFailureMode(MODEL_CHAIN[0], FailureType.ServerError);

			// Generate 5 failures to trip circuit breaker
			for (let i = 0; i < 5; i++) {
				await expect(server.complete(MODEL_CHAIN[0], "test")).rejects.toThrow();
			}

			// Circuit should now be open - 6th request gets circuit breaker error
			await expect(server.complete(MODEL_CHAIN[0], "test")).rejects.toThrow(/Circuit breaker open/);
		});

		it("should not affect other models when one circuit opens", async () => {
			server.setModelFailureMode(MODEL_CHAIN[0], FailureType.ServerError);

			for (let i = 0; i < 5; i++) {
				await expect(server.complete(MODEL_CHAIN[0], "test")).rejects.toThrow();
			}

			// Other models should still work
			const response = await server.complete(MODEL_CHAIN[1], "test");
			expect(response.model).toBe(MODEL_CHAIN[1]);
		});
	});

	// ── Retry Logic Tests ──────────────────────────────────────────

	describe("Retry Logic", () => {
		it.each(getRetryableScenarios())("$name should be retryable (max $maxRetries retries)", (scenario) => {
			expect(scenario.retryable).toBe(true);
			expect(scenario.maxRetries).toBeGreaterThan(0);
		});

		it("non-retryable scenarios should have maxRetries = 0", () => {
			const nonRetryable = FAILURE_SCENARIOS.filter((s) => !s.retryable);
			for (const scenario of nonRetryable) {
				expect(scenario.maxRetries).toBe(0);
			}
		});

		it("should track request counts correctly", async () => {
			await server.complete(MODEL_CHAIN[0], "test1");
			await server.complete(MODEL_CHAIN[0], "test2");
			await server.complete(MODEL_CHAIN[1], "test3");

			expect(server.getRequestCount(MODEL_CHAIN[0])).toBe(2);
			expect(server.getRequestCount(MODEL_CHAIN[1])).toBe(1);
			expect(server.getRequestCount(MODEL_CHAIN[2])).toBe(0);
		});
	});

	// ── Model Availability Tests ───────────────────────────────────

	describe("Model Availability", () => {
		it("should handle model becoming unavailable", async () => {
			const r1 = await server.complete(MODEL_CHAIN[0], "test");
			expect(r1.model).toBe(MODEL_CHAIN[0]);

			server.setModelAvailability(MODEL_CHAIN[0], false);
			await expect(server.complete(MODEL_CHAIN[0], "test")).rejects.toThrow(/unavailable/);
		});

		it("should handle model not found", async () => {
			await expect(server.complete("nonexistent-model", "test")).rejects.toThrow(/not found/);
		});
	});
});
