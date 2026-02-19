@echo off
echo ========================================
echo Starting Meet Board Backend
echo ========================================
echo.

echo Step 1: Checking Docker...
docker --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker is not installed or not running!
    echo Please install Docker Desktop from: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)
echo Docker is installed!
echo.

echo Step 2: Stopping any existing containers...
docker-compose down
echo.

echo Step 3: Starting all services...
docker-compose up -d --build
echo.

echo Step 4: Waiting for services to be ready...
echo This may take 30-60 seconds...
timeout /t 30 /nobreak >nul
echo.

echo Step 5: Initializing database...
docker-compose exec -T postgres psql -U rtc_user -d rtc_app < backend\scripts\init-db.sql
echo.

echo Step 6: Creating MinIO bucket...
docker-compose exec -T minio mc alias set myminio http://localhost:9000 admin SecurePassword123! 2>nul
docker-compose exec -T minio mc mb myminio/rtc-files --ignore-existing 2>nul
echo.

echo ========================================
echo Backend is now running!
echo ========================================
echo.
echo API URL: http://localhost:3001
echo Health Check: http://localhost:3001/health
echo.
echo MinIO Console: http://localhost:9001
echo Username: admin
echo Password: SecurePassword123!
echo.
echo To view logs: docker-compose logs -f backend
echo To stop: docker-compose down
echo.
echo Testing backend connection...
timeout /t 3 /nobreak >nul
curl -s http://localhost:3001/health
echo.
echo.
pause
