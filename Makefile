# Makefile for USWDS Django Template
# Run 'make help' to see all available commands

# Help
.PHONY: help

# Build & Compilation
.PHONY: build

# Development - Local (without Docker)
.PHONY: dev-server
.PHONY: dev-watch-scss

# Django Commands
.PHONY: django-check
.PHONY: django-collectstatic
.PHONY: django-createapp
.PHONY: django-makemigrations
.PHONY: django-migrate
.PHONY: django-shell
.PHONY: django-showmigrations
.PHONY: django-superuser

# Docker - Development Profile
.PHONY: docker-dev-build
.PHONY: docker-dev-down
.PHONY: docker-dev-down-volumes
.PHONY: docker-dev-logs
.PHONY: docker-dev-rebuild
.PHONY: docker-dev-restart
.PHONY: docker-dev-restart-all
.PHONY: docker-dev-up

# Docker - Production Profile
.PHONY: docker-prod-build
.PHONY: docker-prod-down
.PHONY: docker-prod-down-volumes
.PHONY: docker-prod-logs
.PHONY: docker-prod-rebuild
.PHONY: docker-prod-restart
.PHONY: docker-prod-restart-all
.PHONY: docker-prod-up

# Docker - Utilities
.PHONY: docker-exec-dev
.PHONY: docker-exec-prod
.PHONY: docker-ps
.PHONY: docker-prune
.PHONY: docker-logs

# Environment Setup
.PHONY: env-setup

# Installation & Setup
.PHONY: install
.PHONY: install-node
.PHONY: install-python
.PHONY: install-dev
.PHONY: setup

# Python Environment
.PHONY: python-add-pip
.PHONY: python-add-uv

# Code Quality
.PHONY: lint
.PHONY: format
.PHONY: lint-fix
.PHONY: quality

# Testing & Quality
.PHONY: test-accessibility
.PHONY: test-django
.PHONY: test-django-coverage

# Cleanup
.PHONY: clean
.PHONY: clean-python
.PHONY: clean-node
.PHONY: clean-venv
.PHONY: clean-all

# Default target - shows help
.DEFAULT_GOAL := help

