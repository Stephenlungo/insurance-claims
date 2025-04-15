const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

// Create user profile
const createUserProfile = async (req, res) => {
  const { user_id, first_name, last_name, nrc, phone, address } = req.body; // Corrected the variable name

  try {
    // Check if the user exists
    const userExists = await prisma.user.findUnique({
      where: { id: user_id }, // Corrected the variable name to 'user_id'
    });

    if (!userExists) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Create user profile
    const userProfile = await prisma.userProfile.create({
      data: {
        user_id: user_id, // The ID of the user
        first_name,
        last_name,
        nrc,
        phone,
        address,
      },
    });

    res.status(201).json({ message: 'User profile created successfully', userProfile });
  } catch (err) {
    console.error(err);
    res.status(500).send('Error creating user profile');
  }
};

module.exports = {
  createUserProfile,
};
