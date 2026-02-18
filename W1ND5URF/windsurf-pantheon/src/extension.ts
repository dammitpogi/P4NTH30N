import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';
import * as os from 'os';
import { DecisionsProvider, Decision } from './decisionsProvider';

let isEnabled = true;
let debounceTimer: ReturnType<typeof setTimeout> | undefined;
let statusBarItem: vscode.StatusBarItem;

// Track editor activity for auto-close feature
const editorActivityMap = new Map<string, number>();
let cleanupTimer: ReturnType<typeof setTimeout> | undefined;

// Hook integration
let hookWatcher: fs.FSWatcher | undefined;
const HOOK_SIGNAL_FILE = path.join(os.tmpdir(), 'windsurf-follower-target.json');
const DECISIONS_FILE = path.join(os.tmpdir(), 'windsurf-follower-decisions.json');
const MCP_DECISIONS_FILE = path.join(os.tmpdir(), 'windsurf-follower-mcp-decisions.json');

// Webview panel for decisions visibility
let decisionsPanel: vscode.WebviewPanel | undefined;

// Store for latest data
let latestCascadeData: any = null;
let latestMcpData: any = null;

// Tree view provider
let decisionsProvider: DecisionsProvider;

export function activate(context: vscode.ExtensionContext) {
  const config = vscode.workspace.getConfiguration('windsurfFollower');
  isEnabled = config.get('enabled', true);

  // Set context for view visibility
  vscode.commands.executeCommand('setContext', 'windsurfFollower.contextEnabled', isEnabled);

  // Create status bar item
  statusBarItem = vscode.window.createStatusBarItem(
    vscode.StatusBarAlignment.Right,
    100,
  );
  statusBarItem.command = 'windsurfFollower.toggle';
  updateStatusBar();
  statusBarItem.show();

  const disposable =
    vscode.workspace.onDidChangeTextDocument(handleDocumentChange);

  const enableCmd = vscode.commands.registerCommand(
    'windsurfFollower.enable',
    () => {
      setEnabled(true);
    },
  );

  const disableCmd = vscode.commands.registerCommand(
    'windsurfFollower.disable',
    () => {
      setEnabled(false);
    },
  );

  const toggleCmd = vscode.commands.registerCommand(
    'windsurfFollower.toggle',
    () => {
      setEnabled(!isEnabled);
    },
  );

	// Set up hook file watchers
	setupHookWatcher();
	setupDecisionsWatcher();

	// Register command to show decisions panel
	const showDecisionsCmd = vscode.commands.registerCommand(
		'windsurfFollower.showDecisions',
		() => {
			showDecisionsPanel();
		},
	);

	// Create and register the TreeView for Decisions
	decisionsProvider = new DecisionsProvider();
	const treeView = vscode.window.createTreeView('windsurfFollowerDecisionsView', {
		treeDataProvider: decisionsProvider,
		showCollapseAll: true
	});

	context.subscriptions.push(
		treeView,
		disposable,
		enableCmd,
		disableCmd,
		toggleCmd,
		showDecisionsCmd,
		statusBarItem,
	);
}

function setEnabled(enabled: boolean) {
  isEnabled = enabled;
  vscode.commands.executeCommand('setContext', 'windsurfFollower.contextEnabled', isEnabled);
  updateStatusBar();
  vscode.window.showInformationMessage(
    `Windsurf Follower ${isEnabled ? 'enabled' : 'disabled'}`,
  );
}

function updateStatusBar() {
  if (isEnabled) {
    statusBarItem.text = '$(eye) Windsurf';
    statusBarItem.tooltip = 'Windsurf Follower is ON - Click to disable';
    statusBarItem.backgroundColor = undefined;
  } else {
    statusBarItem.text = '$(eye-closed) Windsurf';
    statusBarItem.tooltip = 'Windsurf Follower is OFF - Click to enable';
    statusBarItem.backgroundColor = new vscode.ThemeColor(
      'statusBarItem.warningBackground',
    );
  }
}

