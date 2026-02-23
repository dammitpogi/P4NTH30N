import { describe, expect, test } from 'vitest';
import {
  assertSecureBindAddress,
  validateBindAddress,
} from '../../src/security/bind-validation.js';

describe('REQ-096-026-A bind validation', () => {
  test('ACT-096-017-005: Binds to 127.0.0.1 only', () => {
    expect(validateBindAddress('127.0.0.1')).toBe(true);
    expect(validateBindAddress('localhost')).toBe(true);
    expect(validateBindAddress('0.0.0.0')).toBe(false);
    expect(validateBindAddress('::')).toBe(false);
  });

  test('throws for insecure bind addresses', () => {
    expect(() => assertSecureBindAddress('0.0.0.0')).toThrow();
  });
});
