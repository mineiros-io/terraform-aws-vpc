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
  description = "(Required) The name of the VPC"
  type        = string
}

variable "cidr_block" {
  description = "(Required) The CIDR block for the VPC. The permissible size of the block ranges between a /16 netmask and a /28 netmask. We advice you to use a CIDR block reserved for private address space as recommended in RFC 1918 http://www.faqs.org/rfcs/rfc1918.html."
  type        = string

  # VPCs can vary in size from 16 addresses (/28 netmask) to 65536 addresses (/16 netmask).
  # See further information here:
  # - Classless Inter-domain Routing (CIDR) RFC-4632 https://tools.ietf.org/html/rfc4632
  # - AWS VPC Design https://aws.amazon.com/de/answers/networking/aws-single-vpc-design/
  #
  # Example:
  # Create a VPC with up to to 65536 possible addresses (/16 netmask, 10.2.0.0 - 10.2.255.255).
  # cidr_block = "10.2.0.0/16"
  #
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "assign_generated_ipv6_cidr_block" {
  description = "(Optional) Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block."
  type        = bool
  default     = false
}

variable "allow_private_subnets_internet_access" {
  description = "(Optional) Whether or not to grant resoures inside the private subnets access to the public internet via NAT Gateways."
  type        = bool
  default     = true
}

variable "allow_intra_subnets_internet_access" {
  description = "(Optional) Whether or not to grant resoures inside the intra subnets access to the public internet via NAT Gateways."
  type        = bool
  default     = false
}

variable "create" {
  description = "(Optional) Whether or not to create the VPC its associated resources."
  type        = bool
  default     = true
}

variable "enable_classiclink" {
  description = "(Optional) Whether or not to enable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic. Read more: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/vpc-classiclink.html"
  type        = bool
  default     = false
}

variable "enable_classiclink_dns_support" {
  description = "(Optional) Whether or not to enable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic."
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "(Optional) Whether or not to enable DNS support in the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "(Optional) Whether or not to enable DNS hostnames in the VPC."
  type        = bool
  default     = false
}

variable "create_nat_gateways" {
  description = "(Optional) Set the mode for the NAT Gateways. Possible inputs are \"none\" ( create not NAT Gateways at all ), \"single\" ( create a single Nat Gateway inside the first defined Public Subnet) and \"one_per_az\" ( Create one Nat Gatway inside the first Public Subnet in each availability zone )."
  type        = string

  # Example:
  #
  # enable_nat = "single"
  #
  default = "single"
}

variable "instance_tenancy" {
  description = "(Optional) A tenancy option for instances launched into the VPC."
  type        = string
  default     = "dedicated"
}

variable "public_subnets" {
  description = "(Optional) A map of public subnets to create for this VPC."
  type        = list(map(string))

  # Example:
  #
  # public_subnets = [
  #   {
  #     availability_zone = "us-east-1a",
  #     cidr_block        = "10.0.64.0/21",
  #   },
  #   {
  #     availability_zone = "us-east-1b",
  #     cidr_block        = "10.0.80.0/21",
  #   },
  #   {
  #     availability_zone = "us-east-1c",
  #     cidr_block        = "10.0.96.0/21",
  #   }
  # ]
  default = []
}

variable "private_subnets" {
  description = "(Optional) A map of private subnets to create for this VPC."
  type        = list(map(string))

  # Example:
  #
  # private_subnets = [
  #   {
  #     availability_zone = "us-east-1a",
  #     cidr_block        = "10.0.112.0/21",
  #   },
  #   {
  #     availability_zone = "us-east-1b",
  #     cidr_block        = "10.0.128.0/21",
  #   },
  #   {
  #     availability_zone = "us-east-1c",
  #     cidr_block        = "10.0.144.0/21",
  #   }
  # ]
  default = []
}

variable "intra_subnets" {
  description = "(Optional) A map of private intra subnets to create for this VPC."
  type        = list(map(string))

  # Example:
  #
  # intra_subnets = [
  #   {
  #     availability_zone = "us-east-1a",
  #     cidr_block        = "10.0.160.0/21",
  #   },
  #   {
  #     availability_zone = "us-east-1b",
  #     cidr_block        = "10.0.176.0/21",
  #   }
  # ]
  default = []
}

variable "tags" {
  description = "(Optional) A map of tags to apply to all created resources that support tags."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

variable "eip_tags" {
  description = "(Optional) A map of tags to apply to the created NAT Gateway Elastic IP Addresses."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

variable "internet_gateway_tags" {
  description = "(Optional) A map of tags to apply to the created Internet Gateway."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

variable "public_subnet_tags" {
  description = "(Optional) A map of tags to apply to the created public subnets."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

variable "private_subnet_tags" {
  description = "(Optional) A map of tags to apply to the created Private Subnets."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

variable "intra_subnet_tags" {
  description = "(Optional) A map of tags to apply to the created Intra Subnets."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

variable "public_route_table_tags" {
  description = "(Optional) A map of tags to apply to the created Public Route Table."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

variable "private_route_table_tags" {
  description = "(Optional) A map of tags to apply to the created Private Route Table."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

variable "intra_route_table_tags" {
  description = "(Optional) A map of tags to apply to the created Intra Route Table."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

variable "nat_gateway_tags" {
  description = "(Optional) A map of tags to apply to the created NAT Gateways."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

variable "vpc_tags" {
  description = "(Optional) A map of tags to apply to the created VPC."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# VPC Gateway Endpoints

variable "endpoint_tags" {
  description = "(Optional) A map of tags to apply to the created VPC endpoints."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

variable "enable_dynamodb_endpoint" {
  description = "(Optional) Should be true if you want to provision a DynamoDB endpoint to the VPC"
  type        = bool
  default     = true
}

variable "enable_s3_endpoint" {
  description = "(Optional) Should be true if you want to provision an S3 endpoint to the VPC"
  type        = bool
  default     = true
}

# VPC Interface Endpoints

variable "all_interface_endpoints_subnet_ids" {
  description = "(Optional) A list of IDs of the subnets for all endpoints. Each endpoint will create one ENI (Elastic Network Interface) per subnet."
  type        = list(string)
  default     = []
}

variable "all_interface_endpoints_security_group_ids" {
  # This allows you to control which resources can talk to this endpoint. You need to open port 443 for AWS API calls,
  # since they run over HTTPS.
  description = "(Optional) A list of IDs of the security groups which will apply for all endpoints."
  type        = list(string)
  default     = []
}

# Codebuild

variable "enable_codebuild_endpoint" {
  description = "(Optional) Should be true if you want to provision an Codebuild endpoint to the VPC"
  default     = false
}

variable "codebuild_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Codebuild endpoint"
  default     = []
}

variable "codebuild_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Codebuilt endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  default     = []
}

variable "codebuild_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Codebuild endpoint"
  default     = false
}

variable "codebuild_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "codebuild_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# Codecommit

variable "enable_codecommit_endpoint" {
  description = "(Optional) Should be true if you want to provision an Codecommit endpoint to the VPC"
  default     = false
}

variable "codecommit_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Codecommit endpoint"
  default     = []
}

variable "codecommit_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Codecommit endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  default     = []
}

variable "codecommit_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Codecommit endpoint"
  default     = false
}

variable "codecommit_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "codecommit_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# Git Codecommit

variable "enable_git_codecommit_endpoint" {
  description = "(Optional) Should be true if you want to provision an Git Codecommit endpoint to the VPC"
  default     = false
}

variable "git_codecommit_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Git Codecommit endpoint"
  default     = []
}

variable "git_codecommit_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Git Codecommit endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  default     = []
}

variable "git_codecommit_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "git_codecommit_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Git Codecommit endpoint"
  default     = false
}

variable "git_codecommit_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# Config

variable "enable_config_endpoint" {
  description = "(Optional) Should be true if you want to provision an config endpoint to the VPC"
  default     = false
}

variable "config_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for config endpoint"
  default     = []
}

variable "config_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "config_endpoint_subnet_ids" {

  description = "(Optional) The ID of one or more subnets in which to create a network interface for config endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  default     = []
}

variable "config_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for config endpoint"
  default     = false
}

variable "config_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# SQS

variable "enable_sqs_endpoint" {
  description = "(Optional) Should be true if you want to provision an SQS endpoint to the VPC"
  default     = false
}

variable "sqs_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for SQS endpoint"
  default     = []
}

