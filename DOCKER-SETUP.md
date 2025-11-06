# USWDS Django Template - Docker Setup

This document describes how to run the USWDS Django Template using Docker Compose with Microsoft SQL Server and Redis.

## Architecture

The Docker Compose setup includes three main services:

1. **Django Application** (`django`) - Your main web application
2. **Microsoft SQL Server** (`mssql`) - Database server
3. **Redis** (`redis`) - Cache and session store

## Prerequisites

- Docker Engine 20.10+
- Docker Compose V2
- At least 4GB RAM available for Docker

## Quick Start

1. **Copy the environment configuration:**
   ```bash
   cp sample.env.toml .env.toml
   ```

2. **Update the configuration** in `.env.toml` (the Docker settings are already configured)

3. **Start the services:**
   ```bash
   ./docker-manage.sh start
   ```

   Or manually:
   ```bash
   docker compose up --build
   ```

4. **Access the application:**
   - Django application: http://localhost:8000
   - Database: localhost:1433 (SA/YourStrong@Password123)
   - Redis: localhost:6379

## Configuration

### Environment Variables

The `.env.toml` file contains all configuration. Key settings for Docker:

```toml
[dev]
# Application
HOST = "0.0.0.0"
PORT = 8000

# SQL Server Database
DB_HOST = "mssql"
DB_PORT = 1433
DB_NAME = "uswds_db"
DB_USER = "SA"
DB_PASS = "YourStrong@Password123"

# Redis Cache
REDIS_HOST = "redis"
REDIS_PORT = 6379
REDIS_DB = 0
```

### Database Configuration

The Django application automatically detects SQL Server configuration and uses it when available. If database credentials are not provided, it falls back to SQLite.

### Security Notes

**⚠️ IMPORTANT:** The default SQL Server password (`YourStrong@Password123`) is for development only. In production:

1. Change the SA password in:
   - `docker-compose.yml` (SA_PASSWORD environment variable)
   - `.env.toml` (DB_PASS field)

2. Use Docker secrets for sensitive data
3. Enable SQL Server authentication and create application-specific users

## Management Scripts

The `docker-manage.sh` script provides convenient commands:

### Basic Operations
```bash
./docker-manage.sh start      # Start all services
./docker-manage.sh stop       # Stop all services
./docker-manage.sh restart    # Restart all services
./docker-manage.sh status     # Show service status
```

### Logging
```bash
./docker-manage.sh logs              # View all logs
./docker-manage.sh logs django       # View Django logs only
./docker-manage.sh logs mssql        # View SQL Server logs
```

### Django Management
```bash
./docker-manage.sh manage migrate              # Run migrations
./docker-manage.sh manage createsuperuser      # Create admin user
./docker-manage.sh manage collectstatic        # Collect static files
./docker-manage.sh manage shell                # Django shell
```

### Database Access
```bash
./docker-manage.sh shell-db        # Connect to SQL Server
./docker-manage.sh shell-redis     # Connect to Redis CLI
```

### Cleanup
```bash
./docker-manage.sh clean           # Remove containers, volumes, images
```

## Manual Docker Commands

If you prefer using Docker Compose directly:

### Start services
```bash
# Start database and Redis first
docker compose up -d mssql redis

# Wait for services to be ready, then start Django
docker compose up django
```

### Run Django commands
```bash
docker compose exec django python server/manage.py migrate
docker compose exec django python server/manage.py createsuperuser
```

### Access database
```bash
docker compose exec mssql /opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P 'YourStrong@Password123' -C
```

### View logs
```bash
docker compose logs -f django
```

## Development Workflow

1. **Make code changes** - Files are mounted as volumes, so changes are reflected immediately
2. **Django auto-reload** - The development server automatically restarts on code changes
3. **Frontend assets** - Run frontend build commands inside the container:
   ```bash
   docker compose exec django npm run build
   ```

## Data Persistence

- **SQL Server data**: Stored in `mssql_data` Docker volume
- **Redis data**: Stored in `redis_data` Docker volume
- **Application logs**: Stored in `.logs/` directory (mounted volume)

## Networking

Services communicate through the `uswds-network` Docker network:

- Django can reach SQL Server at `mssql:1433`
- Django can reach Redis at `redis:6379`
- External access via exposed ports (8000, 1433, 6379)

## Troubleshooting

### Database Connection Issues
```bash
# Check if SQL Server is ready
docker compose exec mssql /opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P 'YourStrong@Password123' -C -Q 'SELECT 1'

# View SQL Server logs
docker compose logs mssql
```

### Redis Connection Issues
```bash
# Check Redis connectivity
docker compose exec redis redis-cli ping

# View Redis logs
docker compose logs redis
```

### Django Issues
```bash
# View Django logs
docker compose logs django

# Access Django shell
docker compose exec django python server/manage.py shell

# Check database migrations
docker compose exec django python server/manage.py showmigrations
```

### Performance Issues
- Ensure Docker has sufficient RAM allocated (4GB minimum)
- Check disk space for Docker volumes
- Monitor container resource usage: `docker stats`

## Production Considerations

For production deployment:

1. **Security:**
   - Change all default passwords
   - Use Docker secrets for sensitive data
   - Enable SQL Server encryption
   - Configure proper firewall rules

2. **Performance:**
   - Use production-grade SQL Server edition
   - Configure Redis persistence settings
   - Optimize Django settings (DEBUG=False, etc.)
   - Use a reverse proxy (nginx, Traefik)

3. **Monitoring:**
   - Add health checks for all services
   - Configure log aggregation
   - Set up monitoring and alerting

4. **Backup:**
   - Regular SQL Server database backups
   - Redis data persistence configuration
   - Application code and configuration backups

## Dependencies

The Docker setup uses these additional Python packages:

- `django-mssql-backend` - SQL Server database backend
- `django-redis` - Redis cache backend
- `redis` - Redis client library

These are installed automatically via `requirements-docker.txt`.