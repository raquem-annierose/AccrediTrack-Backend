import type { Task } from '@/types/Task';
import { pool } from '@/db';
import type { ResultSetHeader, RowDataPacket } from 'mysql2';

export class TaskDataManager {
  async addTask(task: Task): Promise<Task> {
    const connection = await pool.getConnection();
    try {
      const [result] = await connection.query<ResultSetHeader>(
        'INSERT INTO tasks (cycle_id, assigned_to_user_id, requirement_id, deadline, status) VALUES (?, ?, ?, ?, ?)',
        [
          task.cycle_id,
          task.assigned_to_user_id,
          task.requirement_id,
          task.deadline,
          task.status || 'todo',
        ]
      );

      const [rows] = await connection.query<RowDataPacket[]>('SELECT * FROM tasks WHERE id = ?', [
        result.insertId,
      ]);

      return rows[0] as Task;
    } finally {
      connection.release();
    }
  }

  async getTasks(): Promise<Task[]> {
    const connection = await pool.getConnection();
    try {
      const [rows] = await connection.query<RowDataPacket[]>('SELECT * FROM tasks');
      return rows as Task[];
    } finally {
      connection.release();
    }
  }

  async getTaskById(id: number): Promise<Task | undefined> {
    const connection = await pool.getConnection();
    try {
      const [rows] = await connection.query<RowDataPacket[]>('SELECT * FROM tasks WHERE id = ?', [
        id,
      ]);
      return rows[0] as Task | undefined;
    } finally {
      connection.release();
    }
  }

  async updateTask(id: number, task: Partial<Task>): Promise<boolean> {
    const connection = await pool.getConnection();
    try {
      const fields: string[] = [];
      const values: unknown[] = [];

      if (task.cycle_id !== undefined) {
        fields.push('cycle_id = ?');
        values.push(task.cycle_id);
      }
      if (task.assigned_to_user_id !== undefined) {
        fields.push('assigned_to_user_id = ?');
        values.push(task.assigned_to_user_id);
      }
      if (task.requirement_id !== undefined) {
        fields.push('requirement_id = ?');
        values.push(task.requirement_id);
      }
      if (task.deadline !== undefined) {
        fields.push('deadline = ?');
        values.push(task.deadline);
      }
      if (task.status !== undefined) {
        fields.push('status = ?');
        values.push(task.status);
      }

      if (fields.length === 0) {
        return false;
      }

      values.push(id);

      const [result] = await connection.query<ResultSetHeader>(
        `UPDATE tasks SET ${fields.join(', ')} WHERE id = ?`,
        values
      );

      return result.affectedRows > 0;
    } finally {
      connection.release();
    }
  }

  async deleteTask(id: number): Promise<boolean> {
    const connection = await pool.getConnection();
    try {
      const [result] = await connection.query<ResultSetHeader>('DELETE FROM tasks WHERE id = ?', [
        id,
      ]);
      return result.affectedRows > 0;
    } finally {
      connection.release();
    }
  }
}

export const taskDataManager = new TaskDataManager();
