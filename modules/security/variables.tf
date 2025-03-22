variable "vpc_id" {
  description = "The ID of the VPC to associate with the security group"
  type        = string
}

variable "alb_arn" {
  description = "The ARN of the Application Load Balancer to associate with AWS WAF"
  type        = string
}
