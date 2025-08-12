# 🏠 FlexiRent – Smart Rental Management Platform

**FlexiRent** is a unified **web & mobile ecosystem** for efficient rental management.  
It connects **shopkeepers** and **customers** through a modern website, while providing an **Admin Analytics App** for monitoring and insights — all powered by a **single MongoDB database**.

---

## 🚀 Overview

FlexiRent streamlines the rental process for both providers and consumers while enabling real-time analytics for admins.  
The platform consists of:

1. **Website** – For shopkeepers to list rentals & for customers to browse and book.
2. **Admin Mobile App** – Analytics dashboard for admins with sales, user activity, and top product stats.
3. **Single Unified Backend** – Node.js + Express API connected to MongoDB Atlas.
4. **Single Database** – Centralized MongoDB instance for all modules.

---

## ✨ Key Features

### 🌐 Website (Shopkeepers & Customers)
- User-friendly product listing and search
- Category-based rental browsing
- Booking and order tracking
- Secure authentication & authorization

### 📊 Admin Analytics App
- **Total Sales** overview
- **Active Users** count
- **Top-Selling Products/Services** chart
- Role-based admin login
- Real-time data synced from the same MongoDB database

### 🔗 Backend
- Node.js + Express REST API
- Unified DB connection for both web and mobile apps
- JWT-based authentication
- Role-based access control

---

## 🛠 Tech Stack

| Module        | Technology Used |
|--------------|-----------------|
| **Frontend (Website)** | HTML, CSS, JavaScript / Vite + React |
| **Frontend (Admin App)** | Flutter |
| **Backend** | Node.js, Express.js |
| **Database** | MongoDB Atlas |
| **Hosting** | Vercel / Netlify (Frontend), Render / Railway / Heroku (Backend) |
| **Version Control** | Git + GitHub |

---

## 🏗 Architecture

[ Website Frontend ] →

[ Unified Backend API ] → [ MongoDB Atlas ]
/
[ Admin App Frontend ] →

yaml
Copy
Edit

---

## ⚡ Getting Started

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/<your-username>/FlexiRent.git
cd FlexiRent
2️⃣ Install Dependencies
For backend:

bash
Copy
Edit
cd backend
npm install
For frontend (website):

bash
Copy
Edit
cd ../frontend
npm install
For admin app:

bash
Copy
Edit
cd ../admin-app
flutter pub get
3️⃣ Configure Environment
Create a .env file in backend/:

ini
Copy
Edit
MONGO_URI=your_mongodb_connection_string
JWT_SECRET=your_secret_key
PORT=5000
4️⃣ Run the Backend
bash
Copy
Edit
cd backend
npm start
5️⃣ Run the Website
bash
Copy
Edit
cd frontend
npm run dev
6️⃣ Run the Admin App
bash
Copy
Edit
cd admin-app
flutter run
📊 Hackathon Value Proposition
Unified Platform → One DB for both user-facing and admin apps.

Scalability → MongoDB Atlas for easy cloud scaling.

Data-Driven Decisions → Real-time analytics dashboard for admins.

User-Centric Design → Smooth, responsive UI for both website and app.

Security → JWT auth, role-based access, and protected routes.

🏆 Hackathon Pitch
"FlexiRent bridges the gap between rental providers and consumers, while giving admins full control and insights — all under one roof. It’s scalable, secure, and hackathon-ready."

