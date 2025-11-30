output "alb_dns_name" {
  description = "The DNS name of the Load Balancer."
  value       = aws_lb.this.dns_name
}

output "target_group_arn" {
  description = "The ARN of the default Target Group."
  value       = aws_lb_target_group.this.arn
}