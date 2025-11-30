# --- 1. Launch Template ---
resource "aws_launch_template" "this" {
  name_prefix   = "${var.project}-${var.environment}-LT"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  network_interfaces {
    associate_public_ip_address = false # Instances in private subnets
    security_groups             = [var.app_sg_id]
  }

  iam_instance_profile {
    arn = var.iam_instance_profile_arn # Must be created in IAM module
  }

  # Example User Data to install and run a simple web server
  user_data = base64encode(templatefile("${path.root}/../../scripts/upload_image.sh", {
    images_bucket = var.images_bucket
    page_title    = "${var.project} - ${var.environment}"
    team_names    = var.team_names
    environment   = var.environment
  }))
  
}
  resource "aws_autoscaling_group" "this" {
  desired_capacity     = 2
  max_size             = 2
  min_size             = 2
  vpc_zone_identifier  = var.private_subnet_ids
  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]  # <-- use the variable

  health_check_type         = "ELB"  # Use ALB health checks instead of EC2
  health_check_grace_period = 300
  # tags = [
  #   {
  #     key                 = "Name"
  #     value               = "${var.project}-${var.environment}-instance"
  #     propagate_at_launch = true
  #   }
  # ]
}

# Note: You would typically add scaling policies here (e.g., CPU utilization)
