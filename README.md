# uswds-django-template

A project template utilizing Django (python) as the backend server, SASS for the organizing stylesheets with USWDS as a starter design system.

## Developer (System) Requirements

These aren't actually hard requirements, just what's on my machine

- node v23.10.0
- npm v11.2.0
- python v3.11

Also tested on these version of `node` and `npm`

- node v20.19.2
- npm v10.8.2

## Production Requirements

- python v3.11

## Setup for Development

### Step 1. Install Python dependencies

```shell
python -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

### Step 2. Install JavaScript dependencies

```shell
npm install
```

### Step 3. Setup Environment File

```shell
cp sample.env .env
```

Fill out the `.env` file with your configuration values. The file will be automatically loaded by Docker Compose or the application.

### Step 4. Do one-time build

```shell
npm run build
```

### Step 5. Run tools in development

```shell
npm run server # Watches `server` directory, triggers rebuild on change
npm run scss   # Watches `styles` directory, triggers rebuild on change
```

Check the `package.json` for more developer scripts.

### Step 6. Run using Docker Compose

The project includes a docker-compose setup with support for both development and production environments.

**Development mode** (Django dev server on port 8000):

```shell
docker compose --profile dev up
```

**Production mode** (Apache HTTP Server on port 8080):

```shell
docker compose --profile prod up
```

Both modes include:

- Microsoft SQL Server (port 1433)
- Redis cache (port 6379)
- Automatic database migrations
- Health checks for all services

To rebuild containers:

```shell
docker compose --profile dev up --build
# or
docker compose --profile prod up --build
```

To stop and remove containers:

```shell
docker compose --profile dev down
# or
docker compose --profile prod down
```

### Optional: Run accessibility check

Set in `package.json` to run on <http://localhost:8000/> for example.

```shell
npm run acheck -- http://localhost:8000
```

[Accessibility check package link](https://www.npmjs.com/package/accessibility-checker#Configuration) for more information.

## Don't forget to generate requirements.txt after adding new Python dependencies

Using `pip freeze`:

```shell
pip freeze > requirements.txt
```

Using `uv pip`:

```shell
uv pip freeze > requirements.txt
```

## Supplemental Documentation

- [django](https://www.djangoproject.com/)
- [uswds](https://designsystem.digital.gov/)
- [sass](https://sass-lang.com/)
