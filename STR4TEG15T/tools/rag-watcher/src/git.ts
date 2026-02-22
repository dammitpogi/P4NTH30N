/**
 * Git Integration Module
 * Provides git operations for the file watcher
 */

import simpleGit, { SimpleGit } from 'simple-git';
import { logger } from './logger.js';

export interface GitInfo {
  commit: string;
  branch: string;
  author: string;
  date: string;
  message: string;
}

export class GitIntegration {
  private git: SimpleGit;

  constructor(repoPath: string) {
    this.git = simpleGit(repoPath);
  }

  /**
   * Check if the path is a git repository
   */
  async isRepo(): Promise<boolean> {
    try {
      return await this.git.checkIsRepo();
    } catch {
      return false;
    }
  }

  /**
   * Get current commit information
   */
  async getCurrentCommit(): Promise<GitInfo | null> {
    try {
      const log = await this.git.log({ maxCount: 1 });
      
      if (log.latest) {
        return {
          commit: log.latest.hash,
          branch: await this.getCurrentBranch(),
          author: log.latest.author_name,
          date: log.latest.date,
          message: log.latest.message,
        };
      }
      
      return null;
    } catch (error) {
      logger.error('Failed to get current commit', { 
        error: error instanceof Error ? error.message : String(error) 
      });
      return null;
    }
  }

  /**
   * Get current branch name
   */
  async getCurrentBranch(): Promise<string> {
    try {
      const branchSummary = await this.git.branch();
      return branchSummary.current || 'unknown';
    } catch {
      return 'unknown';
    }
  }

  /**
   * Get the last commit that modified a file
   */
  async getFileLastCommit(filePath: string): Promise<GitInfo | null> {
    try {
      const log = await this.git.log({ 
        file: filePath,
        maxCount: 1 
      });
      
      if (log.latest) {
        return {
          commit: log.latest.hash,
          branch: await this.getCurrentBranch(),
          author: log.latest.author_name,
          date: log.latest.date,
          message: log.latest.message,
        };
      }
      
      return null;
    } catch (error) {
      logger.error('Failed to get file last commit', { 
        file: filePath,
        error: error instanceof Error ? error.message : String(error) 
      });
      return null;
    }
  }

  /**
   * Check if there are uncommitted changes
   */
  async hasUncommittedChanges(): Promise<boolean> {
    try {
      const status = await this.git.status();
      return status.files.length > 0;
    } catch {
      return false;
    }
  }

  /**
   * Get repository status
   */
  async getStatus(): Promise<{
    modified: string[];
    added: string[];
    deleted: string[];
    staged: string[];
  }> {
    try {
      const status = await this.git.status();
      
      return {
        modified: status.modified,
        added: status.not_added,
        deleted: status.deleted,
        staged: status.staged,
      };
    } catch (error) {
      logger.error('Failed to get git status', { 
        error: error instanceof Error ? error.message : String(error) 
      });
      return {
        modified: [],
        added: [],
        deleted: [],
        staged: [],
      };
    }
  }

  /**
   * Get commit hash for ingestion metadata
   */
  async getCommitHashForIngestion(filePath?: string): Promise<string | undefined> {
    try {
      if (filePath) {
        const commit = await this.getFileLastCommit(filePath);
        return commit?.commit;
      } else {
        const commit = await this.getCurrentCommit();
        return commit?.commit;
      }
    } catch {
      return undefined;
    }
  }
}

/**
 * Create git integration for a repository
 */
export function createGitIntegration(repoPath: string): GitIntegration {
  return new GitIntegration(repoPath);
}
