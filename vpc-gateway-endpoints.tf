# ---------------------------------------------------------------------------------------------------------------------
# VPC GATEWAY ENDPOINTS
#
# A VPC endpoint enables you to privately connect your VPC to supported AWS services and VPC endpoint services powered
# by AWS PrivateLink without requiring an internet gateway, NAT device, VPN connection,
# or AWS Direct Connect connection. Instances in your VPC do not require public IP addresses to communicate with
# resources in the service. Traffic between your VPC and the other service does not leave the Amazon network.
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# VPC Gateway Endpoint for S3
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "s3" {
  count = var.create && var.enable_s3_endpoint ? 1 : 0

  service = "s3"
}

resource "aws_vpc_endpoint" "s3" {
  count = var.create && var.enable_s3_endpoint ? 1 : 0

  vpc_id       = aws_vpc.vpc[0].id
  service_name = data.aws_vpc_endpoint_service.s3[0].service_name
  tags         = var.tags
}

resource "aws_vpc_endpoint_route_table_association" "s3_public" {
  count = var.create && var.enable_s3_endpoint && length(aws_subnet.public) > 0 ? 1 : 0

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = aws_route_table.public[0].id
}

resource "aws_vpc_endpoint_route_table_association" "s3_private" {
  for_each = var.create && var.enable_s3_endpoint ? aws_subnet.private : {}

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = aws_route_table.private[each.key].id
}

resource "aws_vpc_endpoint_route_table_association" "s3_intra" {
  for_each = var.create && var.enable_s3_endpoint ? aws_subnet.intra : {}

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = aws_route_table.intra[each.key].id
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Gateway Endpoint for DynamoDB
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc_endpoint_service" "dynamodb" {
  count = var.create && var.enable_dynamodb_endpoint ? 1 : 0

  service = "dynamodb"
}
resource "aws_vpc_endpoint" "dynamodb" {
  count = var.create && var.enable_dynamodb_endpoint ? 1 : 0

  vpc_id       = aws_vpc.vpc[0].id
  service_name = data.aws_vpc_endpoint_service.dynamodb[0].service_name
  tags         = var.tags
}

resource "aws_vpc_endpoint_route_table_association" "dynamodb_public" {
  count = var.create && var.enable_dynamodb_endpoint && length(var.public_subnets) > 0 ? 1 : 0

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
  route_table_id  = aws_route_table.public[0].id
}

resource "aws_vpc_endpoint_route_table_association" "dynamodb_private" {
  for_each = var.create && var.enable_dynamodb_endpoint ? aws_subnet.private : {}

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
  route_table_id  = aws_route_table.private[each.key].id
}

resource "aws_vpc_endpoint_route_table_association" "dynamodb_intra" {
  for_each = var.create && var.enable_dynamodb_endpoint ? aws_subnet.intra : {}

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
  route_table_id  = aws_route_table.intra[each.key].id

}
