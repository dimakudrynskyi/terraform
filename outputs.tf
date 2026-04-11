output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint URL for the EKS cluster API server"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_certificate_authority" {
  description = "Base64 encoded certificate data for the EKS cluster"
  value       = module.eks.cluster_certificate_authority
  sensitive   = true
}

output "eks_oidc_provider_arn" {
  description = "ARN of the OIDC provider for the EKS cluster"
  value       = module.eks.oidc_provider_arn
}

output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = module.rds.db_endpoint
}

output "rds_database_name" {
  description = "Name of the RDS database"
  value       = module.rds.db_name
}

output "s3_bucket_name" {
  description = "Name of the S3 assets bucket"
  value       = module.s3.bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the S3 assets bucket"
  value       = module.s3.bucket_arn
}
