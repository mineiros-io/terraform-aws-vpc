# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the VPC. The permissible size of the block ranges between a /16 netmask and a /28 netmask. We advice you to use a CIDR block reserved for private address space as recommended in RFC 1918 http://www.faqs.org/rfcs/rfc1918.html."
  type        = string

  # VPCs can vary in size from 16 addresses (/28 netmask) to 65536 addresses (/16 netmask).
  # See further information here:
  # - Classless Inter-domain Routing (CIDR) RFC-4632 https://tools.ietf.org/html/rfc4632
  # - AWS VPC Design https://aws.amazon.com/de/answers/networking/aws-single-vpc-design/
  #
  # Example:
  # Creates a VPC with up to to 65536 possible addresses (/16 netmask, 10.2.0.0 - 10.2.255.255).
  # cidr_block = "10.2.0.0/16"
  #
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "assign_generated_ipv6_cidr_block" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block."
  type        = bool
  default     = false
}

variable "allow_private_subnets_internet_access" {
  description = "Whether or not to grant resoures inside the private subnets access to the public internet via NAT Gateways."
  type        = bool
  default     = true
}

variable "create" {
  description = "Whether or not if the VPC and its should be created."
  type        = bool
  default     = true
}

variable "create_single_nat_only" {
  description = "Whether or not to only create a single NAT Gateway. This is recommended for dev, staging and testing environments because NAT Gateways produce costs."
  type        = bool
  default     = false
}

variable "enable_classiclink" {
  description = "A boolean flag to enable/disable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic. Read more: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/vpc-classiclink.html"
  type        = bool
  default     = false
}

variable "enable_classiclink_dns_support" {
  description = "A boolean flag to enable/disable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic."
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC."
  type        = bool
  default     = false
}

variable "enable_nat" {
  description = "Whether or not to create the NAT Gateways."
  type        = bool
  default     = true
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC."
  type        = string
  default     = "dedicated"
}

variable "aws_region" {
  description = "The AWS region in which all resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "public_subnets" {
  description = "A map of public subnets to create for this VPC."
  //  type        = list(map(string))
  type = any

  # Example:
  #
  # public_subnets = [
  #   {
  #     availability_zone = "us-east-1a",
  #     cidr_block        = "10.0.64.0/21",
  #   },
  #   {
  #     availability_zone = "us-east-1a",
  #     cidr_block        = "10.0.80.0/21",
  #   },
  #   {
  #     availability_zone = "us-east-1b",
  #     cidr_block        = "10.0.96.0/21",
  #   }
  # ]
}

variable "private_subnets" {
  description = "A map of private subnets to create for this VPC."
  type        = list(map(string))
}

variable "private_persistence_subnets" {
  description = "A map of private persistence subnets to create for this VPC."
  type        = list(map(string))
}

variable "tags" {
  description = "A map of tags to apply to all created resources."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   Name = "Test"
  # }
  default = {}
}

variable "endpoint_tags" {
  description = "A map of tags to apply to the created VPC Endpoints."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   "CreatedAt" = "2020-02-07"
  # }
  default = {}
}

variable "internet_gateway_tags" {
  description = "A map of tags to apply to the created Internet Gateway."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   "CreatedAt" = "2020-02-07"
  # }
  default = {}
}

variable "public_subnet_tags" {
  description = "A map of tags to apply to the created Public Subnets."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   "CreatedAt" = "2020-02-07"
  # }
  default = {}
}

variable "private_subnet_tags" {
  description = "A map of tags to apply to the created Public Subnets."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   "CreatedAt" = "2020-02-07"
  # }
  default = {}
}

variable "public_route_table_tags" {
  description = "A map of tags to apply to the created Public Route Table."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   "CreatedAt" = "2020-02-07"
  # }
  default = {}
}

variable "private_route_table_tags" {
  description = "A map of tags to apply to the created Private Route Table."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   "CreatedAt" = "2020-02-07"
  # }
  default = {}
}

variable "nat_gateway_tags" {
  description = "A map of tags to apply to the created NAT Gateways."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   "CreatedAt" = "2020-02-07"
  # }
  default = {}
}

variable "vpc_tags" {
  description = "A map of tags to apply to the created VPC."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   "CreatedAt" = "2020-02-07"
  # }
  default = {}
}
