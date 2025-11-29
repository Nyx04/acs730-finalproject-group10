variable "project" {
  description = "The name of the project (e.g., 'myapp')."
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., 'dev', 'prod')."
  type        = string
}

variable "common_tags" {
  description = "A map of common tags to apply to all resources."
  type        = map(string)
}

variable "vpc_id" {
  description = "The ID of the VPC where the ALB will be deployed."
  type        = string
}

variable "public_subnet_ids" {
  description = "A list of Public Subnet IDs for the ALB to reside in (for multi-AZ HA)."
  type        = list(string)
}

variable "alb_sg_id" {
  description = "The ID of the Security Group assigned to the Application Load Balancer."
  type        = string
}