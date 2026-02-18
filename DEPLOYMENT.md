# Deployment Guide

## Docker Setup

### docker-compose.yml

```yaml
version: '3.8'

services:
  # PostgreSQL Database
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: rtc_app
      POSTGRES_USER: rtc_user
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./init-db.sql:/docker-entrypoint-initdb.d/init.sql
    ports:
      - "5432:5432"
    networks:
      - rtc_network

  # MongoDB
  mongodb:
    image: mongo:7
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_PASSWORD}
    volumes:
      - mongo_data:/data/db
    ports:
      - "27017:27017"
    networks:
      - rtc_network

  # Redis
  redis:
    image: redis:7-alpine
    command: redis-server --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis_data:/data
    ports:
      - "6379:6379"
    networks:
      - rtc_network

  # MinIO (S3-compatible storage)
  minio:
    image: minio/minio
    command: server /data --console-address ":9001"
    environment:
      MINIO_ROOT_USER: ${MINIO_ROOT_USER}
      MINIO_ROOT_PASSWORD: ${MINIO_ROOT_PASSWORD}
    volumes:
      - minio_data:/data
    ports:
      - "9000:9000"
      - "9001:9001"
    networks:
      - rtc_network

  # TURN/STUN Server (coturn)
  coturn:
    image: coturn/coturn
    network_mode: host
    volumes:
      - ./coturn/turnserver.conf:/etc/coturn/turnserver.conf
    command: -c /etc/coturn/turnserver.conf

  # Backend API
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    environment:
      NODE_ENV: production
      PORT: 3001
      DATABASE_URL: postgresql://rtc_user:${POSTGRES_PASSWORD}@postgres:5432/rtc_app
      MONGODB_URI: mongodb://admin:${MONGO_PASSWORD}@mongodb:27017/rtc_app?authSource=admin
      REDIS_URL: redis://:${REDIS_PASSWORD}@redis:6379
      JWT_SECRET: ${JWT_SECRET}
      JWT_REFRESH_SECRET: ${JWT_REFRESH_SECRET}
      S3_ENDPOINT: http://minio:9000
      S3_ACCESS_KEY: ${MINIO_ROOT_USER}
      S3_SECRET_KEY: ${MINIO_ROOT_PASSWORD}
      S3_BUCKET: rtc-files
    depends_on:
      - postgres
      - mongodb
      - redis
      - minio
    ports:
      - "3001:3001"
    networks:
      - rtc_network

  # Frontend
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    environment:
      NEXT_PUBLIC_API_URL: http://backend:3001
      NEXT_PUBLIC_WS_URL: ws://backend:3001
    depends_on:
      - backend
    ports:
      - "3000:3000"
    networks:
      - rtc_network

  # NGINX Reverse Proxy
  nginx:
    image: nginx:alpine
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/ssl:/etc/nginx/ssl
    ports:
      - "80:80"
      - "443:443"
    depends_on:
      - frontend
      - backend
    networks:
      - rtc_network

volumes:
  postgres_data:
  mongo_data:
  redis_data:
  minio_data:

networks:
  rtc_network:
    driver: bridge
```

### Backend Dockerfile

```dockerfile
# backend/Dockerfile
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY --from=builder /app/dist ./dist

EXPOSE 3001

CMD ["node", "dist/index.js"]
```

### Frontend Dockerfile

```dockerfile
# frontend/Dockerfile
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.js ./

EXPOSE 3000

CMD ["npm", "start"]
```

### NGINX Configuration

