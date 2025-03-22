# Main Terraform configuration to deploy the AWS Cloud Architecture

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.2.0"

  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock" # still works but is deprecated
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
# Security Module (IAM, Security Groups, WAF)
# -----------------------------------------
module "security" {
  source  = "./modules/security"
  vpc_id  = module.vpc.vpc_id
  alb_arn = module.compute.alb_arn
}

# -----------------------------------------
# Compute Module (ALB, ASG, EC2, NAT Gateway)
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
# Database Module (RDS, Read Replicas, Redis)
# -----------------------------------------
module "database" {
  source               = "./modules/database"
  vpc_id               = module.vpc.vpc_id
  db_subnet_group      = module.vpc.db_subnet_group
  primary_rds_instance = true
  enable_read_replica  = true
  enable_cache_cluster = true
}

# -----------------------------------------
# Storage Module (S3 Buckets, CloudFront, Route 53)
# -----------------------------------------
module "storage" {
  source                = "./modules/storage"
  enable_cloudfront     = true
  enable_s3_replication = true
}

# -----------------------------------------
# Monitoring & Logging (CloudWatch, CloudTrail)
# -----------------------------------------
module "monitoring" {
  source = "./modules/monitoring"
  vpc_id = module.vpc.vpc_id
}
