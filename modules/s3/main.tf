resource "aws_s3_bucket" "assets" {
  bucket = "${var.project_name}-${var.environment}-assets-${random_id.bucket_suffix.hex}"

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-assets"
  })
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket_versioning" "assets" {
  bucket = aws_s3_bucket.assets.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "assets" {
  bucket = aws_s3_bucket.assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "assets" {
  bucket = aws_s3_bucket.assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Bucket policy for CloudFront access (placeholder)
resource "aws_s3_bucket_policy" "assets" {
  count  = var.cloudfront_oai_arn != "" ? 1 : 0
  bucket = aws_s3_bucket.assets.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "AllowCloudFrontAccess"
      Effect = "Allow"
      Principal = {
        AWS = var.cloudfront_oai_arn
      }
      Action   = "s3:GetObject"
      Resource = "${aws_s3_bucket.assets.arn}/*"
    }]
  })

  depends_on = [aws_s3_bucket_public_access_block.assets]
}
