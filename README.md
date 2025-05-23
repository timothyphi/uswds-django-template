# tempest

A project template utilizing [Django](https://www.djangoproject.com/) as the backend application server the Django templating system, SASS partials for the organizing stylesheets along with [USWDS](https://designsystem.digital.gov/) as a starter design system, and TypeScript with [Vite](https://vite.dev/) for the bundled, client-side, browser code.

## Developer (System) Requirements

These aren't actually hard requirements, just what's on my machine

- git version 2.39.5
- python version 3.12
- nvm version 0.37.2
- node set as version v23.10.0
- npm set as version v11.2.0

## Production Requirements

- TBD
- Python version 3.12
- Docker?
- Operating system (which ones?)

## Initial Setup for Development

### Step 0. Install Python (or update to at least the version listed above)

Check [here](https://www.python.org/downloads/).

### Step 1. Install Python dependencies

```shell
python -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
```

### Step 2. Install JavaScript dependencies

```shell
npm install
```

### Step 3. Initialize USWDS

`TODO` Explain: Why do we need USWDS? We could remove [`uswds-compile`](https://github.com/uswds/uswds-compile) (instead use `vite` to compile and watch our SASS) and we would no longer need the `gulpfile.js` and two setup steps (this and the next one). Seems like a heavy dependency.

```shell
npm run uswds-init
```

- This runs the `gulpfile.js` script.
- The main thing we need from this command is the USWDS javascript files and the `fonts`, `images`, and `uswds/js` being placed in the proper directory (i.e. `public`).

### Step 4. Remove and Revert USWDS extras

```shell
rm styles/_uswds-theme.scss
rm styles/_uswds-theme-custom-styles.scss
git restore styles/styles.scss
```

- We don't need the files that USWDS generates for us, because we can and should already have SASS setup with the proper `@forward`ing to include our own SASS partials.

### Step 5, Option 1. Run tools in development

```shell
npm run server # Watches `server` directory, triggers rebuild on change
npm run scss   # Watches `styles` directory, triggers rebuild on change
npm run ts     # Watches `browser` directory, triggers rebuild on change
```

### Step 5, Option 1. (part 2)

Run all three scripts with `tmux`.

```shell
./scripts/run_tmux_env.sh
```

Kill all `tmux` scripts by killing the session.

```shell
tmux kill-session -t tempest
```

### Step 5, Option 2. Build Browser Code for Deployment

Make sure to initialize USWDS from Step 3. prior to building the JS and CSS bundles. Or else the HTML and CSS will reference scripts, fonts, and images not yet moved to the `public` directory.

```shell
npm run build   # One-time builds TS -> JS (bundle) and SCSS -> CSS (bundle)
```

### Completely Optional: Run accessibility check

```shell
npm run acheck -- http://localhost:8000
```

Runs the accessibility check on the URL provided and generates results.

Check [here](https://www.npmjs.com/package/accessibility-checker#Configuration) for more information.

## TODO List

1. Watch Mode for server
1. Security Audit
1. Integration testing strategy

1. CI/CD
1. Infrastructure

   - docker-compose primarily just for devlopment
   - Dockerfile for server application
     - Maybe one (seperate?) for building?
     - Releases are just the server binary and the static files directory to keep production dependencies at a minimum.
   - Image for Redis
   - Image for Postgres or some other database.
   - Nginx configuration
   - Terraform scripts to setup infrastructure
   - Ansible scripts to configure machines
     - Test and/or Prod environments?
     - Where should I put the database?

1. Background Tasks
1. Scheduled Automations

1. Database tool for running (multi-part) scripts

1. Protected routes, authentication and authorization
1. Access Control (admin, owner, staff, public)

1. Bug Submission
1. Content Request
1. Feature Request
1. Payment, Billing, and Invoicing

1. Email?

1. Packaging and Module breakdown (diagram below)
1. Optimized async route handlers
