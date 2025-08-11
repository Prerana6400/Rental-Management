const mongoose = require('mongoose');
const User = require('../models/User');
require('dotenv').config();

const seedUsers = async () => {
  try {
    // Connect to MongoDB
    await mongoose.connect('mongodb://127.0.0.1:27017/flexirent');
    console.log('✅ Connected to MongoDB');

    // Clear existing users
    await User.deleteMany({});
    console.log('🗑️  Cleared existing users');

    // Create sample users
    const users = [
      {
        name: 'Admin User',
        email: 'admin@flexirent.com',
        password: 'admin123',
        role: 'admin',
        phone: '+1234567890',
        address: {
          street: '123 Admin Street',
          city: 'Admin City',
          state: 'AS',
          zipCode: '12345',
          country: 'USA'
        }
      },
      {
        name: 'John EndUser',
        email: 'enduser@flexirent.com',
        password: 'password123',
        role: 'enduser',
        phone: '+1987654321',
        address: {
          street: '456 EndUser Ave',
          city: 'User City',
          state: 'US',
          zipCode: '54321',
          country: 'USA'
        }
      },
      {
        name: 'Jane Customer',
        email: 'customer@flexirent.com',
        password: 'password123',
        role: 'customer',
        phone: '+1555666777',
        address: {
          street: '789 Customer Blvd',
          city: 'Customer City',
          state: 'CS',
          zipCode: '98765',
          country: 'USA'
        }
      },
      {
        name: 'Bob Manager',
        email: 'manager@flexirent.com',
        password: 'manager123',
        role: 'admin',
        phone: '+1111222333',
        address: {
          street: '321 Manager Lane',
          city: 'Manager City',
          state: 'MG',
          zipCode: '11111',
          country: 'USA'
        }
      },
      {
        name: 'Alice Renter',
        email: 'renter@flexirent.com',
        password: 'renter123',
        role: 'customer',
        phone: '+1444555666',
        address: {
          street: '654 Renter Road',
          city: 'Renter City',
          state: 'RT',
          zipCode: '22222',
          country: 'USA'
        }
      }
    ];

    // Insert users
    const createdUsers = await User.insertMany(users);
    
    console.log('✅ Created users:');
    createdUsers.forEach(user => {
      console.log(`   - ${user.name} (${user.email}) - Role: ${user.role}`);
    });

    console.log('\n🎉 Database seeded successfully!');
    console.log('\n📋 Test Credentials:');
    console.log('   Admin: admin@flexirent.com / admin123');
    console.log('   EndUser: enduser@flexirent.com / password123');
    console.log('   Customer: customer@flexirent.com / password123');
    console.log('   Manager: manager@flexirent.com / manager123');
    console.log('   Renter: renter@flexirent.com / renter123');
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Error seeding database:', error);
    process.exit(1);
  }
};

seedUsers();
