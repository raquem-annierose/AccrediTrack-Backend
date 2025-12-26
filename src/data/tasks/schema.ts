import type { Task } from '@/types/Task';
import { z } from 'zod';

export const taskSchemaObject = {
  id: z.number().int().positive().optional(),
  cycle_id: z.number().int().positive(),
  assigned_to_user_id: z.number().int().positive(),
  requirement_id: z.number().int().positive(),
  deadline: z.coerce.date(),
  status: z.enum(['todo', 'in_progress', 'completed']).default('todo'),
  created_at: z.date().optional(),
};

export const taskSchema = z.object(taskSchemaObject) satisfies z.ZodType<Task>;