function handleDocumentChange(event: vscode.TextDocumentChangeEvent) {
  if (!isEnabled) {
    return;
  }

  const config = vscode.workspace.getConfiguration('windsurfFollower');
  const followExternal = config.get('followExternalChanges', true);
  const followSelf = config.get('followSelfChanges', false);
  const debounceMs = config.get('debounceMs', 100);
  const focusPane = config.get('focusPane', true);
  const autoClose = config.get('autoCloseInactivePanes', true);
  const maxOpenEditors = config.get('maxOpenEditors', 5);

  if (!followExternal && !followSelf) {
    return;
  }

  if (event.contentChanges.length === 0) {
    return;
  }

  const lastChange = event.contentChanges[event.contentChanges.length - 1];
  const changeLine = lastChange.range.start.line;

  // Track this document's activity
  const docUri = event.document.uri.toString();
  editorActivityMap.set(docUri, Date.now());

  if (debounceTimer) {
    clearTimeout(debounceTimer);
  }

  debounceTimer = setTimeout(async () => {
    // Find or show the editor for this document
    let targetEditor = findEditorForDocument(event.document);

    if (!targetEditor && focusPane) {
      // Show the document in an editor if not already visible
      targetEditor = await showTextDocument(event.document);
    }

    if (targetEditor) {
      centerViewOnLine(targetEditor, changeLine);

      // Schedule cleanup of old panes if enabled
      if (autoClose) {
        schedulePaneCleanup(maxOpenEditors);
      }
    }
  }, debounceMs);
}

function centerViewOnLine(editor: vscode.TextEditor, line: number) {
  const range = new vscode.Range(line, 0, line, 0);
  editor.revealRange(range, vscode.TextEditorRevealType.InCenter);
}

function findEditorForDocument(document: vscode.TextDocument): vscode.TextEditor | undefined {
  return vscode.window.visibleTextEditors.find(
    editor => editor.document.uri.toString() === document.uri.toString()
  );
}

async function showTextDocument(document: vscode.TextDocument): Promise<vscode.TextEditor | undefined> {
  try {
    // Show the document in the active column or beside if needed
    const viewColumn = vscode.window.activeTextEditor?.viewColumn || vscode.ViewColumn.One;
    return await vscode.window.showTextDocument(document, viewColumn, false);
  } catch (error) {
    console.error('Failed to show text document:', error);
    return undefined;
  }
}

function schedulePaneCleanup(maxEditors: number) {
  if (cleanupTimer) {
    clearTimeout(cleanupTimer);
  }

  // Wait a bit before cleaning up to allow multiple rapid changes
  cleanupTimer = setTimeout(() => {
    cleanupInactivePanes(maxEditors);
  }, 2000);
}

async function cleanupInactivePanes(maxEditors: number) {
  const visibleEditors = vscode.window.visibleTextEditors;

  if (visibleEditors.length <= maxEditors) {
    return;
  }

  // Sort editors by last activity time (oldest first)
  const editorsWithActivity = visibleEditors
    .map(editor => ({
      editor,
      lastActivity: editorActivityMap.get(editor.document.uri.toString()) || 0
    }))
    .sort((a, b) => a.lastActivity - b.lastActivity);

  // Close oldest editors until we're at the limit
  const editorsToClose = editorsWithActivity.slice(0, editorsWithActivity.length - maxEditors);

  for (const { editor } of editorsToClose) {
    // Don't close the active editor
    if (editor === vscode.window.activeTextEditor) {
      continue;
    }

    // Don't close dirty (unsaved) documents
    if (editor.document.isDirty) {
      continue;
    }

    try {
      await vscode.commands.executeCommand(
        'workbench.action.closeActiveEditor',
        editor
      );
    } catch (error) {
      console.error('Failed to close editor:', error);
    }
  }
}

function setupHookWatcher() {
	// Clean up any existing watcher
	if (hookWatcher) {
		hookWatcher.close();
	}

	// Watch for hook signal file
	try {
		hookWatcher = fs.watch(HOOK_SIGNAL_FILE, async (eventType) => {
			if (eventType === 'change' || eventType === 'rename') {
				await handleHookSignal();
			}
		});

		// Also poll as fallback (some systems don't trigger watch reliably)
		setInterval(async () => {
			if (fs.existsSync(HOOK_SIGNAL_FILE)) {
				const stats = fs.statSync(HOOK_SIGNAL_FILE);
				const age = Date.now() - stats.mtimeMs;
				// Only process if file is less than 500ms old
				if (age < 500) {
					await handleHookSignal();
				}
			}
		}, 100);
	} catch (error) {
		console.error('Failed to set up hook watcher:', error);
	}
}

