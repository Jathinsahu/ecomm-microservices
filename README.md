<h1 align="center">JKart — Cloud-First Microservices E-Commerce Platform</h1>

<p align="center">
  <strong>Designed & Developed by Jathin Kumar Sahu</strong>
</p>

<p align="center">
  <img alt="Static Badge" src="https://img.shields.io/badge/Spring%20Boot-yellowgreen?style=for-the-badge">
  <img alt="Static Badge" src="https://img.shields.io/badge/React.js-darkblue?style=for-the-badge">
  <img alt="Static Badge" src="https://img.shields.io/badge/mongodb-darkgreen?style=for-the-badge">
  <img alt="Static Badge" src="https://img.shields.io/badge/jwt-hotpink?style=for-the-badge">
  <img alt="Static Badge" src="https://img.shields.io/badge/docker-blue?style=for-the-badge">
  <img alt="Static Badge" src="https://img.shields.io/badge/kubernetes-skyblue?style=for-the-badge">
  <img alt="Static Badge" src="https://img.shields.io/badge/terraform-purple?style=for-the-badge">
  <img alt="Static Badge" src="https://img.shields.io/badge/AWS%20EKS-tomato?style=for-the-badge">
  <img alt="Static Badge" src="https://img.shields.io/badge/AWS%20ECR-orange?style=for-the-badge">
  <img alt="Static Badge" src="https://img.shields.io/badge/GITHUB%20ACTIONS-white?style=for-the-badge">
</p>

- **JKart** is a cloud-first microservices web application built for my college final project, showcasing modern cloud-native development with Kubernetes orchestration.
- The application is a full-stack e-commerce platform where users can browse products, add items to a cart, and complete purchases.
- The architecture leverages **Spring Boot microservices**, **Spring Cloud Gateway**, and **Eureka Service Registry**, with a **React.js frontend** and **MongoDB databases**.
- The solution is containerized and deployed to **AWS Elastic Kubernetes Service (EKS)** using **Helm** and automated via **GitHub Actions CI/CD** pipelines.

---

## 🚀 Quick Start (Local)

### 1. Prerequisites
- JDK 21
- Node.js 18+
- Maven
- MongoDB Atlas (or local instance)

### 2. Start Services
Run the automated startup script:
```powershell
./start-cmd.ps1
```
This script will:
1.  Check prerequisites.
2.  Start the Service Registry (Eureka).
3.  Start the API Gateway.
4.  Start all 7 microservices in separate CMD windows.
5.  Install frontend dependencies and start the React dev server.

### 3. Access
- **Frontend:** [http://localhost:5173](http://localhost:5173)
- **API Gateway:** [http://localhost:8080](http://localhost:8080)
- **Eureka Dashboard:** [http://localhost:8761](http://localhost:8761)

---

## 🛠 Architecture

### Backend Services

| Service | Port | Database |
|---|---|---|
| `service-registry` | 8761 | None |
| `api-gateway` | 8080 | None |
| `auth-service` | 9030 | `js_auth_service` |
| `user-service` | 9050 | `js_auth_service` |
| `category-service` | 9000 | `js_category_service` |
| `product-service` | 9010 | `js_product_service` |
| `cart-service` | 9060 | `js_cart_service` |
| `order-service` | 9070 | `js_order_service` |
| `notification-service` | 9020 | None |

### Core Flows

1.  **Auth Flow:** User signup -> Email OTP (Mailtrap) -> Account Activation -> Login (JWT).
2.  **Shopping Flow:** Browse Categories -> Filter Products -> Add to Cart.
3.  **Order Flow:** Checkout -> Mock Payment -> Order Confirmation Email -> Clear Cart.

---

## 🔐 Security
- **JWT Authentication:** Secure communication between services.
- **RBAC:** `ROLE_ADMIN` for catalog management, `ROLE_USER` for shopping.
- **Stateless:** No server-side session storage.

---

## ☁️ Deployment
Detailed deployment guides for AWS EKS, Terraform, and GitHub Actions can be found in [detailedprojectinfo.md](./detailedprojectinfo.md).

---

*JKart — Built with passion by Jathin Kumar Sahu | Version 2.1.0-STABLE*
