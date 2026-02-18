# Implementation Guide - Real-Time Communication App

## Project Structure

```
rtc-app/
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   │   ├── VideoCall/
│   │   │   ├── ScreenShare/
│   │   │   ├── Whiteboard/
│   │   │   ├── Chat/
│   │   │   └── FileShare/
│   │   ├── hooks/
│   │   ├── services/
│   │   ├── store/
│   │   └── utils/
│   ├── package.json
│   └── next.config.js
├── backend/
│   ├── src/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── models/
│   │   ├── middleware/
│   │   ├── sockets/
│   │   └── config/
│   ├── package.json
│   └── tsconfig.json
├── docker-compose.yml
└── README.md
```

## 1. Multi-User Video Call Implementation

### Backend: WebRTC Signaling Server (Node.js + Socket.io)

```typescript
// backend/src/sockets/webrtc-signaling.ts
import { Server, Socket } from 'socket.io';
import { verifyToken } from '../middleware/auth';

interface RoomParticipant {
  socketId: string;
  userId: string;
  username: string;
  isAudioEnabled: boolean;
  isVideoEnabled: boolean;
}

const rooms = new Map<string, Map<string, RoomParticipant>>();

export function setupWebRTCSignaling(io: Server) {
  io.use(async (socket, next) => {
    try {
      const token = socket.handshake.auth.token;
      const user = await verifyToken(token);
      socket.data.user = user;
      next();
    } catch (error) {
      next(new Error('Authentication failed'));
    }
  });

  io.on('connection', (socket: Socket) => {
    console.log(`User connected: ${socket.data.user.id}`);

    // Join room
    socket.on('join-room', async ({ roomId }) => {
      try {
        socket.join(roomId);

        if (!rooms.has(roomId)) {
          rooms.set(roomId, new Map());
        }

        const room = rooms.get(roomId)!;
        const participant: RoomParticipant = {
          socketId: socket.id,
          userId: socket.data.user.id,
          username: socket.data.user.username,
          isAudioEnabled: true,
          isVideoEnabled: true,
        };

        room.set(socket.id, participant);

        // Notify existing participants
        const existingParticipants = Array.from(room.values())
          .filter(p => p.socketId !== socket.id);

        socket.emit('existing-participants', existingParticipants);

        // Notify others about new participant
        socket.to(roomId).emit('participant-joined', participant);

        console.log(`User ${socket.data.user.username} joined room ${roomId}`);
      } catch (error) {
        socket.emit('error', { message: 'Failed to join room' });
      }
    });

    // WebRTC offer
    socket.on('offer', ({ to, offer }) => {
      socket.to(to).emit('offer', {
        from: socket.id,
        offer,
        participant: rooms.get(socket.rooms.values().next().value)?.get(socket.id),
      });
    });

    // WebRTC answer
    socket.on('answer', ({ to, answer }) => {
      socket.to(to).emit('answer', {
        from: socket.id,
        answer,
      });
    });

    // ICE candidate
    socket.on('ice-candidate', ({ to, candidate }) => {
      socket.to(to).emit('ice-candidate', {
        from: socket.id,
        candidate,
      });
    });

    // Toggle audio/video
    socket.on('toggle-media', ({ roomId, type, enabled }) => {
      const room = rooms.get(roomId);
      if (room) {
        const participant = room.get(socket.id);
        if (participant) {
          if (type === 'audio') participant.isAudioEnabled = enabled;
          if (type === 'video') participant.isVideoEnabled = enabled;
          
          socket.to(roomId).emit('participant-media-changed', {
            socketId: socket.id,
            type,
            enabled,
          });
        }
      }
    });

    // Leave room
    socket.on('leave-room', (roomId) => {
      handleLeaveRoom(socket, roomId);
    });

    socket.on('disconnect', () => {
      // Clean up all rooms
      rooms.forEach((room, roomId) => {
        if (room.has(socket.id)) {
          handleLeaveRoom(socket, roomId);
        }
      });
    });
  });
}

function handleLeaveRoom(socket: Socket, roomId: string) {
  const room = rooms.get(roomId);
  if (room) {
    room.delete(socket.id);
    socket.to(roomId).emit('participant-left', { socketId: socket.id });
    socket.leave(roomId);

    if (room.size === 0) {
      rooms.delete(roomId);
    }
  }
}
```

