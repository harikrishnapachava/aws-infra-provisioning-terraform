# Root Module
module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  # Set availability zones based on the environment. For Ex: 2 AZs for production , 1 AZ for staging
  availability_zones   = var.environment == "production" ? var.availability_zones : [var.availability_zones[0]]
  # Set the public and private subnet CIDRs based on the environment. For Ex: 2 AZs for production , 1 AZ for staging
  public_subnet_cidrs  = var.environment == "production" ? var.public_subnet_cidrs : [var.public_subnet_cidrs[0]]
  private_subnet_cidrs = var.environment == "production" ? var.private_subnet_cidrs : [var.private_subnet_cidrs[0]]
}

