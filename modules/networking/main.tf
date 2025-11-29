resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = merge(
    var.common_tags,
    { Name = "${var.project}-${var.environment}-VPC" }
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    var.common_tags,
    { Name = "${var.project}-${var.environment}-IGW" }
  )
}

resource "aws_subnet" "public" {
  count                   = 3
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true
  tags = merge(
    var.common_tags,
    { Name = "${var.project}-${var.environment}-PublicSubnet-${count.index + 1}" }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(
    var.common_tags,
    { Name = "${var.project}-${var.environment}-PublicRT" }
  )
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
