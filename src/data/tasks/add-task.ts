import type { Task } from '@/types/Task';
import { taskDataManager } from './task-data-manager';

export type AddTaskArgs = {
  cycle_id: number;
  assigned_to_user_id: number;
  requirement_id: number;
  deadline: Date;
  status?: 'todo' | 'in_progress' | 'completed';
};

export async function addTask(args: AddTaskArgs): Promise<Task> {
  const newTask: Task = {
    cycle_id: args.cycle_id,
    assigned_to_user_id: args.assigned_to_user_id,
    requirement_id: args.requirement_id,
    deadline: args.deadline,
    status: args.status || 'todo',
  };

  const createdTask = await taskDataManager.addTask(newTask);

  return createdTask;
}

export type AddTaskResponse = ReturnType<typeof addTask>;
