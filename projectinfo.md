# JKart Project Specification (Internal Reference)

> **Important Note for Future Collaborators:** This document defines the actual functionality of the JKart project to prevent hallucinations of features that do not exist.

---

## 1. Project Identity
- **Name:** JKart
- **Domain:** E-Commerce
- **Architecture:** Microservices (Spring Boot + React + MongoDB)
- **Primary Theme Color:** Deep Purple (`#6c5ce7`)

---

## 2. Actual Service Map (Ports & DBs)

| Service | Local Port | DB Name |
|---|---|---|
| **Service Registry** | 8761 | N/A |
| **API Gateway** | 8080 | N/A |
| **Auth Service** | 9030 | `js_auth_service` |
| **User Service** | 9050 | `js_auth_service` |
| **Category Service** | 9000 | `js_category_service` |
| **Product Service** | 9010 | `js_product_service` |
| **Cart Service** | 9060 | `js_cart_service` |
| **Order Service** | 9070 | `js_order_service` |
| **Notification Service** | 9020 | N/A |

---

## 3. Verified Flow Paths

### 🟢 Authentication & Registration Flow
1.  User enters details at `/auth/register`.
2.  `Auth Service` creates user (disabled) and logs a 6-digit OTP to the console/email.
3.  User enters OTP at `/auth/verify`.
4.  `Auth Service` enables the user.
5.  User logs in at `/auth/login` and receives a **JWT Bearer Token**.

### 🟢 Product & Catalog Flow
1.  `Category Service` provides categories for the sidebar.
2.  `Product Service` provides the product list.
3.  Search bar on the frontend calls `/api/product-service/product/search` which searches across names, descriptions, and category names.

### 🟢 Cart & Checkout Flow
1.  "Add to Cart" calls `Cart Service`.
2.  `Cart Service` uses Feign to check if the user exists (User Service) and if the product exists (Product Service).
3.  Checkout page collects address and calls `Order Service`.
4.  **Crucial:** Payment is a **MOCK DEMO**. No real payment processing (Stripe/PayPal) is integrated. The order status is automatically set to "SUCCESS" upon clicking place order.
5.  Order placement triggers an email via `Notification Service` and clears the user's cart.

---

## 4. Common Misunderstandings (What is NOT here)
- **NO Real Payments:** Do not attempt to integrate Stripe/Razorpay unless explicitly asked.
- **NO State in Gateway:** The API Gateway is purely a router. It does not handle authentication logic (it delegates to Auth Service).
- **NO Shared Database:** Except for User/Auth services which share a database for simplicity, all other services have strictly isolated MongoDB databases.
- **NO Messaging Queue:** Communication is purely synchronous via **OpenFeign**. Kafka/RabbitMQ are NOT used in this version.

---

## 5. Security Summary
- Authentication is handled by a custom `AuthTokenFilter` in each service.
- The filter extracts the JWT and calls `AUTH-SERVICE /auth/isValidToken` to validate identity.
- Admin tasks (adding products/categories) require a JWT with `ROLE_ADMIN`.

---

*Verified by Antigravity | JKart v2.1.0-STABLE*
