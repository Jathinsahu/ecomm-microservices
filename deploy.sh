#!/bin/bash

# JKart Production Deployment Script
# Single command to deploy all microservices
# Compatible with ByteXL Nimbus (bash only)

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
    echo "Then run: bash deploy.sh"
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not installed."
    exit 1
fi

# Detect docker-compose command (v1 or v2)
if command -v docker-compose &> /dev/null; then
    COMPOSE_CMD="docker-compose"
elif docker compose version &> /dev/null; then
    COMPOSE_CMD="docker compose"
else
    echo "❌ Docker Compose not found"
    exit 1
fi

echo "✅ Prerequisites checked"
echo ""

# Stop any running containers
echo "🛑 Stopping existing containers..."
$COMPOSE_CMD down 2>/dev/null || true
echo ""

# Build all services
echo "🔨 Building all microservices (this may take 10-15 minutes)..."
$COMPOSE_CMD build --no-cache
echo ""

# Start all services
echo "🚀 Starting all services..."
$COMPOSE_CMD up -d
echo ""

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 30

# Check service health
echo ""
echo "📊 Service Status:"
echo "========================================="
$COMPOSE_CMD ps
echo ""

echo "✅ Deployment Complete!"
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
echo "   - View logs:           $COMPOSE_CMD logs -f"
echo "   - Stop services:       $COMPOSE_CMD down"
echo "   - Restart services:    $COMPOSE_CMD restart"
echo "   - Rebuild services:    $COMPOSE_CMD up -d --build"
echo ""
echo "🎉 JKart is running! Visit Eureka Dashboard to see all registered services."
echo ""
