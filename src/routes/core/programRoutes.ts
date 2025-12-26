import { Router, type Application } from 'express';
import { ProgramController } from '@/controllers/core/programController';

const router = Router();
const programController = new ProgramController();

export const setProgramRoutes = (app: Application) => {
  app.use('/api/programs', router);

  router.post('/', programController.createProgram.bind(programController));
  router.get('/:id', programController.getProgram.bind(programController));
  router.put('/:id', programController.updateProgram.bind(programController));
  router.delete('/:id', programController.deleteProgram.bind(programController));
};
