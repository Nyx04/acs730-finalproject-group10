variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "alb_sg_id" {
  description = "The ID of the pre-existing ALB Security Group"
  type        = string
}