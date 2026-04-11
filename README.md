# Travel Site - AWS Infrastructure

Terraform configuration for deploying the travel-site application on AWS EKS.

## Architecture

- **VPC**: 2 public subnets, 2 private subnets across 2 AZs, NAT gateway, internet gateway
- **EKS**: Managed Kubernetes cluster with autoscaling node group
- **RDS**: PostgreSQL database in private subnets
- **S3**: Static assets bucket with versioning and encryption

## Prerequisites

- Terraform >= 1.5.0
- AWS CLI configured with appropriate credentials
- An AWS account with permissions to create the required resources

## Usage

1. Copy the example variables file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` with your values (especially `db_password`).

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Plan the deployment:
   ```bash
   terraform plan -var-file=environments/dev.tfvars
   ```

5. Apply:
   ```bash
   terraform apply -var-file=environments/dev.tfvars
   ```

## Connecting to EKS

After applying, configure kubectl:

```bash
aws eks update-kubeconfig --name travel-site-dev --region us-east-1
```

## Environments

- `environments/dev.tfvars` - Development (smaller instances, no multi-AZ RDS)
- `environments/prod.tfvars` - Production (larger node group, multi-AZ RDS, deletion protection)

Pass sensitive variables via CLI or environment variables:

```bash
terraform apply -var-file=environments/dev.tfvars \
  -var="db_username=dbadmin" \
  -var="db_password=your-secure-password"
```
