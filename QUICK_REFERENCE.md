# ⚡ Quick Reference - Meet Board

One-page guide to get you started fast.

---

## 🚀 Start Everything (3 Steps)

### Step 1: Open Docker Desktop
Press Windows Key → Type "Docker Desktop" → Open → Wait for "running"

### Step 2: Start Backend
```bash
cd backend
npm run dev
```
Wait for: "✓ All services are ready!" and "Server running on port 3001"

### Step 3: Start Frontend (New Terminal)
```bash
cd frontend
npm start
```
Wait for: "ready - started server on 0.0.0.0:3000"

### Open Browser
http://localhost:3000

---

## 🎯 Even Easier

Double-click: `START_EVERYTHING.bat`

---

## 🚨 Quick Fixes

| Problem | Solution |
|---------|----------|
| Docker not running | Open Docker Desktop |
| Port 3000 in use | Run `KILL_PORTS.bat` |
| Port 3001 in use | Run `KILL_PORTS.bat` |
| Database error | `cd backend && npm run db:init` |
| Build error | `cd frontend && npm install` |

---

## 🛑 Stop Everything

```bash
# Press Ctrl+C in both terminals
docker-compose down
```

---

## 📦 Commands

```bash
# Backend
cd backend
npm run dev          # Start with Docker
npm run dev:local    # Start without Docker
npm run db:init      # Initialize database

# Frontend
cd frontend
npm start            # Build and start
npm run dev          # Development mode

# Docker
docker-compose down  # Stop all services
docker ps            # Check running containers

# Ports
KILL_PORTS.bat       # Clear ports 3000 and 3001
```

---

## 🌐 URLs

- Frontend: http://localhost:3000
- Backend: http://localhost:3001
- MinIO: http://localhost:9000 (admin / SecurePassword123!)

---

## ✅ Success Check

**Backend shows:**
```
✓ All services are ready!
Server running on port 3001
```

**Frontend shows:**
```
ready - started server on 0.0.0.0:3000
```

**Browser:**
- http://localhost:3000 loads
- Can register/login
- No console errors

---

## 📚 More Help

- **COMPLETE_STARTUP_GUIDE.md** - Detailed instructions
- **TROUBLESHOOTING.md** - Common problems
- **README.md** - Full documentation

---

## 💡 Remember

1. Start Docker Desktop first
2. Wait for Docker to be ready
3. Start backend before frontend
4. Keep terminals open
5. Use KILL_PORTS.bat if ports are busy

That's it! 🚀
