import { db } from '@/data/connection/db';
import type { Program } from '@/types/database/core/Program';
import type { ResultSetHeader } from 'mysql2';

export class ProgramRepository {
  async addProgram(
    program: Omit<Program, 'program_id' | 'created_at' | 'updated_at'>
  ): Promise<Program> {
    const query =
      'INSERT INTO programs (code, name, description, status, created_at) VALUES ( ?, ?, ?, ?,NOW())';

    const [result] = await db.execute(query, [
      program.program_code,
      program.program_name,
      program.program_description,
      program.status ?? null,
    ]);

    const insertId = (result as ResultSetHeader).insertId;
    return (await this.findProgramById(insertId)) as Program;
  }

  async findProgramById(programId: number): Promise<Program | null> {
    const query = 'SELECT * FROM programs WHERE id = ?';
    const [rows] = await db.execute(query, [programId]);
    const programs = rows as Program[];

    if (programs.length > 0) {
      const p = programs[0];
      // Ensure objectives are parsed if returned as string from DB
      if (p && typeof p.program_objectives === 'string') {
        p.program_objectives = JSON.parse(p.program_objectives);
      }
      return p ?? null;
    }
    return null;
  }

  async updateProgramById(programId: number, program: Partial<Program>): Promise<Program | null> {
    const updates: string[] = [];
    const values: unknown[] = [];

    Object.entries(program).forEach(([key, value]) => {
      if (key !== 'program_id' && key !== 'created_at' && key !== 'updated_at') {
        updates.push(`${key} = ?`);
        if (key === 'program_objectives' && Array.isArray(value)) {
          values.push(JSON.stringify(value));
        } else {
          values.push(value);
        }
      }
    });

    if (updates.length === 0) return this.findProgramById(programId);

    values.push(programId);
    const query = `UPDATE programs SET ${updates.join(', ')}, updated_at = NOW() WHERE program_id = ?`;
    await db.execute(query, values);

    return this.findProgramById(programId);
  }

  async deleteProgramById(programId: number): Promise<boolean> {
    const query = 'DELETE FROM programs WHERE program_id = ?';
    const [result] = await db.execute(query, [programId]);
    return (result as ResultSetHeader).affectedRows > 0;
  }
}
