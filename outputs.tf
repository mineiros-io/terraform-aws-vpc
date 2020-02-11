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
