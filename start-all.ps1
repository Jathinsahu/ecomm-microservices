# JNexus Commerce - Start All Services Script
# This script starts all backend services and the frontend

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "JNexus Commerce - Starting All Services" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Java is installed
Write-Host "Checking prerequisites..." -ForegroundColor Yellow
try {
    $javaVersion = java -version 2>&1
    Write-Host "Java found" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Java is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install JDK 17 or 21 from https://adoptium.net/" -ForegroundColor Yellow
    exit 1
}

# Check if Maven is installed
try {
    $mavenVersion = mvn -version 2>&1 | Select-Object -First 1
    Write-Host "Maven found" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Maven is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Maven from https://maven.apache.org/download.cgi" -ForegroundColor Yellow
    exit 1
}

# Check if Node.js is installed
try {
    $nodeVersion = node -version 2>&1
    Write-Host "Node.js found: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Node.js is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Node.js 18+ from https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Starting Services..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Function to start a service in a new window
function Start-Microservice {
    param(
        [string]$Name,
        [string]$Path,
        [string]$Command
    )
    
    Write-Host "Starting $Name..." -ForegroundColor Yellow
    $fullPath = Join-Path $PSScriptRoot $Path
    
    if (Test-Path $fullPath) {
        $scriptBlock = "cd '$fullPath'; Write-Host 'Starting $Name...' -ForegroundColor Cyan; $Command"
        Start-Process powershell -ArgumentList "-NoExit", "-Command", $scriptBlock
        Write-Host "  -> $Name started in new window" -ForegroundColor Green
        Start-Sleep -Seconds 2
    } else {
        Write-Host "  -> ERROR: Path not found: $fullPath" -ForegroundColor Red
    }
}

# Start Service Registry
Start-Microservice -Name "Service Registry (Eureka)" -Path "microservice-backend/service-registry" -Command "mvn spring-boot:run"

# Start API Gateway
Start-Microservice -Name "API Gateway" -Path "microservice-backend/api-gateway" -Command "mvn spring-boot:run"

# Start Auth Service
Start-Microservice -Name "Auth Service" -Path "microservice-backend/auth-service" -Command "mvn spring-boot:run"

# Start Category Service
Start-Microservice -Name "Category Service" -Path "microservice-backend/category-service" -Command "mvn spring-boot:run"

# Start Product Service
Start-Microservice -Name "Product Service" -Path "microservice-backend/product-service" -Command "mvn spring-boot:run"

# Start Cart Service
Start-Microservice -Name "Cart Service" -Path "microservice-backend/cart-service" -Command "mvn spring-boot:run"

# Start Order Service
Start-Microservice -Name "Order Service" -Path "microservice-backend/order-service" -Command "mvn spring-boot:run"

# Start User Service (if exists)
$userServicePath = Join-Path $PSScriptRoot "microservice-backend/user-service"
if (Test-Path $userServicePath) {
    Start-Microservice -Name "User Service" -Path "microservice-backend/user-service" -Command "mvn spring-boot:run"
}

# Start Notification Service (if exists)
$notificationServicePath = Join-Path $PSScriptRoot "microservice-backend/notification-service"
if (Test-Path $notificationServicePath) {
    Start-Microservice -Name "Notification Service" -Path "microservice-backend/notification-service" -Command "mvn spring-boot:run"
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Starting Frontend..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Start Frontend
$frontendPath = Join-Path $PSScriptRoot "frontend"
if (Test-Path $frontendPath) {
    Write-Host "Installing frontend dependencies (first time only)..." -ForegroundColor Yellow
    Set-Location $frontendPath
    npm install
    
    Write-Host ""
    Write-Host "Starting Frontend..." -ForegroundColor Yellow
    $frontendScript = "cd '$frontendPath'; Write-Host 'Starting Frontend...' -ForegroundColor Cyan; npm run dev"
    Start-Process powershell -ArgumentList "-NoExit", "-Command", $frontendScript
    Write-Host "  -> Frontend started in new window" -ForegroundColor Green
} else {
    Write-Host "  -> ERROR: Frontend path not found" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "All Services Starting!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Access your application at:" -ForegroundColor Yellow
Write-Host "  Frontend:         http://localhost:5173" -ForegroundColor Cyan
Write-Host "  API Gateway:      http://localhost:8080" -ForegroundColor Cyan
Write-Host "  Eureka Dashboard: http://localhost:8761" -ForegroundColor Cyan
Write-Host ""
Write-Host "Wait 30-60 seconds for all services to fully start" -ForegroundColor Yellow
Write-Host ""
Write-Host "Press any key to exit this window (services will continue running)..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
