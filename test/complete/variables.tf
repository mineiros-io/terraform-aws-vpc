# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "module_enabled" {
  description = "Whether to create resources in the module."
  type        = bool
  default     = true
}

variable "nat_gateway_mode" {
  description = "Defines how many NAT gateways will be deployed for private subnets."
  type        = string
  default     = "single"
}

variable "aws_region" {
  description = "The AWS region to deploy the example in."
  type        = string
  default     = "us-east-1"
}
