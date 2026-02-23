#!/usr/bin/env bun
import { RecorderTUI } from './tui/app';
import { join } from 'path';

const args = process.argv.slice(2);

// Parse --config=path argument, default to step-config.json in current directory
let configPath = join(process.cwd(), 'step-config.json');
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
