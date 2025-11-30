output "alb_endpoint" {
  description = "The DNS name of the Application Load Balancer."
  value       = module.alb.alb_dns_name
}

output "bastion_ssh_command" {
  description = "Example command to SSH into the Bastion Host."
  value       = "ssh -i ~/.ssh/${var.key_pair_name}.pem ec2-user@${module.networking.bastion_public_ip}" # Changed from module.vpc
}

output "vpc_id" {
  description = "The ID of the created VPC."
  value       = module.networking.vpc_id # Changed from module.vpc
}
