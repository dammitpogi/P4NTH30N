#!/usr/bin/env bun
/**
 * ARCH-081: Test coordinate relativity transformations
 */
import { CdpClient } from './cdp-client';
import type { CanvasBounds, RelativeCoordinate } from './types';

console.log('ARCH-081 Coordinate Relativity Test\n');

// Test data from FireKirin workflow
const DESIGN_VIEWPORT = { width: 930, height: 865 };
const FK_ACCOUNT: RelativeCoordinate = { rx: 0.4946, ry: 0.4243, x: 460, y: 367 };

// Test Case 1: Canvas matches design viewport exactly
console.log('Test 1: Canvas matches design viewport (930x865)');
const bounds1: CanvasBounds = { x: 0, y: 0, width: 930, height: 865 };
const result1 = CdpClient.transformRelativeCoords(FK_ACCOUNT, bounds1);
console.log(`  Input: rx=${FK_ACCOUNT.rx}, ry=${FK_ACCOUNT.ry}`);
console.log(`  Canvas: ${bounds1.width}x${bounds1.height} @ (${bounds1.x}, ${bounds1.y})`);
console.log(`  Output: (${result1.x}, ${result1.y})`);
console.log(`  Expected: (${FK_ACCOUNT.x}, ${FK_ACCOUNT.y})`);
console.log(`  Match: ${result1.x === FK_ACCOUNT.x && result1.y === FK_ACCOUNT.y ? '✅' : '❌'}\n`);

// Test Case 2: Canvas is larger (1920x1080)
console.log('Test 2: Canvas is larger (1920x1080)');
const bounds2: CanvasBounds = { x: 0, y: 0, width: 1920, height: 1080 };
const result2 = CdpClient.transformRelativeCoords(FK_ACCOUNT, bounds2);
console.log(`  Input: rx=${FK_ACCOUNT.rx}, ry=${FK_ACCOUNT.ry}`);
console.log(`  Canvas: ${bounds2.width}x${bounds2.height} @ (${bounds2.x}, ${bounds2.y})`);
console.log(`  Output: (${result2.x}, ${result2.y})`);
console.log(`  Expected: (${Math.round(0.4946 * 1920)}, ${Math.round(0.4243 * 1080)})`);
console.log(`  Scales correctly: ${result2.x === Math.round(0.4946 * 1920) && result2.y === Math.round(0.4243 * 1080) ? '✅' : '❌'}\n`);

// Test Case 3: Canvas is offset (100, 50)
console.log('Test 3: Canvas with offset (100, 50)');
const bounds3: CanvasBounds = { x: 100, y: 50, width: 930, height: 865 };
const result3 = CdpClient.transformRelativeCoords(FK_ACCOUNT, bounds3);
console.log(`  Input: rx=${FK_ACCOUNT.rx}, ry=${FK_ACCOUNT.ry}`);
console.log(`  Canvas: ${bounds3.width}x${bounds3.height} @ (${bounds3.x}, ${bounds3.y})`);
console.log(`  Output: (${result3.x}, ${result3.y})`);
console.log(`  Expected: (${100 + FK_ACCOUNT.x}, ${50 + FK_ACCOUNT.y})`);
console.log(`  Offset applied: ${result3.x === (100 + FK_ACCOUNT.x) && result3.y === (50 + FK_ACCOUNT.y) ? '✅' : '❌'}\n`);

// Test Case 4: Canvas not found (fallback to absolute)
console.log('Test 4: Canvas not found (fallback to absolute)');
const bounds4: CanvasBounds = { x: 0, y: 0, width: 0, height: 0 };
const result4 = CdpClient.transformRelativeCoords(FK_ACCOUNT, bounds4);
console.log(`  Input: rx=${FK_ACCOUNT.rx}, ry=${FK_ACCOUNT.ry}, x=${FK_ACCOUNT.x}, y=${FK_ACCOUNT.y}`);
console.log(`  Canvas: NOT FOUND (0x0)`);
console.log(`  Output: (${result4.x}, ${result4.y})`);
console.log(`  Expected: (${FK_ACCOUNT.x}, ${FK_ACCOUNT.y}) [fallback to absolute]`);
console.log(`  Fallback works: ${result4.x === FK_ACCOUNT.x && result4.y === FK_ACCOUNT.y ? '✅' : '❌'}\n`);

console.log('All tests completed.');
