# JKart — Cloud-Native Microservices E-Commerce Platform

> **Author:** Jathin Kumar Sahu  
> **Version:** 2.1.0-STABLE  
> **Type:** College Final Year Project  
> **Category:** Cloud-Native Full-Stack E-Commerce Platform

---

## 1. Project Overview

JKart (formerly JNexus Commerce) is a production-grade, cloud-first e-commerce platform built using a microservices architecture. The application demonstrates real-world software engineering practices including service decomposition, containerization, orchestration, infrastructure as code, and CI/CD automation.

Users can register, browse products by category or search, add items to a cart, and place orders. The system sends transactional emails for registration verification and order confirmation.

---

## 2. Architecture Overview

### 2.1 Microservices Architecture

The backend is decomposed into 9 independent Spring Boot microservices:

| Service | Port | Database | Purpose |
|---|---|---|---|
| `service-registry` | 8761 | None | Eureka service discovery server |
| `api-gateway` | 8080 | None | Central request routing via Spring Cloud Gateway |
| `auth-service` | 9030 | `js_auth_service` | User auth, JWT tokens, email OTP |
| `user-service` | 9050 | `js_auth_service` | User profile lookups (shares Auth DB) |
| `category-service` | 9000 | `js_category_service` | Product category CRUD |
| `product-service` | 9010 | `js_product_service` | Product catalog, search |
| `cart-service` | 9060 | `js_cart_service` | Shopping cart management |
| `order-service` | 9070 | `js_order_service` | Order placement & tracking |
| `notification-service` | 9020 | None | Email sending via JavaMail |

### 2.2 Communication Patterns

- **Client → API Gateway**: All frontend calls go through port 8080 (prefix `/api`)
- **Gateway → Services**: Spring Cloud Gateway routes requests using Eureka service names
- **Service → Service**: OpenFeign declarative HTTP clients (e.g., Order Service calls Cart, User, Notification services)
- **Auth Validation**: Every secured service calls `AUTH-SERVICE /auth/isValidToken` via Feign before processing requests

### 2.3 Security Architecture

- JWT (JSON Web Token) issued by Auth Service on login
- Each secured service has `AuthTokenFilter` (extends `OncePerRequestFilter`) that:
  1. Extracts Bearer token from `Authorization` header
  2. Calls Auth Service `validateToken` endpoint via Feign
  3. Sets `UsernamePasswordAuthenticationToken` in `SecurityContextHolder`
- Role-based access: `ROLE_USER` for customer operations, `ROLE_ADMIN` for management operations
- Spring Security `WebSecurityConfig` with stateless sessions (no HTTP sessions)

---

## 3. Tech Stack

