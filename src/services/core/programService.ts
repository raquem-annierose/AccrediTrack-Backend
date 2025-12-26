import type { Program } from '@/types/database/core/Program';
import { ProgramRepository } from '@/data/repositories/programRepository';

export class ProgramService {
  private programRepository: ProgramRepository;

  constructor() {
    this.programRepository = new ProgramRepository();
  }

  // Fixed: Input type excludes ID and timestamps
  async createProgram(
    programData: Omit<Program, 'program_id' | 'created_at' | 'updated_at'>
  ): Promise<Program> {
    return await this.programRepository.addProgram(programData);
  }

  async getProgram(programId: number): Promise<Program | null> {
    return await this.programRepository.findProgramById(programId);
  }

  async updateProgram(programId: number, programData: Partial<Program>): Promise<Program | null> {
    return await this.programRepository.updateProgramById(programId, programData);
  }

  async deleteProgram(programId: number): Promise<boolean> {
    return await this.programRepository.deleteProgramById(programId);
  }
}
