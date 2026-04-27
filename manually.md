# JKart — Manual Setup & Run Guide

> Step-by-step instructions to configure, run, and deploy the JKart platform locally and on AWS.
> Authored by **Jathin Kumar Sahu**

---

## 1. Required Ports

To run locally, ensure the following ports are free:

| Service | Port |
|---|---|
| Service Registry | 8761 |
| API Gateway | 8080 |
| Category Service | 9000 |
| Product Service | 9010 |
| Notification Service | 9020 |
| Auth Service | 9030 |
| User Service | 9050 |
| Cart Service | 9060 |
| Order Service | 9070 |
| Frontend (React) | 5173 |

---

## 2. Local Startup (Automated)

The project includes a PowerShell script to start everything in one go:

```powershell
./start-cmd.ps1
```

This script handles dependency installation and launches each service in its own command window for easy log monitoring.

---

## 3. Database Configuration

JKart uses MongoDB Atlas. Each service requires its own database name:

| Service | Database |
|---|---|
| auth-service | `js_auth_service` |
| user-service | `js_auth_service` (Shared) |
| category-service | `js_category_service` |
| product-service | `js_product_service` |
| cart-service | `js_cart_service` |
| order-service | `js_order_service` |

Update the `spring.data.mongodb.uri` in each service's `application.yml` or `application.properties`.

---

## 4. Email Configuration

Emails are sent via the `notification-service`. It is currently configured for **Mailtrap** for testing:

**File:** `microservice-backend/notification-service/src/main/resources/application.properties`

```properties
spring.mail.host=sandbox.smtp.mailtrap.io
spring.mail.port=2525
spring.mail.username=6f13c305dfbd02
spring.mail.password=aa23b53e20dbc5
```

---

## 5. Security Reversion (Seeding Data)

Admin endpoints (`/admin/**`) in Product and Category services are secured with `ROLE_ADMIN`. If you need to seed data manually:

1.  Temporarily change `WebSecurityConfig.java` in the service to `.requestMatchers("/admin/**").permitAll()`.
2.  Restart the service.
3.  Run your seed script (e.g., `seed.js`).
4.  Revert the security config to `.hasAuthority("ROLE_ADMIN")`.

---

## 6. AWS Deployment (Summary)

For full cloud deployment details (Terraform, EKS, Helm), please refer to the **[Detailed Project Info](./detailedprojectinfo.md)**.

---

*JKart — v2.1.0-STABLE | Maintained by Jathin Kumar Sahu*
