# MongoDB Atlas Configuration Guide

## Your MongoDB Connection String Template

After completing the MongoDB Atlas setup, your connection string will look like this:

```
mongodb+srv://jnexusadmin:YOUR_PASSWORD@cluster0.xxxxx.mongodb.net/
```

**IMPORTANT:** Replace `YOUR_PASSWORD` with the actual password you created in Step 3!

---

## Configuration for Each Service

### 1. Auth Service
**File:** `microservice-backend/auth-service/src/main/resources/application.yml`

```yaml
spring:
    application:
        name: auth-service
    data:
        mongodb:
            uri: mongodb+srv://jnexusadmin:YOUR_PASSWORD@cluster0.xxxxx.mongodb.net/js_auth_service?retryWrites=true&w=majority

server:
    port: 9030

eureka:
    client:
        serviceUrl:
            defaultZone: http://localhost:8761/eureka/
    instance:
        hostname: localhost
```

---

### 2. Category Service
**File:** `microservice-backend/category-service/src/main/resources/application.yml`

```yaml
spring:
    application:
        name: category-service
    data:
        mongodb:
            uri: mongodb+srv://jnexusadmin:YOUR_PASSWORD@cluster0.xxxxx.mongodb.net/js_category_service?retryWrites=true&w=majority

server:
    port: 9000

eureka:
    client:
        serviceUrl:
            defaultZone: http://localhost:8761/eureka/
        fetchRegistry: true
        registerWithEureka: true
    instance:
        hostname: localhost
```

---

### 3. Product Service
**File:** `microservice-backend/product-service/src/main/resources/application.yml`

```yaml
spring:
    application:
        name: product-service
    data:
        mongodb:
            uri: mongodb+srv://jnexusadmin:YOUR_PASSWORD@cluster0.xxxxx.mongodb.net/js_product_service?retryWrites=true&w=majority

server:
    port: 9010

eureka:
    client:
        serviceUrl:
            defaultZone: http://localhost:8761/eureka/
    instance:
        hostname: localhost
```

---

### 4. Cart Service
**File:** `microservice-backend/cart-service/src/main/resources/application.yml`

```yaml
spring:
    application:
        name: cart-service
    data:
        mongodb:
            uri: mongodb+srv://jnexusadmin:YOUR_PASSWORD@cluster0.xxxxx.mongodb.net/js_cart_service?retryWrites=true&w=majority

server:
    port: 9060

eureka:
    client:
        serviceUrl:
            defaultZone: http://localhost:8761/eureka/
    instance:
        hostname: localhost
```

---

### 5. Order Service
**File:** `microservice-backend/order-service/src/main/resources/application.yml`

```yaml
spring:
    application:
        name: order-service
    data:
        mongodb:
            uri: mongodb+srv://jnexusadmin:YOUR_PASSWORD@cluster0.xxxxx.mongodb.net/js_order_service?retryWrites=true&w=majority

server:
    port: 9070

eureka:
    client:
        serviceUrl:
            defaultZone: http://localhost:8761/eureka/
    instance:
        hostname: localhost
```

---

## ⚠️ IMPORTANT NOTES:

1. **Replace `YOUR_PASSWORD`** with your actual MongoDB Atlas password
2. **Replace `cluster0.xxxxx`** with your actual cluster address from MongoDB Atlas
3. **Don't remove `?retryWrites=true&w=majority`** - this is important for data integrity
4. **Database names** (js_auth_service, js_category_service, etc.) will be created automatically on first connection

---

## Quick Setup Commands

Once you've updated the configuration files, you can start the services:

```bash
# Terminal 1 - Service Registry
cd microservice-backend/service-registry
mvn spring-boot:run

# Terminal 2 - API Gateway
cd microservice-backend/api-gateway
mvn spring-boot:run

# Terminal 3 - Auth Service
cd microservice-backend/auth-service
mvn spring-boot:run

# Terminal 4 - Category Service
cd microservice-backend/category-service
mvn spring-boot:run

# Terminal 5 - Product Service
cd microservice-backend/product-service
mvn spring-boot:run

# Terminal 6 - Cart Service
cd microservice-backend/cart-service
mvn spring-boot:run

# Terminal 7 - Order Service
cd microservice-backend/order-service
mvn spring-boot:run

# Terminal 8 - Frontend
cd frontend
npm install
npm run dev
```

---

## Verify Connection

After starting the services, check the logs for:
- ✅ "Started XxxService in X seconds" - Service started successfully
- ✅ Connection to MongoDB established
- ❌ If you see connection errors, check your password and cluster address

---

## Troubleshooting

### Error: "Authentication failed"
- Check your username and password in the connection string
- Make sure you're using the database user password (not your Atlas account password)

### Error: "Could not resolve host"
- Check your cluster address (cluster0.xxxxx.mongodb.net)
- Make sure you copied the full connection string from Atlas

### Error: "IP not whitelisted"
- Go to Network Access in MongoDB Atlas
- Add `0.0.0.0/0` to allow access from anywhere