### Frontend: Video Call Component (React + WebRTC)

```typescript
// frontend/src/hooks/useWebRTC.ts
import { useEffect, useRef, useState } from 'react';
import { io, Socket } from 'socket.io-client';

interface Participant {
  socketId: string;
  userId: string;
  username: string;
  stream?: MediaStream;
  isAudioEnabled: boolean;
  isVideoEnabled: boolean;
}

const ICE_SERVERS = {
  iceServers: [
    { urls: 'stun:stun.l.google.com:19302' },
    { urls: 'stun:stun1.l.google.com:19302' },
    // Add TURN servers for production
    // {
    //   urls: 'turn:your-turn-server.com:3478',
    //   username: 'user',
    //   credential: 'pass'
    // }
  ],
};

export function useWebRTC(roomId: string, token: string) {
  const [participants, setParticipants] = useState<Map<string, Participant>>(new Map());
  const [localStream, setLocalStream] = useState<MediaStream | null>(null);
  const socketRef = useRef<Socket | null>(null);
  const peerConnectionsRef = useRef<Map<string, RTCPeerConnection>>(new Map());

  useEffect(() => {
    initializeMedia();
    connectSocket();

    return () => {
      cleanup();
    };
  }, [roomId]);

  const initializeMedia = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({
        video: { width: 1280, height: 720 },
        audio: {
          echoCancellation: true,
          noiseSuppression: true,
          autoGainControl: true,
        },
      });
      setLocalStream(stream);
    } catch (error) {
      console.error('Failed to get media devices:', error);
    }
  };

  const connectSocket = () => {
    const socket = io(process.env.NEXT_PUBLIC_WS_URL!, {
      auth: { token },
    });

    socketRef.current = socket;

    socket.on('connect', () => {
      socket.emit('join-room', { roomId });
    });

    socket.on('existing-participants', (existingParticipants: Participant[]) => {
      existingParticipants.forEach(participant => {
        createPeerConnection(participant.socketId, true);
      });
    });

    socket.on('participant-joined', (participant: Participant) => {
      setParticipants(prev => new Map(prev).set(participant.socketId, participant));
    });

    socket.on('offer', async ({ from, offer, participant }) => {
      setParticipants(prev => new Map(prev).set(from, participant));
      const pc = createPeerConnection(from, false);
      await pc.setRemoteDescription(new RTCSessionDescription(offer));
      const answer = await pc.createAnswer();
      await pc.setLocalDescription(answer);
      socket.emit('answer', { to: from, answer });
    });

    socket.on('answer', async ({ from, answer }) => {
      const pc = peerConnectionsRef.current.get(from);
      if (pc) {
        await pc.setRemoteDescription(new RTCSessionDescription(answer));
      }
    });

    socket.on('ice-candidate', async ({ from, candidate }) => {
      const pc = peerConnectionsRef.current.get(from);
      if (pc && candidate) {
        await pc.addIceCandidate(new RTCIceCandidate(candidate));
      }
    });

    socket.on('participant-left', ({ socketId }) => {
      closePeerConnection(socketId);
      setParticipants(prev => {
        const newMap = new Map(prev);
        newMap.delete(socketId);
        return newMap;
      });
    });

    socket.on('participant-media-changed', ({ socketId, type, enabled }) => {
      setParticipants(prev => {
        const newMap = new Map(prev);
        const participant = newMap.get(socketId);
        if (participant) {
          if (type === 'audio') participant.isAudioEnabled = enabled;
          if (type === 'video') participant.isVideoEnabled = enabled;
          newMap.set(socketId, { ...participant });
        }
        return newMap;
      });
    });
  };

  const createPeerConnection = (socketId: string, isInitiator: boolean): RTCPeerConnection => {
    const pc = new RTCPeerConnection(ICE_SERVERS);
    peerConnectionsRef.current.set(socketId, pc);

    // Add local stream tracks
    if (localStream) {
      localStream.getTracks().forEach(track => {
        pc.addTrack(track, localStream);
      });
    }

    // Handle incoming stream
    pc.ontrack = (event) => {
      setParticipants(prev => {
        const newMap = new Map(prev);
        const participant = newMap.get(socketId);
        if (participant) {
          newMap.set(socketId, { ...participant, stream: event.streams[0] });
        }
        return newMap;
      });
    };

    // Handle ICE candidates
    pc.onicecandidate = (event) => {
      if (event.candidate) {
        socketRef.current?.emit('ice-candidate', {
          to: socketId,
          candidate: event.candidate,
        });
      }
    };

    // Create offer if initiator
    if (isInitiator) {
      pc.createOffer()
        .then(offer => pc.setLocalDescription(offer))
        .then(() => {
          socketRef.current?.emit('offer', {
            to: socketId,
            offer: pc.localDescription,
          });
        });
    }

    return pc;
  };

  const closePeerConnection = (socketId: string) => {
    const pc = peerConnectionsRef.current.get(socketId);
    if (pc) {
      pc.close();
      peerConnectionsRef.current.delete(socketId);
    }
  };

  const toggleAudio = () => {
    if (localStream) {
      const audioTrack = localStream.getAudioTracks()[0];
      audioTrack.enabled = !audioTrack.enabled;
      socketRef.current?.emit('toggle-media', {
        roomId,
        type: 'audio',
        enabled: audioTrack.enabled,
      });
    }
  };

  const toggleVideo = () => {
    if (localStream) {
      const videoTrack = localStream.getVideoTracks()[0];
      videoTrack.enabled = !videoTrack.enabled;
      socketRef.current?.emit('toggle-media', {
        roomId,
        type: 'video',
        enabled: videoTrack.enabled,
      });
    }
  };

  const cleanup = () => {
    localStream?.getTracks().forEach(track => track.stop());
    peerConnectionsRef.current.forEach(pc => pc.close());
    socketRef.current?.disconnect();
  };

  return {
    localStream,
    participants,
    toggleAudio,
    toggleVideo,
  };
}
```

