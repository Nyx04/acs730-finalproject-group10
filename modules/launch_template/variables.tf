# Basic identifiers
variable "project" {}
variable "environment" {}

# EC2 configuration
variable "instance_type" {}
variable "ami_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "allowed_ssh_cidr" {}

# Auto Scaling (optional defaults)
variable "min_size" {
  type    = number
  default = 1
}
variable "max_size" {
  type    = number
  default = 4
}
variable "desired_capacity" {
  type    = number
  default = 1
}

# Web page / S3
variable "images_bucket" {}
variable "page_title" {}
variable "team_names" {}

# IAM / Security
variable "instance_profile_name" {
  description = "The name of the IAM Instance Profile to attach to the EC2 Launch Template."
  type        = string
}
variable "security_group_ids" {
  type    = list(string)
  default = []
}

# Optional tags
variable "common_tags" {
  type    = map(string)
  default = {}
}

variable "vpc_id" {}

variable "instance_sg_id" {
  description = "The ID of the pre-created EC2 instance security group."
  type        = string
}