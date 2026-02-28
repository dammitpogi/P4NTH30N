#!/usr/bin/env bun
/**
 * ARCH-081: Coordinate Relativity Live CDP Test
 * 
 * Tests that relative coordinates (rx/ry 0.0-1.0) map correctly to
 * absolute pixel positions across different viewport sizes.
 * 
 * Methodology:
 * 1. Create an HTML test page with the coordinate grid as background
 * 2. Overlay a "game canvas" div that acts as our reference element
 * 3. Inject click markers via CDP at known relative positions
 * 4. Resize viewport and verify the same relative coords hit the same visual targets
 * 5. Screenshot each viewport size for visual proof
 */
import { CdpClient, sleep } from './cdp-client';
import type { CanvasBounds, RelativeCoordinate } from './types';
import { mkdirSync, existsSync } from 'fs';

const RESULTS_DIR = 'C:\\P4NTHE0N\\H4ND\\tools\\recorder\\sessions\\relativity-test';
const GRID_IMAGE = 'file:///C:/P4NTHE0N/STR4TEG15T/screen_coords_grid.png';

// Test viewports
const VIEWPORTS = [
  { name: 'Design (930x865)',  width: 930,  height: 865 },
  { name: 'HD (1280x720)',     width: 1280, height: 720 },
  { name: 'FHD (1920x1080)',   width: 1920, height: 1080 },
  { name: 'Small (800x600)',   width: 800,  height: 600 },
];

// Known test points — relative positions within the canvas
// These correspond to specific visual landmarks on any viewport
const TEST_POINTS: { name: string; coord: RelativeCoordinate }[] = [
  { name: 'Center',       coord: { rx: 0.5000, ry: 0.5000, x: 465, y: 432 } },
  { name: 'Top-Left 25%', coord: { rx: 0.2500, ry: 0.2500, x: 232, y: 216 } },
  { name: 'Top-Right',    coord: { rx: 0.7500, ry: 0.2500, x: 697, y: 216 } },
  { name: 'Bot-Left',     coord: { rx: 0.2500, ry: 0.7500, x: 232, y: 648 } },
  { name: 'Bot-Right',    coord: { rx: 0.7500, ry: 0.7500, x: 697, y: 648 } },
  { name: 'FK Account',   coord: { rx: 0.4946, ry: 0.4243, x: 460, y: 367 } },
  { name: 'FK Login Btn',  coord: { rx: 0.5946, ry: 0.6555, x: 553, y: 567 } },
  { name: 'FK Spin',      coord: { rx: 0.9247, ry: 0.7572, x: 860, y: 655 } },
];

// The HTML test page — grid background with a canvas-sized overlay
function buildTestPage(vpWidth: number, vpHeight: number): string {
  return `<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>ARCH-081 Coordinate Relativity Test</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { 
      background: #1a1a2e; color: #eee; font-family: monospace; 
      overflow: hidden; width: ${vpWidth}px; height: ${vpHeight}px;
    }
    #game-canvas {
      position: absolute; top: 0; left: 0;
      width: ${vpWidth}px; height: ${vpHeight}px;
      background: url('${GRID_IMAGE}') center/cover no-repeat;
      border: 2px solid #0ff;
    }
    #info-panel {
      position: fixed; top: 4px; left: 4px; z-index: 1000;
      background: rgba(0,0,0,0.85); color: #0ff; padding: 6px 10px;
      font-size: 11px; border-radius: 4px; line-height: 1.4;
      border: 1px solid #0ff;
    }
    .click-marker {
      position: absolute; z-index: 500;
      width: 12px; height: 12px;
      border-radius: 50%; border: 2px solid #f00;
      background: rgba(255,0,0,0.3);
      transform: translate(-50%, -50%);
      pointer-events: none;
    }
    .click-marker::after {
      content: attr(data-label);
      position: absolute; left: 14px; top: -2px;
      font-size: 9px; color: #ff0; white-space: nowrap;
      background: rgba(0,0,0,0.7); padding: 1px 3px; border-radius: 2px;
    }
    .crosshair {
      position: absolute; z-index: 400; pointer-events: none;
    }
    .crosshair-h {
      width: 100%; height: 1px; background: rgba(255,255,0,0.3); top: 50%; left: 0;
    }
    .crosshair-v {
      width: 1px; height: 100%; background: rgba(255,255,0,0.3); top: 0; left: 50%;
    }
  </style>
</head>
<body>
  <div id="game-canvas">
    <div class="crosshair crosshair-h" style="position:absolute;"></div>
    <div class="crosshair crosshair-v" style="position:absolute;"></div>
  </div>
  <div id="info-panel">
    ARCH-081 Relativity Test<br>
    Viewport: ${vpWidth}x${vpHeight}<br>
    Canvas: <span id="canvas-info">measuring...</span><br>
    Points: <span id="points-count">0</span> placed
  </div>
  <script>
    // Report canvas bounds
    const canvas = document.getElementById('game-canvas');
    const rect = canvas.getBoundingClientRect();
    document.getElementById('canvas-info').textContent = 
      rect.width + 'x' + rect.height + ' @ (' + rect.x + ',' + rect.y + ')';
    
    // Function to place a marker at absolute coords
    window.__placeMarker = function(x, y, label) {
      const marker = document.createElement('div');
      marker.className = 'click-marker';
      marker.style.left = x + 'px';
      marker.style.top = y + 'px';
      marker.setAttribute('data-label', label);
      document.body.appendChild(marker);
      const count = document.querySelectorAll('.click-marker').length;
      document.getElementById('points-count').textContent = count;
      return { placed: true, x, y, label };
    };
    
    // Function to get canvas bounds
    window.__getCanvasBounds = function() {
      const el = document.getElementById('game-canvas');
      const r = el.getBoundingClientRect();
      return { x: r.x, y: r.y, width: r.width, height: r.height };
    };
  </script>
</body>
</html>`;
}