```typescript
// frontend/src/components/VideoCall/VideoCall.tsx
import React, { useRef, useEffect } from 'react';
import { useWebRTC } from '@/hooks/useWebRTC';

interface VideoCallProps {
  roomId: string;
  token: string;
}

export function VideoCall({ roomId, token }: VideoCallProps) {
  const { localStream, participants, toggleAudio, toggleVideo } = useWebRTC(roomId, token);
  const localVideoRef = useRef<HTMLVideoElement>(null);

  useEffect(() => {
    if (localVideoRef.current && localStream) {
      localVideoRef.current.srcObject = localStream;
    }
  }, [localStream]);

  return (
    <div className="video-call-container">
      <div className="video-grid">
        {/* Local video */}
        <div className="video-wrapper local">
          <video
            ref={localVideoRef}
            autoPlay
            muted
            playsInline
            className="video-element"
          />
          <span className="participant-name">You</span>
        </div>

        {/* Remote videos */}
        {Array.from(participants.values()).map(participant => (
          <RemoteVideo key={participant.socketId} participant={participant} />
        ))}
      </div>

      <div className="controls">
        <button onClick={toggleAudio}>Toggle Audio</button>
        <button onClick={toggleVideo}>Toggle Video</button>
      </div>
    </div>
  );
}

function RemoteVideo({ participant }: { participant: any }) {
  const videoRef = useRef<HTMLVideoElement>(null);

  useEffect(() => {
    if (videoRef.current && participant.stream) {
      videoRef.current.srcObject = participant.stream;
    }
  }, [participant.stream]);

  return (
    <div className="video-wrapper">
      <video
        ref={videoRef}
        autoPlay
        playsInline
        className="video-element"
      />
      <span className="participant-name">{participant.username}</span>
      {!participant.isAudioEnabled && <span className="muted-icon">🔇</span>}
      {!participant.isVideoEnabled && <span className="video-off-icon">📷</span>}
    </div>
  );
}
```

