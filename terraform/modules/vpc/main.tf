resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project}-vpc"
  }
}

locals {
  azs = ["ap-northeast-1a", "ap-northeast-1c"]
}

# Public Subnets (2AZ)
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet("10.0.0.0/16", 8, count.index)   # 10.0.0.0/24, 10.0.1.0/24
  map_public_ip_on_launch = true
  availability_zone       = local.azs[count.index]

  tags = {
    Name = "${var.project}-public-${count.index}"
  }
}

# Private Subnets (2AZ)
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet("10.0.0.0/16", 8, count.index + 2)   # 10.0.2.0/24, 10.0.3.0/24
  availability_zone = local.azs[count.index]

  tags = {
    Name = "${var.project}-private-${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project}-public-rt"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
