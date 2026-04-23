# JNexus Commerce — Manual Setup & Run Guide

> Step-by-step instructions to configure, run, and deploy the JNexus Commerce platform locally and on AWS.
> Authored by **Jathin Kumar Sahu**

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Cleanup Script (Remove Original Git History)](#2-cleanup-script)
3. [MongoDB Atlas Setup](#3-mongodb-atlas-setup)
4. [Configure Application Properties](#4-configure-application-properties)
5. [Run Locally — Backend Services](#5-run-locally--backend-services)
6. [Run Locally — Frontend](#6-run-locally--frontend)
7. [Verify Everything Is Working](#7-verify-everything-is-working)
8. [Docker Build & Push](#8-docker-build--push)
9. [Terraform — Provision AWS Infrastructure](#9-terraform--provision-aws-infrastructure)
10. [Helm — Deploy to Kubernetes (EKS)](#10-helm--deploy-to-kubernetes-eks)
11. [GitHub Actions CI/CD — Secrets Reference](#11-github-actions-cicd--secrets-reference)
12. [Swagger UI URLs](#12-swagger-ui-urls)
13. [Troubleshooting](#13-troubleshooting)

---

## 1. Prerequisites

Install the following tools before proceeding:

| Tool | Version | Download |
|---|---|---|
| JDK | 21 | https://adoptium.net |
| Apache Maven | 3.9+ | https://maven.apache.org |
| Node.js | 18+ | https://nodejs.org |
| npm | 9+ | Bundled with Node.js |
| Docker Desktop | Latest | https://www.docker.com/products/docker-desktop |
| AWS CLI | v2 | https://aws.amazon.com/cli |
| kubectl | 1.28+ | https://kubernetes.io/docs/tasks/tools |
| Helm | 3.13+ | https://helm.sh/docs/intro/install |
| Terraform | 1.6+ | https://developer.hashicorp.com/terraform/install |
| Git | Latest | https://git-scm.com |

**Verify installations (PowerShell):**
```powershell
java -version
mvn -version
node -v
npm -v
docker -v
aws --version
kubectl version --client
helm version
terraform -version
```

---

## 2. Cleanup Script

Run this PowerShell script once to remove the original git history and take full ownership of the project:

```powershell
# Navigate to project root
cd "c:\Users\imvsa\Downloads\Fullstack-E-commerce-web-application-main\Fullstack-E-commerce-web-application-main"

# Remove original git history
Remove-Item -Recurse -Force .git

# Initialize fresh git repo
git init
git add .
git commit -m "Initial commit — JNexus Commerce by Jathin Kumar Sahu"
```

> After this, push to your own GitHub repository:
> ```powershell
> git remote add origin https://github.com/YOUR_USERNAME/jnexus-commerce.git
> git branch -M main
> git push -u origin main
> ```

---

## 3. MongoDB Atlas Setup

JNexus Commerce uses **5 separate MongoDB databases** — one per service.

### 3.1 Create a Free Cluster

1. Go to [https://cloud.mongodb.com](https://cloud.mongodb.com) and sign in
2. Create a new **Free Tier (M0)** cluster
3. Choose a cloud provider and region (e.g., AWS / ap-south-1)
4. Set a **Database User** with username and password (save these!)
5. Add your IP to the **Network Access** allowlist (or use `0.0.0.0/0` for dev)

### 3.2 Get the Connection String

From the Atlas dashboard:
- Click **Connect** → **Drivers** → choose Java / Node.js
- Copy the connection string — it looks like:
  ```
  mongodb+srv://<username>:<password>@cluster0.xxxxx.mongodb.net/
  ```

### 3.3 Required Database Names

Use these exact database names when updating `application.properties`:

| Service | Database Name |
|---|---|
| auth-service | `js_auth_service` |
| category-service | `js_category_service` |
| product-service | `js_product_service` |
| cart-service | `js_cart_service` |
| order-service | `js_order_service` |

> `notification-service` and `user-service` do **not** use MongoDB directly.

### 3.4 Load Sample Data (Optional)

To pre-populate categories and products:

```powershell
# Replace with your actual connection string
mongoimport --uri "mongodb+srv://<user>:<pass>@cluster0.xxxxx.mongodb.net/js_category_service" `
  --collection categories `
  --file "sample-data\purely_category_service.categories.json" `
  --jsonArray

mongoimport --uri "mongodb+srv://<user>:<pass>@cluster0.xxxxx.mongodb.net/js_product_service" `
  --collection products `
  --file "sample-data\purely_product_service.products.json" `
  --jsonArray
```

---

## 4. Configure Application Properties

Each microservice has an `application.properties` file at:
```
microservice-backend\<service-name>\src\main\resources\application.properties
```

### 4.1 auth-service

```properties
spring.data.mongodb.uri=mongodb+srv://<user>:<pass>@cluster0.xxxxx.mongodb.net/js_auth_service
jwt.secret=<your-256-bit-secret-key>
jwt.expiration=86400000
```

### 4.2 category-service

```properties
spring.data.mongodb.uri=mongodb+srv://<user>:<pass>@cluster0.xxxxx.mongodb.net/js_category_service
```

### 4.3 product-service

```properties
spring.data.mongodb.uri=mongodb+srv://<user>:<pass>@cluster0.xxxxx.mongodb.net/js_product_service
```

### 4.4 cart-service

```properties
spring.data.mongodb.uri=mongodb+srv://<user>:<pass>@cluster0.xxxxx.mongodb.net/js_cart_service
```

### 4.5 order-service

```properties
spring.data.mongodb.uri=mongodb+srv://<user>:<pass>@cluster0.xxxxx.mongodb.net/js_order_service
```

### 4.6 notification-service (Email Config)

```properties
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=your.email@gmail.com
spring.mail.password=your-app-password
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true
```

> For Gmail: enable 2FA and generate an **App Password** from  
> [https://myaccount.google.com/apppasswords](https://myaccount.google.com/apppasswords)

### 4.7 api-gateway / service-registry / user-service

These services typically don't require MongoDB configuration. Check their existing `application.properties` for any other credentials (JWT secret shared key, Eureka URL, etc.) and update as needed.

---

## 5. Run Locally — Backend Services

Open **separate terminal windows** for each service. Start them **in this exact order**:

### Step 1 — service-registry (Eureka Server)
```powershell
cd microservice-backend\service-registry
.\mvnw.cmd spring-boot:run
```
Wait for: `Started ServiceRegistryApplication` — then open [http://localhost:8761](http://localhost:8761)

### Step 2 — api-gateway
```powershell
cd microservice-backend\api-gateway
.\mvnw.cmd spring-boot:run
```
Wait for: `Started ApiGatewayApplication` on port `8080`

### Step 3 — auth-service
```powershell
cd microservice-backend\auth-service
.\mvnw.cmd spring-boot:run
```

### Step 4 — user-service
```powershell
cd microservice-backend\user-service
.\mvnw.cmd spring-boot:run
```

### Step 5 — category-service
```powershell
cd microservice-backend\category-service
.\mvnw.cmd spring-boot:run
```

### Step 6 — product-service
```powershell
cd microservice-backend\product-service
.\mvnw.cmd spring-boot:run
```

### Step 7 — cart-service
```powershell
cd microservice-backend\cart-service
.\mvnw.cmd spring-boot:run
```

### Step 8 — order-service
```powershell
cd microservice-backend\order-service
.\mvnw.cmd spring-boot:run
```

### Step 9 — notification-service
```powershell
cd microservice-backend\notification-service
.\mvnw.cmd spring-boot:run
```

> All services register with Eureka automatically. Confirm by refreshing [http://localhost:8761](http://localhost:8761).

---

## 6. Run Locally — Frontend

### 6.1 Update API Base URL

Open `frontend\src\api-service\apiConfig.jsx` and set the base URL to your local gateway:

```jsx
const BASE_URL = "http://localhost:8080";
export default BASE_URL;
```

> For production/cloud, this would be your AWS ALB DNS or ingress hostname.

### 6.2 Install Dependencies & Start Dev Server

```powershell
cd frontend
npm install
npm run dev
```

The app runs at [http://localhost:5173](http://localhost:5173) by default.

---

## 7. Verify Everything Is Working

Run through this checklist after all services are up:

- [ ] Eureka dashboard shows all 9 services: [http://localhost:8761](http://localhost:8761)
- [ ] Frontend loads at [http://localhost:5173](http://localhost:5173) with "JS Premium" branding
- [ ] User can **register** and **log in**
- [ ] Categories appear on the home page
- [ ] Products load correctly
- [ ] Can **add items to cart**
- [ ] Can **place an order** and receive a confirmation email
- [ ] Swagger UI loads for each service (see [Section 12](#12-swagger-ui-urls))

---

## 8. Docker Build & Push

Build Docker images for each service and push to AWS ECR.

### 8.1 Authenticate with ECR

```powershell
aws ecr get-login-password --region ap-south-1 | `
  docker login --username AWS --password-stdin `
  <YOUR_AWS_ACCOUNT_ID>.dkr.ecr.ap-south-1.amazonaws.com
```

### 8.2 Build & Push — Each Service

Replace `<ACCOUNT_ID>` and `<REGION>` with your values.

```powershell
# Example for auth-service
cd microservice-backend\auth-service
docker build -t js_auth_registry .
docker tag js_auth_registry:latest <ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/js_auth_registry:latest
docker push <ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/js_auth_registry:latest
```

Repeat for each service using these ECR repo names:

| Service | ECR Repository Name |
|---|---|
| api-gateway | `js_gateway_registry` |
| auth-service | `js_auth_registry` |
| cart-service | `js_cart_registry` |
| category-service | `js_category_registry` |
| notification-service | `js_notification_registry` |
| order-service | `js_order_registry` |
| product-service | `js_product_registry` |
| service-registry | `js_registry_registry` |
| user-service | `js_user_registry` |
| frontend | `js_web_registry` |

### 8.3 Build Frontend Docker Image

```powershell
cd frontend
docker build -t js_web_registry .
docker tag js_web_registry:latest <ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/js_web_registry:latest
docker push <ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/js_web_registry:latest
```

---

## 9. Terraform — Provision AWS Infrastructure

All Terraform files are in the `terraform/` directory.

### 9.1 Configure Variables

Edit `terraform/common-variables.tf` and set your values:
- AWS region
- EKS cluster name (`js-commerce-cluster`)
- Node group instance types
- ECR registry names

### 9.2 Initialize & Apply

```powershell
cd terraform

# Initialize providers
terraform init

# Preview changes
terraform plan

# Apply (creates VPC, EKS cluster, ECR repos, IAM roles, etc.)
terraform apply
```

> This takes ~15-20 minutes to complete. Type `yes` when prompted.

### 9.3 Update kubeconfig

After Terraform completes, connect kubectl to your new EKS cluster:

```powershell
aws eks update-kubeconfig --region <REGION> --name js-commerce-cluster
kubectl get nodes
```

---

## 10. Helm — Deploy to Kubernetes (EKS)

All Helm charts are in `helm-charts/`. Deploy in this order:

### 10.1 Service Registry (Eureka)
```powershell
helm upgrade --install service-registry helm-charts\service-registry `
  --set image.repository=<ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/js_registry_registry `
  --set image.tag=latest
```

### 10.2 All Other Backend Services
```powershell
# Repeat this pattern for each service
helm upgrade --install auth-service helm-charts\auth-service `
  --set image.repository=<ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/js_auth_registry `
  --set image.tag=latest `
  --set env.MONGODB_URI="mongodb+srv://..." `
  --set env.JWT_SECRET="your-secret"

helm upgrade --install api-gateway helm-charts\api-gateway `
  --set image.repository=<ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/js_gateway_registry `
  --set image.tag=latest

# ... repeat for category, product, cart, order, notification, user services
```

### 10.3 Frontend
```powershell
helm upgrade --install web-app helm-charts\web-app `
  --set image.repository=<ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/js_web_registry `
  --set image.tag=latest
```

### 10.4 Ingress (ALB)
```powershell
helm upgrade --install ingress-alb helm-charts\ingress-alb
```

### 10.5 Verify Deployments
```powershell
kubectl get pods -A
kubectl get svc -A
kubectl get ingress -A
```

---

## 11. GitHub Actions CI/CD — Secrets Reference

Go to your GitHub repo → **Settings** → **Secrets and variables** → **Actions** and add:

| Secret Name | Value |
|---|---|
| `AWS_ACCESS_KEY_ID` | Your AWS IAM access key |
| `AWS_SECRET_ACCESS_KEY` | Your AWS IAM secret key |
| `AWS_REGION` | e.g., `ap-south-1` |
| `AWS_ACCOUNT_ID` | Your 12-digit AWS account ID |
| `EKS_CLUSTER_NAME` | `js-commerce-cluster` |
| `MONGODB_URI_AUTH` | Atlas URI for `js_auth_service` |
| `MONGODB_URI_CATEGORY` | Atlas URI for `js_category_service` |
| `MONGODB_URI_PRODUCT` | Atlas URI for `js_product_service` |
| `MONGODB_URI_CART` | Atlas URI for `js_cart_service` |
| `MONGODB_URI_ORDER` | Atlas URI for `js_order_service` |
| `JWT_SECRET` | Your 256-bit JWT signing secret |
| `MAIL_USERNAME` | Gmail address for notifications |
| `MAIL_PASSWORD` | Gmail App Password |

> Workflows are in `.github/workflows/`. Each `ci-cd-*.yml` builds, pushes to ECR, and deploys via Helm on every push to `main`.

---

## 12. Swagger UI URLs

When running locally, access the API documentation for each service:

| Service | Swagger UI URL |
|---|---|
| auth-service | http://localhost:8081/swagger-ui/index.html |
| user-service | http://localhost:8082/swagger-ui/index.html |
| category-service | http://localhost:8083/swagger-ui/index.html |
| product-service | http://localhost:8084/swagger-ui/index.html |
| cart-service | http://localhost:8085/swagger-ui/index.html |
| order-service | http://localhost:8086/swagger-ui/index.html |
| notification-service | http://localhost:8087/swagger-ui/index.html |
| service-registry | http://localhost:8761/swagger-ui/index.html |

> The **api-gateway** itself uses `springdoc-openapi-starter-webflux-ui`. It aggregates all routes but does not expose a standalone Swagger UI.

---

## 13. Troubleshooting

### Services fail to start — "Connection refused to Eureka"
- Make sure `service-registry` is fully started before launching other services
- Check `application.properties` — Eureka URL should be `http://localhost:8761/eureka`

### MongoDB connection fails
- Verify your Atlas IP whitelist includes your current IP
- Double-check the connection string — password must be URL-encoded if it contains special characters
- Make sure the database user has **Read and Write** access

### Frontend shows blank screen or CORS errors
- Ensure all backend services are running
- Check `apiConfig.jsx` — base URL must match the gateway port (`http://localhost:8080`)
- Open browser DevTools → Network tab to identify the failing request

### JWT errors (401 Unauthorized)
- Ensure the same `jwt.secret` value is used in both `auth-service` and `user-service`
- JWT tokens expire after 24 hours (`jwt.expiration=86400000` ms) — log in again

### Docker build fails
- Ensure `mvnw.cmd` has execute permissions and Maven wrapper jar exists
- Try `mvn clean package -DskipTests` first, then `docker build`

### Helm deployment fails — ImagePullBackOff
- ECR authentication may have expired — re-run the `aws ecr get-login-password` command
- Verify the image tag pushed to ECR matches the tag in `values.yaml`

### Port conflicts locally
- If a port is in use, stop the conflicting process or change the port in `application.properties` (e.g., `server.port=8091`)

---

*JNexus Commerce — v2.0.1-STABLE | Maintained by Jathin Kumar Sahu*