variable "sqs_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "sqs_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for SQS endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  default     = []
}

variable "sqs_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for SQS endpoint"
  default     = false
}

variable "sqs_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# Secrets Manager

variable "enable_secretsmanager_endpoint" {
  description = "(Optional) Should be true if you want to provision an Secrets Manager endpoint to the VPC"
  type        = bool
  default     = false
}

variable "secretsmanager_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Secrets Manager endpoint"
  type        = list(string)
  default     = []
}

variable "secretsmanager_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "secretsmanager_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Secrets Manager endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "secretsmanager_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Secrets Manager endpoint"
  type        = bool
  default     = false
}

variable "secretsmanager_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# SSM

variable "enable_ssm_endpoint" {
  description = "(Optional) Should be true if you want to provision an SSM endpoint to the VPC"
  type        = bool
  default     = false
}

variable "ssm_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for SSM endpoint"
  type        = list(string)
  default     = []
}

variable "ssm_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "ssm_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for SSM endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "ssm_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for SSM endpoint"
  type        = bool
  default     = false
}

variable "ssm_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# SSM MESSAGES

variable "enable_ssmmessages_endpoint" {
  description = "(Optional) Should be true if you want to provision a SSMMESSAGES endpoint to the VPC"
  type        = bool
  default     = false
}

