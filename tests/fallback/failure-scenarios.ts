/**
 * TECH-005: Failure scenario definitions for model fallback testing.
 * Defines the conditions that should trigger model fallback behavior.
 */

export interface FailureScenario {
	name: string;
	type: FailureType;
	httpStatus?: number;
	errorMessage: string;
	shouldTriggerFallback: boolean;
	retryable: boolean;
	maxRetries: number;
}

export enum FailureType {
	Timeout = "timeout",
	RateLimit = "rate_limit",
	ContextLength = "context_length",
	AuthFailure = "auth_failure",
	ServerError = "server_error",
	NetworkError = "network_error",
	ModelNotFound = "model_not_found",
	ContentFilter = "content_filter",
}

export const FAILURE_SCENARIOS: FailureScenario[] = [
	{
		name: "Request Timeout",
		type: FailureType.Timeout,
		errorMessage: "Request timed out after 30000ms",
		shouldTriggerFallback: true,
		retryable: true,
		maxRetries: 2,
	},
	{
		name: "Rate Limit Exceeded",
		type: FailureType.RateLimit,
		httpStatus: 429,
		errorMessage: "Rate limit exceeded. Please retry after 60 seconds.",
		shouldTriggerFallback: true,
		retryable: true,
		maxRetries: 3,
	},
	{
		name: "Context Length Exceeded",
		type: FailureType.ContextLength,
		httpStatus: 400,
		errorMessage: "This model's maximum context length is 200000 tokens.",
		shouldTriggerFallback: true,
		retryable: false,
		maxRetries: 0,
	},
	{
		name: "Authentication Failure",
		type: FailureType.AuthFailure,
		httpStatus: 401,
		errorMessage: "Invalid API key provided.",
		shouldTriggerFallback: true,
		retryable: false,
		maxRetries: 0,
	},
	{
		name: "Internal Server Error",
		type: FailureType.ServerError,
		httpStatus: 500,
		errorMessage: "Internal server error.",
		shouldTriggerFallback: true,
		retryable: true,
		maxRetries: 2,
	},
	{
		name: "Network Error",
		type: FailureType.NetworkError,
		errorMessage: "ECONNREFUSED: Connection refused",
		shouldTriggerFallback: true,
		retryable: true,
		maxRetries: 2,
	},
	{
		name: "Model Not Found",
		type: FailureType.ModelNotFound,
		httpStatus: 404,
		errorMessage: "The model 'claude-opus-4-20250514' does not exist.",
		shouldTriggerFallback: true,
		retryable: false,
		maxRetries: 0,
	},
	{
		name: "Content Filter Triggered",
		type: FailureType.ContentFilter,
		httpStatus: 400,
		errorMessage: "Content was flagged by the safety system.",
		shouldTriggerFallback: false,
		retryable: false,
		maxRetries: 0,
	},
];

export function getScenarioByType(type: FailureType): FailureScenario | undefined {
	return FAILURE_SCENARIOS.find((s) => s.type === type);
}

export function getRetryableScenarios(): FailureScenario[] {
	return FAILURE_SCENARIOS.filter((s) => s.retryable);
}

export function getFallbackTriggerScenarios(): FailureScenario[] {
	return FAILURE_SCENARIOS.filter((s) => s.shouldTriggerFallback);
}