async function handleHookSignal() {
	if (!isEnabled) {
		return;
	}

	try {
		if (!fs.existsSync(HOOK_SIGNAL_FILE)) {
			return;
		}

		const data = JSON.parse(fs.readFileSync(HOOK_SIGNAL_FILE, 'utf8'));
		const { filePath, line, timestamp } = data;

		// Only process recent signals (within last 2 seconds)
		if (Date.now() - timestamp > 2000) {
			return;
		}

		if (!filePath) {
			return;
		}

		// Open and focus the file
		const document = await vscode.workspace.openTextDocument(filePath);
		const editor = await vscode.window.showTextDocument(document, {
			viewColumn: vscode.window.activeTextEditor?.viewColumn || vscode.ViewColumn.One,
			preserveFocus: false, // This ensures it gets focused
			preview: false // Open as permanent tab, not preview
		});

		// Center on the line if specified
		if (line !== undefined && line >= 0) {
		centerViewOnLine(editor, line);
	}

	// Track activity for auto-close
	editorActivityMap.set(document.uri.toString(), Date.now());

		// Clean up the signal file
		try {
			fs.unlinkSync(HOOK_SIGNAL_FILE);
		} catch {
			// Ignore cleanup errors
		}
	} catch (error) {
		console.error('Hook signal handling error:', error);
	}
}

function setupDecisionsWatcher() {
	// Poll for decisions files (more reliable than watch for this use case)
	setInterval(async () => {
		let updated = false;
		
		// Check Cascade response file
		if (fs.existsSync(DECISIONS_FILE)) {
			try {
				const stats = fs.statSync(DECISIONS_FILE);
				const age = Date.now() - stats.mtimeMs;
				if (age < 2000) {
					const data = JSON.parse(fs.readFileSync(DECISIONS_FILE, 'utf8'));
					latestCascadeData = data;
					updated = true;
					fs.unlinkSync(DECISIONS_FILE);
				}
			} catch {
				// Ignore errors
			}
		}
		
		// Check MCP decisions file
		if (fs.existsSync(MCP_DECISIONS_FILE)) {
			try {
				const stats = fs.statSync(MCP_DECISIONS_FILE);
				const age = Date.now() - stats.mtimeMs;
				if (age < 2000) {
					const data = JSON.parse(fs.readFileSync(MCP_DECISIONS_FILE, 'utf8'));
					latestMcpData = data;
					updated = true;
					
					// Add to TreeView if it's a decisions tool interaction
					if (data.isDecisionsTool && decisionsProvider) {
						decisionsProvider.addMcpInteraction(data);
						
						// Also try to parse decision data from result
						if (data.result) {
							try {
								const result = typeof data.result === 'string' 
									? JSON.parse(data.result) 
									: data.result;
								
								if (result && (result.Id || result.id)) {
									const decision: Decision = {
										id: result.Id || result.id,
										type: result.Type || result.type || 'Unknown',
										confidence: result.Confidence || result.confidence || 0,
										timestamp: Date.now(),
										targetHouse: result.TargetHouse || result.targetHouse,
										targetGame: result.TargetGame || result.targetGame,
										targetUsername: result.TargetUsername || result.targetUsername,
										rationale: result.Rationale || result.rationale,
										executed: result.Executed || result.executed,
										executedAt: result.ExecutedAt || result.executedAt
									};
									decisionsProvider.addDecision(decision);
								}
							} catch (e) {
								// Failed to parse result as decision
							}
						}
					}
					
					fs.unlinkSync(MCP_DECISIONS_FILE);
				}
			} catch {
				// Ignore errors
			}
		}
		
		// Update panel if we have new data
		if (updated && decisionsPanel) {
			decisionsPanel.webview.html = getCombinedDecisionsHtml();
		}
	}, 200);
}