variable "ssmmessages_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for SSMMESSAGES endpoint"
  type        = list(string)
  default     = []
}

variable "ssmmessages_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "ssmmessages_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for SSMMESSAGES endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "ssmmessages_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for SSMMESSAGES endpoint"
  type        = bool
  default     = false
}

variable "ssmmessages_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# EC2

variable "enable_ec2_endpoint" {
  description = "(Optional) Should be true if you want to provision an EC2 endpoint to the VPC"
  type        = bool
  default     = false
}

variable "ec2_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for EC2 endpoint"
  type        = list(string)
  default     = []
}

variable "ec2_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for EC2 endpoint"
  type        = bool
  default     = false
}

variable "ec2_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "ec2_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for EC2 endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "ec2_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# EC2 MESSAGES

variable "enable_ec2messages_endpoint" {
  description = "(Optional) Should be true if you want to provision an EC2MESSAGES endpoint to the VPC"
  type        = bool
  default     = false
}

variable "ec2messages_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for EC2MESSAGES endpoint"
  type        = list(string)
  default     = []
}

variable "ec2messages_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for EC2MESSAGES endpoint"
  type        = bool
  default     = false
}

variable "ec2messages_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "ec2messages_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for EC2MESSAGES endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "ec2messages_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# EC2 AUTOSCALING PLANS

variable "enable_autoscaling_plans_endpoint" {
  description = "(Optional) Should be true if you want to provision an Auto Scaling Plans endpoint to the VPC"
  type        = bool
  default     = false
}

variable "autoscaling_plans_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Auto Scaling Plans endpoint"
  type        = list(string)
  default     = []
}

variable "autoscaling_plans_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "autoscaling_plans_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Auto Scaling Plans endpoint. Only a single subnet within an AZ is supported. Ifomitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "autoscaling_plans_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Auto Scaling Plans endpoint"
  type        = bool
  default     = false
}

variable "autoscaling_plans_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# EC2 AUTOSCALING

variable "enable_ec2_autoscaling_endpoint" {
  description = "(Optional) Should be true if you want to provision an Auto Scaling Plans endpoint to the VPC"
  type        = bool
  default     = false
}

variable "ec2_autoscaling_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Auto Scaling Plans endpoint"
  type        = list(string)
  default     = []
}

variable "ec2_autoscaling_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "ec2_autoscaling_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Auto Scaling Plans endpoint. Only a single subnet within an AZ is supported. Ifomitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "ec2_autoscaling_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Auto Scaling Plans endpoint"
  type        = bool
  default     = false
}

variable "ec2_autoscaling_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}



# TRANSFERSERVER

variable "enable_transferserver_endpoint" {
  description = "(Optional) Should be true if you want to provision a Transfer Server endpoint to the VPC"
  type        = bool
  default     = false
}

variable "transferserver_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Transfer Server endpoint"
  type        = list(string)
  default     = []
}

variable "transferserver_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Transfer Server endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "transferserver_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "transferserver_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Transfer Server endpoint"
  type        = bool
  default     = false
}

variable "transferserver_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# ECR API

variable "enable_ecr_api_endpoint" {
  description = "(Optional) Should be true if you want to provision an ecr api endpoint to the VPC"
  type        = bool
  default     = false
}

variable "ecr_api_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for ECR api endpoint. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "ecr_api_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for ECR API endpoint"
  type        = bool
  default     = false
}

variable "ecr_api_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "ecr_api_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for ECR API endpoint"
  type        = list(string)
  default     = []
}

variable "ecr_api_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# ECR DKR

variable "enable_ecr_dkr_endpoint" {
  description = "(Optional) Should be true if you want to provision an ecr dkr endpoint to the VPC"
  type        = bool
  default     = false
}

