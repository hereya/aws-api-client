terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.5"
    }
  }
}

resource "random_id" "bucket_id" {
  byte_length = 8
}

resource "aws_s3_bucket" "this" {
  bucket = "${var.name_prefix}${random_id.bucket_id.hex}"

  tags = {
    Source  = "DReAM POC"
    Package = "aws_api_client"
  }
}

data "aws_iam_policy_document" "permissions" {
  # Object-level permissions
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]
  }

  # Bucket-level permissions
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.this.arn]
  }
}

# Allow browsers on the given origins to upload/download directly via presigned
# URLs (PUT/GET). Only created when at least one origin is provided, so existing
# consumers that don't set cors_allowed_origins are unaffected.
resource "aws_s3_bucket_cors_configuration" "this" {
  count  = length(var.cors_allowed_origins) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id

  cors_rule {
    allowed_origins = var.cors_allowed_origins
    allowed_methods = ["PUT", "GET", "HEAD"]
    allowed_headers = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}