resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-${var.environment}-ALB-SG"
  vpc_id      = var.vpc_id
  description = "Allow http ingress from internet to ALB"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.common_tags
}

resource "aws_security_group" "instance_sg" {
  name        = "${var.project}-${var.environment}-Instance-SG"
  vpc_id      = var.vpc_id
  description = "Allow traffic from ALB and SSH from admin IP"

  ingress {
    description     = "Allow from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description = "SSH from admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.common_tags
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "instance_sg_id" {
  value = aws_security_group.instance_sg.id
}
