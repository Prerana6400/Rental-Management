# 🏠 FlexiRent - Rental Management System
## Integration & Setup Guide

---

## 📊 **Project Status: PARTIALLY INTEGRATED**

### ✅ **What's Working**
- **Backend API**: Complete Node.js/Express server with JWT authentication
- **Frontend UI**: Modern React/TypeScript application with beautiful UI
- **API Service**: Frontend has API service configured to connect to backend
- **Database**: MongoDB with seeded test users
- **CORS**: Properly configured for frontend-backend communication

### ⚠️ **What Needs Integration**
- **Authentication**: Frontend currently uses mock login instead of real API calls
- **Data Flow**: Frontend uses mock data instead of fetching from backend
- **Real-time Updates**: Need to connect real API endpoints

---

## 🚀 **How to Run the Project**

### **Prerequisites**
- Node.js (v14 or higher)
- MongoDB (running locally)
- npm or yarn

### **Step 1: Start Backend Server**

```bash
# Navigate to backend directory
cd Rental-Management/backend

# Install dependencies
npm install

# Seed database with test users
npm run seed

# Start development server
npm run dev
```

**Backend will run on**: `http://localhost:8080`

**Test Users Created**:
- **Admin**: `admin@flexirent.com` / `admin123`
- **Customer**: `customer@flexirent.com` / `password123`
- **EndUser**: `enduser@flexirent.com` / `password123`

### **Step 2: Start Frontend Application**

```bash
# Open new terminal and navigate to frontend
cd Rental-Management/FlexiRent

# Install dependencies
npm install

# Start development server
npm run dev
```

**Frontend will run on**: `http://localhost:5173`

---

## 🔗 **Current Integration Points**

### **1. API Configuration** ✅
```javascript
// FlexiRent/src/services/api.js
const API_BASE_URL = 'http://localhost:8080/api';
```

### **2. CORS Setup** ✅
```javascript
// backend/app.js
app.use(cors({
  origin: ['http://localhost:5173', 'http://localhost:3000'],
  credentials: true
}));
```

### **3. Available API Endpoints** ✅
- `POST /api/auth/login` - User login
- `POST /api/auth/signup` - User registration
- `GET /api/auth/me` - Get current user
- `GET /api/users` - Get all users (admin)
- `PUT /api/users/profile` - Update profile

---

## 🔧 **Integration Tasks Needed**

### **Task 1: Connect Real Authentication**
**File**: `FlexiRent/src/pages/Login.tsx`

**Current (Mock)**:
```typescript
const handleLogin = (role: 'customer' | 'admin') => {
  const mockUser = { id: '1', name: 'John', role };
  setUser(mockUser);
};
```

**Needed (Real API)**:
```typescript
const handleLogin = async (email: string, password: string) => {
  try {
    const response = await apiService.login({ email, password });
    if (response.success) {
      setUser(response.data.user);
      setCurrentPage('marketplace');
    }
  } catch (error) {
    // Handle error
  }
};
```

### **Task 2: Connect Product Data**
**File**: `FlexiRent/src/context/AppContext.tsx`

Replace mock products with API calls to fetch real data from backend.

### **Task 3: Connect User Management**
Replace mock user management with real API calls for user CRUD operations.

---

## 🧪 **Testing the Integration**

### **1. Test Backend API**
```bash
# In backend directory
npm test
```

### **2. Test Frontend-Backend Connection**
1. Start both servers
2. Open browser to `http://localhost:5173`
3. Try logging in with test credentials
4. Check browser console for API calls

### **3. API Health Check**
Visit: `http://localhost:8080/api/health`

Expected response:
```json
{
  "success": true,
  "message": "FlexiRent API is running",
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

---

## 📁 **Project Structure**

```
Rental-Management/
├── backend/                 # Node.js/Express API
│   ├── app.js              # Main server file
│   ├── models/             # MongoDB models
│   ├── routes/             # API routes
│   ├── middleware/         # Auth middleware
│   └── scripts/            # Database seeding
└── FlexiRent/              # React/TypeScript Frontend
    ├── src/
    │   ├── components/     # UI components
    │   ├── pages/          # Page components
    │   ├── services/       # API service
    │   └── context/        # React context
    └── package.json
```

---

## 🎯 **Next Steps for Full Integration**

1. **Update Login Component**: Replace mock authentication with real API calls
2. **Connect Product Data**: Fetch products from backend instead of using mock data
3. **Implement Real-time Updates**: Connect cart and order management to backend
4. **Add Error Handling**: Implement proper error handling for API failures
5. **Add Loading States**: Show loading indicators during API calls
6. **Implement Token Refresh**: Handle JWT token expiration

---

## 🐛 **Troubleshooting**

### **Backend Issues**
- **MongoDB Connection**: Ensure MongoDB is running on `mongodb://127.0.0.1:27017`
- **Port Conflicts**: Check if port 8080 is available
- **Dependencies**: Run `npm install` in backend directory

### **Frontend Issues**
- **Port Conflicts**: Check if port 5173 is available
- **API Connection**: Verify backend is running on port 8080
- **CORS Errors**: Check browser console for CORS issues

### **Integration Issues**
- **API Calls Failing**: Check network tab in browser dev tools
- **Authentication**: Verify JWT tokens are being sent correctly
- **Data Not Loading**: Check if API endpoints are responding

---

## 📞 **Support**

If you encounter issues:
1. Check server logs in both terminals
2. Verify MongoDB is running
3. Check browser console for errors
4. Test API endpoints directly with tools like Postman
5. Ensure all environment variables are set correctly

---

**Happy coding! 🎉**
