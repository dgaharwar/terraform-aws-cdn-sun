locals {
  s3_prefix_name = "petronas-module-test-bucket-"
}

# Data block to get caller account id
data "aws_caller_identity" "current" {}

# Primary bucket
module "s3_module1" {
  source = "git::git@ssh.dev.azure.com:v3/petronasvsts/PETRONAS_AWS_IAC_Module/terraform-aws-s3?ref=v4.0-latest"

  bucket                   = "${local.s3_prefix_name}${data.aws_caller_identity.current.account_id}"
  control_object_ownership = false
  attach_policy            = true

  # allow cloudfront access
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          "Service" = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${local.s3_prefix_name}${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          "StringEquals" = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })

  website = {
    index_document = "index.html"
    error_document = "index.html"
  }
}

# Second bucket
module "s3_module2" {
  source = "git::git@ssh.dev.azure.com:v3/petronasvsts/PETRONAS_AWS_IAC_Module/terraform-aws-s3?ref=v4.0-latest"

  bucket                   = "${local.s3_prefix_name}2-${data.aws_caller_identity.current.account_id}"
  control_object_ownership = false
  attach_policy            = true

  # allow cloudfront access
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          "Service" = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${local.s3_prefix_name}2-${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          "StringEquals" = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })

  website = {
    index_document = "index.html"
    error_document = "index.html"
  }
}

# will upload all the files present under HTML folder to the S3 bucket 
resource "aws_s3_object" "upload_object1" {
  for_each     = fileset("html/", "*")
  bucket       = module.s3_module1.name
  key          = each.value
  source       = "html/${each.value}"
  etag         = filemd5("html/${each.value}")
  content_type = "text/html"
  tags = {
    Project_Code = "COC-LAB"
    CostCenter   = "704D905153"
  }
  override_provider {
    default_tags {
      tags = {}
    }
  }
}

# will upload all the files present under HTML folder to the S3 bucket
resource "aws_s3_object" "upload_object2" {
  for_each     = fileset("html/", "*")
  bucket       = module.s3_module2.name
  key          = each.value
  source       = "html/${each.value}"
  etag         = filemd5("html/${each.value}")
  content_type = "text/html"

  tags = {
    Project_Code = "COC-LAB"
    CostCenter   = "704D905153"
  }
  override_provider {
    default_tags {
      tags = {}
    }
  }
}