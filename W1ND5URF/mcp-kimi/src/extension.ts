import * as vscode from 'vscode';
import * as path from 'path';
import * as fs from 'fs';

interface CartographyConfig {
    metadata: {
        version: string;
        last_run: string;
        root: string;
        include_patterns: string[];
        exclude_patterns: string[];
        exceptions: string[];
    };
    file_hashes: Record<string, string>;
    folder_hashes: Record<string, string>;
}

interface AgentsContext {
    workspaceRoot: string;
    relativePath: string;
    agentsPath: string | null;
    content: string | null;
}

export function activate(context: vscode.ExtensionContext) {
    console.log('Windsurf AGENTS extension is now active');

    const cartographyService = new CartographyService();
    
    // Register commands
    const refreshCommand = vscode.commands.registerCommand(
        'windsurf-cartography.refresh',
        () => cartographyService.refreshContext()
    );
    
    const showCurrentCommand = vscode.commands.registerCommand(
        'windsurf-cartography.showCurrent',
        () => cartographyService.showCurrentAgents()
    );
    
    const toggleCommand = vscode.commands.registerCommand(
        'windsurf-cartography.toggle',
        () => cartographyService.toggleAutoInjection()
    );

    // Watch for active editor changes
    const editorChangeDisposable = vscode.window.onDidChangeActiveTextEditor(
        (editor) => {
            if (editor) {
                cartographyService.handleEditorChange(editor);
            }
        }
    );

    // Watch for configuration changes
    const configChangeDisposable = vscode.workspace.onDidChangeConfiguration(
        (event) => {
            if (event.affectsConfiguration('windsurfCartography')) {
                cartographyService.reloadConfiguration();
            }
        }
    );

    const configureKimiCommand = vscode.commands.registerCommand(
        'windsurf-cartography.configureKimi',
        () => configureKimiBYOK()
    );

    context.subscriptions.push(
        refreshCommand,
        showCurrentCommand,
        toggleCommand,
        configureKimiCommand,
        editorChangeDisposable,
        configChangeDisposable
    );

    // Initialize with current editor
    if (vscode.window.activeTextEditor) {
        cartographyService.handleEditorChange(vscode.window.activeTextEditor);
    }
}

async function configureKimiBYOK(): Promise<void> {
    const apiKey = await vscode.window.showInputBox({
        prompt: 'Enter your Kimi API Key',
        password: true,
        placeHolder: 'sk-kimi-...',
        ignoreFocusOut: true
    });
    
    if (!apiKey) {
        vscode.window.showWarningMessage('Kimi BYOK configuration cancelled');
        return;
    }
    
    try {
        // Get user settings.json path
        const userSettingsPath = vscode.Uri.file(
            path.join(process.env.USERPROFILE || process.env.HOME || '', '.windsurf', 'settings.json')
        );
        
        // Read existing settings
        let settings: any = {};
        try {
            const content = await vscode.workspace.fs.readFile(userSettingsPath);
            settings = JSON.parse(Buffer.from(content).toString('utf8'));
        } catch {
            // File doesn't exist or is empty, start fresh
        }
        
        // Add Kimi BYOK configuration
        settings['windsurf.byok.providers'] = [
            {
                name: 'Kimi',
                baseUrl: 'https://api.kimi.com/coding/v1',
                apiKey: apiKey,
                models: ['kimi-k2'],
                defaultModel: 'kimi-k2'
            }
        ];
        
        // Write back to settings
        const updatedContent = Buffer.from(JSON.stringify(settings, null, 4), 'utf8');
        await vscode.workspace.fs.writeFile(userSettingsPath, updatedContent);
        
        vscode.window.showInformationMessage(
            'Kimi BYOK configured successfully! Select "Kimi" from the model dropdown in Cascade after restarting Windsurf.',
            'Restart Windsurf'
        ).then(selection => {
            if (selection === 'Restart Windsurf') {
                vscode.commands.executeCommand('workbench.action.reloadWindow');
            }
        });
        
    } catch (error) {
        vscode.window.showErrorMessage(`Failed to configure Kimi BYOK: ${error}`);
    }
}

class CartographyService {
    private config: vscode.WorkspaceConfiguration;
    private enabled: boolean;
    private cartographyPath: string;
    private maxContextLength: number;
    private currentAgents: AgentsContext | null = null;
    private statusBarItem: vscode.StatusBarItem;

    constructor() {
        this.config = vscode.workspace.getConfiguration('windsurfCartography');
        this.enabled = this.config.get('enabled', true);
        this.cartographyPath = this.config.get('cartographyPath', '.slim/cartography.json');
        this.maxContextLength = this.config.get('maxContextLength', 5000);
        
        this.statusBarItem = vscode.window.createStatusBarItem(
            vscode.StatusBarAlignment.Right,
            100
        );
        this.statusBarItem.command = 'windsurf-cartography.showCurrent';
        this.updateStatusBar();
        this.statusBarItem.show();
    }

