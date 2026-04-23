# JNexus Commerce — Detailed Project Information

> **Author:** Jathin Kumar Sahu  
> **Version:** 2.0.1-STABLE  
> **Type:** College Final Year Project  
> **Category:** Cloud-Native Full-Stack E-Commerce Platform

---

## 1. Project Overview

JNexus Commerce is a production-grade, cloud-first e-commerce platform built using a microservices architecture. The application demonstrates real-world software engineering practices including service decomposition, containerization, orchestration, infrastructure as code, and CI/CD automation.

Users can register, browse products by category or search, add items to a cart, and place orders. The system sends transactional emails for registration verification and order confirmation.

---

## 2. Architecture Overview

### 2.1 Microservices Architecture

The backend is decomposed into 9 independent Spring Boot microservices:

| Service | Port | Database | Purpose |
|---|---|---|---|
| `js-service-registry` | 8761 | None | Eureka service discovery server |
| `js-api-gateway` | 8080 | None | Central request routing via Spring Cloud Gateway |
| `js-auth-service` | 8081 | `js_auth_service` | User auth, JWT tokens, email OTP |
| `js-user-service` | 8082 | `js_auth_service` | User profile lookups (used by other services) |
| `js-category-service` | 8083 | `js_category_service` | Product category CRUD |
| `js-product-service` | 8084 | `js_product_service` | Product catalog, search |
| `js-cart-service` | 8085 | `js_cart_service` | Shopping cart management |
| `js-order-service` | 8086 | `js_order_service` | Order placement & tracking |
| `js-notification-service` | 8087 | None | Email sending via JavaMail |

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

## 4. Backend Service Details

### 4.1 Service Registry (`js-service-registry`)

**Package:** `com.jathinsahu.ecommerce.serviceregistry`  
**Key annotation:** `@EnableEurekaServer`  
**URL:** `http://localhost:8761`

The Eureka server dashboard shows all registered services with their instance IDs, health status, and metadata. All microservices register with Eureka on startup and de-register on shutdown.

---

### 4.2 API Gateway (`js-api-gateway`)

**Package:** `com.jathinsahu.ecommerce.apigateway`  
**Key annotation:** `@EnableDiscoveryClient`  
**URL:** `http://localhost:8080`

Uses Spring Cloud Gateway (reactive, built on Netty + WebFlux). Routes are defined in `application.yml` using Eureka service names. Example route:
- `/api/auth-service/**` → `AUTH-SERVICE`
- `/api/product-service/**` → `PRODUCT-SERVICE`

Swagger UI: `http://localhost:8080/webjars/swagger-ui/index.html`

---

### 4.3 Auth Service (`js-auth-service`)

**Package:** `com.jathinsahu.ecommerce.authservice`  
**Key annotations:** `@EnableFeignClients`, `@EnableDiscoveryClient`

**Sub-packages:**
- `controllers` — `AuthController` (REST endpoints)
- `services` — `AuthService` (interface + `AuthServiceImpl`)
- `modals` — `User`, `Role` (MongoDB documents)
- `dtos` — `SignUpRequestDto`, `SignInRequestDto`, `JwtResponseDto`, `UserAuthorityDto`, `ApiResponseDto`, `MailRequestDto`
- `repositories` — `UserRepository`, `RoleRepository`
- `security` — `UserDetailsImpl`, `WebSecurityConfig` (Spring Security), no `AuthTokenFilter` (Auth service IS the authority)
- `exceptions` — `UserAlreadyExistsException`, `UserNotFoundException`, `UserVerificationFailedException`, `RoleNotFoundException`, `ServiceLogicException`
- `exceptionHandlers` — `RestExceptionHandler` (`@RestControllerAdvice`)
- `enums` — `ERole` (ROLE_USER, ROLE_ADMIN)
- `factories` — `RoleFactory`
- `dataSeeders` — `RoleDataSeeder` (seeds default roles on startup)
- `feigns` — `NotificationService` (Feign client to send OTP emails)
- `config` — `SwaggerConfig`

**Flow:**
1. Registration: `POST /auth/signup` → creates User → sends OTP via Notification Service
2. Verification: `GET /auth/signup/verify?code=XXX` → enables account
3. Login: `POST /auth/signin` → validates credentials → returns JWT
4. Token validation: `GET /auth/isValidToken?token=XXX` → returns `UserAuthorityDto`

---

### 4.4 User Service (`js-user-service`)

**Package:** `com.jathinsahu.ecommerce.userservice`

Provides user lookups for Cart and Order services. Endpoints:
- `GET /user/exists/byId?userId=XXX` — boolean existence check
- `GET /user/get/byId?id=XXX` — returns `UserDto`

**Sub-packages:** `controllers`, `services`, `modals`, `repositories`, `dtos`, `security`, `exceptions`, `feigns`, `config`

---

