# JKart Production Deployment Guide

## 🚀 Quick Start (Single Command Deployment)

### Prerequisites
- Docker & Docker Compose installed
- MongoDB Atlas account (free tier)
- Mailtrap account (free tier for email testing)
- Git installed

### Step 1: Clone Repository

```bash
git clone https://github.com/YOUR_USERNAME/jkart.git
cd jkart
```

### Step 2: Configure Environment Variables

```bash
# Copy environment template
cp .env.example .env

# Edit .env file with your credentials
# - MongoDB Atlas connection strings (5 databases)
# - JWT secret key (minimum 256 bits)
# - Mailtrap SMTP credentials
```

### Step 3: Deploy (One Command!)

**Linux/Mac:**
```bash
chmod +x deploy.sh
./deploy.sh
```

**Windows:**
```powershell
.\deploy.ps1
```

### Step 4: Verify Deployment

1. **Eureka Dashboard:** http://localhost:8761
   - Verify all 8 services are registered
   
2. **API Gateway Health:** http://localhost:8080/actuator/health
   - Should return `{"status":"UP"}`

3. **Test Registration:**
   ```bash
   curl -X POST http://localhost:8080/api/auth/register \
     -H "Content-Type: application/json" \
     -d '{"email":"test@test.com","password":"Test@1234","firstName":"Test","lastName":"User"}'
   ```

---

## 📦 Architecture Overview

All 9 microservices run in a single Docker Compose instance:

```
┌─────────────────────────────────────────┐
│         Docker Compose Instance         │
├─────────────────────────────────────────┤
│  Port 8761: Service Registry (Eureka)   │
│  Port 8080: API Gateway                 │
│  Port 9030: Auth Service                │
│  Port 9050: User Service                │
│  Port 9000: Category Service            │
│  Port 9010: Product Service             │
│  Port 9060: Cart Service                │
│  Port 9070: Order Service               │
│  Port 9020: Notification Service        │
└─────────────────────────────────────────┘
         ↕
  MongoDB Atlas (Cloud)
```

---

## 🔧 Deployment Options

### Option 1: ByteXL Nimbus (College Platform)

1. **Upload to ByteXL Nimbus:**
   ```bash
   # Compose the project
   tar -czf jkart.tar.gz \
     docker-compose.yml \
     .env \
     microservice-backend/ \
     deploy.sh
   ```

2. **Deploy on ByteXL Nimbus:**
   - Upload `jkart.tar.gz` to ByteXL Nimbus
   - Run: `./deploy.sh`
   - Platform will expose ports 8080-9070

3. **Update Frontend API URL:**
   ```javascript
   // frontend/src/api-service/axios.js
   const API_BASE_URL = 'http://YOUR-BYTEXL-IP:8080/api';
   ```

### Option 2: Any VPS/Cloud Server (AWS, DigitalOcean, etc.)

1. **Provision Server:**
   - Minimum: 4GB RAM, 2 vCPUs
   - Ubuntu 20.04+ recommended

2. **Install Docker:**
   ```bash
   curl -fsSL https://get.docker.com | sh
   sudo usermod -aG docker $USER
   ```

3. **Deploy:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/jkart.git
   cd jkart
   cp .env.example .env
   # Edit .env with production credentials
   ./deploy.sh
   ```

### Option 3: Frontend on Cloudflare Pages

**See [FRONTEND_DEPLOYMENT.md](FRONTEND_DEPLOYMENT.md) for detailed Cloudflare deployment instructions.**

Quick steps:
1. Build frontend: `cd frontend && npm run build`
2. Deploy to Cloudflare Pages via GitHub integration
3. Set `VITE_API_URL` environment variable to backend URL

---

## 🛠️ Management Commands

### View Service Status
```bash
docker-compose ps
```

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f auth-service
```

### Restart Services
```bash
# All services
docker-compose restart

# Specific service
docker-compose restart auth-service
```

### Stop All Services
```bash
./stop.sh        # Linux/Mac
.\stop.ps1       # Windows
```

### Rebuild Services
```bash
docker-compose up -d --build
```

### Update to Latest Code
```bash
git pull
./deploy.sh
```

---

## 🔐 Security Checklist

- [ ] Change default JWT secret in `.env`
- [ ] Use strong MongoDB passwords
- [ ] Enable MongoDB Atlas IP whitelist
- [ ] Use production SMTP credentials (not Mailtrap)
- [ ] Enable HTTPS for API Gateway (reverse proxy with Nginx/Let's Encrypt)
- [ ] Set up firewall rules (only expose ports 8080 and 8761)
- [ ] Enable MongoDB authentication
- [ ] Rotate JWT secret periodically

---

## 📊 Monitoring

### Health Checks
All services expose Actuator health endpoints:

```bash
# Check all services
for port in 8761 8080 9030 9050 9000 9010 9060 9070 9020; do
  echo "Port $port: $(curl -s http://localhost:$port/actuator/health)"
done
```

### Eureka Dashboard
Visit http://localhost:8761 to see:
- Registered services
- Service status (UP/DOWN)
- Instance count
- Health check status

---

## 🐛 Troubleshooting

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
- Ensure database names match: `js_auth_service`, `js_category_service`, etc.

### Port Already in Use
```bash
# Find process using port
lsof -i :8080   # Linux/Mac
netstat -ano | findstr :8080   # Windows

# Kill process
kill -9 <PID>   # Linux/Mac
taskkill /PID <PID> /F   # Windows
```

### High Memory Usage
- Limit Java heap in Dockerfile:
  ```dockerfile
  CMD ["java", "-Xmx512m", "-jar", "app.jar"]
  ```

### CORS Errors
Update API Gateway CORS configuration to allow your frontend domain.

---

## 📈 Performance Optimization

### Production Dockerfile Changes
Add JVM flags for container optimization:

```dockerfile
CMD ["java", \
  "-Xmx512m", \
  "-Xms256m", \
  "-XX:+UseContainerSupport", \
  "-XX:MaxRAMPercentage=75.0", \
  "-jar", "app.jar"]
```

### Database Indexing
Create indexes for frequently queried fields:

```javascript
// Products collection
db.products.createIndex({ name: "text", description: "text" })
db.products.createIndex({ categoryId: 1 })

// Users collection
db.users.createIndex({ email: 1 }, { unique: true })
```

---

## 🎯 Next Steps After Deployment

1. **Seed Database:** Add sample products and categories
2. **Set Up Monitoring:** Integrate Prometheus + Grafana
3. **Enable HTTPS:** Use Nginx reverse proxy with Let's Encrypt
4. **Backup Strategy:** Configure MongoDB Atlas automated backups
5. **Load Testing:** Test with Apache JMeter or k6
6. **CI/CD:** Set up automated deployment with GitHub Actions

---

## 📞 Support

For issues or questions:
- Check logs: `docker-compose logs -f`
- Review Eureka Dashboard: http://localhost:8761
- Consult service-specific documentation in `/microservice-backend/`

---

**🎉 Congratulations! Your JKart platform is production-ready!**
