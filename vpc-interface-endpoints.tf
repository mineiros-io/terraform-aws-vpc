locals {
  private_subnet_ids = [for subnet in aws_subnet.private : subnet.id]
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Codebuild
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "codebuild" {
  count = var.create && var.enable_codebuild_endpoint ? 1 : 0

  service = "codebuild"
}

resource "aws_vpc_endpoint" "codebuild" {
  count = var.create && var.enable_codebuild_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.codebuild[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.codebuild_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.codebuild_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.codebuild_endpoint_private_dns_enabled
  policy              = var.codebuild_endpoint_policy
  tags                = merge(var.codebuild_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Code Commit
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "codecommit" {
  count = var.create && var.enable_codecommit_endpoint ? 1 : 0

  service = "codecommit"
}

resource "aws_vpc_endpoint" "codecommit" {
  count = var.create && var.enable_codecommit_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.codecommit[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.codecommit_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.codecommit_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.codecommit_endpoint_private_dns_enabled
  policy              = var.codecommit_endpoint_policy
  tags                = merge(var.codecommit_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Git Code Commit
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "git_codecommit" {
  count = var.create && var.enable_git_codecommit_endpoint ? 1 : 0

  service = "git-codecommit"
}

resource "aws_vpc_endpoint" "git_codecommit" {
  count = var.create && var.enable_git_codecommit_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.git_codecommit[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.git_codecommit_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.git_codecommit_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.git_codecommit_endpoint_private_dns_enabled
  policy              = var.git_codecommit_endpoint_policy
  tags                = merge(var.git_codecommit_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Config
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "config" {
  count = var.create && var.enable_config_endpoint ? 1 : 0

  service = "config"
}

resource "aws_vpc_endpoint" "config" {
  count = var.create && var.enable_config_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.config[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.config_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.config_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.config_endpoint_private_dns_enabled
  policy              = var.config_endpoint_policy
  tags                = merge(var.config_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for SQS
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "sqs" {
  count = var.create && var.enable_sqs_endpoint ? 1 : 0

  service = "sqs"
}

resource "aws_vpc_endpoint" "sqs" {
  count = var.create && var.enable_sqs_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.sqs[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.sqs_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.sqs_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.sqs_endpoint_private_dns_enabled
  policy              = var.sqs_endpoint_policy
  tags                = merge(var.sqs_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Secrets Manager
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "secretsmanager" {
  count = var.create && var.enable_secretsmanager_endpoint ? 1 : 0

  service = "secretsmanager"
}

resource "aws_vpc_endpoint" "secretsmanager" {
  count = var.create && var.enable_secretsmanager_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.secretsmanager[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.secretsmanager_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.secretsmanager_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.secretsmanager_endpoint_private_dns_enabled
  policy              = var.secretsmanager_endpoint_policy
  tags                = merge(var.secretsmanager_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for SSM
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "ssm" {
  count = var.create && var.enable_ssm_endpoint ? 1 : 0

  service = "ssm"
}

resource "aws_vpc_endpoint" "ssm" {
  count = var.create && var.enable_ssm_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.ssm[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.ssm_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.ssm_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.ssm_endpoint_private_dns_enabled
  policy              = var.ssm_endpoint_policy
  tags                = merge(var.ssm_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for SSMMESSAGESC
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "ssmmessages" {
  count = var.create && var.enable_ssmmessages_endpoint ? 1 : 0

  service = "ssmmessages"
}

resource "aws_vpc_endpoint" "ssmmessages" {
  count = var.create && var.enable_ssmmessages_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.ssmmessages[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.ssmmessages_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.ssmmessages_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.ssmmessages_endpoint_private_dns_enabled
  policy              = var.ssmmessages_endpoint_policy
  tags                = merge(var.ssmmessages_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for EC2
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "ec2" {
  count = var.create && var.enable_ec2_endpoint ? 1 : 0

  service = "ec2"
}

resource "aws_vpc_endpoint" "ec2" {
  count = var.create && var.enable_ec2_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.ec2[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.ec2_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.ec2_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.ec2_endpoint_private_dns_enabled
  policy              = var.ec2_endpoint_policy
  tags                = merge(var.ec2_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for EC2MESSAGES
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "ec2messages" {
  count = var.create && var.enable_ec2messages_endpoint ? 1 : 0

  service = "ec2messages"
}

resource "aws_vpc_endpoint" "ec2messages" {
  count = var.create && var.enable_ec2messages_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.ec2messages[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.ec2messages_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.ec2messages_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.ec2messages_endpoint_private_dns_enabled
  policy              = var.ec2messages_endpoint_policy
  tags                = merge(var.ec2messages_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Auto Scaling Plans
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "auto_scaling_plans" {
  count = var.create && var.enable_autoscaling_plans_endpoint ? 1 : 0

  service = "autoscaling-plans"
}

resource "aws_vpc_endpoint" "auto_scaling_plans" {
  count = var.create && var.enable_autoscaling_plans_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.auto_scaling_plans[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = var.autoscaling_plans_endpoint_security_group_ids
  subnet_ids          = coalescelist(var.autoscaling_plans_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.autoscaling_plans_endpoint_private_dns_enabled

  tags = var.tags
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for EC2 Autoscaling
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "ec2_autoscaling" {
  count = var.create && var.enable_ec2_autoscaling_endpoint ? 1 : 0

  service = "autoscaling"
}

resource "aws_vpc_endpoint" "ec2_autoscaling" {
  count = var.create && var.enable_ec2_autoscaling_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.ec2_autoscaling[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.ec2_autoscaling_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.ec2_autoscaling_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.ec2_autoscaling_endpoint_private_dns_enabled
  policy              = var.ec2_autoscaling_endpoint_policy
  tags                = merge(var.ec2_autoscaling_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Transfer Server
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "transferserver" {
  count = var.create && var.enable_transferserver_endpoint ? 1 : 0

  service = "transfer.server"
}

resource "aws_vpc_endpoint" "transferserver" {
  count = var.create && var.enable_transferserver_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.transferserver[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.transferserver_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.transferserver_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.transferserver_endpoint_private_dns_enabled
  policy              = var.transferserver_endpoint_policy
  tags                = merge(var.transferserver_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for ECR API
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "ecr_api" {
  count = var.create && var.enable_ecr_api_endpoint ? 1 : 0

  service = "ecr.api"
}

resource "aws_vpc_endpoint" "ecr_api" {
  count = var.create && var.enable_ecr_api_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.ecr_api[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.ecr_api_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.ecr_api_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.ecr_api_endpoint_private_dns_enabled
  policy              = var.ecr_api_endpoint_policy
  tags                = merge(var.ecr_api_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for ECR DKR
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "ecr_dkr" {
  count = var.create && var.enable_ecr_dkr_endpoint ? 1 : 0

  service = "ecr.dkr"
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  count = var.create && var.enable_ecr_dkr_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.ecr_dkr[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.ecr_dkr_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.ecr_dkr_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.ecr_dkr_endpoint_private_dns_enabled
  policy              = var.ecr_dkr_endpoint_policy
  tags                = merge(var.ecr_dkr_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for API Gateway
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "apigw" {
  count = var.create && var.enable_apigw_endpoint ? 1 : 0

  service = "execute-api"
}

resource "aws_vpc_endpoint" "apigw" {
  count = var.create && var.enable_apigw_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.apigw[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.apigw_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.apigw_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.apigw_endpoint_private_dns_enabled
  policy              = var.apigw_endpoint_policy
  tags                = merge(var.apigw_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for KMS
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "kms" {
  count = var.create && var.enable_kms_endpoint ? 1 : 0

  service = "kms"
}

resource "aws_vpc_endpoint" "kms" {
  count = var.create && var.enable_kms_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.kms[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.kms_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.kms_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.kms_endpoint_private_dns_enabled
  policy              = var.kms_endpoint_policy
  tags                = merge(var.kms_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for ECS
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "ecs" {
  count = var.create && var.enable_ecs_endpoint ? 1 : 0

  service = "ecs"
}

resource "aws_vpc_endpoint" "ecs" {
  count = var.create && var.enable_ecs_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.ecs[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.ecs_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.ecs_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.ecs_endpoint_private_dns_enabled
  policy              = var.ecs_endpoint_policy
  tags                = merge(var.ecs_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for ECS Agent
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "ecs_agent" {
  count = var.create && var.enable_ecs_agent_endpoint ? 1 : 0

  service = "ecs-agent"
}

resource "aws_vpc_endpoint" "ecs_agent" {
  count = var.create && var.enable_ecs_agent_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.ecs_agent[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.ecs_agent_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.ecs_agent_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.ecs_agent_endpoint_private_dns_enabled
  policy              = var.ecs_agent_endpoint_policy
  tags                = merge(var.ecs_agent_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for ECS Telemetry
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "ecs_telemetry" {
  count = var.create && var.enable_ecs_telemetry_endpoint ? 1 : 0

  service = "ecs-telemetry"
}

resource "aws_vpc_endpoint" "ecs_telemetry" {
  count = var.create && var.enable_ecs_telemetry_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.ecs_telemetry[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.ecs_telemetry_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.ecs_telemetry_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.ecs_telemetry_endpoint_private_dns_enabled
  policy              = var.ecs_telemetry_endpoint_policy
  tags                = merge(var.ecs_telemetry_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for SNS
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "sns" {
  count = var.create && var.enable_sns_endpoint ? 1 : 0

  service = "sns"
}

resource "aws_vpc_endpoint" "sns" {
  count = var.create && var.enable_sns_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.sns[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.sns_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.sns_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.sns_endpoint_private_dns_enabled
  policy              = var.sns_endpoint_policy
  tags                = merge(var.sns_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for CloudWatch Monitoring
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "monitoring" {
  count = var.create && var.enable_monitoring_endpoint ? 1 : 0

  service = "monitoring"
}

resource "aws_vpc_endpoint" "monitoring" {
  count = var.create && var.enable_monitoring_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.monitoring[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.monitoring_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.monitoring_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.monitoring_endpoint_private_dns_enabled
  policy              = var.monitoring_endpoint_policy
  tags                = merge(var.monitoring_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for CloudWatch Logs
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "logs" {
  count = var.create && var.enable_logs_endpoint ? 1 : 0

  service = "logs"
}

resource "aws_vpc_endpoint" "logs" {
  count = var.create && var.enable_logs_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.logs[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.logs_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.logs_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.logs_endpoint_private_dns_enabled
  policy              = var.logs_endpoint_policy
  tags                = merge(var.logs_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for CloudWatch Events
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "events" {
  count = var.create && var.enable_events_endpoint ? 1 : 0

  service = "events"
}

resource "aws_vpc_endpoint" "events" {
  count = var.create && var.enable_events_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.events[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.events_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.events_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.events_endpoint_private_dns_enabled
  policy              = var.events_endpoint_policy
  tags                = merge(var.events_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Elastic Load Balancing
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "elasticloadbalancing" {
  count = var.create && var.enable_elasticloadbalancing_endpoint ? 1 : 0

  service = "elasticloadbalancing"
}

resource "aws_vpc_endpoint" "elasticloadbalancing" {
  count = var.create && var.enable_elasticloadbalancing_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.elasticloadbalancing[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.elasticloadbalancing_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.elasticloadbalancing_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.elasticloadbalancing_endpoint_private_dns_enabled
  policy              = var.elasticloadbalancing_endpoint_policy
  tags                = merge(var.elasticloadbalancing_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for CloudTrail
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "cloudtrail" {
  count = var.create && var.enable_cloudtrail_endpoint ? 1 : 0

  service = "cloudtrail"
}

resource "aws_vpc_endpoint" "cloudtrail" {
  count = var.create && var.enable_cloudtrail_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.cloudtrail[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.cloudtrail_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.cloudtrail_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.cloudtrail_endpoint_private_dns_enabled
  policy              = var.cloudtrail_endpoint_policy
  tags                = merge(var.cloudtrail_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Kinesis Streams
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "kinesis_streams" {
  count = var.create && var.enable_kinesis_streams_endpoint ? 1 : 0

  service = "kinesis-streams"
}

resource "aws_vpc_endpoint" "kinesis_streams" {
  count = var.create && var.enable_kinesis_streams_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.kinesis_streams[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.kinesis_streams_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.kinesis_streams_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.kinesis_streams_endpoint_private_dns_enabled
  policy              = var.kinesis_streams_endpoint_policy
  tags                = merge(var.kinesis_streams_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Kinesis Firehose
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "kinesis_firehose" {
  count = var.create && var.enable_kinesis_firehose_endpoint ? 1 : 0

  service = "kinesis-firehose"
}

resource "aws_vpc_endpoint" "kinesis_firehose" {
  count = var.create && var.enable_kinesis_firehose_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.kinesis_firehose[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.kinesis_firehose_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.kinesis_firehose_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.kinesis_firehose_endpoint_private_dns_enabled
  policy              = var.kinesis_firehose_endpoint_policy
  tags                = merge(var.kinesis_firehose_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Glue
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "glue" {
  count = var.create && var.enable_glue_endpoint ? 1 : 0

  service = "glue"
}

resource "aws_vpc_endpoint" "glue" {
  count = var.create && var.enable_glue_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.glue[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.glue_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.glue_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.glue_endpoint_private_dns_enabled
  policy              = var.glue_endpoint_policy
  tags                = merge(var.glue_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for SageMaker API
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "sagemaker_api" {
  count = var.create && var.enable_sagemaker_api_endpoint ? 1 : 0

  service = "sagemaker.api"
}

resource "aws_vpc_endpoint" "sagemaker_api" {
  count = var.create && var.enable_sagemaker_api_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.sagemaker_api[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.sagemaker_api_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.sagemaker_api_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.sagemaker_api_endpoint_private_dns_enabled
  policy              = var.sagemaker_api_endpoint_policy
  tags                = merge(var.sagemaker_api_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Sagemaker Notebooks
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "sagemaker_notebook" {
  count = var.create && var.enable_sagemaker_notebook_endpoint ? 1 : 0

  service_name = "aws.sagemaker.${var.sagemaker_notebook_endpoint_region}.notebook"
}

resource "aws_vpc_endpoint" "sagemaker_notebook" {
  count = var.create && var.enable_sagemaker_notebook_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.sagemaker_notebook[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.sagemaker_notebook_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.sagemaker_notebook_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.sagemaker_notebook_endpoint_private_dns_enabled
  policy              = var.sagemaker_notebook_endpoint_policy
  tags                = merge(var.sagemaker_notebook_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for SageMaker Runtime
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "sagemaker_runtime" {
  count = var.create && var.enable_sagemaker_runtime_endpoint ? 1 : 0

  service = "sagemaker.runtime"
}

resource "aws_vpc_endpoint" "sagemaker_runtime" {
  count = var.create && var.enable_sagemaker_runtime_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.sagemaker_runtime[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.sagemaker_runtime_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.sagemaker_runtime_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.sagemaker_runtime_endpoint_private_dns_enabled
  policy              = var.sagemaker_runtime_endpoint_policy
  tags                = merge(var.sagemaker_runtime_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for STS
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "sts" {
  count = var.create && var.enable_sts_endpoint ? 1 : 0

  service = "sts"
}

resource "aws_vpc_endpoint" "sts" {
  count = var.create && var.enable_sts_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.sts[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.sts_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.sts_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.sts_endpoint_private_dns_enabled
  policy              = var.sts_endpoint_policy
  tags                = merge(var.sts_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Cloudformation
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "cloudformation" {
  count = var.create && var.enable_cloudformation_endpoint ? 1 : 0

  service = "cloudformation"
}

resource "aws_vpc_endpoint" "cloudformation" {
  count = var.create && var.enable_cloudformation_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.cloudformation[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.cloudformation_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.cloudformation_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.cloudformation_endpoint_private_dns_enabled
  policy              = var.cloudformation_endpoint_policy
  tags                = merge(var.cloudformation_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for CodePipeline
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "codepipeline" {
  count = var.create && var.enable_codepipeline_endpoint ? 1 : 0

  service = "codepipeline"
}

resource "aws_vpc_endpoint" "codepipeline" {
  count = var.create && var.enable_codepipeline_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.codepipeline[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.codepipeline_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.codepipeline_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.codepipeline_endpoint_private_dns_enabled
  policy              = var.codepipeline_endpoint_policy
  tags                = merge(var.codepipeline_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for AppMesh
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "appmesh_envoy_management" {
  count = var.create && var.enable_appmesh_envoy_management_endpoint ? 1 : 0

  service = "appmesh-envoy-management"
}

resource "aws_vpc_endpoint" "appmesh_envoy_management" {
  count = var.create && var.enable_appmesh_envoy_management_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.appmesh_envoy_management[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.appmesh_envoy_management_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.appmesh_envoy_management_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.appmesh_envoy_management_endpoint_private_dns_enabled
  policy              = var.appmesh_envoy_management_endpoint_policy
  tags                = merge(var.appmesh_envoy_management_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Service Catalog
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "servicecatalog" {
  count = var.create && var.enable_servicecatalog_endpoint ? 1 : 0

  service = "servicecatalog"
}

resource "aws_vpc_endpoint" "servicecatalog" {
  count = var.create && var.enable_servicecatalog_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.servicecatalog[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.servicecatalog_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.servicecatalog_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.servicecatalog_endpoint_private_dns_enabled
  policy              = var.servicecatalog_endpoint_policy
  tags                = merge(var.servicecatalog_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Storage Gateway
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "storagegateway" {
  count = var.create && var.enable_storagegateway_endpoint ? 1 : 0

  service = "storagegateway"
}

resource "aws_vpc_endpoint" "storagegateway" {
  count = var.create && var.enable_storagegateway_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.storagegateway[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.storagegateway_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.storagegateway_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.storagegateway_endpoint_private_dns_enabled
  policy              = var.storagegatewat_endpoint_policy
  tags                = merge(var.storagegateway_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Transfer
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "transfer" {
  count = var.create && var.enable_transfer_endpoint ? 1 : 0

  service = "transfer"
}

resource "aws_vpc_endpoint" "transfer" {
  count = var.create && var.enable_transfer_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.transfer[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.transfer_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.transfer_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.transfer_endpoint_private_dns_enabled
  policy              = var.transfer_endpoint_policy
  tags                = merge(var.transfer_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for AppStream
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "appstream" {
  count = var.create && var.enable_appstream_endpoint ? 1 : 0

  service = "appstream"
}

resource "aws_vpc_endpoint" "appstream" {
  count = var.create && var.enable_appstream_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.appstream[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.appstream_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.appstream_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.appstream_endpoint_private_dns_enabled
  policy              = var.appstream_endpoint_policy
  tags                = merge(var.appstream_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Athena
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "athena" {
  count = var.create && var.enable_athena_endpoint ? 1 : 0

  service = "athena"
}

resource "aws_vpc_endpoint" "athena" {
  count = var.create && var.enable_athena_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.athena[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.athena_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.athena_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.athena_endpoint_private_dns_enabled
  policy              = var.athena_endpoint_policy
  tags                = merge(var.athena_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Rekognition
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "rekognition" {
  count = var.create && var.enable_rekognition_endpoint ? 1 : 0

  service = "rekognition"
}

resource "aws_vpc_endpoint" "rekognition" {
  count = var.create && var.enable_rekognition_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.rekognition[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.rekognition_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.rekognition_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.rekognition_endpoint_private_dns_enabled
  policy              = var.rekognition_endpoint_policy
  tags                = merge(var.rekognition_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for EFS
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "efs" {
  count = var.create && var.enable_efs_endpoint ? 1 : 0

  service = "elasticfilesystem"
}

resource "aws_vpc_endpoint" "efs" {
  count = var.create && var.enable_efs_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.efs[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.efs_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.efs_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.efs_endpoint_private_dns_enabled
  policy              = var.efs_endpoint_policy
  tags                = merge(var.efs_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Cloud Directory
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "cloud_directory" {
  count = var.create && var.enable_cloud_directory_endpoint ? 1 : 0

  service = "clouddirectory"
}

resource "aws_vpc_endpoint" "cloud_directory" {
  count = var.create && var.enable_cloud_directory_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.cloud_directory[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.cloud_directory_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.cloud_directory_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.cloud_directory_endpoint_private_dns_enabled
  policy              = var.cloud_directory_endpoint_policy
  tags                = merge(var.cloud_directory_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Workspaces
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "workspaces" {
  count = var.create && var.enable_workspaces_endpoint ? 1 : 0

  service = "workspaces"
}

resource "aws_vpc_endpoint" "workspaces" {
  count = var.create && var.enable_workspaces_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.workspaces[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.workspaces_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.workspaces_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.workspaces_endpoint_private_dns_enabled
  policy              = var.workspaces_endpoint_policy
  tags                = merge(var.workspaces_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Access Analyzer
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "access_analyzer" {
  count = var.create && var.enable_access_analyzer_endpoint ? 1 : 0

  service = "access-analyzer"
}

resource "aws_vpc_endpoint" "access_analyzer" {
  count = var.create && var.enable_access_analyzer_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.access_analyzer[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.access_analyzer_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.access_analyzer_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.access_analyzer_endpoint_private_dns_enabled
  policy              = var.access_analyzer_endpoint_policy
  tags                = merge(var.access_analyzer_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for EBS
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "ebs" {
  count = var.create && var.enable_ebs_endpoint ? 1 : 0

  service = "ebs"
}

resource "aws_vpc_endpoint" "ebs" {
  count = var.create && var.enable_ebs_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.ebs[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.ebs_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.ebs_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.ebs_endpoint_private_dns_enabled
  policy              = var.ebs_endpoint_policy
  tags                = merge(var.ebs_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Data Sync
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "datasync" {
  count = var.create && var.enable_datasync_endpoint ? 1 : 0

  service = "datasync"
}

resource "aws_vpc_endpoint" "datasync" {
  count = var.create && var.enable_datasync_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.datasync[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.datasync_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.datasync_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.datasync_endpoint_private_dns_enabled
  policy              = var.datasync_endpoint_policy
  tags                = merge(var.datasync_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Elastic Inference Runtime
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "elastic_inference_runtime" {
  count = var.create && var.enable_elastic_inference_runtime_endpoint ? 1 : 0

  service = "elastic-inference.runtime"
}

resource "aws_vpc_endpoint" "elastic_inference_runtime" {
  count = var.create && var.enable_elastic_inference_runtime_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.elastic_inference_runtime[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.elastic_inference_runtime_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.elastic_inference_runtime_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.elastic_inference_runtime_endpoint_private_dns_enabled
  policy              = var.elastic_inference_runtime_endpoint_policy
  tags                = merge(var.elastic_inference_runtime_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for SMS
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "sms" {
  count = var.create && var.enable_sms_endpoint ? 1 : 0

  service = "sms"
}

resource "aws_vpc_endpoint" "sms" {
  count = var.create && var.enable_sms_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.sms[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.sms_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.sms_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.sms_endpoint_private_dns_enabled
  policy              = var.sms_endpoint_policy
  tags                = merge(var.sms_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for EMR
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "emr" {
  count = var.create && var.enable_emr_endpoint ? 1 : 0

  service = "elasticmapreduce"
}

resource "aws_vpc_endpoint" "emr" {
  count = var.create && var.enable_emr_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.emr[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.emr_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.emr_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.emr_endpoint_private_dns_enabled
  policy              = var.emr_endpoint_policy
  tags                = merge(var.emr_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for QLDB Session
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "states" {
  count = var.create && var.enable_states_endpoint ? 1 : 0

  service = "states"
}

resource "aws_vpc_endpoint" "states" {
  count = var.create && var.enable_states_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.states[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.states_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.states_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.states_endpoint_private_dns_enabled
  policy              = var.states_endpoint_policy
  tags                = merge(var.states_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Elastic Beanstalk
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "elasticbeanstalk" {
  count = var.create && var.enable_elasticbeanstalk_endpoint ? 1 : 0

  service = "elasticbeanstalk"
}

resource "aws_vpc_endpoint" "elasticbeanstalk" {
  count = var.create && var.enable_elasticbeanstalk_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.elasticbeanstalk[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.elasticbeanstalk_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.elasticbeanstalk_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.elasticbeanstalk_endpoint_private_dns_enabled
  policy              = var.elasticbeanstalk_endpoint_policy
  tags                = merge(var.elasticbeanstalk_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for Elastic Beanstalk Health
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "elasticbeanstalk_health" {
  count = var.create && var.enable_elasticbeanstalk_health_endpoint ? 1 : 0

  service = "elasticbeanstalk.health"
}

resource "aws_vpc_endpoint" "elasticbeanstalk_health" {
  count = var.create && var.enable_elasticbeanstalk_health_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.elasticbeanstalk_health[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.elasticbeanstalk_health_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.elasticbeanstalk_health_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.elasticbeanstalk_health_endpoint_private_dns_enabled
  policy              = var.elasticbeanstalk_health_endpoint_policy
  tags                = merge(var.elasticbeanstalk_health_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for ACM PCA
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "acm_pca" {
  count = var.create && var.enable_acm_pca_endpoint ? 1 : 0

  service = "acm-pca"
}

resource "aws_vpc_endpoint" "acm_pca" {
  count = var.create && var.enable_acm_pca_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.acm_pca[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.acm_pca_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.acm_pca_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.acm_pca_endpoint_private_dns_enabled
  policy              = var.acm_pca_endpoint_policy
  tags                = merge(var.acm_pca_endpoint_tags, var.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Endpoint for SES
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "ses" {
  count = var.create && var.enable_ses_endpoint ? 1 : 0

  service = "email-smtp"
}

resource "aws_vpc_endpoint" "ses" {
  count = var.create && var.enable_ses_endpoint ? 1 : 0

  vpc_id            = aws_vpc.vpc[0].id
  service_name      = data.aws_vpc_endpoint_service.ses[0].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = coalescelist(var.all_interface_endpoints_security_group_ids, var.ses_endpoint_security_group_ids)
  subnet_ids          = coalescelist(var.all_interface_endpoints_subnet_ids, var.ses_endpoint_subnet_ids, local.private_subnet_ids)
  private_dns_enabled = var.ses_endpoint_private_dns_enabled
  policy              = var.ses_endpoint_policy
  tags                = merge(var.ses_endpoint_tags, var.tags)
}
