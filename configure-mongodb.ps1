# MongoDB Atlas Configuration Helper
# Run this script after getting your MongoDB connection string from Atlas

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "MongoDB Atlas Configuration Helper" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Get MongoDB connection string from user
Write-Host "Please enter your MongoDB Atlas connection string:" -ForegroundColor Yellow
Write-Host "Example: mongodb+srv://jnexusadmin:MyPassword123@cluster0.xxxxx.mongodb.net/" -ForegroundColor Gray
Write-Host ""
$connectionString = Read-Host "Enter connection string"

# Validate connection string
if ($connectionString -match "mongodb\+srv://") {
    Write-Host ""
    Write-Host "✓ Valid connection string format detected" -ForegroundColor Green
    Write-Host ""
    
    # Define services and their database names
    $services = @(
        @{Name="auth-service"; DB="js_auth_service"; Port="9030"},
        @{Name="category-service"; DB="js_category_service"; Port="9000"},
        @{Name="product-service"; DB="js_product_service"; Port="9010"},
        @{Name="cart-service"; DB="js_cart_service"; Port="9060"},
        @{Name="order-service"; DB="js_order_service"; Port="9070"}
    )
    
    $basePath = "microservice-backend"
    
    foreach ($service in $services) {
        $configPath = Join-Path $basePath "$($service.Name)/src/main/resources/application.yml"
        $fullConnectionString = "$($connectionString.TrimEnd('/'))/$($service.DB)?retryWrites=true&w=majority"
        
        if (Test-Path $configPath) {
            Write-Host "Configuring $($service.Name)..." -ForegroundColor Yellow
            
            $configContent = @"
spring:
    application:
        name: $($service.Name)
    data:
        mongodb:
            uri: $fullConnectionString

server:
    port: $($service.Port)

eureka:
    client:
        serviceUrl:
            defaultZone: http://localhost:8761/eureka/
"@
            
            # Add specific configurations for category-service
            if ($service.Name -eq "category-service") {
                $configContent += @"
        fetchRegistry: true
        registerWithEureka: true
    instance:
        hostname: localhost
"@
            } else {
                $configContent += @"
    instance:
        hostname: localhost
"@
            }
            
            Set-Content -Path $configPath -Value $configContent
            Write-Host "  ✓ Updated $configPath" -ForegroundColor Green
        } else {
            Write-Host "  ✗ File not found: $configPath" -ForegroundColor Red
        }
    }
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "All services configured successfully!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Start Service Registry: cd microservice-backend/service-registry; mvn spring-boot:run" -ForegroundColor White
    Write-Host "2. Start API Gateway: cd microservice-backend/api-gateway; mvn spring-boot:run" -ForegroundColor White
    Write-Host "3. Start other services in separate terminals" -ForegroundColor White
    Write-Host "4. Start Frontend: cd frontend; npm install; npm run dev" -ForegroundColor White
    Write-Host ""
    
} else {
    Write-Host ""
    Write-Host "✗ Invalid connection string format!" -ForegroundColor Red
    Write-Host "Please make sure it starts with mongodb+srv://" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Example format:" -ForegroundColor Cyan
    Write-Host "mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/" -ForegroundColor Gray
}

Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
