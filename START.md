# 🚀 START GUIDE - Meet Board

## Quick Start (Recommended)

### Step 1: Start Backend

Open PowerShell or Command Prompt and run:

```bash
docker-compose up -d --build
```

Wait 30-45 seconds for services to start.

### Step 2: Initialize Database

```bash
docker-compose exec -T postgres psql -U rtc_user -d rtc_app < backend/scripts/init-db.sql
```

### Step 3: Create Storage Bucket

```bash
docker-compose exec minio mc alias set myminio http://localhost:9000 admin SecurePassword123!
docker-compose exec minio mc mb myminio/rtc-files --ignore-existing
```

### Step 4: Verify Backend

```bash
curl http://localhost:3001/health
```

Should return: `{"status":"ok",...}`

### Step 5: Start Frontend

```bash
cd frontend
npm install
npm run dev
```

### Step 6: Open Application

Go to: **http://localhost:3000**

---

## Alternative: Use Batch Files

### Windows Users

1. **Double-click:** `SETUP_COMPLETE.bat`
   - Starts and initializes backend
   - Wait for "Setup Complete!"

2. **Double-click:** `START_FRONTEND.bat`
   - Starts frontend
   - Opens on http://localhost:3000

---

## First Time Setup

### 1. Register Account

1. Go to http://localhost:3000
2. Click "Sign Up"
3. Enter:
   - Email: your@email.com
   - Username: yourname
   - Password: YourPassword123! (min 12 chars)
4. Click "Sign Up"

### 2. Create Room

1. Click "+ Create Room"
2. Enter room name
3. Click "Create"

### 3. Allow Permissions

- Allow camera and microphone when prompted

### 4. Start Using

- Video controls at bottom
- Chat on right sidebar
- Whiteboard on right sidebar

---

## Troubleshooting

### Registration Fails

**Error:** "Registration failed"

**Fix:**
```bash
# Check if database tables exist
docker-compose exec postgres psql -U rtc_user -d rtc_app -c "\dt"

# If no tables, initialize:
docker-compose exec -T postgres psql -U rtc_user -d rtc_app < backend/scripts/init-db.sql

# Restart backend
docker-compose restart backend
```

### Backend Won't Start

```bash
# Check Docker is running
docker ps

# View logs
docker-compose logs backend

# Restart
docker-compose down
docker-compose up -d --build
```

### Frontend Won't Start

```bash
cd frontend

# Clear and reinstall
rm -rf node_modules
npm install

# Start
npm run dev
```

### Can't Connect

```bash
# Test backend
curl http://localhost:3001/health

# Check all services
docker-compose ps

# All should show "Up" and "healthy"
```

### Database Connection Error

```bash
# Reinitialize database
docker-compose exec -T postgres psql -U rtc_user -d rtc_app < backend/scripts/init-db.sql
```

---

## Common Commands

```bash
# Start backend
docker-compose up -d

# Stop backend
docker-compose down

# View logs
docker-compose logs -f backend

# Restart backend
docker-compose restart backend

# Check status
docker-compose ps

# Initialize database
docker-compose exec -T postgres psql -U rtc_user -d rtc_app < backend/scripts/init-db.sql

# Access PostgreSQL
docker-compose exec postgres psql -U rtc_user -d rtc_app

# Access MongoDB
docker-compose exec mongodb mongosh -u admin -p SecurePassword123!

# Access Redis
docker-compose exec redis redis-cli -a SecurePassword123!
```

---

## Service URLs

- **Frontend:** http://localhost:3000
- **Backend API:** http://localhost:3001
- **Backend Health:** http://localhost:3001/health
- **MinIO Console:** http://localhost:9001
  - Username: admin
  - Password: SecurePassword123!

---

## Default Credentials

### PostgreSQL
- Host: localhost:5432
- Database: rtc_app
- User: rtc_user
- Password: SecurePassword123!

### MongoDB
- Host: localhost:27017
- User: admin
- Password: SecurePassword123!

### Redis
- Host: localhost:6379
- Password: SecurePassword123!

### MinIO
- Console: http://localhost:9001
- Username: admin
- Password: SecurePassword123!

---

## Verify Setup

### Check Backend
```bash
curl http://localhost:3001/health
```

### Check Database
```bash
docker-compose exec postgres psql -U rtc_user -d rtc_app -c "\dt"
```

Should list: users, sessions, rooms, room_participants, files

### Check Services
```bash
docker-compose ps
```

All should show "Up" and "healthy"

---

## Stop Everything

```bash
# Stop all services
docker-compose down

# Stop and remove data (WARNING: deletes everything)
docker-compose down -v

# Stop frontend
Press Ctrl+C in terminal
```

---

## Restart Everything

```bash
# Stop
docker-compose down

# Start fresh
docker-compose up -d --build

# Wait 30 seconds
timeout /t 30

# Initialize
docker-compose exec -T postgres psql -U rtc_user -d rtc_app < backend/scripts/init-db.sql
```

---

## Success Checklist

- [ ] Docker Desktop running
- [ ] Backend started: `docker-compose up -d`
- [ ] Database initialized
- [ ] Backend health check passes
- [ ] Frontend started: `npm run dev`
- [ ] Can access http://localhost:3000
- [ ] Can register a user
- [ ] Can create a room
- [ ] Camera/microphone work

---

## Need More Help?

- **COMPLETE_GUIDE.md** - Full documentation
- **FRONTEND_GUIDE.md** - Frontend details
- **SIMPLE_START.md** - Simplified instructions
- **PROJECT_SUMMARY.md** - What was built

---

## Quick Test

After starting everything:

1. Open http://localhost:3000
2. Click "Sign Up"
3. Register with:
   - Email: test@test.com
   - Username: testuser
   - Password: TestPassword123!
4. Should redirect to Dashboard
5. Click "+ Create Room"
6. Enter "Test Room"
7. Click "Create"
8. Allow camera/microphone
9. You should see your video!

---

## 🎉 You're Ready!

Your Meet Board application is now running!

- Create rooms
- Invite others
- Video call
- Chat
- Whiteboard
- Screen share

Enjoy! 🚀
