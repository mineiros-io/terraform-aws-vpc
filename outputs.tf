output "vpc_id" {
  value = try(aws_vpc.vpc[0].id, null)
}

output "vpc_name" {
  value = var.vpc_name
}

output "vpc_cidr_block" {
  value = try(aws_vpc.vpc[0].cidr_block, null)
}

output "public_subnets_cidr_blocks" {
  value = [for subnet in aws_subnet.public : subnet.cidr_block]
}

output "private_subnets_cidr_blocks" {
  value = [for subnet in aws_subnet.private : subnet.cidr_block]
}

output "public_subnet_route_table_id" {
  value = try(aws_route_table.public[0].id, null)
}

output "private_subnet_route_table_ids" {
  value = [for route_table in aws_route_table.private : route_table.id]
}

output "full_vpc" {
  description = "The full VPC object."
  value       = try(aws_vpc.vpc[0], {})
}

output "public_subnets" {
  value = aws_subnet.public
}

output "private_subnets" {
  value = aws_subnet.private
}

output "nat_gateways" {
  value = aws_nat_gateway.nat
}
