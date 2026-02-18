# Backend Setup Checklist

Use this checklist to ensure your backend is properly configured and running.

## Pre-Installation Checklist

- [ ] Docker Desktop installed (for Docker setup)
- [ ] Node.js 20+ installed (for local development)
- [ ] Git installed
- [ ] Text editor/IDE installed (VS Code recommended)

## Installation Steps

### Option A: Docker Setup (Recommended)

- [ ] Clone repository
- [ ] Copy `.env.example` to `.env`
- [ ] Update all passwords in `.env` (minimum 8 characters)
- [ ] Generate secure JWT secrets (32+ characters)
- [ ] Run `docker-compose up -d`
- [ ] Wait for all services to be healthy
- [ ] Create MinIO bucket: `docker-compose exec minio mc mb myminio/rtc-files`
- [ ] Check logs: `docker-compose logs -f backend`

### Option B: Local Development Setup

- [ ] Install PostgreSQL 15+
- [ ] Install MongoDB 7+
- [ ] Install Redis 7+
- [ ] Install MinIO
- [ ] Create PostgreSQL database and user
- [ ] Copy `backend/.env.example` to `backend/.env`
- [ ] Update database URLs in `.env`
- [ ] Run `cd backend && npm install`
- [ ] Run `npm run migrate`
- [ ] Start services (PostgreSQL, MongoDB, Redis, MinIO)
- [ ] Run `npm run dev`

## Configuration Checklist

### Environment Variables

- [ ] `NODE_ENV` set (development/production)
- [ ] `PORT` configured (default: 3001)
- [ ] `DATABASE_URL` points to PostgreSQL
- [ ] `MONGODB_URI` points to MongoDB
- [ ] `REDIS_URL` points to Redis
- [ ] `JWT_SECRET` is 32+ characters
- [ ] `JWT_REFRESH_SECRET` is 32+ characters
- [ ] `S3_ENDPOINT` points to MinIO/S3
- [ ] `S3_ACCESS_KEY` configured
- [ ] `S3_SECRET_KEY` configured
- [ ] `S3_BUCKET` name set (rtc-files)
- [ ] `FRONTEND_URL` configured for CORS

### Database Setup

- [ ] PostgreSQL database created
- [ ] PostgreSQL user created with permissions
- [ ] MongoDB running and accessible
- [ ] Redis running and accessible
- [ ] Database migrations executed successfully
- [ ] All tables created in PostgreSQL
- [ ] Indexes created properly

### Storage Setup

- [ ] MinIO/S3 running
- [ ] Bucket created (rtc-files)
- [ ] Access credentials working
- [ ] Can upload test file
- [ ] Can download test file

## Verification Checklist

### Service Health

- [ ] Backend server starts without errors
- [ ] PostgreSQL connection successful
- [ ] MongoDB connection successful
- [ ] Redis connection successful
- [ ] MinIO/S3 connection successful

### API Endpoints

- [ ] `GET /health` returns 200 OK
- [ ] `GET /ready` returns 200 OK
- [ ] `POST /api/auth/register` works
- [ ] `POST /api/auth/login` works
- [ ] `POST /api/auth/logout` works
- [ ] `GET /api/auth/profile` works (with auth)
- [ ] `POST /api/rooms` works (with auth)
- [ ] `GET /api/rooms` works (with auth)

### WebSocket Connection

- [ ] WebSocket server accepts connections
- [ ] Authentication works for WebSocket
- [ ] Can join a room via WebSocket
- [ ] Can send chat messages
- [ ] Can draw on whiteboard
- [ ] WebRTC signaling works

### File Upload

- [ ] Can upload files < 100MB
- [ ] Files stored in MinIO/S3
- [ ] File metadata saved to database
- [ ] Can retrieve file download URL
- [ ] Can download files
- [ ] Can delete files

### Security

- [ ] Passwords are hashed (not plain text)
- [ ] JWT tokens expire after 15 minutes
- [ ] Refresh tokens expire after 7 days
- [ ] Cookies are httpOnly and secure
- [ ] CORS configured correctly
- [ ] Rate limiting active
- [ ] Helmet headers applied
- [ ] SQL injection protection (parameterized queries)

## Testing Checklist

### Manual Testing

- [ ] Register a new user
- [ ] Login with credentials
- [ ] Create a room
- [ ] Join a room
- [ ] Send chat messages
- [ ] Upload a file
- [ ] Download a file
- [ ] Leave a room
- [ ] Logout

