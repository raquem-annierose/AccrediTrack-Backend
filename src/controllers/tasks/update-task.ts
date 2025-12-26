import { z } from 'zod';
import type { Request, Response, NextFunction } from 'express';
import { updateTask } from '@/data/tasks/update-task';
import { taskSchema } from '@/data/tasks/schema';

const paramsSchema = z.object({
  task_id: z.coerce.number().int().positive(),
});

const bodySchema = taskSchema
  .pick({
    cycle_id: true,
    assigned_to_user_id: true,
    requirement_id: true,
    deadline: true,
    status: true,
  })
  .partial();

export async function updateTaskHandler(req: Request, res: Response, next: NextFunction) {
  try {
    const params = paramsSchema.parse(req.params);
    const updates = bodySchema.parse(req.body);

    const updatedTask = await updateTask({
      task_id: params.task_id,
      updates,
    });

    res.status(200).json({ message: 'Task updated successfully', task: updatedTask });
  } catch (error) {
    next(error);
  }
}

export type UpdateTaskHandlerResponseType = typeof updateTaskHandler;
