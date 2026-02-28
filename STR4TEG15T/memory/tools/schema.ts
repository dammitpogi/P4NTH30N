import { z } from 'zod';

export const MetadataSchema = z.object({
  type: z.enum(['decision', 'log', 'research', 'tool']),
  id: z.string().regex(/^[A-Z_0-9-]+$/),
  category: z.enum(['architecture', 'implementation', 'bugfix', 'research', 'event']),
  status: z.enum(['active', 'deprecated', 'superseded', 'draft']),
  version: z.string().regex(/^\d+\.\d+\.\d+$/),
  created_at: z.string().datetime(),
  last_reviewed: z.string().datetime(),
  keywords: z.array(z.string().min(2).max(50)).max(20),
  roles: z.array(z.string()),
  summary: z.string().min(50).max(500),
  source: z.object({
    type: z.string(),
    original_path: z.string()
  }).optional()
});

export type Metadata = z.infer<typeof MetadataSchema>;

export function validateMetadata(data: unknown): { success: boolean; data?: Metadata; errors?: string[] } {
  const result = MetadataSchema.safeParse(data);
  if (result.success) {
    return { success: true, data: result.data };
  }
  return {
    success: false,
    errors: result.error.errors.map(e => `${e.path.join('.')}: ${e.message}`)
  };
}
