output "bucket_name" {
  description = "Name of the S3 bucket for static assets"
  value       = aws_s3_bucket.static_assets.bucket
}

output "cloudfront_url" {
  description = "URL of the CloudFront distribution"
  value       = aws_cloudfront_distribution.cdn[0].domain_name
  condition   = var.enable_cloudfront
}