variable "ecr_dkr_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for ECR dkr endpoint. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "ecr_dkr_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for ECR DKR endpoint"
  type        = bool
  default     = false
}

variable "ecr_dkr_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "ecr_dkr_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for ECR DKR endpoint"
  type        = list(string)
  default     = []
}

variable "ecr_dkr_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# API GATEWAY

variable "enable_apigw_endpoint" {
  description = "(Optional) Should be true if you want to provision an api gateway endpoint to the VPC"
  type        = bool
  default     = false
}

variable "apigw_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for API GW  endpoint"
  type        = list(string)
  default     = []
}

variable "apigw_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for API GW endpoint"
  type        = bool
  default     = false
}

variable "apigw_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "apigw_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for API GW endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "apigw_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# KMS

variable "enable_kms_endpoint" {
  description = "(Optional) Should be true if you want to provision a KMS endpoint to the VPC"
  type        = bool
  default     = false
}

variable "kms_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for KMS endpoint"
  type        = list(string)
  default     = []
}

variable "kms_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for KMS endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "kms_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "kms_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for KMS endpoint"
  type        = bool
  default     = false
}

variable "kms_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# ECS

variable "enable_ecs_endpoint" {
  description = "(Optional) Should be true if you want to provision a ECS endpoint to the VPC"
  type        = bool
  default     = false
}

variable "ecs_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for ECS endpoint"
  type        = list(string)
  default     = []
}

variable "ecs_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for ECS endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "ecs_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "ecs_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for ECS endpoint"
  type        = bool
  default     = false
}

variable "ecs_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# ECS AGENT

variable "enable_ecs_agent_endpoint" {
  description = "(Optional) Should be true if you want to provision a ECS Agent endpoint to the VPC"
  type        = bool
  default     = false
}

variable "ecs_agent_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for ECS Agent endpoint"
  type        = list(string)
  default     = []
}

variable "ecs_agent_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for ECS Agent endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "ecs_agent_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "ecs_agent_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for ECS Agent endpoint"
  type        = bool
  default     = false
}

variable "ecs_agent_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}


# ECS TELEMETRY

variable "enable_ecs_telemetry_endpoint" {
  description = "(Optional) Should be true if you want to provision a ECS Telemetry endpoint to the VPC"
  type        = bool
  default     = false
}

variable "ecs_telemetry_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for ECS Telemetry endpoint"
  type        = list(string)
  default     = []
}

variable "ecs_telemetry_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for ECS Telemetry endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}


variable "ecs_telemetry_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "ecs_telemetry_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for ECS Telemetry endpoint"
  type        = bool
  default     = false
}
variable "ecs_telemetry_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# SNS

variable "enable_sns_endpoint" {
  description = "(Optional) Should be true if you want to provision a SNS endpoint to the VPC"
  type        = bool
  default     = false
}

variable "sns_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for SNS endpoint"
  type        = list(string)
  default     = []
}

variable "sns_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for SNS endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "sns_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "sns_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for SNS endpoint"
  type        = bool
  default     = false
}

variable "sns_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# CLOUDWATCH MONITORING

variable "enable_monitoring_endpoint" {
  description = "(Optional) Should be true if you want to provision a CloudWatch Monitoring endpoint to the VPC"
  type        = bool
  default     = false
}

variable "monitoring_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for CloudWatch Monitoring endpoint"
  type        = list(string)
  default     = []
}

variable "monitoring_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for CloudWatch Monitoring endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "monitoring_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "monitoring_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for CloudWatch Monitoring endpoint"
  type        = bool
  default     = false
}

variable "monitoring_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# CLOUDWATCH LOGS

variable "enable_logs_endpoint" {
  description = "(Optional) Should be true if you want to provision a CloudWatch Logs endpoint to the VPC"
  type        = bool
  default     = false
}

variable "logs_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for CloudWatch Logs endpoint"
  type        = list(string)
  default     = []
}

variable "logs_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for CloudWatch Logs endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "logs_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "logs_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for CloudWatch Logs endpoint"
  type        = bool
  default     = false
}

variable "logs_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# CLOUDWATCH EVENTS

variable "enable_events_endpoint" {
  description = "(Optional) Should be true if you want to provision a CloudWatch Events endpoint to the VPC"
  type        = bool
  default     = false
}

variable "events_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for CloudWatch Events endpoint"
  type        = list(string)
  default     = []
}

variable "events_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for CloudWatch Events endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "events_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "events_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for CloudWatch Events endpoint"
  type        = bool
  default     = false
}

variable "events_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# ELASTIC LOADBALANCING