```nginx
# nginx/nginx.conf
events {
    worker_connections 1024;
}

http {
    upstream frontend {
        server frontend:3000;
    }

    upstream backend {
        server backend:3001;
    }

    # Rate limiting
    limit_req_zone $binary_remote_addr zone=api_limit:10m rate=10r/s;
    limit_req_zone $binary_remote_addr zone=upload_limit:10m rate=2r/s;

    server {
        listen 80;
        server_name your-domain.com;
        return 301 https://$server_name$request_uri;
    }

    server {
        listen 443 ssl http2;
        server_name your-domain.com;

        ssl_certificate /etc/nginx/ssl/cert.pem;
        ssl_certificate_key /etc/nginx/ssl/key.pem;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers HIGH:!aNULL:!MD5;

        # Security headers
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' data:; connect-src 'self' wss://your-domain.com; media-src 'self' blob:;" always;

        # Frontend
        location / {
            proxy_pass http://frontend;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
        }

        # Backend API
        location /api/ {
            limit_req zone=api_limit burst=20 nodelay;
            
            proxy_pass http://backend;
            proxy_http_version 1.1;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        # WebSocket
        location /socket.io/ {
            proxy_pass http://backend;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_read_timeout 86400;
        }

        # File uploads
        location /api/files/upload {
            limit_req zone=upload_limit burst=5 nodelay;
            client_max_body_size 100M;
            
            proxy_pass http://backend;
            proxy_http_version 1.1;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_request_buffering off;
        }
    }
}
```

### TURN Server Configuration

```conf
# coturn/turnserver.conf
listening-port=3478
tls-listening-port=5349

listening-ip=0.0.0.0
relay-ip=YOUR_SERVER_IP

external-ip=YOUR_SERVER_IP

realm=your-domain.com
server-name=your-domain.com

lt-cred-mech
user=username:password

cert=/etc/coturn/cert.pem
pkey=/etc/coturn/key.pem

no-stdout-log
log-file=/var/log/turnserver.log

fingerprint
```

## Environment Variables

Create a `.env` file:

```env
# Database
POSTGRES_PASSWORD=your_secure_password
MONGO_PASSWORD=your_secure_password
REDIS_PASSWORD=your_secure_password

# MinIO
MINIO_ROOT_USER=admin
MINIO_ROOT_PASSWORD=your_secure_password

# JWT
JWT_SECRET=your_jwt_secret_key_min_32_chars
JWT_REFRESH_SECRET=your_refresh_secret_key_min_32_chars

# Application
NODE_ENV=production
FRONTEND_URL=https://your-domain.com
BACKEND_URL=https://your-domain.com/api
```

## Deployment Steps

### 1. Initial Setup

```bash
# Clone repository
git clone <your-repo>
cd rtc-app

# Create environment file
cp .env.example .env
# Edit .env with your values

# Generate SSL certificates (Let's Encrypt)
certbot certonly --standalone -d your-domain.com
cp /etc/letsencrypt/live/your-domain.com/fullchain.pem nginx/ssl/cert.pem
cp /etc/letsencrypt/live/your-domain.com/privkey.pem nginx/ssl/key.pem
```

### 2. Build and Start Services

```bash
# Build images
docker-compose build

# Start services
docker-compose up -d

# Check logs
docker-compose logs -f

# Initialize MinIO bucket
docker-compose exec minio mc alias set myminio http://localhost:9000 $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD
docker-compose exec minio mc mb myminio/rtc-files
docker-compose exec minio mc anonymous set download myminio/rtc-files
```

### 3. Database Migrations

```bash
# Run PostgreSQL migrations
docker-compose exec backend npm run migrate

# Create MongoDB indexes
docker-compose exec backend npm run mongo:indexes
```

### 4. Health Checks

```bash
# Check all services
docker-compose ps

# Test backend
curl https://your-domain.com/api/health

# Test WebSocket
wscat -c wss://your-domain.com/socket.io/
```

## Kubernetes Deployment (Production)

### kubernetes/deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rtc-backend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: rtc-backend
  template:
    metadata:
      labels:
        app: rtc-backend
    spec:
      containers:
      - name: backend
        image: your-registry/rtc-backend:latest
        ports:
        - containerPort: 3001
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: rtc-secrets
              key: database-url
        - name: REDIS_URL
          valueFrom:
            secretKeyRef:
              name: rtc-secrets
              key: redis-url
        resources:
          requests:
            memory: "512Mi"
            cpu: "500m"
          limits:
            memory: "1Gi"
            cpu: "1000m"
        livenessProbe:
          httpGet:
            path: /health
            port: 3001
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 3001
          initialDelaySeconds: 5
          periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: rtc-backend-service
spec:
  selector:
    app: rtc-backend
  ports:
  - protocol: TCP
    port: 80
    targetPort: 3001
  type: LoadBalancer
