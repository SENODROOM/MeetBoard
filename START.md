# 🚀 START GUIDE - Meet Board

## Quick Start (Easiest Way)

### Prerequisites

1. **Docker Desktop** - Must be running
2. **Node.js 20+** - Installed

---

## ⚡ Start Everything with One Command

### From Root Directory

```bash
# First time - install dependencies
npm install

# Start everything
npm run dev
```

This will:
- ✅ Start Docker services (PostgreSQL, MongoDB, Redis, MinIO)
- ✅ Initialize database
- ✅ Start backend on http://localhost:3001
- ✅ Start frontend on http://localhost:3000

**Just wait 30-45 seconds and open:** http://localhost:3000

---

## 🎯 Alternative: Run Separately

### Backend

```bash
cd backend
npm install
npm run dev
```

This automatically:
- Starts Docker services
- Initializes database
- Starts backend server

### Frontend

```bash
cd frontend
npm install
npm run dev
```

---

## ✅ Verify It's Working

### Check Backend
```bash
curl http://localhost:3001/health
```

Should return: `{"status":"ok",...}`

### Check Frontend
Open: http://localhost:3000

### Check Docker Services
```bash
docker-compose ps
```

All should show "Up" and "healthy"

---

## 🎮 First Time Use

### 1. Register Account

1. Go to http://localhost:3000
2. Click **"Sign Up"**
3. Enter:
   - Email: test@example.com
   - Username: testuser
   - Password: TestPassword123! (min 12 chars)
4. Click **"Sign Up"**

### 2. Create Room

1. Click **"+ Create Room"**
2. Enter room name
3. Click **"Create"**

### 3. Allow Permissions

- Click **"Allow"** for camera/microphone

### 4. Start Using!

- 🎤 Mute/unmute
- 📹 Camera on/off
- 🖥️ Share screen
- 💬 Chat
- 🎨 Whiteboard

---

## 🐛 Troubleshooting

### Docker Not Running

**Error:** "Docker is not running"

**Fix:**
1. Open Docker Desktop
2. Wait for it to start
3. Run command again

### Registration Fails

**Error:** "Registration failed"

**Fix:**
```bash
cd backend
npm run db:init
docker-compose restart backend
```

### Port Already in Use

**Fix:**
```bash
# Find process
netstat -ano | findstr :3001

# Kill it
taskkill /PID <PID> /F
```

### Frontend Can't Connect

**Fix:**
```bash
# Make sure backend is running
curl http://localhost:3001/health

# If not, start it
cd backend
npm run dev
```

---

## 📝 Available Commands

### Root Directory

```bash
npm run dev          # Start everything
npm run docker:stop  # Stop Docker services
npm run docker:logs  # View logs
npm run setup        # Install all dependencies
```

### Backend

```bash
npm run dev          # Start with Docker
npm run dev:local    # Start without Docker
npm run docker:start # Start Docker only
npm run docker:stop  # Stop Docker
npm run db:init      # Initialize database
```

### Frontend

```bash
npm run dev          # Start development server
npm run build        # Build for production
npm start            # Run production build
```

---

## 🛑 Stop Everything

```bash
# Stop Docker
npm run docker:stop

# Stop frontend/backend
Press Ctrl+C in terminals
```

---

## 🔄 Restart Everything

```bash
# Stop
npm run docker:stop

# Start
npm run dev
```

---

## 📊 Service URLs

- **Frontend:** http://localhost:3000
- **Backend:** http://localhost:3001
- **Backend Health:** http://localhost:3001/health
- **MinIO Console:** http://localhost:9001

---

## 🔐 Default Credentials

- **PostgreSQL:** rtc_user / SecurePassword123!
- **MongoDB:** admin / SecurePassword123!
- **Redis:** SecurePassword123!
- **MinIO:** admin / SecurePassword123!

---

## 🎉 You're Ready!

Just run:
```bash
npm run dev
```

And start using Meet Board! 🚀

---

## 📚 More Documentation

- **SIMPLE_DEV_GUIDE.md** - Quick reference
- **DEV_GUIDE.md** - Detailed development guide
- **README_START_HERE.md** - Complete documentation
- **COMPLETE_GUIDE.md** - Full guide
