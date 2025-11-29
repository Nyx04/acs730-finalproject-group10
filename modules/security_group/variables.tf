variable "project" {
  type = string
}

variable "environment" {
  type = string
}

# In ../modules/security_group/variables.tf
variable "alb_security_group_id" {
  description = "The ID of the ALB Security Group (Optional reference)."
  type        = string
  # Set a default value to make it optional.
  default     = null 
}

variable "vpc_id" {
  type = string
}

variable "allowed_ssh_cidr" {
  type = string
}

variable "common_tags" {
  type = map(string)
}
