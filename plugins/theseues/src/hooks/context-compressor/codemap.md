# src/hooks/context-compressor/

## Responsibility

Reduces prompt size before model invocation by truncating the middle of long message histories. This helps avoid context-length failures while preserving the initial system context and the most recent conversation.

## Design

- Implements an `experimental.chat.messages.transform` hook via `createContextCompressorHook()`.
- Uses a rough token estimator (sum of text chars / 4).
- Compression strategy:
  - keep the first `MESSAGES_TO_KEEP_HEAD` messages (system + initial context),
  - keep the last `MESSAGES_TO_KEEP_TAIL` messages (recent turns),
  - replace the middle with a single system summary marker message.
- Exports `detectProviderError(errorMessage)` which classifies error strings that should trigger model fallback/retry logic.

## Flow

1. Hook runs immediately before model call with `output.messages`.
2. Estimate tokens; if under `TOKEN_THRESHOLD`, no-op.
3. If exceeded, splice messages into head + summary + tail and write back to `output.messages`.
4. Log compression stats; swallow errors to avoid breaking chat.

## Integration

- Registered through the hook system at `experimental.chat.messages.transform`.
- Uses `src/utils/logger` for best-effort logging.
