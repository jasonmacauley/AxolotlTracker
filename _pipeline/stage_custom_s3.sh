#!/bin/bash
source "/opt/sb/sb-pipeline.sh"
set -e
source "_pipeline/config.sh"

# The login_to_stage ensures your application is deployed to the organisation
# unit (app_stage) defined in the config.sh file
login_to_stage "${APP_STAGE}"

# Here, we select the sb-terraform to be used to deploy the next stage:
# stage_custom_s3_terraform.sh.
# The build_img_runner helper ensures the correct environment is set to
# run commands using different build images
export APP_BUILD_IMAGE_NAME=$(image_name sb-terraform-centos-0-12-x master)
build_img_runner ./_pipeline/stage_custom_s3_terraform.sh
