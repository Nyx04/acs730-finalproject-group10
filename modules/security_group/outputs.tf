output "alb_security_group_id" {
  description = "The ID of the ALB Security Group"
  value       = aws_security_group.alb_sg.id
}

output "instance_security_group_id" {
  description = "The ID of the EC2 instance Security Group"
  value       = aws_security_group.instance_sg.id
}