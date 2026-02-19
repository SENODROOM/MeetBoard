# Complete Setup and Usage Guide

## 🚀 Quick Start (Easiest Way)

### Step 1: Start Backend
```bash
# Double-click RUN.bat
# OR run in terminal:
docker-compose up -d
```

Wait 30 seconds for all services to start.

### Step 2: Start Frontend
```bash
# Double-click START_FRONTEND.bat
# OR run in terminal:
cd frontend
npm install
npm run dev
```

### Step 3: Open Application
Open your browser and go to: **http://localhost:3000**

That's it! You're ready to use Meet Board.

---

## 📋 What You Get

### Backend (Port 3001)
- ✅ User authentication (register/login)
- ✅ Room management
- ✅ WebRTC signaling server
- ✅ Real-time chat with WebSocket
- ✅ Collaborative whiteboard
- ✅ File sharing (ready, not in UI yet)
- ✅ PostgreSQL database
- ✅ MongoDB for chat/whiteboard
- ✅ Redis for caching
- ✅ MinIO for file storage

### Frontend (Port 3000)
- ✅ Beautiful landing page
- ✅ User registration/login
- ✅ Dashboard with room list
- ✅ Video calling interface
- ✅ Screen sharing
- ✅ Real-time chat
- ✅ Collaborative whiteboard
- ✅ Responsive design

---

## 🎯 Using the Application

### 1. Register an Account

1. Go to http://localhost:3000
2. Click **"Sign Up"**
3. Fill in:
   - Email: `test@example.com`
   - Username: `testuser`
   - Password: `SecurePassword123!` (min 12 chars)
4. Click **"Sign Up"**
5. You'll be automatically logged in

### 2. Create Your First Room

1. You'll see the Dashboard
2. Click **"+ Create Room"**
3. Enter room name: `My First Meeting`
4. Click **"Create"**
5. You'll join the room automatically

### 3. Allow Camera/Microphone

When you join a room:
1. Browser will ask for camera/microphone permission
2. Click **"Allow"**
3. Your video will appear

### 4. Invite Others

1. Share the room URL with others
2. They need to register/login
3. They can join from the Dashboard

### 5. Use Features

**Video Controls (bottom center):**
- 🎤 **Microphone** - Click to mute/unmute
- 📹 **Camera** - Click to turn video on/off
- 🖥️ **Screen Share** - Click to share your screen

**Chat (right sidebar):**
- Click **"Chat"** tab
- Type message and press Enter
- See when others are typing

**Whiteboard (right sidebar):**
- Click **"Whiteboard"** tab
- Click **Pen** to draw
- Click **Eraser** to erase
- Pick colors with color picker
- Adjust brush size with slider
- Click **Clear** to clear canvas

**Leave Room:**
- Click **"Leave"** button (top right)
- Returns to Dashboard

---

## 🔧 Technical Details

### Architecture

```
┌─────────────┐
│   Browser   │ ← http://localhost:3000
│  (Frontend) │
└──────┬──────┘
       │ HTTP/WebSocket
       ↓
┌─────────────┐
│   Backend   │ ← http://localhost:3001
│  (Node.js)  │
└──────┬──────┘
       │
       ├─→ PostgreSQL (User data)
       ├─→ MongoDB (Chat/Whiteboard)
       ├─→ Redis (Cache)
       └─→ MinIO (File storage)
```

### Ports

- **3000** - Frontend (Next.js)
- **3001** - Backend API (Express)
- **5432** - PostgreSQL
- **27017** - MongoDB
- **6379** - Redis
- **9000** - MinIO API
- **9001** - MinIO Console

### Technologies

**Frontend:**
- Next.js 14 (React framework)
- TypeScript
- Tailwind CSS
- Socket.io Client
- WebRTC
- Fabric.js (Whiteboard)
- Zustand (State management)

