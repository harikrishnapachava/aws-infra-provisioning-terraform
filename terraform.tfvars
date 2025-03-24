# Region configuration
region = "ap-south-1"  # Mumbai region

# Environment setting - determines deployment scale
# production = multi-AZ deployment
# staging = single-AZ deployment for cost savings
environment = "production"

# VPC network configuration
vpc_cidr = "10.0.0.0/16"  # 65,536 IP addresses
vpc_name = "production-vpc"

# Multi-AZ configuration
# These AZs will all be used for production
# Only the first will be used for staging
availability_zones = ["ap-south-1a", "ap-south-1b"]

# Subnet CIDR allocations
# Even numbered subnets are public (internet-facing)
# Odd numbered subnets are private (internal only)
# Each /24 subnet provides 254 usable IP addresses
public_subnet_cidrs = ["10.0.2.0/24", "10.0.4.0/24"]
private_subnet_cidrs = ["10.0.1.0/24", "10.0.3.0/24"]