function getCombinedDecisionsHtml(): string {
	const data = latestCascadeData;
	const mcpData = latestMcpData;
	
	if (!data && !mcpData) {
		return getDecisionsHtml(null);
	}
	
	const summary = data?.summary || {};
	const plannerResponses = summary.plannerResponses || [];
	const triggeredRules = summary.triggeredRules || [];
	const fileReads = summary.fileReads || [];
	const fileWrites = summary.fileWrites || [];
	const commands = summary.commands || [];
	
	// MCP Decisions section
	const mcpSection = mcpData ? `
		<div class="section mcp-section">
			<div class="section-title">🎯 Decisions Tool (MCP)</div>
			<div class="mcp-details">
				<div class="mcp-header">
					<span class="mcp-server">${escapeHtml(mcpData.serverName)}</span>
					<span class="mcp-tool">${escapeHtml(mcpData.toolName)}</span>
				</div>
				${mcpData.arguments && Object.keys(mcpData.arguments).length > 0 ? `
					<div class="mcp-args">
						<div class="args-title">Arguments:</div>
						<pre>${escapeHtml(JSON.stringify(mcpData.arguments, null, 2))}</pre>
					</div>
				` : ''}
				${mcpData.result ? `
					<div class="mcp-result">
						<div class="result-title">Result:</div>
						<pre>${escapeHtml(typeof mcpData.result === 'string' ? mcpData.result : JSON.stringify(mcpData.result, null, 2))}</pre>
					</div>
				` : ''}
			</div>
			<div class="mcp-timestamp">${new Date(mcpData.timestamp).toLocaleTimeString()}</div>
		</div>
	` : '';

	return `<!DOCTYPE html>
	<html>
	<head>
		<style>
			body { 
				font-family: var(--vscode-font-family); 
				padding: 20px; 
				color: var(--vscode-foreground);
				line-height: 1.6;
			}
			.header { 
				font-size: 18px; 
				font-weight: bold; 
				margin-bottom: 10px;
				padding-bottom: 10px;
				border-bottom: 1px solid var(--vscode-panel-border);
			}
			.timestamp {
				color: var(--vscode-descriptionForeground);
				font-size: 12px;
				margin-bottom: 20px;
			}
			.section {
				margin: 20px 0;
				padding: 15px;
				background: var(--vscode-editor-inactiveSelectionBackground);
				border-radius: 6px;
			}
			.section.mcp-section {
				background: var(--vscode-charts-purple);
				background-opacity: 0.1;
				border: 1px solid var(--vscode-charts-purple);
			}
			.section-title {
				font-weight: bold;
				margin-bottom: 10px;
				color: var(--vscode-symbolIcon-classForeground);
			}
			.mcp-section .section-title {
				color: var(--vscode-charts-purple);
			}
			.planner-response {
				background: var(--vscode-editor-background);
				padding: 12px;
				border-radius: 4px;
				margin: 10px 0;
				border-left: 3px solid var(--vscode-charts-blue);
				white-space: pre-wrap;
			}
			.rule-item {
				padding: 6px 10px;
				margin: 4px 0;
				background: var(--vscode-editor-background);
				border-radius: 3px;
				font-size: 13px;
			}
			.rule-type {
				display: inline-block;
				padding: 2px 6px;
				border-radius: 3px;
				font-size: 11px;
				margin-right: 8px;
				background: var(--vscode-badge-background);
				color: var(--vscode-badge-foreground);
			}
			.action-item {
				padding: 4px 0;
				font-family: var(--vscode-editor-font-family);
				font-size: 13px;
			}
			.action-icon {
				display: inline-block;
				width: 20px;
				text-align: center;
				margin-right: 8px;
			}
			.read { color: var(--vscode-charts-blue); }
			.write { color: var(--vscode-charts-green); }
			.command { color: var(--vscode-charts-yellow); }
			.empty-state {
				color: var(--vscode-descriptionForeground);
				font-style: italic;
				text-align: center;
				padding: 20px;
			}
			.trajectory-id {
				font-size: 11px;
				color: var(--vscode-descriptionForeground);
				text-align: right;
				margin-top: 30px;
				padding-top: 10px;
				border-top: 1px solid var(--vscode-panel-border);
			}
			.mcp-header {
				margin-bottom: 10px;
			}
			.mcp-server {
				font-weight: bold;
				color: var(--vscode-charts-purple);
			}
			.mcp-tool {
				display: inline-block;
				margin-left: 10px;
				padding: 2px 8px;
				background: var(--vscode-badge-background);
				border-radius: 3px;
				font-size: 12px;
			}
			.mcp-args, .mcp-result {
				margin-top: 10px;
				padding: 10px;
				background: var(--vscode-editor-background);
				border-radius: 4px;
			}
			.args-title, .result-title {
				font-size: 11px;
				font-weight: bold;
				color: var(--vscode-descriptionForeground);
				margin-bottom: 5px;
			}
			.mcp-args pre, .mcp-result pre {
				margin: 0;
				font-size: 12px;
				overflow-x: auto;
			}
			.mcp-timestamp {
				font-size: 11px;
				color: var(--vscode-descriptionForeground);
				text-align: right;
				margin-top: 10px;
			}
		</style>
	</head>
	<body>
		<div class="header">WindSurf Cascade Decisions</div>
		${data ? `<div class="timestamp">${new Date(data.timestamp).toLocaleString()}</div>` : ''}
		
		${mcpSection}
		
		${plannerResponses.length > 0 ? `
		<div class="section">
			<div class="section-title">Thinking</div>
			${plannerResponses.map((r: string) => `<div class="planner-response">${escapeHtml(r)}</div>`).join('')}
		</div>
		` : ''}
		
		${triggeredRules.length > 0 ? `
		<div class="section">
			<div class="section-title">Triggered Rules</div>
			${triggeredRules.map((r: {type: string, rule: string}) => `
				<div class="rule-item">
					<span class="rule-type">${escapeHtml(r.type)}</span>
					${escapeHtml(r.rule)}
				</div>
			`).join('')}
		</div>
		` : ''}
		
		${fileReads.length > 0 ? `
		<div class="section">
			<div class="section-title">Files Read</div>
			${fileReads.map((f: string) => `<div class="action-item"><span class="action-icon read">📖</span>${escapeHtml(f)}</div>`).join('')}
		</div>
		` : ''}
		
		${fileWrites.length > 0 ? `
		<div class="section">
			<div class="section-title">Files Modified</div>
			${fileWrites.map((f: string) => `<div class="action-item"><span class="action-icon write">✏️</span>${escapeHtml(f)}</div>`).join('')}
		</div>
		` : ''}
		
		${commands.length > 0 ? `
		<div class="section">
			<div class="section-title">Commands Executed</div>
			${commands.map((c: string) => `<div class="action-item"><span class="action-icon command">⚡</span><code>${escapeHtml(c)}</code></div>`).join('')}
		</div>
		` : ''}
		
		${!plannerResponses.length && !triggeredRules.length && !fileReads.length && !fileWrites.length && !commands.length && !mcpData ? `
		<div class="empty-state">
			No actions recorded in this response.
		</div>
		` : ''}
		
		${data ? `<div class="trajectory-id">Trajectory: ${data.trajectoryId || 'unknown'}</div>` : ''}
	</body>
	</html>`;
}

