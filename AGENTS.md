# Agent Guidelines for USWDS Django Template

This document provides coding agents with essential information about this project's structure, commands, and conventions.

## Project Overview

Django 5.2 backend with USWDS 3.12 design system, SASS stylesheets, and TypeScript support. Uses django-components for reusable UI components, MSSQL/SQLite database, and Redis cache.

**Python Version:** 3.11+  
**Key Dependencies:** Django 5.2.1, django-components 0.143.2, Ruff 0.14.10

**IMPORTANT: This project runs exclusively through Docker.** All development, testing, and production deployments use Docker containers. The Makefile provides Docker commands prefixed with `docker-dev-` for development and `docker-prod-` for production.

## Directory Structure

```
server/                      # Django backend
  django_project/           # Project settings and config
  core/                     # Core Django app
  manage.py                 # Django management script
components/                 # Reusable django-components
  {component}/              # Each component has .py, .html, .css, .js
templates/                  # Django HTML templates
styles/                     # SCSS source files
  abstracts/                # Variables, mixins, functions
  base/                     # Reset, typography, root styles
  components/               # Component-specific styles
  layouts/                  # Page-specific layouts
  utilities/                # Utility classes
  vendors/                  # USWDS theme configuration
public/                     # Static assets (output)
  css/                      # Compiled CSS (generated)
  fonts/                    # USWDS fonts (generated)
  img/                      # USWDS images (generated)
  uswds/js/                 # USWDS JavaScript (generated)
```

## Build Commands

### Docker Development (Primary Method)
```bash
# Start development environment
make docker-dev-up          # Start all services (Django, MSSQL, Redis) in detached mode
make docker-dev-rebuild     # Rebuild and start in foreground (useful for debugging)
make docker-dev-down        # Stop and remove containers
make docker-dev-down-volumes # Stop and remove containers with volumes (clean slate)

# View logs
make docker-dev-logs             # View all service logs
make docker-dev-logs SERVICE=django   # View specific service logs
# Available services: django, mssql, redis

# Container management
make docker-dev-restart-all           # Restart all containers
make docker-dev-restart SERVICE=django # Restart specific service
make docker-ps                        # Show container status

# Execute commands in containers
make docker-exec-dev CMD="bash"                          # Open bash shell
make docker-exec-dev CMD="python server/manage.py shell" # Django shell
make docker-exec-dev CMD="python server/manage.py migrate" # Run migrations
make docker-exec-dev CMD="python server/manage.py test"   # Run all tests
make docker-exec-dev CMD="python server/manage.py test core.tests.TestClass" # Single test
```

### Docker Production
```bash
make docker-prod-up         # Start production environment (Apache on port 8080)
make docker-prod-rebuild    # Rebuild and start production
make docker-prod-down       # Stop production containers
make docker-prod-logs       # View production logs
make docker-exec-prod CMD="bash" # Execute commands in production container
```

### Build & Compilation (Run locally or in container)
```bash
make build                  # Compile SCSS to CSS
npx gulp compile            # Direct gulp command
npx gulp init               # First-time setup (copy USWDS assets)
```

### Testing (Run in Docker container)
```bash
# Django tests - run inside Docker container
make docker-exec-dev CMD="python server/manage.py test"
make docker-exec-dev CMD="python server/manage.py test core"
make docker-exec-dev CMD="python server/manage.py test core.tests.TestClass"
make docker-exec-dev CMD="python server/manage.py test core.tests.TestClass.test_method"

# With coverage
make docker-exec-dev CMD="coverage run --source='.' server/manage.py test && coverage report"

# Accessibility testing (run after starting Docker environment)
make test-accessibility URL=http://localhost:8000
```

### Linting & Formatting (Run locally if .venv exists)
```bash
make lint                   # Check Python code with Ruff
make format                 # Format Python code with Ruff
make lint-fix               # Auto-fix linting + formatting
make quality                # Run all quality checks
```

## Code Style Guidelines

### Python (Ruff Configuration)

**General:**
- Line length: 100 characters
- Indentation: 4 spaces
- Target: Python 3.11+
- Quote style: Double quotes

**Import Ordering (isort):**
```python
# 1. Future imports
from __future__ import annotations

# 2. Standard library
import os
from pathlib import Path

# 3. Django imports
from django.conf import settings
from django.contrib.auth import get_user_model

# 4. Third-party imports
from dotenv import load_dotenv
from django_components import Component, register

# 5. First-party (django_project)
from django_project.utils import helper

# 6. Local/relative imports
from .models import MyModel
```

**Type Hints:**
- Use type hints for function parameters and return values
- Use modern syntax: `list[str]` not `List[str]` (Python 3.11+)
- Use `str | None` not `Optional[str]` (Python 3.10+)

**Naming Conventions:**
- Classes: `PascalCase`
- Functions/variables: `snake_case`
- Constants: `UPPER_SNAKE_CASE`
- Private methods: `_leading_underscore`

