# Check which services are running
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Checking Service Status..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$services = @(
    @{Name="Service Registry"; Port=8761},
    @{Name="API Gateway"; Port=8080},
    @{Name="Category Service"; Port=9000},
    @{Name="Notification Service"; Port=9020},
    @{Name="Auth Service"; Port=9030},
    @{Name="User Service"; Port=9050},
    @{Name="Cart Service"; Port=9060},
    @{Name="Order Service"; Port=9070},
    @{Name="Product Service"; Port=9010},
    @{Name="Frontend"; Port=5173}
)

foreach ($service in $services) {
    $port = $service.Port
    $name = $service.Name
    
    $connection = $null
    try {
        $connection = New-Object System.Net.Sockets.TcpClient("localhost", $port)
        Write-Host "[RUNNING] $name - Port $port" -ForegroundColor Green
    } catch {
        Write-Host "[STOPPED] $name - Port $port" -ForegroundColor Red
    } finally {
        if ($connection) {
            $connection.Close()
        }
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Check complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "If services show as STOPPED, check their CMD windows for errors"
Write-Host ""
pause
