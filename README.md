# AWS VPC Infrastructure with Terraform

A robust Terraform project for provisioning a fully configured AWS VPC with public and private subnets, NAT gateways, internet gateway, and properly configured routing.

## Architecture

This project creates:

- Multi-availability zone VPC
- Public and private subnets across AZs
- Internet Gateway for public internet access
- NAT Gateways for private subnet outbound connectivity
- Route tables with appropriate routes

## Features

- **Multi-Environment Support**: Configure for both production (multi-AZ) and staging (single-AZ)
- **Remote State Management**: S3 backend with DynamoDB locking
- **Proper Resource Tagging**: All resources tagged with environment and name
- **Flexible CIDR Configuration**: Easily customize subnet addressing

## Requirements

- Terraform ~> 1.9.0
- AWS Provider ~> 5.60.0
- AWS CLI configured with appropriate permissions
- S3 bucket and DynamoDB table for state management (optional)

## Module Structure

```
.
├── backend.tf              # S3 backend configuration
├── main.tf                 # Root module calling the VPC module
├── modules/
│   └── vpc/                # VPC module
│       ├── main.tf         # VPC resources definition
│       ├── variables.tf    # Module input variables
│       └── outputs.tf      # Module outputs
├── outputs.tf              # Root module outputs
├── providers.tf            # Provider configuration
├── terraform.tfvars        # Variable values
└── variables.tf            # Root module variables
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | AWS region for deployment | string | `"ap-south-1"` | yes |
| environment | Deployment environment (production/staging) | string | `"production"` | yes |
| vpc_cidr | IPv4 CIDR block for the VPC | string | `"10.0.0.0/16"` | yes |
| vpc_name | Name of the VPC | string | `"production-vpc"` | yes |
| availability_zones | List of availability zones | list(string) | `["ap-south-1a", "ap-south-1b"]` | yes |
| public_subnet_cidrs | CIDR blocks for public subnets | list(string) | `["10.0.2.0/24", "10.0.4.0/24"]` | yes |
| private_subnet_cidrs | CIDR blocks for private subnets | list(string) | `["10.0.1.0/24", "10.0.3.0/24"]` | yes |

## Environment Configuration

The infrastructure automatically adapts based on the environment:

- **Production**: Deploys across multiple availability zones (default: 2)
- **Staging**: Deploys to a single availability zone to reduce costs

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | ID of the created VPC |
| public_subnet_ids | List of public subnet IDs |
| private_subnet_ids | List of private subnet IDs |
| nat_gateway_ids | List of NAT gateway IDs |
| internet_gateway_id | ID of the internet gateway |

## Usage

### Backend Configuration

If using a remote backend, ensure your S3 bucket and DynamoDB table exist:

```bash
# Update the bucket and table name in backend.tf
# Remove backend.tf if you prefer local state management
```

### Deployment

```bash
# Initialize Terraform
terraform init

# Plan changes
terraform plan

# Apply infrastructure
terraform apply

# Destroy when finished
terraform destroy
```

### Custom Configuration

Modify `terraform.tfvars` for your environment:

```hcl
region               = "us-west-2"
environment          = "production"
vpc_cidr             = "10.0.0.0/16"
vpc_name             = "my-vpc"
availability_zones   = ["us-west-2a", "us-west-2b"]
public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24"]
private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
```

## Best Practices

- Use environment-specific workspaces or separate state files
- Review and approve changes through pull requests
- Apply proper IAM permissions for Terraform execution
- Tag all resources for cost allocation and management