**Backend:**
- Node.js 20
- Express.js
- Socket.io
- PostgreSQL
- MongoDB
- Redis
- MinIO/S3

---

## 🐛 Troubleshooting

### Backend Won't Start

```bash
# Check if Docker is running
docker --version

# Check if ports are available
netstat -ano | findstr :3001

# View backend logs
docker-compose logs backend
```

### Frontend Won't Start

```bash
# Make sure you're in frontend directory
cd frontend

# Clear node_modules and reinstall
rmdir /s /q node_modules
npm install

# Try again
npm run dev
```

### Can't Login/Register

1. **Check backend is running:**
   ```bash
   curl http://localhost:3001/health
   ```
   Should return: `{"status":"ok",...}`

2. **Check browser console** (F12)
   - Look for network errors
   - Check if API calls are failing

3. **Check CORS:**
   - Backend should allow `http://localhost:3000`
   - Check backend logs for CORS errors

### Camera/Microphone Not Working

1. **Check browser permissions:**
   - Chrome: Click lock icon → Site settings
   - Allow camera and microphone

2. **Check if devices are available:**
   - Close other apps using camera/mic
   - Try refreshing the page

3. **Use supported browser:**
   - Chrome 90+ ✅
   - Firefox 88+ ✅
   - Edge 90+ ✅
   - Safari 14+ ⚠️ (limited)

### Video Call Not Connecting

1. **Check WebSocket connection:**
   - Open browser console (F12)
   - Look for "Socket connected" message

2. **Check firewall:**
   - Make sure ports 3000 and 3001 are not blocked

3. **For production:**
   - Need to configure TURN server
   - STUN servers may not work behind strict firewalls

### Chat Not Working

1. **Check WebSocket:**
   - Browser console should show "Socket connected"
   - Check backend logs for WebSocket errors

2. **Refresh the page:**
   - Sometimes WebSocket needs to reconnect

### Whiteboard Not Syncing

1. **Check canvas is visible:**
   - Click "Whiteboard" tab
   - Check browser console for errors

2. **Check WebSocket connection:**
   - Whiteboard uses WebSocket for sync

---

## 📊 Testing the Application

### Test Scenario 1: Single User

1. Register and login
2. Create a room
3. Test video/audio controls
4. Send chat messages
5. Draw on whiteboard
6. Share screen
7. Leave room

### Test Scenario 2: Multiple Users

1. **User 1:**
   - Register as `user1@test.com`
   - Create room "Test Room"
   - Wait in room

2. **User 2 (different browser/incognito):**
   - Register as `user2@test.com`
   - Join "Test Room"
   - Both should see each other's video

3. **Test features:**
   - Both users send chat messages
   - Both users draw on whiteboard
   - User 1 shares screen
   - User 2 should see the screen

### Test Scenario 3: Screen Sharing

1. Join a room
2. Click screen share button
3. Select window/screen to share
4. Other participants should see your screen
5. Click stop sharing

---

## 🚢 Deployment

### Development
```bash
# Backend
docker-compose up -d

# Frontend
cd frontend
npm run dev
```

### Production (Docker)
```bash
# Build and start everything
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f
```

### Production (Manual)

**Backend:**
```bash
cd backend
npm install
npm run build
npm start
```

**Frontend:**
```bash
cd frontend
npm install
npm run build
npm start
```

---

## 📁 Project Structure

```
meet-board/
├── backend/                 # Backend API
│   ├── src/
│   │   ├── controllers/    # Request handlers
│   │   ├── routes/         # API routes
│   │   ├── sockets/        # WebSocket handlers
│   │   ├── models/         # Database models
│   │   ├── middleware/     # Express middleware
│   │   ├── config/         # Configuration
│   │   └── types/          # TypeScript types
│   ├── scripts/            # Database migrations
│   └── Dockerfile
│
├── frontend/               # Frontend app
│   ├── src/
│   │   ├── app/           # Next.js pages
│   │   ├── components/    # React components
│   │   ├── hooks/         # Custom hooks
│   │   ├── services/      # API services
│   │   ├── store/         # State management
│   │   └── types/         # TypeScript types
│   └── Dockerfile
│
├── docker-compose.yml      # Docker services
├── .env                    # Environment variables
├── RUN.bat                 # Start backend
├── START_FRONTEND.bat      # Start frontend
└── README.md              # Documentation
```

