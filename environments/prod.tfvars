aws_region  = "us-east-1"
environment = "prod"

# VPC
vpc_cidr = "10.1.0.0/16"

# EKS
eks_cluster_version    = "1.29"
eks_node_instance_type = "t3.medium"
eks_node_min_size      = 3
eks_node_max_size      = 10
eks_node_desired_size  = 3

# RDS
db_instance_class = "db.t3.small"
db_name           = "travel_site"
