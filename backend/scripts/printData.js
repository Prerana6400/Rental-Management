/* eslint-disable no-console */
require('dotenv').config();
const mongoose = require('mongoose');

const Category = require('../models/Category');
const Product = require('../models/Product');
const User = require('../models/User');
const Cart = require('../models/Cart');
const Rental = require('../models/Rental');
const Quotation = require('../models/Quotation');
const Payment = require('../models/Payment');
const ProductBooking = require('../models/ProductBooking');
const Review = require('../models/Review');
const Notification = require('../models/Notification');
const AuditLog = require('../models/AuditLog');
const RefreshToken = require('../models/RefreshToken');

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://127.0.0.1:27017/flexirent';

async function main() {
  await mongoose.connect(MONGODB_URI);
  console.log('Connected to MongoDB');

  const [users, categories, products, carts, rentals, quotations, payments, bookings, reviews, notifications, auditLogs, refreshTokens] = await Promise.all([
    User.find({}).select('name email role createdAt').limit(10).lean(),
    Category.find({}).select('name slug').lean(),
    Product.find({}).select('name pricePerDay categoryId').limit(10).lean(),
    Cart.find({}).limit(5).lean(),
    Rental.find({}).limit(5).lean(),
    Quotation.find({}).limit(5).lean(),
    Payment.find({}).limit(5).lean(),
    ProductBooking.find({}).limit(5).lean(),
    Review.find({}).limit(5).lean(),
    Notification.find({}).limit(5).lean(),
    AuditLog.find({}).limit(5).lean(),
    RefreshToken.find({}).limit(5).lean(),
  ]);

  console.log('\nUsers (up to 5):');
  console.table(users);

  console.log('\nCategories:');
  console.table(categories);

  console.log('\nProducts (up to 10):');
  console.table(products);

  console.log('\nCarts (up to 5):');
  console.table(carts);

  console.log('\nRentals (up to 5):');
  console.table(rentals);

  console.log('\nQuotations (up to 5):');
  console.table(quotations);

  console.log('\nPayments (up to 5):');
  console.table(payments);

  console.log('\nProductBookings (up to 5):');
  console.table(bookings);

  console.log('\nReviews (up to 5):');
  console.table(reviews);

  console.log('\nNotifications (up to 5):');
  console.table(notifications);

  console.log('\nAuditLogs (up to 5):');
  console.table(auditLogs);

  console.log('\nRefreshTokens (up to 5):');
  console.table(refreshTokens);

  await mongoose.disconnect();
}

main().catch((err) => {
  console.error(err);
  mongoose.disconnect();
  process.exit(1);
});


