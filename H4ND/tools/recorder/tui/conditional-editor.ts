import type { ConditionalLogic, ConditionCheck, ConditionalBranch } from '../types';
import { c, box, moveTo, clearLine, pad } from './screen';

export interface ConditionalEditorState {
  editingSection: 'condition' | 'onTrue' | 'onFalse';
  editingField: string | null;
  conditionType: ConditionCheck['type'];
  conditionTarget: string;
  conditionDescription: string;
  cdpCommand: string;
  onTrueAction: ConditionalBranch['action'];
  onTrueGotoStep: number | undefined;
  onTrueRetryCount: number | undefined;
  onTrueRetryDelayMs: number | undefined;
  onTrueComment: string;
  onFalseAction: ConditionalBranch['action'];
  onFalseGotoStep: number | undefined;
  onFalseRetryCount: number | undefined;
  onFalseRetryDelayMs: number | undefined;
  onFalseComment: string;
  cursor: number;
}

export function createDefaultConditionalState(): ConditionalEditorState {
  return {
    editingSection: 'condition',
    editingField: null,
    conditionType: 'element-exists',
    conditionTarget: '',
    conditionDescription: '',
    cdpCommand: '',
    onTrueAction: 'continue',
    onTrueGotoStep: undefined,
    onTrueRetryCount: undefined,
    onTrueRetryDelayMs: undefined,
    onTrueComment: '',
    onFalseAction: 'continue',
    onFalseGotoStep: undefined,
    onFalseRetryCount: undefined,
    onFalseRetryDelayMs: undefined,
    onFalseComment: '',
    cursor: 0,
  };
}

export function loadConditionalState(conditional: ConditionalLogic | undefined): ConditionalEditorState {
  if (!conditional) return createDefaultConditionalState();
  
  return {
    editingSection: 'condition',
    editingField: null,
    conditionType: conditional.condition.type,
    conditionTarget: conditional.condition.target || '',
    conditionDescription: conditional.condition.description,
    cdpCommand: conditional.condition.cdpCommand || '',
    onTrueAction: conditional.onTrue.action,
    onTrueGotoStep: conditional.onTrue.gotoStep,
    onTrueRetryCount: conditional.onTrue.retryCount,
    onTrueRetryDelayMs: conditional.onTrue.retryDelayMs,
    onTrueComment: conditional.onTrue.comment || '',
    onFalseAction: conditional.onFalse.action,
    onFalseGotoStep: conditional.onFalse.gotoStep,
    onFalseRetryCount: conditional.onFalse.retryCount,
    onFalseRetryDelayMs: conditional.onFalse.retryDelayMs,
    onFalseComment: conditional.onFalse.comment || '',
    cursor: 0,
  };
}

export function buildConditionalLogic(state: ConditionalEditorState): ConditionalLogic {
  const condition: ConditionCheck = {
    type: state.conditionType,
    description: state.conditionDescription,
  };
  
  if (state.conditionTarget) condition.target = state.conditionTarget;
  if (state.cdpCommand) condition.cdpCommand = state.cdpCommand;
  
  const onTrue: ConditionalBranch = {
    action: state.onTrueAction,
  };
  if (state.onTrueGotoStep) onTrue.gotoStep = state.onTrueGotoStep;
  if (state.onTrueRetryCount) onTrue.retryCount = state.onTrueRetryCount;
  if (state.onTrueRetryDelayMs) onTrue.retryDelayMs = state.onTrueRetryDelayMs;
  if (state.onTrueComment) onTrue.comment = state.onTrueComment;
  
  const onFalse: ConditionalBranch = {
    action: state.onFalseAction,
  };
  if (state.onFalseGotoStep) onFalse.gotoStep = state.onFalseGotoStep;
  if (state.onFalseRetryCount) onFalse.retryCount = state.onFalseRetryCount;
  if (state.onFalseRetryDelayMs) onFalse.retryDelayMs = state.onFalseRetryDelayMs;
  if (state.onFalseComment) onFalse.comment = state.onFalseComment;
  
  return { condition, onTrue, onFalse };
}

export function renderConditionalEditor(
  state: ConditionalEditorState,
  rows: number,
  cols: number,
  editingField: boolean,
  editBuffer: string
): string {
  let out = '';
  const contentWidth = Math.min(cols - 4, 120);
  const leftMargin = Math.floor((cols - contentWidth) / 2);
  
  let row = 3;
  
  // Title
  out += moveTo(row++, leftMargin) + c.cyan + c.bold + 'Conditional Logic Editor' + c.reset;
  out += moveTo(row++, leftMargin) + c.dim + 'Define if-then-else error handling logic' + c.reset;
  row++;
  
  // Instructions
  out += moveTo(row++, leftMargin) + c.yellow + 'Tab' + c.reset + '=Switch Section  ' + 
         c.yellow + 'Enter' + c.reset + '=Edit Field  ' +
         c.yellow + 'Ctrl+S' + c.reset + '=Save  ' +
         c.yellow + 'Ctrl+D' + c.reset + '=Delete  ' +
         c.yellow + 'Esc' + c.reset + '=Cancel';
  row++;
  
  // Condition Section
  out += renderConditionSection(state, row, leftMargin, contentWidth, editingField, editBuffer, state.cursor);
  row += 8;
  
  // OnTrue Section
  out += renderBranchSection('TRUE', state, row, leftMargin, contentWidth, editingField, editBuffer, state.cursor, true);
  row += 7;
  
  // OnFalse Section
  out += renderBranchSection('FALSE', state, row, leftMargin, contentWidth, editingField, editBuffer, state.cursor, false);
  row += 7;
  
  // Preview
  out += moveTo(row++, leftMargin) + c.dim + '─'.repeat(contentWidth) + c.reset;
  out += moveTo(row++, leftMargin) + c.cyan + 'Preview:' + c.reset;
  out += renderConditionalPreview(state, row, leftMargin);
  
  return out;
}

