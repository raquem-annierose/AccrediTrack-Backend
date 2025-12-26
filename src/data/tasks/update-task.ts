import { BadRequestError } from '@/utils/errors';
import { taskDataManager } from './task-data-manager';
import type { Task } from '@/types/Task';

export type UpdateTaskArgs = {
  task_id: number;
  updates: Partial<Omit<Task, 'id' | 'created_at'>>;
};

export async function updateTask(args: UpdateTaskArgs): Promise<Task> {
  const updated = await taskDataManager.updateTask(args.task_id, args.updates);

  if (!updated) {
    throw new BadRequestError('Task ID not found or no changes made!');
  }

  const task = await taskDataManager.getTaskById(args.task_id);
  if (!task) {
    throw new BadRequestError('Task not found after update!');
  }

  return task;
}

export type UpdateTaskResponse = ReturnType<typeof updateTask>;
