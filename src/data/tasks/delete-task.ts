import { BadRequestError } from '@/utils/errors';
import { taskDataManager } from './task-data-manager';

export type DeleteTaskArgs = {
  task_id: number;
};

export async function deleteTask(args: DeleteTaskArgs): Promise<number> {
  const res = await taskDataManager.deleteTask(args.task_id);

  if (!res) {
    throw new BadRequestError('Task ID not found!');
  }
  return args.task_id;
}

export type DeleteTaskResponse = ReturnType<typeof deleteTask>;
