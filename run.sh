#!/bin/bash

echo "running run.sh"
# exit on error
set -e

source './runtime_functions.sh'
detect_app_stage

# ensure we are at the app's folder
cd /sbapp

echo "${ENVIRONMENT}-${STAGE} RAILS_ENV: ${APP_STAGE}"

export RAILS_ENV=${APP_STAGE}
export LOG_TO_STDOUT_ENABLED=true
export DOCKER=true
export RAILS_SERVE_STATIC_FILES=true
source './bin/ruby_tuning.sh'
export DEVISE_SECRET_KEY='ea0c9a9bce14df1cdab8850a6c59ba2811a5cc4a97a7d39b275e674f9d016d5ed5d8757f06b795444d0f1f23b7b3f98fa1a0abed04fe8b3fa904ef79efe02636'

# Handle SIGTERM and forward to rails process
_term() {
  echo "Caught SIGTERM signal!"
  # overwrite TERM to INT, since clustered puma treats TERM
  # as the one that should be sent to worker - not master
  # and raises an exception
  # https://github.com/puma/puma/blob/master/docs/signals.md#puma-signals
  kill -INT "$PUMA_PID" 2>/dev/null
  wait "$PUMA_PID"
}
trap _term SIGTERM

bundle exec rails s -b 0.0.0.0 -p 3000 &
PUMA_PID=$!

wait "$PUMA_PID"
