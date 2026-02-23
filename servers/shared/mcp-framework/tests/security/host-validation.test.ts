import { describe, expect, test } from 'vitest';
import {
  validateHost,
  validateRequiredHostHeader,
} from '../../src/security/host-validation.js';

describe('REQ-096-026-C host validation', () => {
  test('accepts localhost host values', () => {
    expect(validateHost('localhost:3000')).toBe(true);
    expect(validateHost('127.0.0.1:3000')).toBe(true);
  });

  test('rejects external host values', () => {
    expect(validateHost('evil.com')).toBe(false);
    expect(validateHost('10.0.0.5:3000')).toBe(false);
  });

  test('provides failure reason for missing host', () => {
    expect(validateRequiredHostHeader(undefined)).toEqual({
      valid: false,
      reason: 'Missing Host header',
    });
  });
});
