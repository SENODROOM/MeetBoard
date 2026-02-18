# Real-Time Communication Application

A full-featured real-time communication platform with video calling, screen sharing, collaborative whiteboard, chat, and secure file sharing.

## Features

- **Multi-User Video Calling**: WebRTC-based video/audio communication
- **Screen Sharing**: Share your screen with participants
- **Collaborative Whiteboard**: Real-time drawing and collaboration
- **Real-Time Chat**: Instant messaging with message history
- **Secure File Sharing**: End-to-end encrypted file uploads and downloads
- **Room Management**: Create, join, and manage meeting rooms
- **User Authentication**: Secure JWT-based authentication

## Architecture

See [ARCHITECTURE.md](./ARCHITECTURE.md) for detailed system architecture.

## Tech Stack

See [TECH_STACK.md](./TECH_STACK.md) for complete technology breakdown.

## Project Structure

```
rtc-app/
├── backend/                 # Node.js/Express backend
│   ├── src/
│   │   ├── controllers/    # Request handlers
│   │   ├── routes/         # API routes
│   │   ├── sockets/        # WebSocket handlers
│   │   ├── models/         # Database models
│   │   ├── middleware/     # Express middleware
│   │   ├── config/         # Configuration files
│   │   └── types/          # TypeScript types
│   ├── scripts/            # Database migrations
│   └── Dockerfile
├── docker-compose.yml      # Docker services configuration
├── ARCHITECTURE.md         # System architecture documentation
├── TECH_STACK.md          # Technology stack details
├── IMPLEMENTATION.md      # Implementation guide
└── DEPLOYMENT.md          # Deployment instructions
```

## Quick Start

### Prerequisites

- Docker and Docker Compose
- Node.js 20+ (for local development)
- Git

### Using Docker (Recommended)

1. Clone the repository:
```bash
git clone <repository-url>
cd rtc-app
```

2. Create environment file:
```bash
cp .env.example .env
```

3. Update `.env` with secure passwords and secrets

4. Start all services:
```bash
docker-compose up -d
```

5. Check service status:
```bash
docker-compose ps
```

6. View logs:
```bash
docker-compose logs -f backend
```

The backend will be available at `http://localhost:3001`

### Local Development

1. Install dependencies:
```bash
cd backend
npm install
```

2. Set up databases (PostgreSQL, MongoDB, Redis, MinIO)

3. Create `.env` file in backend directory:
```bash
cp .env.example .env
```

4. Run database migrations:
```bash
npm run migrate
```

5. Start development server:
```bash
npm run dev
```

## API Documentation

### Authentication Endpoints

- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `POST /api/auth/logout` - Logout user
- `POST /api/auth/refresh` - Refresh access token
- `GET /api/auth/profile` - Get user profile

### Room Endpoints

- `POST /api/rooms` - Create a new room
- `GET /api/rooms` - List available rooms
- `GET /api/rooms/:roomId` - Get room details
- `POST /api/rooms/:roomId/join` - Join a room
- `POST /api/rooms/:roomId/leave` - Leave a room
- `POST /api/rooms/:roomId/end` - End a room (host only)

### Chat Endpoints

- `GET /api/chat/:roomId/history` - Get chat history
- `DELETE /api/chat/messages/:messageId` - Delete a message
- `PUT /api/chat/messages/:messageId` - Edit a message

### File Endpoints

- `POST /api/files/upload` - Upload a file
- `GET /api/files/:fileId/url` - Get file download URL
- `GET /api/files/room/:roomId` - List room files
- `DELETE /api/files/:fileId` - Delete a file

## WebSocket Events

### WebRTC Signaling

- `join-room` - Join a video call room
- `offer` - Send WebRTC offer
- `answer` - Send WebRTC answer
- `ice-candidate` - Exchange ICE candidates
- `toggle-media` - Toggle audio/video
- `start-screen-share` - Start screen sharing
- `stop-screen-share` - Stop screen sharing
- `leave-room` - Leave the room

### Chat Events

- `chat-message` - Send a chat message
- `typing-start` - User started typing
- `typing-stop` - User stopped typing

### Whiteboard Events

- `whiteboard-draw` - Draw on whiteboard
- `whiteboard-get-history` - Get whiteboard history

## Database Schema

### PostgreSQL Tables

- `users` - User accounts
- `sessions` - Authentication sessions
- `rooms` - Meeting rooms
- `room_participants` - Room membership
- `files` - File metadata

### MongoDB Collections

- `chatmessages` - Chat message history
- `whiteboards` - Whiteboard action history

## Security Features

- Password hashing with bcrypt (cost factor 12)
- JWT tokens with short expiration (15 minutes)
- Refresh tokens (7 days)
- httpOnly, secure cookies
- Rate limiting on all endpoints
- Input validation and sanitization
- CORS protection
- Helmet security headers
- End-to-end encryption for files
- WebRTC encryption (DTLS-SRTP)

## Environment Variables

See `.env.example` for all required environment variables.

Key variables:
- `DATABASE_URL` - PostgreSQL connection string
- `MONGODB_URI` - MongoDB connection string
- `REDIS_URL` - Redis connection string
- `JWT_SECRET` - JWT signing secret (min 32 chars)
- `JWT_REFRESH_SECRET` - Refresh token secret (min 32 chars)
- `S3_ENDPOINT` - S3/MinIO endpoint
- `S3_ACCESS_KEY` - S3 access key
- `S3_SECRET_KEY` - S3 secret key

## Testing

```bash
# Run tests
npm test

# Run with coverage
npm run test:coverage
```

## Building for Production

```bash
# Build backend
cd backend
npm run build

# Build Docker image
docker build -t rtc-backend .
```

## Deployment

See [DEPLOYMENT.md](./DEPLOYMENT.md) for detailed deployment instructions including:
- Docker deployment
- Kubernetes deployment
- NGINX configuration
- SSL/TLS setup
- Monitoring and logging
- Scaling strategies

## Troubleshooting

### Database Connection Issues

```bash
# Check PostgreSQL
docker-compose exec postgres psql -U rtc_user -d rtc_app

# Check MongoDB
docker-compose exec mongodb mongosh -u admin -p

# Check Redis
docker-compose exec redis redis-cli -a your_password ping
```

### WebSocket Connection Issues

- Ensure CORS is properly configured
- Check firewall rules
- Verify WebSocket upgrade headers in NGINX

### File Upload Issues

- Check MinIO is running: `docker-compose ps minio`
- Verify bucket exists: `docker-compose exec minio mc ls myminio/`
- Check file size limits in configuration

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

MIT License - see LICENSE file for details

## Support

For issues and questions:
- Create an issue on GitHub
- Check documentation in `/docs`
- Review [ARCHITECTURE.md](./ARCHITECTURE.md) and [IMPLEMENTATION.md](./IMPLEMENTATION.md)

## Roadmap

- [ ] Recording functionality
- [ ] AI-powered transcription
- [ ] Virtual backgrounds
- [ ] Breakout rooms
- [ ] Polls and reactions
- [ ] Mobile app support
- [ ] Calendar integration
- [ ] Analytics dashboard
