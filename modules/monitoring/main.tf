resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "trail_bucket" {
  bucket        = "cloudtrail-logs-monitoring-${random_id.bucket_id.hex}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "trail_bucket_block" {
  bucket = aws_s3_bucket.trail_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudtrail" "trail" {
  name                          = "cloudtrail-monitoring"
  s3_bucket_name                = aws_s3_bucket.trail_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
}

resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/aws/app/monitoring"
  retention_in_days = 30
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "application-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x = 0,
        y = 0,
        width = 24,
        height = 6,
        properties = {
          metrics = [
            [ "AWS/EC2", "CPUUtilization", "InstanceId", "i-0123456789abcdef0" ]
          ],
          period = 300,
          stat   = "Average",
          region = "us-east-1",
          title  = "EC2 CPU Utilization"
        }
      }
    ]
  })
}
