resource "aws_s3_bucket" "static_assets" {
  bucket = "my-static-assets-bucket"
  acl    = "private"

  tags = {
    Name = "static-assets"
  }
}
