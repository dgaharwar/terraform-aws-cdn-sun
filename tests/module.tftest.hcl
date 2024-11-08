provider "aws" {
  region = "ap-southeast-1"
}

// Plan cdn module
run "plan_cdn_resource" {
  command = plan

  variables {
    default_cache_behavior = {
      target_origin_id       = "S3-mybucket"
      viewer_protocol_policy = "allow-all"
      allowed_methods        = ["GET", "HEAD"]
      cached_methods         = ["GET", "HEAD"]
    }

    geo_restriction = {
      restriction_type = "none"
    }
    origin = {
      s3 = {
        domain_name = "mybucket.s3.amazonaws.com"
        origin_id   = "S3-mybucket"
      }
    }
  }

  assert {
    condition     = var.origin.s3.origin_id == var.default_cache_behavior.target_origin_id
    error_message = "Verify aws_cloudfront_distribution origin same as target origin id"
  }
}
