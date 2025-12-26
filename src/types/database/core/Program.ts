export interface Program {
  program_id: number;
  program_code: string;
  program_name: string;
  program_description: string;
  program_objectives: string[];
  status: string;
  created_at: Date;
  updated_at: Date;
}
