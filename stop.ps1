# JKart Stop Script (Windows PowerShell)

Write-Host "🛑 Stopping all JKart services..." -ForegroundColor Yellow
docker-compose down

Write-Host "✅ All services stopped successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "💡 To start again, run: .\deploy.ps1" -ForegroundColor Cyan
