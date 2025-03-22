variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "security_group" {
  description = "Security group ID for database and cache access"
  type        = string
}

variable "primary_rds_instance" {
  description = "Flag to create the primary RDS instance"
  type        = bool
}

variable "enable_read_replica" {
  description = "Enable RDS read replica"
  type        = bool
}

variable "enable_cache_cluster" {
  description = "Enable ElastiCache cluster"
  type        = bool
}
