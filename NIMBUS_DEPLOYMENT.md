# ByteXL Nimbus Deployment Guide

## 🚀 Quick Start (Bash Only)

### Step 1: Upload to ByteXL Nimbus

Upload these files to your ByteXL Nimbus platform:
- `docker-compose.yml`
- `.env` (configured with your credentials)
- `deploy.sh`
- `stop.sh`
- `microservice-backend/` (entire folder)

### Step 2: Configure Environment

```bash
# Copy environment template
cp .env.example .env

# Edit .env with your credentials
nano .env
```

**Required:**
- MongoDB Atlas connection strings (5 databases)
- JWT secret key (min 256 bits)
- Mailtrap SMTP credentials

### Step 3: Deploy

```bash
bash deploy.sh
```

That's it! All 9 services will build and start automatically.

---

## 📍 Service Endpoints

After deployment, access services on ByteXL Nimbus:

- **Eureka Dashboard:** `http://YOUR-NIMBUS-IP:8761`
- **API Gateway:** `http://YOUR-NIMBUS-IP:8080`
- **Auth Service:** `http://YOUR-NIMBUS-IP:9030`
- **User Service:** `http://YOUR-NIMBUS-IP:9050`
- **Category Service:** `http://YOUR-NIMBUS-IP:9000`
- **Product Service:** `http://YOUR-NIMBUS-IP:9010`
- **Cart Service:** `http://YOUR-NIMBUS-IP:9060`
- **Order Service:** `http://YOUR-NIMBUS-IP:9070`
- **Notification Service:** `http://YOUR-NIMBUS-IP:9020`

---

## 🛠️ Management Commands

### View Logs
```bash
docker-compose logs -f              # All services
docker-compose logs -f auth-service # Specific service
```

### Stop Services
```bash
bash stop.sh
```

### Restart Services
```bash
docker-compose restart              # All services
docker-compose restart auth-service # Specific service
```

### Rebuild Services
```bash
docker-compose up -d --build
```

### Check Status
```bash
docker-compose ps
```

---

## 🔧 Update Frontend API URL

After deploying backend to ByteXL Nimbus, update your frontend:

```javascript
// frontend/src/api-service/axios.js
const API_BASE_URL = 'http://YOUR-NIMBUS-IP:8080/api';
```

Then deploy frontend to Cloudflare Pages (see FRONTEND_DEPLOYMENT.md).

---

## 🐛 Troubleshooting

### Build Takes Too Long
- First build takes 10-15 minutes (Maven downloads dependencies)
- Subsequent builds are faster with Docker cache

### Port Already in Use
```bash
# Check what's using the port
netstat -tulpn | grep :8080

# Kill the process
kill -9 <PID>
```

### Service Won't Start
```bash
# Check logs
docker-compose logs auth-service

# Rebuild specific service
docker-compose build auth-service
docker-compose up -d auth-service
```

### MongoDB Connection Failed
- Verify connection string in `.env`
- Check MongoDB Atlas IP whitelist (add `0.0.0.0/0` for testing)
- Ensure database names are correct

---

## 📊 Verify Deployment

1. **Check Eureka Dashboard:**
   ```bash
   curl http://localhost:8761
   ```
   Should show all 8 services registered

2. **Test API Gateway:**
   ```bash
   curl http://localhost:8080/actuator/health
   ```
   Should return: `{"status":"UP"}`

3. **Test Registration:**
   ```bash
   curl -X POST http://localhost:8080/api/auth/register \
     -H "Content-Type: application/json" \
     -d '{"email":"test@test.com","password":"Test@1234","firstName":"Test","lastName":"User"}'
   ```

---

## ⚙️ Architecture

All services run in single Docker Compose instance on ByteXL Nimbus:

```
ByteXL Nimbus Server
├── Port 8761: Service Registry
├── Port 8080: API Gateway ← Frontend connects here
├── Port 9030: Auth Service
├── Port 9050: User Service
├── Port 9000: Category Service
├── Port 9010: Product Service
├── Port 9060: Cart Service
├── Port 9070: Order Service
└── Port 9020: Notification Service
         ↕
  MongoDB Atlas (Cloud)
```

---

## 🎯 Next Steps

1. **Deploy Frontend:** See [FRONTEND_DEPLOYMENT.md](FRONTEND_DEPLOYMENT.md)
2. **Configure CORS:** Update API Gateway to allow Cloudflare domain
3. **Test End-to-End:** Registration → Login → Browse → Cart → Order
4. **Monitor:** Check Eureka Dashboard for service health

---

**🎉 Your JKart platform is live on ByteXL Nimbus!**
