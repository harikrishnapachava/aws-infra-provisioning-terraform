variable "region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS region where resources will be provisioned"
}

variable "environment" {
  type        = string
  default     = "production" # or "staging"
  description = "Deployment environment which determines infrastructure scale"
  validation {
    condition     = var.environment == "production" || var.environment == "staging"
    error_message = "Environment must be either 'production' or 'staging'"
  }
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "IPv4 CIDR block for the VPC (must be /16 to accommodate subnet allocation)"
}

variable "vpc_name" {
  type        = string
  default     = "production-vpc"
  description = "Name for the VPC (will be tagged with this name)"
}

variable "availability_zones" {
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
  description = "List of availability zones for multi-AZ deployment (production uses all, staging uses first only)"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.4.0/24"]
  description = "CIDR blocks for public subnets (should be within VPC CIDR block)"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
  description = "CIDR blocks for private subnets (should be within VPC CIDR block)"
}