variable "enable_elasticloadbalancing_endpoint" {
  description = "(Optional) Should be true if you want to provision a Elastic Load Balancing endpoint to the VPC"
  type        = bool
  default     = false
}

variable "elasticloadbalancing_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Elastic Load Balancing endpoint"
  type        = list(string)
  default     = []
}

variable "elasticloadbalancing_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Elastic Load Balancing endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "elasticloadbalancing_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "elasticloadbalancing_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Elastic Load Balancing endpoint"
  type        = bool
  default     = false
}
variable "elasticloadbalancing_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# CLOUDTRAIL

variable "enable_cloudtrail_endpoint" {
  description = "(Optional) Should be true if you want to provision a CloudTrail endpoint to the VPC"
  type        = bool
  default     = false
}

variable "cloudtrail_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for CloudTrail endpoint"
  type        = list(string)
  default     = []
}

variable "cloudtrail_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for CloudTrail endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "cloudtrail_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "cloudtrail_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for CloudTrail endpoint"
  type        = bool
  default     = false
}

variable "cloudtrail_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# KINESIS STREAMS

variable "enable_kinesis_streams_endpoint" {
  description = "(Optional) Should be true if you want to provision a Kinesis Streams endpoint to the VPC"
  type        = bool
  default     = false
}

variable "kinesis_streams_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Kinesis Streams endpoint"
  type        = list(string)
  default     = []
}

variable "kinesis_streams_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Kinesis Streams endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "kinesis_streams_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "kinesis_streams_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Kinesis Streams endpoint"
  type        = bool
  default     = false
}

variable "kinesis_streams_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# KINESIS FIREHOSE

variable "enable_kinesis_firehose_endpoint" {
  description = "(Optional) Should be true if you want to provision a Kinesis Firehose endpoint to the VPC"
  type        = bool
  default     = false
}

variable "kinesis_firehose_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Kinesis Firehose endpoint"
  type        = list(string)
  default     = []
}

variable "kinesis_firehose_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Kinesis Firehose endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "kinesis_firehose_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "kinesis_firehose_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Kinesis Firehose endpoint"
  type        = bool
  default     = false
}

variable "kinesis_firehose_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# GLUE

variable "enable_glue_endpoint" {
  description = "(Optional) Should be true if you want to provision a Glue endpoint to the VPC"
  type        = bool
  default     = false
}

variable "glue_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Glue endpoint"
  type        = list(string)
  default     = []
}

variable "glue_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Glue endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "glue_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "glue_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Glue endpoint"
  type        = bool
  default     = false
}

variable "glue_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# SAGEMAKER NOTEBOOK

variable "enable_sagemaker_notebook_endpoint" {
  description = "(Optional) Should be true if you want to provision a Sagemaker Notebook endpoint to the VPC"
  type        = bool
  default     = false
}

variable "sagemaker_notebook_endpoint_region" {
  description = "Region to use for Sagemaker Notebook endpoint"
  type        = string
  default     = null
}

variable "sagemaker_notebook_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Sagemaker Notebook endpoint"
  type        = list(string)
  default     = []
}

variable "sagemaker_notebook_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Sagemaker Notebook endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}


variable "sagemaker_notebook_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "sagemaker_notebook_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Sagemaker Notebook endpoint"
  type        = bool
  default     = false
}

variable "sagemaker_notebook_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# STS

variable "enable_sts_endpoint" {
  description = "(Optional) Should be true if you want to provision a STS endpoint to the VPC"
  type        = bool
  default     = false
}

variable "sts_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for STS endpoint"
  type        = list(string)
  default     = []
}

variable "sts_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for STS endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "sts_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "sts_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for STS endpoint"
  type        = bool
  default     = false
}

variable "sts_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# CLOUDFORMATION

variable "enable_cloudformation_endpoint" {
  description = "(Optional) Should be true if you want to provision a Cloudformation endpoint to the VPC"
  type        = bool
  default     = false
}

variable "cloudformation_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Cloudformation endpoint"
  type        = list(string)
  default     = []
}

variable "cloudformation_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Cloudformation endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "cloudformation_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "cloudformation_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Cloudformation endpoint"
  type        = bool
  default     = false
}

variable "cloudformation_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# CODEPIPELINE

variable "enable_codepipeline_endpoint" {
  description = "(Optional) Should be true if you want to provision a CodePipeline endpoint to the VPC"
  type        = bool
  default     = false
}

variable "codepipeline_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for CodePipeline endpoint"
  type        = list(string)
  default     = []
}

