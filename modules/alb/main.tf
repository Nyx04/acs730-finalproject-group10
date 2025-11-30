resource "aws_lb" "this" {
  name               = "${var.project}-${var.environment}-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids # ALB is public, so use public subnets

  tags = merge(var.common_tags, { Name = "${var.project}-${var.environment}-ALB" })
}

resource "aws_lb_target_group" "this" {
  name     = "${var.project}-${var.environment}-TG"
  port     = 8080 # Application listening port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
  path                = "/"          # Path your app responds to
  port                = "traffic-port" # Uses target group port (8080)
  protocol            = "HTTP"
  interval            = 30            # seconds between checks
  timeout             = 5             # seconds before timeout
  healthy_threshold   = 2             # # of successes to mark healthy
  unhealthy_threshold = 2             # # of failures to mark unhealthy
}
  tags = merge(var.common_tags, { Name = "${var.project}-${var.environment}-TG" })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