## 2. Screen Sharing Implementation

```typescript
// frontend/src/hooks/useScreenShare.ts
import { useState, useRef } from 'react';

export function useScreenShare(peerConnections: Map<string, RTCPeerConnection>) {
  const [isSharing, setIsSharing] = useState(false);
  const screenStreamRef = useRef<MediaStream | null>(null);
  const originalSendersRef = useRef<Map<string, RTCRtpSender[]>>(new Map());

  const startScreenShare = async () => {
    try {
      const screenStream = await navigator.mediaDevices.getDisplayMedia({
        video: {
          cursor: 'always',
          displaySurface: 'monitor',
        },
        audio: false,
      });

      screenStreamRef.current = screenStream;

      // Replace video track in all peer connections
      const videoTrack = screenStream.getVideoTracks()[0];
      
      peerConnections.forEach((pc, socketId) => {
        const senders = pc.getSenders();
        const videoSender = senders.find(sender => 
          sender.track?.kind === 'video'
        );

        if (videoSender) {
          originalSendersRef.current.set(socketId, senders);
          videoSender.replaceTrack(videoTrack);
        }
      });

      // Handle screen share stop
      videoTrack.onended = () => {
        stopScreenShare();
      };

      setIsSharing(true);
    } catch (error) {
      console.error('Failed to start screen share:', error);
    }
  };

  const stopScreenShare = () => {
    if (screenStreamRef.current) {
      screenStreamRef.current.getTracks().forEach(track => track.stop());
      screenStreamRef.current = null;
    }

    // Restore original video tracks
    peerConnections.forEach((pc, socketId) => {
      const senders = originalSendersRef.current.get(socketId);
      if (senders) {
        // Get original camera track and replace back
        navigator.mediaDevices.getUserMedia({ video: true })
          .then(stream => {
            const videoTrack = stream.getVideoTracks()[0];
            const videoSender = pc.getSenders().find(s => s.track?.kind === 'video');
            if (videoSender) {
              videoSender.replaceTrack(videoTrack);
            }
          });
      }
    });

    setIsSharing(false);
  };

  return { isSharing, startScreenShare, stopScreenShare };
}
```

## 3. Whiteboard Collaboration

```typescript
// frontend/src/components/Whiteboard/Whiteboard.tsx
import React, { useEffect, useRef, useState } from 'react';
import { fabric } from 'fabric';
import { Socket } from 'socket.io-client';

interface WhiteboardProps {
  roomId: string;
  socket: Socket;
}

export function Whiteboard({ roomId, socket }: WhiteboardProps) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const fabricCanvasRef = useRef<fabric.Canvas | null>(null);
  const [tool, setTool] = useState<'pen' | 'eraser'>('pen');
  const [color, setColor] = useState('#000000');
  const [brushSize, setBrushSize] = useState(2);

  useEffect(() => {
    if (!canvasRef.current) return;

    const canvas = new fabric.Canvas(canvasRef.current, {
      isDrawingMode: true,
      width: 1200,
      height: 800,
    });

    fabricCanvasRef.current = canvas;

    // Configure brush
    canvas.freeDrawingBrush.color = color;
    canvas.freeDrawingBrush.width = brushSize;

    // Listen for drawing events
    canvas.on('path:created', (e) => {
      const path = e.path;
      const pathData = path?.toJSON();
      
      socket.emit('whiteboard-draw', {
        roomId,
        action: 'draw',
        data: pathData,
      });
    });

    // Listen for remote drawing
    socket.on('whiteboard-update', ({ action, data }) => {
      if (action === 'draw') {
        fabric.util.enlivenObjects([data], (objects: fabric.Object[]) => {
          objects.forEach(obj => {
            canvas.add(obj);
          });
          canvas.renderAll();
        });
      } else if (action === 'clear') {
        canvas.clear();
      }
    });

    return () => {
      canvas.dispose();
    };
  }, [roomId, socket]);

  useEffect(() => {
    if (fabricCanvasRef.current) {
      const canvas = fabricCanvasRef.current;
      canvas.freeDrawingBrush.color = tool === 'eraser' ? '#FFFFFF' : color;
      canvas.freeDrawingBrush.width = brushSize;
    }
  }, [tool, color, brushSize]);

  const clearCanvas = () => {
    if (fabricCanvasRef.current) {
      fabricCanvasRef.current.clear();
      socket.emit('whiteboard-draw', {
        roomId,
        action: 'clear',
      });
    }
  };

  return (
    <div className="whiteboard-container">
      <div className="whiteboard-toolbar">
        <button onClick={() => setTool('pen')}>Pen</button>
        <button onClick={() => setTool('eraser')}>Eraser</button>
        <input
          type="color"
          value={color}
          onChange={(e) => setColor(e.target.value)}
        />
        <input
          type="range"
          min="1"
          max="20"
          value={brushSize}
          onChange={(e) => setBrushSize(Number(e.target.value))}
        />
        <button onClick={clearCanvas}>Clear</button>
      </div>
      <canvas ref={canvasRef} />
    </div>
  );
}
```

