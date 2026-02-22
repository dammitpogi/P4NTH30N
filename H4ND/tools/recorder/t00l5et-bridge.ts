import { spawn } from 'child_process';
import type { T00L5ETResult } from './types';

export class T00L5ETBridge {
  private t00l5etPath: string;

  constructor(t00l5etPath: string = 'C:\\P4NTH30N\\T00L5ET\\bin\\Debug\\net10.0-windows7.0\\T00L5ET.exe') {
    this.t00l5etPath = t00l5etPath;
  }

  async executeTool(toolName: string, args: string[] = []): Promise<T00L5ETResult> {
    const startTime = Date.now();
    
    return new Promise((resolve) => {
      const fullArgs = [toolName, ...args];
      const proc = spawn(this.t00l5etPath, fullArgs, {
        cwd: 'C:\\P4NTH30N',
        env: process.env,
      });

      let stdout = '';
      let stderr = '';

      proc.stdout?.on('data', (data) => {
        stdout += data.toString();
      });

      proc.stderr?.on('data', (data) => {
        stderr += data.toString();
      });

      proc.on('close', (code) => {
        const duration = Date.now() - startTime;
        resolve({
          success: code === 0,
          stdout,
          stderr,
          exitCode: code || 0,
          duration,
        });
      });

      proc.on('error', (err) => {
        const duration = Date.now() - startTime;
        resolve({
          success: false,
          stdout,
          stderr: stderr + '\n' + err.message,
          exitCode: -1,
          duration,
        });
      });
    });
  }

  async diag(): Promise<T00L5ETResult> {
    return this.executeTool('diag');
  }

  async login(username?: string, password?: string): Promise<T00L5ETResult> {
    const args = [];
    if (username) args.push('--username', username);
    if (password) args.push('--password', password);
    return this.executeTool('login', args);
  }

  async credcheck(): Promise<T00L5ETResult> {
    return this.executeTool('credcheck');
  }

  parseOutput(result: T00L5ETResult): Record<string, any> {
    const parsed: Record<string, any> = {
      raw: result.stdout,
      success: result.success,
      duration: result.duration,
    };

    const lines = result.stdout.split('\n');
    for (const line of lines) {
      if (line.includes('CDP:')) {
        parsed.cdp = line.includes('CONNECTED') || line.includes('OK');
      }
      if (line.includes('MongoDB:')) {
        parsed.mongodb = line.includes('CONNECTED') || line.includes('OK');
      }
      if (line.includes('URL:')) {
        const match = line.match(/URL:\s*(.+)/);
        if (match) parsed.url = match[1].trim();
      }
      if (line.includes('Ready State:')) {
        const match = line.match(/Ready State:\s*(.+)/);
        if (match) parsed.readyState = match[1].trim();
      }
      if (line.toLowerCase().includes('slot') || line.toLowerCase().includes('fish')) {
        parsed.loginSuccess = true;
      }
    }

    return parsed;
  }
}
