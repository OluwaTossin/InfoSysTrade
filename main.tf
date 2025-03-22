terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.2.0"

  backend "s3" {
    bucket         = "d-terraform-state-bucket-271"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock" # deprecated but still functional
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

# -----------------------------------------
# VPC Module
# -----------------------------------------
module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = true
  enable_vpc_endpoints = true
}

# -----------------------------------------
# Security Module
# -----------------------------------------
module "security" {
  source  = "./modules/security"
  vpc_id  = module.vpc.vpc_id
  alb_arn = module.compute.alb_arn
}

# -----------------------------------------
# Compute Module
# -----------------------------------------
module "compute" {
  source          = "./modules/compute"
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  nat_gateway_id  = module.vpc.nat_gateway_id
  security_group  = module.security.web_sg_id
}

# -----------------------------------------
# Database Module
# -----------------------------------------
module "database" {
  source               = "./modules/database"
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnets
  security_group       = module.security.web_sg_id
  primary_rds_instance = true
  enable_read_replica  = true
  enable_cache_cluster = true
}

# -----------------------------------------
# Create Replica S3 Bucket (for Replication)
# -----------------------------------------
resource "aws_s3_bucket" "replica_bucket" {
  bucket = "info-sys-trade-replica"
  acl    = "private"

  tags = {
    Name = "Replica Bucket"
  }
}

# Enable versioning on replica bucket
resource "aws_s3_bucket_versioning" "replica_versioning" {
  bucket = aws_s3_bucket.replica_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# -----------------------------------------
# Storage Module
# -----------------------------------------
module "storage" {
  source                 = "./modules/storage"
  bucket_name            = "info-sys-trade-assets"
  enable_cloudfront      = true
  enable_s3_replication  = true
  replica_bucket_arn     = aws_s3_bucket.replica_bucket.arn

  depends_on = [aws_s3_bucket_versioning.replica_versioning]
}

# -----------------------------------------
# Monitoring & Logging
# -----------------------------------------
module "monitoring" {
  source = "./modules/monitoring"
  vpc_id = module.vpc.vpc_id
}
