# Quick Start Guide

Get the Real-Time Communication backend up and running in 5 minutes.

## Option 1: Docker (Easiest)

### Step 1: Prerequisites
- Install [Docker Desktop](https://www.docker.com/products/docker-desktop)
- Install [Git](https://git-scm.com/)

### Step 2: Clone and Configure

```bash
# Clone the repository
git clone <your-repo-url>
cd rtc-app

# Create environment file
cp .env.example .env
```

### Step 3: Update Environment Variables

Edit `.env` and change the default passwords:

```env
POSTGRES_PASSWORD=your_secure_password_here
MONGO_PASSWORD=your_secure_password_here
REDIS_PASSWORD=your_secure_password_here
MINIO_ROOT_PASSWORD=your_secure_password_min_8_chars
JWT_SECRET=generate_a_random_32_character_string_here
JWT_REFRESH_SECRET=generate_another_random_32_character_string
```

### Step 4: Start Services

```bash
# Start all services
docker-compose up -d

# Check if services are running
docker-compose ps

# View logs
docker-compose logs -f backend
```

### Step 5: Initialize MinIO Bucket

```bash
# Access MinIO container
docker-compose exec minio sh

# Inside container, run:
mc alias set myminio http://localhost:9000 admin your_minio_password
mc mb myminio/rtc-files
exit
```

### Step 6: Test the API

```bash
# Health check
curl http://localhost:3001/health

# Register a user
curl -X POST http://localhost:3001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "username": "testuser",
    "password": "SecurePassword123!"
  }'

# Login
curl -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "SecurePassword123!"
  }'
```

## Option 2: Local Development

### Step 1: Prerequisites
- Node.js 20+
- PostgreSQL 15+
- MongoDB 7+
- Redis 7+
- MinIO or AWS S3

### Step 2: Install PostgreSQL

**Windows:**
```bash
# Download from https://www.postgresql.org/download/windows/
# Or use Chocolatey:
choco install postgresql
```

**macOS:**
```bash
brew install postgresql@15
brew services start postgresql@15
```

**Linux:**
```bash
sudo apt-get install postgresql-15
sudo systemctl start postgresql
```

### Step 3: Install MongoDB

**Windows:**
```bash
# Download from https://www.mongodb.com/try/download/community
# Or use Chocolatey:
choco install mongodb
```

**macOS:**
```bash
brew tap mongodb/brew
brew install mongodb-community@7.0
brew services start mongodb-community@7.0
```

**Linux:**
```bash
wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo systemctl start mongod
```

### Step 4: Install Redis

**Windows:**
```bash
# Download from https://github.com/microsoftarchive/redis/releases
# Or use WSL and install Linux version
```

**macOS:**
```bash
brew install redis
brew services start redis
```

**Linux:**
```bash
sudo apt-get install redis-server
sudo systemctl start redis
```

### Step 5: Install MinIO

```bash
# Download MinIO
wget https://dl.min.io/server/minio/release/linux-amd64/minio
chmod +x minio

# Start MinIO
./minio server /data --console-address ":9001"
```

### Step 6: Setup Backend

```bash
cd backend

# Install dependencies
npm install

# Create .env file
cp .env.example .env

# Update .env with your local database URLs
# DATABASE_URL=postgresql://rtc_user:password@localhost:5432/rtc_app
# MONGODB_URI=mongodb://admin:password@localhost:27017/rtc_app?authSource=admin
# REDIS_URL=redis://:password@localhost:6379

# Create PostgreSQL database and user
psql -U postgres
CREATE DATABASE rtc_app;
CREATE USER rtc_user WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE rtc_app TO rtc_user;
\q

# Run migrations
npm run migrate

# Start development server
npm run dev
```

## Verify Installation

### Check Services

```bash
# PostgreSQL
psql -U rtc_user -d rtc_app -c "SELECT version();"

# MongoDB
mongosh --eval "db.version()"

# Redis
redis-cli ping

# MinIO
curl http://localhost:9000/minio/health/live
```

### Test API Endpoints

```bash
# Health check
curl http://localhost:3001/health

# Should return: {"status":"ok","timestamp":"..."}
```

### Test WebSocket Connection

Use a WebSocket client or browser console:

```javascript
const socket = io('http://localhost:3001', {
  auth: { token: 'your_jwt_token' }
});

socket.on('connect', () => {
  console.log('Connected!');
});
```

## Common Issues

### Port Already in Use

```bash
# Check what's using the port
# Windows
netstat -ano | findstr :3001

# macOS/Linux
lsof -i :3001

# Kill the process or change the port in .env
```

### Database Connection Failed

```bash
# Check if PostgreSQL is running
# Windows
sc query postgresql-x64-15

# macOS/Linux
sudo systemctl status postgresql

# Check connection
psql -U rtc_user -d rtc_app
```

### MinIO Bucket Not Found

```bash
# Create bucket manually
docker-compose exec minio mc alias set myminio http://localhost:9000 admin password
docker-compose exec minio mc mb myminio/rtc-files
```

## Next Steps

1. Read [ARCHITECTURE.md](./ARCHITECTURE.md) to understand the system
2. Check [IMPLEMENTATION.md](./IMPLEMENTATION.md) for code examples
3. Review [DEPLOYMENT.md](./DEPLOYMENT.md) for production deployment
4. Build the frontend application
5. Configure TURN/STUN servers for production WebRTC

## Stopping Services

### Docker
```bash
# Stop all services
docker-compose down

# Stop and remove volumes (WARNING: deletes all data)
docker-compose down -v
```

### Local Development
```bash
# Stop backend
Ctrl+C in terminal

# Stop databases
brew services stop postgresql@15
brew services stop mongodb-community@7.0
brew services stop redis
```

## Getting Help

- Check logs: `docker-compose logs -f backend`
- Review documentation in `/docs`
- Create an issue on GitHub
- Check [Troubleshooting](#common-issues) section

## Development Tips

1. Use `npm run dev` for hot-reload during development
2. Check `docker-compose logs` for debugging
3. Use Postman or Thunder Client for API testing
4. Install MongoDB Compass for database inspection
5. Use Redis Commander for Redis debugging
