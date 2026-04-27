# JNexus Commerce - Clean, Build and Start All Services
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "JNexus Commerce - Clean Build & Start" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Step 1: Checking prerequisites..." -ForegroundColor Yellow
try {
    java -version 2>&1 | Out-Null
    Write-Host "  Java: OK" -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Java not found" -ForegroundColor Red
    exit 1
}

try {
    mvn -version 2>&1 | Out-Null
    Write-Host "  Maven: OK" -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Maven not found" -ForegroundColor Red
    exit 1
}

try {
    $nodeVer = node --version 2>&1
    Write-Host "  Node.js: $nodeVer" -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Node.js not found" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Step 2: Building all backend services..." -ForegroundColor Yellow
Write-Host ""

$services = @(
    "service-registry",
    "api-gateway",
    "auth-service",
    "category-service",
    "product-service",
    "cart-service",
    "order-service",
    "user-service",
    "notification-service"
)

$basePath = Join-Path $PSScriptRoot "microservice-backend"

foreach ($service in $services) {
    $servicePath = Join-Path $basePath $service
    if (Test-Path $servicePath) {
        Write-Host "Building $service..." -ForegroundColor Yellow
        Set-Location $servicePath
        mvn clean package -DskipTests -q
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✓ $service built successfully" -ForegroundColor Green
        } else {
            Write-Host "  ✗ $service build FAILED" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Step 3: Starting all services..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

function Start-ServiceInCMD {
    param(
        [string]$WindowTitle,
        [string]$Path,
        [string]$Command
    )
    
    Write-Host "Starting $WindowTitle..." -ForegroundColor Yellow
    $fullPath = Join-Path $PSScriptRoot $Path
    
    if (Test-Path $fullPath) {
        $cmdCommand = "cd /d `"$fullPath`" && echo Starting $WindowTitle... && $Command"
        Start-Process cmd -ArgumentList "/k", $cmdCommand -WindowStyle Normal
        Write-Host "  -> $WindowTitle started" -ForegroundColor Green
        Start-Sleep -Seconds 2
    }
}

# Start all services
Start-ServiceInCMD -WindowTitle "Service Registry (Eureka)" -Path "microservice-backend\service-registry" -Command "mvn spring-boot:run"
Start-ServiceInCMD -WindowTitle "API Gateway" -Path "microservice-backend\api-gateway" -Command "mvn spring-boot:run"
Start-ServiceInCMD -WindowTitle "Auth Service" -Path "microservice-backend\auth-service" -Command "mvn spring-boot:run"
Start-ServiceInCMD -WindowTitle "Category Service" -Path "microservice-backend\category-service" -Command "mvn spring-boot:run"
Start-ServiceInCMD -WindowTitle "Product Service" -Path "microservice-backend\product-service" -Command "mvn spring-boot:run"
Start-ServiceInCMD -WindowTitle "Cart Service" -Path "microservice-backend\cart-service" -Command "mvn spring-boot:run"
Start-ServiceInCMD -WindowTitle "Order Service" -Path "microservice-backend\order-service" -Command "mvn spring-boot:run"
Start-ServiceInCMD -WindowTitle "User Service" -Path "microservice-backend\user-service" -Command "mvn spring-boot:run"
Start-ServiceInCMD -WindowTitle "Notification Service" -Path "microservice-backend\notification-service" -Command "mvn spring-boot:run"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Starting Frontend..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$frontendPath = Join-Path $PSScriptRoot "frontend"
if (Test-Path $frontendPath) {
    Write-Host "Installing frontend dependencies..." -ForegroundColor Yellow
    Set-Location $frontendPath
    npm install --silent
    
    Write-Host ""
    Write-Host "Starting Frontend..." -ForegroundColor Yellow
    $frontendCMD = "cd /d `"$frontendPath`" && echo Starting Frontend... && npm run dev"
    Start-Process cmd -ArgumentList "/k", $frontendCMD -WindowStyle Normal
    Write-Host "  -> Frontend started" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "All Services Starting!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Access your application at:" -ForegroundColor Yellow
Write-Host "  Frontend:         http://localhost:5173" -ForegroundColor Cyan
Write-Host "  API Gateway:      http://localhost:8080" -ForegroundColor Cyan
Write-Host "  Eureka Dashboard: http://localhost:8761" -ForegroundColor Cyan
Write-Host ""
Write-Host "Wait 60-90 seconds for all services to fully start" -ForegroundColor Yellow
Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
