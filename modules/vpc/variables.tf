variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Enable or disable the NAT Gateway"
  type        = bool
  default     = false
}

variable "enable_vpc_endpoints" {
  description = "Enable or disable VPC endpoints (optional feature)"
  type        = bool
  default     = false
}
