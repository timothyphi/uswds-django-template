# uswds-django-template

A project template utilizing Django (python) as the backend server, SASS for the organizing stylesheets with USWDS as a starter design system.

## Developer Requirements

- [nvm](https://github.com/nvm-sh/nvm) (Node Version Manager) - for managing Node.js versions
- [uv](https://github.com/astral-sh/uv) (Python package installer) - for managing Python environments

## Production Requirements

- Python v3.11

## Setup for Local Development

### Quick Start (Recommended)

The following commands are equivalent and will install all dependencies, setup your environment, and build assets:

```shell
make setup
```

This single command installs all dependencies, sets up your environment, and builds assets.

**OR** run the individual steps:

```shell
make install-python-uv  # Create venv and install Python dependencies (uses uv)
make install-node       # Install Node.js dependencies
make env-setup          # Copy sample.env to .env
make build              # Build SCSS to CSS
```

After setup, edit `.env` with your configuration values.

### Run Development Servers

Open two terminal windows and run:

```shell
# Terminal 1 - Django development server
make dev-server

# Terminal 2 - Watch and compile SCSS on changes
make dev-watch-scss
```

Your Django application will be running at <http://localhost:8000>.

### Docker Compose (Alternative)

You can also run the full stack using Docker Compose, which includes Django, Microsoft SQL Server, and Redis:

**Development mode** (Django dev server on port 8000):

```shell
make docker-dev-up
```

**Production mode** (Apache HTTP Server on port 8080):

```shell
make docker-prod-up
```

To stop containers:

```shell
make docker-dev-down   # or make docker-prod-down
```

To rebuild:

```shell
make docker-dev-rebuild   # or make docker-prod-rebuild
```

See `make help` for all available commands.

## Adding Python Dependencies

Use the `make` commands to add packages and automatically update `requirements.txt`:

```shell
make python-add-uv PACKAGE=package-name    # Using uv (recommended)
make python-add-pip PACKAGE=package-name   # Using pip (alternative)
```

Manual update using `uv pip`:

```shell
uv pip install package-name
uv pip freeze > requirements.txt
```

## Supplemental Documentation

- [django](https://www.djangoproject.com/)
- [uswds](https://designsystem.digital.gov/)
- [sass](https://sass-lang.com/)
