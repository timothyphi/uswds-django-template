# justfile for USWDS Django Template
# Run 'just --list' to see all available commands

# =============================================================================
# Platform detection
# =============================================================================

python   := if os_family() == "windows" { ".venv/Scripts/python" } else { ".venv/bin/python" }
venv_bin := if os_family() == "windows" { ".venv/Scripts" } else { ".venv/bin" }

# =============================================================================
# Build & Compilation
# =============================================================================


# Build styles (SCSS)
build:
    npx gulp compile


# =============================================================================
# Development - Local (without Docker)
# =============================================================================


# Run Django development server (local Python)
dev-server:
    {{python}} server/manage.py runserver


# Watch and compile SCSS files on change
dev-watch-scss:
    npx gulp watch


# =============================================================================
# Django Commands
# =============================================================================


# Run Django check for deployment issues
django-check:
    {{python}} server/manage.py check --deploy


# Collect static files for production
django-collectstatic:
    {{python}} server/manage.py collectstatic --noinput


# Create a new Django app (e.g. just django-createapp myapp)
django-createapp name:
    {{python}} server/manage.py startapp {{name}}


# Create database migrations
django-makemigrations:
    {{python}} server/manage.py makemigrations


# Apply database migrations
django-migrate:
    {{python}} server/manage.py migrate


# Open Django shell
django-shell:
    {{python}} server/manage.py shell


# Show all migrations and their status
django-showmigrations:
    {{python}} server/manage.py showmigrations


# Create a Django superuser
django-superuser:
    {{python}} server/manage.py createsuperuser


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


# View development container logs (optionally specify a service: django, mssql, redis)
docker-dev-logs service="":
    docker compose --profile dev logs -f {{service}}


# Rebuild and start development environment (foreground)
docker-dev-rebuild:
    docker compose --profile dev up --build


# Restart a single development service (e.g. just docker-dev-restart django)
docker-dev-restart service:
    docker compose --profile dev restart {{service}}


# Restart all development containers
docker-dev-restart-all:
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


# View production container logs (optionally specify a service: django, mssql, redis)
docker-prod-logs service="":
    docker compose --profile prod logs -f {{service}}


# Rebuild and start production environment (foreground)
docker-prod-rebuild:
    docker compose --profile prod up --build


# Restart a single production service (e.g. just docker-prod-restart django)
docker-prod-restart service:
    docker compose --profile prod restart {{service}}


# Restart all production containers
docker-prod-restart-all:
    docker compose --profile prod restart


# Start production environment in detached mode
docker-prod-up:
    docker compose --profile prod up -d


# =============================================================================
# Docker - Utilities
# =============================================================================


# Execute a command in the development Django container (e.g. just docker-exec-dev bash)
docker-exec-dev cmd:
    docker exec -it uswds-django-dev {{cmd}}


# Execute a command in the production Django container (e.g. just docker-exec-prod bash)
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
    {{ if os_family() == "windows" { "copy sample.env .env" } else { "cp sample.env .env" } }}
    @echo "DONE: Created .env file from sample.env"
    @echo "NOTE: Remember to edit .env with your configuration values"


# =============================================================================
# Installation & Setup
# =============================================================================


# Install all dependencies (Python + Node.js)
install: install-python install-node


# Install Node.js dependencies
install-node:
    npm install


# Create virtual environment and install Python dependencies using system python and pip
install-python:
    python -m venv .venv
    {{venv_bin}}/pip install -r requirements-dev.txt


# Create virtual environment and install Python dependencies using system uv
install-python-uv:
    uv sync


# Complete initial setup (install deps + setup env + build)
setup: install env-setup build
    @echo "Setup complete! Edit .env and run 'just docker-dev-up' to start"


# =============================================================================
# Python Dependencies
# =============================================================================


# Add a production Python package and update requirements files (e.g. just python-add django)
python-add-prod package:
    {{venv_bin}}/uv add {{package}}
    just sync-requirements
    @echo "DONE: Added {{package}} and updated requirements files"


# Add a development Python package and update requirements files (e.g. just python-add-dev ruff)
python-add-dev package:
    {{venv_bin}}/uv add --optional dev {{package}}
    just sync-requirements
    @echo "DONE: Added {{package}} and updated requirements files"


# Remove a production Python package and update requirements files (e.g. just python-remove-prod django)
python-remove-prod package:
    {{venv_bin}}/uv remove {{package}}
    just sync-requirements
    @echo "DONE: Removed {{package}} and updated requirements files"


# Remove a development Python package and update requirements files (e.g. just python-remove-dev ruff)
python-remove-dev package:
    {{venv_bin}}/uv remove --optional dev {{package}}
    just sync-requirements
    @echo "DONE: Removed {{package}} and updated requirements files"


# Export uv lockfile to requirements.txt and requirements-dev.txt
sync-requirements:
    {{venv_bin}}/uv export --no-dev --output-file requirements.txt
    {{venv_bin}}/uv export --extra dev --output-file requirements-dev.txt
    @echo "DONE: Regenerated requirements.txt and requirements-dev.txt"


# =============================================================================
# Code Quality
# =============================================================================


# Run linter (Ruff) on Python code
lint:
    {{venv_bin}}/ruff check server/ scripts/


# Format Python code with Ruff
format:
    {{venv_bin}}/ruff format server/ scripts/


# Auto-fix linting and formatting issues (includes import sorting)
lint-fix:
    {{venv_bin}}/ruff check --fix server/ scripts/
    {{venv_bin}}/ruff format server/ scripts/


# Run all quality checks (lint + format check)
quality:
    @echo "Running linting checks..."
    {{venv_bin}}/ruff check server/ scripts/
    @echo ""
    @echo "Checking code formatting..."
    {{venv_bin}}/ruff format --check server/ scripts/
    @echo ""
    @echo "DONE: All quality checks passed!"


# =============================================================================
# Testing
# =============================================================================


# Run accessibility checker (optionally specify a URL, default: http://localhost:8000)
test-accessibility url="http://localhost:8000":
    npx achecker {{url}}


# Run Django tests
test-django:
    {{python}} server/manage.py test


# Run Django tests with coverage
test-django-coverage:
    {{venv_bin}}/coverage run --source='.' server/manage.py test
    {{venv_bin}}/coverage report
    {{venv_bin}}/coverage html


# =============================================================================
# Cleanup
# =============================================================================


# Clean artifacts and caches for Python and Node.js
clean: clean-python clean-node clean-venv


# Clean all Python build artifacts and caches
clean-python:
    {{python}} scripts/clean.py
    @echo "DONE: Cleaned Python artifacts"


# Clean Node.js artifacts
clean-node:
    {{python}} scripts/clean.py --node
    @echo "DONE: Cleaned Node.js artifacts"


# Clean Python virtual environment
clean-venv:
    {{python}} scripts/clean.py --venv
    @echo "DONE: Cleaned Python virtual environment"


# Clean everything (artifacts, dependencies, Docker)
clean-all: clean docker-dev-down-volumes docker-prod-down-volumes
    @echo "DONE: Complete cleanup finished"

