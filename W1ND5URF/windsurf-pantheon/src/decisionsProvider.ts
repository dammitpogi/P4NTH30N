import * as vscode from 'vscode';

export interface Decision {
	id: string;
	type: string;
	confidence: number;
	timestamp: number;
	targetHouse?: string;
	targetGame?: string;
	targetUsername?: string;
	rationale?: {
		summary: string;
		factors: string[];
		thresholdProximity?: number;
		estimatedMinutesToPop?: number;
		dPDAverage?: number;
		triggeredBy?: string;
	};
	executed?: boolean;
	executedAt?: string;
}

export class DecisionsProvider implements vscode.TreeDataProvider<DecisionItem> {
	private _onDidChangeTreeData: vscode.EventEmitter<DecisionItem | undefined | null | void> = new vscode.EventEmitter<DecisionItem | undefined | null | void>();
	readonly onDidChangeTreeData: vscode.Event<DecisionItem | undefined | null | void> = this._onDidChangeTreeData.event;

	private decisions: Decision[] = [];
	private mcpInteractions: any[] = [];

	refresh(): void {
		this._onDidChangeTreeData.fire();
	}

	addDecision(decision: Decision): void {
		// Add to beginning of list
		this.decisions.unshift(decision);
		// Keep only last 50 decisions
		if (this.decisions.length > 50) {
			this.decisions = this.decisions.slice(0, 50);
		}
		this.refresh();
	}

	addMcpInteraction(interaction: any): void {
		this.mcpInteractions.unshift(interaction);
		if (this.mcpInteractions.length > 20) {
			this.mcpInteractions = this.mcpInteractions.slice(0, 20);
		}
		this.refresh();
	}

	getTreeItem(element: DecisionItem): vscode.TreeItem {
		return element;
	}

	getChildren(element?: DecisionItem): Thenable<DecisionItem[]> {
		if (element) {
			// Return children for a decision
			if (element.contextValue === 'decision' && element.decision) {
				const decision = element.decision;
				const children: DecisionItem[] = [];
				
				if (decision.rationale?.summary) {
					children.push(new DecisionItem(
						'Summary',
						decision.rationale.summary,
						'detail',
						vscode.TreeItemCollapsibleState.None,
						'detail',
						undefined,
						'info'
					));
				}

				if (decision.rationale?.factors?.length) {
					children.push(new DecisionItem(
						'Factors',
						`${decision.rationale.factors.length} factors`,
						'factors',
						vscode.TreeItemCollapsibleState.Collapsed,
						'factors',
						decision.rationale.factors
					));
				}

				if (decision.confidence !== undefined) {
					children.push(new DecisionItem(
						'Confidence',
						`${(decision.confidence * 100).toFixed(1)}%`,
						'detail',
						vscode.TreeItemCollapsibleState.None,
						'detail',
						undefined,
						decision.confidence > 0.7 ? 'success' : decision.confidence > 0.4 ? 'warning' : 'error'
					));
				}

				return Promise.resolve(children);
			} else if (element.contextValue === 'factors') {
				// Return individual factors
				return Promise.resolve(
					element.factors?.map((factor: string, index: number) => 
						new DecisionItem(
							`Factor ${index + 1}`,
							factor,
							'factor',
							vscode.TreeItemCollapsibleState.None,
							'detail'
						)
					) || []
				);
			} else if (element.contextValue === 'mcp-section') {
				return Promise.resolve(this.getMcpChildren());
			} else if (element.contextValue === 'decisions-section') {
				return Promise.resolve(this.getDecisionChildren());
			}
			return Promise.resolve([]);
		}

		// Root level - return sections
		const items: DecisionItem[] = [];

		// Add MCP Interactions section
		if (this.mcpInteractions.length > 0) {
			items.push(new DecisionItem(
				'Tool Interactions',
				`${this.mcpInteractions.length} recent`,
				'mcp-section',
				vscode.TreeItemCollapsibleState.Collapsed,
				'mcp-section'
			));
		}

		// Add Recent Decisions section
		if (this.decisions.length > 0) {
			items.push(new DecisionItem(
				'Recent Decisions',
				`${this.decisions.length} total`,
				'decisions-section',
				vscode.TreeItemCollapsibleState.Collapsed,
				'decisions-section'
			));
		}

		if (items.length === 0) {
			items.push(new DecisionItem(
				'No decisions yet',
				'Waiting for Cascade...',
				'empty',
				vscode.TreeItemCollapsibleState.None,
				'empty'
			));
		}

		return Promise.resolve(items);
	}

	getMcpChildren(): DecisionItem[] {
		return this.mcpInteractions.map((mcp) => {
			const label = mcp.toolName || 'Unknown Tool';
			const time = new Date(mcp.timestamp).toLocaleTimeString();
			return new DecisionItem(
				label,
				`${mcp.serverName || 'Unknown'} • ${time}`,
				'mcp-interaction',
				vscode.TreeItemCollapsibleState.Collapsed,
				'mcp-interaction',
				undefined,
				undefined,
				mcp
			);
		});
	}

	getDecisionChildren(): DecisionItem[] {
		return this.decisions.slice(0, 20).map((decision) => {
			const time = new Date(decision.timestamp).toLocaleTimeString();
			const label = decision.type || 'Unknown';
			const description = decision.targetHouse 
				? `${decision.targetHouse} • ${time}`
				: time;
			
			return new DecisionItem(
				label,
				description,
				'decision',
				vscode.TreeItemCollapsibleState.Collapsed,
				'decision',
				undefined,
				undefined,
				undefined,
				decision
			);
		});
	}
}

export class DecisionItem extends vscode.TreeItem {
	constructor(
		public readonly label: string,
		public readonly description: string,
		public readonly contextValue: string,
		public readonly collapsibleState: vscode.TreeItemCollapsibleState,
		public readonly itemType: string,
		public readonly factors?: string[],
		public readonly iconType?: string,
		public readonly mcpData?: any,
		public readonly decision?: Decision
	) {
		super(label, collapsibleState);
		this.description = description;
		this.contextValue = contextValue;
		
		// Set icon based on type
		if (iconType) {
			this.iconPath = new vscode.ThemeIcon(iconType);
		} else if (itemType === 'decision') {
			this.iconPath = new vscode.ThemeIcon('git-commit');
		} else if (itemType === 'mcp-interaction') {
			this.iconPath = new vscode.ThemeIcon('tools');
		} else if (itemType === 'mcp-section' || itemType === 'decisions-section') {
			this.iconPath = new vscode.ThemeIcon('folder');
		} else if (itemType === 'detail') {
			this.iconPath = new vscode.ThemeIcon('info');
		} else if (itemType === 'factors') {
			this.iconPath = new vscode.ThemeIcon('list-unordered');
		} else if (itemType === 'factor') {
			this.iconPath = new vscode.ThemeIcon('check');
		}

		// Set tooltip
		if (decision?.rationale?.summary) {
			this.tooltip = decision.rationale.summary;
		} else if (mcpData) {
			this.tooltip = `Tool: ${mcpData.toolName}\nServer: ${mcpData.serverName}`;
		}
	}
}
