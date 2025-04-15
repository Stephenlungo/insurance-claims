const express = require('express');
const { createUserProfile } = require('../controllers/userProfileController'); // Import the controller
const router = express.Router();

// POST route to create a user profile
router.post('/', createUserProfile);

module.exports = router;
