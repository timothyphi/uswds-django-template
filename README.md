# tempest

## Developer (System) Requirements

These aren't actually hard requirements, just what's on my machine

- nvm version 0.37.2
- node version v23.10.0
- npm version v11.2.0
- python version 3.11

## Production Requirements

- python version 3.11

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

`TODO` Explain: Why do we need USWDS? We could remove `uswds-compile` (instead use `vite`) and we would no longer need the `gulpfile.js`.

```shell
npm run uswds-init
```

- This runs the `gulpfile.js` script.
- The main thing we need from this command is the USWDS javascript files and the assets being placed in the proper directory.

### 4. Remove and Revert USWDS extras

```shell
rm styles/_uswds-theme.scss
rm styles/_uswds-theme-custom-styles.scss
git restore styles/styles.scss
```

- We don't need the files that USWDS generates for us, because we can and should already have SASS setup with the proper `@forward`ing to include our own SASS partials.

### Option 1. Run tools in development

```shell
npm run server # Watches `server` directory, triggers rebuild on change
npm run scss   # Watches `styles` directory, triggers rebuild on change
npm run ts     # Watches `browser` directory, triggers rebuild on change
```

### Option 2. Build Browser Code for Deployment

```shell
npm run build   # One-time builds TS -> JS (bundle) and SCSS -> CSS (bundle)
```

### Optional: Run accessibility check

Set in `package.json` to run on <http://localhost:8000/> by default (change if necessary).

```shell
npm run acheck
```

Check [here](https://www.npmjs.com/package/accessibility-checker#Configuration) for more information.

## TODO List

1. Integration tests
1. Security Audit
1. Accessibility Checker

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