| Category | Technology |
|---|---|
| Backend Framework | Spring Boot 3.2.x |
| Service Discovery | Spring Cloud Netflix Eureka |
| API Gateway | Spring Cloud Gateway (Reactive/WebFlux) |
| Inter-service Communication | Spring Cloud OpenFeign |
| Security | Spring Security + JWT (jjwt 0.11.5) |
| Database | MongoDB Atlas (one database per service) |
| ORM/ODM | Spring Data MongoDB |
| Email | Spring Boot Mail (JavaMail/SMTP) |
| Frontend Framework | React.js 18 with Vite |
| Frontend Routing | React Router DOM |
| HTTP Client (FE) | Axios |
| Frontend Theme | Deep Purple (#6c5ce7) — Dark Slate (#2c3e50) accents |
| API Documentation | SpringDoc OpenAPI (Swagger UI) |
| Containerization | Docker |
| Container Registry | Amazon ECR |
| Orchestration | Kubernetes (AWS EKS) |
| Package Manager (K8s) | Helm |
| Infrastructure as Code | Terraform |
| CI/CD | GitHub Actions |
| Cloud Provider | AWS (EKS, ECR, VPC, ALB, NAT Gateway) |
| Java Version | JDK 21 (services), JDK 17 (auth, notification) |
| Build Tool | Apache Maven |

---

## 4. Core Flow Paths & Implementation

### 4.1 User Registration & Email Verification

1.  **Request:** Frontend calls `Auth Service` (`/auth/signup`).
2.  **Creation:** `Auth Service` creates a `User` in `js_auth_service` DB with `enabled = false` and generates a 6-digit OTP.
3.  **Notification:** `Auth Service` calls `Notification Service` via Feign to send the OTP email (using Mailtrap/SMTP).
4.  **Verification:** User enters OTP → Frontend calls `Auth Service` (`/auth/signup/verify`).
5.  **Activation:** `Auth Service` sets `enabled = true` in DB. User can now log in.

### 4.2 Shopping Cart Management

1.  **Add Item:** User clicks "Add to Cart" → Frontend calls `Cart Service` (`/cart/add`).
2.  **Validation:** `Cart Service` calls `User Service` (to check if user exists) and `Product Service` (to verify product details/price) via Feign.
3.  **Persistence:** If valid, `Cart Service` saves item in `js_cart_service` DB (linked to `userId`).
4.  **Display:** Frontend calls `Cart Service` (`/cart/get/byUser`) to render the sidebar.

### 4.3 Checkout & Order Placement

1.  **Submission:** User clicks "Place Order" → Frontend calls `Order Service` (`/order/create`).
2.  **Order Creation:** `Order Service` generates an Order record in `js_order_service` DB.
3.  **Data Sync:** `Order Service` calls `Cart Service` (via Feign) to fetch the items to be ordered.
4.  **Payment (Mock):** The system simulates a successful payment. **Note:** No real payment gateway (Stripe/PayPal) is currently integrated; it is a demo-only flow.
5.  **Confirmation:** `Order Service` calls `Notification Service` to send an order success email.
6.  **Cleanup:** `Order Service` calls `Cart Service` to clear the user's cart items.

### 4.4 Product Search & Filtering

1.  **Search:** User types in navbar → Frontend calls `Product Service` (`/product/search?query=...`).
2.  **Filter:** User clicks a category → Frontend calls `Product Service` (`/product/get/byCategory?categoryId=...`).
3.  **Result:** `Product Service` performs a case-insensitive search in MongoDB and returns matching DTOs.

---

## 5. Backend Service Details

### 5.1 Service Registry (`service-registry`)
- **Port:** 8761
- Eureka dashboard: `http://localhost:8761`
- Centralized discovery for all microservices.

### 5.2 API Gateway (`api-gateway`)
- **Port:** 8080
- Central entry point. Routes requests based on `/api/service-name/**`.
- Handles global CORS and security filters.

### 5.3 Auth Service (`auth-service`)
- **Port:** 9030
- Manages JWT issuance and validation.
- Handles registration, login, and OTP verification.

### 5.4 User Service (`user-service`)
- **Port:** 9050
- Shares `js_auth_service` database to provide user validation for other services.

### 5.5 Category & Product Services
- **Ports:** 9000 (Category), 9010 (Product)
- Manage the catalog. Admin endpoints are secured via `ROLE_ADMIN`.

### 5.6 Cart & Order Services
- **Ports:** 9060 (Cart), 9070 (Order)
- Handle the transactional part of the shop. Orchestrate calls between User, Product, and Notification services.

---

## 6. Frontend Architecture

### 6.1 Theme & Branding
- **Name:** JKart
- **Primary Color:** `#6c5ce7` (Deep Purple)
- **CSS Variable:** `--primary`
- **Copyright:** `© 2026 | JKart | Designed & Developed by Jathin Kumar Sahu`

### 6.2 State Management
- **AuthContext:** Manages user login state and persists to `localStorage`.
- **Axios Services:** Isolated layer for API communication at `frontend/src/api-service/`.

---

## 7. Security Model

| Layer | Mechanism |
|---|---|
| Authentication | JWT Bearer tokens (HMAC SHA-256) |
| Authorization | `@PreAuthorize` + `hasAuthority("ROLE_ADMIN")` / `"ROLE_USER"` |
| Password Storage | BCrypt hashed |
| Session Management | STATELESS (no server-side sessions) |

---

## 8. API Documentation (Swagger)

| Service | Swagger URL |
|---|---|
| Auth Service | `http://localhost:9030/swagger-ui/index.html` |
| User Service | `http://localhost:9050/swagger-ui/index.html` |
| Category Service | `http://localhost:9000/swagger-ui/index.html` |
| Product Service | `http://localhost:9010/swagger-ui/index.html` |
| Cart Service | `http://localhost:9060/swagger-ui/index.html` |
| Order Service | `http://localhost:9070/swagger-ui/index.html` |
| Notification Service | `http://localhost:9020/swagger-ui/index.html` |

---

*Document prepared by: Jathin Kumar Sahu | JKart v2.1.0-STABLE*
