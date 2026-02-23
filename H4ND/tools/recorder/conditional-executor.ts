import { CdpClient } from './cdp-client';
import type { ConditionalLogic, ConditionCheck, ConditionalBranch } from './types';

/**
 * Evaluates conditional logic and determines next step
 */
export class ConditionalExecutor {
  private cdp: CdpClient;

  constructor(cdpHost: string = '127.0.0.1', cdpPort: number = 9222) {
    this.cdp = new CdpClient(cdpHost, cdpPort);
  }

  async connect(): Promise<void> {
    await this.cdp.connect();
  }

  close(): void {
    this.cdp.close();
  }

  /**
   * Evaluate a condition and return the appropriate branch
   */
  async evaluateCondition(conditional: ConditionalLogic): Promise<{
    conditionMet: boolean;
    branch: ConditionalBranch;
    details: string;
  }> {
    const { condition, onTrue, onFalse } = conditional;
    
    console.log(`\n[Conditional] Evaluating: ${condition.description}`);
    console.log(`[Conditional] Type: ${condition.type}`);
    
    let conditionMet = false;
    let details = '';

    try {
      switch (condition.type) {
        case 'element-exists':
          conditionMet = await this.checkElementExists(condition.target!);
          details = conditionMet 
            ? `Element "${condition.target}" found`
            : `Element "${condition.target}" not found`;
          break;

        case 'element-missing':
          conditionMet = !(await this.checkElementExists(condition.target!));
          details = conditionMet 
            ? `Element "${condition.target}" confirmed missing`
            : `Element "${condition.target}" still present`;
          break;

        case 'text-contains':
          conditionMet = await this.checkTextContains(condition.target!);
          details = conditionMet 
            ? `Text "${condition.target}" found in page`
            : `Text "${condition.target}" not found`;
          break;

        case 'cdp-check':
          conditionMet = await this.checkCdpCommand(condition.cdpCommand!);
          details = conditionMet 
            ? `CDP check "${condition.cdpCommand}" passed`
            : `CDP check "${condition.cdpCommand}" failed`;
          break;

        case 'custom-js':
          conditionMet = await this.evaluateCustomJs(condition.target!);
          details = conditionMet 
            ? `Custom JS returned true: ${condition.target}`
            : `Custom JS returned false: ${condition.target}`;
          break;

        case 'tool-success':
        case 'tool-failure':
          // These are evaluated by the caller based on tool execution result
          throw new Error(`${condition.type} must be evaluated by caller with tool result`);

        default:
          throw new Error(`Unknown condition type: ${condition.type}`);
      }

      const branch = conditionMet ? onTrue : onFalse;
      console.log(`[Conditional] Result: ${conditionMet ? 'TRUE' : 'FALSE'}`);
      console.log(`[Conditional] Action: ${branch.action}${branch.gotoStep ? ` (goto step ${branch.gotoStep})` : ''}`);
      console.log(`[Conditional] Details: ${details}`);

      return { conditionMet, branch, details };
    } catch (error: any) {
      console.error(`[Conditional] Error evaluating condition: ${error.message}`);
      // On error, treat as false and use onFalse branch
      return { 
        conditionMet: false, 
        branch: onFalse, 
        details: `Error: ${error.message}` 
      };
    }
  }

  /**
   * Evaluate condition with tool result (for tool-success/tool-failure types)
   */
  evaluateWithToolResult(
    conditional: ConditionalLogic, 
    toolSuccess: boolean
  ): {
    conditionMet: boolean;
    branch: ConditionalBranch;
    details: string;
  } {
    const { condition, onTrue, onFalse } = conditional;
    
    let conditionMet = false;
    if (condition.type === 'tool-success') {
      conditionMet = toolSuccess;
    } else if (condition.type === 'tool-failure') {
      conditionMet = !toolSuccess;
    } else {
      throw new Error(`evaluateWithToolResult only supports tool-success/tool-failure, got ${condition.type}`);
    }

    const branch = conditionMet ? onTrue : onFalse;
    const details = `Tool ${toolSuccess ? 'succeeded' : 'failed'}, condition ${conditionMet ? 'met' : 'not met'}`;

    console.log(`[Conditional] ${condition.description}`);
    console.log(`[Conditional] Result: ${conditionMet ? 'TRUE' : 'FALSE'}`);
    console.log(`[Conditional] Action: ${branch.action}${branch.gotoStep ? ` (goto step ${branch.gotoStep})` : ''}`);

    return { conditionMet, branch, details };
  }

  private async checkElementExists(selector: string): Promise<boolean> {
    try {
      const result = await this.cdp.evaluate(`
        (function() {
          const element = document.querySelector('${selector.replace(/'/g, "\\'")}');
          return element !== null;
        })()
      `);
      return result === true;
    } catch {
      return false;
    }
  }

  private async checkTextContains(text: string): Promise<boolean> {
    try {
      const result = await this.cdp.evaluate(`
        (function() {
          const bodyText = document.body.innerText || document.body.textContent || '';
          return bodyText.includes('${text.replace(/'/g, "\\'")}');
        })()
      `);
      return result === true;
    } catch {
      return false;
    }
  }

  private async checkCdpCommand(command: string): Promise<boolean> {
    try {
      // Parse command as JSON: {"method": "Page.navigate", "params": {...}}
      const cmd = JSON.parse(command);
      const result = await this.cdp.sendCommand(cmd.method, cmd.params || {});
      return result !== null && result !== undefined;
    } catch {
      return false;
    }
  }

  private async evaluateCustomJs(jsExpression: string): Promise<boolean> {
    try {
      const result = await this.cdp.evaluate(`(function() { return ${jsExpression}; })()`);
      return result === true;
    } catch {
      return false;
    }
  }
}

/**
 * Format conditional logic for human-readable display
 */
export function formatConditional(conditional: ConditionalLogic): string {
  const { condition, onTrue, onFalse } = conditional;
  
  let output = `IF ${condition.description}\n`;
  output += `  THEN ${formatBranch(onTrue)}\n`;
  output += `  ELSE ${formatBranch(onFalse)}`;
  
  return output;
}

function formatBranch(branch: ConditionalBranch): string {
  switch (branch.action) {
    case 'continue':
      return `continue to next step${branch.comment ? ` (${branch.comment})` : ''}`;
    case 'goto':
      return `goto step ${branch.gotoStep}${branch.comment ? ` (${branch.comment})` : ''}`;
    case 'retry':
      return `retry ${branch.retryCount} times with ${branch.retryDelayMs}ms delay${branch.comment ? ` (${branch.comment})` : ''}`;
    case 'abort':
      return `abort workflow${branch.comment ? ` (${branch.comment})` : ''}`;
    default:
      return branch.action;
  }
}
