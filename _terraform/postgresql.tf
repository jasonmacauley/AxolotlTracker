#provider "aws" {
#  region = "eu-west-1"
#}

##############################################################
# Data sources to get VPC, subnets and security group details
##############################################################


###########
# Master DB
###########
module "master" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"
#  source = "../../"

  identifier = "axolotltracker-db-master-postgres"

  engine            = "postgres"
  engine_version    = "9.6.9"
  instance_class    = "db.t2.large"
  allocated_storage = 5

  name     = "axolotltrackerdbpostgres"
  username = "axolotl"
  password = "!petth3BuringD0g!!"
  port     = "5432"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = ["sg-12345678"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  tags = {
      Owner       = "user"
      Environment = "dev"
    }

  # DB subnet group
  subnet_ids = ["subnet-e0a87e86", "subnet-fbaa7c9d"]

  create_db_option_group    = false
  create_db_parameter_group = false

    # Snapshot name upon DB deletion
    final_snapshot_identifier = "axolotl-db"

    # Database Deletion Protection
    deletion_protection = true

    parameters = [
      {
        name = "character_set_client"
        value = "utf8"
      },
      {
        name = "character_set_server"
        value = "utf8"
      }
    ]

    options = [
      {
        option_name = "MARIADB_AUDIT_PLUGIN"

        option_settings = [
          {
            name  = "SERVER_AUDIT_EVENTS"
            value = "CONNECT"
          },
          {
            name  = "SERVER_AUDIT_FILE_ROTATIONS"
            value = "37"
          },
        ]
      },
    ]
}