### WebSocket Testing

- [ ] Connect to WebSocket server
- [ ] Join a room
- [ ] Send WebRTC offer
- [ ] Receive WebRTC answer
- [ ] Exchange ICE candidates
- [ ] Toggle audio/video
- [ ] Start screen share
- [ ] Stop screen share
- [ ] Send chat message
- [ ] Draw on whiteboard

### Load Testing (Optional)

- [ ] Multiple users can join same room
- [ ] Chat messages delivered to all users
- [ ] Whiteboard updates synchronized
- [ ] File uploads work under load
- [ ] WebRTC connections stable

## Production Readiness Checklist

### Security Hardening

- [ ] All default passwords changed
- [ ] JWT secrets are cryptographically secure
- [ ] SSL/TLS certificates installed
- [ ] Firewall rules configured
- [ ] Rate limiting tuned for production
- [ ] CORS origins restricted to production domains
- [ ] Security headers configured
- [ ] File upload scanning enabled (optional)

### Performance Optimization

- [ ] Database indexes verified
- [ ] Connection pooling configured
- [ ] Redis caching enabled
- [ ] CDN configured for static assets (optional)
- [ ] Compression enabled (gzip/brotli)
- [ ] Image optimization enabled

### Monitoring & Logging

- [ ] Application logs configured
- [ ] Error tracking setup (Sentry, etc.)
- [ ] Performance monitoring (Prometheus, etc.)
- [ ] Database monitoring enabled
- [ ] Uptime monitoring configured
- [ ] Alert notifications setup

### Backup & Recovery

- [ ] Database backup strategy defined
- [ ] Automated backups scheduled
- [ ] Backup restoration tested
- [ ] File storage backup configured
- [ ] Disaster recovery plan documented

### Deployment

- [ ] Docker images built successfully
- [ ] Kubernetes manifests created (if using K8s)
- [ ] CI/CD pipeline configured
- [ ] Staging environment tested
- [ ] Production deployment plan ready
- [ ] Rollback procedure documented

## Troubleshooting Checklist

### Server Won't Start

- [ ] Check all environment variables are set
- [ ] Verify database connections
- [ ] Check port availability (3001)
- [ ] Review error logs
- [ ] Verify Node.js version (20+)

### Database Connection Issues

- [ ] PostgreSQL is running
- [ ] MongoDB is running
- [ ] Redis is running
- [ ] Connection strings are correct
- [ ] Credentials are valid
- [ ] Network connectivity works
- [ ] Firewall allows connections

### WebSocket Issues

- [ ] WebSocket port is open
- [ ] CORS configured correctly
- [ ] Authentication token valid
- [ ] Proxy/load balancer configured for WebSocket
- [ ] Check browser console for errors

### File Upload Issues

- [ ] MinIO/S3 is running
- [ ] Bucket exists
- [ ] Credentials are correct
- [ ] File size within limits
- [ ] Network connectivity works
- [ ] Sufficient storage space

### Performance Issues

- [ ] Check database query performance
- [ ] Review connection pool settings
- [ ] Monitor memory usage
- [ ] Check CPU usage
- [ ] Review rate limiting settings
- [ ] Analyze slow queries

## Maintenance Checklist

### Daily

- [ ] Check application logs for errors
- [ ] Monitor server resources
- [ ] Review security alerts

### Weekly

- [ ] Review database performance
- [ ] Check backup integrity
- [ ] Update dependencies (security patches)
- [ ] Review user feedback

### Monthly

- [ ] Full security audit
- [ ] Performance optimization review
- [ ] Database cleanup (old sessions, etc.)
- [ ] Update documentation
- [ ] Review and update monitoring alerts

## Documentation Checklist

- [ ] README.md complete
- [ ] API documentation available
- [ ] WebSocket events documented
- [ ] Environment variables documented
- [ ] Deployment guide available
- [ ] Troubleshooting guide available
- [ ] Architecture diagrams created
- [ ] Code comments added

## Sign-Off

- [ ] All checklist items completed
- [ ] Backend tested and verified
- [ ] Documentation reviewed
- [ ] Team trained on deployment
- [ ] Production deployment approved

---

**Date Completed:** _______________

**Completed By:** _______________

**Reviewed By:** _______________

**Notes:**