variable "codepipeline_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for CodePipeline endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "codepipeline_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "codepipeline_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for CodePipeline endpoint"
  type        = bool
  default     = false
}

variable "codepipeline_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# APPMESH ENVOY

variable "enable_appmesh_envoy_management_endpoint" {
  description = "(Optional) Should be true if you want to provision a AppMesh endpoint to the VPC"
  type        = bool
  default     = false
}

variable "appmesh_envoy_management_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for AppMesh endpoint"
  type        = list(string)
  default     = []
}

variable "appmesh_envoy_management_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for AppMesh endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "appmesh_envoy_management_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "appmesh_envoy_management_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for AppMesh endpoint"
  type        = bool
  default     = false
}

variable "appmesh_envoy_management_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# SERVICE CATALOG

variable "enable_servicecatalog_endpoint" {
  description = "(Optional) Should be true if you want to provision a Service Catalog endpoint to the VPC"
  type        = bool
  default     = false
}

variable "servicecatalog_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Service Catalog endpoint"
  type        = list(string)
  default     = []
}

variable "servicecatalog_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Service Catalog endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "servicecatalog_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "servicecatalog_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Service Catalog endpoint"
  type        = bool
  default     = false
}

variable "servicecatalog_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# STORAGE GATEWAY

variable "enable_storagegateway_endpoint" {
  description = "(Optional) Should be true if you want to provision a Storage Gateway endpoint to the VPC"
  type        = bool
  default     = false
}

variable "storagegateway_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Storage Gateway endpoint"
  type        = list(string)
  default     = []
}

variable "storagegateway_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Storage Gateway endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "storagegatewat_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "storagegateway_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Storage Gateway endpoint"
  type        = bool
  default     = false
}

variable "storagegateway_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# TRANSFER SERVICE

variable "enable_transfer_endpoint" {
  description = "(Optional) Should be true if you want to provision a Transfer endpoint to the VPC"
  type        = bool
  default     = false
}

variable "transfer_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Transfer endpoint"
  type        = list(string)
  default     = []
}

variable "transfer_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Transfer endpoint. Only a single subnet within an AZ is supported. Ifomitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "transfer_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "transfer_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Transfer endpoint"
  type        = bool
  default     = false
}

variable "transfer_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# SAGEMAKER API

variable "enable_sagemaker_api_endpoint" {
  description = "(Optional) Should be true if you want to provision a SageMaker API endpoint to the VPC"
  type        = bool
  default     = false
}

variable "sagemaker_api_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for SageMaker API endpoint"
  type        = list(string)
  default     = []
}

variable "sagemaker_api_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for SageMaker API endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "sagemaker_api_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "sagemaker_api_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for SageMaker API endpoint"
  type        = bool
  default     = false
}

variable "sagemaker_api_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# SAGEMAKER RUNTIME

variable "enable_sagemaker_runtime_endpoint" {
  description = "(Optional) Should be true if you want to provision a SageMaker Runtime endpoint to the VPC"
  type        = bool
  default     = false
}

variable "sagemaker_runtime_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for SageMaker Runtime endpoint"
  type        = list(string)
  default     = []
}

variable "sagemaker_runtime_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for SageMaker Runtime endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "sagemaker_runtime_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "sagemaker_runtime_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for SageMaker Runtime endpoint"
  type        = bool
  default     = false
}

variable "sagemaker_runtime_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# APPSTREAM

variable "enable_appstream_endpoint" {
  description = "(Optional) Should be true if you want to provision a AppStream endpoint to the VPC"
  type        = bool
  default     = false
}

variable "appstream_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for AppStream endpoint"
  type        = list(string)
  default     = []
}

variable "appstream_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for AppStream endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "appstream_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "appstream_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for AppStream endpoint"
  type        = bool
  default     = false
}

variable "appstream_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# ATHENA

variable "enable_athena_endpoint" {
  description = "(Optional) Should be true if you want to provision a Athena endpoint to the VPC"
  type        = bool
  default     = false
}

variable "athena_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Athena endpoint"
  type        = list(string)
  default     = []
}

variable "athena_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Athena endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "athena_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "athena_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Athena endpoint"
  type        = bool
  default     = false
}

variable "athena_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# REKOGNITION

variable "enable_rekognition_endpoint" {
  description = "(Optional) Should be true if you want to provision a Rekognition endpoint to the VPC"
  type        = bool
  default     = false
}

variable "rekognition_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Rekognition endpoint"
  type        = list(string)
  default     = []
}