### 4.5 Category Service (`js-category-service`)

**Package:** `com.jathinsahu.ecommerce.categoryservice`

**Sub-packages:** `controllers` (Admin + Common), `services`, `modals` (`Category`), `repositories`, `dtos`, `security`, `exceptions`, `feigns`, `config`

MongoDB collection: `categories`  
Fields: `id`, `categoryName`, `description`, `imageUrl`

---

### 4.6 Product Service (`js-product-service`)

**Package:** `com.jathinsahu.ecommerce.productservice`

**Sub-packages:** `controllers` (Admin + Common), `services`, `models` (`Product`), `repositories`, `dtos`, `security`, `exceptions`, `feigns`, `config`

MongoDB collection: `products`  
Fields: `id`, `productName`, `price`, `description`, `imageUrl`, `categoryId`, `categoryName`

Custom repository query: full-text search across `productName`, `description`, and `categoryName` using `ContainingIgnoreCase`.

---

### 4.7 Cart Service (`js-cart-service`)

**Package:** `com.jathinsahu.ecommerce.cartservice`

**Sub-packages:** `controllers`, `services`, `modals` (`Cart`, `CartItem`), `repositories`, `dtos`, `security`, `exceptions`, `feigns` (Auth, Product, User), `config`

MongoDB collection: `carts`  
Fields: `id`, `userId`, `cartItems` (Set of CartItem{productId, quantity})

Logic: If cart does not exist for a user, it is auto-created on first access.

---

### 4.8 Order Service (`js-order-service`)

**Package:** `com.jathinsahu.ecommerce.orderservice`

**Sub-packages:** `controllers`, `services`, `modals` (`Order`, `OrderItem`), `repositories`, `dtos`, `enums`, `security`, `exceptions`, `feigns` (Auth, Cart, User, Notification), `config`

MongoDB collection: `orders`  
Fields: `id`, `userId`, `firstName`, `lastName`, `addressLine1`, `addressLine2`, `city`, `phoneNo`, `orderAmt`, `placedOn`, `orderStatus`, `paymentStatus`, `orderItems`

Enums: `EOrderStatus` (PENDING, PROCESSING, CONFIRMED, SHIPPED, DELIVERED, CANCELLED, RETURNED), `EOrderPaymentStatus` (PAID, UNPAID)

---

### 4.9 Notification Service (`js-notification-service`)

**Package:** `com.jathinsahu.ecommerce.notificationservice`

**Sub-packages:** `controller`, `services` (`NotificationService` interface + `EmailNotificationService`), `dtos`, `config`

Uses `JavaMailSender` with `MimeMessage` for HTML email support. Called by Auth Service (OTP) and Order Service (order confirmation).

---

## 5. Frontend Architecture

### 5.1 Project Structure

```
frontend/src/
├── api-service/       # Axios service layer (auth, cart, order, product)
├── assets/styles/     # Global CSS with CSS custom properties
├── components/        # Reusable UI components
│   ├── header/        # Navigation, search, cart icon
│   ├── footer/        # Footer, CopyRight, Signature
│   ├── logo/          # Brand logo "JS Premium"
│   ├── cart/          # Cart sidebar
│   ├── categories/    # Category display
│   ├── about/         # About section
│   ├── home_hero/     # Landing hero
│   ├── loading/       # Loading spinner
│   └── info/          # Info/message display
├── contexts/          # React Context (AuthContext, CartContext)
├── pages/             # Page components
│   ├── home/          # Landing page
│   ├── auth/          # Login, Register, Verify, Error pages
│   ├── products/      # Product listing
│   ├── search/        # Search results
│   ├── checkout/      # Checkout + Order success
│   └── my.account/    # User dashboard + order history
└── routes/            # React Router configuration
```

### 5.2 Theme & Branding

| CSS Variable | Value | Usage |
|---|---|---|
| `--primary` | `#6c5ce7` (Deep Purple) | Navbar, buttons, borders |
| `--secondary` | `#a29bfe` (Light Purple) | Hover states |
| `--ternary` | `#2c3e50` (Dark Slate) | Signature bar, accents |
| `--light` | `#dfe6e9` (Light Gray) | Search input bg, footer bg |
| `--body` | `#EFF0F3` (Off-white) | Page background |

Brand name: **JS Premium** (navbar logo)  
Browser title: `JS Engine | Shop`  
Footer copyright: `© 2026 | JS Premium | Designed & Developed by Jathin Kumar Sahu`  
Signature bar: `System Status: Active | Version: 2.0.1-STABLE | Developed by Jathin Sahu`

### 5.3 Authentication Flow

1. User calls `AuthService.login()` → `POST /api/auth-service/auth/signin`
2. JWT token + user details stored in `localStorage` under key `"user"`
3. `AuthContext` exposes `user` state across all components
4. `toggleUser()` refreshes user from localStorage (called on login/logout)
5. Protected routes check `user` from context; if null, show `<Unauthorized />`

