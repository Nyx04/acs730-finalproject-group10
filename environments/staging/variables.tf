variable "project" {
  description = "Project name."
  type        = string
  default     = "MyWebProject"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "staging"
}

variable "region" {
  description = "AWS Region."
  type        = string
  default     = "us-east-1"
}

variable "azs" {
  description = "List of AZs to use."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "instance_type" {
  description = "Instance type for ASG and Bastion."
  type        = string
  default     = "t3.micro"
}

variable "key_pair_name" {
  description = "SSH Key Pair name."
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instances (e.g., Amazon Linux 2)."
  type        = string
}

variable "bastion_ssh_cidr" {
  description = "CIDR block for Bastion SSH access."
  type        = list(string)
  default     = ["0.0.0.0/0"] # REPLACE with your actual IP or a safe range
}

variable "iam_instance_profile_arn" {
  description = "ARN of the IAM Instance Profile for ASG instances."
  type        = string # This should come from your IAM module
}

variable "images_bucket" {
  description = "S3 bucket name for images"
  type        = string
}

variable "team_names" {
  description = "Team names to display on the webpage"
  type        = string
}