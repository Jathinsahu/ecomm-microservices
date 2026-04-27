#!/bin/bash

# JKart Production Deployment Script
# Single command to deploy all microservices

set -e

echo "========================================="
echo "  JKart Production Deployment"
echo "========================================="
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "⚠️  .env file not found!"
    echo "Creating .env from .env.example..."
    cp .env.example .env
    echo ""
    echo "❌ Please edit .env file with your actual credentials:"
    echo "   - MongoDB Atlas connection strings"
    echo "   - JWT secret key"
    echo "   - Email SMTP credentials"
    echo ""
    echo "Then run: ./deploy.sh"
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

echo "✅ Prerequisites checked"
echo ""

# Stop any running containers
echo "🛑 Stopping existing containers..."
docker-compose down 2>/dev/null || true
echo ""

# Pull latest code (if in git repo)
if [ -d .git ]; then
    echo "📥 Pulling latest code..."
    git pull || echo "⚠️  Git pull failed, continuing with current code..."
    echo ""
fi

# Build all services
echo "🔨 Building all microservices..."
docker-compose build --no-cache
echo ""

# Start all services
echo "🚀 Starting all services..."
docker-compose up -d
echo ""

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 30

# Check service health
echo ""
echo "📊 Service Status:"
echo "========================================="
docker-compose ps
echo ""

# Show logs for first 60 seconds
echo "📋 Showing startup logs (Ctrl+C to stop)..."
echo "========================================="
docker-compose logs --tail=100 -f &
LOG_PID=$!

# Wait 60 seconds then show summary
sleep 60
kill $LOG_PID 2>/dev/null || true

echo ""
echo "========================================="
echo "  ✅ Deployment Complete!"
echo "========================================="
echo ""
echo "📍 Service Endpoints:"
echo "   - Eureka Dashboard:    http://localhost:8761"
echo "   - API Gateway:         http://localhost:8080"
echo "   - Auth Service:        http://localhost:9030"
echo "   - User Service:        http://localhost:9050"
echo "   - Category Service:    http://localhost:9000"
echo "   - Product Service:     http://localhost:9010"
echo "   - Cart Service:        http://localhost:9060"
echo "   - Order Service:       http://localhost:9070"
echo "   - Notification Svc:    http://localhost:9020"
echo ""
echo "📝 Useful Commands:"
echo "   - View logs:           docker-compose logs -f"
echo "   - Stop services:       docker-compose down"
echo "   - Restart services:    docker-compose restart"
echo "   - Rebuild services:    docker-compose up -d --build"
echo ""
echo "🎉 JKart is running! Visit Eureka Dashboard to see all registered services."
echo ""
