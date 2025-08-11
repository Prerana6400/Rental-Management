const axios = require('axios');

const BASE_URL = 'http://localhost:8080/api';

async function simpleTest() {
  try {
    console.log('🧪 Simple API Test...\n');

    // Test 1: Health check
    console.log('1. Testing health check...');
    try {
      const healthResponse = await axios.get(`${BASE_URL}/health`);
      console.log('✅ Health check passed:', healthResponse.data.message);
    } catch (error) {
      console.log('❌ Health check failed:', error.response?.data || error.message);
    }

    // Test 2: Login with admin
    console.log('\n2. Testing admin login...');
    try {
      const loginResponse = await axios.post(`${BASE_URL}/auth/login`, {
        email: 'admin@flexirent.com',
        password: 'admin123'
      });
      console.log('✅ Admin login successful!');
      console.log('   User:', loginResponse.data.data.user.name);
      console.log('   Role:', loginResponse.data.data.user.role);
      console.log('   Token received:', !!loginResponse.data.data.token);
      
      const token = loginResponse.data.data.token;
      
      // Test 3: Get current user
      console.log('\n3. Testing get current user...');
      const meResponse = await axios.get(`${BASE_URL}/auth/me`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      console.log('✅ Get current user successful!');
      console.log('   User:', meResponse.data.data.user.name);
      
    } catch (error) {
      console.log('❌ Login failed:', error.response?.data?.message || error.message);
    }

    // Test 4: Signup new user
    console.log('\n4. Testing user signup...');
    try {
      const signupResponse = await axios.post(`${BASE_URL}/auth/signup`, {
        name: 'Test User',
        email: 'testuser@example.com',
        password: 'testpass123',
        role: 'enduser'
      });
      console.log('✅ Signup successful!');
      console.log('   User:', signupResponse.data.data.user.name);
    } catch (error) {
      console.log('❌ Signup failed:', error.response?.data?.message || error.message);
    }

    console.log('\n🎉 Simple test completed!');

  } catch (error) {
    console.error('❌ Test failed:', error.message);
  }
}

simpleTest();
