variable "project" {}
variable "environment" {}
variable "instance_type" {}
variable "ami_id" {}
variable "allowed_ssh_cidr" {}
variable "desired_capacity" {
  type    = number
  default = 2
}
variable "page_title" {}
variable "team_names" {}
variable "images_bucket" {}
variable "min_asg" {
  type    = number
  default = 1
}
variable "max_asg" {
  type    = number
  default = 4
}
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "owner" {
  type    = string
  default = "your-name"
}

variable "vpc_cidr" {
  type    = string
}

variable "azs" {
  type    = list(string)
}