# Helpful recipe - shows available commands
help:
	@echo "Available targets:"
	@echo "  Build & Compilation:"
	@echo "    build                   - Build styles (SCSS)"
	@echo ""
	@echo "  Development - Local (without Docker):"
	@echo "    dev-server              - Run Django development server (local Python)"
	@echo "    dev-watch-scss          - Watch and compile SCSS files on change"
	@echo ""
	@echo "  Django Commands:"
	@echo "    django-check            - Run Django check for deployment issues"
	@echo "    django-collectstatic    - Collect static files for production"
	@echo "    django-createapp        - Create a new Django app (use: make django-createapp NAME=myapp)"
	@echo "    django-makemigrations   - Create database migrations"
	@echo "    django-migrate          - Apply database migrations"
	@echo "    django-shell            - Open Django shell"
	@echo "    django-showmigrations   - Show all migrations and their status"
	@echo "    django-superuser        - Create a Django superuser"
	@echo ""
	@echo "  Docker - Development Profile:"
	@echo "    docker-dev-build        - Build development Docker images"
	@echo "    docker-dev-down         - Stop and remove development containers"
	@echo "    docker-dev-down-volumes - Stop and remove development containers with volumes"
	@echo "    docker-dev-logs         - View development container logs (use: make docker-dev-logs SERVICE=django)"
	@echo "    docker-dev-rebuild      - Rebuild and start development environment (foreground)"
	@echo "    docker-dev-restart      - Restart a single service (use: make docker-dev-restart SERVICE=django)"
	@echo "    docker-dev-restart-all  - Restart all development containers"
	@echo "    docker-dev-up           - Start development environment in detached mode"
	@echo ""
	@echo "  Docker - Production Profile:"
	@echo "    docker-prod-build       - Build production Docker images"
	@echo "    docker-prod-down        - Stop and remove production containers"
	@echo "    docker-prod-down-volumes - Stop and remove production containers with volumes"
	@echo "    docker-prod-logs        - View production container logs (use: make docker-prod-logs SERVICE=django)"
	@echo "    docker-prod-rebuild     - Rebuild and start production environment (foreground)"
	@echo "    docker-prod-restart     - Restart a single service (use: make docker-prod-restart SERVICE=django)"
	@echo "    docker-prod-restart-all - Restart all production containers"
	@echo "    docker-prod-up          - Start production environment in detached mode"
	@echo ""
	@echo "  Docker - Utilities:"
	@echo "    docker-exec-dev         - Execute command in development Django container (use: make docker-exec-dev CMD=bash)"
	@echo "    docker-exec-prod        - Execute command in production Django container (use: make docker-exec-prod CMD=bash)"
	@echo "    docker-ps               - Show Docker container status"
	@echo "    docker-prune            - Prune unused Docker resources"
	@echo "    docker-logs             - View all Docker Compose logs"
	@echo ""
	@echo "  Environment Setup:"
	@echo "    env-setup               - Copy sample.env to .env"
	@echo ""
	@echo "  Installation & Setup:"
	@echo "    install                 - Install all dependencies (Python + Node.js)"
	@echo "    install-node            - Install Node.js dependencies"
	@echo "    install-python          - Install Python dependencies in virtual environment"
	@echo "    install-dev             - Install Python dev dependencies (Ruff, coverage, etc.)"
	@echo "    setup                   - Complete initial setup (install deps + setup env + build)"
	@echo ""
	@echo "  Python Dependencies:"
	@echo "    python-add-pip          - Add a Python package using pip and update requirements.txt (use: make python-add-pip PACKAGE=django)"
	@echo "    python-add-uv           - Add a Python package using uv and update requirements.txt (use: make python-add-uv PACKAGE=django)"
	@echo ""
	@echo "  Code Quality:"
	@echo "    lint                    - Run linter (Ruff) on Python code"
	@echo "    format                  - Format Python code with Ruff"
	@echo "    lint-fix                - Auto-fix linting and formatting issues (includes import sorting)"
	@echo "    quality                 - Run all quality checks (lint + format check)"
	@echo ""
	@echo "  Testing & Quality:"
	@echo "    test-accessibility      - Run accessibility checker (use: make test-accessibility URL=http://localhost:8000)"
	@echo "    test-django             - Run Django tests"
	@echo "    test-django-coverage    - Run Django tests with coverage"
	@echo ""
	@echo "  Cleanup:"
	@echo "    clean                   - Clean artifacts and caches for Python and Node.js"
	@echo "    clean-python            - Clean all build artifacts and caches"
	@echo "    clean-node              - Clean Node.js artifacts"
	@echo "    clean-venv              - Clean Python virtual environment"
	@echo "    clean-all               - Clean everything (artifacts, dependencies, Docker)"

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
# Usage: make django-createapp NAME=myapp
django-createapp:
ifndef NAME
	@echo "ERROR: NAME is required. Usage: make django-createapp NAME=myapp"
	@exit 1
endif
	.venv/bin/python server/manage.py startapp $(NAME)

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
# Usage: make docker-dev-logs SERVICE=django (or leave SERVICE empty for all)
docker-dev-logs:
	docker compose --profile dev logs -f $(SERVICE)

# Rebuild and start development environment (foreground)
docker-dev-rebuild:
	docker compose --profile dev up --build

# Restart a single development service
# Usage: make docker-dev-restart SERVICE=django
docker-dev-restart:
ifndef SERVICE
	@echo "ERROR: SERVICE is required. Usage: make docker-dev-restart SERVICE=django"
	@exit 1
endif
	docker compose --profile dev restart $(SERVICE)

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

# View production container logs (specify service: django, mssql, redis, or leave empty for all)
# Usage: make docker-prod-logs SERVICE=django (or leave SERVICE empty for all)
docker-prod-logs:
	docker compose --profile prod logs -f $(SERVICE)

