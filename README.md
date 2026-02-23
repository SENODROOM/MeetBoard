# Meet Board - Real-Time Collaboration Platform

A full-stack video conferencing and collaboration platform with WebRTC, real-time chat, and collaborative whiteboard features.

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ and npm
- Docker Desktop (for databases)
- Git

### Installation & Setup

1. **Clone and Install**
```bash
git clone <repository-url>
cd meet-board
npm install
cd frontend && npm install
cd ../backend && npm install
```

2. **Start the Application**
```bash
# From the backend directory
cd backend
npm run dev
```

This will automatically:
- Start all Docker services (PostgreSQL, MongoDB, Redis, MinIO)
- Initialize databases
- Start the backend server on port 3001

3. **Start Frontend** (in a new terminal)
```bash
cd frontend
npm run dev
```

Frontend will be available at: http://localhost:3000 (or 3002 if 3000 is busy)

## 🏗️ Architecture

### Tech Stack

**Frontend:**
- Next.js 14 (React 18)
- TypeScript
- Tailwind CSS
- Zustand (State Management)
- Socket.io Client
- Fabric.js (Whiteboard)
- Simple-peer (WebRTC)

**Backend:**
- Node.js + Express
- TypeScript
- Socket.io
- PostgreSQL (User data)
- MongoDB (Chat messages)
- Redis (Sessions & caching)
- MinIO (S3-compatible file storage)

### Project Structure
```
meet-board/
├── frontend/               # Next.js frontend
│   ├── src/
│   │   ├── app/           # Next.js 14 app router
│   │   ├── components/    # React components
│   │   ├── hooks/         # Custom React hooks
│   │   ├── services/      # API services
│   │   ├── store/         # Zustand stores
│   │   └── types/         # TypeScript types
│   └── package.json
│
├── backend/               # Express backend
│   ├── src/
│   │   ├── config/       # Database configs
│   │   ├── controllers/  # Route controllers
│   │   ├── middleware/   # Express middleware
│   │   ├── models/       # Data models
│   │   ├── routes/       # API routes
│   │   ├── sockets/      # Socket.io handlers
│   │   └── types/        # TypeScript types
│   ├── scripts/          # Setup scripts
│   └── package.json
│
├── docker-compose.yml    # Docker services
└── .env                  # Root environment variables
```

## 🔧 Configuration

### Environment Variables

**Root `.env`:**
```env
POSTGRES_PASSWORD=SecurePassword123!
MONGO_PASSWORD=SecurePassword123!
REDIS_PASSWORD=SecurePassword123!
MINIO_ROOT_USER=admin
MINIO_ROOT_PASSWORD=SecurePassword123!
```

**Backend `.env`:**
```env
NODE_ENV=development
PORT=3001
DATABASE_URL=postgresql://rtc_user:SecurePassword123%21@localhost:5432/rtc_app
MONGODB_URI=<your-mongodb-uri>
REDIS_URL=redis://default:SecurePassword123!@localhost:6379
JWT_SECRET=<your-jwt-secret>
JWT_REFRESH_SECRET=<your-refresh-secret>
S3_ENDPOINT=http://localhost:9000
S3_ACCESS_KEY=admin
S3_SECRET_KEY=SecurePassword123!
S3_BUCKET=rtc-files
FRONTEND_URL=http://localhost:3000,http://localhost:3002
```

**Frontend `.env.local`:**
```env
NEXT_PUBLIC_API_URL=http://localhost:3001
NEXT_PUBLIC_WS_URL=http://localhost:3001
PORT=3000
```

## 🎯 Features

### Core Features
- **Video Conferencing**: WebRTC-based peer-to-peer video calls
- **Real-time Chat**: Socket.io powered instant messaging
- **Collaborative Whiteboard**: Multi-user drawing with Fabric.js
- **File Sharing**: Upload and share files via MinIO S3 storage
- **User Authentication**: JWT-based auth with refresh tokens
- **Room Management**: Create and join meeting rooms

### Security Features
- Helmet.js security headers
- CORS protection
- Rate limiting
- Password hashing (bcrypt)
- JWT token authentication
- Secure cookie handling

## 📡 API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `POST /api/auth/logout` - Logout user
- `POST /api/auth/refresh` - Refresh access token
- `GET /api/auth/profile` - Get user profile (protected)

