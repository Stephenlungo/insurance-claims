
const express = require('express');
const router = express.Router();
const claimsController = require('../controllers/claimsController');
const authMiddleware = require('../middleware/auth');
const { uploadSingle } = require('../middleware/upload');

const checkRole = require('../middleware/role');


// Get all claims
router.get('/all', claimsController.getClaims);

// Create a new claim
router.post('/', authMiddleware, uploadSingle, claimsController.createClaim);

// View claim status
router.get('/:id/view-status', claimsController.viewClaimStatus);

router.patch('/:id/update-status', authMiddleware, checkRole('admin'), claimsController.updateClaimStatus);

router.post('/:id/settle', authMiddleware, checkRole('admin'), claimsController.settleClaim);
router.get('/my-claims', authMiddleware, claimsController.getMyClaims);

module.exports = router;
