#!/bin/bash

# JKart Stop Script
# Compatible with ByteXL Nimbus (bash only)

# Detect docker-compose command
if command -v docker-compose &> /dev/null; then
    COMPOSE_CMD="docker-compose"
elif docker compose version &> /dev/null; then
    COMPOSE_CMD="docker compose"
else
    echo "❌ Docker Compose not found"
    exit 1
fi

echo "🛑 Stopping all JKart services..."
$COMPOSE_CMD down

echo "✅ All services stopped successfully!"
echo ""
echo "💡 To start again, run: bash deploy.sh"
