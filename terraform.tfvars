region = "ap-south-1" # or any other region you want to use
environment = "production" # Accepted values are production or staging
vpc_cidr = "10.0.0.0/16"
vpc_name = "production-vpc" # or any other name you prefer
availability_zones = [ "ap-south-1a", "ap-south-1b" ] # Use one AZ for staging, or more for production
public_subnet_cidrs = ["10.0.2.0/24", "10.0.4.0/24"] # Use one subnet for staging, or more for production
private_subnet_cidrs = ["10.0.1.0/24", "10.0.3.0/24"] # Use one subnet for staging, or more for production