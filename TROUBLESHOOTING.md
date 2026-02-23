# 🔧 Troubleshooting Guide

Quick solutions to common problems.

---

## 🚨 Problem: Docker Not Running

**Error Message:**
```
open //./pipe/dockerDesktopLinuxEngine: The system cannot find the file specified
```

**What it means:** Docker Desktop is not running

**Solution:**
1. Press Windows Key
2. Type "Docker Desktop"
3. Open the application
4. Wait for "Docker Desktop is running" (30-60 seconds)
5. Look for Docker whale icon in system tray
6. Run your command again

**Verify it's working:**
```bash
docker ps
```

---

## 🚨 Problem: Port 3000 Already in Use

**Error Message:**
```
Error: listen EADDRINUSE: address already in use :::3000
```

**What it means:** Another application is using port 3000

**Solution 1 (Easy):**
Double-click `KILL_PORTS.bat`

**Solution 2 (Manual):**
```bash
# Find what's using port 3000
netstat -ano | findstr :3000

# You'll see something like:
# TCP    0.0.0.0:3000    0.0.0.0:0    LISTENING    12345

# Kill the process (replace 12345 with your PID)
taskkill /PID 12345 /F
```

**Solution 3 (Nuclear):**
```bash
# Kill all Node.js processes
taskkill /F /IM node.exe
```

---

## 🚨 Problem: Port 3001 Already in Use

**Error Message:**
```
Error: listen EADDRINUSE: address already in use :::3001
```

**Solution:**
```bash
# Find what's using port 3001
netstat -ano | findstr :3001

# Kill the process
taskkill /PID <PID> /F
```

Or use `KILL_PORTS.bat`

---

## 🚨 Problem: Database Not Initialized

**Error Message:**
```
relation "users" does not exist
```

**What it means:** Database tables haven't been created

**Solution:**
```bash
cd backend
npm run db:init
```

**Manual solution:**
```bash
docker-compose exec -T postgres psql -U rtc_user -d rtc_app < backend/scripts/init-db.sql
```

---

## 🚨 Problem: Frontend Build Error (fabric.js)

**Error Message:**
```
Could not find a declaration file for module 'fabric'
```

**What it means:** TypeScript can't find fabric.js types

**Solution:**
This should already be fixed! But if you still see it:

```bash
cd frontend
npm install @types/fabric
```

The fix is already in place:
- `@ts-ignore` comment in `frontend/src/hooks/useWhiteboard.ts`
- Type declaration in `frontend/src/types/fabric.d.ts`

---

## 🚨 Problem: Docker Images Won't Download

**Error Message:**
```
unable to get image 'mongo:7'
```

**What it means:** Docker can't download images

**Solution:**
1. Check internet connection
2. Make sure Docker Desktop is fully started
3. Try manually:
```bash
docker-compose down
docker-compose pull
docker-compose up -d
```

---

## 🚨 Problem: Backend Won't Start

**Symptoms:**
- Backend terminal shows errors
- Can't connect to http://localhost:3001

**Solution Checklist:**
1. ✅ Docker Desktop is running
2. ✅ Port 3001 is free
3. ✅ All Docker services are running: `docker ps`
4. ✅ Database is initialized: `npm run db:init`
5. ✅ Environment variables are set (check `backend/.env`)

**Try:**
```bash
# Stop everything
docker-compose down
taskkill /F /IM node.exe

# Start fresh
cd backend
npm run dev
```

---

## 🚨 Problem: Frontend Won't Start

**Symptoms:**
- Frontend terminal shows errors
- Can't connect to http://localhost:3000

**Solution Checklist:**
1. ✅ Port 3000 is free
2. ✅ Dependencies installed: `npm install`
3. ✅ Backend is running first
4. ✅ Environment variables are set (check `frontend/.env.local`)

**Try:**
```bash
# Kill port 3000
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# Reinstall and start
cd frontend
npm install
npm start
```

---

## 🚨 Problem: Can't Connect to Backend from Frontend

**Symptoms:**
- Frontend loads but API calls fail
- Console shows connection errors

**Solution:**
1. Check backend is running: http://localhost:3001
2. Check `frontend/.env.local`:
```
NEXT_PUBLIC_API_URL=http://localhost:3001
NEXT_PUBLIC_WS_URL=http://localhost:3001
```
3. Restart frontend after changing .env.local

---

## 🚨 Problem: WebRTC Video Not Working

**Symptoms:**
- Can't see video
- Camera not detected

**Solution:**
1. Allow camera/microphone permissions in browser
2. Use HTTPS or localhost (WebRTC requirement)
3. Check browser console for errors
4. Try different browser (Chrome recommended)

---

## 🚨 Problem: Whiteboard Not Working

**Symptoms:**
- Can't draw on whiteboard
- Whiteboard is blank

