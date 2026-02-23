import type { PluginInput } from '@opencode-ai/plugin';
import { execFile } from 'node:child_process';
import { promisify } from 'node:util';
import { DEFAULT_CODEMAP_CONFIG } from './constants';
import { log } from '../../utils/logger';

const execFileAsync = promisify(execFile);

interface ModelsResponse {
  data?: Array<{ id?: string }>;
}

interface LmsLocalModel {
  modelKey?: string;
  path?: string;
  indexedModelIdentifier?: string;
}

interface LmsLoadedModel {
  identifier?: string;
  modelKey?: string;
  path?: string;
}

function getAuthHeaders(apiKey: string): Record<string, string> {
  if (!apiKey) {
    return {};
  }

  return {
    Authorization: `Bearer ${apiKey}`,
  };
}

function matchesModel(modelId: string, configuredModel: string, hfModel: string): boolean {
  const normalizedModelId = modelId.toLowerCase();
  const normalizedConfigured = configuredModel.toLowerCase();
  const normalizedHf = hfModel.toLowerCase();

  return (
    normalizedModelId === normalizedConfigured ||
    normalizedModelId.includes(normalizedConfigured) ||
    normalizedModelId === normalizedHf ||
    normalizedModelId.includes(normalizedHf)
  );
}

async function isModelLoaded(
  config: typeof DEFAULT_CODEMAP_CONFIG,
): Promise<boolean> {
  const response = await fetch(`${config.lmStudioBaseUrl}/v1/models`, {
    headers: {
      'Content-Type': 'application/json',
      ...getAuthHeaders(config.lmStudioApiKey),
    },
  });

  if (!response.ok) {
    throw new Error(`LM Studio models endpoint returned ${response.status}`);
  }

  const payload = (await response.json()) as ModelsResponse;
  const models = payload.data ?? [];

  return models.some((model) => {
    const id = model.id ?? '';
    return matchesModel(id, config.lmStudioModel, config.hfModel);
  });
}

async function showToast(
  ctx: PluginInput,
  title: string,
  message: string,
  variant: 'info' | 'success' | 'warning' | 'error',
): Promise<void> {
  try {
    await ctx.client.tui.showToast({
      body: {
        title,
        message,
        variant,
        duration: 5000,
      },
    });
  } catch {
    // Ignore toast failures.
  }
}

async function runLmsCommand(args: string[]): Promise<void> {
  const candidates = ['lms', 'lms.cmd', 'lmstudio'];
  let lastError: unknown = null;

  for (const command of candidates) {
    try {
      await execFileAsync(command, args, {
        timeout: 15 * 60 * 1000,
      });
      return;
    } catch (error) {
      lastError = error;
    }
  }

  throw lastError instanceof Error
    ? lastError
    : new Error('LM Studio CLI command failed');
}

async function runLmsJson<T>(args: string[]): Promise<T> {
  const candidates = ['lms', 'lms.cmd', 'lmstudio'];
  let lastError: unknown = null;

  for (const command of candidates) {
    try {
      const { stdout } = await execFileAsync(command, args, {
        timeout: 30_000,
      });
      return JSON.parse(stdout) as T;
    } catch (error) {
      lastError = error;
    }
  }

  throw lastError instanceof Error
    ? lastError
    : new Error('LM Studio CLI JSON command failed');
}

async function startLmStudioServer(): Promise<void> {
  try {
    await runLmsCommand(['server', 'start']);
  } catch {
    // Ignore: can fail if already started by app.
  }
}

function modelMatchesLocal(local: LmsLocalModel, config: typeof DEFAULT_CODEMAP_CONFIG): boolean {
  const modelKey = (local.modelKey ?? '').toLowerCase();
  const path = (local.path ?? '').toLowerCase();
  const indexed = (local.indexedModelIdentifier ?? '').toLowerCase();
  const desiredKey = config.lmStudioModel.toLowerCase();
  const desiredHf = config.hfModel.toLowerCase();

  return (
    modelKey === desiredKey ||
    path.includes(desiredHf) ||
    indexed.includes(desiredHf) ||
    path.includes(desiredKey)
  );
}

function modelMatchesLoaded(loaded: LmsLoadedModel, config: typeof DEFAULT_CODEMAP_CONFIG): boolean {
  const identifier = (loaded.identifier ?? '').toLowerCase();
  const modelKey = (loaded.modelKey ?? '').toLowerCase();
  const path = (loaded.path ?? '').toLowerCase();
  const desiredKey = config.lmStudioModel.toLowerCase();
  const desiredHf = config.hfModel.toLowerCase();

  return (
    identifier === desiredKey ||
    modelKey === desiredKey ||
    path.includes(desiredHf) ||
    path.includes(desiredKey)
  );
}

async function getLocalModels(): Promise<LmsLocalModel[]> {
  return runLmsJson<LmsLocalModel[]>(['ls', '--json']);
}

async function getLoadedModels(): Promise<LmsLoadedModel[]> {
  return runLmsJson<LmsLoadedModel[]>(['ps', '--json']);
}

async function ensureModelDownloaded(config: typeof DEFAULT_CODEMAP_CONFIG): Promise<string> {
  const localModels = await getLocalModels();
  const existing = localModels.find((model) => modelMatchesLocal(model, config));
  if (existing?.modelKey) {
    return existing.modelKey;
  }

  await runLmsCommand(['get', config.hfModel, '--yes']);

  const refreshed = await getLocalModels();
  const downloaded = refreshed.find((model) => modelMatchesLocal(model, config));
  if (!downloaded?.modelKey) {
    throw new Error('Model downloaded but not found in local registry');
  }

  return downloaded.modelKey;
}

async function ensureModelLoadedByCli(config: typeof DEFAULT_CODEMAP_CONFIG): Promise<void> {
  const loaded = await getLoadedModels();
  if (loaded.some((model) => modelMatchesLoaded(model, config))) {
    return;
  }

  const localModelKey = await ensureModelDownloaded(config);
  await runLmsCommand([
    'load',
    localModelKey,
    '--identifier',
    config.lmStudioModel,
    '--yes',
  ]);
}

export async function ensureLmStudioModelLoaded(
  ctx: PluginInput,
  options?: Partial<typeof DEFAULT_CODEMAP_CONFIG>,
): Promise<void> {
  const config = { ...DEFAULT_CODEMAP_CONFIG, ...options };

  if (!config.enabled || !config.summarizeWithLmStudio || !config.autoEnsureModel) {
    return;
  }

  try {
    if (await isModelLoaded(config)) {
      return;
    }
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    log('[directory-codemap-injector] Failed to check model list', { message });
  }

  await showToast(
    ctx,
    'Code Map Summarizer',
    `Loading LM Studio model ${config.hfModel}...`,
    'info',
  );

  try {
    await startLmStudioServer();
    await ensureModelLoadedByCli(config);

    const loaded =
      (await getLoadedModels()).some((model) =>
        modelMatchesLoaded(model, config),
      ) || (await isModelLoaded(config));
    if (!loaded) {
      throw new Error('Model still not loaded after download/load attempt');
    }

    await showToast(
      ctx,
      'Code Map Summarizer',
      `LM Studio model ready: ${config.hfModel}`,
      'success',
    );
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    log('[directory-codemap-injector] Failed to auto-load LM Studio model', {
      message,
    });
    await showToast(
      ctx,
      'Code Map Summarizer',
      `Auto-load failed. Please load ${config.hfModel} in LM Studio.`,
      'warning',
    );
  }
}
