#!/usr/bin/env bash
function detect_app_stage {
  export APP_STAGE=development
  ENV_STAGE=${ENVIRONMENT}-${STAGE}
  if [ "$STAGE" = 'local' ]; then
    echo 'starting local development environment'
    rm -f tmp/pids/server.pid
    APP_STAGE=development
  else
    if [ "$ENV_STAGE" = 'dev-production' ] && [ "$BRANCH" != 'master' ]; then
      APP_STAGE=integration
    elif [ "$ENV_STAGE" = 'dev-production' ] && [ "$BRANCH" = 'master' ]; then
      APP_STAGE=staging
    elif [ "$ENV_STAGE" = 'live-production' ] && [ "$BRANCH" = 'master' ]; then
      APP_STAGE=production
    else
      echo 'ambiguous setting environment-stage =' "${ENVIRONMENT}"-"${STAGE}, exiting..."
      exit 1
    fi
  fi
}

function handle_secrets(){
  handle_secrets_from_secrets_manager
  handle_recaptcha_secrets "${HOME}"
}

function handle_secrets_from_secrets_manager(){
  # Fetch secrets from AWS Secrets Manager
  /sbapp/bin/fetch_secrets
  cat $(ls -I chopin-migration.conf ${HOME}/*.conf) >> ${HOME}/.chopin.conf
  if [ ! -z $MIGRATION_HOSTS ]; then
    cat ${HOME}/chopin-migration.conf >> ${HOME}/.chopin.conf
    echo "export CHOPIN_MONGO_MIGRATION_HOSTS='${MIGRATION_HOSTS}'" >> ${HOME}/.chopin.conf
  fi
  if [ -z "$CHOPIN_SHELL" ] && [ "$APP_STAGE" = 'integration' ]; then
    sed -i '/CHOPIN_MONGO_DATABASE/d' ${HOME}/.chopin.conf
    SANITISED_BRANCH=$(sed -e s/[./_]/-/g <<< $BRANCH) #invalid for mongo database names
    echo "export CHOPIN_MONGO_DATABASE='chopin_${SANITISED_BRANCH}'" >> ${HOME}/.chopin.conf
  elif [ ! -z "$CHOPIN_SHELL" ] && [ "$APP_STAGE" = 'integration' ]; then
    sed -i '/CHOPIN_MONGO_DATABASE/d' /home/sbopr/.chopin.conf
    SANITISED_BRANCH=$(sed -e s/[./_]/-/g <<< $RAW_BRANCH_NAME) #invalid for mongo database names
    echo "export CHOPIN_MONGO_DATABASE='chopin_${SANITISED_BRANCH}'" >> /home/sbopr/.chopin.conf
  fi
  echo "export AWS_REGION='${REGION}'" >> ${HOME}/.chopin.conf
  source ${HOME}/.chopin.conf 
}

function handle_recaptcha_secrets(){
  secrets_path=$1
  if [[ -z "$secrets_path" ]]; then
    secrets_path=/run/secrets
  fi
  destination_path=/sbapp/config/snippets

  declare -a decrypted_files=("recaptcha_keys_development.yml" "recaptcha_keys_staging.yml"
  "recaptcha_keys_production.yml" "recaptcha_keys_integration.yml")
  for file in ${decrypted_files[@]}
  do
    if [[ -f $secrets_path/$file && ! -f $destination_path/$file ]]; then
      echo "Copying from $secrets_path/$file to $destination_path"
      $(mv $secrets_path/$file $destination_path/$file)
    fi
  done
}
