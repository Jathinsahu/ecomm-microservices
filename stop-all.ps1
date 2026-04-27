# JNexus Commerce - Stop All Services Script
# This script stops all running Java and Node.js processes

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "JNexus Commerce - Stopping All Services" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Stop Java processes (Spring Boot services)
Write-Host "Stopping backend services (Java processes)..." -ForegroundColor Yellow
$javaProcesses = Get-Process -Name "java" -ErrorAction SilentlyContinue
if ($javaProcesses) {
    $javaProcesses | Stop-Process -Force
    Write-Host "Stopped $($javaProcesses.Count) Java process(es)" -ForegroundColor Green
} else {
    Write-Host "No Java processes running" -ForegroundColor Green
}

# Stop Node.js processes (Frontend)
Write-Host ""
Write-Host "Stopping frontend (Node.js processes)..." -ForegroundColor Yellow
$nodeProcesses = Get-Process -Name "node" -ErrorAction SilentlyContinue
if ($nodeProcesses) {
    $nodeProcesses | Stop-Process -Force
    Write-Host "Stopped $($nodeProcesses.Count) Node.js process(es)" -ForegroundColor Green
} else {
    Write-Host "No Node.js processes running" -ForegroundColor Green
}

# Stop npm processes
Write-Host ""
Write-Host "Stopping npm processes..." -ForegroundColor Yellow
$npmProcesses = Get-Process -Name "npm" -ErrorAction SilentlyContinue
if ($npmProcesses) {
    $npmProcesses | Stop-Process -Force
    Write-Host "Stopped $($npmProcesses.Count) npm process(es)" -ForegroundColor Green
} else {
    Write-Host "No npm processes running" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "All services stopped!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
