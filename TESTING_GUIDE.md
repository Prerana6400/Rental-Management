# 🧪 **Complete Testing Guide for FlexiRent**

## 🎯 **Testing Checklist**

### **✅ Backend Database Testing**
### **✅ Frontend Integration Testing**
### **✅ API Endpoint Testing**
### **✅ Authentication Flow Testing**

---

## 🚀 **Step 1: Start Both Servers**

### **Terminal 1 - Backend Server**
```bash
cd Rental-Management/backend
npm run dev
```

**Expected Output:**
```
🚀 Server running on port 8080
📡 API available at http://localhost:8080
🔗 Frontend should connect to http://localhost:8080/api
✅ MongoDB Connected Successfully
```

### **Terminal 2 - Frontend Server**
```bash
cd Rental-Management/FlexiRent
npm run dev
```

**Expected Output:**
```
  VITE v5.4.19  ready in 1000 ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: use --host to expose
  ➜  press h + enter to show help
```

---

## 🧪 **Step 2: Backend Database Testing**

### **2.1 Test Database Connection**
```bash
# In backend directory
npm test
```

**Expected Results:**
- ✅ Health check: `http://localhost:8080/api/health`
- ✅ User signup: Create new user
- ✅ User login: Authenticate with credentials
- ✅ Authentication: JWT token validation
- ✅ Profile management: Update user profile
- ✅ Token refresh: Refresh expired tokens
- ✅ User logout: Clear authentication

### **2.2 Test Database Seeding**
```bash
# In backend directory
npm run seed
```

**Expected Output:**
```
✅ Connected to MongoDB
🗑️  Cleared existing users
✅ Created users:
   - Admin User (admin@flexirent.com) - Role: admin
   - John User (user@flexirent.com) - Role: user
   - Sarah Smith (sarah@flexirent.com) - Role: user
   - Mike Johnson (mike@flexirent.com) - Role: user
   - Alice Wilson (alice@flexirent.com) - Role: user

📋 Test Credentials:
   Admin: admin@flexirent.com / admin123
   User: user@flexirent.com / password123
   User: sarah@flexirent.com / password123
   User: mike@flexirent.com / password123
   User: alice@flexirent.com / password123
```

### **2.3 Manual API Testing**

#### **Test Health Check**
```bash
curl http://localhost:8080/api/health
```

**Expected Response:**
```json
{
  "success": true,
  "message": "FlexiRent API is running",
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

#### **Test Admin Login**
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "admin@flexirent.com", "password": "admin123"}'
```

**Expected Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": "...",
      "name": "Admin User",
      "email": "admin@flexirent.com",
      "role": "admin"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

#### **Test User Login**
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "user@flexirent.com", "password": "password123"}'
```

---

## 🌐 **Step 3: Frontend Integration Testing**

### **3.1 Open Browser**
Navigate to: `http://localhost:5173`

### **3.2 Test Login Page**
1. **Check UI Elements:**
   - ✅ Login form with email/password fields
   - ✅ User/Admin tabs
   - ✅ Test credentials displayed
   - ✅ Error handling area

2. **Test Admin Login:**
   - Email: `admin@flexirent.com`
   - Password: `admin123`
   - Expected: Redirect to marketplace

3. **Test User Login:**
   - Email: `user@flexirent.com`
   - Password: `password123`
   - Expected: Redirect to marketplace

4. **Test Error Handling:**
   - Try invalid credentials
   - Expected: Error message displayed

### **3.3 Test Browser Console**
Open Developer Tools (F12) and check:

**Network Tab:**
- ✅ API calls to `http://localhost:8080/api/auth/login`
- ✅ JWT token in request headers
- ✅ Successful responses (200 status)

**Console Tab:**
- ✅ No JavaScript errors
- ✅ API service logs
- ✅ Authentication success messages

**Application Tab:**
- ✅ JWT token stored in localStorage
- ✅ User data in session storage

---

