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

