# 🚀 START HERE - Meet Board

## Welcome! Your app is ready to run.

---

## ⚡ Quick Start (3 Steps)

### Step 1: Start Backend
**Windows:**
```bash
# Double-click this file:
RUN.bat
```

**Or run in terminal:**
```bash
docker-compose up -d
```

**Wait 30 seconds** for services to start.

### Step 2: Start Frontend
**Windows:**
```bash
# Double-click this file:
START_FRONTEND.bat
```

**Or run in terminal:**
```bash
cd frontend
npm install
npm run dev
```

### Step 3: Open Browser
Go to: **http://localhost:3000**

---

## 🎯 First Time Setup

1. **Click "Sign Up"**
2. **Create account:**
   - Email: `your@email.com`
   - Username: `yourname`
   - Password: `YourSecurePassword123!` (min 12 chars)
3. **Click "Sign Up"** - You'll be logged in automatically
4. **Click "+ Create Room"**
5. **Enter room name** and click "Create"
6. **Allow camera/microphone** when prompted
7. **You're in!** 🎉

---

## 🎮 What You Can Do

### In the Room:

**Video Controls (bottom):**
- 🎤 Click to mute/unmute
- 📹 Click to turn video on/off
- 🖥️ Click to share screen

**Chat (right side):**
- Click "Chat" tab
- Type and press Enter
- See when others are typing

**Whiteboard (right side):**
- Click "Whiteboard" tab
- Use pen to draw
- Pick colors
- Adjust brush size
- Click clear to erase all

**Leave:**
- Click "Leave" button (top right)

---

## 👥 Test with Multiple Users

### Option 1: Same Computer
1. Open a different browser (Chrome, Firefox, Edge)
2. Go to http://localhost:3000
3. Register with different email
4. Join the same room

### Option 2: Different Computer
1. Share your IP address: `ipconfig` (Windows) or `ifconfig` (Mac/Linux)
2. Other person goes to: `http://YOUR_IP:3000`
3. They register and join your room

---

## 📋 Checklist

Before starting:
- [ ] Docker Desktop installed and running
- [ ] Node.js 20+ installed
- [ ] Ports 3000 and 3001 available

After starting:
- [ ] Backend running (check: http://localhost:3001/health)
- [ ] Frontend running (check: http://localhost:3000)
- [ ] Can register a user
- [ ] Can create a room
- [ ] Camera/microphone working

---

## ❓ Problems?

### Backend won't start
```bash
# Check Docker is running
docker --version

# Check logs
docker-compose logs backend
```

### Frontend won't start
```bash
cd frontend
npm install
npm run dev
```

### Camera not working
1. Click lock icon in browser address bar
2. Allow camera and microphone
3. Refresh page

### Can't connect
1. Check backend: http://localhost:3001/health
2. Should return: `{"status":"ok",...}`
3. Check browser console (F12) for errors

---

## 📚 Need More Help?

Read these guides:
1. **COMPLETE_GUIDE.md** - Full instructions
2. **FRONTEND_GUIDE.md** - Frontend details
3. **PROJECT_SUMMARY.md** - What was built

---

## 🎉 You're Ready!

Your Meet Board app includes:
- ✅ Video calling
- ✅ Screen sharing
- ✅ Real-time chat
- ✅ Collaborative whiteboard
- ✅ Secure authentication

**Enjoy your new communication platform!** 🚀

---

## 🆘 Quick Commands

```bash
# Start backend
docker-compose up -d

# Stop backend
docker-compose down

# View backend logs
docker-compose logs -f backend

# Start frontend
cd frontend && npm run dev

# Build for production
cd frontend && npm run build

# Check backend health
curl http://localhost:3001/health
```

---

**That's it! Have fun! 🎊**
