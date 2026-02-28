export function log(level: 'info' | 'warn' | 'error', message: string, meta?: Record<string, unknown>): void {
  const timestamp = new Date().toISOString();
  const logEntry = {
    timestamp,
    level,
    message,
    ...meta
  };
  
  // Write to stderr for warnings/errors, stdout for info
  const output = level === 'error' || level === 'warn' ? console.error : console.log;
  output(`[${timestamp}] [${level.toUpperCase()}] ${message}`, meta ? JSON.stringify(meta) : '');
}

export function info(message: string, meta?: Record<string, unknown>): void {
  log('info', message, meta);
}

export function warn(message: string, meta?: Record<string, unknown>): void {
  log('warn', message, meta);
}

export function error(message: string, meta?: Record<string, unknown>): void {
  log('error', message, meta);
}
