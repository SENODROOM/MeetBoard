# Frontend Setup and Usage Guide

## Quick Start

### Option 1: Development Mode (Recommended for Testing)

1. **Start the Backend First**
   ```bash
   # Make sure backend is running
   docker-compose up -d
   ```

2. **Start the Frontend**
   
   **Windows:**
   ```bash
   # Double-click START_FRONTEND.bat
   # OR run in terminal:
   cd frontend
   npm install
   npm run dev
   ```

   **Mac/Linux:**
   ```bash
   cd frontend
   npm install
   npm run dev
   ```

3. **Open in Browser**
   - Navigate to: http://localhost:3000

### Option 2: Docker (Full Stack)

```bash
# Start everything (backend + frontend)
docker-compose up -d

# Wait for services to start (about 30 seconds)
# Then open: http://localhost:3000
```

## Using the Application

### 1. Register an Account

1. Go to http://localhost:3000
2. Click "Sign Up"
3. Fill in:
   - Email: your@email.com
   - Username: yourname
   - Password: (minimum 12 characters)
4. Click "Sign Up"

### 2. Login

1. Click "Login"
2. Enter your email and password
3. Click "Sign In"

### 3. Create a Room

1. After login, you'll see the Dashboard
2. Click "+ Create Room"
3. Enter a room name
4. Click "Create"

### 4. Join a Room

1. On the Dashboard, you'll see available rooms
2. Click "Join Room" on any room
3. Allow camera and microphone permissions when prompted

### 5. In the Room

**Video Controls:**
- 🎤 Microphone button - Mute/Unmute audio
- 📹 Camera button - Turn video on/off
- 🖥️ Screen Share button - Share your screen

**Chat:**
- Click "Chat" tab on the right sidebar
- Type messages and press Enter or click Send
- See typing indicators when others are typing

**Whiteboard:**
- Click "Whiteboard" tab on the right sidebar
- Use Pen tool to draw
- Use Eraser to erase
- Change colors and brush size
- Click Clear to clear the canvas

**Leave Room:**
- Click "Leave" button in the top right

## Features

### ✅ Implemented Features

1. **Authentication**
   - User registration
   - User login
   - Session management
   - Auto-redirect when authenticated

2. **Room Management**
   - Create rooms
   - List available rooms
   - Join rooms
   - Leave rooms
   - See participant count

3. **Video Calling**
   - Multi-user video calls
   - Audio/video toggle
   - WebRTC peer-to-peer connections
   - Automatic connection to new participants

4. **Screen Sharing**
   - Share your screen
   - Stop sharing
   - Broadcast to all participants

5. **Real-Time Chat**
   - Send messages
   - Receive messages instantly
   - Typing indicators
   - Message history
   - Timestamps

6. **Collaborative Whiteboard**
   - Draw in real-time
   - Multiple tools (pen, eraser)
   - Color picker
   - Brush size adjustment
   - Clear canvas
   - Synchronized across all participants

## Troubleshooting

### Camera/Microphone Not Working

1. **Check Browser Permissions**
   - Chrome: Click the lock icon in address bar → Site settings
   - Allow camera and microphone access

2. **Check if devices are available**
   - Make sure no other app is using your camera/microphone
   - Try refreshing the page

3. **Browser Compatibility**
   - Use Chrome, Firefox, or Edge (latest versions)
   - Safari may have limited WebRTC support

### Can't Connect to Backend

1. **Check Backend is Running**
   ```bash
   curl http://localhost:3001/health
   # Should return: {"status":"ok",...}
   ```

2. **Check Environment Variables**
   - Frontend `.env.local` should have:
     ```
     NEXT_PUBLIC_API_URL=http://localhost:3001
     NEXT_PUBLIC_WS_URL=http://localhost:3001
     ```

3. **CORS Issues**
   - Backend should allow `http://localhost:3000` in CORS settings
   - Check backend logs for CORS errors

### Video Not Showing

1. **Check Video Element**
   - Open browser console (F12)
   - Look for errors

2. **WebRTC Connection Issues**
   - Check if STUN/TURN servers are accessible
   - May need to configure TURN server for production

3. **Firewall/Network**
   - Make sure ports 3000 and 3001 are not blocked
   - Check if you're behind a restrictive firewall

### Chat Messages Not Sending

1. **Check WebSocket Connection**
   - Open browser console
   - Look for "Socket connected" message
   - Check for WebSocket errors

2. **Check Backend Logs**
   ```bash
   docker-compose logs -f backend
   ```

3. **Refresh the Page**
   - Sometimes WebSocket connection needs to be re-established

### Whiteboard Not Syncing

1. **Check Canvas Element**
   - Make sure canvas is visible
   - Check browser console for errors

2. **Check WebSocket Connection**
   - Whiteboard uses WebSocket for real-time sync
   - Verify WebSocket is connected

3. **Clear Browser Cache**
   - Sometimes cached JavaScript can cause issues

## Development Tips

### Hot Reload

The frontend uses Next.js hot reload. Changes to files will automatically refresh the browser.

### Debugging

1. **Open Browser DevTools** (F12)
2. **Console Tab** - See logs and errors
3. **Network Tab** - See API requests
4. **Application Tab** - See cookies and storage

### API Testing

Use browser console to test API:

```javascript
// Test login
fetch('http://localhost:3001/api/auth/login', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  credentials: 'include',
  body: JSON.stringify({
    email: 'test@example.com',
    password: 'SecurePassword123!'
  })
}).then(r => r.json()).then(console.log)
```

### WebSocket Testing

```javascript
// Test WebSocket connection
const socket = io('http://localhost:3001', {
  auth: { token: 'your-token' }
});

socket.on('connect', () => {
  console.log('Connected!');
  socket.emit('join-room', { roomId: 'room-id' });
});
```

## Building for Production

```bash
cd frontend
npm run build
npm start
```

Or with Docker:

```bash
docker-compose up -d
```

## Environment Variables

Create `frontend/.env.local`:

```env
NEXT_PUBLIC_API_URL=http://localhost:3001
NEXT_PUBLIC_WS_URL=http://localhost:3001
```

For production, update these to your production URLs.

## Browser Support

- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Edge 90+
- ⚠️ Safari 14+ (limited WebRTC support)
- ❌ Internet Explorer (not supported)

## Performance Tips

1. **Close Unused Tabs** - Video calls use significant resources
2. **Use Wired Connection** - Better than WiFi for video calls
3. **Close Other Apps** - Free up CPU and memory
4. **Lower Video Quality** - If experiencing lag

## Security Notes

1. **HTTPS Required for Production** - WebRTC requires HTTPS in production
2. **Secure Passwords** - Minimum 12 characters enforced
3. **Session Cookies** - httpOnly, secure cookies used
4. **CORS Protection** - Backend validates origins

## Next Steps

1. ✅ Frontend is complete and integrated with backend
2. ⏭️ Test all features
3. ⏭️ Configure TURN server for production
4. ⏭️ Add SSL/TLS certificates
5. ⏭️ Deploy to production
6. ⏭️ Add more features (recording, file sharing, etc.)

## Support

For issues:
1. Check browser console for errors
2. Check backend logs: `docker-compose logs backend`
3. Review this guide
4. Check ARCHITECTURE.md and IMPLEMENTATION.md
