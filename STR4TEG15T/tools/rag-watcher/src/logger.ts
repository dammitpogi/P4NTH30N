/**
 * Logger utility for RAG Watcher
 * Provides structured logging with timestamps and log levels
 */

export type LogLevel = 'debug' | 'info' | 'warn' | 'error';

export interface LogEntry {
  timestamp: string;
  level: LogLevel;
  message: string;
  context?: Record<string, unknown>;
}

export class Logger {
  private level: LogLevel;
  private logs: LogEntry[] = [];
  private maxLogs: number;

  constructor(level: LogLevel = 'info', maxLogs = 1000) {
    this.level = level;
    this.maxLogs = maxLogs;
  }

  private shouldLog(level: LogLevel): boolean {
    const levels: LogLevel[] = ['debug', 'info', 'warn', 'error'];
    return levels.indexOf(level) >= levels.indexOf(this.level);
  }

  private formatMessage(entry: LogEntry): string {
    const context = entry.context
      ? ' ' + JSON.stringify(entry.context)
      : '';
    return `[${entry.timestamp}] [${entry.level.toUpperCase()}] ${entry.message}${context}`;
  }

  private log(level: LogLevel, message: string, context?: Record<string, unknown>): void {
    if (!this.shouldLog(level)) return;

    const entry: LogEntry = {
      timestamp: new Date().toISOString(),
      level,
      message,
      context,
    };

    this.logs.push(entry);

    // Trim logs if exceeding max
    if (this.logs.length > this.maxLogs) {
      this.logs = this.logs.slice(-this.maxLogs);
    }

    // Output to console
    const formatted = this.formatMessage(entry);
    if (level === 'error') {
      console.error(formatted);
    } else if (level === 'warn') {
      console.warn(formatted);
    } else {
      console.log(formatted);
    }
  }

  debug(message: string, context?: Record<string, unknown>): void {
    this.log('debug', message, context);
  }

  info(message: string, context?: Record<string, unknown>): void {
    this.log('info', message, context);
  }

  warn(message: string, context?: Record<string, unknown>): void {
    this.log('warn', message, context);
  }

  error(message: string, context?: Record<string, unknown>): void {
    this.log('error', message, context);
  }

  getLogs(): LogEntry[] {
    return [...this.logs];
  }

  getRecentLogs(count: number = 10): LogEntry[] {
    return this.logs.slice(-count);
  }

  clear(): void {
    this.logs = [];
  }

  setLevel(level: LogLevel): void {
    this.level = level;
  }
}

// Default logger instance
export const logger = new Logger(process.env.LOG_LEVEL as LogLevel || 'info');
