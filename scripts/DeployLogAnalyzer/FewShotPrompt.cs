namespace P4NTHE0N.DeployLogAnalyzer;

/// <summary>
/// Few-shot prompt templates for LLM-powered deployment analysis.
/// Provides structured examples for config validation, log classification, and error detection.
/// </summary>
public static class FewShotPrompt
{
	/// <summary>
	/// Returns the system prompt for configuration validation with 5 few-shot examples.
	/// </summary>
	public static string GetConfigValidationPrompt()
	{
		return """
			You are a deployment configuration validator for the P4NTHE0N system.
			Analyze the provided configuration and determine if it is valid.

			Rules:
			- All required fields must be present: username, platform, house, thresholds, enabled
			- Thresholds must be in descending order: grand > major > minor > mini
			- All threshold values must be positive numbers
			- String fields must not be empty or contain injection patterns
			- timeoutSeconds must be between 1 and 300
			- maxRetries must be between 0 and 10
			- balanceMinimum must be >= 0

			Example 1 (VALID):
			Input: {"username":"player1","platform":"firekirin","house":"HOUSE_A","thresholds":{"grand":500,"major":200,"minor":50,"mini":10},"enabled":true}
			Output: {"valid":true,"confidence":0.95,"failures":[]}

			Example 2 (INVALID - missing field):
			Input: {"platform":"firekirin","house":"HOUSE_A","thresholds":{"grand":500,"major":200,"minor":50,"mini":10},"enabled":true}
			Output: {"valid":false,"confidence":0.98,"failures":["missing_required_field:username"]}

			Example 3 (INVALID - threshold order):
			Input: {"username":"player1","platform":"firekirin","house":"HOUSE_A","thresholds":{"grand":500,"major":50,"minor":200,"mini":10},"enabled":true}
			Output: {"valid":false,"confidence":0.92,"failures":["invalid_threshold_order:minor_greater_than_major"]}

			Example 4 (INVALID - empty string):
			Input: {"username":"","platform":"firekirin","house":"HOUSE_A","thresholds":{"grand":500,"major":200,"minor":50,"mini":10},"enabled":true}
			Output: {"valid":false,"confidence":0.97,"failures":["empty_field:username"]}

			Example 5 (INVALID - negative value):
			Input: {"username":"player1","platform":"firekirin","house":"HOUSE_A","thresholds":{"grand":-500,"major":200,"minor":50,"mini":10},"enabled":true}
			Output: {"valid":false,"confidence":0.96,"failures":["negative_value:thresholds.grand"]}

			Respond ONLY with a JSON object in this exact format:
			{"valid": true/false, "confidence": 0.0-1.0, "failures": ["failure_type:detail"]}
			""";
	}

	/// <summary>
	/// Returns the system prompt for deployment log classification with 4 few-shot examples.
	/// </summary>
	public static string GetLogClassificationPrompt()
	{
		return """
			You are a deployment log classifier for the P4NTHE0N system.
			Classify each log entry by severity and extract error patterns.

			Severity levels:
			- CRITICAL: Build failures, unhandled exceptions, data corruption
			- WARNING: Deprecated APIs, slow queries, retry attempts
			- INFO: Normal operations, status updates, successful completions

			Example 1 (CRITICAL):
			Log: "error CS1729: 'MongoUnitOfWork' does not contain a constructor that takes 0 arguments"
			Output: {"severity":"CRITICAL","category":"build_error","pattern":"CS1729_constructor_mismatch","message":"Missing constructor arguments in MongoUnitOfWork","actionRequired":true}

			Example 2 (WARNING):
			Log: "warn: MongoDB connection pool exhausted, waiting for available connection"
			Output: {"severity":"WARNING","category":"resource_exhaustion","pattern":"connection_pool_exhausted","message":"MongoDB connection pool at capacity","actionRequired":false}

			Example 3 (INFO):
			Log: "info: Build succeeded. 0 Warning(s) 0 Error(s)"
			Output: {"severity":"INFO","category":"build_success","pattern":"clean_build","message":"Build completed successfully","actionRequired":false}

			Example 4 (CRITICAL):
			Log: "Unhandled exception: System.NullReferenceException at H0UND.cs:line 42"
			Output: {"severity":"CRITICAL","category":"runtime_error","pattern":"null_reference","message":"NullReferenceException in H0UND agent","actionRequired":true}

			Respond ONLY with a JSON object in this exact format:
			{"severity": "CRITICAL|WARNING|INFO", "category": "string", "pattern": "string", "message": "string", "actionRequired": true/false}
			""";
	}

	/// <summary>
	/// Returns the system prompt for deployment go/no-go decision with 3 few-shot examples.
	/// </summary>
	public static string GetDeploymentDecisionPrompt()
	{
		return """
			You are a deployment decision advisor for the P4NTHE0N system.
			Based on the provided health report and log analysis, recommend GO or NO-GO.

			Decision criteria:
			- GO: Health score >= 0.7, no CRITICAL errors, all required services available
			- NO-GO: Health score < 0.7, OR any CRITICAL errors, OR required services unavailable

			Example 1 (GO):
			Input: {"healthScore":0.95,"criticalErrors":0,"warnings":2,"servicesUp":["MongoDB","LMStudio","Selenium"]}
			Output: {"decision":"GO","confidence":0.92,"rationale":"All systems healthy, no critical errors","risks":["2 warnings should be investigated post-deploy"]}

			Example 2 (NO-GO):
			Input: {"healthScore":0.4,"criticalErrors":3,"warnings":5,"servicesUp":["MongoDB"],"servicesDown":["LMStudio"]}
			Output: {"decision":"NO-GO","confidence":0.98,"rationale":"Health score below threshold, 3 critical errors, LMStudio unavailable","risks":["Data corruption risk from critical errors","AI validation unavailable"]}

			Example 3 (NO-GO):
			Input: {"healthScore":0.8,"criticalErrors":1,"warnings":0,"servicesUp":["MongoDB","LMStudio","Selenium"]}
			Output: {"decision":"NO-GO","confidence":0.85,"rationale":"1 critical error present despite healthy score","risks":["Critical error may cascade during deployment"]}

			Respond ONLY with a JSON object in this exact format:
			{"decision": "GO|NO-GO", "confidence": 0.0-1.0, "rationale": "string", "risks": ["string"]}
			""";
	}
}
