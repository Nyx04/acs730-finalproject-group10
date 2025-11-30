variable "project" {
  description = "The name of the project (e.g., 'myapp')."
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., 'dev', 'prod')."
  type        = string
}

variable "common_tags" {
  description = "A map of tags applied to all resources (e.g., Owner, Cost Center)."
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
  description = "The CIDR block for the entire VPC (e.g., '10.0.0.0/16')."
  type        = string
  default     = "10.0.0.0/16" # Corrected syntax
}

variable "azs" {
  description = "A list of Availability Zones to use for creating public and private subnets (e.g., ['us-east-1a', 'us-east-1b'])."
  type        = list(string)
}

variable "ami_id" {
  description = "The AMI ID for the Bastion Host EC2 instance (e.g., Amazon Linux 2)."
  type        = string
}

variable "instance_type" {
  description = "The instance type for the Bastion Host."
  type        = string
  default     = "t3.micro" # Corrected syntax
}

variable "key_pair_name" {
  description = "The name of the pre-existing EC2 Key Pair for Bastion SSH access."
  type        = string
}

variable "bastion_ssh_cidr" {
  description = "A list of CIDR blocks allowed to SSH into the Bastion Host (e.g., ['your.office.ip/32']). **RECOMMENDED: Keep this restricted.**"
  type        = list(string)
}