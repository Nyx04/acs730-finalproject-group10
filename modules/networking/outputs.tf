output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "A list of Public Subnet IDs."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "A list of Private Subnet IDs."
  value       = aws_subnet.private[*].id
}

output "bastion_public_ip" {
  description = "The public IP address of the Bastion Host."
  value       = aws_instance.bastion.public_ip
}

output "security_group_ids" {
  description = "Map of all security group IDs created by the SG module."
  value = {
    alb_sg_id     = module.security_groups.alb_sg_id
    app_sg_id     = module.security_groups.app_sg_id
    bastion_sg_id = module.security_groups.bastion_sg_id
  }
}