variable "rekognition_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Rekognition endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}


variable "rekognition_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "rekognition_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Rekognition endpoint"
  type        = bool
  default     = false
}

variable "rekognition_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# EFS

variable "enable_efs_endpoint" {
  description = "(Optional) Should be true if you want to provision an EFS endpoint to the VPC"
  type        = bool
  default     = false
}

variable "efs_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for EFS endpoint"
  type        = list(string)
  default     = []
}

variable "efs_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for EFS endpoint. Only a single subnet within an AZ is supported. Ifomitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "efs_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "efs_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for EFS endpoint"
  type        = bool
  default     = false
}

variable "efs_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# CLOUD DIRECTORY

variable "enable_cloud_directory_endpoint" {
  description = "(Optional) Should be true if you want to provision an Cloud Directory endpoint to the VPC"
  type        = bool
  default     = false
}

variable "cloud_directory_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Cloud Directory endpoint"
  type        = list(string)
  default     = []
}

variable "cloud_directory_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Cloud Directory endpoint. Only a single subnet within an AZ is supported. Ifomitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "cloud_directory_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "cloud_directory_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Cloud Directory endpoint"
  type        = bool
  default     = false
}

variable "cloud_directory_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# SES

variable "enable_ses_endpoint" {
  description = "(Optional) Should be true if you want to provision an SES endpoint to the VPC"
  type        = bool
  default     = false
}

variable "ses_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for SES endpoint"
  type        = list(string)
  default     = []
}

variable "ses_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for SES endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "ses_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "ses_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for SES endpoint"
  type        = bool
  default     = false
}

variable "ses_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# WORKSPACES

variable "enable_workspaces_endpoint" {
  description = "(Optional) Should be true if you want to provision an Workspaces endpoint to the VPC"
  type        = bool
  default     = false
}

variable "workspaces_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Workspaces endpoint"
  type        = list(string)
  default     = []
}

variable "workspaces_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Workspaces endpoint. Only a single subnet within an AZ is supported. Ifomitted, private subnets will be used."
  type        = list(string)
  default     = []
}


variable "workspaces_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "workspaces_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Workspaces endpoint"
  type        = bool
  default     = false
}

variable "workspaces_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# ACCESS ANALYZER

variable "enable_access_analyzer_endpoint" {
  description = "(Optional) Should be true if you want to provision an Access Analyzer endpoint to the VPC"
  type        = bool
  default     = false
}

variable "access_analyzer_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Access Analyzer endpoint"
  type        = list(string)
  default     = []
}

variable "access_analyzer_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Access Analyzer endpoint. Only a single subnet within an AZ is supported. Ifomitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "access_analyzer_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "access_analyzer_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Access Analyzer endpoint"
  type        = bool
  default     = false
}

variable "access_analyzer_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# EBS

variable "enable_ebs_endpoint" {
  description = "(Optional) Should be true if you want to provision an EBS endpoint to the VPC"
  type        = bool
  default     = false
}

variable "ebs_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for EBS endpoint"
  type        = list(string)
  default     = []
}

variable "ebs_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for EBS endpoint. Only a single subnet within an AZ is supported. Ifomitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "ebs_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "ebs_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for EBS endpoint"
  type        = bool
  default     = false
}

variable "ebs_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# DATASYNC

variable "enable_datasync_endpoint" {
  description = "(Optional) Should be true if you want to provision an Data Sync endpoint to the VPC"
  type        = bool
  default     = false
}

variable "datasync_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Data Sync endpoint"
  type        = list(string)
  default     = []
}

variable "datasync_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Data Sync endpoint. Only a single subnet within an AZ is supported. Ifomitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "datasync_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "datasync_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Data Sync endpoint"
  type        = bool
  default     = false
}

variable "datasync_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# ELASTIC INFERENCE RUNTIME

variable "enable_elastic_inference_runtime_endpoint" {
  description = "(Optional) Should be true if you want to provision an Elastic Inference Runtime endpoint to the VPC"
  type        = bool
  default     = false
}

variable "elastic_inference_runtime_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Elastic Inference Runtime endpoint"
  type        = list(string)
  default     = []
}

variable "elastic_inference_runtime_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Elastic Inference Runtime endpoint. Only a single subnet within an AZ is supported. Ifomitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "elastic_inference_runtime_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "elastic_inference_runtime_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Elastic Inference Runtime endpoint"
  type        = bool
  default     = false
}

variable "elastic_inference_runtime_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# SMS

