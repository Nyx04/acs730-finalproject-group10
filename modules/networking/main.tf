### 1. VPC and Internet Gateway ###
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = merge(var.common_tags, { Name = "${var.project}-${var.environment}-VPC" })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.common_tags, { Name = "${var.project}-${var.environment}-IGW" })
}

### 2. Subnets (Public and Private) ###
resource "aws_subnet" "public" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index) 
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true
  tags = merge(var.common_tags, { Name = "${var.project}-${var.environment}-PublicSubnet-${count.index + 1}" })
}

resource "aws_subnet" "private" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + length(var.azs))
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = false
  tags = merge(var.common_tags, { Name = "${var.project}-${var.environment}-PrivateSubnet-${count.index + 1}" })
}

### 3. NAT Gateway ###
resource "aws_eip" "nat" { 
  tags = merge(var.common_tags, { Name = "${var.project}-${var.environment}-NAT-EIP" })
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags          = merge(var.common_tags, { Name = "${var.project}-${var.environment}-NATGW" })
  depends_on    = [aws_internet_gateway.this]
}

### 4. Route Tables and Associations ###
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  
  route { 
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags   = merge(var.common_tags, { Name = "${var.project}-${var.environment}-PublicRT" })
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  
  # FIX APPLIED: Separated arguments with newlines
  route { 
    cidr_block   = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id 
  }
  tags   = merge(var.common_tags, { Name = "${var.project}-${var.environment}-PrivateRT" })
}

resource "aws_route_table_association" "private_assoc" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

### 5. Bastion Host and SG Module Call ###

# Calls the centralized Security Group module
module "security_groups" {
  # Path previously corrected to use relative path to peer module
  source           = "../security_group" 
  project          = var.project
  environment      = var.environment
  vpc_id           = aws_vpc.this.id
  common_tags      = var.common_tags
  bastion_ssh_cidr = var.bastion_ssh_cidr
}

# EC2 Instance for Bastion Host
resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  subnet_id                   = aws_subnet.public[0].id
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.security_groups.bastion_sg_id]

  tags = merge(var.common_tags, { Name = "${var.project}-${var.environment}-BastionHost" })
}
