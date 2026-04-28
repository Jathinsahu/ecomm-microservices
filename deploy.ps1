# JKart Production Deployment Script (Windows PowerShell)
# Single command to deploy all microservices

$ErrorActionPreference = "Stop"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  JKart Production Deployment" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Check if .env file exists
if (-Not (Test-Path ".env")) {
    Write-Host "⚠️  .env file not found!" -ForegroundColor Yellow
    Write-Host "Creating .env from .env.example..." -ForegroundColor Yellow
    Copy-Item ".env.example" ".env"
    Write-Host ""
    Write-Host "❌ Please edit .env file with your actual credentials:" -ForegroundColor Red
    Write-Host "   - MongoDB Atlas connection strings"
    Write-Host "   - JWT secret key"
    Write-Host "   - Email SMTP credentials"
    Write-Host ""
    Write-Host "Then run: .\deploy.ps1" -ForegroundColor Yellow
    exit 1
}

# Check if Docker is installed
if (-Not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Docker is not installed. Please install Docker Desktop first." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Prerequisites checked" -ForegroundColor Green
Write-Host ""

# Stop any running containers
Write-Host "🛑 Stopping existing containers..." -ForegroundColor Yellow
docker-compose down 2>$null
Write-Host ""

# Pull latest code (if in git repo)
if (Test-Path ".git") {
    Write-Host "📥 Pulling latest code..." -ForegroundColor Yellow
    git pull
    Write-Host ""
}

# Build all services
Write-Host "🔨 Building all microservices..." -ForegroundColor Yellow
docker-compose build --no-cache
Write-Host ""

# Start all services
Write-Host "🚀 Starting all services..." -ForegroundColor Green
docker-compose up -d
Write-Host ""

# Wait for services to be ready
Write-Host "⏳ Waiting for services to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Check service health
Write-Host ""
Write-Host "📊 Service Status:" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
docker-compose ps
Write-Host ""

# Show logs
Write-Host "📋 Showing startup logs (Press Ctrl+C to stop)..." -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Cyan
docker-compose logs --tail=100 -f

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  ✅ Deployment Complete!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📍 Service Endpoints:" -ForegroundColor Cyan
Write-Host "   - Eureka Dashboard:    http://localhost:8761"
Write-Host "   - API Gateway:         http://localhost:8080"
Write-Host "   - Auth Service:        http://localhost:9030"
Write-Host "   - User Service:        http://localhost:9050"
Write-Host "   - Category Service:    http://localhost:9000"
Write-Host "   - Product Service:     http://localhost:9010"
Write-Host "   - Cart Service:        http://localhost:9060"
Write-Host "   - Order Service:       http://localhost:9070"
Write-Host "   - Notification Svc:    http://localhost:9020"
Write-Host ""
Write-Host "📝 Useful Commands:" -ForegroundColor Cyan
Write-Host "   - View logs:           docker-compose logs -f"
Write-Host "   - Stop services:       docker-compose down"
Write-Host "   - Restart services:    docker-compose restart"
Write-Host "   - Rebuild services:    docker-compose up -d --build"
Write-Host ""
Write-Host "🎉 JKart is running! Visit Eureka Dashboard to see all registered services." -ForegroundColor Green
Write-Host ""