function showDecisionsPanel() {
	if (decisionsPanel) {
		decisionsPanel.reveal(vscode.ViewColumn.Beside);
		return;
	}

	decisionsPanel = vscode.window.createWebviewPanel(
		'windsurfFollowerDecisions',
		'WindSurf Decisions',
		vscode.ViewColumn.Beside,
		{
			enableScripts: true,
			retainContextWhenHidden: true
		}
	);

	decisionsPanel.onDidDispose(() => {
		decisionsPanel = undefined;
	});

	decisionsPanel.webview.html = getDecisionsHtml(null);
}

function getDecisionsHtml(data: any): string {
	if (!data) {
		return `<!DOCTYPE html>
		<html>
		<head>
			<style>
				body { font-family: var(--vscode-font-family); padding: 20px; color: var(--vscode-foreground); }
				.header { font-size: 18px; font-weight: bold; margin-bottom: 20px; }
				.waiting { color: var(--vscode-descriptionForeground); font-style: italic; }
			</style>
		</head>
		<body>
			<div class="header">WindSurf Cascade Decisions</div>
			<div class="waiting">Waiting for Cascade to respond...</div>
			<p style="color: var(--vscode-descriptionForeground); font-size: 12px; margin-top: 40px;">
				This panel shows Cascade's planner responses, triggered rules, and actions in real-time.
			</p>
		</body>
		</html>`;
	}

	const summary = data.summary || {};
	const plannerResponses = summary.plannerResponses || [];
	const triggeredRules = summary.triggeredRules || [];
	const fileReads = summary.fileReads || [];
	const fileWrites = summary.fileWrites || [];
	const commands = summary.commands || [];

	return `<!DOCTYPE html>
	<html>
	<head>
		<style>
			body { 
				font-family: var(--vscode-font-family); 
				padding: 20px; 
				color: var(--vscode-foreground);
				line-height: 1.6;
			}
			.header { 
				font-size: 18px; 
				font-weight: bold; 
				margin-bottom: 10px;
				padding-bottom: 10px;
				border-bottom: 1px solid var(--vscode-panel-border);
			}
			.timestamp {
				color: var(--vscode-descriptionForeground);
				font-size: 12px;
				margin-bottom: 20px;
			}
			.section {
				margin: 20px 0;
				padding: 15px;
				background: var(--vscode-editor-inactiveSelectionBackground);
				border-radius: 6px;
			}
			.section-title {
				font-weight: bold;
				margin-bottom: 10px;
				color: var(--vscode-symbolIcon-classForeground);
			}
			.planner-response {
				background: var(--vscode-editor-background);
				padding: 12px;
				border-radius: 4px;
				margin: 10px 0;
				border-left: 3px solid var(--vscode-charts-blue);
				white-space: pre-wrap;
			}
			.rule-item {
				padding: 6px 10px;
				margin: 4px 0;
				background: var(--vscode-editor-background);
				border-radius: 3px;
				font-size: 13px;
			}
			.rule-type {
				display: inline-block;
				padding: 2px 6px;
				border-radius: 3px;
				font-size: 11px;
				margin-right: 8px;
				background: var(--vscode-badge-background);
				color: var(--vscode-badge-foreground);
			}
			.action-item {
				padding: 4px 0;
				font-family: var(--vscode-editor-font-family);
				font-size: 13px;
			}
			.action-icon {
				display: inline-block;
				width: 20px;
				text-align: center;
				margin-right: 8px;
			}
			.read { color: var(--vscode-charts-blue); }
			.write { color: var(--vscode-charts-green); }
			.command { color: var(--vscode-charts-yellow); }
			.empty-state {
				color: var(--vscode-descriptionForeground);
				font-style: italic;
				text-align: center;
				padding: 20px;
			}
			.trajectory-id {
				font-size: 11px;
				color: var(--vscode-descriptionForeground);
				text-align: right;
				margin-top: 30px;
				padding-top: 10px;
				border-top: 1px solid var(--vscode-panel-border);
			}
		</style>
	</head>
	<body>
		<div class="header">WindSurf Cascade Decisions</div>
		<div class="timestamp">${new Date(data.timestamp).toLocaleString()}</div>
		
		${plannerResponses.length > 0 ? `
		<div class="section">
			<div class="section-title">Thinking</div>
			${plannerResponses.map((r: string) => `<div class="planner-response">${escapeHtml(r)}</div>`).join('')}
		</div>
		` : ''}
		
		${triggeredRules.length > 0 ? `
		<div class="section">
			<div class="section-title">Triggered Rules</div>
			${triggeredRules.map((r: {type: string, rule: string}) => `
				<div class="rule-item">
					<span class="rule-type">${escapeHtml(r.type)}</span>
					${escapeHtml(r.rule)}
				</div>
			`).join('')}
		</div>
		` : ''}
		
		${fileReads.length > 0 ? `
		<div class="section">
			<div class="section-title">Files Read</div>
			${fileReads.map((f: string) => `<div class="action-item"><span class="action-icon read">📖</span>${escapeHtml(f)}</div>`).join('')}
		</div>
		` : ''}
		
		${fileWrites.length > 0 ? `
		<div class="section">
			<div class="section-title">Files Modified</div>
			${fileWrites.map((f: string) => `<div class="action-item"><span class="action-icon write">✏️</span>${escapeHtml(f)}</div>`).join('')}
		</div>
		` : ''}
		
		${commands.length > 0 ? `
		<div class="section">
			<div class="section-title">Commands Executed</div>
			${commands.map((c: string) => `<div class="action-item"><span class="action-icon command">⚡</span><code>${escapeHtml(c)}</code></div>`).join('')}
		</div>
		` : ''}
		
		${!plannerResponses.length && !triggeredRules.length && !fileReads.length && !fileWrites.length && !commands.length ? `
		<div class="empty-state">
			No actions recorded in this response.
		</div>
		` : ''}
		
		<div class="trajectory-id">Trajectory: ${data.trajectoryId || 'unknown'}</div>
	</body>
	</html>`;
}

function escapeHtml(text: string): string {
	if (!text) return '';
	return text
		.replace(/&/g, '&amp;')
		.replace(/</g, '&lt;')
		.replace(/>/g, '&gt;')
		.replace(/"/g, '&quot;')
		.replace(/'/g, '&#039;');
}

export function deactivate() {
	if (debounceTimer) {
		clearTimeout(debounceTimer);
	}
	if (cleanupTimer) {
		clearTimeout(cleanupTimer);
	}
	if (hookWatcher) {
		hookWatcher.close();
	}
	editorActivityMap.clear();
}
