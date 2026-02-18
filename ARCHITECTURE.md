# Real-Time Communication App - System Architecture

## 1. High-Level System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         CLIENT LAYER                             │
├─────────────────────────────────────────────────────────────────┤
│  React/Next.js Frontend                                          │
│  ├── Video/Audio Components (WebRTC)                            │
│  ├── Screen Share Module                                         │
│  ├── Whiteboard Canvas (Fabric.js/Excalidraw)                  │
│  ├── File Upload/Download UI                                    │
│  └── Real-time Chat Interface                                   │
└─────────────────────────────────────────────────────────────────┘
                              ↕ HTTPS/WSS
┌─────────────────────────────────────────────────────────────────┐
│                      API GATEWAY / LOAD BALANCER                 │
│                         (NGINX/AWS ALB)                          │
└─────────────────────────────────────────────────────────────────┘
                              ↕
┌─────────────────────────────────────────────────────────────────┐
│                      APPLICATION LAYER                           │
├─────────────────────────────────────────────────────────────────┤
│  Node.js/Express Backend                                         │
│  ├── REST API Server (Authentication, User Management)          │
│  ├── WebSocket Server (Socket.io) - Signaling & Real-time      │
│  ├── WebRTC Signaling Service                                   │
│  ├── File Processing Service                                    │
│  └── Encryption/Decryption Service                             │
└─────────────────────────────────────────────────────────────────┘
                              ↕
┌─────────────────────────────────────────────────────────────────┐
│                      MEDIA LAYER                                 │
├─────────────────────────────────────────────────────────────────┤
│  WebRTC Infrastructure                                           │
│  ├── STUN Server (coturn)                                       │
│  ├── TURN Server (coturn) - NAT traversal                      │
│  └── SFU (Selective Forwarding Unit) - mediasoup/Janus         │
└─────────────────────────────────────────────────────────────────┘
                              ↕
┌─────────────────────────────────────────────────────────────────┐
│                      DATA LAYER                                  │
├─────────────────────────────────────────────────────────────────┤
│  ├── PostgreSQL (User data, sessions, metadata)                │
│  ├── MongoDB (Chat history, whiteboard data)                   │
│  ├── Redis (Session cache, presence, pub/sub)                  │
│  └── S3/MinIO (File storage with encryption)                   │
└─────────────────────────────────────────────────────────────────┘
```

## 2. Technology Stack

### Frontend
- **Framework**: React 18+ with Next.js 14 (App Router)
- **State Management**: Zustand or Redux Toolkit
- **WebRTC**: simple-peer or mediasoup-client
- **Real-time**: Socket.io-client
- **Whiteboard**: Fabric.js or Excalidraw
- **UI Components**: shadcn/ui or Material-UI
- **Video Processing**: @mediapipe/tasks-vision (background blur)
- **Encryption**: Web Crypto API, libsodium.js

### Backend
- **Runtime**: Node.js 20+ with TypeScript
- **Framework**: Express.js or Fastify
- **WebSocket**: Socket.io
- **WebRTC Signaling**: Custom implementation
- **Media Server**: mediasoup (SFU) or Janus Gateway
- **Authentication**: Passport.js + JWT
- **Encryption**: Node crypto module, libsodium
- **File Processing**: multer, sharp (image optimization)

### Database & Storage
- **Primary DB**: PostgreSQL 15+ (user data, sessions)
- **Document DB**: MongoDB (chat, whiteboard states)
- **Cache**: Redis 7+ (sessions, presence, pub/sub)
- **File Storage**: AWS S3 or MinIO (self-hosted)
- **Search**: Elasticsearch (optional, for chat history)

### Infrastructure
- **Containerization**: Docker + Docker Compose
- **Orchestration**: Kubernetes (production)
- **Reverse Proxy**: NGINX
- **SSL/TLS**: Let's Encrypt
- **Monitoring**: Prometheus + Grafana
- **Logging**: Winston + ELK Stack

## 3. Real-Time Protocols

### WebRTC (Peer-to-Peer Media)
**Use for**: Video/audio streams, screen sharing

**Why WebRTC?**
- Low latency (< 500ms) for real-time media
- Built-in encryption (DTLS-SRTP)
- Direct peer-to-peer when possible
- Browser native support

**Architecture Choice**: SFU (Selective Forwarding Unit)
- Scales better than mesh (P2P) for 3+ participants
- Lower client CPU usage than MCU
- Each client sends one stream, receives multiple

### WebSockets (Signaling & Data)
**Use for**: Chat, whiteboard, file metadata, presence

**Why WebSockets?**
- Full-duplex communication
- Lower overhead than HTTP polling
- Perfect for signaling WebRTC connections
- Real-time updates for non-media data

**Implementation**: Socket.io
- Automatic reconnection
- Room-based broadcasting
- Fallback to long-polling

### Protocol Flow
```
1. User joins room → WebSocket connection established
2. Exchange SDP offers/answers → WebSocket signaling
3. ICE candidates exchanged → WebSocket
4. Media streams established → WebRTC (P2P or via SFU)
5. Chat/whiteboard updates → WebSocket
6. File metadata → WebSocket, actual file → HTTPS
```

## 4. Database Schema

### PostgreSQL Schema

```sql
-- Users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    public_key TEXT, -- For E2EE
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT true
);

