import { describe, expect, test } from 'vitest';
import {
  validateOrigin,
  validateRequiredOriginHeader,
} from '../../src/security/origin-validation.js';

describe('REQ-096-026-B origin validation', () => {
  test('accepts localhost origin', () => {
    expect(validateOrigin('http://localhost:3000')).toBe(true);
    expect(validateOrigin('http://127.0.0.1:5173')).toBe(true);
  });

  test('rejects wildcard and external origins', () => {
    expect(validateOrigin('*')).toBe(false);
    expect(validateOrigin('http://evil.com')).toBe(false);
    expect(validateOrigin('https://localhost:3000')).toBe(false);
  });

  test('rejects missing and null origin header', () => {
    expect(validateRequiredOriginHeader(undefined)).toEqual({
      valid: false,
      reason: 'Missing Origin header',
    });

    expect(validateRequiredOriginHeader('null')).toEqual({
      valid: false,
      reason: 'Null Origin header is not allowed',
    });
  });
});