interface TestResult {
  viewport: string;
  vpWidth: number;
  vpHeight: number;
  canvasBounds: CanvasBounds;
  points: {
    name: string;
    rx: number;
    ry: number;
    expectedDesignX: number;
    expectedDesignY: number;
    actualX: number;
    actualY: number;
    withinCanvas: boolean;
  }[];
  screenshotPath: string;
}

async function main() {
  console.log('═══════════════════════════════════════════════════════════');
  console.log('  ARCH-081: Coordinate Relativity — Live CDP Test');
  console.log('═══════════════════════════════════════════════════════════\n');

  // Ensure results dir
  if (!existsSync(RESULTS_DIR)) mkdirSync(RESULTS_DIR, { recursive: true });

  // Connect to Chrome
  console.log('[CDP] Connecting to Chrome on port 9222...');
  const cdp = new CdpClient('127.0.0.1', 9222, RESULTS_DIR);
  await cdp.connect();
  console.log('[CDP] Connected.\n');

  const allResults: TestResult[] = [];

  for (const vp of VIEWPORTS) {
    console.log(`\n${'─'.repeat(60)}`);
    console.log(`  Testing viewport: ${vp.name} (${vp.width}x${vp.height})`);
    console.log(`${'─'.repeat(60)}`);

    // 1. Resize the browser viewport via CDP Emulation
    console.log(`[RESIZE] Setting viewport to ${vp.width}x${vp.height}...`);
    await cdp.send('Emulation.setDeviceMetricsOverride', {
      width: vp.width,
      height: vp.height,
      deviceScaleFactor: 1,
      mobile: false,
    });
    await sleep(300);

    // 2. Navigate to the test page (data URL with the HTML)
    const html = buildTestPage(vp.width, vp.height);
    const dataUrl = `data:text/html;charset=utf-8,${encodeURIComponent(html)}`;
    await cdp.navigate(dataUrl);
    await sleep(1000);

    // 3. Get canvas bounds from the page
    const canvasBounds = await cdp.evaluate<CanvasBounds>('window.__getCanvasBounds()');
    console.log(`[BOUNDS] Canvas: ${canvasBounds.width}x${canvasBounds.height} @ (${canvasBounds.x}, ${canvasBounds.y})`);

    // 4. Transform each test point and place markers
    const pointResults: TestResult['points'] = [];
    
    for (const tp of TEST_POINTS) {
      // Use our production transform function
      const abs = CdpClient.transformRelativeCoords(tp.coord, canvasBounds);
      
      // Place visual marker on the page
      await cdp.evaluate(`window.__placeMarker(${abs.x}, ${abs.y}, '${tp.name} (${tp.coord.rx},${tp.coord.ry})')`);
      
      const withinCanvas = (
        abs.x >= canvasBounds.x && abs.x <= canvasBounds.x + canvasBounds.width &&
        abs.y >= canvasBounds.y && abs.y <= canvasBounds.y + canvasBounds.height
      );

      console.log(
        `  ${withinCanvas ? '✅' : '❌'} ${tp.name.padEnd(16)} ` +
        `rx=${tp.coord.rx.toFixed(4)} ry=${tp.coord.ry.toFixed(4)} → ` +
        `(${abs.x}, ${abs.y})` +
        `${!withinCanvas ? ' ⚠ OUT OF BOUNDS' : ''}`
      );

      pointResults.push({
        name: tp.name,
        rx: tp.coord.rx,
        ry: tp.coord.ry,
        expectedDesignX: tp.coord.x,
        expectedDesignY: tp.coord.y,
        actualX: abs.x,
        actualY: abs.y,
        withinCanvas,
      });
    }

    // 5. Screenshot for visual proof
    await sleep(300);
    const ssLabel = `relativity-${vp.width}x${vp.height}`;
    const ssPath = await cdp.screenshot(ssLabel);
    console.log(`[SCREENSHOT] ${ssPath}`);

    allResults.push({
      viewport: vp.name,
      vpWidth: vp.width,
      vpHeight: vp.height,
      canvasBounds,
      points: pointResults,
      screenshotPath: ssPath,
    });
  }

  // Reset emulation
  await cdp.send('Emulation.clearDeviceMetricsOverride', {});

  // ─── Summary Report ─────────────────────────────────────────────
  console.log('\n\n' + '═'.repeat(60));
  console.log('  ARCH-081: Coordinate Relativity Test — Summary');
  console.log('═'.repeat(60));

  let totalPoints = 0;
  let totalInBounds = 0;

  for (const r of allResults) {
    const inBounds = r.points.filter(p => p.withinCanvas).length;
    totalPoints += r.points.length;
    totalInBounds += inBounds;
    
    console.log(`\n  ${r.viewport}:`);
    console.log(`    Canvas: ${r.canvasBounds.width}x${r.canvasBounds.height}`);
    console.log(`    Points in bounds: ${inBounds}/${r.points.length}`);
    console.log(`    Screenshot: ${r.screenshotPath}`);
    
    // Show relative position consistency check
    if (r.vpWidth !== 930 || r.vpHeight !== 865) {
      console.log(`    Scale factors: x=${(r.canvasBounds.width / 930).toFixed(3)} y=${(r.canvasBounds.height / 865).toFixed(3)}`);
    }
  }

  const passRate = ((totalInBounds / totalPoints) * 100).toFixed(1);
  console.log(`\n  Overall: ${totalInBounds}/${totalPoints} points in bounds (${passRate}%)`);
  console.log(`  Result: ${totalInBounds === totalPoints ? '✅ ALL PASS' : '⚠ SOME OUT OF BOUNDS'}`);

  // Write JSON report
  const reportPath = `${RESULTS_DIR}/relativity-report.json`;
  const report = {
    timestamp: new Date().toISOString(),
    testDescription: 'ARCH-081 Coordinate Relativity Live CDP Test',
    designViewport: { width: 930, height: 865 },
    testPoints: TEST_POINTS.map(t => ({ name: t.name, rx: t.coord.rx, ry: t.coord.ry })),
    results: allResults.map(r => ({
      viewport: r.viewport,
      dimensions: `${r.vpWidth}x${r.vpHeight}`,
      canvasBounds: r.canvasBounds,
      pointsInBounds: r.points.filter(p => p.withinCanvas).length,
      totalPoints: r.points.length,
      screenshot: r.screenshotPath,
      points: r.points,
    })),
    summary: {
      totalPoints,
      totalInBounds,
      passRate: `${passRate}%`,
      allPass: totalInBounds === totalPoints,
    },
  };

  const { writeFileSync } = await import('fs');
  writeFileSync(reportPath, JSON.stringify(report, null, 2));
  console.log(`\n  Report: ${reportPath}`);

  cdp.close();
  console.log('\n[CDP] Disconnected. Test complete.');
}

main().catch(err => {
  console.error('Test failed:', err);
  process.exit(1);
});
