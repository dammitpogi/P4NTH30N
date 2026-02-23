#!/usr/bin/env bun
/**
 * DECISION_077: Unified Workflow Runner
 * Runs full Login → Game Selection → Auto Spin → Logout for either platform.
 *
 * Usage:
 *   bun run run.ts firekirin --username=X --password=X [--spins=3]
 *   bun run run.ts orionstars --username=X --password=X [--spins=3]
 *   bun run run.ts firekirin --from-mongo          # pulls first enabled credential from MongoDB
 */
import { runFireKirinWorkflow } from './firekirin-workflow';
import { runOrionStarsWorkflow } from './orionstars-workflow';
import { spawn } from 'child_process';

const args = process.argv.slice(2);
const platform = args[0]?.toLowerCase();

function getArg(name: string, def?: string): string | undefined {
  const a = args.find(a => a.startsWith(`--${name}=`));
  return a ? a.split('=')[1] : def;
}

async function getCredentialFromMongo(game: string): Promise<{ username: string; password: string } | null> {
  return new Promise((resolve) => {
    const t00l5et = 'C:\\P4NTH30N\\T00L5ET\\bin\\Debug\\net10.0-windows7.0\\T00L5ET.exe';
    const proc = spawn(t00l5et, ['credcheck'], { cwd: 'C:\\P4NTH30N' });
    let stdout = '';
    proc.stdout?.on('data', (d: Buffer) => { stdout += d.toString(); });
    proc.on('close', () => {
      // Parse credcheck output for first enabled credential
      const lines = stdout.split('\n');
      for (const line of lines) {
        if (line.includes(game) && line.includes('Enabled') && !line.includes('Banned')) {
          const match = line.match(/Username:\s*(\S+).*Password:\s*(\S+)/);
          if (match) {
            resolve({ username: match[1], password: match[2] });
            return;
          }
        }
      }
      resolve(null);
    });
    proc.on('error', () => resolve(null));
  });
}

if (!platform || !['firekirin', 'orionstars'].includes(platform)) {
  console.log(`
DECISION_077: Production Navigation Workflow Runner

Usage:
  bun run run.ts <platform> --username=<user> --password=<pass> [--spins=3]

Platforms:
  firekirin     Login → SLOT → Fortune Piggy → Auto Spin → Logout
  orionstars    Login → SLOT → First Game → Auto Spin → Logout

Options:
  --username    Account username
  --password    Account password
  --spins       Number of spins (default: 3)
  --from-mongo  Pull credentials from MongoDB (requires T00L5ET)
  --use-config  Load and execute steps from step-config-firekirin.json

Examples:
  bun run run.ts firekirin --username=PaulPP9fk --password=mypass --spins=5
  bun run run.ts orionstars --username=TestUser1 --password=mypass
`);
  process.exit(1);
}

let username = getArg('username');
let password = getArg('password');
const spins = parseInt(getArg('spins', '3')!, 10);
const fromMongo = args.includes('--from-mongo');
const useConfig = args.includes('--use-config');

if (fromMongo && (!username || !password)) {
  const game = platform === 'firekirin' ? 'FireKirin' : 'OrionStars';
  console.log(`Fetching credential from MongoDB for ${game}...`);
  const cred = await getCredentialFromMongo(game);
  if (cred) {
    username = cred.username;
    password = cred.password;
    console.log(`Using: ${username}`);
  } else {
    console.error('No credential found in MongoDB. Provide --username and --password.');
    process.exit(1);
  }
}

if (!username || !password) {
  console.error('Missing --username or --password. Use --from-mongo to pull from MongoDB.');
  process.exit(1);
}

console.log(`\n${'='.repeat(60)}`);
console.log(`DECISION_077: ${platform.toUpperCase()} Production Workflow`);
console.log(`User: ${username} | Spins: ${spins}`);
console.log(`${'='.repeat(60)}\n`);

let result: any;
if (platform === 'firekirin') {
  result = await runFireKirinWorkflow({ username, password, spins, useConfig });
} else {
  result = await runOrionStarsWorkflow({ username, password, spins });
}

console.log(`\n${'='.repeat(60)}`);
console.log(`${platform.toUpperCase()}: ${result.success ? '✅ SUCCESS' : '❌ FAILED'}`);
console.log(`Duration: ${(result.durationMs / 1000).toFixed(1)}s | Screenshots: ${result.screenshots.length}`);
console.log('Phases:');
for (const p of result.phases) {
  console.log(`  ${p.success ? '✅' : '❌'} ${p.name} (${(p.durationMs / 1000).toFixed(1)}s)`);
}
if (result.error) console.log(`\nError: ${result.error}`);
console.log(`${'='.repeat(60)}`);

process.exit(result.success ? 0 : 1);
