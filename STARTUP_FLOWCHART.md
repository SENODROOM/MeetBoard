# 🔄 Startup Flowchart

Visual guide to starting Meet Board.

---

## 📊 Automatic Startup Flow

```
START
  │
  ├─→ Open Docker Desktop
  │     │
  │     ├─→ Wait for "Docker Desktop is running"
  │     │
  │     └─→ ✓ Docker Ready
  │
  ├─→ Double-click START_EVERYTHING.bat
  │     │
  │     ├─→ Check Docker is running
  │     │     │
  │     │     ├─→ ❌ Not running → Show error → EXIT
  │     │     │
  │     │     └─→ ✓ Running → Continue
  │     │
  │     ├─→ Clear ports 3000 and 3001
  │     │     │
  │     │     └─→ ✓ Ports cleared
  │     │
  │     ├─→ Start Backend (new window)
  │     │     │
  │     │     ├─→ Start Docker services
  │     │     │     │
  │     │     ├─→ Initialize database
  │     │     │     │
  │     │     └─→ Start Express server
  │     │           │
  │     │           └─→ ✓ Backend running on :3001
  │     │
  │     ├─→ Wait 45 seconds
  │     │
  │     └─→ Start Frontend (new window)
  │           │
  │           ├─→ Build Next.js
  │           │     │
  │           └─→ Start server
  │                 │
  │                 └─→ ✓ Frontend running on :3000
  │
  └─→ Open http://localhost:3000
        │
        └─→ ✓ SUCCESS! 🎉
```

---

## 📊 Manual Startup Flow

```
START
  │
  ├─→ Open Docker Desktop
  │     │
  │     └─→ Wait for "running" (30-60s)
  │           │
  │           └─→ ✓ Docker Ready
  │
  ├─→ Clear Ports (if needed)
  │     │
  │     ├─→ Run KILL_PORTS.bat
  │     │     │
  │     │     └─→ ✓ Ports 3000 & 3001 free
  │     │
  │     └─→ Or manually:
  │           │
  │           ├─→ netstat -ano | findstr :3000
  │           │
  │           └─→ taskkill /PID <PID> /F
  │
  ├─→ Terminal 1: Start Backend
  │     │
  │     ├─→ cd backend
  │     │
  │     └─→ npm run dev
  │           │
  │           ├─→ Check Docker running
  │           │     │
  │           │     ├─→ ❌ Not running → Error → EXIT
  │           │     │
  │           │     └─→ ✓ Running → Continue
  │           │
  │           ├─→ Start Docker services
  │           │     │
  │           │     ├─→ PostgreSQL
  │           │     ├─→ MongoDB
  │           │     ├─→ Redis
  │           │     └─→ MinIO
  │           │           │
  │           │           └─→ Wait 30s for services
  │           │
  │           ├─→ Initialize database
  │           │     │
  │           │     └─→ Create tables
  │           │
  │           └─→ Start Express server
  │                 │
  │                 ├─→ Connect to PostgreSQL
  │                 ├─→ Connect to MongoDB
  │                 ├─→ Connect to Redis
  │                 ├─→ Setup Socket.io
  │                 │
  │                 └─→ ✓ Server running on :3001
  │
  ├─→ Terminal 2: Start Frontend
  │     │
  │     ├─→ cd frontend
  │     │
  │     └─→ npm start
  │           │
  │           ├─→ Build Next.js
  │           │     │
  │           │     ├─→ Compile TypeScript
  │           │     ├─→ Optimize pages
  │           │     └─→ Generate static files
  │           │
  │           └─→ Start Next.js server
  │                 │
  │                 └─→ ✓ Server running on :3000
  │
  └─→ Open Browser
        │
        └─→ http://localhost:3000
              │
              └─→ ✓ SUCCESS! 🎉
```

---

## 🔍 Troubleshooting Flow

```
PROBLEM DETECTED
  │
  ├─→ Docker not running?
  │     │
  │     ├─→ Error: "pipe/dockerDesktopLinuxEngine"
  │     │     │
  │     │     └─→ FIX: Open Docker Desktop
  │     │           │
  │     │           └─→ Wait for "running"
  │     │                 │
  │     │                 └─→ Retry
  │     │
  │     └─→ Verify: docker ps
  │
  ├─→ Port already in use?
  │     │
  │     ├─→ Error: "EADDRINUSE: address already in use"
  │     │     │
  │     │     └─→ FIX: Run KILL_PORTS.bat
  │     │           │
  │     │           └─→ Or manually:
  │     │                 │
  │     │                 ├─→ netstat -ano | findstr :3000
  │     │                 │
  │     │                 └─→ taskkill /PID <PID> /F
  │     │
  │     └─→ Retry
  │
  ├─→ Database error?
  │     │
  │     ├─→ Error: "relation 'users' does not exist"
  │     │     │
  │     │     └─→ FIX: cd backend && npm run db:init
  │     │           │
  │     │           └─→ Retry
  │     │
  │     └─→ Verify: docker ps (check postgres)
  │
  ├─→ Build error?
  │     │
  │     ├─→ Error: "Could not find module 'fabric'"
  │     │     │
  │     │     └─→ FIX: cd frontend && npm install
  │     │           │
  │     │           └─→ Retry
  │     │
  │     └─→ Check: package.json dependencies
  │
  └─→ Nothing works?
        │
        └─→ NUCLEAR RESET:
              │
              ├─→ docker-compose down
              │
              ├─→ taskkill /F /IM node.exe
              │
              ├─→ Run KILL_PORTS.bat
              │
              ├─→ Restart computer
              │
              └─→ Start from beginning
```

