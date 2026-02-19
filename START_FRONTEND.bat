@echo off
echo ========================================
echo Starting Meet Board Frontend
echo ========================================
echo.

cd frontend

echo Step 1: Installing dependencies...
call npm install
echo.

echo Step 2: Starting development server...
echo.
echo Frontend will be available at: http://localhost:3000
echo Backend should be running at: http://localhost:3001
echo.
echo Press Ctrl+C to stop the server
echo.

call npm run dev