```

## Monitoring Setup

### Prometheus Configuration

```yaml
# prometheus/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'rtc-backend'
    static_configs:
      - targets: ['backend:3001']
    metrics_path: '/metrics'

  - job_name: 'postgres'
    static_configs:
      - targets: ['postgres-exporter:9187']

  - job_name: 'redis'
    static_configs:
      - targets: ['redis-exporter:9121']
```

### Add to docker-compose.yml

```yaml
  prometheus:
    image: prom/prometheus
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    ports:
      - "9090:9090"
    networks:
      - rtc_network

  grafana:
    image: grafana/grafana
    environment:
      GF_SECURITY_ADMIN_PASSWORD: ${GRAFANA_PASSWORD}
    volumes:
      - grafana_data:/var/lib/grafana
    ports:
      - "3002:3000"
    networks:
      - rtc_network
```

## Scaling Considerations

### Horizontal Scaling
- Use Redis for session storage (sticky sessions not required)
- Deploy multiple backend instances behind load balancer
- Use SFU (mediasoup) for efficient media routing
- Implement WebSocket sticky sessions or use Redis adapter

### Vertical Scaling
- Increase CPU for media processing
- Increase memory for concurrent connections
- Use dedicated media servers for large rooms

### Database Optimization
- Read replicas for PostgreSQL
- MongoDB sharding for chat history
- Redis cluster for high availability
- Connection pooling (pg-pool, mongoose)

## Backup Strategy

```bash
# PostgreSQL backup
docker-compose exec postgres pg_dump -U rtc_user rtc_app > backup_$(date +%Y%m%d).sql

# MongoDB backup
docker-compose exec mongodb mongodump --out=/backup

# MinIO backup
docker-compose exec minio mc mirror myminio/rtc-files /backup/files
```

## Security Checklist

- [ ] SSL/TLS certificates installed and auto-renewal configured
- [ ] Firewall rules configured (allow only 80, 443, 3478, 5349)
- [ ] Database passwords rotated regularly
- [ ] JWT secrets are cryptographically secure (32+ chars)
- [ ] Rate limiting enabled on all endpoints
- [ ] CORS configured with specific origins
- [ ] Security headers configured in NGINX
- [ ] File upload validation and scanning enabled
- [ ] Logs monitored for suspicious activity
- [ ] Regular security updates applied
- [ ] Backup and disaster recovery tested
- [ ] DDoS protection enabled (CloudFlare/AWS Shield)

## Performance Optimization

1. **CDN**: Use CloudFlare or AWS CloudFront for static assets
2. **Caching**: Implement Redis caching for frequent queries
3. **Compression**: Enable gzip/brotli in NGINX
4. **Image Optimization**: Use sharp for image processing
5. **Code Splitting**: Lazy load components in React
6. **Database Indexing**: Add indexes on frequently queried columns
7. **Connection Pooling**: Configure appropriate pool sizes
8. **Media Optimization**: Use VP9/H.264 codecs, adaptive bitrate

## Troubleshooting

### WebRTC Connection Issues
```bash
# Check STUN/TURN server
telnet your-server 3478

# Test ICE connectivity
# Use https://webrtc.github.io/samples/src/content/peerconnection/trickle-ice/
```

### WebSocket Connection Issues
```bash
# Check WebSocket endpoint
wscat -c wss://your-domain.com/socket.io/

# Check NGINX WebSocket config
docker-compose exec nginx nginx -t
```

### Database Connection Issues
```bash
# Check PostgreSQL
docker-compose exec postgres psql -U rtc_user -d rtc_app

# Check MongoDB
docker-compose exec mongodb mongosh -u admin -p
```

## Maintenance

### Update Dependencies
```bash
# Backend
cd backend && npm audit fix && npm update

# Frontend
cd frontend && npm audit fix && npm update
```

### Log Rotation
```bash
# Configure logrotate
/var/log/rtc-app/*.log {
    daily
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 www-data www-data
}
```

### SSL Certificate Renewal
```bash
# Auto-renewal with certbot
certbot renew --dry-run

# Add to crontab
0 0 * * * certbot renew --quiet && docker-compose restart nginx
```
