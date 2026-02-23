import { z } from 'zod';

const CodemapSchema = z.object({
  version: z.string().default('1.0'),
  generatedAt: z.string().optional(),
  project: z.string().optional(),
  directories: z.array(z.object({
    path: z.string(),
    files: z.array(z.object({
      path: z.string(),
      type: z.enum(['source', 'config', 'test', 'documentation', 'other']),
      language: z.string().optional(),
      size: z.number().optional(),
      lines: z.number().optional(),
      dependencies: z.array(z.string()).optional(),
      description: z.string().optional(),
    })),
    totalFiles: z.number(),
    totalLines: z.number(),
    dominantLanguage: z.string().optional(),
    architecturalPatterns: z.array(z.string()).optional(),
    keyComponents: z.array(z.string()).optional(),
  })),
  summary: z.object({
    totalFiles: z.number(),
    totalLines: z.number(),
    languages: z.record(z.string(), z.number()),
    architecture: z.string().optional(),
    keyTechnologies: z.array(z.string()).optional(),
    mainPatterns: z.array(z.string()).optional(),
  }),
});

export type Codemap = z.infer<typeof CodemapSchema>;

/**
 * Parse a codemap.md file and validate its structure.
 * @param content The content of the codemap.md file
 * @returns Parsed and validated codemap object
 */
export function parseCodemap(content: string): Codemap | null {
  try {
    // Simple markdown parsing - look for JSON structure or structured data
    const jsonMatch = content.match(/```json\s*\n([\s\S]*?)\n```/);
    if (jsonMatch) {
      const jsonData = JSON.parse(jsonMatch[1]);
      return CodemapSchema.parse(jsonData);
    }
    
    // Fallback: Try to extract structured information from markdown
    const lines = content.split('\n');
    const sections: Record<string, string[]> = {};
    let currentSection = '';
    
    for (const line of lines) {
      if (line.startsWith('# ') && !line.startsWith('# Code Map')) {
        currentSection = line.substring(2).trim();
        sections[currentSection] = [];
      } else if (currentSection && line.trim()) {
        sections[currentSection].push(line);
      }
    }
    
    // If we found structured information, create a basic codemap
    if (Object.keys(sections).length > 0) {
      return {
        version: '1.0',
        summary: {
          totalFiles: 0,
          totalLines: 0,
          languages: {},
          keyTechnologies: [],
          mainPatterns: [],
        },
        directories: [],
      };
    }
    
    return null;
  } catch (error) {
    console.warn('[codemap-utils] Failed to parse codemap:', error);
    return null;
  }
}

/**
 * Extract key architectural information from a codemap for summarization.
 * @param codemap The parsed codemap object
 * @returns String summary focusing on architectural elements
 */
export function extractArchitecturalSummary(codemap: Codemap): string {
  if (!codemap || !codemap.summary) {
    return 'No architectural information available.';
  }
  
  const { summary, directories } = codemap;
  let result = `Project Architecture:\n`;
  
  if (summary.architecture) {
    result += `- Architecture Pattern: ${summary.architecture}\n`;
  }
  
  if (summary.keyTechnologies && summary.keyTechnologies.length > 0) {
    result += `- Key Technologies: ${summary.keyTechnologies.join(', ')}\n`;
  }
  
  if (summary.mainPatterns && summary.mainPatterns.length > 0) {
    result += `- Main Patterns: ${summary.mainPatterns.join(', ')}\n`;
  }
  
  if (directories.length > 0) {
    result += `- Main Directories: ${directories.slice(0, 5).map(d => d.path).join(', ')}\n`;
  }
  
  result += `- Total Files: ${summary.totalFiles}\n`;
  result += `- Total Lines: ${summary.totalLines}\n`;
  
  const languages = Object.entries(summary.languages)
    .sort(([,a], [,b]) => b - a)
    .slice(0, 5)
    .filter(([,count]) => typeof count === 'number' && count > 0);
  
  if (languages.length > 0) {
    result += `- Languages: ${languages.map(([lang, count]) => `${lang} (${count})`).join(', ')}\n`;
  } else {
    result += `- Languages: Unknown\n`;
  }
  
  return result;
}

/**
 * Check if a codemap contains architectural information worth summarizing.
 * @param codemap The parsed codemap object
 * @returns True if the codemap has substantial architectural information
 */
export function hasArchitecturalContent(codemap: Codemap | null): boolean {
  if (!codemap) return false;
  
  const hasDirs = codemap.directories.length > 0;
  const summary = codemap.summary;
  
  if (!summary) return hasDirs;
  
  const hasArch =
    (typeof summary.architecture === 'string' && summary.architecture.length > 0);
  const hasTech = Boolean(summary.keyTechnologies && Array.isArray(summary.keyTechnologies) && summary.keyTechnologies.length > 0);
  const hasPatterns = Boolean(summary.mainPatterns && Array.isArray(summary.mainPatterns) && summary.mainPatterns.length > 0);
  
  return hasDirs || hasArch || hasTech || hasPatterns;
}