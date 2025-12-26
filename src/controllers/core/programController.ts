import type { Request, Response } from 'express';
import { ProgramService } from '@/services/core/programService';
import type { Program } from '@/types/database/core/Program';

export class ProgramController {
  private programService: ProgramService;

  constructor() {
    this.programService = new ProgramService();
  }

  public createProgram = async (req: Request, res: Response) => {
    try {
      const programData = req.body;
      const newProgram = await this.programService.createProgram(programData);
      res.status(201).json(newProgram);
    } catch (error) {
      res.status(500).json({ message: 'Error creating program', error });
    }
  };

  public getProgram = async (req: Request, res: Response) => {
    try {
      const programId = parseInt(req.params.id || '');
      const program = await this.programService.getProgram(programId);
      if (program) {
        res.status(200).json(program);
      } else {
        res.status(404).json({ message: 'Program not found' });
      }
    } catch (error) {
      res.status(500).json({ message: 'Error retrieving program', error });
    }
  };

  public updateProgram = async (req: Request, res: Response) => {
    try {
      const programId = parseInt(req.params.id || '');
      const programData: Partial<Program> = req.body;
      const updatedProgram = await this.programService.updateProgram(programId, programData);
      if (updatedProgram) {
        res.status(200).json(updatedProgram);
      } else {
        res.status(404).json({ message: 'Program not found' });
      }
    } catch (error) {
      res.status(500).json({ message: 'Error updating program', error });
    }
  };

  public deleteProgram = async (req: Request, res: Response) => {
    try {
      const programId = parseInt(req.params.id || '');
      const deleted = await this.programService.deleteProgram(programId);
      if (deleted) {
        res.status(204).send();
      } else {
        res.status(404).json({ message: 'Program not found' });
      }
    } catch (error) {
      res.status(500).json({ message: 'Error deleting program', error });
    }
  };
}