---

## 🔐 Security

### Implemented Security Features

1. **Password Security:**
   - Bcrypt hashing (cost 12)
   - Minimum 12 characters enforced
   - No plain text storage

2. **Authentication:**
   - JWT tokens (15 min expiry)
   - Refresh tokens (7 days)
   - httpOnly, secure cookies
   - Session management

3. **API Security:**
   - Rate limiting
   - CORS protection
   - Helmet security headers
   - Input validation

4. **WebRTC Security:**
   - DTLS-SRTP encryption (built-in)
   - Peer-to-peer encryption

5. **Database Security:**
   - Parameterized queries (SQL injection prevention)
   - Connection pooling
   - Secure credentials

---

## 📈 Performance Tips

1. **For Better Video Quality:**
   - Use wired internet connection
   - Close unnecessary browser tabs
   - Close other applications
   - Use Chrome for best performance

2. **For Better Performance:**
   - Limit participants to 4-6 for best quality
   - Turn off video if bandwidth is limited
   - Use screen share only when needed

3. **For Production:**
   - Use CDN for static assets
   - Enable Redis caching
   - Configure TURN server
   - Use load balancer for scaling

---

## 🎓 Learning Resources

- **WebRTC:** https://webrtc.org/
- **Socket.io:** https://socket.io/docs/
- **Next.js:** https://nextjs.org/docs
- **Express.js:** https://expressjs.com/
- **PostgreSQL:** https://www.postgresql.org/docs/
- **MongoDB:** https://docs.mongodb.com/

---

## 📝 API Documentation

See `backend/README.md` for complete API documentation.

**Quick Reference:**

- `POST /api/auth/register` - Register user
- `POST /api/auth/login` - Login user
- `GET /api/auth/profile` - Get profile
- `POST /api/rooms` - Create room
- `GET /api/rooms` - List rooms
- `POST /api/rooms/:id/join` - Join room

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

---

## 📄 License

MIT License - See LICENSE file

---

## 🆘 Getting Help

1. **Check Documentation:**
   - README.md
   - ARCHITECTURE.md
   - IMPLEMENTATION.md
   - DEPLOYMENT.md

2. **Check Logs:**
   ```bash
   # Backend logs
   docker-compose logs backend
   
   # All logs
   docker-compose logs
   ```

3. **Browser Console:**
   - Press F12
   - Check Console tab for errors
   - Check Network tab for failed requests

4. **Common Issues:**
   - See TROUBLESHOOTING section above
   - Check FRONTEND_GUIDE.md
   - Check START.md

---

## ✅ Checklist

Before using:
- [ ] Docker Desktop installed and running
- [ ] Node.js 20+ installed
- [ ] Ports 3000 and 3001 available
- [ ] Backend started (`docker-compose up -d`)
- [ ] Frontend started (`npm run dev`)
- [ ] Browser opened to http://localhost:3000

After setup:
- [ ] Can register a user
- [ ] Can login
- [ ] Can create a room
- [ ] Can join a room
- [ ] Camera/microphone working
- [ ] Can send chat messages
- [ ] Can draw on whiteboard
- [ ] Can share screen

---

## 🎉 You're All Set!

Your Meet Board application is now running with:
- ✅ Full-stack real-time communication
- ✅ Video calling with WebRTC
- ✅ Screen sharing
- ✅ Real-time chat
- ✅ Collaborative whiteboard
- ✅ Secure authentication
- ✅ Production-ready architecture

Enjoy your new communication platform! 🚀
