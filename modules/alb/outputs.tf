output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.tg.arn
}

output "alb_security_group_id" {
  description = "The ID of the ALB Security Group passed into this module"
  # Reference the variable that was passed into the module
  value       = var.alb_sg_id 
}