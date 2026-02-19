# 🚀 Simple Start Guide

## The Easiest Way to Run Meet Board

### Step 1: Start Backend (with Docker)

**Double-click:** `SETUP_COMPLETE.bat`

This will:
- Start PostgreSQL, MongoDB, Redis, MinIO
- Build and start the backend
- Initialize the database
- Create storage bucket

**Wait for:** "Setup Complete!" message

### Step 2: Start Frontend (without Docker)

**Double-click:** `START_FRONTEND.bat`

Or manually:
```bash
cd frontend
npm install
npm run dev
```

### Step 3: Open Browser

Go to: **http://localhost:3000**

---

## That's It!

Now you can:
1. Register an account
2. Create a room
3. Start video calling

---

## If Something Goes Wrong

### Backend Issues
```bash
# View logs
docker-compose logs backend

# Restart
docker-compose restart backend
```

### Frontend Issues
```bash
cd frontend
rmdir /s /q node_modules
npm install
npm run dev
```

### Database Not Initialized
```bash
docker-compose exec -T postgres psql -U rtc_user -d rtc_app < backend\scripts\init-db.sql
```

---

## Stop Everything

```bash
# Stop backend
docker-compose down

# Stop frontend
Press Ctrl+C in terminal
```

---

**Need more help?** Check START.md for detailed instructions.
