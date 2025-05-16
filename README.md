# torgadden

## Developer Requirements

These aren't actually hard requirements, just what's on my machine

- nvm version 0.37.2
- node version v23.10.0
- npm version v11.2.0
- rustc/cargo v1.86.0

TODO: This should be Dockerized eventually

## Production Requirements

- Nothing...
- Docker?

## Developer Tools

- rust-analyzer
- typescript
- esbuild
- eslint
- gulp
- prettier

## Useful Commands

### Developer Scripts

Check `package.json` for npm scripts.

## TODO List

1. Watch mode
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

1. Logging

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
