export type Task = {
  id?: number;
  cycle_id: number;
  assigned_to_user_id: number;
  requirement_id: number;
  deadline: Date;
  status: 'todo' | 'in_progress' | 'completed';
  created_at?: Date;
};
