output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "List of IDs for public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "List of IDs for private subnets"
  value       = aws_subnet.private[*].id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway (if created)"
  value       = var.enable_nat_gateway ? aws_nat_gateway.nat[0].id : null
}

output "db_subnet_group" {
  description = "Subnet group used for RDS database instances"
  value       = aws_subnet.private[*].id
}
