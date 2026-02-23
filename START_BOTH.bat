@echo off
echo ========================================
echo Starting Meet Board - Full Stack
echo ========================================
echo.

echo Checking Docker Desktop...
docker --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo ERROR: Docker Desktop is not running!
    echo.
    echo Please:
    echo 1. Open Docker Desktop
    echo 2. Wait for it to start completely
    echo 3. Run this script again
    echo.
    pause
    exit /b 1
)

echo Docker is running!
echo.

echo Te======================================
echo STEP 1: Starting Backend Services
echo ========================================
echo.

echo Stopping any existing containers...
docker-compose down 2>nul
echo.

echo Starting PostgreSQL, MongoDB, Redis, MinIO, and Backend...
echo This will take 2-3 minutes...
start /B docker-compose up --build

echo.
echo Waiting for services to start (45 seconds)...
timeout /t 45 /nobreak >nul

echo.
echo Initializing database...
docker-compose exec -T postgres psql -U rtc_user -d rtc_app < backend\scripts\init-db.sql
if errorlevel 1 (
    echo Database initialization failed, trying again...
    timeout /t 5 /nobreak >nul
    docker-compose exec -T postgres psql -U rtc_user -d rtc_app < backend\scripts\init-db.sql
)

echo.
echo Creating storage bucket...
docker-compose exec -T minio mc alias set myminio http://localhost:9000 admin SecurePassword123! 2>nul
docker-compose exec -T minio mc mb myminio/rtc-files --ignore-existing 2>nul

echo.
echo Testing backend...
timeout /t 3 /nobreak >nul
curl -s http://localhost:3001/health
echo.

echo.
echo ========================================
echo STEP 2: Starting Frontend
echo ========================================
echo.

cd frontend

if not exist node_modules (
    echo Installing frontend dependencies...
    call npm install
    echo.
)

echo Starting frontend development server...
echo.
echo Frontend will open on: http://localhost:3000
echo Backend is running on: http://localhost:3001
echo.
echo Press Ctrl+C to stop the frontend
echo To stop backend: docker-compose down
echo.

call npm run dev
