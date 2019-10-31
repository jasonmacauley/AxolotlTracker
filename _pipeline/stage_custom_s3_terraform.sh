#!/bin/bash
set -e
source "_pipeline/config.sh"

# This is the IAM role applied to the running containers of the application. It
# is used to allow the apps access to its KMS Keys, secrets among other
# capabilities. We are loading the name here, so we can use in the terraform S3
# template, where we will allow the app role to read and write to the bucket.
APP_ROLE="$(bnw_name $APP_NAME master $ENVIRONMENT $APP_STAGE $REGION)"
REGION="eu-west-1" # I think this is set by Jenkins somehow normally?

cd _terraform

echo
echo "### Initialising"
echo
# bnw_terraform init should be used instead of 'terraform init' so we can
# initialise prepare terraform to be used in the BNW. The bnw_terraform_init
# command sets up the correct backend so we can remotely store state files and
# support advanced features suck as locking the state file (which is
# enabled by default when using bnw_terraform_init).
bnw_terraform init \
  --app-name "${APP_NAME}" \
  --environment "${ENVIRONMENT}" \
  --ou "${APP_STAGE}" \
  --region "${REGION}" \
  --branch-name "${BRANCH_NAME}"

echo
echo "### Validating template"
echo
# Validating the template syntax
terraform validate

echo
echo "### Running Plan"
echo
# Running the plan command. Note the '-out' parameter, which is where the plan
# is stored. This is important to ensure whatever you see in the 'plan' phase
# is applied when running apply.
terraform plan \
  -out custom_s3.out \
  -input=false \
  -var application="${APP_NAME}" \
  -var branch="${BRANCH_NAME}" \
  -var environment="${ENVIRONMENT}" \
  -var ou="${APP_STAGE}" \
  -var bucket_region="${REGION}" \
  -var app_role="${APP_ROLE}" \
  -var app_env="${APP_ENV}"


echo
echo "### Running apply"
echo
# Applies the plan defined earlier and creates the resources in AWS
terraform apply -input=false -auto-approve custom_s3.out

echo
echo "### Cleaning up"
echo
# cleanup temporary files, plans, etc
rm -rf _terraform/.terraform
rm -rf _terraform/*.out

echo "Done."
