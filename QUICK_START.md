# 🚀 Quick Start Guide - JNexus Commerce

## ⚡ Fast Track (10 Minutes)

### Step 1: Set Up MongoDB Atlas (5 minutes)
1. Go to: https://www.mongodb.com/cloud/atlas/register
2. Sign up (FREE)
3. Create a FREE M0 Shared Cluster
4. Create database user with username/password
5. Whitelist IP: Add `0.0.0.0/0` (allow from anywhere)
6. Click "Connect" → "Drivers" → Copy connection string

### Step 2: Configure Project (1 minute)
**Option A - Automated (Recommended):**
```powershell
# In PowerShell, navigate to project folder
.\configure-mongodb.ps1
# Paste your MongoDB connection string when prompted
```

**Option B - Manual:**
- See `MONGODB_SETUP_GUIDE.md` for detailed instructions
- Update 5 files in `microservice-backend/*/src/main/resources/application.yml`

### Step 3: Install Prerequisites (if not already installed)
- **JDK 17 or 21**: https://adoptium.net/
- **Maven**: https://maven.apache.org/download.cgi
- **Node.js 18+**: https://nodejs.org/

### Step 4: Run the Application

**Terminal 1 - Service Registry:**
```bash
cd microservice-backend/service-registry
mvn spring-boot:run
```

**Terminal 2 - API Gateway:**
```bash
cd microservice-backend/api-gateway
mvn spring-boot:run
```

**Terminal 3 - Auth Service:**
```bash
cd microservice-backend/auth-service
mvn spring-boot:run
```

**Terminal 4 - Category Service:**
```bash
cd microservice-backend/category-service
mvn spring-boot:run
```

**Terminal 5 - Product Service:**
```bash
cd microservice-backend/product-service
mvn spring-boot:run
```

**Terminal 6 - Cart Service:**
```bash
cd microservice-backend/cart-service
mvn spring-boot:run
```

**Terminal 7 - Order Service:**
```bash
cd microservice-backend/order-service
mvn spring-boot:run
```

**Terminal 8 - Frontend:**
```bash
cd frontend
npm install
npm run dev
```

### Step 5: Access the Application
- **Frontend**: http://localhost:5173
- **API Gateway**: http://localhost:8080
- **Eureka Dashboard**: http://localhost:8761

---

## 📋 Service Ports Reference

| Service | Port |
|---------|------|
| Service Registry (Eureka) | 8761 |
| API Gateway | 8080 |
| Category Service | 9000 |
| Product Service | 9010 |
| Auth Service | 9030 |
| Cart Service | 9060 |
| Order Service | 9070 |
| Frontend | 5173 |

---

## 🗄️ Database Names

| Service | MongoDB Database |
|---------|------------------|
| Auth Service | js_auth_service |
| Category Service | js_category_service |
| Product Service | js_product_service |
| Cart Service | js_cart_service |
| Order Service | js_order_service |

---

## ❓ Troubleshooting

### MongoDB Connection Issues
- Check username/password in connection string
- Verify IP is whitelisted in MongoDB Atlas
- Ensure cluster is running (not paused)

### Port Already in Use
- Kill the process using the port or change the port in application.yml

### Frontend Can't Connect to Backend
- Ensure API Gateway is running on port 8080
- Check `frontend/src/api-service/apiConfig.jsx` has correct URL

### Maven Build Fails
- Ensure JDK 17+ is installed: `java -version`
- Ensure Maven is installed: `mvn -version`

### npm Install Fails
- Ensure Node.js 18+ is installed: `node -version`
- Try: `npm cache clean --force` then `npm install`

---

## 📚 Sample Data

Import sample data from `sample-data/` folder into MongoDB:
- `purely_category_service.categories.json`
- `purely_product_service.products.json`

Use MongoDB Compass or mongosh to import.

---

## 🎯 What's Next?

1. ✅ MongoDB Atlas setup
2. ✅ Configure connection strings
3. ✅ Start all services
4. ✅ Access application at http://localhost:5173
5. 🎉 Start testing the e-commerce platform!

---

## 📖 Additional Resources

- Detailed setup guide: `MONGODB_SETUP_GUIDE.md`
- Project README: `README.md`
- LaTeX fixes: `ecomm_output/FIXES_APPLIED.md`

---

**Need Help?** Check the troubleshooting section or refer to the detailed guides!
