variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "subnet_ids" {
  type = list(string)
}
variable "launch_template_version" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "launch_template_id" {
  description = "The ID of the Launch Template to use for the ASG."
  type        = string
}

variable "desired_capacity" {}
variable "public_subnets" {
  description = "List of public subnet IDs to launch ASG instances into"
  type        = list(string) # Must be defined as a list
}