# ✅ Startup Checklist

Print this or keep it open while starting Meet Board.

---

## 📋 Pre-Start Checklist

Before you begin, verify:

- [ ] Docker Desktop is installed
- [ ] Node.js v18+ is installed (`node --version`)
- [ ] Dependencies installed in backend (`cd backend && npm install`)
- [ ] Dependencies installed in frontend (`cd frontend && npm install`)
- [ ] Internet connection available (for Docker images)

---

## 🚀 Startup Steps

### Method 1: Automatic (Recommended)

- [ ] **Step 1:** Open Docker Desktop
- [ ] **Step 2:** Wait for "Docker Desktop is running" (30-60 seconds)
- [ ] **Step 3:** Double-click `START_EVERYTHING.bat`
- [ ] **Step 4:** Wait 2-3 minutes for both servers to start
- [ ] **Step 5:** Open http://localhost:3000 in browser
- [ ] **Step 6:** Register an account and start using!

### Method 2: Manual

- [ ] **Step 1:** Open Docker Desktop
- [ ] **Step 2:** Wait for "Docker Desktop is running"
- [ ] **Step 3:** Open terminal, run: `cd backend && npm run dev`
- [ ] **Step 4:** Wait for "✓ All services are ready!" and "Server running on port 3001"
- [ ] **Step 5:** Open new terminal, run: `cd frontend && npm start`
- [ ] **Step 6:** Wait for "ready - started server on 0.0.0.0:3000"
- [ ] **Step 7:** Open http://localhost:3000 in browser
- [ ] **Step 8:** Register an account and start using!

---

## ✅ Success Verification

Check these to confirm everything is working:

- [ ] Docker Desktop shows 4 running containers
- [ ] Backend terminal shows "Server running on port 3001"
- [ ] Frontend terminal shows "ready - started server on 0.0.0.0:3000"
- [ ] http://localhost:3000 loads in browser
- [ ] Can see login/register page
- [ ] No errors in browser console (press F12)

---

## 🔍 Quick Diagnostics

If something isn't working, check:

- [ ] Docker Desktop is running (check system tray for whale icon)
- [ ] Port 3000 is free: `netstat -ano | findstr :3000`
- [ ] Port 3001 is free: `netstat -ano | findstr :3001`
- [ ] Docker containers are running: `docker ps`
- [ ] Backend terminal has no errors
- [ ] Frontend terminal has no errors
- [ ] Browser console has no errors (F12)

---

## 🚨 Common Issues Quick Fix

| Issue | Quick Fix | Done |
|-------|-----------|------|
| Docker not running | Open Docker Desktop | [ ] |
| Port 3000 in use | Run `KILL_PORTS.bat` | [ ] |
| Port 3001 in use | Run `KILL_PORTS.bat` | [ ] |
| Database error | `cd backend && npm run db:init` | [ ] |
| Build error | `cd frontend && npm install` | [ ] |

---

## 🛑 Shutdown Checklist

When you're done:

- [ ] Press `Ctrl+C` in backend terminal
- [ ] Press `Ctrl+C` in frontend terminal
- [ ] Run: `docker-compose down`
- [ ] Close Docker Desktop (optional)

---

## 🔄 Restart Checklist

If you need to restart:

- [ ] Stop all services (see Shutdown Checklist)
- [ ] Run `KILL_PORTS.bat` to clear ports
- [ ] Wait 10 seconds
- [ ] Start again (see Startup Steps)

---

## 📞 Need Help?

If you're stuck:

1. [ ] Check **TROUBLESHOOTING.md** for your specific error
2. [ ] Check **COMPLETE_STARTUP_GUIDE.md** for detailed steps
3. [ ] Try the "Nuclear Reset" in TROUBLESHOOTING.md
4. [ ] Restart your computer and try again

---

## 💡 Pro Tips

- ✅ Always start Docker Desktop first
- ✅ Wait for Docker to fully start (don't rush)
- ✅ Start backend before frontend
- ✅ Keep both terminals open while using the app
- ✅ Use `START_EVERYTHING.bat` for easiest startup
- ✅ Use `KILL_PORTS.bat` if you had issues before
- ✅ First run takes longer (Docker downloads images)

---

## 🎯 First Time Setup

If this is your first time:

- [ ] Install Docker Desktop
- [ ] Install Node.js v18+
- [ ] Clone the repository
- [ ] Run: `cd backend && npm install`
- [ ] Run: `cd frontend && npm install`
- [ ] Follow startup steps above

---

## 📊 Service Status Check

| Service | Port | Status | Check Command |
|---------|------|--------|---------------|
| Frontend | 3000 | [ ] | http://localhost:3000 |
| Backend | 3001 | [ ] | http://localhost:3001 |
| PostgreSQL | 5432 | [ ] | `docker ps` |
| MongoDB | 27017 | [ ] | `docker ps` |
| Redis | 6379 | [ ] | `docker ps` |
| MinIO | 9000 | [ ] | http://localhost:9000 |

---

## 🎉 Ready to Use!

Once all checkboxes are checked:

- [ ] Create an account
- [ ] Create a new room
- [ ] Invite others (share room link)
- [ ] Start video call
- [ ] Use chat
- [ ] Draw on whiteboard
- [ ] Share screen

Enjoy Meet Board! 🚀

---

## 📚 Documentation

- **QUICK_REFERENCE.md** - One-page guide
- **COMPLETE_STARTUP_GUIDE.md** - Detailed instructions
- **TROUBLESHOOTING.md** - Fix problems
- **STARTUP_FLOWCHART.md** - Visual guide
- **README.md** - Full documentation

---

## 🔖 Bookmark This Page

Keep this checklist handy for every startup!

**Last Updated:** February 2026
**Version:** 1.0.0
