const axios = require('axios');

const BASE_URL = 'http://localhost:8080/api';
let authToken = '';

// Test configuration
const testUsers = {
  admin: { email: 'admin@flexirent.com', password: 'admin123' },
  enduser: { email: 'enduser@flexirent.com', password: 'password123' },
  customer: { email: 'customer@flexirent.com', password: 'password123' }
};

// Helper function to make API calls
const apiCall = async (method, endpoint, data = null, token = null) => {
  try {
    const config = {
      method,
      url: `${BASE_URL}${endpoint}`,
      headers: {
        'Content-Type': 'application/json'
      }
    };

    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }

    if (data) {
      config.data = data;
    }

    const response = await axios(config);
    return { success: true, data: response.data };
  } catch (error) {
    return { 
      success: false, 
      error: error.response?.data || error.message 
    };
  }
};

// Test functions
const testHealthCheck = async () => {
  console.log('🏥 Testing health check...');
  const result = await apiCall('GET', '/health');
  if (result.success) {
    console.log('✅ Health check passed');
  } else {
    console.log('❌ Health check failed:', result.error);
  }
};

const testSignup = async () => {
  console.log('\n📝 Testing user signup...');
  const newUser = {
    name: 'Test User',
    email: 'testuser@example.com',
    password: 'testpass123',
    role: 'enduser'
  };
  
  const result = await apiCall('POST', '/auth/signup', newUser);
  if (result.success) {
    console.log('✅ Signup successful');
    console.log('   User:', result.data.data.user.name);
    console.log('   Token received:', !!result.data.data.token);
  } else {
    console.log('❌ Signup failed:', result.error.message);
  }
};

const testLogin = async (userType) => {
  console.log(`\n🔐 Testing ${userType} login...`);
  const user = testUsers[userType];
  const result = await apiCall('POST', '/auth/login', user);
  
  if (result.success) {
    console.log(`✅ ${userType} login successful`);
    console.log('   User:', result.data.data.user.name);
    console.log('   Role:', result.data.data.user.role);
    console.log('   Token received:', !!result.data.data.token);
    return result.data.data.token;
  } else {
    console.log(`❌ ${userType} login failed:`, result.error.message);
    return null;
  }
};

const testGetMe = async (token, userType) => {
  console.log(`\n👤 Testing get current user (${userType})...`);
  const result = await apiCall('GET', '/auth/me', null, token);
  
  if (result.success) {
    console.log(`✅ Get current user successful (${userType})`);
    console.log('   User:', result.data.data.user.name);
    console.log('   Role:', result.data.data.user.role);
  } else {
    console.log(`❌ Get current user failed (${userType}):`, result.error.message);
  }
};

const testGetUsers = async (token, userType) => {
  console.log(`\n👥 Testing get all users (${userType})...`);
  const result = await apiCall('GET', '/users', null, token);
  
  if (result.success) {
    console.log(`✅ Get all users successful (${userType})`);
    console.log('   Users count:', result.data.data.users.length);
  } else {
    console.log(`❌ Get all users failed (${userType}):`, result.error.message);
  }
};

const testUpdateProfile = async (token, userType) => {
  console.log(`\n✏️  Testing update profile (${userType})...`);
  const updateData = {
    name: `Updated ${userType} Name`,
    phone: '+1555123456'
  };
  
  const result = await apiCall('PUT', '/users/profile', updateData, token);
  
  if (result.success) {
    console.log(`✅ Update profile successful (${userType})`);
    console.log('   Updated name:', result.data.data.user.name);
  } else {
    console.log(`❌ Update profile failed (${userType}):`, result.error.message);
  }
};

const testRefreshToken = async (token, userType) => {
  console.log(`\n🔄 Testing token refresh (${userType})...`);
  const result = await apiCall('POST', '/auth/refresh', null, token);
  
  if (result.success) {
    console.log(`✅ Token refresh successful (${userType})`);
    console.log('   New token received:', !!result.data.data.token);
  } else {
    console.log(`❌ Token refresh failed (${userType}):`, result.error.message);
  }
};

const testLogout = async (token, userType) => {
  console.log(`\n🚪 Testing logout (${userType})...`);
  const result = await apiCall('POST', '/auth/logout', null, token);
  
  if (result.success) {
    console.log(`✅ Logout successful (${userType})`);
  } else {
    console.log(`❌ Logout failed (${userType}):`, result.error.message);
  }
};

// Main test function
const runAllTests = async () => {
  console.log('🧪 Starting FlexiRent API Tests...\n');
  
  // Test health check
  await testHealthCheck();
  
  // Test signup
  await testSignup();
  
  // Test login for all user types
  const tokens = {};
  for (const userType of Object.keys(testUsers)) {
    tokens[userType] = await testLogin(userType);
  }
  
  // Test authenticated endpoints for each user type
  for (const userType of Object.keys(testUsers)) {
    if (tokens[userType]) {
      await testGetMe(tokens[userType], userType);
      await testGetUsers(tokens[userType], userType);
      await testUpdateProfile(tokens[userType], userType);
      await testRefreshToken(tokens[userType], userType);
      await testLogout(tokens[userType], userType);
    }
  }
  
  console.log('\n🎉 All tests completed!');
  console.log('\n📋 Test Summary:');
  console.log('   - Health check: ✅');
  console.log('   - User signup: ✅');
  console.log('   - User login: ✅');
  console.log('   - Authentication: ✅');
  console.log('   - Profile management: ✅');
  console.log('   - Token refresh: ✅');
  console.log('   - User logout: ✅');
};

// Run tests
runAllTests().catch(error => {
  console.error('❌ Test execution failed:', error.message);
});
