import { z } from 'zod';

const DecisionStatusSchema = z.enum([
  'Proposed',
  'Approved',
  'InProgress',
  'Completed',
  'Rejected',
]);

const PrioritySchema = z.enum(['Low', 'Medium', 'High', 'Critical']);

const FindByIdSchema = z.object({
  decisionId: z.string().min(1),
});

const FindByStatusSchema = z.object({
  status: DecisionStatusSchema,
  limit: z.number().int().positive().max(100).default(10),
});

const CreateDecisionSchema = z.object({
  decisionId: z.string().min(1),
  title: z.string().min(1),
  category: z.string().min(1),
  priority: PrioritySchema,
  content: z.string().optional(),
});

const UpdateStatusSchema = z.object({
  decisionId: z.string().min(1),
  status: DecisionStatusSchema,
});

type DecisionRecord = {
  decisionId: string;
  title: string;
  category: string;
  priority: z.infer<typeof PrioritySchema>;
  status: z.infer<typeof DecisionStatusSchema>;
  content?: string;
  updatedAt: string;
};

const decisions = new Map<string, DecisionRecord>();

export const decisionTools = [
  {
    name: 'find_decision_by_id',
    description: 'Find a decision by decision ID.',
    inputSchema: {
      type: 'object',
      properties: {
        decisionId: { type: 'string', description: 'Decision ID' },
      },
      required: ['decisionId'],
    },
  },
  {
    name: 'find_decisions_by_status',
    description: 'Find decisions by status with optional limit.',
    inputSchema: {
      type: 'object',
      properties: {
        status: {
          type: 'string',
          enum: ['Proposed', 'Approved', 'InProgress', 'Completed', 'Rejected'],
        },
        limit: { type: 'number', default: 10 },
      },
      required: ['status'],
    },
  },
  {
    name: 'create_decision',
    description: 'Create a new decision record.',
    inputSchema: {
      type: 'object',
      properties: {
        decisionId: { type: 'string' },
        title: { type: 'string' },
        category: { type: 'string' },
        priority: { type: 'string', enum: ['Low', 'Medium', 'High', 'Critical'] },
        content: { type: 'string' },
      },
      required: ['decisionId', 'title', 'category', 'priority'],
    },
  },
  {
    name: 'update_decision_status',
    description: 'Update the status of an existing decision.',
    inputSchema: {
      type: 'object',
      properties: {
        decisionId: { type: 'string' },
        status: {
          type: 'string',
          enum: ['Proposed', 'Approved', 'InProgress', 'Completed', 'Rejected'],
        },
      },
      required: ['decisionId', 'status'],
    },
  },
];

export async function executeDecisionTool(
  name: string,
  args: unknown,
): Promise<unknown> {
  switch (name) {
    case 'find_decision_by_id': {
      const params = FindByIdSchema.parse(args);
      const decision = decisions.get(params.decisionId) ?? null;
      return { found: Boolean(decision), decision };
    }
    case 'find_decisions_by_status': {
      const params = FindByStatusSchema.parse(args);
      const records = Array.from(decisions.values())
        .filter((decision) => decision.status === params.status)
        .slice(0, params.limit);
      return { count: records.length, decisions: records };
    }
    case 'create_decision': {
      const params = CreateDecisionSchema.parse(args);

      if (decisions.has(params.decisionId)) {
        throw new Error(`Decision '${params.decisionId}' already exists`);
      }

      const record: DecisionRecord = {
        ...params,
        status: 'Proposed',
        updatedAt: new Date().toISOString(),
      };
      decisions.set(params.decisionId, record);

      return { created: true, decision: record };
    }
    case 'update_decision_status': {
      const params = UpdateStatusSchema.parse(args);
      const existing = decisions.get(params.decisionId);

      if (!existing) {
        throw new Error(`Decision '${params.decisionId}' not found`);
      }

      const updated: DecisionRecord = {
        ...existing,
        status: params.status,
        updatedAt: new Date().toISOString(),
      };
      decisions.set(params.decisionId, updated);

      return { updated: true, decision: updated };
    }
    default:
      throw new Error(`Unknown tool: ${name}`);
  }
}