## 🔍 **Step 4: Database Verification**

### **4.1 Check MongoDB Connection**
```bash
# Connect to MongoDB shell
mongosh
use flexirent
db.users.find()
```

**Expected Output:**
```javascript
[
  {
    "_id": ObjectId("..."),
    "name": "Admin User",
    "email": "admin@flexirent.com",
    "role": "admin",
    "isActive": true,
    "createdAt": ISODate("2024-01-01T00:00:00.000Z")
  },
  {
    "_id": ObjectId("..."),
    "name": "John User",
    "email": "user@flexirent.com",
    "role": "user",
    "isActive": true,
    "createdAt": ISODate("2024-01-01T00:00:00.000Z")
  }
  // ... more users
]
```

### **4.2 Verify User Roles**
```javascript
// Check admin users
db.users.find({role: "admin"})

// Check regular users
db.users.find({role: "user"})

// Check user count
db.users.countDocuments()
```

---

## 🛠️ **Step 5: Troubleshooting Commands**

### **5.1 Backend Issues**
```bash
# Check if MongoDB is running
netstat -an | findstr 27017

# Check if port 8080 is available
netstat -an | findstr 8080

# Restart backend server
npm run dev

# Clear and reseed database
npm run seed
```

### **5.2 Frontend Issues**
```bash
# Clear npm cache
npm cache clean --force

# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install

# Start development server
npm run dev
```

### **5.3 Database Issues**
```bash
# Start MongoDB (if not running)
mongod

# Connect to database
mongosh
use flexirent

# Check collections
show collections

# Check users
db.users.find().pretty()
```

---

## 📊 **Step 6: Success Criteria**

### **✅ Backend Success Indicators**
- [ ] Server starts without errors
- [ ] MongoDB connection successful
- [ ] API endpoints responding (200 status)
- [ ] JWT tokens generated correctly
- [ ] User authentication working
- [ ] Database seeding successful

### **✅ Frontend Success Indicators**
- [ ] Development server starts
- [ ] Login page loads correctly
- [ ] API calls successful (no CORS errors)
- [ ] Authentication flow works
- [ ] User data stored in context
- [ ] Navigation between pages works

### **✅ Integration Success Indicators**
- [ ] Frontend can connect to backend
- [ ] Real API calls instead of mock data
- [ ] JWT tokens stored and used
- [ ] Error handling works
- [ ] Loading states display correctly

---

## 🚨 **Common Issues & Solutions**

### **Issue 1: MongoDB Connection Failed**
**Solution:**
```bash
# Start MongoDB service
mongod

# Or install MongoDB if not installed
# Download from: https://www.mongodb.com/try/download/community
```

### **Issue 2: Port Already in Use**
**Solution:**
```bash
# Kill process using port 8080
netstat -ano | findstr 8080
taskkill /PID <PID> /F

# Or change port in backend/app.js
const PORT = process.env.PORT || 3000;
```

### **Issue 3: CORS Errors**
**Solution:**
Check `backend/app.js` CORS configuration:
```javascript
app.use(cors({
  origin: ['http://localhost:5173', 'http://localhost:3000'],
  credentials: true
}));
```

### **Issue 4: JWT Token Issues**
**Solution:**
```bash
# Check JWT secret in backend
# Ensure .env file exists with JWT_SECRET
echo "JWT_SECRET=your-secret-key" > .env
```

---

## 🎯 **Final Testing Checklist**

- [ ] **Backend server running** on port 8080
- [ ] **Frontend server running** on port 5173
- [ ] **MongoDB connected** and seeded
- [ ] **API endpoints responding** correctly
- [ ] **Login functionality** working
- [ ] **User roles** properly assigned
- [ ] **JWT authentication** working
- [ ] **Error handling** functioning
- [ ] **Database operations** successful
- [ ] **Frontend-backend integration** complete

---

**🎉 If all tests pass, your FlexiRent application is fully integrated and ready!**
