resource "aws_s3_bucket" "static_assets" {
  bucket = var.bucket_name
  acl    = "private"

  tags = {
    Name = "static-assets"
  }
}

# Optional CloudFront Distribution
resource "aws_cloudfront_distribution" "cdn" {
  count = var.enable_cloudfront ? 1 : 0

  origin {
    domain_name = aws_s3_bucket.static_assets.bucket_regional_domain_name
    origin_id   = "s3-origin"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-origin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "cloudfront-cdn"
  }
}

# Optional Cross-Region Replication (simplified version)
resource "aws_s3_bucket_replication_configuration" "replication" {
  count = var.enable_s3_replication ? 1 : 0

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.static_assets.id

  rules {
    id     = "replication-rule"
    status = "Enabled"

    destination {
      bucket = var.replica_bucket_arn
    }
  }
}

resource "aws_iam_role" "replication" {
  count = var.enable_s3_replication ? 1 : 0

  name = "s3-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "s3.amazonaws.com"
      }
    }]
  })
}