```typescript
// backend/src/sockets/whiteboard.ts
export function setupWhiteboard(io: Server) {
  io.on('connection', (socket) => {
    socket.on('whiteboard-draw', ({ roomId, action, data }) => {
      // Broadcast to all other participants
      socket.to(roomId).emit('whiteboard-update', { action, data });

      // Optionally save to MongoDB for persistence
      // saveWhiteboardAction(roomId, socket.data.user.id, action, data);
    });
  });
}
```

## 4. File Sharing with Encryption

```typescript
// frontend/src/services/fileEncryption.ts
export class FileEncryptionService {
  async encryptFile(file: File, roomKey: CryptoKey): Promise<{ 
    encryptedData: ArrayBuffer; 
    iv: Uint8Array;
  }> {
    const fileData = await file.arrayBuffer();
    const iv = crypto.getRandomValues(new Uint8Array(12));

    const encryptedData = await crypto.subtle.encrypt(
      { name: 'AES-GCM', iv },
      roomKey,
      fileData
    );

    return { encryptedData, iv };
  }

  async decryptFile(
    encryptedData: ArrayBuffer,
    iv: Uint8Array,
    roomKey: CryptoKey
  ): Promise<ArrayBuffer> {
    return await crypto.subtle.encrypt(
      { name: 'AES-GCM', iv },
      roomKey,
      encryptedData
    );
  }

  async generateRoomKey(): Promise<CryptoKey> {
    return await crypto.subtle.generateKey(
      { name: 'AES-GCM', length: 256 },
      true,
      ['encrypt', 'decrypt']
    );
  }
}
```

```typescript
// frontend/src/components/FileShare/FileUpload.tsx
import React, { useState } from 'react';
import { FileEncryptionService } from '@/services/fileEncryption';

export function FileUpload({ roomId, roomKey, onUploadComplete }: any) {
  const [uploading, setUploading] = useState(false);
  const encryptionService = new FileEncryptionService();

  const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    setUploading(true);

    try {
      // Encrypt file client-side
      const { encryptedData, iv } = await encryptionService.encryptFile(file, roomKey);

      // Create form data
      const formData = new FormData();
      formData.append('file', new Blob([encryptedData]));
      formData.append('filename', file.name);
      formData.append('iv', Buffer.from(iv).toString('base64'));
      formData.append('roomId', roomId);

      // Upload to server
      const response = await fetch('/api/files/upload', {
        method: 'POST',
        body: formData,
        headers: {
          'Authorization': `Bearer ${localStorage.getItem('token')}`,
        },
      });

      const result = await response.json();
      onUploadComplete(result);
    } catch (error) {
      console.error('Upload failed:', error);
    } finally {
      setUploading(false);
    }
  };

  return (
    <div>
      <input
        type="file"
        onChange={handleFileUpload}
        disabled={uploading}
      />
      {uploading && <span>Encrypting and uploading...</span>}
    </div>
  );
}
```

