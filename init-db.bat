@echo off
echo =========================================
echo Initializing Database
echo =========================================
echo.

echo Waiting for PostgreSQL to be ready...
timeout /t 10 /nobreak >nul

echo Creating database tables...
docker-compose exec -T postgres psql -U rtc_user -d rtc_app < backend\scripts\init-db.sql

if %errorlevel% equ 0 (
    echo.
    echo Database initialized successfully!
    echo.
) else (
    echo.
    echo Database initialization failed!
    echo Please check the logs: docker-compose logs postgres
    echo.
    exit /b 1
)

echo =========================================
echo Database is ready!
echo =========================================
pause
