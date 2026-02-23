import { z } from 'zod';

const configSchema = z.object({
  PORT: z.string().default('3002'),
  BIND_ADDRESS: z.string().default('127.0.0.1'),
  MCP_AUTH_TOKEN: z
    .string()
    .min(32, 'MCP_AUTH_TOKEN must be at least 32 characters'),
  VECTOR_STORE_PATH: z.string().min(1, 'VECTOR_STORE_PATH is required'),
  EMBEDDING_MODEL: z.string().default('text-embedding-3-small'),
});

export type Config = z.infer<typeof configSchema>;

export function loadConfig(env: NodeJS.ProcessEnv = process.env): Config {
  const result = configSchema.safeParse(env);

  if (!result.success) {
    const issues = result.error.issues
      .map((issue) => `${issue.path.join('.')}: ${issue.message}`)
      .join('; ');
    throw new Error(`Configuration validation failed: ${issues}`);
  }

  return result.data;
}