```typescript
// backend/src/controllers/fileController.ts
import multer from 'multer';
import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';
import crypto from 'crypto';

const upload = multer({ storage: multer.memoryStorage() });
const s3Client = new S3Client({ region: process.env.AWS_REGION });

export async function uploadFile(req: Request, res: Response) {
  try {
    const file = req.file;
    const { filename, iv, roomId } = req.body;
    const userId = req.user.id;

    // Generate unique filename
    const uniqueFilename = `${crypto.randomUUID()}-${filename}`;

    // Upload to S3
    await s3Client.send(new PutObjectCommand({
      Bucket: process.env.S3_BUCKET,
      Key: `rooms/${roomId}/${uniqueFilename}`,
      Body: file.buffer,
      ServerSideEncryption: 'AES256',
    }));

    // Save metadata to database
    const fileRecord = await db.files.create({
      roomId,
      uploadedBy: userId,
      filename: uniqueFilename,
      originalFilename: filename,
      fileSize: file.size,
      mimeType: file.mimetype,
      storagePath: `rooms/${roomId}/${uniqueFilename}`,
      iv,
    });

    res.json({ success: true, file: fileRecord });
  } catch (error) {
    res.status(500).json({ error: 'Upload failed' });
  }
}
```

## 5. Authentication Implementation

```typescript
// backend/src/controllers/authController.ts
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { db } from '../config/database';

export async function register(req: Request, res: Response) {
  try {
    const { email, username, password } = req.body;

    // Validate input
    if (password.length < 12) {
      return res.status(400).json({ error: 'Password must be at least 12 characters' });
    }

    // Hash password
    const passwordHash = await bcrypt.hash(password, 12);

    // Create user
    const user = await db.users.create({
      email,
      username,
      passwordHash,
    });

    res.json({ success: true, userId: user.id });
  } catch (error) {
    res.status(500).json({ error: 'Registration failed' });
  }
}

export async function login(req: Request, res: Response) {
  try {
    const { email, password } = req.body;

    // Find user
    const user = await db.users.findOne({ where: { email } });
    if (!user) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    // Verify password
    const isValid = await bcrypt.compare(password, user.passwordHash);
    if (!isValid) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    // Generate tokens
    const accessToken = jwt.sign(
      { userId: user.id, email: user.email },
      process.env.JWT_SECRET!,
      { expiresIn: '15m' }
    );

    const refreshToken = jwt.sign(
      { userId: user.id },
      process.env.JWT_REFRESH_SECRET!,
      { expiresIn: '7d' }
    );

    // Save session
    await db.sessions.create({
      userId: user.id,
      tokenHash: crypto.createHash('sha256').update(accessToken).digest('hex'),
      refreshTokenHash: crypto.createHash('sha256').update(refreshToken).digest('hex'),
      expiresAt: new Date(Date.now() + 15 * 60 * 1000),
      ipAddress: req.ip,
      userAgent: req.headers['user-agent'],
    });

    // Set httpOnly cookies
    res.cookie('accessToken', accessToken, {
      httpOnly: true,
      secure: true,
      sameSite: 'strict',
      maxAge: 15 * 60 * 1000,
    });

    res.cookie('refreshToken', refreshToken, {
      httpOnly: true,
      secure: true,
      sameSite: 'strict',
      maxAge: 7 * 24 * 60 * 60 * 1000,
    });

    res.json({ success: true, user: { id: user.id, email: user.email, username: user.username } });
  } catch (error) {
    res.status(500).json({ error: 'Login failed' });
  }
}
```

See DEPLOYMENT.md for Docker setup and production deployment guide.
