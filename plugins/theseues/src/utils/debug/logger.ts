import * as fs from 'node:fs';
import * as os from 'node:os';
import * as path from 'node:path';

export enum DebugLevel {
  SILENT = 0,
  ERROR = 1,
  WARN = 2,
  INFO = 3,
  DEBUG = 4,
  TRACE = 5,
}

export interface DebugConfig {
  level: DebugLevel;
  console: boolean;
  file?: string;
}

type DebugConfigFile = {
  logging?: {
    defaultLevel?: 'SILENT' | 'ERROR' | 'WARN' | 'INFO' | 'DEBUG' | 'TRACE';
    consoleEnabled?: boolean;
    fileEnabled?: boolean;
    logFile?: string;
  };
  suppressConsole?: boolean;
};

function parseLevel(level?: string): DebugLevel {
  switch (level) {
    case 'SILENT':
      return DebugLevel.SILENT;
    case 'ERROR':
      return DebugLevel.ERROR;
    case 'WARN':
      return DebugLevel.WARN;
    case 'DEBUG':
      return DebugLevel.DEBUG;
    case 'TRACE':
      return DebugLevel.TRACE;
    case 'INFO':
    default:
      return DebugLevel.INFO;
  }
}

function resolveLogPath(logFile?: string): string {
  if (!logFile) {
    return path.join(
      os.homedir(),
      '.config',
      'opencode',
      '.debug',
      'opencode-debug.log',
    );
  }

  if (path.isAbsolute(logFile)) {
    return logFile;
  }

  return path.join(os.homedir(), '.config', 'opencode', logFile);
}

function loadDebugConfig(): DebugConfig {
  const configPath = path.join(
    os.homedir(),
    '.config',
    'opencode',
    '.debug',
    'debug.json',
  );

  const defaults: DebugConfig = {
    level: DebugLevel.INFO,
    console: false,
    file: resolveLogPath('.debug/opencode-debug.log'),
  };

  try {
    if (!fs.existsSync(configPath)) {
      return defaults;
    }

    const parsed = JSON.parse(
      fs.readFileSync(configPath, 'utf8'),
    ) as DebugConfigFile;
    const logging = parsed.logging ?? {};
    const consoleEnabled = logging.consoleEnabled === true;
    const suppressConsole = parsed.suppressConsole === true;
    const fileEnabled = logging.fileEnabled !== false;

    return {
      level: parseLevel(logging.defaultLevel),
      console: consoleEnabled && !suppressConsole,
      file: fileEnabled ? resolveLogPath(logging.logFile) : undefined,
    };
  } catch {
    return defaults;
  }
}

class DebugLogger {
  private config: DebugConfig;

  constructor(config: DebugConfig) {
    this.config = config;
  }

  private shouldLog(level: DebugLevel): boolean {
    return level <= this.config.level;
  }

  private format(level: DebugLevel, message: string): string {
    return `[${new Date().toISOString()}] [${DebugLevel[level]}] ${message}`;
  }

  private consoleMethod(level: DebugLevel): 'error' | 'warn' | 'info' | 'log' {
    switch (level) {
      case DebugLevel.ERROR:
        return 'error';
      case DebugLevel.WARN:
        return 'warn';
      case DebugLevel.INFO:
        return 'info';
      default:
        return 'log';
    }
  }

  private writeToFile(line: string): void {
    if (!this.config.file) return;
    try {
      const dir = path.dirname(this.config.file);
      if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
      }
      fs.appendFileSync(this.config.file, `${line}\n`);
    } catch {
      // Ignore logging failures.
    }
  }

  log(level: DebugLevel, message: string, ...args: unknown[]): void {
    if (!this.shouldLog(level)) return;
    const line = this.format(level, message);

    if (this.config.console) {
      const method = this.consoleMethod(level);
      (console as unknown as Record<string, (...input: unknown[]) => void>)[method](
        line,
        ...args,
      );
    }

    if (args.length > 0) {
      this.writeToFile(`${line} ${JSON.stringify(args)}`);
      return;
    }
    this.writeToFile(line);
  }

  error(message: string, ...args: unknown[]): void {
    this.log(DebugLevel.ERROR, message, ...args);
  }

  warn(message: string, ...args: unknown[]): void {
    this.log(DebugLevel.WARN, message, ...args);
  }

  info(message: string, ...args: unknown[]): void {
    this.log(DebugLevel.INFO, message, ...args);
  }

  debug(message: string, ...args: unknown[]): void {
    this.log(DebugLevel.DEBUG, message, ...args);
  }

  trace(message: string, ...args: unknown[]): void {
    this.log(DebugLevel.TRACE, message, ...args);
  }

  setLevel(level: DebugLevel): void {
    this.config.level = level;
  }

  setConsole(enabled: boolean): void {
    this.config.console = enabled;
  }

  setLogFile(file?: string): void {
    this.config.file = file;
  }
}

export const debug = new DebugLogger(loadDebugConfig());

export function log(message: string, data?: unknown): void {
  if (data !== undefined) {
    debug.info(message, data);
    return;
  }
  debug.info(message);
}

export function error(message: string, ...args: unknown[]): void {
  debug.error(message, ...args);
}

export function warn(message: string, ...args: unknown[]): void {
  debug.warn(message, ...args);
}

export function info(message: string, ...args: unknown[]): void {
  debug.info(message, ...args);
}

export function debugMsg(message: string, ...args: unknown[]): void {
  debug.debug(message, ...args);
}

export function trace(message: string, ...args: unknown[]): void {
  debug.trace(message, ...args);
}

export default debug;
