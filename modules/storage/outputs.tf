output "bucket_name" {
  description = "Name of the generated S3 bucket with random suffix"
  value       = aws_s3_bucket.static_assets.bucket
}

output "cloudfront_url" {
  description = "URL of the CloudFront distribution (if enabled)"
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.cdn[0].domain_name : null
}
