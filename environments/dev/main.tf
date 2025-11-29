terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    Owner       = var.owner
  }
}

module "network" {
  source      = "../../modules/networking"
  project     = var.project
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
  azs         = var.azs
  common_tags = local.common_tags
}

module "security_group" {
  source           = "../../modules/security_group"
  project          = var.project
  environment      = var.environment
  vpc_id           = module.network.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
  common_tags      = local.common_tags
}

module "iam" {
  source        = "../../modules/iam"
  project       = var.project
  environment   = var.environment
  #images_bucket = var.images_bucket
  #common_tags   = local.common_tags
}

module "launch" {
  source                  = "../../modules/launch_template"
  project                 = var.project
  instance_sg_id          = module.security_group.instance_security_group_id  
  vpc_id                  = module.network.vpc_id
  environment             = var.environment
  instance_type           = var.instance_type
  ami_id                  = var.ami_id
  subnet_ids              = module.network.public_subnets
  allowed_ssh_cidr        = var.allowed_ssh_cidr
  min_size                = var.min_asg
  max_size                = var.max_asg
  desired_capacity        = var.desired_capacity
  images_bucket           = var.images_bucket
  page_title              = var.page_title
  team_names              = var.team_names
  instance_profile_name   = module.iam.instance_profile_name
  security_group_ids      = [module.security_group.instance_sg_id]
  common_tags             = local.common_tags
}


module "alb" {
  source         = "../../modules/alb"
  project        = var.project
  environment    = var.environment
  public_subnets = module.network.public_subnets
  vpc_id         = module.network.vpc_id
  common_tags    = local.common_tags
  alb_sg_id = module.security_group.alb_security_group_id
}

module "autoscaling" {
  source                  = "../../modules/autoscaling"
  project                 = var.project
  environment             = var.environment
  min_size                = var.min_asg
  max_size                = var.max_asg
  subnet_ids              = module.network.public_subnets
  launch_template_id      = module.launch.launch_template_id
  launch_template_version = "$Latest"  
  target_group_arn        = module.alb.target_group_arn
  common_tags             = local.common_tags

  # Required variables
  instance_type           = var.instance_type       # <-- must be passed
  desired_capacity        = var.desired_capacity
  public_subnets          = module.network.public_subnets
}


output "alb_dns" {
  value = module.alb.alb_dns_name
}
