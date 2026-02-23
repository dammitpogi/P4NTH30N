# Changelog

## [0.7.1] - 2026-02-15

### Fixed
- **400 Invalid Argument Error**: Shortened core tool descriptions (`bash`, `todowrite`, `task`, `skill`) to stay within Gemini API payload limits.
- **Connectivity Error Detection**: Updated `background-manager.ts` to recognize "typo in the url or port" and "unable to connect" as retryable provider errors.
- **Model Fallback**: Corrected hardcoded default model IDs and cleared stale triage state to ensure reliable agent communication.
- **Config Integrity**: Fixed syntax errors in `oh-my-opencode-theseus.json` caused by concurrent writes.
