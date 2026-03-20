# uswds-django-template

A project template utilizing Django web framework, SASS for the organizing stylesheets with USWDS as a starter design system.

## Developer Recommended

- [uv](https://github.com/astral-sh/uv) (Python package installer) - for managing Python dependencies and environment
- [just](https://github.com/casey/just) (just a command runner) - for running and documenting routine shell commands

These tools are highly recommended but you may always use `python`/`pip` to install dependencies and manage virtual environments, and the `Justfile` is fairly readable, so feel free to run those commands in the shell.

## Developer Requirements

 - npm v22.13.10
 - python v3.11

## Production Requirements

- Python v3.11

## Setup for Local Development

### Quick Start (Recommended)

The following commands are almost equivalent and will install all dependencies, setup your environment, and build assets:

```shell
just setup
```

This single command installs all dependencies, sets up your environment, and builds assets.

**OR** run the individual steps:

```shell
just install-python     # Uses system python and version for virtual environment
# OR
just install-python-uv  # Uses system uv, adheres to .python-version

just install-node    # Install Node.js dependencies
just env-setup       # Copy sample.env to .env
just build           # Build SCSS to CSS
```

After setup, edit `.env` with your configuration values.

### Run Development Servers

Open two terminal windows and run:

```shell
# Terminal 1 - Django development server
just dev-server

# Terminal 2 - Watch and compile SCSS on changes
just dev-watch-scss
```

Your Django application will be running at <http://localhost:8000>.

### Docker Compose (Alternative)

You can also run the full stack using Docker Compose, which includes Django, Microsoft SQL Server, and Redis:

**Development mode** (Django dev server on port 8000):

```shell
just docker-dev-up
```

**Production mode** (Apache HTTP Server on port 8080):

```shell
just docker-prod-up
```

To stop containers:

```shell
just docker-dev-down   # or just docker-prod-down
```

To rebuild:

```shell
just docker-dev-rebuild   # or just docker-prod-rebuild
```

See `just --list` for all available commands.

## Adding Python Dependencies

Use the `just` commands to add packages and automatically update `requirements.txt`:

```shell
just python-add-prod package-name  # Add a production dependency
just python-add-dev package-name   # Add a development-only dependency
```

## Supplemental Documentation

- [django](https://www.djangoproject.com/)
- [uswds](https://designsystem.digital.gov/)
- [sass](https://sass-lang.com/)