    public reloadConfiguration(): void {
        this.config = vscode.workspace.getConfiguration('windsurfCartography');
        this.enabled = this.config.get('enabled', true);
        this.cartographyPath = this.config.get('cartographyPath', '.slim/cartography.json');
        this.maxContextLength = this.config.get('maxContextLength', 5000);
        this.updateStatusBar();
    }

    public toggleAutoInjection(): void {
        this.enabled = !this.enabled;
        this.config.update('enabled', this.enabled, true);
        this.updateStatusBar();
        
        vscode.window.showInformationMessage(
            `AGENTS.md auto-detection ${this.enabled ? 'enabled' : 'disabled'}`
        );
    }

    public async refreshContext(): Promise<void> {
        if (!vscode.window.activeTextEditor) {
            vscode.window.showWarningMessage('No active editor to refresh context for');
            return;
        }

        await this.handleEditorChange(vscode.window.activeTextEditor);
        vscode.window.showInformationMessage('AGENTS context refreshed');
    }

    public async showCurrentAgents(): Promise<void> {
        if (!this.currentAgents || !this.currentAgents.content) {
            vscode.window.showInformationMessage('No AGENTS.md context currently loaded');
            return;
        }

        // Create and show a document with the AGENTS.md content
        const doc = await vscode.workspace.openTextDocument({
            content: this.currentAgents.content,
            language: 'markdown'
        });
        
        await vscode.window.showTextDocument(doc, {
            preview: true,
            viewColumn: vscode.ViewColumn.Two
        });
    }

    public async handleEditorChange(editor: vscode.TextEditor): Promise<void> {
        if (!this.enabled) {
            this.currentAgents = null;
            this.updateStatusBar();
            return;
        }

        const workspaceRoot = vscode.workspace.workspaceFolders?.[0]?.uri.fsPath;
        if (!workspaceRoot) {
            return;
        }

        const filePath = editor.document.uri.fsPath;
        const agentsContext = this.findAgentsForFile(workspaceRoot, filePath);
        
        if (agentsContext && agentsContext.agentsPath) {
            try {
                const content = fs.readFileSync(agentsContext.agentsPath, 'utf-8');
                agentsContext.content = this.truncateContent(content);
                this.currentAgents = agentsContext;
                
                // AGENTS.md is automatically discovered by Windsurf - no injection needed
                console.log('Found AGENTS.md for context:', agentsContext.relativePath);
                
                this.updateStatusBar();
            } catch (error) {
                console.error('Error reading AGENTS.md:', error);
            }
        } else {
            this.currentAgents = null;
            this.updateStatusBar();
        }
    }

    private findAgentsForFile(workspaceRoot: string, filePath: string): AgentsContext {
        const relativePath = path.relative(workspaceRoot, filePath);
        const dirPath = path.dirname(filePath);
        
        // Look for AGENTS.md in the current directory and parent directories
        let currentDir = dirPath;
        while (currentDir.startsWith(workspaceRoot)) {
            const agentsPath = path.join(currentDir, 'AGENTS.md');
            if (fs.existsSync(agentsPath)) {
                return {
                    workspaceRoot,
                    relativePath: path.relative(workspaceRoot, currentDir),
                    agentsPath,
                    content: null
                };
            }
            
            // Move up to parent directory
            const parentDir = path.dirname(currentDir);
            if (parentDir === currentDir) {
                break;
            }
            currentDir = parentDir;
        }

        // Check for root-level AGENTS.md
        const rootAgentsPath = path.join(workspaceRoot, 'AGENTS.md');
        if (fs.existsSync(rootAgentsPath)) {
            return {
                workspaceRoot,
                relativePath: '.',
                agentsPath: rootAgentsPath,
                content: null
            };
        }

        return {
            workspaceRoot,
            relativePath: relativePath,
            agentsPath: null,
            content: null
        };
    }

    private truncateContent(content: string): string {
        if (content.length <= this.maxContextLength) {
            return content;
        }
        
        return content.substring(0, this.maxContextLength) + 
               '\n\n...[Content truncated due to length limits]';
    }

    private updateStatusBar(): void {
        if (!this.enabled) {
            this.statusBarItem.text = '$(map) AGENTS (Off)';
            this.statusBarItem.tooltip = 'Windsurf Cartography: Auto-detection disabled';
            this.statusBarItem.backgroundColor = new vscode.ThemeColor('statusBarItem.warningBackground');
        } else if (this.currentAgents) {
            this.statusBarItem.text = `$(map) ${this.currentAgents.relativePath}`;
            this.statusBarItem.tooltip = `AGENTS.md: ${this.currentAgents.agentsPath}`;
            this.statusBarItem.backgroundColor = undefined;
        } else {
            this.statusBarItem.text = '$(map) No AGENTS';
            this.statusBarItem.tooltip = 'No AGENTS.md found for current file';
            this.statusBarItem.backgroundColor = undefined;
        }
    }
}