# Rebuild and start production environment (foreground)
docker-prod-rebuild:
	docker compose --profile prod up --build

# Restart a single production service
# Usage: make docker-prod-restart SERVICE=django
docker-prod-restart:
ifndef SERVICE
	@echo "ERROR: SERVICE is required. Usage: make docker-prod-restart SERVICE=django"
	@exit 1
endif
	docker compose --profile prod restart $(SERVICE)

# Restart all production containers
docker-prod-restart-all:
	docker compose --profile prod restart

# Start production environment in detached mode
docker-prod-up:
	docker compose --profile prod up -d

# =============================================================================
# Docker - Utilities
# =============================================================================

# Execute command in development Django container
# Usage: make docker-exec-dev CMD=bash
docker-exec-dev:
ifndef CMD
	@echo "ERROR: CMD is required. Usage: make docker-exec-dev CMD=bash"
	@exit 1
endif
	docker exec -it uswds-django-dev $(CMD)

# Execute command in production Django container
# Usage: make docker-exec-prod CMD=bash
docker-exec-prod:
ifndef CMD
	@echo "ERROR: CMD is required. Usage: make docker-exec-prod CMD=bash"
	@exit 1
endif
	docker exec -it uswds-django-prod $(CMD)

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
	@echo "DONE: Created .env file from sample.env"
	@echo "NOTE: Remember to edit .env with your configuration values"

# =============================================================================
# Installation & Setup
# =============================================================================

# Install all dependencies (Python + Node.js)
install: install-python install-node install-dev

# Install Node.js dependencies
install-node:
	npm install

# Install Python dependencies in virtual environment
install-python:
	python3 -m venv .venv
	.venv/bin/pip install --upgrade pip
	.venv/bin/pip install -r requirements.txt

# Install Python dev dependencies (Ruff, coverage, etc.)
install-dev:
	.venv/bin/pip install ruff coverage

# Complete initial setup (install deps + setup env + build)
setup: install env-setup build
	@echo "Setup complete! Edit .env and run 'make docker-dev-up' to start"

# =============================================================================
# Python Environment
# =============================================================================

# Add a Python package using pip and update requirements.txt
# Usage: make python-add-pip PACKAGE=django
python-add-pip:
ifndef PACKAGE
	@echo "Error: PACKAGE is required. Usage: make python-add-pip PACKAGE=django"
	@exit 1
endif
	.venv/bin/pip install $(PACKAGE)
	.venv/bin/pip freeze > requirements.txt
	@echo "DONE: Added $(PACKAGE) and updated requirements.txt"

# Add a Python package using uv and update requirements.txt
# Usage: make python-add-uv PACKAGE=django
python-add-uv:
ifndef PACKAGE
	@echo "Error: PACKAGE is required. Usage: make python-add-uv PACKAGE=django"
	@exit 1
endif
	uv pip install $(PACKAGE)
	uv pip freeze > requirements.txt
	@echo "DONE: Added $(PACKAGE) and updated requirements.txt"

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
# Usage: make test-accessibility URL=http://localhost:3000 (or leave URL empty for default)
test-accessibility:
ifndef URL
	$(eval URL := http://localhost:8000)
endif
	npx achecker $(URL)

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

# Clean artifacts and caches for Python and Node.js
clean: clean-python clean-node clean-venv

# Clean all build artifacts and caches
clean-python:
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	rm -rf .coverage htmlcov/
	@echo "DONE: Cleaned Python artifacts"

# Clean Node.js artifacts
clean-node:
	rm -rf node_modules/
	@echo "✓ Cleaned Node.js artifacts"

# Clean Python virtual environment
clean-venv:
	rm -rf .venv/
	@echo "DONE: Cleaned Python virtual environment"

# Clean everything (artifacts, dependencies, Docker)
clean-all: clean docker-dev-down-volumes docker-prod-down-volumes
	@echo "DONE: Complete cleanup finished"
