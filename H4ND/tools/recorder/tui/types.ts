// TUI Types for Recorder Macro Editor
import type { CanvasBounds, RelativeCoordinate, ConditionalLogic } from '../types';

export interface MacroStep {
  stepId: number;
  enabled?: boolean;
  platform?: 'firekirin' | 'orionstars';  // Optional: filter steps by platform
  phase: 'Login' | 'GameSelection' | 'Spin' | 'Logout' | 'DismissModals';
  takeScreenshot: boolean;
  screenshotReason: string;
  comment: string;
  tool: 'diag' | 'login' | 'nav' | 'credcheck' | 'none';
  action?: 'click' | 'type' | 'clip' | 'longpress' | 'navigate' | 'wait';
  // ARCH-081: Supports both relative (rx/ry) and absolute (x/y) coordinates
  coordinates?: RelativeCoordinate | { x: number; y: number };
  // ARCH-081: Canvas bounds captured at time of coordinate capture
  canvasBounds?: CanvasBounds;
  input?: string;
  url?: string;       // URL for navigate action
  holdMs?: number;    // longpress hold duration (ms) — only used when action='longpress'
  delayMs?: number;
  retryCount?: number;
  verification: {
    entryGate: string;
    exitGate: string;
    progressIndicators?: string[];
  };
  breakpoint: boolean;
  // Conditional logic for error handling
  conditional?: ConditionalLogic;
  // Goto target for error recovery
  gotoStep?: number;
  // Runtime state (not persisted)
  _status?: 'pending' | 'running' | 'passed' | 'failed' | 'skipped';
  _lastResult?: string;
  _screenshotPath?: string;
  _durationMs?: number;
}

export interface MacroConfig {
  platform: 'firekirin' | 'orionstars';
  decision: string;
  sessionNotes: string;
  steps: MacroStep[];
  metadata: {
    created: string;
    modified: string;
    // ARCH-081: Design viewport and coordinates with relative values
    designViewport?: { width: number; height: number; calibratedDate: string };
    coordinates: Record<string, Record<string, RelativeCoordinate | { x: number; y: number }>>;
    credentials: Record<string, { username: string; password: string; source: string }>;
  };
}

export type ViewMode =
  | 'step-list'
  | 'step-detail'
  | 'step-edit'
  | 'step-add'
  | 'run-mode'
  | 'screenshot-preview'
  | 'session-select'
  | 'conditional-edit'
  | 'help';

export type EditField =
  | 'phase'
  | 'action'
  | 'tool'
  | 'coordinates_x'
  | 'coordinates_y'
  | 'coordinates_rx'
  | 'coordinates_ry'
  | 'input'
  | 'url'
  | 'holdMs'
  | 'delayMs'
  | 'takeScreenshot'
  | 'screenshotReason'
  | 'comment'
  | 'entryGate'
  | 'exitGate'
  | 'gotoStep'
  | 'conditional';

export const EDIT_FIELDS: EditField[] = [
  'phase', 'action', 'tool',
  'coordinates_x', 'coordinates_y',
  'coordinates_rx', 'coordinates_ry',
  'input', 'url', 'holdMs', 'delayMs',
  'takeScreenshot', 'screenshotReason',
  'comment', 'entryGate', 'exitGate',
  'gotoStep', 'conditional',
];

export const PHASES = ['Login', 'GameSelection', 'Spin', 'Logout', 'DismissModals'] as const;
export const ACTIONS = ['click', 'type', 'clip', 'longpress', 'navigate', 'wait'] as const;
export const TOOLS = ['diag', 'login', 'nav', 'credcheck', 'none'] as const;

export interface AppState {
  view: ViewMode;
  configPath: string;
  config: MacroConfig;
  cursor: number;        // Selected step index
  scroll: number;        // Scroll offset for step list
  editCursor: number;    // Selected field in edit mode
  editBuffer: string;    // Current text being edited
  editingField: boolean; // Whether actively typing into a field
  runCursor: number;     // Current step in run mode
  runPaused: boolean;    // Paused at breakpoint
  runAuto: boolean;      // Auto-advance through steps (F5 mode)
  runExecuting: boolean; // Currently executing a step (async)
  cdpConnected: boolean; // Whether CDP is connected
  cdpBrowser: string;    // Connected browser string
  sessionDir: string;    // Screenshot session directory
  dirty: boolean;        // Unsaved changes
  statusMessage: string; // Bottom status bar message
  conditionalCursor: number;
  conditionalEditing: boolean;
  conditionalEditBuffer: string;
  statusTimeout?: ReturnType<typeof setTimeout>;
  screenRows: number;
  screenCols: number;
}
