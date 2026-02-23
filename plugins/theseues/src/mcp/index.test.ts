import { describe, expect, test } from 'bun:test';
import { createBuiltinMcps } from './index';

describe('createBuiltinMcps', () => {
  test('returns empty MCPs when no disabled list provided', () => {
    const mcps = createBuiltinMcps();
    const names = Object.keys(mcps);

    expect(names.length).toBe(0);
  });

  test('returns empty MCPs with empty disabled list', () => {
    const mcps = createBuiltinMcps([]);
    const names = Object.keys(mcps);

    expect(names.length).toBe(0);
  });

  test('returns empty MCPs when all disabled', () => {
    const mcps = createBuiltinMcps(['websearch', 'context7', 'grep_app']);
    const names = Object.keys(mcps);

    expect(names.length).toBe(0);
  });

  test('ignores unknown MCP names in disabled list', () => {
    const mcps = createBuiltinMcps(['unknown_mcp', 'nonexistent']);
    const names = Object.keys(mcps);

    // Should still be empty since no MCPs are defined
    expect(names.length).toBe(0);
  });
});