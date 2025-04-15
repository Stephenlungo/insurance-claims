
const { PrismaClient } = require('@prisma/client');
const jwt = require('jsonwebtoken');
const SECRET = process.env.JWT_SECRET;
const bcrypt = require('bcryptjs');

const prisma = new PrismaClient();


// Register user
const register = async (req, res) => {
  const { email, password, role } = req.body;
  const hashedPassword = await bcrypt.hash(password, 10);

  try {
    const user = await prisma.user.create({
      data: { email, password: hashedPassword, role },
    });
    res.status(201).json({ message: 'User registered' });
  } catch (err) {
    console.error(err);
    res.status(500).send('Error registering user');
  }
};
//Login
const login = async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await prisma.user.findUnique({
      where: { email },
      include: {
        profile: { 
          select: {
            id: true,
            first_name: true,
            last_name: true,
            phone: true,
            address: true,
          },
        },
      },
    });

    if (!user || !(await bcrypt.compare(password, user.password))) {
      return res.status(401).send('Invalid credentials');
    }

    const token = jwt.sign(
      { id: user.id, email: user.email, role: user.role },
      SECRET,
      { expiresIn: '1d' }
    );

    res.json({
      message: 'Login successful',
      token,
      user: {
        id: user.id,
        email: user.email,
        role: user.role,
        profile: user.profile, 
      },
    });
  } catch (err) {
    console.error(err);
    res.status(500).send('Error logging in');
  }
};


module.exports = { register, login };
