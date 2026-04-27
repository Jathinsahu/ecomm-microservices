# JNexus Commerce - How to Run

## Quick Start

### Start All Services (Automated)
```powershell
.\start-all.ps1
```

This script will:
- ✅ Check if Java, Maven, and Node.js are installed
- ✅ Start all 8 backend services in separate windows
- ✅ Install frontend dependencies (first time only)
- ✅ Start the frontend application

### Stop All Services
```powershell
.\stop-all.ps1
```

This will stop all Java and Node.js processes.

---

## Manual Start (If Needed)

If you prefer to start services manually, open separate terminals for each:

### Backend Services

**Terminal 1 - Service Registry:**
```powershell
cd microservice-backend/service-registry
mvn spring-boot:run
```

**Terminal 2 - API Gateway:**
```powershell
cd microservice-backend/api-gateway
mvn spring-boot:run
```

**Terminal 3 - Auth Service:**
```powershell
cd microservice-backend/auth-service
mvn spring-boot:run
```

**Terminal 4 - Category Service:**
```powershell
cd microservice-backend/category-service
mvn spring-boot:run
```

**Terminal 5 - Product Service:**
```powershell
cd microservice-backend/product-service
mvn spring-boot:run
```

**Terminal 6 - Cart Service:**
```powershell
cd microservice-backend/cart-service
mvn spring-boot:run
```

**Terminal 7 - Order Service:**
```powershell
cd microservice-backend/order-service
mvn spring-boot:run
```

**Terminal 8 - User Service:**
```powershell
cd microservice-backend/user-service
mvn spring-boot:run
```

**Terminal 9 - Notification Service:**
```powershell
cd microservice-backend/notification-service
mvn spring-boot:run
```

### Frontend

**Terminal 10 - Frontend:**
```powershell
cd frontend
npm install    # First time only
npm run dev
```

---

## Access URLs

| Service | URL |
|---------|-----|
| Frontend | http://localhost:5173 |
| API Gateway | http://localhost:8080 |
| Eureka Dashboard | http://localhost:8761 |

---

## Service Ports Reference

| Service | Port |
|---------|------|
| Service Registry (Eureka) | 8761 |
| API Gateway | 8080 |
| Category Service | 9000 |
| Product Service | 9010 |
| Auth Service | 9030 |
| User Service | 9040 |
| Notification Service | 9020 |
| Cart Service | 9060 |
| Order Service | 9070 |
| Frontend | 5173 |

---

## First Time Setup

1. MongoDB Atlas is already configured with your credentials
2. Run `.\start-all.ps1` to start everything
3. Wait 30-60 seconds for all services to fully start
4. Open http://localhost:5173 in your browser

---

## Troubleshooting

### Port Already in Use
Run `.\stop-all.ps1` to stop all services, then try starting again.

### Maven Build Fails
- Ensure JDK 17+ is installed: `java -version`
- Ensure Maven is installed: `mvn -version`

### Frontend Doesn't Start
- Ensure Node.js 18+ is installed: `node --version`
- Try: `npm cache clean --force` then `npm install`

### MongoDB Connection Errors
- Check your internet connection
- Verify MongoDB Atlas cluster is running (not paused)
- Check credentials in `microservice-backend/*/src/main/resources/application.yml`

---

## Scripts Created

1. **start-all.ps1** - Starts all services automatically
2. **stop-all.ps1** - Stops all running services
3. **configure-mongodb.ps1** - Helper to configure MongoDB connection strings

---

## Notes

- Each service opens in a new PowerShell window
- You can close individual windows to stop specific services
- The main script window will stay open until you press a key
- Services continue running even after you close the main window
- To completely stop all services, run `stop-all.ps1` or close all terminal windows
