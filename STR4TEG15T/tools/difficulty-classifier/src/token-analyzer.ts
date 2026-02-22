/**
 * Token Analysis Module
 * Analyzes query complexity based on token/word count
 *
 * Thresholds per DECISION_087:
 * - Simple: <500 tokens
 * - Moderate: 500-2000 tokens
 * - Complex: 2000+ tokens
 */

import type { DifficultyLevel, TokenAnalysis } from './types.js';

/** Approximate tokens per word ratio (GPT-family average) */
const TOKENS_PER_WORD = 1.3;

/** Token thresholds for difficulty levels */
const TOKEN_THRESHOLDS = {
  simple: 500,
  moderate: 2000,
} as const;

/**
 * Estimate token count from text
 * Uses word-based estimation (1.3 tokens per word average)
 */
export function estimateTokenCount(text: string): number {
  if (!text || text.trim().length === 0) return 0;

  // Count words (split on whitespace, filter empties)
  const words = text.split(/\s+/).filter((w) => w.length > 0);
  const wordCount = words.length;

  // Add tokens for special characters, code blocks, etc.
  const codeBlockCount = (text.match(/```/g) || []).length / 2;
  const jsonBrackets = (text.match(/[{}\[\]]/g) || []).length;
  const specialChars = (text.match(/[<>|=!@#$%^&*()]/g) || []).length;

  const baseTokens = Math.ceil(wordCount * TOKENS_PER_WORD);
  const extraTokens = Math.ceil(
    codeBlockCount * 4 + jsonBrackets * 0.5 + specialChars * 0.3
  );

  return baseTokens + extraTokens;
}

/**
 * Count sentences in text
 */
export function countSentences(text: string): number {
  if (!text || text.trim().length === 0) return 0;

  // Match sentence-ending punctuation
  const sentences = text.split(/[.!?]+/).filter((s) => s.trim().length > 0);
  return Math.max(1, sentences.length);
}

/**
 * Count words in text
 */
export function countWords(text: string): number {
  if (!text || text.trim().length === 0) return 0;
  return text.split(/\s+/).filter((w) => w.length > 0).length;
}

/**
 * Classify difficulty based on token count
 */
export function classifyByTokens(tokenCount: number): DifficultyLevel {
  if (tokenCount < TOKEN_THRESHOLDS.simple) return 'simple';
  if (tokenCount < TOKEN_THRESHOLDS.moderate) return 'moderate';
  return 'complex';
}

/**
 * Calculate token score (0-10)
 * Higher score = more complex
 */
export function calculateTokenScore(tokenCount: number): number {
  if (tokenCount === 0) return 0;
  if (tokenCount < 100) return 1;
  if (tokenCount < TOKEN_THRESHOLDS.simple) return 3;
  if (tokenCount < 1000) return 5;
  if (tokenCount < TOKEN_THRESHOLDS.moderate) return 7;
  if (tokenCount < 3000) return 8;
  return 10;
}

/**
 * Perform complete token analysis
 */
export function analyzeTokens(text: string): TokenAnalysis {
  const tokenCount = estimateTokenCount(text);
  const wordCount = countWords(text);
  const sentenceCount = countSentences(text);
  const level = classifyByTokens(tokenCount);

  return {
    tokenCount,
    wordCount,
    sentenceCount,
    level,
  };
}
