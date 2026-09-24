import { Router } from 'express';
import auth from '../middleware/auth.js';
import * as c from '../controllers/dashboardController.js';

const router = Router();

router.use(auth);
router.get('/overview', c.overview);
router.get('/growth', c.growth);

export default router;