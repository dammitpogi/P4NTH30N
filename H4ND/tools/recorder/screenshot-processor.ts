import type { PhaseDefinition, PlatformConfig } from './types';

export class ScreenshotProcessor {
  private config: PlatformConfig;

  constructor(config: PlatformConfig) {
    this.config = config;
  }

  analyzePhase(phaseName: string, screenshotPath: string): {
    phase: string;
    entryGate: string;
    exitGate: string;
    suggestedActions: string[];
  } {
    const phase = this.config.phases[phaseName];
    if (!phase) {
      throw new Error(`Unknown phase: ${phaseName}`);
    }

    return {
      phase: phaseName,
      entryGate: phase.entryGate.elements.join(', '),
      exitGate: phase.exitGate.elements.join(', '),
      suggestedActions: this.getSuggestedActions(phase),
    };
  }

  private getSuggestedActions(phase: PhaseDefinition): string[] {
    const actions: string[] = [];
    
    for (const [name, action] of Object.entries(phase.actions)) {
      if ('x' in action && 'y' in action) {
        actions.push(`Click ${name} at (${action.x}, ${action.y})`);
      } else if ('selector' in action) {
        actions.push(`Interact with ${name} using selector: ${action.selector}`);
      }
    }

    return actions;
  }

  getPhaseDefinition(phaseName: string): PhaseDefinition | undefined {
    return this.config.phases[phaseName];
  }

  getCdpVerificationChecks(phaseName: string): string[] {
    const phase = this.config.phases[phaseName];
    if (!phase) return [];

    const checks: string[] = [
      'location.href',
      'document.readyState',
    ];

    if (phase.exitGate.cdpChecks) {
      checks.push(...phase.exitGate.cdpChecks);
    }

    return checks;
  }

  formatFailureIndicators(phaseName: string): string {
    const phase = this.config.phases[phaseName];
    if (!phase || !phase.failureIndicators) return 'No specific failure indicators defined';

    return phase.failureIndicators.map(indicator => `❌ ${indicator}`).join('\n');
  }

  formatSuccessIndicators(phaseName: string): string {
    const phase = this.config.phases[phaseName];
    if (!phase || !phase.successIndicators) return 'No specific success indicators defined';

    return phase.successIndicators.map(indicator => `✅ ${indicator}`).join('\n');
  }
}
