import { log } from '../../utils/logger';

const TOKEN_THRESHOLD = 150000; // Conservative threshold before 204800 limit
const MESSAGES_TO_KEEP_HEAD = 2; // Keep first 2 messages (system + initial context)
const MESSAGES_TO_KEEP_TAIL = 10; // Keep last 10 messages (recent context)

interface MessagePart {
  type: string;
  text?: string;
  [key: string]: unknown;
}

interface MessageInfo {
  role: string;
  agent?: string;
}

interface MessageWithParts {
  info: MessageInfo;
  parts: MessagePart[];
}

function estimateTokenCount(messages: MessageWithParts[]): number {
  // Rough estimation: sum of text parts / 4
  let totalChars = 0;
  for (const msg of messages) {
    for (const part of msg.parts) {
      if (part.text) {
        totalChars += part.text.length;
      }
    }
  }
  return Math.floor(totalChars / 4);
}

function detectProviderError(errorMessage: string): boolean {
  const providerErrorPatterns = [
    /rate.limit/i,
    /context.length/i,
    /token.limit/i,
    /max.token/i,
    /more.credit/i,
    /fewer.max_token/i,
    /model.unavailable/i,
    /credit.exceeded/i,
    /insufficient.quota/i,
    /quota.exceeded/i,
    /exceeded.your.current.quota/i,
    /RESOURCE_EXHAUSTED/,
    /generativelanguage\.googleapis\.com/,
    /api.usage/i,
    /429/, // HTTP status code for rate limit
    /503/, // HTTP status code for service unavailable
    /504/, // HTTP status code for gateway timeout
    // Invalid model errors should trigger fallback
    /invalid.*model/i,
    /model.*not.*found/i,
    /unknown.*model/i,
    /model.*not.*available/i,
    // Generic unknown errors should trigger fallback
    /unknown.*error/i,
    /unknown.*failure/i,
    // Auth and key errors should trigger fallback
    /api.*key/i,
    /authentication/i,
    /unauthorized/i,
    /invalid.*api/i,
    // Network and connection errors
    /network.*error/i,
    /connection.*error/i,
    /timeout/i,
    /econnrefused/i,
    /econnreset/i,
    /enotfound/i,
    /000/i, // Connection failure (curl timeout/empty response)
    // Agent-specific errors that should trigger fallback
    /agent.*not.*found/i,
    /agent.*not.*available/i,
    /subagent.*error/i,
    // General provider failures
    /provider.*error/i,
    /upstream.*error/i,
    /server.*error/i,
    /internal.*error/i,
  ];

  return providerErrorPatterns.some((pattern) => pattern.test(errorMessage));
}

export function createContextCompressorHook() {
  return {
    'experimental.chat.messages.transform': async (
      _input: Record<string, never>,
      output: { messages: MessageWithParts[] },
    ): Promise<void> => {
      const messages = output.messages;
      
      try {
        const tokenCount = estimateTokenCount(messages);
        
        log('[context-compressor] Checking message token count:', {
          estimatedTokens: tokenCount,
          threshold: TOKEN_THRESHOLD,
          totalMessages: messages.length,
        });

        // If under threshold, return as-is
        if (tokenCount <= TOKEN_THRESHOLD) {
          return;
        }

        log('[context-compressor] Threshold exceeded, compressing messages:', {
          estimatedTokens: tokenCount,
          originalMessageCount: messages.length,
        });

        // Keep first 2 messages (system + initial context)
        const headMessages = messages.slice(0, MESSAGES_TO_KEEP_HEAD);
        
        // Keep last 10 messages (recent context)
        const tailMessages = messages.slice(-MESSAGES_TO_KEEP_TAIL);
        
        // Calculate middle messages that will be truncated
        const middleStart = MESSAGES_TO_KEEP_HEAD;
        const middleEnd = messages.length - MESSAGES_TO_KEEP_TAIL;
        const middleMessageCount = Math.max(0, middleEnd - middleStart);

        // Create summary message for truncated middle section
        if (middleMessageCount > 0) {
          const summaryMessage: MessageWithParts = {
            info: { role: 'system' },
            parts: [
              {
                type: 'text',
                text: `[Context compressed: ${middleMessageCount} messages truncated to save tokens. Keeping recent context below.]`,
              },
            ],
          };
          
          output.messages = [
            ...headMessages,
            summaryMessage,
            ...tailMessages,
          ];
        } else {
          // If there are no middle messages to truncate, just combine head and tail
          output.messages = [...headMessages, ...tailMessages];
        }

        const newTokenCount = estimateTokenCount(output.messages);
        
        log('[context-compressor] Compression complete:', {
          originalMessages: messages.length,
          compressedMessages: output.messages.length,
          originalTokens: tokenCount,
          compressedTokens: newTokenCount,
          tokensSaved: tokenCount - newTokenCount,
        });
      } catch (error) {
        const errorMsg = error instanceof Error ? error.message : String(error);
        log('[context-compressor] Error during compression:', {
          error: errorMsg,
        });
        // If compression fails, keep original messages to avoid breaking the chat
      }
    },
  };
}

export { detectProviderError };