function renderConditionSection(
  state: ConditionalEditorState,
  startRow: number,
  leftMargin: number,
  width: number,
  editingField: boolean,
  editBuffer: string,
  cursor: number
): string {
  let out = '';
  let row = startRow;
  const fieldStart = 0;
  
  out += moveTo(row++, leftMargin) + c.green + c.bold + '▶ CONDITION' + c.reset + c.dim + ' (what to check)' + c.reset;
  
  const fields = [
    { id: 0, label: 'Type', value: state.conditionType, field: 'conditionType' },
    { id: 1, label: 'Target', value: state.conditionTarget, field: 'conditionTarget' },
    { id: 2, label: 'CDP Cmd', value: state.cdpCommand, field: 'cdpCommand' },
    { id: 3, label: 'Description', value: state.conditionDescription, field: 'conditionDescription' },
  ];
  
  for (const f of fields) {
    const selected = cursor === f.id;
    const editing = editingField && selected;
    const display = editing ? editBuffer : (f.value || c.dim + '(empty)' + c.reset);
    const prefix = selected ? c.yellow + '→ ' + c.reset : '  ';
    
    out += moveTo(row++, leftMargin) + prefix + c.cyan + pad(f.label, 12) + c.reset + ': ' + display;
  }
  
  return out;
}

function renderBranchSection(
  branchName: string,
  state: ConditionalEditorState,
  startRow: number,
  leftMargin: number,
  width: number,
  editingField: boolean,
  editBuffer: string,
  cursor: number,
  isTrue: boolean
): string {
  let out = '';
  let row = startRow;
  const fieldOffset = isTrue ? 4 : 9;
  
  const color = isTrue ? c.green : c.red;
  out += moveTo(row++, leftMargin) + color + c.bold + `▶ ON ${branchName}` + c.reset + c.dim + ' (what to do)' + c.reset;
  
  const action = isTrue ? state.onTrueAction : state.onFalseAction;
  const gotoStep = isTrue ? state.onTrueGotoStep : state.onFalseGotoStep;
  const retryCount = isTrue ? state.onTrueRetryCount : state.onFalseRetryCount;
  const retryDelayMs = isTrue ? state.onTrueRetryDelayMs : state.onFalseRetryDelayMs;
  const comment = isTrue ? state.onTrueComment : state.onFalseComment;
  
  const fields = [
    { id: fieldOffset + 0, label: 'Action', value: action, field: isTrue ? 'onTrueAction' : 'onFalseAction' },
    { id: fieldOffset + 1, label: 'Goto Step', value: gotoStep?.toString() || '', field: isTrue ? 'onTrueGotoStep' : 'onFalseGotoStep' },
    { id: fieldOffset + 2, label: 'Retry Count', value: retryCount?.toString() || '', field: isTrue ? 'onTrueRetryCount' : 'onFalseRetryCount' },
    { id: fieldOffset + 3, label: 'Retry Delay', value: retryDelayMs?.toString() || '', field: isTrue ? 'onTrueRetryDelayMs' : 'onFalseRetryDelayMs' },
    { id: fieldOffset + 4, label: 'Comment', value: comment, field: isTrue ? 'onTrueComment' : 'onFalseComment' },
  ];
  
  for (const f of fields) {
    const selected = cursor === f.id;
    const editing = editingField && selected;
    const display = editing ? editBuffer : (f.value || c.dim + '(empty)' + c.reset);
    const prefix = selected ? c.yellow + '→ ' + c.reset : '  ';
    
    out += moveTo(row++, leftMargin) + prefix + c.cyan + pad(f.label, 12) + c.reset + ': ' + display;
  }
  
  return out;
}

function renderConditionalPreview(state: ConditionalEditorState, startRow: number, leftMargin: number): string {
  let out = '';
  let row = startRow;
  
  out += moveTo(row++, leftMargin + 2) + c.white + 'IF ' + c.reset + state.conditionDescription;
  out += moveTo(row++, leftMargin + 4) + c.green + 'THEN ' + c.reset + formatBranchPreview(state, true);
  out += moveTo(row++, leftMargin + 4) + c.red + 'ELSE ' + c.reset + formatBranchPreview(state, false);
  
  return out;
}

function formatBranchPreview(state: ConditionalEditorState, isTrue: boolean): string {
  const action = isTrue ? state.onTrueAction : state.onFalseAction;
  const gotoStep = isTrue ? state.onTrueGotoStep : state.onFalseGotoStep;
  const retryCount = isTrue ? state.onTrueRetryCount : state.onFalseRetryCount;
  const retryDelayMs = isTrue ? state.onTrueRetryDelayMs : state.onFalseRetryDelayMs;
  const comment = isTrue ? state.onTrueComment : state.onFalseComment;
  
  switch (action) {
    case 'continue':
      return `continue to next step${comment ? ` (${comment})` : ''}`;
    case 'goto':
      return `goto step ${gotoStep || '?'}${comment ? ` (${comment})` : ''}`;
    case 'retry':
      return `retry ${retryCount || '?'} times with ${retryDelayMs || '?'}ms delay${comment ? ` (${comment})` : ''}`;
    case 'abort':
      return `abort workflow${comment ? ` (${comment})` : ''}`;
    default:
      return action;
  }
}

export const CONDITION_TYPES: ConditionCheck['type'][] = [
  'element-exists',
  'element-missing',
  'text-contains',
  'cdp-check',
  'tool-success',
  'tool-failure',
  'custom-js',
];

export const BRANCH_ACTIONS: ConditionalBranch['action'][] = [
  'continue',
  'goto',
  'retry',
  'abort',
];
