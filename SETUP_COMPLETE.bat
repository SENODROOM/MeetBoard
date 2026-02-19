@echo off
echo ========================================
echo Meet Board - Complete Setup
echo ========================================
echo.

echo This script will:
echo 1. Stop any existing containers
echo 2. Build and start all services
echo 3. Initialize the database
echo 4. Create storage bucket
echo 5. Test the connection
echo.
pause

echo.
echo Step 1: Stopping existing containers...
docker-compose down
echo.

echo Step 2: Building and starting services...
echo This may take 2-3 minutes...
docker-compose up -d --build
echo.

echo Step 3: Waiting for services to be ready...
timeout /t 45 /nobreak >nul
echo.

echo Step 4: Initializing database...
docker-compose exec -T postgres psql -U rtc_user -d rtc_app < backend\scripts\init-db.sql
if %errorlevel% neq 0 (
    echo.
    echo WARNING: Database initialization may have failed
    echo Trying again...
    timeout /t 5 /nobreak >nul
    docker-compose exec -T postgres psql -U rtc_user -d rtc_app < backend\scripts\init-db.sql
)
echo.

echo Step 5: Creating MinIO bucket...
docker-compose exec -T minio mc alias set myminio http://localhost:9000 admin SecurePassword123! 2>nul
docker-compose exec -T minio mc mb myminio/rtc-files --ignore-existing 2>nul
echo.

echo Step 6: Testing backend connection...
timeout /t 5 /nobreak >nul
curl -s http://localhost:3001/health
echo.
echo.

echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo Backend: http://localhost:3001
echo Frontend: Run START_FRONTEND.bat
echo.
echo To view logs: docker-compose logs -f
echo To stop: docker-compose down
echo.
pause
