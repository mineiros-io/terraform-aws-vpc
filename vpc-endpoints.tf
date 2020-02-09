# ---------------------------------------------------------------------------------------------------------------------
# SETUP VPC GATEWAY Endpoints
# A gateway endpoint is a gateway that you specify as a target for a route in your route table for traffic destined to a
# supported AWS service. VPC Endpoints ensure that Traffic between your VPC and the other service does not leave the
# Amazon network. The following AWS services are supported:
# - Amazon S3
# - DynamoDB
# ---------------------------------------------------------------------------------------------------------------------

# ToDo: creation of aws_vpc_endpoints should be handled dynamically for all subnets
resource "aws_vpc_endpoint" "s3" {
  count = var.create && length(local.public_subnets) > 0 ? 1 : 0

  service_name = "com.amazonaws.${var.aws_region}.s3"
  vpc_id       = local.vpc_id

  route_table_ids = concat(
    [aws_route_table.public[0].id],
  )

  tags = merge(
    { Name = "${var.vpc_name}-vpc-s3-endpoint" },
    var.endpoint_tags,
    var.tags
  )
}

resource "aws_vpc_endpoint" "dynamodb" {
  count = var.create && length(local.public_subnets) > 0 ? 1 : 0

  vpc_id       = local.vpc_id
  service_name = "com.amazonaws.${var.aws_region}.dynamodb"

  route_table_ids = concat(
    [aws_route_table.public[0].id],
  )

  tags = merge(
    { Name = "${var.vpc_name}-vpc-dynamodb-endpoint" },
    var.endpoint_tags,
    var.tags
  )
}
