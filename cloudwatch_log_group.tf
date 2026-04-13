resource "aws_cloudwatch_log_group" "fluent_bit" {
  name              = "/aws/eks/fluent-bit"
  retention_in_days = 7

  tags = {
    Name        = "fluent-bit-log-group"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_cloudwatch_log_stream" "fluent_bit" {
  name           = "fluent-bit-stream"
  log_group_name = aws_cloudwatch_log_group.fluent_bit.name
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.fluent_bit.name
}

output "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.fluent_bit.arn
}