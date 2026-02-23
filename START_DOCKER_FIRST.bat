@echo off
echo ========================================
echo Docker Desktop Checker
echo ========================================
echo.

echo Checking if Docker Desktop is running...
docker ps >nul 2>&1

if errorlevel 1 (
    echo.
    echo ❌ Docker Desktop is NOT running!
    echo.
    echo Please follow these steps:
    echo.
    echo 1. Open Docker Desktop application
    echo 2. Wait until you see "Docker Desktop is running"
    echo 3. You should see the Docker whale icon in your system tray
    echo 4. Run this script again to verify
    echo.
    echo Press any key to try opening Docker Desktop...
    pause >nul
    
    echo.
    echo Attempting to start Docker Desktop...
    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    
    echo.
    echo Waiting for Docker Desktop to start...
    echo This may take 30-60 seconds...
    echo.
    
    :WAIT_LOOP
    timeout /t 5 /nobreak >nul
    docker ps >nul 2>&1
    if errorlevel 1 (
        echo Still waiting...
        goto WAIT_LOOP
    )
    
    echo.
    echo ✓ Docker Desktop is now running!
    echo.
) else (
    echo.
    echo ✓ Docker Desktop is running!
    echo.
)

echo ========================================
echo Docker Status
echo ========================================
docker ps
echo.

echo ========================================
echo You can now run:
echo ========================================
echo.
echo   cd backend
echo   npm run dev
echo.
echo Or from root:
echo.
echo   npm run dev
echo.
pause
