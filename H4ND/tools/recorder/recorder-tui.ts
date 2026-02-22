#!/usr/bin/env bun
import { RecorderTUI } from './tui/app';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dir = dirname(fileURLToPath(import.meta.url));
const args = process.argv.slice(2);

// Parse --config=path argument, default to step-config.json in recorder dir
let configPath = join(__dir, 'step-config.json');
for (const arg of args) {
  if (arg.startsWith('--config=')) {
    configPath = arg.split('=')[1];
  }
}

const app = new RecorderTUI(configPath);
app.start().catch(err => {
  console.error('TUI Error:', err);
  process.exit(1);
});
