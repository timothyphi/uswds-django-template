#!/bin/bash

SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
PROJECT_DIR="$(readlink -f "$SCRIPT_DIR/../")"

pushd $PROJECT_DIR
npx gulp init

# We setup our root SASS file so we need to revert the changes from `uswds-compile`
rm styles/_uswds-theme.scss
rm styles/_uswds-theme-custom-styles.scss
git restore styles/styles.scss
popd
