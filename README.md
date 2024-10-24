# AWS Infrastructure Provisioning with Terraform

This Terraform project provisions a fully-configured AWS Virtual Private Cloud (VPC) with public and private subnets, NAT gateways, and route tables.

## Overview
This project automates the creation of a secure and scalable AWS infrastructure with the following features:
- Multi-AZ VPC with public and private subnets
- Internet gateway for public subnets
- NAT gateway for private subnets
- Customizable subnet CIDR blocks and availability zones

## Requirements
- [Terraform](https://www.terraform.io/downloads.html) ~> 1.9.0
- [Terraform AWS Provider Plugin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) ~> 5.60.0

The Terraform state file is stored in an S3 bucket with DynamoDB for state locking. Ensure to update the values for the S3 bucket and DynamoDB table. If a remote backend is not required, delete `backend.tf`.

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| region | AWS region to create the VPC | string | ap-south-1 | yes |
| environment | Deployment environment (production/staging) | string | production | yes |
| vpc_cidr | IPv4 CIDR block for the VPC | string | 10.0.0.0/16 | yes |
| vpc_name | Name of the VPC | string | production-vpc | yes |
| availability_zones | List of availability zones | list(string) | ["ap-south-1a", "ap-south-1b"] | yes |
| public_subnet_cidrs | CIDR blocks for public subnets | list(string) | ["10.0.2.0/24", "10.0.4.0/24"] | yes |
| private_subnet_cidrs | CIDR blocks for private subnets | list(string) | ["10.0.1.0/24", "10.0.3.0/24"] | yes |

## Default Values
The default values assume a production environment with two availability zones in the `ap-south-1` region.

## Resources Created
| Resource |
|----------|
| VPC |
| Internet Gateway |
| Elastic IPs for NAT Gateways |
| NAT Gateways |
| Public Subnets |
| Private Subnets |
| Routes |
| Route Tables |
| Route Table Associations |

## Outputs
| Name | Description |
|------|-------------|
| vpc_id | ID of the created VPC |
| public_subnet_ids | List of Public Subnet IDs |
| private_subnet_ids | List of Private Subnet IDs |

## Usage
1. **Initialize Terraform**:
   ```bash
   terraform init
    ```

2. **Plan the deployment**:
   ```bash
terraform plan
    ```

3. **Apply the configuration**:
   ```bash
terraform apply
    ```

4. **Destroy the infrastructure**:
   ```bash
terraform destroy
    ```

5. **Backend Configuration**:
   ```bash
If using a remote backend, ensure that the S3 bucket and DynamoDB table are properly configured in the backend.tf file. If not required, delete backend.tf.
    ```


## Requirements

The following requirements are needed
- [terraform] ~> 1.9.0
- [terraform aws provider plugin] ~> 5.60.0
- Terraform statefile is saved in S3 with statefile locking, update the values of the S3 bucket and dynamo db table
- delete the backend.tf if storing the statefile in a remote backend is not required and 

## Inputs 

The below inputs need to be passed. If we dont pass the inputs, the default values listed below will be taken

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|--------|
| region | AWS region in which the VPC should be creted | string | ap-south-1 | yes |
| environment | Specify the environment name. Accepted values are production/staging | string | production | yes |
| vpc_cidr | The IPv4 CIDR block for the VPC | string | 10.0.0.0/16 | yes |
| vpc_name | Name for the VPC | string | production-vpc | yes |
| availability_zones | List of availability zones | list(string) | ["ap-south-1a", "ap-south-1b"] | yes |
| public_subnet_cidrs | CIDR blocks for public subnets | list(string) | ["10.0.2.0/24", "10.0.4.0/24"] | yes |
| private_subnet_cidrs | CIDR blocks for private subnets | list(string) | ["10.0.1.0/24", "10.0.3.0/24"] | yes |

## Default values

Default values are set to production with 2 AZs and the default region pointing to ap-south-1

## Resources

The below aws resources will be created

| Name |
|------|
| VPC |
| Internet gateway |
| Elastic IPs for NAT gateways |
| NAT gateways |
| Public Subnets |
| Private Subnets |
| Routes |
| Route tables |
| Route table associations |


## Outputs

The below outputs will be displayed

| Name | Description |
|------|-------------|
| vpc_id | ID of the VPC that is created |
| public_subnet_ids | List of Public Subnet IDs that are created |
| private_subnet_ids | List of Private Subnet IDs that are created |

