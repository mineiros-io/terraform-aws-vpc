# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN EXAMPLE VPC WITH SUBNETS, INTERNET- AND NAT GATEWAYS
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../.."

  create = true

  vpc_name            = "Test"
  cidr_block          = "10.0.0.0/16"
  create_nat_gateways = "one_per_az"

  public_subnets = [
    {
      availability_zone = "us-east-1a",
      cidr_block        = "10.0.64.0/21",
    },
    {
      availability_zone = "us-east-1a",
      cidr_block        = "10.0.80.0/21",
    },
    {
      availability_zone = "us-east-1b",
      cidr_block        = "10.0.96.0/21",
    }
  ]

  private_subnets = [
    {
      availability_zone = "us-east-1a",
      cidr_block        = "10.0.112.0/21",
    },
    {
      availability_zone = "us-east-1b",
      cidr_block        = "10.0.128.0/21",
    },
    {
      availability_zone = "us-east-1c",
      cidr_block        = "10.0.144.0/21",
    }
  ]

  intra_subnets = [
    {
      availability_zone = "us-east-1a",
      cidr_block        = "10.0.160.0/21",
    },
    {
      availability_zone = "us-east-1b",
      cidr_block        = "10.0.176.0/21",
    }
  ]

  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = true

  #  all_interface_endpoints_security_group_ids = []

  # Interface Endpoints will cause additional costs

  # Not supported in us-east-1
  enable_transferserver_endpoint            = false
  enable_appstream_endpoint                 = false
  enable_elasticbeanstalk_health_endpoint   = false
  enable_transfer_endpoint                  = false
  enable_elastic_inference_runtime_endpoint = false
  enable_ses_endpoint                       = false

  enable_codebuild_endpoint             = true
  codebuild_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_codecommit_endpoint             = true
  codecommit_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_git_codecommit_endpoint             = true
  git_codecommit_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_config_endpoint             = true
  config_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_sqs_endpoint             = true
  sqs_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_secretsmanager_endpoint             = true
  secretsmanager_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_ssm_endpoint             = true
  ssm_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_ssmmessages_endpoint             = true
  ssmmessages_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_ec2_endpoint             = true
  ec2_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_ec2messages_endpoint             = true
  ec2messages_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_autoscaling_plans_endpoint             = true
  autoscaling_plans_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_ec2_autoscaling_endpoint             = true
  ec2_autoscaling_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_ecr_api_endpoint             = true
  ecr_api_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_ecr_dkr_endpoint             = true
  ecr_dkr_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_apigw_endpoint             = true
  apigw_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_kms_endpoint             = true
  kms_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_ecs_endpoint             = true
  ecs_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_ecs_agent_endpoint             = true
  ecs_agent_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_ecs_telemetry_endpoint             = true
  ecs_telemetry_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_sns_endpoint             = true
  sns_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_monitoring_endpoint             = true
  monitoring_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_logs_endpoint             = true
  logs_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_events_endpoint             = true
  events_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_elasticloadbalancing_endpoint             = true
  elasticloadbalancing_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_cloudtrail_endpoint             = true
  cloudtrail_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_kinesis_streams_endpoint             = true
  kinesis_streams_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_kinesis_firehose_endpoint             = true
  kinesis_firehose_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_glue_endpoint             = true
  glue_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_sagemaker_notebook_endpoint             = true
  sagemaker_notebook_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_sts_endpoint                = true
  sts_endpoint_security_group_ids    = [aws_security_group.vpc_interface_endpoints.id]
  sagemaker_notebook_endpoint_region = "us-east-1"

  enable_cloudformation_endpoint             = true
  cloudformation_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_codepipeline_endpoint             = true
  codepipeline_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_appmesh_envoy_management_endpoint             = true
  appmesh_envoy_management_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_servicecatalog_endpoint             = true
  servicecatalog_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_storagegateway_endpoint             = true
  storagegateway_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_sagemaker_api_endpoint             = true
  sagemaker_api_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_sagemaker_runtime_endpoint             = true
  sagemaker_runtime_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_athena_endpoint             = true
  athena_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_efs_endpoint             = true
  efs_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_cloud_directory_endpoint             = true
  cloud_directory_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_ebs_endpoint             = true
  ebs_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_datasync_endpoint             = true
  datasync_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_sms_endpoint             = true
  sms_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_emr_endpoint             = true
  emr_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_qldb_session_endpoint             = true
  qldb_session_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_elasticbeanstalk_endpoint             = true
  elasticbeanstalk_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_states_endpoint             = true
  states_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  enable_acm_pca_endpoint             = true
  acm_pca_endpoint_security_group_ids = [aws_security_group.vpc_interface_endpoints.id]

  tags = {
    "Bob" = "Alice"
  }
}

resource "aws_security_group" "vpc_interface_endpoints" {
  name        = "example_security_group"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id
}
