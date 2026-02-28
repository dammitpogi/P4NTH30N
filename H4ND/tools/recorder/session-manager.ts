import { writeFile, appendFile, mkdir } from 'fs/promises';
import { join } from 'path';
import type { SessionMetadata, StepRecord } from './types';

export class SessionManager {
  private metadata: SessionMetadata;
  private stepCounter: number = 0;

  constructor(metadata: SessionMetadata) {
    this.metadata = metadata;
  }

  static async initialize(
    platform: 'firekirin' | 'orionstars',
    decision: string,
    baseDir: string = 'C:\\P4NTHE0N\\DECISION_077\\sessions'
  ): Promise<SessionManager> {
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, -5);
    const sessionId = `${platform}-${timestamp}`;
    const sessionDir = join(baseDir, sessionId);
    const screenshotDir = join(sessionDir, 'screenshots');

    await mkdir(sessionDir, { recursive: true });
    await mkdir(screenshotDir, { recursive: true });

    const metadata: SessionMetadata = {
      sessionId,
      platform,
      decision,
      startTime: new Date().toISOString(),
      baseDir: sessionDir,
      screenshotDir,
      logFile: join(sessionDir, 'session.ndjson'),
      markdownFile: join(sessionDir, 'session.md'),
    };

    await writeFile(metadata.logFile, '');
    await writeFile(
      metadata.markdownFile,
      `# ${decision} - ${platform} Navigation Session\n\n` +
      `**Session ID**: ${sessionId}\n` +
      `**Start Time**: ${metadata.startTime}\n` +
      `**Platform**: ${platform}\n\n` +
      `---\n\n`
    );

    return new SessionManager(metadata);
  }

  async recordStep(step: StepRecord): Promise<void> {
    this.stepCounter++;
    step.stepNumber = this.stepCounter;

    await appendFile(this.metadata.logFile, JSON.stringify(step) + '\n');

    const markdown = this.formatStepMarkdown(step);
    await appendFile(this.metadata.markdownFile, markdown);
  }

  private formatStepMarkdown(step: StepRecord): string {
    let md = `## Step ${step.stepNumber}: ${step.phase}\n\n`;
    md += `**Status**: ${step.status}\n`;
    md += `**Screenshot**: \`screenshots/${step.screenshot}\`\n`;
    
    if (step.tool) {
      md += `**Tool**: ${step.tool}\n`;
    }
    
    if (step.duration) {
      md += `**Duration**: ${step.duration}ms\n`;
    }

    if (step.coordinates && Object.keys(step.coordinates).length > 0) {
      md += `\n### Coordinates Used\n`;
      for (const [name, coord] of Object.entries(step.coordinates)) {
        md += `- ${name}: \`{${coord.x}, ${coord.y}}\`\n`;
      }
    }

    if (step.toolOutput) {
      md += `\n### T00L5ET Output\n\`\`\`\n${step.toolOutput}\n\`\`\`\n`;
    }

    if (step.cdpVerification && Object.keys(step.cdpVerification).length > 0) {
      md += `\n### CDP Verification\n`;
      for (const [check, result] of Object.entries(step.cdpVerification)) {
        const icon = typeof result === 'boolean' ? (result ? '✅' : '❌') : '📝';
        md += `- ${check}: ${icon} ${typeof result === 'string' ? result : ''}\n`;
      }
    }

    if (step.phaseTransition) {
      md += `\n### Phase Transition\n`;
      md += `- Entry gate: ${step.phaseTransition.entryGate}\n`;
      md += `- Exit gate: ${step.phaseTransition.exitGate}\n`;
      if (step.phaseTransition.nextPhase) {
        md += `- Next phase: ${step.phaseTransition.nextPhase}\n`;
      }
    }

    if (step.nextAction) {
      md += `\n### Next Action\n${step.nextAction}\n`;
    }

    md += `\n---\n\n`;
    return md;
  }

  getMetadata(): SessionMetadata {
    return this.metadata;
  }

  getSessionDir(): string {
    return this.metadata.baseDir;
  }

  getScreenshotDir(): string {
    return this.metadata.screenshotDir;
  }
}
