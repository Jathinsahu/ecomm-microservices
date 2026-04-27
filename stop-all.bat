@echo off
echo ========================================
echo JNexus Commerce - Stopping All Services
echo ========================================
echo.

echo Stopping backend services (Java processes)...
taskkill /F /IM java.exe /T >nul 2>&1
if %errorlevel% equ 0 (
    echo Stopped Java processes
) else (
    echo No Java processes running
)

echo.
echo Stopping frontend (Node.js processes)...
taskkill /F /IM node.exe /T >nul 2>&1
if %errorlevel% equ 0 (
    echo Stopped Node.js processes
) else (
    echo No Node.js processes running
)

echo.
echo Stopping npm processes...
taskkill /F /IM npm.cmd /T >nul 2>&1
if %errorlevel% equ 0 (
    echo Stopped npm processes
) else (
    echo No npm processes running
)

echo.
echo ========================================
echo All services stopped!
echo ========================================
echo.
pause