### Rooms
- `POST /api/rooms` - Create room (protected)
- `GET /api/rooms/:id` - Get room details (protected)
- `GET /api/rooms` - List user's rooms (protected)

### Chat
- `GET /api/chat/:roomId` - Get chat history (protected)

### Files
- `POST /api/files/upload` - Upload file (protected)
- `GET /api/files/:fileId` - Download file (protected)

### Health
- `GET /health` - Health check
- `GET /ready` - Readiness check

## 🔌 Socket.io Events

### WebRTC Signaling
- `join-room` - Join a room
- `offer` - Send WebRTC offer
- `answer` - Send WebRTC answer
- `ice-candidate` - Exchange ICE candidates
- `leave-room` - Leave room

### Chat
- `chat-message` - Send/receive messages
- `typing` - Typing indicators

### Whiteboard
- `whiteboard-draw` - Drawing events
- `whiteboard-clear` - Clear whiteboard
- `whiteboard-undo` - Undo action

## 🐳 Docker Services

The application uses Docker Compose to manage services:

- **PostgreSQL** (port 5432): User accounts and room data
- **MongoDB** (port 27017): Chat messages and logs
- **Redis** (port 6379): Session storage and caching
- **MinIO** (ports 9000, 9001): S3-compatible file storage

### Docker Commands
```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f

# Restart a service
docker-compose restart <service-name>
```

## 🛠️ Development

### Running in Development Mode

**Backend:**
```bash
cd backend
npm run dev  # Starts with ts-node-dev (hot reload)
```

**Frontend:**
```bash
cd frontend
npm run dev  # Starts Next.js dev server
```

### Building for Production

**Backend:**
```bash
cd backend
npm run build
npm start
```

**Frontend:**
```bash
cd frontend
npm run build
npm start
```

### Using Docker Compose (Full Stack)
```bash
docker-compose up --build
```

## 🐛 Troubleshooting

### Port Already in Use
```bash
# Windows - Kill process on port
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# Or use the provided script
KILL_PORTS.bat
```

### Database Connection Issues
```bash
# Check if Docker containers are running
docker ps

# Restart Docker services
docker-compose restart

# Check logs
docker-compose logs postgres
docker-compose logs mongodb
docker-compose logs redis
```

### Redis Connection Error
- Ensure Redis URL format: `redis://default:password@localhost:6379`
- Check password matches in `.env` and `backend/.env`

### PostgreSQL Authentication Failed
- URL encode special characters in password (! becomes %21)
- Example: `SecurePassword123!` → `SecurePassword123%21`

### Frontend Can't Connect to Backend
- Check CORS settings in `backend/src/index.ts`
- Verify `FRONTEND_URL` in `backend/.env` includes your frontend port
- Ensure backend is running on port 3001

## 📝 Scripts

### Backend Scripts
- `npm run dev` - Start development server
- `npm run build` - Build TypeScript
- `npm start` - Start production server
- `npm run migrate` - Run database migrations

### Frontend Scripts
- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm start` - Start production server
- `npm run lint` - Run ESLint

## 🔐 Security Notes

- Change all default passwords in production
- Use strong JWT secrets (minimum 32 characters)
- Enable HTTPS in production
- Configure proper CORS origins
- Set up rate limiting appropriately
- Use environment variables for sensitive data
- Never commit `.env` files to version control

## 📦 Database Initialization

The backend automatically:
1. Creates database tables on first run
2. Sets up MinIO buckets
3. Initializes Redis connection
4. Connects to MongoDB

Manual initialization:
```bash
cd backend
npm run migrate
```

## 🚢 Deployment

### Environment Setup
1. Set `NODE_ENV=production`
2. Update all URLs to production domains
3. Use strong passwords and secrets
4. Configure SSL/TLS certificates
5. Set up proper CORS origins

### Recommended Hosting
- **Frontend**: Vercel, Netlify, or AWS Amplify
- **Backend**: AWS EC2, DigitalOcean, or Heroku
- **Databases**: Managed services (AWS RDS, MongoDB Atlas, Redis Cloud)
- **Storage**: AWS S3 or DigitalOcean Spaces

## 📄 License

[Your License Here]

## 👥 Contributing

[Your Contributing Guidelines Here]

## 📞 Support

For issues and questions:
- Create an issue on GitHub
- Check existing documentation
- Review troubleshooting section

---

**Built with ❤️ using Next.js, Express, and WebRTC**
