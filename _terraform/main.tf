# Always add the S3 backend for proper use of the BNW terraform support
# Do not set any additional parameters as they will be overriden by
# bnw_terraform_init, which sets the bucket, keys, etc according to BNW's best
# practices
terraform {
  backend "s3" { }
}

variable "application" {
  type        = "string"
  description = "application name (e.g. `my-app`)"
}

variable "branch" {
  type        = "string"
  description = "branch name (e.g. `master`"
}

variable "environment" {
  type        = "string"
  description = "environment (e.g. `dev`, `live`)"
}

variable "ou" {
  type        = "string"
  description = "ou (e.g. `infosec`, `dna`, `production`)"
}

variable "app_env" {
  type = "string"
  description = "current environment (e.g. `production`, `staging`, `integration`)"
}

variable "bucket_region" {
  type        = "string"
  description = "bucket region"
}

variable "app_role" {
  type        = "string"
  description = "Application role authorised to access the bucket"
}

# Note if you are running on your laptop, you will need to set a couple of
# environment variables to adjust the AWS credentials according to the
# account you are deploying your application. For example, for an application
# running on the dev environment and production organisation unit (ou).
# You need to set:
#   AWS_SDK_LOAD_CONFIG=1 AWS_PROFILE=dev-production
# where AWS_SDK_LOAD_CONFIG=1 tells terraform to load your settings
# from ~/.aws/credentials and ~/.aws/config files and
# AWS_PROFILE=dev-production indicates the credentials to load from those
# files (which are mapped to BNW environments and accouts/OUs).
# In Jenkis (or when running via bnw_runner) you don't need to set those
# variables as they are automatically configured by the bnw tooling.
provider "aws" {
  version = "~> 2.0"
  region  = "${var.bucket_region}"
}

# Use this data source to get the access to the effective Account ID, User ID,
# and ARN in which Terraform is authorized.
data "aws_caller_identity" "current" {}
