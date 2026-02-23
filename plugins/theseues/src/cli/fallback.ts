import { existsSync, readFileSync, writeFileSync } from 'node:fs';
import { parseConfig, stripJsonComments, writeConfig } from './config-io';
import { getLiteConfig } from './paths';

const AGENT_NAMES = [
  'orchestrator',
  'oracle',
  'designer',
  'explorer',
  'librarian',
  'fixer',
] as const;

type AgentName = (typeof AGENT_NAMES)[number];

interface FallbackResult {
  success: boolean;
  agent: AgentName;
  previousModel?: string;
  newModel?: string;
  position?: number;
  totalModels?: number;
  chain?: string[];
  error?: string;
}

function parseModelReference(model: string): {
  providerID: string;
  modelID: string;
} | null {
  const slashIndex = model.indexOf('/');
  if (slashIndex <= 0 || slashIndex >= model.length - 1) {
    return null;
  }
  return {
    providerID: model.slice(0, slashIndex),
    modelID: model.slice(slashIndex + 1),
  };
}

function getModelChain(
  agentName: AgentName,
  config: Record<string, unknown>,
): string[] {
  const agents = config.agents as
    | Record<string, Record<string, unknown>>
    | undefined;
  const chainCandidates: Array<string | undefined> = [];

  if (agents?.[agentName]) {
    const agentConfig = agents[agentName];
    const models = agentConfig.models as string[] | undefined;
    if (models && Array.isArray(models) && models.length > 0) {
      chainCandidates.push(...models);
    } else if (typeof agentConfig.currentModel === 'string') {
      chainCandidates.push(agentConfig.currentModel);
    }
  }

  const legacyChains = (config.fallback as Record<string, unknown> | undefined)
    ?.chains as Record<string, string[] | undefined> | undefined;
  const legacyChain = legacyChains?.[agentName];
  if (legacyChain && Array.isArray(legacyChain)) {
    chainCandidates.push(...legacyChain);
  }

  const seen = new Set<string>();
  const valid: string[] = [];

  for (const model of chainCandidates) {
    if (!model || seen.has(model)) continue;
    if (!parseModelReference(model)) continue;
    seen.add(model);
    valid.push(model);
  }

  return valid;
}

function getCurrentModel(
  agentName: AgentName,
  config: Record<string, unknown>,
): string | undefined {
  const agents = config.agents as
    | Record<string, Record<string, unknown>>
    | undefined;
  const agentConfig = agents?.[agentName];
  return typeof agentConfig?.currentModel === 'string'
    ? agentConfig.currentModel
    : undefined;
}

export function triggerFallback(
  agentName: AgentName = 'orchestrator',
): FallbackResult {
  const configPath = getLiteConfig();

  if (!existsSync(configPath)) {
    return {
      success: false,
      agent: agentName,
      error: `Config file not found: ${configPath}\n\nRun: bunx oh-my-opencode-theseus install`,
    };
  }

  const { config, error: parseError } = parseConfig(configPath);

  if (parseError || !config) {
    return {
      success: false,
      agent: agentName,
      error: `Failed to parse config: ${parseError || 'Unknown error'}`,
    };
  }

  const currentModel = getCurrentModel(agentName, config);
  if (!currentModel) {
    return {
      success: false,
      agent: agentName,
      error: `No current model configured for ${agentName}`,
    };
  }

  const chain = getModelChain(agentName, config);
  if (chain.length === 0) {
    return {
      success: false,
      agent: agentName,
      error: `No model chain configured for ${agentName}`,
    };
  }

  const currentIndex = chain.indexOf(currentModel);
  const nextIndex = currentIndex === -1 ? 0 : (currentIndex + 1) % chain.length;
  const nextModel = chain[nextIndex];

  if (nextModel === currentModel && chain.length === 1) {
    return {
      success: false,
      agent: agentName,
      previousModel: currentModel,
      chain,
      error: `No alternative model available. Only one model in chain: ${currentModel}`,
    };
  }

  // Update config
  if (!config.agents || typeof config.agents !== 'object') {
    config.agents = {};
  }
  const agents = config.agents as Record<string, Record<string, unknown>>;
  if (!agents[agentName] || typeof agents[agentName] !== 'object') {
    agents[agentName] = {};
  }
  agents[agentName].currentModel = nextModel;

  // Write config
  try {
    writeConfig(configPath, config);
  } catch (err) {
    return {
      success: false,
      agent: agentName,
      error: `Failed to write config: ${err}`,
    };
  }

  return {
    success: true,
    agent: agentName,
    previousModel: currentModel,
    newModel: nextModel,
    position: nextIndex + 1,
    totalModels: chain.length,
    chain,
  };
}

