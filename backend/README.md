# FlexiRent Backend API

A complete Node.js/Express backend for the FlexiRent rental management system with JWT authentication and role-based access control.

## 🚀 Features

- **🔐 JWT Authentication** - Secure token-based authentication
- **👥 Role-Based Access Control** - Three user roles: `enduser`, `customer`, `admin`
- **🛡️ Security** - Password hashing with bcrypt, input validation
- **📊 User Management** - Complete CRUD operations for users
- **🔄 Token Refresh** - Automatic token refresh mechanism
- **🌐 CORS Enabled** - Frontend integration ready
- **📝 Comprehensive API** - RESTful endpoints with proper error handling

## 👥 User Roles

1. **enduser** - Default role for new registrations (can be upgraded to admin)
2. **customer** - Customers who can rent items
3. **admin** - Administrators with full access to manage users and system

## 🛠️ Tech Stack

- **Node.js** - Runtime environment
- **Express.js** - Web framework
- **MongoDB** - Database
- **Mongoose** - ODM for MongoDB
- **JWT** - Authentication tokens
- **bcryptjs** - Password hashing
- **CORS** - Cross-origin resource sharing

## 📋 Prerequisites

- Node.js (v14 or higher)
- MongoDB (running locally or cloud instance)
- npm or yarn

## 🚀 Quick Start

### 1. Install Dependencies

```bash
cd Rental-Management/backend
npm install
```

### 2. Environment Setup

Create a `.env` file in the backend directory:

```env
JWT_SECRET=your-super-secret-jwt-key-2024
NODE_ENV=development
PORT=8080
MONGODB_URI=mongodb://127.0.0.1:27017/flexirent
```

### 3. Start MongoDB

Make sure MongoDB is running on your system.

### 4. Start Server

```bash
# Development mode (with auto-reload)
npm run dev

# Production mode
npm start
```

The server will start on `http://localhost:8080`

Admin bootstrap: On first run, the server ensures an admin exists using env vars (or defaults):
- Email: `ADMIN_EMAIL` (default: `admin@flexirent.com`)
- Password: `ADMIN_PASSWORD` (default: `admin123`)
- Name: `ADMIN_NAME` (default: `Admin User`)

### 5. Test API

```bash
npm test
```

## 📡 API Endpoints

### Authentication (`/api/auth`)

| Method | Endpoint | Description | Access |
|--------|----------|-------------|---------|
| POST | `/signup` | Register new user | Public |
| POST | `/login` | User login | Public |
| GET | `/me` | Get current user | Private |
| POST | `/logout` | User logout | Private |
| POST | `/refresh` | Refresh token | Private |

### User Management (`/api/users`)

| Method | Endpoint | Description | Access |
|--------|----------|-------------|---------|
| GET | `/` | Get all users | Admin |
| GET | `/role/:role` | Get users by role | Admin |
| GET | `/:id` | Get user by ID | Private |
| PUT | `/profile` | Update profile | Private |
| PUT | `/:id/role` | Update user role | Admin |
| PUT | `/:id/status` | Activate/deactivate user | Admin |
| DELETE | `/:id` | Delete user | Admin |

### System

| Method | Endpoint | Description | Access |
|--------|----------|-------------|---------|
| GET | `/health` | Health check | Public |
| GET | `/` | API info | Public |

## 🔗 Frontend Integration

### 1. API Service

The frontend includes a complete API service (`src/services/api.js`) that handles:

- Authentication token management
- Automatic token storage in localStorage
- Request/response handling
- Error management

### 2. Usage in React Components

```javascript
import apiService from '../services/api';

// Login
const handleLogin = async (email, password) => {
  try {
    const response = await apiService.login({ email, password });
    if (response.success) {
      // User is now logged in
      console.log('User:', response.data.user);
    }
  } catch (error) {
    console.error('Login failed:', error.message);
  }
};

// Get current user
const getCurrentUser = async () => {
  try {
    const response = await apiService.getCurrentUser();
    return response.data.user;
  } catch (error) {
    console.error('Failed to get user:', error.message);
  }
};

// Check if authenticated
if (apiService.isAuthenticated()) {
  // User is logged in
}
```

### 3. Update Your Frontend Components

Replace mock authentication in your React components:

**Before (mock):**
```javascript
const handleLogin = (role) => {
  const mockUser = { id: '1', name: 'John', role };
  setUser(mockUser);
};
```

**After (real API):**
```javascript
const handleLogin = async (email, password) => {
  try {
    const response = await apiService.login({ email, password });
    if (response.success) {
      setUser(response.data.user);
      setCurrentPage('marketplace');
    }
  } catch (error) {
    toast({ title: 'Login failed', description: error.message });
  }
};
```

## 🧪 Testing

### Manual Testing

Test the API endpoints using the provided test script:

```bash
npm test
```

### API Testing with Tools

**Using curl:**
```bash
# Login
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "admin@flexirent.com", "password": "admin123"}'

# Get current user (with token)
curl -X GET http://localhost:8080/api/auth/me \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

**Using Postman:**
1. Import the collection (if available)
2. Set base URL: `http://localhost:8080/api`
3. Use the provided test credentials

## 🔧 Development

### Project Structure

```
backend/
├── app.js                 # Main application file
├── models/
│   └── User.js           # User model
├── routes/
│   ├── auth.js           # Authentication routes
│   └── users.js          # User management routes
├── middleware/
│   └── auth.js           # Authentication middleware
├── scripts/
│   └── seedUsers.js      # Database seeding
├── test-api.js           # API testing script
└── package.json
```

### Available Scripts

```bash
npm start          # Start production server
npm run dev        # Start development server (with nodemon)
npm run seed       # Seed database with sample users
npm test           # Run API tests
```

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `JWT_SECRET` | Secret key for JWT tokens | `flexirent-super-secret-jwt-key-2024` |
| `NODE_ENV` | Environment mode | `development` |
| `PORT` | Server port | `8080` |
| `MONGODB_URI` | MongoDB connection string | `mongodb://127.0.0.1:27017/flexirent` |

## 🔒 Security Features

- **Password Hashing** - bcrypt with salt rounds
- **JWT Tokens** - Secure token-based authentication
- **Input Validation** - Comprehensive validation for all inputs
- **Role-Based Access** - Proper authorization checks
- **CORS Protection** - Configured for frontend integration
- **Error Handling** - Secure error responses

## 🚨 Error Handling

The API returns consistent error responses:

```json
{
  "success": false,
  "message": "Error description"
}
```

Common HTTP status codes:
- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `500` - Server Error

## 📊 Database Schema

### User Model

```javascript
{
  name: String (required, 2-50 chars),
  email: String (required, unique, validated),
  password: String (required, min 6 chars, hashed),
  role: String (enum: 'enduser', 'customer', 'admin'),
  phone: String (optional, validated),
  address: {
    street: String,
    city: String,
    state: String,
    zipCode: String,
    country: String
  },
  isActive: Boolean (default: true),
  lastLogin: Date,
  profileImage: String,
  createdAt: Date,
  updatedAt: Date
}
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📝 License

This project is licensed under the MIT License.

## 🆘 Support

If you encounter any issues:

1. Check the server logs for error messages
2. Ensure MongoDB is running
3. Verify all environment variables are set
4. Check the API documentation
5. Run the test suite to verify functionality

---

**Happy coding! 🎉**
