data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}



# Launch Template
resource "aws_launch_template" "this" {
  name_prefix   = "${var.project}-${var.environment}-lt"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.instance_profile_name 
  }

  vpc_security_group_ids = [var.instance_sg_id]

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install -y httpd awscli

systemctl enable httpd
systemctl start httpd

aws s3 cp s3://${var.images_bucket}/site-image.jpg /var/www/html/site-image.jpg || true

cat > /var/www/html/index.html <<EOT
<html>
<head><title>${var.page_title}</title></head>
<body>
<h1>${var.page_title}</h1>
<p>Team: ${var.team_names}</p>
<img src="site-image.jpg" alt="S3 Image" width="400"/>
<p>Environment: ${var.environment}</p>
</body>
</html>
EOT
EOF
  )
}

# Auto Scaling Group
resource "aws_autoscaling_group" "this" {
  name                      = "${var.project}-${var.environment}-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.subnet_ids
  launch_template {
    id      = aws_launch_template.this.id
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
