# Frontend Deployment to Cloudflare Pages

## Prerequisites
- Cloudflare account (free tier available)
- GitHub repository with your frontend code
- Node.js 18+ installed

## Method 1: Direct GitHub Integration (Recommended)

### Step 1: Prepare Frontend for Production

1. Update API base URL in frontend to point to your deployed backend:

```javascript
// frontend/src/api-service/axios.js
const API_BASE_URL = 'http://YOUR-BYTEXL-NIMBUS-IP:8080/api';
```

2. Build the frontend:

```bash
cd frontend
npm install
npm run build
```

### Step 2: Deploy to Cloudflare Pages

1. Login to Cloudflare Dashboard
2. Go to **Workers & Pages** → **Create Application** → **Pages**
3. Click **Connect to Git**
4. Select your GitHub repository
5. Configure build settings:
   - **Framework preset:** Vite
   - **Build command:** `npm run build`
   - **Build output directory:** `frontend/dist`
   - **Node version:** 18
6. Click **Save and Deploy**

### Step 3: Configure Custom Domain (Optional)

1. Go to your Pages project settings
2. Click **Custom domains**
3. Add your domain (e.g., `jkart.yourdomain.com`)
4. Follow DNS configuration instructions

---

## Method 2: Manual Deployment via Wrangler CLI

### Step 1: Install Wrangler

```bash
npm install -g wrangler
```

### Step 2: Login to Cloudflare

```bash
wrangler login
```

### Step 3: Build and Deploy

```bash
cd frontend
npm run build
wrangler pages deploy dist --project-name=jkart-frontend
```

---

## Environment Variables in Cloudflare Pages

1. Go to your Pages project → **Settings** → **Environment variables**
2. Add production variables if needed:
   ```
   VITE_API_URL=http://YOUR-BACKEND-IP:8080/api
   ```

---

## Verify Deployment

1. Visit your Cloudflare Pages URL (e.g., `https://jkart.pages.dev`)
2. Test user registration, login, product browsing
3. Verify API calls reach your ByteXL Nimbus backend

---

## Troubleshooting

### CORS Issues
If you get CORS errors, update API Gateway CORS configuration:

```yaml
# microservice-backend/api-gateway/src/main/resources/application-docker.yml
spring:
  cloud:
    gateway:
      globalcors:
        corsConfigurations:
          '[/**]':
            allowedOrigins: "https://jkart.pages.dev"
            allowedMethods: "*"
            allowedHeaders: "*"
            allowCredentials: true
```

### API Not Reachable
- Ensure ByteXL Nimbus backend is accessible from Cloudflare
- Check firewall rules allow port 8080
- Verify API Gateway is running: `http://YOUR-IP:8080/actuator/health`
