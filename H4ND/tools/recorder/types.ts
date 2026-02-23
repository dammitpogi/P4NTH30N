// ARCH-081: Canvas bounding rectangle from getBoundingClientRect()
export interface CanvasBounds {
  x: number;
  y: number;
  width: number;
  height: number;
}

// ARCH-081: Coordinate that supports both absolute and relative (0.0-1.0) values
export interface RelativeCoordinate {
  rx: number;  // relative X (0.0-1.0) within canvas
  ry: number;  // relative Y (0.0-1.0) within canvas
  x: number;   // absolute fallback X (for design viewport)
  y: number;   // absolute fallback Y (for design viewport)
}

// ARCH-081: Design viewport that the absolute fallback coordinates were calibrated against
export interface DesignViewport {
  width: number;
  height: number;
  calibratedDate: string;
}

export interface SessionMetadata {
  sessionId: string;
  platform: 'firekirin' | 'orionstars';
  decision: string;
  startTime: string;
  baseDir: string;
  screenshotDir: string;
  logFile: string;
  markdownFile: string;
}

export interface PhaseDefinition {
  entryGate: {
    elements: string[];
    cdpChecks?: string[];
  };
  exitGate: {
    elements: string[];
    cdpChecks?: string[];
  };
  // ARCH-081: Actions now support RelativeCoordinate (preferred) or legacy absolute
  actions: Record<string, RelativeCoordinate | { x: number; y: number } | { selector: string }>;
  failureIndicators?: string[];
  successIndicators?: string[];
}

export interface PlatformConfig {
  platform: string;
  baseUrl: string;
  phases: Record<string, PhaseDefinition>;
}

export interface StepRecord {
  stepNumber: number;
  phase: string;
  timestamp: string;
  screenshot: string;
  tool?: string;
  toolOutput?: string;
  duration?: number;
  status: 'success' | 'failure' | 'blocked';
  // ARCH-081: Coordinates now include both absolute and relative
  coordinates?: Record<string, RelativeCoordinate | { x: number; y: number }>;
  // ARCH-081: Canvas bounds captured at this step (for coordinate validation)
  canvasBounds?: CanvasBounds;
  cdpVerification?: Record<string, boolean | string>;
  phaseTransition?: {
    entryGate: string;
    exitGate: string;
    nextPhase?: string;
  };
  nextAction?: string;
  // Conditional logic for error handling
  conditional?: ConditionalLogic;
  // Goto target for error recovery
  gotoStep?: number;
}

export interface ConditionalLogic {
  condition: ConditionCheck;
  onTrue: ConditionalBranch;
  onFalse: ConditionalBranch;
}

export interface ConditionCheck {
  type: 'element-exists' | 'element-missing' | 'text-contains' | 'cdp-check' | 'tool-success' | 'tool-failure' | 'custom-js';
  target?: string; // Element selector, text to search, or JS expression
  cdpCommand?: string; // CDP command for cdp-check type
  description: string; // Human-readable condition description
}

export interface ConditionalBranch {
  action: 'continue' | 'goto' | 'retry' | 'abort';
  gotoStep?: number; // Step number to jump to
  retryCount?: number; // Number of retries
  retryDelayMs?: number; // Delay between retries
  comment?: string; // Explanation of this branch
}

export interface T00L5ETResult {
  success: boolean;
  stdout: string;
  stderr: string;
  exitCode: number;
  duration: number;
}