**Solution:**
1. Check browser console for errors
2. Make sure Socket.io is connected
3. Check backend logs for whiteboard events
4. Try refreshing the page

---

## 🚨 Problem: Chat Not Working

**Symptoms:**
- Messages don't send
- Can't see other users' messages

**Solution:**
1. Check Socket.io connection in browser console
2. Check backend logs for socket events
3. Make sure MongoDB is running: `docker ps`
4. Check MongoDB connection in backend logs

---

## 🔄 Universal Reset (When Nothing Works)

**Step 1: Stop Everything**
```bash
# Stop Docker
docker-compose down

# Kill all Node processes
taskkill /F /IM node.exe

# Kill all Docker processes (if needed)
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
```

**Step 2: Clear Ports**
Run `KILL_PORTS.bat` or:
```bash
netstat -ano | findstr :3000
taskkill /PID <PID> /F

netstat -ano | findstr :3001
taskkill /PID <PID> /F
```

**Step 3: Restart Computer**
This clears all ports and processes

**Step 4: Start Fresh**
1. Open Docker Desktop
2. Wait for it to fully start
3. Run `START_EVERYTHING.bat`

---

## 🧪 Diagnostic Commands

**Check Docker:**
```bash
docker --version
docker ps
docker-compose ps
```

**Check Ports:**
```bash
netstat -ano | findstr :3000
netstat -ano | findstr :3001
netstat -ano | findstr :5432
netstat -ano | findstr :27017
```

**Check Services:**
```bash
# PostgreSQL
docker-compose exec postgres psql -U rtc_user -d rtc_app -c "\dt"

# MongoDB
docker-compose exec mongodb mongosh -u rtc_user -p SecurePassword123! --eval "db.adminCommand('ping')"

# Redis
docker-compose exec redis redis-cli ping

# MinIO
curl http://localhost:9000/minio/health/live
```

**Check Logs:**
```bash
# Backend logs
docker-compose logs backend

# PostgreSQL logs
docker-compose logs postgres

# MongoDB logs
docker-compose logs mongodb

# All logs
docker-compose logs
```

---

## 📋 Pre-Flight Checklist

Before starting, verify:

- [ ] Docker Desktop installed
- [ ] Docker Desktop running (check system tray)
- [ ] Node.js v18+ installed: `node --version`
- [ ] Port 3000 free: `netstat -ano | findstr :3000`
- [ ] Port 3001 free: `netstat -ano | findstr :3001`
- [ ] Internet connection (for Docker images)
- [ ] Dependencies installed in backend: `cd backend && npm install`
- [ ] Dependencies installed in frontend: `cd frontend && npm install`

---

## 🆘 Still Stuck?

1. **Read COMPLETE_STARTUP_GUIDE.md** - Detailed step-by-step guide
2. **Check all terminals** - Look for error messages
3. **Check browser console** - Press F12 to see errors
4. **Try the nuclear reset** - Stop everything and restart computer
5. **Check Docker Desktop** - Make sure it's running and healthy

---

## 💡 Prevention Tips

1. **Always start Docker Desktop first**
2. **Wait for Docker to fully start** (30-60 seconds)
3. **Start backend before frontend**
4. **Keep terminals open** while using the app
5. **Don't close Docker Desktop** while app is running
6. **Use KILL_PORTS.bat** before starting if you had issues before
7. **Run `npm run db:init`** if you see database errors

---

## ✅ How to Know Everything is Working

**Backend Terminal Shows:**
```
✓ All services are ready!
Server running on port 3001
```

**Frontend Terminal Shows:**
```
ready - started server on 0.0.0.0:3000
```

**Browser:**
- http://localhost:3000 loads
- You can register/login
- No errors in console (F12)

**Docker:**
```bash
docker ps
# Should show 4 containers: postgres, mongodb, redis, minio
```

---

## 🎯 Quick Reference

| Problem | Quick Fix |
|---------|-----------|
| Docker not running | Open Docker Desktop |
| Port in use | Run `KILL_PORTS.bat` |
| Database error | `npm run db:init` |
| Build error | `npm install` |
| Nothing works | Restart computer |

---

## 📞 Command Quick Reference

```bash
# Start everything
START_EVERYTHING.bat

# Clear ports
KILL_PORTS.bat

# Backend
cd backend
npm run dev

# Frontend
cd frontend
npm start

# Stop Docker
docker-compose down

# Check Docker
docker ps

# Initialize database
cd backend
npm run db:init

# Kill all Node
taskkill /F /IM node.exe
```

---

That's it! Most issues can be solved by:
1. Making sure Docker Desktop is running
2. Clearing ports with KILL_PORTS.bat
3. Starting backend first, then frontend
4. Waiting for services to fully start

Good luck! 🚀
