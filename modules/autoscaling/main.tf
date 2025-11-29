resource "aws_autoscaling_group" "asg" {
  name                = "${var.project}-${var.environment}-asg"
  max_size            = var.max_size
  min_size            = var.min_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.public_subnets
  wait_for_capacity_timeout = "15m"
  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project}-${var.environment}-ASG"
    propagate_at_launch = true
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300
}


resource "aws_autoscaling_policy" "scale_out" {
  name                    = "${var.project}-${var.environment}-scaleOut"
  autoscaling_group_name   = aws_autoscaling_group.asg.name
  adjustment_type          = "ChangeInCapacity"
  scaling_adjustment       = 1
  cooldown                 = 300
}

resource "aws_autoscaling_policy" "scale_in" {
  name                    = "${var.project}-${var.environment}-scaleIn"
  autoscaling_group_name   = aws_autoscaling_group.asg.name
  adjustment_type          = "ChangeInCapacity"
  scaling_adjustment       = -1
  cooldown                 = 300
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.project}-${var.environment}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 10.0
  alarm_actions       = [aws_autoscaling_policy.scale_out.arn]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.project}-${var.environment}-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 5.0
  alarm_actions       = [aws_autoscaling_policy.scale_in.arn]
}

output "asg_name" {
  value = aws_autoscaling_group.asg.name
}
