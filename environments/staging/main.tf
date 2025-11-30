

provider "aws" {
  region = var.region
}

locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 1. NETWORKING Infrastructure (VPC, Subnets, SG, NAT GW, Bastion)
module "networking" {
  source               = "../../modules/networking" # The folder name can still be 'vpc' even if the module name is 'networking'
  project              = var.project
  environment          = var.environment
  common_tags          = local.common_tags
  azs                  = var.azs
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  key_pair_name        = var.key_pair_name
  bastion_ssh_cidr     = var.bastion_ssh_cidr
}

# 2. ALB (Uses Public Subnets and ALB SG)
module "alb" {
  source              = "../../modules/alb"
  project             = var.project
  environment         = var.environment
  common_tags         = local.common_tags
  vpc_id              = module.networking.vpc_id # Changed from module.vpc
  public_subnet_ids   = module.networking.public_subnet_ids # Changed from module.vpc
  alb_sg_id           = module.networking.security_group_ids["alb_sg_id"] # Changed from module.vpc
}

# 3. Auto Scaling Group (Uses Private Subnets and App SG)
module "autoscaling" {
  source                     = "../../modules/autoscaling"
  project                    = var.project
  environment                = var.environment
  images_bucket = var.images_bucket
  team_names    = var.team_names
  common_tags                = local.common_tags
  private_subnet_ids         = module.networking.private_subnet_ids # Changed from module.vpc
  app_sg_id                  = module.networking.security_group_ids["app_sg_id"] # Changed from module.vpc
  target_group_arn           = module.alb.target_group_arn
  ami_id                     = var.ami_id
  instance_type              = var.instance_type
  key_pair_name              = var.key_pair_name
  iam_instance_profile_arn   = var.iam_instance_profile_arn 
}