**Django-Specific:**
- Component classes inherit from `Component` and use `@register("name")` decorator
- Use `get_context_data()` method for component context
- Management commands inherit from `BaseCommand`

**Error Handling:**
```python
# Prefer specific exceptions
try:
    value = int(os.getenv("PORT", "8000"))
except ValueError:
    value = 8000

# Use logging for errors
import logging
logger = logging.getLogger(__name__)
logger.error(f"Error message: {e}")
```

**Docstrings:**
```python
def function_name(param: str) -> bool:
    """Brief one-line description.
    
    Longer description if needed.
    """
```

### SCSS

**Structure:**
- Use 7-1 pattern: abstracts, base, components, layouts, utilities, vendors
- Import order: abstracts → vendors → base → components → layouts → utilities

**Naming:**
- Use USWDS naming conventions where applicable
- Component classes: `.component-name`
- Modifiers: `.component-name--modifier`
- Utilities: `.u-utility-name`

**Best Practices:**
- Use USWDS design tokens from `vendors/uswds/_uswds-theme.scss`
- Avoid inline styles; create utility classes instead
- Use mixins from `abstracts/_mixins.scss`

### Django Components

**Component Structure:**
```
components/
  my_component/
    my_component.py       # Component class
    my_component.html     # Template
    my_component.css      # Styles (optional)
    my_component.js       # JavaScript (optional)
```

**Component Registration:**
```python
from django_components import Component, register

@register("my_component")
class MyComponent(Component):
    """Brief description of component."""
    
    template_name = "my_component/my_component.html"
    
    def get_context_data(self, param1, param2=None):
        return {
            "param1": param1,
            "param2": param2,
        }
```

### HTML Templates

- Use USWDS component markup where possible
- Use django-components for reusable UI elements
- Template syntax: `{% component "name" param=value %}`

**Custom CSS in Templates:**
For page-specific or one-off layout styles, use the `extra_css` block in templates:
```html
{% extends "layout.html" %}

{% block extra_css %}
<style>
  .custom-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 2rem;
  }
</style>
{% endblock %}

{% block content %}
  <div class="custom-grid">
    <!-- content -->
  </div>
{% endblock %}
```
This approach keeps custom layout styles near relevant code and reduces reliance on SCSS build process.

## Django Management Commands

```bash
# Database
make django-migrate                # Apply migrations
make django-makemigrations        # Create migrations
make django-showmigrations        # Show migration status

# Admin
make django-superuser             # Create superuser
.venv/bin/python server/manage.py create_superuser_if_none_exists  # Auto-create

# Development
make django-shell                 # Open Django shell
make django-check                 # Check for deployment issues
make django-collectstatic         # Collect static files

# Create new app
make django-createapp NAME=myapp
```

**Note:** These commands run locally with `.venv`. To run in Docker, use:
```bash
make docker-exec-dev CMD="python server/manage.py <command>"
# Example: make docker-exec-dev CMD="python server/manage.py makemigrations"
```

## Environment Setup

1. Copy environment template: `cp sample.env .env`
2. Required variables:
   - `SECRET_KEY` - Django secret key (required)
   - `MODE` - "dev" or "prod"
   - `DEBUG` - "true" or "false"
3. Optional database (MSSQL):
   - `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASS`
4. Redis cache:
   - `REDIS_HOST`, `REDIS_PORT`, `REDIS_DB`

## Common Patterns

### Adding Python Dependencies
```bash
make python-add-pip PACKAGE=django-cors-headers
# or
make python-add-uv PACKAGE=django-cors-headers
```

### Creating a New Component
1. Create directory: `components/my_component/`
2. Create files: `my_component.py`, `my_component.html`
3. Register component with `@register("my_component")` decorator
4. Use in templates: `{% component "my_component" param=value %}`

### Running in Docker
```bash
# Development (port 8000)
make docker-dev-up

# Production (Apache on port 8080)
make docker-prod-up

# Execute commands in container
make docker-exec-dev CMD="python server/manage.py shell"
```

## Excluded from Linting

- `.git/`, `.venv/`, `__pycache__/`, `node_modules/`
- `migrations/`, `public/`, `staticfiles/`
- Lint rule ignores:
  - `DJ001` - null=True on string fields (allowed)
  - `E501` in settings.py - Long lines allowed

## Notes for Agents

- **CRITICAL: Run all Django commands inside Docker containers** using `make docker-exec-dev CMD="..."`
- Always use Docker for development: `make docker-dev-up` to start
- For linting/formatting, you can use local `.venv` if available, or run inside Docker
- Run `make lint-fix` before committing Python code
- Static files are in `public/`, generated from `styles/` by gulp
- Don't edit files in `public/css/`, `public/fonts/`, `public/img/`, `public/uswds/` - they're generated
- Use `make help` to see all available commands
- For accessibility: Run `make test-accessibility` on pages before committing