---

## ⏱️ Timeline

```
Time    Action                          Status
─────────────────────────────────────────────────
0:00    Open Docker Desktop             Starting...
0:30    Docker ready                    ✓ Ready
0:31    Run START_EVERYTHING.bat        Starting...
0:32    Clear ports                     ✓ Done
0:33    Start backend                   Starting...
0:34    Docker services starting        Pulling images...
1:30    Docker services ready           ✓ Ready
1:31    Database initializing           Creating tables...
1:35    Database ready                  ✓ Ready
1:36    Backend server starting         Connecting...
1:40    Backend ready                   ✓ Running on :3001
1:41    Start frontend                  Starting...
1:42    Building Next.js                Compiling...
2:30    Build complete                  ✓ Done
2:31    Frontend server starting        Starting...
2:35    Frontend ready                  ✓ Running on :3000
2:36    Open browser                    Loading...
2:40    Application loaded              ✓ SUCCESS! 🎉

Total time: ~2-3 minutes (first run)
Total time: ~1 minute (subsequent runs)
```

---

## 🎯 Decision Tree

```
Do you want to start the app?
  │
  ├─→ YES
  │     │
  │     ├─→ Is Docker Desktop running?
  │     │     │
  │     │     ├─→ NO → Open Docker Desktop → Wait → Continue
  │     │     │
  │     │     └─→ YES → Continue
  │     │
  │     ├─→ Do you want automatic or manual?
  │     │     │
  │     │     ├─→ AUTOMATIC
  │     │     │     │
  │     │     │     └─→ Run START_EVERYTHING.bat
  │     │     │           │
  │     │     │           └─→ Wait 2-3 minutes
  │     │     │                 │
  │     │     │                 └─→ Open http://localhost:3000
  │     │     │
  │     │     └─→ MANUAL
  │     │           │
  │     │           ├─→ Terminal 1: cd backend && npm run dev
  │     │           │     │
  │     │           │     └─→ Wait for "Server running on :3001"
  │     │           │
  │     │           ├─→ Terminal 2: cd frontend && npm start
  │     │           │     │
  │     │           │     └─→ Wait for "ready - started server"
  │     │           │
  │     │           └─→ Open http://localhost:3000
  │     │
  │     └─→ Did it work?
  │           │
  │           ├─→ YES → ✓ SUCCESS! Use the app
  │           │
  │           └─→ NO → Check TROUBLESHOOTING.md
  │
  └─→ NO → Have a nice day! 👋
```

---

## 🔄 Stop Flow

```
Want to stop the app?
  │
  ├─→ Quick stop
  │     │
  │     ├─→ Press Ctrl+C in backend terminal
  │     │
  │     ├─→ Press Ctrl+C in frontend terminal
  │     │
  │     └─→ ✓ Stopped (Docker still running)
  │
  ├─→ Full stop
  │     │
  │     ├─→ Press Ctrl+C in both terminals
  │     │
  │     ├─→ Run: docker-compose down
  │     │
  │     └─→ ✓ Everything stopped
  │
  └─→ Nuclear stop
        │
        ├─→ taskkill /F /IM node.exe
        │
        ├─→ docker-compose down
        │
        ├─→ Close Docker Desktop
        │
        └─→ ✓ Everything killed
```

---

## 📊 Service Dependencies

```
Frontend (Port 3000)
  │
  └─→ Depends on Backend (Port 3001)
        │
        ├─→ Depends on PostgreSQL (Port 5432)
        │     │
        │     └─→ Depends on Docker
        │
        ├─→ Depends on MongoDB (Port 27017)
        │     │
        │     └─→ Depends on Docker
        │
        ├─→ Depends on Redis (Port 6379)
        │     │
        │     └─→ Depends on Docker
        │
        └─→ Depends on MinIO (Port 9000)
              │
              └─→ Depends on Docker

Therefore: Start Docker → Backend → Frontend
```

---

## ✅ Health Check Flow

```
Is everything working?
  │
  ├─→ Check Docker
  │     │
  │     ├─→ Run: docker ps
  │     │
  │     └─→ Should show 4 containers:
  │           - postgres
  │           - mongodb
  │           - redis
  │           - minio
  │
  ├─→ Check Backend
  │     │
  │     ├─→ Terminal shows: "Server running on :3001"
  │     │
  │     └─→ Browser: http://localhost:3001
  │           │
  │           └─→ Should return JSON
  │
  ├─→ Check Frontend
  │     │
  │     ├─→ Terminal shows: "ready - started server"
  │     │
  │     └─→ Browser: http://localhost:3000
  │           │
  │           └─→ Should show login page
  │
  └─→ All checks passed?
        │
        ├─→ YES → ✓ Everything working!
        │
        └─→ NO → Check TROUBLESHOOTING.md
```

---

## 🎯 Quick Reference

**Start:** `START_EVERYTHING.bat` or manual commands
**Stop:** `Ctrl+C` in terminals + `docker-compose down`
**Fix ports:** `KILL_PORTS.bat`
**Fix database:** `cd backend && npm run db:init`
**Check status:** `docker ps`

---

That's the complete flow! 🚀

For detailed instructions, see:
- **COMPLETE_STARTUP_GUIDE.md**
- **TROUBLESHOOTING.md**
- **QUICK_REFERENCE.md**