-- Sessions table
CREATE TABLE sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    token_hash VARCHAR(255) NOT NULL,
    refresh_token_hash VARCHAR(255),
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address INET,
    user_agent TEXT
);

-- Rooms table
CREATE TABLE rooms (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    created_by UUID REFERENCES users(id),
    room_type VARCHAR(50) DEFAULT 'public', -- public, private, scheduled
    max_participants INTEGER DEFAULT 50,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    scheduled_at TIMESTAMP,
    ended_at TIMESTAMP
);

-- Room participants
CREATE TABLE room_participants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_id UUID REFERENCES rooms(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    left_at TIMESTAMP,
    role VARCHAR(50) DEFAULT 'participant', -- host, moderator, participant
    UNIQUE(room_id, user_id)
);

-- Files metadata
CREATE TABLE files (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_id UUID REFERENCES rooms(id) ON DELETE CASCADE,
    uploaded_by UUID REFERENCES users(id),
    filename VARCHAR(255) NOT NULL,
    original_filename VARCHAR(255) NOT NULL,
    file_size BIGINT NOT NULL,
    mime_type VARCHAR(100),
    storage_path TEXT NOT NULL,
    encryption_key_id VARCHAR(255), -- Reference to key management
    checksum VARCHAR(64), -- SHA-256
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT false
);

-- Indexes
CREATE INDEX idx_sessions_user_id ON sessions(user_id);
CREATE INDEX idx_sessions_expires_at ON sessions(expires_at);
CREATE INDEX idx_room_participants_room_id ON room_participants(room_id);
CREATE INDEX idx_files_room_id ON files(room_id);
```

### MongoDB Schema

```javascript
// Chat messages collection
{
  _id: ObjectId,
  roomId: UUID,
  userId: UUID,
  username: String,
  message: String, // Encrypted
  messageType: String, // text, file, system
  encryptedKey: String, // Per-message key encrypted with room key
  timestamp: ISODate,
  editedAt: ISODate,
  isDeleted: Boolean,
  replyTo: ObjectId // Reference to another message
}

// Whiteboard states collection
{
  _id: ObjectId,
  roomId: UUID,
  userId: UUID,
  action: String, // draw, erase, clear, undo
  data: Object, // Canvas state or delta
  timestamp: ISODate,
  version: Number // For conflict resolution
}

// Indexes
db.messages.createIndex({ roomId: 1, timestamp: -1 });
db.messages.createIndex({ userId: 1 });
db.whiteboard.createIndex({ roomId: 1, timestamp: -1 });
```

## 5. Security Best Practices

### Authentication & Authorization

1. **Password Security**
   - Use bcrypt (cost factor 12+) or Argon2id
   - Enforce strong password policy (min 12 chars, complexity)
   - Implement rate limiting on login attempts
   - Use HTTPS only for all communications

2. **JWT Token Management**
   - Short-lived access tokens (15 minutes)
   - Long-lived refresh tokens (7 days) stored securely
   - Token rotation on refresh
   - Store tokens in httpOnly, secure, sameSite cookies
   - Implement token blacklist in Redis for logout

3. **Session Management**
   - Generate cryptographically secure session IDs
   - Store session data server-side (Redis)
   - Implement session timeout and idle timeout
   - Allow users to view and revoke active sessions

### End-to-End Encryption

1. **Key Management**
   - Generate client-side key pairs (public/private)
   - Store private keys encrypted with user password
   - Use Diffie-Hellman for shared room keys
   - Rotate room keys when participants change

2. **Message Encryption**
   - Use AES-256-GCM for message encryption
   - Generate unique IV for each message
   - Encrypt with room key, then encrypt room key with user public keys
   - Sign messages with sender's private key

3. **File Encryption**
   - Encrypt files client-side before upload
   - Use AES-256-GCM with unique key per file
   - Store encryption key encrypted with room key
   - Implement chunked encryption for large files

4. **Media Encryption**
   - WebRTC uses DTLS-SRTP (built-in)
   - For SFU, use Insertable Streams API for E2EE
   - Implement frame encryption/decryption in workers

### Secure File Sharing

1. **Upload Security**
   - Validate file types (whitelist approach)
   - Scan files for malware (ClamAV)
   - Limit file sizes (e.g., 100MB per file)
   - Generate unique, non-guessable filenames (UUID)
   - Store files outside web root

2. **Download Security**
   - Verify user authorization before serving
   - Use signed, time-limited URLs (S3 presigned URLs)
   - Implement download rate limiting
   - Log all file access

3. **Storage Security**
   - Enable encryption at rest (S3 SSE or disk encryption)
   - Use separate storage buckets per environment
   - Implement backup and disaster recovery
   - Regular security audits

### Additional Security Measures

- **CORS**: Strict origin policies
- **CSP**: Content Security Policy headers
- **Rate Limiting**: API and WebSocket connections
- **Input Validation**: Sanitize all user inputs
- **SQL Injection**: Use parameterized queries
- **XSS Prevention**: Escape output, use CSP
- **CSRF Protection**: Use CSRF tokens
- **DDoS Protection**: CloudFlare or AWS Shield
- **Audit Logging**: Log security events
- **Dependency Scanning**: Regular npm audit

## 6. Implementation Guide

See IMPLEMENTATION.md for detailed code examples and setup instructions.
