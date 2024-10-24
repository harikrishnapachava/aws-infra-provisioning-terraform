# This module will create the VPC, public and private subnets, nat gateway, internet gateway, routes, route tables and associate the route tables to subnets

#vpc
resource "aws_vpc" "production_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

# pvt subnet
resource "aws_subnet" "private_subnet" {
  count            = length(var.private_subnet_cidrs)
  vpc_id           = aws_vpc.production_vpc.id
  cidr_block       = var.private_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

# pub subnet
resource "aws_subnet" "public_subnet" {
  count            = length(var.public_subnet_cidrs)
  vpc_id           = aws_vpc.production_vpc.id
  cidr_block       = var.public_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

#EIP for NAT GW
resource "aws_eip" "nat_eip" {
  count = length(var.public_subnet_cidrs) # Matches number of public subnets
  vpc   = true
  tags = {
    Name = "nat-eip-${count.index + 1}"
  }
}

# NAT GW
resource "aws_nat_gateway" "nat_gw" {
  count        = length(var.public_subnet_cidrs) # Matches number of public subnets
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id
  tags = {
    Name = "nat-gw-${count.index + 1}"
  }
}

# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.production_vpc.id
  tags = {
    Name = "igw"
  }
}

# RT for pub subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.production_vpc.id
  tags = {
    Name = "public-rt"
  }
}

# Route for pub subnet
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# pub subnet rt association
resource "aws_route_table_association" "public_association" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# pvt subnet RT
resource "aws_route_table" "private_rt" {
  count  = length(aws_subnet.private_subnet)
  vpc_id = aws_vpc.production_vpc.id
  tags = {
    Name = "private-rt-${count.index + 1}"
  }
}

# routes for pvt subnets
resource "aws_route" "private_route" {
  count                = length(aws_subnet.private_subnet)
  route_table_id       = aws_route_table.private_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id       = aws_nat_gateway.nat_gw[count.index].id
}

# rt association for pvt subnet
resource "aws_route_table_association" "private_assoc" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}
