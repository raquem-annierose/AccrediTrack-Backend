import type { Task } from '@/types/Task';
import { taskDataManager } from './task-data-manager';

export async function getTasks(): Promise<Task[]> {
  const tasks = await taskDataManager.getTasks();
  return tasks;
}

export type GetTaskResponse = ReturnType<typeof getTasks>;
