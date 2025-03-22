variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  type        = string
}

variable "security_group" {
  description = "The ID of the security group"
  type        = string
}
