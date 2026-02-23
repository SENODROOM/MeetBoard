@echo off
echo ========================================
echo Meet Board - Complete Startup
echo ========================================
echo.

echo Step 1: Checking Docker Desktop...
docker ps >nul 2>&1
if errorlevel 1 (
    echo.
    echo ❌ Docker Desktop is NOT running!
    echo.
    echo Please:
    echo 1. Open Docker Desktop
    echo 2. Wait for "Docker Desktop is running"
    echo 3. Run this script again
    echo.
    pause
    exit /b 1
)
echo ✓ Docker is running
echo.

echo Step 2: Killing processes on ports 3000 and 3001...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :3000') do taskkill /PID %%a /F 2>nul
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :3001') do taskkill /PID %%a /F 2>nul
echo ✓ Ports cleared
echo.

echo Step 3: Starting backend in new window...
start "Backend Server" cmd /k "cd backend && npm run dev"
echo ✓ Backend starting...
echo.

echo Step 4: Waiting 45 seconds for backend to be ready...
timeout /t 45 /nobreak >nul
echo.

echo Step 5: Starting frontend in new window...
start "Frontend Server" cmd /k "cd frontend && npm start"
echo ✓ Frontend starting...
echo.

echo ========================================
echo Startup Complete!
echo ========================================
echo.
echo Backend: http://localhost:3001
echo Frontend: http://localhost:3000
echo.
echo Two new windows opened:
echo 1. Backend Server
echo 2. Frontend Server
echo.
echo Wait for both to show "ready" then open:
echo http://localhost:3000
echo.
echo To stop: Close both terminal windows
echo.
pause
