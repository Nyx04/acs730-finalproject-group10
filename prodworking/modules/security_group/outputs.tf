output "bastion_sg_id" {
  description = "ID of the Bastion Host Security Group."
  value       = aws_security_group.bastion_sg.id
}

output "alb_sg_id" {
  description = "ID of the ALB Security Group."
  value       = aws_security_group.alb_sg.id
}

output "app_sg_id" {
  description = "ID of the Application Security Group."
  value       = aws_security_group.app_sg.id
}