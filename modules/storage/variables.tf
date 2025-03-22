variable "bucket_name" {
  description = "Name of the primary S3 bucket for static assets"
  type        = string
}

variable "enable_cloudfront" {
  description = "Enable CloudFront distribution"
  type        = bool
  default     = false
}

variable "enable_s3_replication" {
  description = "Enable cross-region replication for S3"
  type        = bool
  default     = false
}

variable "replica_bucket_arn" {
  description = "ARN of the destination bucket for S3 replication"
  type        = string
  default     = ""
}
