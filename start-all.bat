@echo off
echo ========================================
echo JNexus Commerce - Starting All Services
echo ========================================
echo.

REM Check if Java is installed
echo Checking prerequisites...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Java is not installed or not in PATH
    echo Please install JDK 17 or 21 from https://adoptium.net/
    pause
    exit /b 1
)
echo Java found

REM Check if Maven is installed
mvn -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Maven is not installed or not in PATH
    echo Please install Maven from https://maven.apache.org/download.cgi
    pause
    exit /b 1
)
echo Maven found

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Node.js is not installed or not in PATH
    echo Please install Node.js 18+ from https://nodejs.org/
    pause
    exit /b 1
)
for /f %%i in ('node --version') do echo Node.js found: %%i

echo.
echo ========================================
echo Starting Services...
echo ========================================
echo.

REM Function to start a service
echo Starting Service Registry (Eureka)...
start "Service Registry (Eureka)" cmd /k "cd /d %~dp0microservice-backend\service-registry && echo Starting Service Registry... && mvn spring-boot:run"
timeout /t 2 /nobreak >nul

echo Starting API Gateway...
start "API Gateway" cmd /k "cd /d %~dp0microservice-backend\api-gateway && echo Starting API Gateway... && mvn spring-boot:run"
timeout /t 2 /nobreak >nul

echo Starting Auth Service...
start "Auth Service" cmd /k "cd /d %~dp0microservice-backend\auth-service && echo Starting Auth Service... && mvn spring-boot:run"
timeout /t 2 /nobreak >nul

echo Starting Category Service...
start "Category Service" cmd /k "cd /d %~dp0microservice-backend\category-service && echo Starting Category Service... && mvn spring-boot:run"
timeout /t 2 /nobreak >nul

echo Starting Product Service...
start "Product Service" cmd /k "cd /d %~dp0microservice-backend\product-service && echo Starting Product Service... && mvn spring-boot:run"
timeout /t 2 /nobreak >nul

echo Starting Cart Service...
start "Cart Service" cmd /k "cd /d %~dp0microservice-backend\cart-service && echo Starting Cart Service... && mvn spring-boot:run"
timeout /t 2 /nobreak >nul

echo Starting Order Service...
start "Order Service" cmd /k "cd /d %~dp0microservice-backend\order-service && echo Starting Order Service... && mvn spring-boot:run"
timeout /t 2 /nobreak >nul

REM Check if User Service exists
if exist "%~dp0microservice-backend\user-service" (
    echo Starting User Service...
    start "User Service" cmd /k "cd /d %~dp0microservice-backend\user-service && echo Starting User Service... && mvn spring-boot:run"
    timeout /t 2 /nobreak >nul
)

REM Check if Notification Service exists
if exist "%~dp0microservice-backend\notification-service" (
    echo Starting Notification Service...
    start "Notification Service" cmd /k "cd /d %~dp0microservice-backend\notification-service && echo Starting Notification Service... && mvn spring-boot:run"
    timeout /t 2 /nobreak >nul
)

echo.
echo ========================================
echo Starting Frontend...
echo ========================================
echo.

REM Start Frontend
if exist "%~dp0frontend" (
    echo Installing frontend dependencies (first time only)...
    cd /d %~dp0frontend
    call npm install
    
    echo.
    echo Starting Frontend...
    start "Frontend" cmd /k "cd /d %~dp0frontend && echo Starting Frontend... && npm run dev"
) else (
    echo ERROR: Frontend path not found
)

echo.
echo ========================================
echo All Services Starting!
echo ========================================
echo.
echo Access your application at:
echo   Frontend:         http://localhost:5173
echo   API Gateway:      http://localhost:8080
echo   Eureka Dashboard: http://localhost:8761
echo.
echo Wait 30-60 seconds for all services to fully start
echo.
echo You can close this window - services will continue running in their own windows
echo.
pause
