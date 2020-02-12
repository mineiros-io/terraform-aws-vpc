output "create" {
  description = "Whether or not to create the VPC its associated resources."
  value       = var.create
}

output "vpc_id" {
  description = "The ID of the VPC."
  value       = try(aws_vpc.vpc[0].id, null)
}

output "vpc_name" {
  description = "The name of the VPC."
  value       = var.vpc_name
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC."
  value       = try(aws_vpc.vpc[0].cidr_block, null)
}

output "public_subnets_cidr_blocks" {
  description = "A list of CIDR Blocks of the public subnets."
  value       = [for subnet in aws_subnet.public : subnet.cidr_block]
}

output "private_subnets_cidr_blocks" {
  description = "A list of CIDR Blocks of the private subnets."
  value       = [for subnet in aws_subnet.private : subnet.cidr_block]
}

output "intra_subnets_cidr_blocks" {
  description = "A list of CIDR Blocks of the intra subnets."
  value       = [for subnet in aws_subnet.intra : subnet.cidr_block]
}

output "public_subnet_route_table_id" {
  description = "The ID of the public subnet route table."
  value       = try(aws_route_table.public[0].id, null)
}

output "private_subnet_route_table_ids" {
  description = "A list of IDs of the private subnet route tables."
  value       = [for route_table in aws_route_table.private : route_table.id]
}

output "intra_subnet_route_table_ids" {
  description = "A list of IDs of the intra subnet route tables."
  value       = [for route_table in aws_route_table.intra : route_table.id]
}

output "full_vpc" {
  description = "The full VPC object."
  value       = try(aws_vpc.vpc[0], {})
}

output "public_subnets" {
  description = "A map that contains all public subnets."
  value       = aws_subnet.public
}

output "private_subnets" {
  description = "A map that contains all private subnets."
  value       = aws_subnet.private
}

output "intra_subnets" {
  description = "A map that contains all intra subnets."
  value       = aws_subnet.intra
}

output "nat_gateways" {
  description = "A map that contains all NAT Gateways."
  value       = aws_nat_gateway.nat
}

output "nat_gateway_public_ips" {
  description = "A list of public IP Addresses associated with the NAT Gateways."
  value       = [for eip in aws_eip.nat : eip.public_ip]
}
