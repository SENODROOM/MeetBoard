# 🚀 Simple Development Guide

## The Easiest Way to Run Everything

### Prerequisites

1. **Docker Desktop** - Open and wait for it to start
2. **Node.js 20+** - Installed

---

## ⚡ Quick Start

### Method 1: Run Everything Together (Recommended)

From the root directory:

```bash
# First time only - install dependencies
npm install

# Start everything (backend + frontend)
npm run dev
```

This single command will:
- ✅ Start Docker services (PostgreSQL, MongoDB, Redis, MinIO)
- ✅ Initialize database
- ✅ Start backend on http://localhost:3001
- ✅ Start frontend on http://localhost:3000

---

### Method 2: Run Separately (Two Terminals)

**Terminal 1 - Backend:**
```bash
cd backend
npm run dev
```

This will:
- Start Docker services automatically
- Initialize database
- Start backend server with hot-reload

**Terminal 2 - Frontend:**
```bash
cd frontend
npm run dev
```

This will:
- Start frontend with hot-reload
- Open on http://localhost:3000

---

## 📝 Simple Commands

### From Root Directory

```bash
# Start everything
npm run dev

# Stop Docker services
npm run docker:stop

# View logs
npm run docker:logs
```

### From Backend Directory

```bash
cd backend

# Start backend (includes Docker)
npm run dev

# Start backend only (if Docker already running)
npm run dev:local

# Stop Docker
npm run docker:stop
```

### From Frontend Directory

```bash
cd frontend

# Start frontend
npm run dev
```

---

## ✅ That's It!

Just run `npm run dev` and everything starts automatically!

---

## 🐛 If Something Goes Wrong

### Docker Not Running

**Error:** "Docker is not running"

**Fix:**
1. Open Docker Desktop
2. Wait for it to start
3. Run `npm run dev` again

### Port Already in Use

**Fix:**
```bash
# Stop Docker services
npm run docker:stop

# Or kill the process
netstat -ano | findstr :3001
taskkill /PID <PID> /F
```

### Database Not Initialized

**Fix:**
```bash
cd backend
npm run db:init
```

---

## 🛑 Stop Everything

```bash
# Stop Docker services
npm run docker:stop

# Stop frontend/backend
Press Ctrl+C in terminals
```

---

## 🎉 You're Ready!

**To start developing:**

```bash
npm run dev
```

**That's all you need!** 🚀

---

## 📚 More Info

- **DEV_GUIDE.md** - Detailed development guide
- **START.md** - Full startup instructions
- **README_START_HERE.md** - Complete documentation
