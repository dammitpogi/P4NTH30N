/**
 * DECISION_051: ToolHive Desktop Configuration Types
 * TypeScript type definitions for external server configuration
 */

/**
 * Server configuration entry from ToolHive Desktop runconfig
 */
export interface ToolHiveServerConfig {
  /** Unique server identifier */
  id: string;
  /** Human-readable name */
  name: string;
  /** Server transport type */
  transport: 'stdio' | 'http' | 'streamable-http';
  /** Connection details */
  connection: {
    command?: string;
    args?: string[];
    url?: string;
    port?: number;
  };
  /** Tags for filtering */
  tags: string[];
  /** Server description */
  description: string;
  /** Source runconfig file */
  source: string;
  /** Docker image (if applicable) */
  image?: string;
  /** Environment variables */
  envVars?: Record<string, string>;
  /** Whether server is enabled */
  enabled: boolean;
}

/**
 * Complete servers configuration file structure
 */
export interface ServersConfig {
  /** Schema version */
  schemaVersion: string;
  /** Last updated timestamp */
  lastUpdated: string;
  /** Source directory for auto-discovery */
  sourceDirectory: string;
  /** Array of server configurations */
  servers: ToolHiveServerConfig[];
  /** Metadata about the configuration */
  metadata: {
    totalServers: number;
    enabledServers: number;
    httpServers: number;
    stdioServers: number;
  };
}

/**
 * Runconfig file structure from ToolHive Desktop
 */
export interface ToolHiveRunconfig {
  schema_version: string;
  name: string;
  container_name: string;
  base_name: string;
  transport: 'stdio' | 'streamable-http';
  host: string;
  port: number;
  target_port?: number;
  target_host?: string;
  image?: string;
  remote_url?: string;
  env_vars?: Record<string, string>;
  cmd_args?: string[];
  proxy_mode: string;
  group: string;
}

/**
 * Discovery result from scanning runconfigs
 */
export interface DiscoveryResult {
  /** Successfully parsed servers */
  servers: ToolHiveServerConfig[];
  /** Errors encountered during discovery */
  errors: Array<{
    file: string;
    error: string;
  }>;
  /** Summary statistics */
  summary: {
    totalFiles: number;
    successful: number;
    failed: number;
  };
}

/**
 * Validation result for configuration
 */
export interface ValidationResult {
  /** Whether configuration is valid */
  valid: boolean;
  /** Validation errors */
  errors: string[];
  /** Validation warnings */
  warnings: string[];
  /** Statistics */
  stats: {
    totalServers: number;
    validServers: number;
    invalidServers: number;
  };
}

/**
 * Deployment result
 */
export interface DeploymentResult {
  /** Whether deployment succeeded */
  success: boolean;
  /** Deployed servers */
  deployed: string[];
  /** Failed deployments */
  failed: Array<{
    server: string;
    error: string;
  }>;
  /** Backup location (if created) */
  backupLocation?: string;
  /** Timestamp */
  timestamp: string;
}