---

## 6. Deployment Architecture

### 6.1 Docker

Each service has a `Dockerfile` using multi-stage build:
1. Build stage: Maven/Node build
2. Runtime stage: JRE/Nginx + app JAR/static files

All images use `COPY target/*.jar app.jar` (wildcard, safe after artifactId changes).

### 6.2 Kubernetes (AWS EKS)

Cluster name: `js-commerce-cluster`

Each service has a Helm chart in `helm-charts/<service>/` containing:
- `Deployment.yaml` — Pod spec, resource limits, env vars from secrets/configmaps
- `Service.yaml` — ClusterIP service
- `hpa.yaml` — HorizontalPodAutoscaler (CPU-based scaling)
- `configmap.yaml` — Non-sensitive configuration
- `secret.yaml` — Sensitive data (DB URIs, JWT secret, mail credentials)

Ingress: `helm-charts/ingress-alb/` — AWS ALB Ingress Controller routes external traffic.

### 6.3 AWS Infrastructure (Terraform)

| Resource | Purpose |
|---|---|
| VPC | Isolated network across 2 AZs |
| 2 Public Subnets | NAT Gateway, ALB |
| 2 Private Subnets | EKS worker nodes (never exposed to internet) |
| Internet Gateway | Public subnet internet access |
| NAT Gateway | Private subnet outbound access (ECR image pulls) |
| EKS Cluster | Managed Kubernetes control plane |
| EKS Node Group | Managed worker nodes (auto-scaled) |
| ALB Controller | Kubernetes Ingress → AWS ALB |
| Metrics Server | HPA pod resource metrics |
| Cluster Autoscaler | Automatic node scaling |
| ECR Repositories | Docker image storage (one per service) |

### 6.4 CI/CD Pipeline (GitHub Actions)

11 workflow files in `.github/workflows/` (one per service + web).

Each pipeline:
1. **Build & Test**: `mvn clean package` / `npm run build`
2. **Docker Build & Push**: Build image → tag → push to ECR
3. **Helm Deploy**: `helm upgrade --install` on EKS cluster

Triggered on: push to `main` branch for the respective service path.

---

## 7. Security Model

| Layer | Mechanism |
|---|---|
| Authentication | JWT Bearer tokens (HMAC SHA-256 signing) |
| Authorization | `@PreAuthorize` + `hasAuthority("ROLE_ADMIN")` / `"ROLE_USER"` |
| Token Storage | `localStorage` (frontend) |
| Token Validation | Auth Service validates token for every secured request |
| Password Storage | BCrypt hashed (Spring Security) |
| CSRF | Disabled (stateless REST API) |
| CORS | Configured in API Gateway |
| Session Management | STATELESS (no server-side sessions) |

---

## 8. API Documentation (Swagger)

After starting each service, Swagger UI is available at:

| Service | Swagger URL |
|---|---|
| Auth Service | `http://localhost:8081/swagger-ui/index.html` |
| User Service | `http://localhost:8082/swagger-ui/index.html` |
| Category Service | `http://localhost:8083/swagger-ui/index.html` |
| Product Service | `http://localhost:8084/swagger-ui/index.html` |
| Cart Service | `http://localhost:8085/swagger-ui/index.html` |
| Order Service | `http://localhost:8086/swagger-ui/index.html` |
| Notification Service | `http://localhost:8087/swagger-ui/index.html` |
| Service Registry | `http://localhost:8761/swagger-ui/index.html` |

All configured with: Contact = **Jathin Kumar Sahu** / `jathinsahu@gmail.com`

---

## 9. MongoDB Databases

| Database Name | Used By | Key Collections |
|---|---|---|
| `js_auth_service` | Auth Service, User Service | `Users`, `Roles` |
| `js_category_service` | Category Service | `categories` |
| `js_product_service` | Product Service | `products` |
| `js_cart_service` | Cart Service | `carts` |
| `js_order_service` | Order Service | `orders` |

---

## 10. Key Design Decisions

1. **Separate DB per service** — Ensures loose coupling; each service owns its data.
2. **Feign over RestTemplate** — Declarative, readable, integrates with Eureka load balancing.
3. **JWT stateless auth** — No session affinity needed; works perfectly with horizontal scaling.
4. **Eureka + Spring Cloud Gateway** — Standard Spring Cloud Netflix stack for reliable service discovery.
5. **HPA + Cluster Autoscaler** — Two-level autoscaling: pod-level and node-level.
6. **Terraform IaC** — All AWS resources are reproducible and version-controlled.
7. **Per-service CI/CD** — Independent pipelines allow deploying a single service without affecting others.

---

*Document prepared by: Jathin Kumar Sahu | JNexus Commerce v2.0.1-STABLE*
