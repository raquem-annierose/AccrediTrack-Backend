import { taskSchema } from '@/data/tasks/schema';
import type { z } from 'zod';
import type { Request, Response, NextFunction } from 'express';
import { addTask } from '@/data/tasks/add-task';

const inputSchema = taskSchema.pick({
  cycle_id: true,
  assigned_to_user_id: true,
  requirement_id: true,
  deadline: true,
  status: true,
});
type InputType = z.infer<typeof inputSchema>;

export async function addTaskHandler(req: Request, res: Response, next: NextFunction) {
  try {
    const taskRequest = req.body as InputType;
    inputSchema.parse(taskRequest);
    const newTask = await addTask(taskRequest);
    res.status(200).json({ message: 'Task added successfully', task: newTask });
  } catch (error) {
    next(error);
  }
}

export type AddTaskHandlerResponseType = typeof addTaskHandler;
