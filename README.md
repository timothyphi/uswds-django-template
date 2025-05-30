# uswds-django-template

A project template utilizing Django (python) as the backend server, SASS for the organizing stylesheets with USWDS as a starter design system, and TypeScript for the client-side browser code.

## Developer (System) Requirements

These aren't actually hard requirements, just what's on my machine

- nvm v0.37.2
- node v23.10.0
- npm v11.2.0
- python v3.11

## Production Requirements

- python v3.11

## Setup

### 1. Install Python dependencies

```shell
python -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
```

### 2. Install JavaScript dependencies

```shell
npm install
```

### 3. Initialize USWDS

```shell
./scripts/uswds_init.sh
```

### Step 4. (Option 1) Run tools to do one-time build

```shell
npm run build
```

### Step 4. (Option 2) Run tools in development

```shell
npm run server # Watches `server` directory, triggers rebuild on change
npm run scss   # Watches `styles` directory, triggers rebuild on change
npm run ts     # Watches `browser` directory, triggers rebuild on change
```

Check the `package.json` for more developer scripts.

### Step 4. (Option 3) Run tools in development

Run all three scripts with `tmux`.

```shell
./scripts/run_tmux_env.sh
```

Kill all `tmux` scripts by killing the session.

```shell
tmux kill-session -t uswds-nuxt-template
```

### Optional: Run accessibility check

Set in `package.json` to run on <http://localhost:8000/> by default (change if necessary).

```shell
npm run acheck
```

[Accessibility check package link](https://www.npmjs.com/package/accessibility-checker#Configuration) for more information.
