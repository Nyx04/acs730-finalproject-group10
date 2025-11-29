variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "min_asg" {
  type = number
}

variable "max_asg" {
  type = number
}

variable "images_bucket" {
  type = string
}

variable "team_names" {
  type = string
}

variable "owner" {
  type = string
}

variable "project" {
  type = string
}

variable "allowed_ssh_cidr" {
  type = string
}
