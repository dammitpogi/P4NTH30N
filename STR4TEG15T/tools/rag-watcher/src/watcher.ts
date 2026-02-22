/**
 * File Watcher Module
 * Watches for file changes and triggers ingestion
 */

import chokidar from 'chokidar';
import { logger } from './logger.js';

export interface WatcherOptions {
  paths: string[];
  ignored?: string[];
  debounceMs?: number;
  persistent?: boolean;
}

export interface FileEvent {
  type: 'add' | 'change' | 'unlink';
  path: string;
  timestamp: number;
}

type EventHandler = (events: FileEvent[]) => void | Promise<void>;

/**
 * File watcher class for monitoring documentation changes
 */
export class FileWatcher {
  private watcher?: chokidar.FSWatcher;
  private options: WatcherOptions;
  private eventBuffer: FileEvent[] = [];
  private debounceTimer?: NodeJS.Timeout;
  private handlers: EventHandler[] = [];
  private isWatching = false;

  constructor(options: WatcherOptions) {
    this.options = {
      ignored: ['**/node_modules/**', '**/.git/**', '**/dist/**'],
      debounceMs: 500,
      persistent: true,
      ...options,
    };
  }

  /**
   * Add an event handler
   */
  onEvent(handler: EventHandler): void {
    this.handlers.push(handler);
  }

  /**
   * Remove an event handler
   */
  offEvent(handler: EventHandler): void {
    const index = this.handlers.indexOf(handler);
    if (index > -1) {
      this.handlers.splice(index, 1);
    }
  }

  /**
   * Start watching files
   */
  async start(): Promise<void> {
    if (this.isWatching) {
      logger.warn('Watcher is already running');
      return;
    }

    logger.info('Starting file watcher', { 
      paths: this.options.paths,
      ignored: this.options.ignored,
      debounceMs: this.options.debounceMs 
    });

    this.watcher = chokidar.watch(this.options.paths, {
      ignored: this.options.ignored,
      persistent: this.options.persistent,
      ignoreInitial: false,
      awaitWriteFinish: {
        stabilityThreshold: 300,
        pollInterval: 100,
      },
    });

    // Set up event handlers
    this.watcher.on('add', (path) => this.handleEvent('add', path));
    this.watcher.on('change', (path) => this.handleEvent('change', path));
    this.watcher.on('unlink', (path) => this.handleEvent('unlink', path));
    this.watcher.on('error', (error) => this.handleError(error));
    this.watcher.on('ready', () => this.handleReady());

    this.isWatching = true;

    // Wait for ready event
    await new Promise<void>((resolve) => {
      this.watcher?.once('ready', () => resolve());
    });
  }

  /**
   * Stop watching files
   */
  async stop(): Promise<void> {
    if (!this.isWatching || !this.watcher) {
      return;
    }

    logger.info('Stopping file watcher');

    // Clear any pending debounce
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer);
      this.debounceTimer = undefined;
    }

    // Process any remaining buffered events
    if (this.eventBuffer.length > 0) {
      await this.processEvents();
    }

    await this.watcher.close();
    this.watcher = undefined;
    this.isWatching = false;

    logger.info('File watcher stopped');
  }

  /**
   * Handle a file event
   */
  private handleEvent(type: FileEvent['type'], path: string): void {
    const event: FileEvent = {
      type,
      path,
      timestamp: Date.now(),
    };

    logger.debug(`File ${type}: ${path}`);

    this.eventBuffer.push(event);

    // Debounce event processing
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer);
    }

    this.debounceTimer = setTimeout(() => {
      this.processEvents();
    }, this.options.debounceMs);
  }

  /**
   * Process buffered events
   */
  private async processEvents(): Promise<void> {
    if (this.eventBuffer.length === 0) {
      return;
    }

    const events = [...this.eventBuffer];
    this.eventBuffer = [];

    logger.info(`Processing ${events.length} file events`);

    // Call all registered handlers
    for (const handler of this.handlers) {
      try {
        await handler(events);
      } catch (error) {
        logger.error('Event handler failed', { 
          error: error instanceof Error ? error.message : String(error) 
        });
      }
    }
  }

  /**
   * Handle watcher errors
   */
  private handleError(error: Error): void {
    logger.error('File watcher error', { error: error.message });
  }

  /**
   * Handle watcher ready event
   */
  private handleReady(): void {
    logger.info('File watcher ready');
  }

  /**
   * Get current watcher stats
   */
  getStats(): { isWatching: boolean; bufferedEvents: number } {
    return {
      isWatching: this.isWatching,
      bufferedEvents: this.eventBuffer.length,
    };
  }
}

/**
 * Create a watcher for decision files
 */
export function createDecisionWatcher(
  decisionsPath: string,
  onChange: (events: FileEvent[]) => void | Promise<void>
): FileWatcher {
  const watcher = new FileWatcher({
    paths: [`${decisionsPath}/**/*.md`],
    ignored: [
      '**/node_modules/**',
      '**/.git/**',
      '**/dist/**',
      '**/_templates/**',
      '**/clusters/**',
    ],
    debounceMs: 500,
    persistent: true,
  });

  watcher.onEvent(onChange);

  return watcher;
}
