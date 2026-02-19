#!/bin/bash

echo "========================================="
echo "Initializing Database"
echo "========================================="
echo ""

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
sleep 10

# Run the SQL initialization script
echo "Creating database tables..."
docker-compose exec -T postgres psql -U rtc_user -d rtc_app -f /docker-entrypoint-initdb.d/init.sql

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Database initialized successfully!"
    echo ""
else
    echo ""
    echo "❌ Database initialization failed!"
    echo "Please check the logs: docker-compose logs postgres"
    echo ""
    exit 1
fi

echo "========================================="
echo "Database is ready!"
echo "========================================="
