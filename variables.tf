variable "region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS region"
}

variable "environment" {
  type        = string
  default     = "production" # or "staging"
  description = "Specify the environment. Accepted values are production/staging"
  validation {
    condition     = var.environment == "production" || var.environment == "staging"
    error_message = "Incorrect value. Accepted values are production/staging"
  }
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC"
}

variable "vpc_name" {
  type        = string
  default     = "production-vpc"
  description = "Name for the VPC"
}

variable "availability_zones" {
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
  description = "List of availability zones"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.4.0/24"]
  description = "CIDR blocks for public subnets"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
  description = "CIDR blocks for private subnets"
}