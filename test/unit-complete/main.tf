# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# COMPLETE FEATURES UNIT TEST
# This module tests a complete set of most/all non-exclusive features
# The purpose is to activate everything the module offers, but trying to keep execution time and costs minimal.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

variable "aws_region" {
  description = "(Optional) The AWS region in which all resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "module_enabled" {
  description = "(Optional) Test module_enabled feature. Can be true or false."
  type        = bool
  default     = true
}

variable "nat_gateway_mode" {
  description = "(Optional) Test nat_gateway_mode feature. Can be single, one_per_az, or none."
  type        = string
  default     = "single"
}

provider "aws" {
  region = var.aws_region
}

locals {
  cidr_block = "192.168.0.0/16"
}

module "test" {
  source = "../.."

  module_enabled = true

  vpc_name         = "test"
  cidr_block       = local.cidr_block
  nat_gateway_mode = var.nat_gateway_mode

  subnets = [
    {
      group = "test"
      class = "public"

      netnums_by_az = {
        a = [0]
        b = [1]
      }
    },
    {
      group = "test"
      class = "private"

      netnums_by_az = {
        a = [2]
        b = [3]
      }
    },
    {
      group = "test"
      class = "intra"

      netnums_by_az = {
        a = [128]
        b = [129]
      }
    },
    {
      group = "db"
      class = "intra"

      db_subnet_group_name = "my-db-subnet-group"

      tags = {
        "foo" = "bar"
      }

      netnums_by_az = {
        a = [130]
        b = [131]
      }
    },
  ]

  module_tags = {
    Environment = "unknown"
  }

  module_depends_on = ["nothing"]
}
