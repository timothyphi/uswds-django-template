# uswds-django-template

A project template utilizing Django (python) as the backend server, SASS for the organizing stylesheets with USWDS as a starter design system, and TypeScript for the client-side browser code.

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

### Step 3. Initialize USWDS

```shell
./scripts/uswds_init.sh
```

### Step 4. Setup Environment File

```shell
cp sample.env.toml .env.toml
```

Fill out environment file for your needs.

### Step 5. (Option 1) Run tools to do one-time build

```shell
npm run build
```

### Step 5. (Option 2) Run tools in development

```shell
npm run server # Watches `server` directory, triggers rebuild on change
npm run scss   # Watches `styles` directory, triggers rebuild on change
npm run ts     # Watches `browser` directory, triggers rebuild on change
```

Check the `package.json` for more developer scripts.

### Step 5. (Option 3) Run tools in development

Run all three scripts with `tmux`.

```shell
./scripts/run_tmux_env.sh
```

Kill all `tmux` scripts by killing the session.

```shell
tmux kill-session -t uswds-django-template
```

### Optional: Run accessibility check

Set in `package.json` to run on <http://localhost:8000/> for example.

```shell
npm run acheck -- http://localhost:8000
```

[Accessibility check package link](https://www.npmjs.com/package/accessibility-checker#Configuration) for more information.

## Running the application in Production

It's recommended to build the browser assets (steps 2, 3, and 5) on a seperate machine.

1. Move those assets to the production machine

1. Install the Python dependencies (step 1)

1. Setup the environment file (step 4)

1. Run the Django server

## Supplemental Documentation

- [django](https://www.djangoproject.com/)
- [uswds](https://designsystem.digital.gov/)
- [vite](https://vite.dev/)

