# VPC Module
# This module creates a complete AWS networking stack including:
# - VPC with DNS support
# - Public and private subnets across multiple availability zones
# - Internet Gateway for public internet access
# - NAT Gateways for private subnet outbound internet access
# - Route tables with appropriate routes for both subnet types

# VPC Resource
# Creates the main Virtual Private Cloud with DNS support enabled
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr     # Main IPv4 address range for the VPC
  enable_dns_support   = true             # Enables DNS resolution in the VPC
  enable_dns_hostnames = true             # Enables DNS hostnames for EC2 instances
  tags = {
    Name        = var.vpc_name            # Name tag for easy identification
    Environment = var.environment         # Environment tag for resource grouping
  }
}

# Private Subnets
# Create private subnets for resources that don't need direct internet access
# Uses count to create multiple subnets across availability zones
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidrs)                # Number of private subnets to create
  vpc_id            = aws_vpc.vpc.id                                  # Associate with our VPC
  cidr_block        = var.private_subnet_cidrs[count.index]           # CIDR block for this subnet from variable list
  availability_zone = element(var.availability_zones, count.index)    # AZ for this subnet from variable list
  tags = {
    Name        = "${var.environment}-private-subnet-${count.index + 1}"  # Unique name with environment prefix
    Environment = var.environment                                         # Environment tag
  }
}

# Public Subnets
# Create public subnets for resources that need direct internet access
# Uses count to create multiple subnets across availability zones
resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnet_cidrs)                 # Number of public subnets to create
  vpc_id            = aws_vpc.vpc.id                                  # Associate with our VPC
  cidr_block        = var.public_subnet_cidrs[count.index]            # CIDR block for this subnet from variable list
  availability_zone = element(var.availability_zones, count.index)    # AZ for this subnet from variable list
  tags = {
    Name        = "${var.environment}-public-subnet-${count.index + 1}"   # Unique name with environment prefix
    Environment = var.environment                                         # Environment tag
  }
}

# Elastic IPs for NAT Gateways
# Allocate static public IP addresses for the NAT Gateways
resource "aws_eip" "nat_eip" {
  count  = length(var.public_subnet_cidrs)    # One EIP per public subnet (for each NAT Gateway)
  domain = "vpc"                              # EIP will be used in a VPC
  tags = {
    Name        = "${var.environment}-nat-eip-${count.index + 1}"    # Unique name with environment prefix
    Environment = var.environment                                    # Environment tag
  }
}

# NAT Gateways
# Create NAT Gateways to enable private subnet resources to access the internet
# One NAT Gateway per AZ in public subnets for high availability
resource "aws_nat_gateway" "nat_gw" {
  count         = length(var.public_subnet_cidrs)          # One NAT Gateway per public subnet
  allocation_id = aws_eip.nat_eip[count.index].id          # Associate with the corresponding EIP
  subnet_id     = aws_subnet.public_subnet[count.index].id # Place in the corresponding public subnet
  tags = {
    Name        = "${var.environment}-nat-gw-${count.index + 1}"   # Unique name with environment prefix
    Environment = var.environment                                  # Environment tag
  }
}

# Internet Gateway
# Create a single Internet Gateway to enable public subnet resources to access the internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id    # Associate with our VPC
  tags = {
    Name        = "${var.environment}-igw"    # Name with environment prefix
    Environment = var.environment            # Environment tag
  }
}

# Public Route Table
# Create a route table for public subnets with a route to the Internet Gateway
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id    # Associate with our VPC
  tags = {
    Name        = "${var.environment}-public-rt"   # Name with environment prefix
    Environment = var.environment                 # Environment tag
  }
}

# Public Route to Internet
# Add a default route to the Internet Gateway in the public route table
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id    # Use the public route table
  destination_cidr_block = "0.0.0.0/0"                     # Default route for all external traffic
  gateway_id             = aws_internet_gateway.igw.id     # Send traffic to the Internet Gateway
}

# Public Subnet Route Table Association
# Associate the public route table with each public subnet
resource "aws_route_table_association" "public_association" {
  count          = length(aws_subnet.public_subnet)         # One association per public subnet
  subnet_id      = aws_subnet.public_subnet[count.index].id # The public subnet to associate
  route_table_id = aws_route_table.public_rt.id             # The public route table to use
}

# Private Route Tables
# Create separate route tables for each private subnet
# Each private subnet gets its own route table to enable AZ isolation
resource "aws_route_table" "private_rt" {
  count  = length(aws_subnet.private_subnet)    # One route table per private subnet
  vpc_id = aws_vpc.vpc.id                       # Associate with our VPC
  tags = {
    Name        = "${var.environment}-private-rt-${count.index + 1}"   # Unique name with environment prefix
    Environment = var.environment                                      # Environment tag
  }
}

# Private Routes to NAT Gateways
# Add default routes to the NAT Gateways in each private route table
# This enables outbound internet access from the private subnets
resource "aws_route" "private_route" {
  count                  = length(aws_subnet.private_subnet)      # One route per private subnet
  route_table_id         = aws_route_table.private_rt[count.index].id   # Use corresponding private route table
  destination_cidr_block = "0.0.0.0/0"                            # Default route for all external traffic
  nat_gateway_id         = aws_nat_gateway.nat_gw[count.index].id # Send traffic to corresponding NAT Gateway
}

# Private Subnet Route Table Association
# Associate each private route table with its corresponding private subnet
resource "aws_route_table_association" "private_assoc" {
  count          = length(aws_subnet.private_subnet)              # One association per private subnet
  subnet_id      = aws_subnet.private_subnet[count.index].id      # The private subnet to associate
  route_table_id = aws_route_table.private_rt[count.index].id     # The corresponding private route table
}










# This module will create the VPC, public and private subnets, nat gateway, internet gateway, routes, route tables and associate the route tables to subnets

#vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = var.vpc_name
    Environment = var.environment
  }
}

# pvt subnet
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name        = "${var.environment}-private-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

# pub subnet
resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name        = "${var.environment}-public-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

#EIP for NAT GW
resource "aws_eip" "nat_eip" {
  count = length(var.public_subnet_cidrs) # Matches number of public subnets
  domain = "vpc"
  tags = {
    Name        = "${var.environment}-nat-eip-${count.index + 1}"
    Environment = var.environment
  }
}

# NAT GW
resource "aws_nat_gateway" "nat_gw" {
  count         = length(var.public_subnet_cidrs) # Matches number of public subnets
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id
  tags = {
    Name        = "${var.environment}-nat-gw-${count.index + 1}"
    Environment = var.environment
  }
}

# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}

# RT for pub subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.environment}-public-rt"
    Environment = var.environment
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
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.environment}-private-rt-${count.index + 1}"
    Environment = var.environment
  }
}

# routes for pvt subnets
resource "aws_route" "private_route" {
  count                  = length(aws_subnet.private_subnet)
  route_table_id         = aws_route_table.private_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw[count.index].id
}

# rt association for pvt subnet
resource "aws_route_table_association" "private_assoc" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}
