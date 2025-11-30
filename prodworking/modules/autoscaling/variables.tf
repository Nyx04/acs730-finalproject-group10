variable "project" {
  description = "The name of the project (e.g., 'MyWebProject')."
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., 'dev', 'prod')."
  type        = string
}
variable "images_bucket" {
  description = "S3 bucket name for images"
  type        = string
}

variable "team_names" {
  description = "Team names to display on the webpage"
  type        = string
}


variable "common_tags" {
  description = "A map of common tags to apply to all ASG and Launch Template resources."
  type        = map(string)
}

variable "private_subnet_ids" {
  description = "A list of Private Subnet IDs where ASG instances will be launched (for high availability)."
  type        = list(string)
}

variable "app_sg_id" {
  description = "The ID of the Security Group applied to the application instances."
  type        = string
}

variable "target_group_arn" {
  description = "The ARN of the Application Load Balancer (ALB) Target Group that the ASG should register instances with."
  type        = string
}

variable "ami_id" {
  description = "The AMI ID (Image ID) to use for the EC2 instances in the Launch Template."
  type        = string
}

variable "instance_type" {
  description = "The size of the EC2 instances (e.g., 't3.medium') used in the Launch Template."
  type        = string
}

variable "key_pair_name" {
  description = "The name of the pre-existing SSH Key Pair for accessing the instances (optional, but standard for troubleshooting)."
  type        = string
}

variable "iam_instance_profile_arn" {
  description = "The ARN of the IAM Instance Profile to attach to the instances, granting them necessary AWS permissions (e.g., S3 access)."
  type        = string
}