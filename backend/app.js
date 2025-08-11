const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const path = require('path');
const User = require('./models/User');
const Category = require('./models/Category');
const Product = require('./models/Product');
const Cart = require('./models/Cart');
const Rental = require('./models/Rental');
const Quotation = require('./models/Quotation');
const Payment = require('./models/Payment');
const ProductBooking = require('./models/ProductBooking');
const Review = require('./models/Review');
const Notification = require('./models/Notification');
const AuditLog = require('./models/AuditLog');
const RefreshToken = require('./models/RefreshToken');
require('dotenv').config();

const app = express();

// MongoDB Connection
const connectDB = async () => {
  try {
    await mongoose.connect('mongodb://127.0.0.1:27017/flexirent');
    console.log(' MongoDB Connected Successfully');
  } catch (error) {
    console.error(' MongoDB Connection Error:', error.message);
    process.exit(1);
  }
};

// Ensure at least one admin user exists (bootstrap)
const ensureAdminUser = async () => {
  const adminExists = await User.countDocuments({ role: 'admin' });
  if (adminExists > 0) return;

  const adminEmail = process.env.ADMIN_EMAIL || 'admin@flexirent.com';
  const adminPassword = process.env.ADMIN_PASSWORD || 'admin123';
  const adminName = process.env.ADMIN_NAME || 'Admin User';

  await User.create({
    name: adminName,
    email: adminEmail,
    password: adminPassword,
    role: 'admin'
  });
  console.log(`🔑 Bootstrapped admin: ${adminEmail}`);
};

// Middleware
app.use(cors({
  origin: ['http://localhost:5173', 'http://localhost:3000', 'http://127.0.0.1:5173'],
  credentials: true
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/users');

app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);

app.get('/api/health', (req, res) => {
  res.json({ 
    success: true, 
    message: 'FlexiRent API is running',
    timestamp: new Date().toISOString()
  });
});

// Root endpoint
app.get('/', (req, res) => {
  res.json({ 
    success: true, 
    message: 'FlexiRent Backend API',
    version: '1.0.0',
    endpoints: {
      auth: '/api/auth',
      users: '/api/users',
      health: '/api/health'
    }
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ 
    success: false, 
    message: 'Something went wrong!' 
  });
});

// 404 handler (Express 5: avoid '*' which breaks path-to-regexp)
app.use((req, res) => {
  res.status(404).json({ 
    success: false, 
    message: 'Route not found' 
  });
});

const PORT = process.env.PORT || 8080;

// Start server
const startServer = async () => {
  await connectDB();
  // Ensure collections exist so they show up in MongoDB "show collections"
  try {
    await Promise.all([
      User.createCollection(),
      Category.createCollection(),
      Product.createCollection(),
      Cart.createCollection(),
      Rental.createCollection(),
      Quotation.createCollection(),
      Payment.createCollection(),
      ProductBooking.createCollection(),
      Review.createCollection(),
      Notification.createCollection(),
      AuditLog.createCollection(),
      RefreshToken.createCollection(),
    ]);
  } catch (e) {
    // Ignore errors if collections already exist
  }
  await ensureAdminUser();
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
    console.log(`API available at http://localhost:${PORT}`);
    console.log(`Frontend should connect to http://localhost:${PORT}/api`);
  });
};

startServer();
