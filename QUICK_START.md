# ⚡ Quick Start - Meet Board

## Prerequisites

1. **Start Docker Desktop**
   - Open Docker Desktop application
   - Wait until it shows "Docker Desktop is running"
   - You should see the Docker icon in your system tray

2. **Verify Docker is Running**
   ```bash
   docker --version
   ```
   Should show Docker version

---

## 🚀 Start Everything (One Command)

### Option 1: Automated Script (Easiest)

**Double-click:** `START_BOTH.bat`

This will:
- ✅ Start all backend services (PostgreSQL, MongoDB, Redis, MinIO, Backend API)
- ✅ Initialize the database
- ✅ Create storage bucket
- ✅ Start the frontend
- ✅ Open on http://localhost:3000

**Just wait and it will open automatically!**

---

### Option 2: Manual (Two Terminals)

**Terminal 1 - Backend:**
```bash
docker-compose up --build
```

Wait 45 seconds, then in **Terminal 2:**
```bash
# Initialize database
docker-compose exec -T postgres psql -U rtc_user -d rtc_app < backend/scripts/init-db.sql

# Create bucket
docker-compose exec minio mc alias set myminio http://localhost:9000 admin SecurePassword123!
docker-compose exec minio mc mb myminio/rtc-files --ignore-existing
```

**Terminal 3 - Frontend:**
```bash
cd frontend
npm install
npm run dev
```

---

## ✅ Verify It's Working

1. **Check Backend:**
   ```bash
   curl http://localhost:3001/health
   ```
   Should return: `{"status":"ok",...}`

2. **Check Frontend:**
   Open browser: http://localhost:3000
   Should see the Meet Board landing page

3. **Check Services:**
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
   - Email: `your@email.com`
   - Username: `yourname`
   - Password: `YourPassword123!` (min 12 chars)
4. Click **"Sign Up"**

### 2. Create Room
1. Click **"+ Create Room"**
2. Enter room name: `My First Meeting`
3. Click **"Create"**

### 3. Allow Permissions
- Click **"Allow"** when browser asks for camera/microphone

### 4. Start Using!
- 🎤 Mute/unmute microphone
- 📹 Turn camera on/off
- 🖥️ Share screen
- 💬 Send chat messages
- 🎨 Draw on whiteboard

---

## 🐛 Troubleshooting

### Docker Desktop Not Running

**Error:** "Docker Desktop is not running"

**Fix:**
1. Open Docker Desktop application
2. Wait for it to fully start
3. Run the script again

### Registration Fails

**Error:** "Registration failed"

**Fix:**
```bash
# Reinitialize database
docker-compose exec -T postgres psql -U rtc_user -d rtc_app < backend/scripts/init-db.sql

# Restart backend
docker-compose restart backend
```

### Port Already in Use

**Error:** "Port 3000 or 3001 already in use"

**Fix:**
```bash
# Find what's using the port
netstat -ano | findstr :3000
netstat -ano | findstr :3001

# Kill the process or stop other services
```

### Frontend Won't Start

**Fix:**
```bash
cd frontend
rmdir /s /q node_modules
npm install
npm run dev
```

### Can't See Video

**Fix:**
1. Check browser permissions (click lock icon in address bar)
2. Allow camera and microphone
3. Refresh the page
4. Try a different browser (Chrome recommended)

---

## 🛑 Stop Everything

### Stop Frontend
- Press `Ctrl+C` in the terminal running frontend

### Stop Backend
```bash
docker-compose down
```

### Stop and Remove All Data
```bash
docker-compose down -v
```

---

## 📊 Service URLs

- **Frontend:** http://localhost:3000
- **Backend API:** http://localhost:3001
- **Backend Health:** http://localhost:3001/health
- **MinIO Console:** http://localhost:9001
  - Username: `admin`
  - Password: `SecurePassword123!`

---

## 🔄 Restart Everything

```bash
# Stop
docker-compose down

# Start fresh
docker-compose up --build
```

In another terminal:
```bash
# Wait 45 seconds, then:
docker-compose exec -T postgres psql -U rtc_user -d rtc_app < backend/scripts/init-db.sql

# Start frontend
cd frontend
npm run dev
```

---

## 📝 Quick Commands

```bash
# View backend logs
docker-compose logs -f backend

# View all logs
docker-compose logs -f

# Check service status
docker-compose ps

# Restart backend only
docker-compose restart backend

# Access database
docker-compose exec postgres psql -U rtc_user -d rtc_app

# Test backend
curl http://localhost:3001/health
```

---

## ✨ Features Available

Once running, you can:

- ✅ Register and login
- ✅ Create meeting rooms
- ✅ Join video calls
- ✅ Share your screen
- ✅ Send chat messages
- ✅ Draw on collaborative whiteboard
- ✅ Mute/unmute audio
- ✅ Turn camera on/off
- ✅ See other participants
- ✅ Real-time synchronization

---

## 🎉 You're Ready!

Just run `START_BOTH.bat` and everything will start automatically!

**Need help?** Check:
- **START.md** - Detailed instructions
- **FIXED_AND_READY.md** - What was fixed
- **COMPLETE_GUIDE.md** - Full documentation

Enjoy your Meet Board! 🚀
