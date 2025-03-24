output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "Public DNS name of the Application Load Balancer"
  value       = module.compute.alb_dns_name
}

output "rds_endpoint" {
  description = "Endpoint of the RDS database"
  value       = module.database.rds_endpoint
}

output "static_assets_bucket_name" {
  description = "Name of the S3 bucket used for artifact upload"
  value       = module.storage.bucket_name
}

output "cloudfront_url" {
  description = "URL of the CloudFront distribution"
  value       = module.storage.cloudfront_url
}

output "nat_gateway_id" {
  description = "ID of the created NAT Gateway"
  value       = module.vpc.nat_gateway_id
}

output "monitoring_dashboard_url" {
  description = "URL of the CloudWatch Monitoring Dashboard"
  value       = module.monitoring.dashboard_url
}
