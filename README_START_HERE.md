# 🚀 START HERE - Meet Board

## ⚠️ IMPORTANT: Before You Start

### 1. Start Docker Desktop

**You MUST start Docker Desktop first!**

1. **Open Docker Desktop** application
2. **Wait** until you see "Docker Desktop is running"
3. **Verify** by running in terminal:
   ```bash
   docker --version
   ```
   Should show: `Docker version 20.x.x` or similar

**If Docker Desktop is not installed:**
- Download from: https://www.docker.com/products/docker-desktop
- Install and restart your computer
- Start Docker Desktop

---

## 🎯 Quick Start (After Docker is Running)

### Method 1: One-Click Start (Easiest)

**Double-click:** `START_BOTH.bat`

This will:
1. ✅ Start all backend services
2. ✅ Initialize database
3. ✅ Start frontend
4. ✅ Open on http://localhost:3000

**Just wait 2-3 minutes and it's ready!**

---

### Method 2: Step by Step

#### Step 1: Start Backend

Open PowerShell/Command Prompt:

```bash
docker-compose up --build
```

**Wait 45 seconds** for services to start.

#### Step 2: Initialize Database

Open **another** terminal:

```bash
docker-compose exec -T postgres psql -U rtc_user -d rtc_app < backend/scripts/init-db.sql
```

#### Step 3: Create Storage

```bash
docker-compose exec minio mc alias set myminio http://localhost:9000 admin SecurePassword123!
docker-compose exec minio mc mb myminio/rtc-files --ignore-existing
```

#### Step 4: Start Frontend

Open **another** terminal:

```bash
cd frontend
npm install
npm run dev
```

#### Step 5: Open Browser

Go to: **http://localhost:3000**

---

## ✅ Verify Everything Works

### 1. Check Docker Desktop
- Open Docker Desktop
- Should show containers running:
  - meetboard-postgres-1
  - meetboard-mongodb-1
  - meetboard-redis-1
  - meetboard-minio-1
  - meetboard-backend-1

### 2. Check Backend
```bash
curl http://localhost:3001/health
```
Should return: `{"status":"ok","timestamp":"..."}`

### 3. Check Frontend
- Open: http://localhost:3000
- Should see Meet Board landing page

### 4. Check Database
```bash
docker-compose exec postgres psql -U rtc_user -d rtc_app -c "\dt"
```
Should list tables: users, sessions, rooms, etc.

---

## 🎮 First Time Use

### 1. Register Account

1. Go to http://localhost:3000
2. Click **"Sign Up"**
3. Fill in:
   - **Email:** test@example.com
   - **Username:** testuser
   - **Password:** TestPassword123! (minimum 12 characters)
4. Click **"Sign Up"**
5. You'll be logged in automatically

### 2. Create Your First Room

1. On Dashboard, click **"+ Create Room"**
2. Enter room name: **"My First Meeting"**
3. Click **"Create"**
4. You'll join the room automatically

### 3. Allow Camera/Microphone

- Browser will ask for permissions
- Click **"Allow"**
- Your video will appear

### 4. Use Features

**Video Controls (bottom):**
- 🎤 **Microphone** - Click to mute/unmute
- 📹 **Camera** - Click to turn on/off
- 🖥️ **Screen Share** - Click to share screen

**Chat (right sidebar):**
- Click **"Chat"** tab
- Type message and press Enter

**Whiteboard (right sidebar):**
- Click **"Whiteboard"** tab
- Use pen to draw
- Pick colors
- Adjust brush size

---

## 🐛 Common Issues & Solutions

### Issue 1: Docker Desktop Not Running

**Error:** "Docker Desktop is not running" or "Cannot connect to Docker"

**Solution:**
1. Open Docker Desktop application
2. Wait until it shows "Docker Desktop is running"
3. Try again

---

### Issue 2: Registration Fails

**Error:** "Registration failed" or "relation users does not exist"

**Solution:**
```bash
# Reinitialize database
docker-compose exec -T postgres psql -U rtc_user -d rtc_app < backend/scripts/init-db.sql

# Restart backend
docker-compose restart backend

# Try registering again
```

---

### Issue 3: Port Already in Use

**Error:** "Port 3000 or 3001 already in use"

