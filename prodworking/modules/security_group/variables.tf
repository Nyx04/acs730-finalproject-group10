#
# Module Input Variables
#

# --- Naming and Environment Variables ---

variable "project" {
  description = "The name of the project (e.g., 'acme-web'). Used for resource naming."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'staging', 'prod'). Used for resource naming."
  type        = string
}

# --- Networking Variables ---

variable "vpc_id" {
  description = "The ID of the VPC where the security groups will be created."
  type        = string
}

variable "bastion_ssh_cidr" {
  description = "A list of CIDR blocks that are allowed to SSH (Port 22) into the Bastion Host."
  type        = list(string)
}

# --- Tagging Variables ---

variable "common_tags" {
  description = "A map of tags to apply to all resources, typically including Cost Center, Owner, etc."
  type        = map(string)
  default     = {}
}