#
# Three-Tier Application Security Groups
#
# This file defines the network ingress and egress rules for the Bastion Host,
# the Application Load Balancer (ALB), and the backend Application Servers.
#

# --- 1. Bastion Security Group (Allows SSH from trusted external network) ---
resource "aws_security_group" "bastion_sg" {
  name        = "${var.project}-${var.environment}-Bastion-SG"
  description = "Allows SSH inbound traffic for Bastion Host"
  vpc_id      = var.vpc_id

  # Ingress: Allow SSH (Port 22) only from the defined trusted CIDR block
  ingress {
    description = "Allow SSH from trusted network"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.bastion_ssh_cidr
  }

  # Egress: Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "${var.project}-${var.environment}-Bastion-SG" })
}


# --- 2. ALB Security Group (Allows HTTP/HTTPS from outside) ---
resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-${var.environment}-ALB-SG"
  description = "Allows HTTP/HTTPS traffic to the ALB"
  vpc_id      = var.vpc_id

  # Ingress: Allow HTTP (Port 80) from the entire internet
  ingress {
    description = "Allow HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress: Allow all outbound traffic (to reach the application tier)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "${var.project}-${var.environment}-ALB-SG" })
}


# --- 3. Application Security Group (Allows traffic ONLY from ALB) ---
resource "aws_security_group" "app_sg" {
  name        = "${var.project}-${var.environment}-App-SG"
  description = "Allows traffic from the ALB"
  vpc_id      = var.vpc_id

  # Ingress: Allow traffic on port 8080 ONLY from the ALB's security group
  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 8080 # Example application server port
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # Source is the ALB SG ID
  }
  # ADD THIS: Allow SSH from Bastion for troubleshooting
  ingress {
    description     = "Allow SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }
  # Egress: Allow all outbound traffic (for NAT Gateway access)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Needed for outbound traffic via NAT GW
  }

  tags = merge(var.common_tags, { Name = "${var.project}-${var.environment}-App-SG" })
}