**Solution:**
```bash
# Find what's using the port
netstat -ano | findstr :3000
netstat -ano | findstr :3001

# Kill the process (replace PID with actual number)
taskkill /PID <PID> /F

# Or stop other services and try again
```

---

### Issue 4: Frontend Won't Start

**Error:** npm errors or "Cannot find module"

**Solution:**
```bash
cd frontend
rmdir /s /q node_modules
npm install
npm run dev
```

---

### Issue 5: Can't See Video

**Problem:** Video not showing or camera not working

**Solution:**
1. Click lock icon in browser address bar
2. Go to Site Settings
3. Allow Camera and Microphone
4. Refresh the page
5. Try Chrome browser (best compatibility)

---

### Issue 6: Backend Not Responding

**Error:** "Cannot connect to backend" or 500 errors

**Solution:**
```bash
# Check backend logs
docker-compose logs backend

# Restart backend
docker-compose restart backend

# If still not working, restart everything
docker-compose down
docker-compose up --build
```

---

## 🛑 Stop Everything

### Stop Frontend
- Press `Ctrl+C` in the terminal running frontend

### Stop Backend
```bash
docker-compose down
```

### Stop and Remove All Data (Fresh Start)
```bash
docker-compose down -v
```

---

## 🔄 Restart Everything (Fresh Start)

```bash
# Stop everything
docker-compose down -v

# Start backend
docker-compose up --build

# Wait 45 seconds, then in another terminal:
docker-compose exec -T postgres psql -U rtc_user -d rtc_app < backend/scripts/init-db.sql

# Start frontend
cd frontend
npm run dev
```

---

## 📊 Service Information

### URLs
- **Frontend:** http://localhost:3000
- **Backend API:** http://localhost:3001
- **Backend Health:** http://localhost:3001/health
- **MinIO Console:** http://localhost:9001

### Default Credentials

**PostgreSQL:**
- Host: localhost:5432
- Database: rtc_app
- User: rtc_user
- Password: SecurePassword123!

**MongoDB:**
- Host: localhost:27017
- User: admin
- Password: SecurePassword123!

**Redis:**
- Host: localhost:6379
- Password: SecurePassword123!

**MinIO:**
- Console: http://localhost:9001
- Username: admin
- Password: SecurePassword123!

---

## 📝 Useful Commands

```bash
# View backend logs
docker-compose logs -f backend

# View all logs
docker-compose logs -f

# Check service status
docker-compose ps

# Restart backend
docker-compose restart backend

# Access PostgreSQL
docker-compose exec postgres psql -U rtc_user -d rtc_app

# Access MongoDB
docker-compose exec mongodb mongosh -u admin -p SecurePassword123!

# Access Redis
docker-compose exec redis redis-cli -a SecurePassword123!

# Test backend health
curl http://localhost:3001/health

# Initialize database
docker-compose exec -T postgres psql -U rtc_user -d rtc_app < backend/scripts/init-db.sql
```

---

## ✨ What You Can Do

Once everything is running:

- ✅ Register and login
- ✅ Create meeting rooms
- ✅ Multi-user video calls
- ✅ Screen sharing
- ✅ Real-time chat
- ✅ Collaborative whiteboard
- ✅ Audio/video controls
- ✅ Invite others to join

---

## 📚 More Documentation

- **QUICK_START.md** - Quick reference
- **START.md** - Detailed startup guide
- **COMPLETE_GUIDE.md** - Full documentation
- **FIXED_AND_READY.md** - What was fixed
- **FRONTEND_GUIDE.md** - Frontend details

---

## 🆘 Still Having Issues?

1. **Make sure Docker Desktop is running**
2. **Check logs:** `docker-compose logs backend`
3. **Check browser console** (F12)
4. **Try restarting everything:** `docker-compose down && docker-compose up --build`
5. **Check START.md** for detailed troubleshooting

---

## 🎉 You're Ready!

### To Start:

1. **Open Docker Desktop** (wait until running)
2. **Double-click:** `START_BOTH.bat`
3. **Wait 2-3 minutes**
4. **Open:** http://localhost:3000
5. **Register and start using!**

**Enjoy your Meet Board! 🚀**
