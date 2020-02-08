# ---------------------------------------------------------------------------------------------------------------------
# SETUP VPC GATEWAY Endpoints
# A gateway endpoint is a gateway that you specify as a target for a route in your route table for traffic destined to a
# supported AWS service. VPC Endpoints ensure that Traffic between your VPC and the other service does not leave the
# Amazon network. The following AWS services are supported:
# - Amazon S3
# - DynamoDB
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_vpc_endpoint" "s3" {
  service_name = "com.amazonaws.${var.aws_region}.s3"
  vpc_id       = aws_vpc.vpc.id

  route_table_ids = concat(
    [aws_route_table.public.id],
  )

  tags = merge(
    { Name = "${var.vpc_name}-vpc-s3-endpoint" }, var.tags
  )
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.aws_region}.dynamodb"

  route_table_ids = concat(
    [aws_route_table.public.id],
  )

  tags = merge(
    { Name = "${var.vpc_name}-vpc-dynamodb-endpoint" },
    var.endpoint_tags,
    var.tags
  )
}
