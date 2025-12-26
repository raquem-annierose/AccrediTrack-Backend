import { z } from 'zod';
import type { Request, Response, NextFunction } from 'express';
import { deleteTask } from '@/data/tasks/delete-task';

const inputSchema = z.object({
  task_id: z.coerce.number().int().positive(),
});

export async function deleteTaskHandler(req: Request, res: Response, next: NextFunction) {
  try {
    const task = inputSchema.parse(req.params);

    await deleteTask({
      task_id: task.task_id,
    });
    res.status(200).json({ message: 'Task deleted successfully', task_id: task.task_id });
  } catch (error) {
    next(error);
  }
}

export type DeleteTaskHandlerResponseType = typeof deleteTaskHandler;
