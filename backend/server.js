require('dotenv').config();

const express = require('express');
const cors = require('cors');
const app = express();
const { PrismaClient } = require('@prisma/client');
const http = require('http');
const socketIo = require('socket.io');
const bodyParser = require('body-parser');
const authRoutes = require('./routes/auth');
const claimsRoutes = require('./routes/claims');
const userProfileRoutes = require('./routes/userProfile');
const authenticate = require('./middleware/auth');
const checkRole = require('./middleware/role');
const path = require('path');

const prisma = new PrismaClient();

//initialize socket.io
const server = http.createServer(app);
const io = socketIo(server, {
  cors: {
    origin: 'http://localhost:3000',
    methods: ['GET', 'POST', 'PUT', 'PATCH'],
    credentials: true,
  },
});

// Attach `io` to every request
app.use((req, res, next) => {
  req.io = io;
  next();
});

// CORS middleware
app.use(cors({
  origin: 'http://localhost:3000',
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'],
  credentials: true,
}));

app.use(bodyParser.json());

// WebSocket connection
io.on('connection', (socket) => {
  console.log('A user connected');

  socket.on('disconnect', () => {
    console.log('User disconnected');
  });
});

// Routes
app.use('/auth', authRoutes);
app.use('/claims', authenticate, claimsRoutes); 
app.use('/user-profile', authenticate, userProfileRoutes);

// Serve uploaded files statically
app.use('/uploads', express.static(path.join(__dirname, 'public', 'uploads')));

// Start the server
const PORT = process.env.PORT || 5000;
server.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
