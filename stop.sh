#!/bin/bash

# JKart Stop Script

echo "🛑 Stopping all JKart services..."
docker-compose down

echo "✅ All services stopped successfully!"
echo ""
echo "💡 To start again, run: ./deploy.sh"
