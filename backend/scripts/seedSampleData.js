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

async function connectDB() {
  await mongoose.connect(MONGODB_URI);
  console.log(`Connected to MongoDB: ${MONGODB_URI}`);
}

function slugify(name) {
  return name
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/(^-|-$)+/g, '');
}

function randomToken(length = 48) {
  const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';
  let out = '';
  for (let i = 0; i < length; i += 1) out += possible[Math.floor(Math.random() * possible.length)];
  return out;
}

function addDays(date, days) {
  const d = new Date(date);
  d.setDate(d.getDate() + days);
  return d;
}

async function clearAll() {
  await Promise.all([
    User.deleteMany({}),
    Category.deleteMany({}),
    Product.deleteMany({}),
    Cart.deleteMany({}),
    Rental.deleteMany({}),
    Quotation.deleteMany({}),
    Payment.deleteMany({}),
    ProductBooking.deleteMany({}),
    Review.deleteMany({}),
    Notification.deleteMany({}),
    AuditLog.deleteMany({}),
    RefreshToken.deleteMany({}),
  ]);
}

async function seed() {
  await connectDB();

  console.log('Clearing existing seed data from all relevant collections...');
  await clearAll();

  // Create users
  console.log('Creating users...');
  const [admin, alice, bob] = await User.insertMany([
    { name: 'Admin User', email: 'admin.seed@flexirent.com', password: 'admin123', role: 'admin', phone: '+10000000001' },
    { name: 'Alice Johnson', email: 'alice@flexirent.com', password: 'alice1234', role: 'user', phone: '+10000000002' },
    { name: 'Bob Smith', email: 'bob@flexirent.com', password: 'bob1234', role: 'user', phone: '+10000000003' },
  ]);

  const categoryNames = ['Photography', 'Technology', 'Tools', 'Furniture', 'Medical'];
  const categories = await Category.insertMany(
    categoryNames.map((name) => ({ name, slug: slugify(name), description: `${name} gear` }))
  );
  const categoryMap = Object.fromEntries(categories.map((c) => [c.name, c._id]));
  console.log(`Inserted ${categories.length} categories`);

  const products = [
    {
      name: 'Professional Camera Kit',
      category: 'Photography',
      description: 'High-end DSLR camera with lenses and accessories',
      images: ['/placeholder-camera.jpg'],
      pricePerHour: 25,
      pricePerDay: 150,
      pricePerWeek: 900,
      features: ['4K Video', 'Multiple Lenses', 'Tripod Included'],
      addOns: [
        { id: 'a1', name: 'Extra Battery', price: 15 },
        { id: 'a2', name: 'Memory Card 64GB', price: 20 },
      ],
    },
    {
      name: 'MacBook Pro 16"',
      category: 'Technology',
      description: 'Latest MacBook Pro for professional work',
      images: ['/placeholder-laptop.jpg'],
      pricePerHour: 15,
      pricePerDay: 80,
      pricePerWeek: 500,
      features: ['M3 Chip', '32GB RAM', '1TB SSD'],
      addOns: [
        { id: 'a3', name: 'External Monitor', price: 30 },
        { id: 'a4', name: 'Wireless Mouse', price: 10 },
      ],
    },
    {
      name: 'Power Drill Set',
      category: 'Tools',
      description: 'Professional cordless drill with complete bit set',
      images: ['/placeholder-drill.jpg'],
      pricePerHour: 8,
      pricePerDay: 35,
      pricePerWeek: 200,
      features: ['Cordless', 'Multiple Bits', 'Case Included'],
      addOns: [{ id: 'a5', name: 'Extra Battery Pack', price: 25 }],
    },
    {
      name: 'Conference Table',
      category: 'Furniture',
      description: 'Modern glass conference table for 8 people',
      images: ['/placeholder-table.jpg'],
      pricePerHour: 12,
      pricePerDay: 60,
      pricePerWeek: 350,
      features: ['Glass Top', 'Seats 8', 'Modern Design'],
      addOns: [{ id: 'a6', name: 'Chair Set (8)', price: 40 }],
    },
    {
      name: 'Wheelchair',
      category: 'Medical',
      description: 'Comfortable wheelchair for mobility assistance',
      images: ['/placeholder-wheelchair.jpg'],
      pricePerHour: 8,
      pricePerDay: 45,
      pricePerWeek: 280,
      features: ['Adjustable', 'Lightweight', 'Foldable'],
      addOns: [{ id: 'a7', name: 'Cushion', price: 12 }],
    },
    {
      name: 'Office Chair',
      category: 'Furniture',
      description: 'Ergonomic office chair with lumbar support',
      images: ['/placeholder-chair.jpg'],
      pricePerHour: 5,
      pricePerDay: 25,
      pricePerWeek: 150,
      features: ['Ergonomic', 'Adjustable Height', 'Swivel'],
      addOns: [{ id: 'a8', name: 'Footrest', price: 8 }],
    },
    {
      name: 'GoPro Action Camera',
      category: 'Photography',
      description: 'Waterproof action camera with mounts',
      images: ['/placeholder-gopro.jpg'],
      pricePerHour: 10,
      pricePerDay: 50,
      pricePerWeek: 300,
      features: ['4K60', 'Waterproof', 'Stabilization'],
      addOns: [{ id: 'a9', name: 'Chest Mount', price: 12 }],
    },
    {
      name: 'Projector 1080p',
      category: 'Technology',
      description: 'Bright 1080p projector for meetings',
      images: ['/placeholder-projector.jpg'],
      pricePerHour: 12,
      pricePerDay: 55,
      pricePerWeek: 320,
      features: ['HDMI', '3000 Lumens', 'Remote'],
      addOns: [{ id: 'a10', name: 'Projector Screen', price: 20 }],
    },
    {
      name: 'Circular Saw',
      category: 'Tools',
      description: 'Heavy-duty circular saw for woodworking',
      images: ['/placeholder-saw.jpg'],
      pricePerHour: 7,
      pricePerDay: 30,
      pricePerWeek: 180,
      features: ['Laser Guide', 'Dust Blower'],
      addOns: [{ id: 'a11', name: 'Extra Blades', price: 15 }],
    },
    {
      name: 'Standing Desk',
      category: 'Furniture',
      description: 'Electric height-adjustable standing desk',
      images: ['/placeholder-desk.jpg'],
      pricePerHour: 6,
      pricePerDay: 28,
      pricePerWeek: 165,
      features: ['Electric Lift', 'Memory Presets'],
      addOns: [{ id: 'a12', name: 'Cable Tray', price: 10 }],
    },
    {
      name: 'Hospital Bed',
      category: 'Medical',
      description: 'Adjustable hospital bed with side rails',
      images: ['/placeholder-bed.jpg'],
      pricePerHour: 10,
      pricePerDay: 70,
      pricePerWeek: 420,
      features: ['Adjustable', 'Wheels', 'Rails'],
      addOns: [{ id: 'a13', name: 'Overbed Table', price: 20 }],
    },
    {
      name: '3D Printer',
      category: 'Technology',
      description: 'High-precision FDM 3D printer',
      images: ['/placeholder-3dprinter.jpg'],
      pricePerHour: 20,
      pricePerDay: 120,
      pricePerWeek: 720,
      features: ['Heated Bed', 'Silent Drivers'],
      addOns: [{ id: 'a14', name: 'Extra Filament (1kg)', price: 25 }],
    },
  ];

  const productDocs = products.map((p) => ({
    name: p.name,
    categoryId: categoryMap[p.category],
    description: p.description,
    images: p.images,
    pricePerHour: p.pricePerHour,
    pricePerDay: p.pricePerDay,
    pricePerWeek: p.pricePerWeek,
    features: p.features,
    addOns: p.addOns,
    availability: 'available',
    isActive: true,
  }));

  const inserted = await Product.insertMany(productDocs);
  console.log(`Inserted ${inserted.length} products`);

  // Create carts
  console.log('Creating carts...');
  const now = new Date();
  const p0 = inserted[0];
  const p1 = inserted[1];
  const p2 = inserted[2];
  await Cart.insertMany([
    {
      userId: alice._id,
      items: [
        {
          productId: p0._id,
          quantity: 1,
          duration: 3,
          durationType: 'day',
          selectedAddOns: p0.addOns.slice(0, 1),
          startDate: addDays(now, 2),
          endDate: addDays(now, 5),
        },
      ],
    },
    {
      userId: bob._id,
      items: [
        {
          productId: p1._id,
          quantity: 2,
          duration: 1,
          durationType: 'week',
          selectedAddOns: p1.addOns.slice(0, 2),
          startDate: addDays(now, 7),
          endDate: addDays(now, 14),
        },
      ],
    },
  ]);

  // Create quotation for Alice
  console.log('Creating quotations...');
  const qItem1Unit = p0.pricePerDay;
  const qItem1AddOn = p0.addOns[0]?.price || 0;
  const qItem1Qty = 1;
  const qItem1Dur = 2;
  const qItem1Line = qItem1Unit * qItem1Qty * qItem1Dur + qItem1AddOn;
  const qSubtotal = qItem1Line;
  const qService = Math.round(qSubtotal * 0.05 * 100) / 100;
  const qTax = Math.round(qSubtotal * 0.18 * 100) / 100;
  const qTotal = Math.round((qSubtotal + qService + qTax) * 100) / 100;
  const quotation = await Quotation.create({
    userId: alice._id,
    items: [
      {
        productId: p0._id,
        productSnapshot: {
          name: p0.name,
          pricePerHour: p0.pricePerHour,
          pricePerDay: p0.pricePerDay,
          pricePerWeek: p0.pricePerWeek,
        },
        quantity: qItem1Qty,
        duration: qItem1Dur,
        durationType: 'day',
        selectedAddOns: p0.addOns.slice(0, 1),
        startDate: addDays(now, 3),
        endDate: addDays(now, 5),
        unitBasePrice: qItem1Unit,
        addOnTotal: qItem1AddOn,
        lineTotal: qItem1Line,
      },
    ],
    subtotal: qSubtotal,
    serviceFee: qService,
    tax: qTax,
    total: qTotal,
    status: 'accepted',
    validUntil: addDays(now, 14),
  });

  // Create rental for Alice with product 0 and 1
  console.log('Creating rentals...');
  const rItem1Unit = p0.pricePerDay;
  const rItem1AddOn = p0.addOns[0]?.price || 0;
  const rItem1Qty = 1;
  const rItem1Dur = 3;
  const rItem1Line = rItem1Unit * rItem1Qty * rItem1Dur + rItem1AddOn;

  const rItem2Unit = p1.pricePerWeek;
  const rItem2AddOn = (p1.addOns[0]?.price || 0) + (p1.addOns[1]?.price || 0);
  const rItem2Qty = 1;
  const rItem2Dur = 1;
  const rItem2Line = rItem2Unit * rItem2Qty * rItem2Dur + rItem2AddOn;

  const rSubtotal = rItem1Line + rItem2Line;
  const rService = Math.round(rSubtotal * 0.05 * 100) / 100;
  const rTax = Math.round(rSubtotal * 0.18 * 100) / 100;
  const rTotal = Math.round((rSubtotal + rService + rTax) * 100) / 100;

  const rental = await Rental.create({
    userId: alice._id,
    items: [
      {
        productId: p0._id,
        productSnapshot: {
          name: p0.name,
          pricePerHour: p0.pricePerHour,
          pricePerDay: p0.pricePerDay,
          pricePerWeek: p0.pricePerWeek,
        },
        quantity: rItem1Qty,
        duration: rItem1Dur,
        durationType: 'day',
        selectedAddOns: p0.addOns.slice(0, 1),
        startDate: addDays(now, 2),
        endDate: addDays(now, 5),
        unitBasePrice: rItem1Unit,
        addOnTotal: rItem1AddOn,
        lineTotal: rItem1Line,
      },
      {
        productId: p1._id,
        productSnapshot: {
          name: p1.name,
          pricePerHour: p1.pricePerHour,
          pricePerDay: p1.pricePerDay,
          pricePerWeek: p1.pricePerWeek,
        },
        quantity: rItem2Qty,
        duration: rItem2Dur,
        durationType: 'week',
        selectedAddOns: p1.addOns.slice(0, 2),
        startDate: addDays(now, 7),
        endDate: addDays(now, 14),
        unitBasePrice: rItem2Unit,
        addOnTotal: rItem2AddOn,
        lineTotal: rItem2Line,
      },
    ],
    paymentMode: 'deposit',
    subtotal: rSubtotal,
    serviceFee: rService,
    tax: rTax,
    total: rTotal,
    depositAmount: Math.round(rTotal * 0.3 * 100) / 100,
    balanceDue: Math.round(rTotal * 0.7 * 100) / 100,
    status: 'upcoming',
    delivery: {
      method: 'pickup',
      address: { street: '123 Main St', city: 'Metropolis', state: 'NY', zipCode: '10001', country: 'USA' },
      deliveryFee: 0,
    },
    customerSnapshot: { name: alice.name, email: alice.email, phone: alice.phone },
  });

  // Create product bookings
  console.log('Creating product bookings...');
  await ProductBooking.insertMany([
    { productId: p0._id, rentalId: rental._id, status: 'confirmed', startDate: addDays(now, 2), endDate: addDays(now, 5), quantity: 1 },
    { productId: p2._id, status: 'hold', startDate: addDays(now, 1), endDate: addDays(now, 2), quantity: 1 },
  ]);

  // Create payments
  console.log('Creating payments...');
  await Payment.insertMany([
    { rentalId: rental._id, userId: alice._id, amount: Math.round(rTotal * 0.3 * 100) / 100, currency: 'USD', paymentType: 'deposit', method: 'card', status: 'succeeded', provider: 'MockPay', providerRef: 'pay_dep_001' },
    { rentalId: rental._id, userId: alice._id, amount: Math.round(rTotal * 0.7 * 100) / 100, currency: 'USD', paymentType: 'balance', method: 'card', status: 'pending', provider: 'MockPay', providerRef: 'pay_bal_001' },
  ]);

  // Create reviews
  console.log('Creating reviews...');
  await Review.insertMany([
    { productId: p0._id, userId: alice._id, rating: 5, comment: 'Excellent quality and easy to use!' },
    { productId: p1._id, userId: bob._id, rating: 4, comment: 'Very powerful device. Battery life could be better.' },
  ]);

  // Create notifications
  console.log('Creating notifications...');
  await Notification.insertMany([
    { userId: alice._id, type: 'rental', title: 'Rental Confirmed', message: `Your rental ${rental._id.toString()} is confirmed.` },
    { userId: alice._id, type: 'payment', title: 'Deposit Received', message: 'We have received your deposit payment.' },
    { userId: admin._id, type: 'system', title: 'New Rental', message: `${alice.name} created a new rental.` },
  ]);

  // Create audit logs
  console.log('Creating audit logs...');
  await AuditLog.insertMany([
    { actorId: admin._id, action: 'CREATE_USER', entity: 'User', entityId: alice._id, after: { id: alice._id, email: alice.email } },
    { actorId: admin._id, action: 'CREATE_PRODUCT', entity: 'Product', entityId: p0._id, after: { id: p0._id, name: p0.name } },
    { actorId: admin._id, action: 'CREATE_RENTAL', entity: 'Rental', entityId: rental._id, after: { id: rental._id, total: rTotal } },
    { actorId: admin._id, action: 'CREATE_PAYMENT', entity: 'Payment', after: { amount: Math.round(rTotal * 0.3 * 100) / 100 } },
    { actorId: admin._id, action: 'CREATE_QUOTATION', entity: 'Quotation', entityId: quotation._id, after: { id: quotation._id, total: qTotal } },
  ]);

  // Create refresh tokens
  console.log('Creating refresh tokens...');
  await RefreshToken.insertMany([
    { userId: alice._id, token: randomToken(), expiresAt: addDays(now, 30) },
    { userId: bob._id, token: randomToken(), expiresAt: addDays(now, 30) },
  ]);

  // Print a small sample to terminal
  const sample = await Product.find({}).limit(5).lean();
  console.log('Sample products:', sample.map((s) => ({ name: s.name, pricePerDay: s.pricePerDay })));

  await mongoose.disconnect();
  console.log('Seeding complete. Disconnected.');
}

seed().catch((err) => {
  console.error('Seeding failed:', err);
  mongoose.disconnect();
  process.exit(1);
});


