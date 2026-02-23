#!/usr/bin/env bun
import { runFallbackCommand } from './fallback';
import { install } from './install';
import type { BooleanArg, InstallArgs } from './types';

function parseArgs(args: string[]): InstallArgs {
  const result: InstallArgs = {
    tui: true,
  };

  for (const arg of args) {
    if (arg === '--no-tui') {
      result.tui = false;
    } else if (arg.startsWith('--kimi=')) {
      result.kimi = arg.split('=')[1] as BooleanArg;
    } else if (arg.startsWith('--openai=')) {
      result.openai = arg.split('=')[1] as BooleanArg;
    } else if (arg.startsWith('--anthropic=')) {
      result.anthropic = arg.split('=')[1] as BooleanArg;
    } else if (arg.startsWith('--copilot=')) {
      result.copilot = arg.split('=')[1] as BooleanArg;
    } else if (arg.startsWith('--zai-plan=')) {
      result.zaiPlan = arg.split('=')[1] as BooleanArg;
    } else if (arg.startsWith('--antigravity=')) {
      result.antigravity = arg.split('=')[1] as BooleanArg;
    } else if (arg.startsWith('--chutes=')) {
      result.chutes = arg.split('=')[1] as BooleanArg;
    } else if (arg.startsWith('--tmux=')) {
      result.tmux = arg.split('=')[1] as BooleanArg;
    } else if (arg.startsWith('--opencode-free=')) {
      result.opencodeFree = arg.split('=')[1] as BooleanArg;
    } else if (arg.startsWith('--opencode-free-model=')) {
      result.opencodeFreeModel = arg.split('=')[1];
    } else if (arg === '-h' || arg === '--help') {
      printHelp();
      process.exit(0);
    }
  }

  return result;
}

function printHelp(): void {
  console.log(`
oh-my-opencode-theseus

Usage: bunx oh-my-opencode-theseus <command> [options]

Commands:
  install [OPTIONS]  Install/configure the plugin
  fallback [agent]   Trigger model fallback for an agent
  status             Show current model status for all agents

Install Options:
  --kimi=yes|no          Kimi API access (yes/no)
  --openai=yes|no        OpenAI API access (yes/no)
  --anthropic=yes|no     Anthropic access (yes/no)
  --copilot=yes|no       GitHub Copilot access (yes/no)
  --zai-plan=yes|no      ZAI Coding Plan access (yes/no)
  --antigravity=yes|no   Antigravity/Google models (yes/no)
  --chutes=yes|no        Chutes models (yes/no)
  --opencode-free=yes|no Use OpenCode free models (opencode/*)
  --opencode-free-model  Preferred OpenCode model id or "auto"
  --tmux=yes|no          Enable tmux integration (yes/no)
  --no-tui               Non-interactive mode (requires all flags)
  -h, --help             Show this help message

Fallback Options:
  <agent>                Agent to fallback (orchestrator, oracle, etc.)
  status                 Show current model status

Examples:
  bunx oh-my-opencode-theseus install
  bunx oh-my-opencode-theseus fallback
  bunx oh-my-opencode-theseus fallback oracle
  bunx oh-my-opencode-theseus fallback status
`);
}

async function main(): Promise<void> {
  const args = process.argv.slice(2);

  if (args.length === 0 || args[0] === 'install') {
    const installArgs = parseArgs(args.slice(args[0] === 'install' ? 1 : 0));
    const exitCode = await install(installArgs);
    process.exit(exitCode);
  } else if (args[0] === 'fallback') {
    runFallbackCommand(args.slice(1));
  } else if (args[0] === 'status') {
    runFallbackCommand(['status']);
  } else if (args[0] === '-h' || args[0] === '--help') {
    printHelp();
    process.exit(0);
  } else {
    console.error(`Unknown command: ${args[0]}`);
    console.error('Run with --help for usage information');
    process.exit(1);
  }
}

main().catch((err) => {
  console.error('Fatal error:', err);
  process.exit(1);
});