variable "enable_sms_endpoint" {
  description = "(Optional) Should be true if you want to provision an SMS endpoint to the VPC"
  type        = bool
  default     = false
}

variable "sms_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for SMS endpoint"
  type        = list(string)
  default     = []
}

variable "sms_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for SMS endpoint. Only a single subnet within an AZ is supported. Ifomitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "sms_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "sms_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for SMS endpoint"
  type        = bool
  default     = false
}

variable "sms_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# EMR

variable "enable_emr_endpoint" {
  description = "(Optional) Should be true if you want to provision an EMR endpoint to the VPC"
  type        = bool
  default     = false
}

variable "emr_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for EMR endpoint"
  type        = list(string)
  default     = []
}

variable "emr_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for EMR endpoint. Only a single subnet within an AZ is supported. Ifomitted, private subnets will be used."
  type        = list(string)
  default     = []
}


variable "emr_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "emr_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for EMR endpoint"
  type        = bool
  default     = false
}

variable "emr_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# QLDB

variable "enable_qldb_session_endpoint" {
  description = "(Optional) Should be true if you want to provision an QLDB Session endpoint to the VPC"
  type        = bool
  default     = false
}

variable "qldb_session_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for QLDB Session endpoint"
  type        = list(string)
  default     = []
}

variable "qldb_session_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for QLDB Session endpoint. Only a single subnet within an AZ is supported. Ifomitted, private subnets will be used."
  type        = list(string)
  default     = []
}


variable "qldb_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "qldb_session_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for QLDB Session endpoint"
  type        = bool
  default     = false
}

variable "qldb_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# ELASTIC BEANSTALK

variable "enable_elasticbeanstalk_endpoint" {
  description = "(Optional) Should be true if you want to provision a Elastic Beanstalk endpoint to the VPC"
  type        = bool
  default     = false
}

variable "elasticbeanstalk_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Elastic Beanstalk endpoint"
  type        = list(string)
  default     = []
}

variable "elasticbeanstalk_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Elastic Beanstalk endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "elasticbeanstalk_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "elasticbeanstalk_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Elastic Beanstalk endpoint"
  type        = bool
  default     = false
}

variable "elasticbeanstalk_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# ELASTIC BEANSTALK HEALH

variable "enable_elasticbeanstalk_health_endpoint" {
  description = "(Optional) Should be true if you want to provision a Elastic Beanstalk Health endpoint to the VPC"
  type        = bool
  default     = false
}

variable "elasticbeanstalk_health_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Elastic Beanstalk Health endpoint"
  type        = list(string)
  default     = []
}

variable "elasticbeanstalk_health_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Elastic Beanstalk Health endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "elasticbeanstalk_health_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "elasticbeanstalk_health_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Elastic Beanstalk Health endpoint"
  type        = bool
  default     = false
}

variable "elasticbeanstalk_health_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# STATES

variable "enable_states_endpoint" {
  description = "(Optional) Should be true if you want to provision a Step Function endpoint to the VPC"
  type        = bool
  default     = false
}

variable "states_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for Step Function endpoint"
  type        = list(string)
  default     = []
}

variable "states_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Step Function endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "states_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "states_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for Step Function endpoint"
  type        = bool
  default     = false
}

variable "states_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}

# ACM

variable "enable_acm_pca_endpoint" {
  description = "(Optional) Should be true if you want to provision an ACM PCA endpoint to the VPC"
  default     = false
}

variable "acm_pca_endpoint_security_group_ids" {
  description = "(Optional) The ID of one or more security groups to associate with the network interface for ACM PCA endpoint"
  default     = []
}

variable "acm_pca_endpoint_subnet_ids" {
  description = "(Optional) The ID of one or more subnets in which to create a network interface for Codebuilt endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  default     = []
}


variable "acm_pca_endpoint_policy" {
  description = "(Optional) IAM policy to restrict what resources can call this endpoint. For example, you can add an IAM policy that allows EC2 instances to talk to this endpoint but no other types of resources. If not specified, all resources will be allowed to call this endpoint."
  type        = string
  default     = null
}

variable "acm_pca_endpoint_private_dns_enabled" {
  description = "(Optional) Whether or not to associate a private hosted zone with the specified VPC for ACM PCA endpoint"
  default     = false
}

variable "acm_pca_endpoint_tags" {
  description = "(Optional) A map of tags to apply to the codebuild interface endpoint."
  type        = map(string)

  # Example:
  #
  # tags = {
  #   CreatedAt = "2020-02-07",
  #   Alice     = "Bob
  # }
  default = {}
}
