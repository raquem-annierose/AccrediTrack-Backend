import type { Request, Response, NextFunction } from 'express';
import { getTasks } from '@/data/tasks/get-task';

export async function getTaskHandler(req: Request, res: Response, next: NextFunction) {
  try {
    const tasks = await getTasks();
    res.status(200).json({ tasks });
  } catch (error) {
    next(error);
  }
}

export type GetTaskHandlerResponseType = typeof getTaskHandler;
