# Terraform AWS Infrastructure

This Terraform project provisions AWS EC2 instances, S3 buckets, and DynamoDB tables using reusable local modules. Resource counts and names are selected through Terraform workspaces.

## Resources

The root module uses three modules:

| Module | Resources created |
| --- | --- |
| `modules/ec2` | EC2 key pair, default VPC reference, security group, HTTP ingress rule, unrestricted egress rule, and EC2 instances |
| `modules/S3` | S3 buckets |
| `modules/Dynamo` | DynamoDB tables created with the `terraform-aws-modules/dynamodb-table/aws` module |

The EC2 instances use:

- AMI: `ami-09bf9dfeeb1e9adbc`
- Instance type: `t2.nano`
- Root volume: 10 GB GP3
- Security group port: TCP 80
- SSH key name: `<workspace>-terra-server-project`

## Workspace Resource Counts

| Workspace | EC2 instances | S3 buckets | DynamoDB tables |
| --- | ---: | ---: | ---: |
| `dev` | 1 | 1 | 1 |
| `stg` | 2 | 1 | 1 |
| `prod` | 3 | 2 | 2 |

Any workspace other than `dev`, `stg`, or `prod` falls back to the `dev` counts. The workspace name is also included in resource names and tags.

Generated naming patterns:

- EC2: `<workspace>-Terra-tilo`
- S3: `terra-tilo-bucket-<workspace>-<index>`
- DynamoDB: `terra-tillo-DB-<workspace>-<index>`

## Primitives

- Terraform: `>= 1.5.0`
- AWS provider: `hashicorp/aws` `6.71.0`
- Remote state backend:
  - Bucket: `boku-no-hero-academia`
  - Key: `terraform.tfstate`
  - Region: `us-east-2`
  - Native state locking enabled with `use_lockfile`

The remote S3 bucket must already exist and the AWS identity used by Terraform must have access to read and write state in it.

## Prerequisites

Install and configure:

1. Terraform 1.5 or later.
2. AWS CLI credentials for an account with permission to manage EC2, VPC security groups, S3, DynamoDB, and state in S3.
3. An existing EC2 public key file at the path referenced by `modules/ec2/01-ec2-create.tf`.

Configure AWS credentials before initialization, for example with environment variables or a named AWS CLI profile.

The public key path in the EC2 module is currently hard-coded:

```hcl
file("/home/ec2-user/Kenji/Project-1/terra-server-project.pub")
```

Update this path before applying if the public key is stored elsewhere. The repository also intentionally ignores `terra-server-project` and `terra-server-project.pub`, as well as `*.pem`.

## Usage

Initialize the project:

```bash
terraform init
```

Create or select an environment workspace:

```bash
terraform workspace new dev
# or
terraform workspace select dev
```

Review the plan:

```bash
terraform plan
```

Create the resources:

```bash
terraform apply
```

Destroy resources for the selected workspace:

```bash
terraform destroy
```

Example for staging:

```bash
terraform workspace select stg
terraform plan
terraform apply
```

## Outputs

The EC2 module exposes:

- `ec2_public_ip`: public IP addresses of the created instances
- `ec2_type`: instance types of the created instances

View outputs after apply:

```bash
terraform output
```

## Before Deploying

- Confirm that `ami-09bf9dfeeb1e9adbc` exists in the AWS region used by your provider credentials.
- Confirm that the EC2 module's hard-coded public key path exists on the machine running Terraform.
- S3 bucket names are globally unique. If `terra-tilo-bucket-<workspace>-<index>` is already in use, change `s3_name`.
- DynamoDB table names must be unique across the AWS account and region.
- The EC2 security group allows HTTP traffic from `0.0.0.0/0` and allows all outbound traffic. Add SSH ingress rules and restrict source CIDRs when private access is required.
