# ----------------------------------------------------------------------------------------------------------------------
# SET TERRAFORM AND PROVIDER REQUIREMENTS FOR RUNNING THIS MODULE
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.12.20, < 2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.45, < 4.0"
    }
  }
}
