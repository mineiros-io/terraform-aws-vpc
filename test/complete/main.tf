
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

variable "aws_region" {
  description = "(Optional) Run the test in the specific region."
  type        = string
  default     = "us-east-1"
}

locals {
  cidr_block = "192.168.0.0/16"
}

module "vpc" {
  source = "../.."

  module_enabled = var.module_enabled

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
  ]
}

provider "aws" {
  region  = var.aws_region
  version = "~> 2.0"
}

output "all" {
  value = module.vpc
}
