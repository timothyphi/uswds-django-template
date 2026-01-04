# Justfile for USWDS Django Template
# Run 'just --list' to see all available commands

# Helpful recipe - shows available commands
help:
    @just --list

# =============================================================================
# Build & Compilation
# =============================================================================

# Build all frontend assets (SCSS, TypeScript)
build:
    npx gulp compile

# =============================================================================
# Development - Local (without Docker)
# =============================================================================

# Run Django development server (local Python)
dev-server:
    .venv/bin/python server/manage.py runserver

# Watch and compile SCSS files on change
dev-watch-scss:
    npx gulp watch

# =============================================================================
# Django Commands
# =============================================================================

# Run Django check for deployment issues
django-check:
    .venv/bin/python server/manage.py check --deploy

# Collect static files for production
django-collectstatic:
    .venv/bin/python server/manage.py collectstatic --noinput

# Create a new Django app
django-createapp name:
    .venv/bin/python server/manage.py startapp {{name}}

# Create database migrations
django-makemigrations:
    .venv/bin/python server/manage.py makemigrations

# Apply database migrations
django-migrate:
    .venv/bin/python server/manage.py migrate

# Open Django shell
django-shell:
    .venv/bin/python server/manage.py shell

# Show all migrations and their status
django-showmigrations:
    .venv/bin/python server/manage.py showmigrations

# Create a Django superuser
django-superuser:
    .venv/bin/python server/manage.py createsuperuser

# =============================================================================
# Docker - Development Profile
# =============================================================================

# Build development Docker images
docker-dev-build:
    docker compose --profile dev build

# Stop and remove development containers
docker-dev-down:
    docker compose --profile dev down

# Stop and remove development containers with volumes
docker-dev-down-volumes:
    docker compose --profile dev down -v

# View development container logs (specify service: django, mssql, redis, or leave empty for all)
docker-dev-logs service="":
    docker compose --profile dev logs -f {{service}}

# Rebuild and start development environment
docker-dev-rebuild:
    docker compose --profile dev up --build

# Restart development containers
docker-dev-restart:
    docker compose --profile dev restart

# Start development environment in detached mode
docker-dev-up:
    docker compose --profile dev up -d

# =============================================================================
# Docker - Production Profile
# =============================================================================

# Build production Docker images
docker-prod-build:
    docker compose --profile prod build

# Stop and remove production containers
docker-prod-down:
    docker compose --profile prod down

# Stop and remove production containers with volumes
docker-prod-down-volumes:
    docker compose --profile prod down -v

# View production container logs (specify service: django, mssql, redis, or leave empty for all)
docker-prod-logs service="":
    docker compose --profile prod logs -f {{service}}

# Rebuild and start production environment
docker-prod-rebuild:
    docker compose --profile prod up --build

# Restart production containers
docker-prod-restart:
    docker compose --profile prod restart

# Start production environment in detached mode
docker-prod-up:
    docker compose --profile prod up -d

# =============================================================================
# Docker - Utilities
# =============================================================================

# Execute command in development Django container
docker-exec-dev cmd:
    docker exec -it uswds-django-dev {{cmd}}

# Execute command in production Django container
docker-exec-prod cmd:
    docker exec -it uswds-django-prod {{cmd}}

# Show Docker container status
docker-ps:
    docker compose ps

# Prune unused Docker resources
docker-prune:
    docker system prune -af --volumes

# View all Docker Compose logs
docker-logs:
    docker compose logs -f

# =============================================================================
# Environment Setup
# =============================================================================

# Copy sample.env to .env
env-setup:
    cp sample.env .env
    @echo "✓ Created .env file from sample.env"
    @echo "⚠ Remember to edit .env with your configuration values"

# =============================================================================
# Installation & Setup
# =============================================================================

# Install all dependencies (Python + Node.js)
install: install-python install-node

# Install Node.js dependencies
install-node:
    npm install

# Install Python dependencies in virtual environment
install-python:
    python3 -m venv .venv
    .venv/bin/pip install --upgrade pip
    .venv/bin/pip install -r requirements.txt

# Install Python dev dependencies (Ruff, etc.)
install-dev:
    .venv/bin/pip install ruff

# Complete initial setup (install deps + setup env + build)
setup: install env-setup build
    @echo "✓ Setup complete! Edit .env and run 'just docker-dev-up' to start"

# =============================================================================
# Python Environment
# =============================================================================

# Add a Python package using pip and update requirements.txt
python-add-pip package:
    .venv/bin/pip install {{package}}
    just python-freeze
    @echo "✓ Added {{package}} and updated requirements.txt"

# Add a Python package using uv and update requirements.txt
python-add-uv package:
    uv pip install {{package}}
    just python-freeze-uv
    @echo "✓ Added {{package}} and updated requirements.txt"

# Freeze Python dependencies to requirements.txt
python-freeze:
    .venv/bin/pip freeze > requirements.txt

# Freeze Python dependencies using uv
python-freeze-uv:
    uv pip freeze > requirements.txt

# =============================================================================
# Code Quality
# =============================================================================

# Run linter (Ruff) on Python code
lint:
    .venv/bin/ruff check server/

# Format Python code with Ruff
format:
    .venv/bin/ruff format server/

# Auto-fix linting and formatting issues (includes import sorting)
lint-fix:
    .venv/bin/ruff check --fix server/
    .venv/bin/ruff format server/

# Run all quality checks (lint + format check)
quality:
    @echo "Running linting checks..."
    .venv/bin/ruff check server/
    @echo ""
    @echo "Checking code formatting..."
    .venv/bin/ruff format --check server/
    @echo ""
    @echo "✓ All quality checks passed!"

# =============================================================================
# Testing & Quality
# =============================================================================

# Run accessibility checker on URL (default: localhost:8000)
test-accessibility url="http://localhost:8000":
    npx achecker {{url}}

# Run Django tests
test-django:
    .venv/bin/python server/manage.py test

# Run Django tests with coverage
test-django-coverage:
    .venv/bin/coverage run --source='.' server/manage.py test
    .venv/bin/coverage report
    .venv/bin/coverage html

# =============================================================================
# Cleanup
# =============================================================================

# Cleans artifacts and caches for python and node
clean: clean-python clean-node clean-venv

# Clean all build artifacts and caches
clean-python:
    find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
    find . -type f -name "*.pyc" -delete
    find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
    find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
    rm -rf .coverage htmlcov/
    @echo "✓ Cleaned Python artifacts"


# Clean Node.js artifacts
clean-node:
    rm -rf node_modules/
    @echo "✓ Cleaned Node.js artifacts"

# Clean Python virtual environment
clean-venv:
    rm -rf .venv/
    @echo "✓ Cleaned Python virtual environment"

# Clean everything (artifacts, dependencies, Docker)
clean-all: clean clean-node clean-venv docker-dev-down-volumes docker-prod-down-volumes
    @echo "✓ Complete cleanup finished"