export function printFallbackResult(result: FallbackResult): void {
  if (!result.success) {
    console.error(`\n❌ Fallback failed for ${result.agent}\n`);
    console.error(`   ${result.error}`);
    if (result.chain) {
      console.error(`\n   Model chain: ${result.chain.join(' → ')}`);
    }
    process.exit(1);
  }

  console.log(`\n✅ Fallback successful for ${result.agent}\n`);
  console.log(`   Previous model: ${result.previousModel}`);
  console.log(`   Now using:      ${result.newModel}`);
  console.log(
    `   Position:       ${result.position}/${result.totalModels} in chain`,
  );
  console.log(`   Chain:          ${result.chain?.join(' → ')}`);
  console.log(`\n   The next ${result.agent} prompt will use the new model.`);
  console.log(`   Config saved to: ${getLiteConfig()}`);
}

export function showCurrentStatus(): void {
  const configPath = getLiteConfig();

  if (!existsSync(configPath)) {
    console.error(`\n❌ Config file not found: ${configPath}`);
    console.error(`\n   Run: bunx oh-my-opencode-theseus install`);
    process.exit(1);
  }

  try {
    const content = readFileSync(configPath, 'utf-8');
    const config = JSON.parse(stripJsonComments(content)) as Record<
      string,
      unknown
    >;

    console.log(`\n📊 Current Model Status\n`);
    console.log(`   Config: ${configPath}\n`);

    for (const agentName of AGENT_NAMES) {
      const currentModel = getCurrentModel(agentName, config);
      const chain = getModelChain(agentName, config);

      if (currentModel) {
        const position = chain.indexOf(currentModel) + 1;
        console.log(
          `   ${agentName.padEnd(12)} ${currentModel.padEnd(45)} (${position}/${chain.length})`,
        );
      } else {
        console.log(`   ${agentName.padEnd(12)} (not configured)`);
      }
    }

    console.log('');
  } catch (err) {
    console.error(`\n❌ Failed to read config: ${err}`);
    process.exit(1);
  }
}

export function runFallbackCommand(args: string[]): void {
  const command = args[0];

  if (command === '--help' || command === '-h') {
    console.log(`
oh-my-opencode-theseus fallback command

Trigger a model fallback for any agent.

Usage:
  bunx oh-my-opencode-theseus fallback [agent]
  bunx oh-my-opencode-theseus fallback status

Arguments:
  agent         Agent to trigger fallback for (default: orchestrator)
                Available: orchestrator, oracle, designer, explorer, librarian, fixer
  status        Show current model status for all agents

Examples:
  bunx oh-my-opencode-theseus fallback              # Fallback orchestrator
  bunx oh-my-opencode-theseus fallback orchestrator # Fallback orchestrator explicitly
  bunx oh-my-opencode-theseus fallback oracle       # Fallback oracle
  bunx oh-my-opencode-theseus fallback status       # Show current status
`);
    process.exit(0);
  }

  if (command === 'status') {
    showCurrentStatus();
    return;
  }

  const agentName = (command as AgentName) || 'orchestrator';

  if (!AGENT_NAMES.includes(agentName)) {
    console.error(`\n❌ Unknown agent: ${agentName}\n`);
    console.error(`   Available agents: ${AGENT_NAMES.join(', ')}`);
    console.error(`\n   Run with --help for usage information`);
    process.exit(1);
  }

  const result = triggerFallback(agentName);
  printFallbackResult(result);
}
