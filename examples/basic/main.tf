######################################################################################################
# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
#######################################################################################################


module "aws-cdn-basic-example" {
  source = "../.."
  # source = "git::git@ssh.dev.azure.com:v3/petronasvsts/PETRONAS_AWS_IAC_Module/terraform-aws-cdn?ref=v4.0-latest"

  default_cache_behavior = {
    target_origin_id       = "S3-mybucket"
    viewer_protocol_policy = "allow-all"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
  }

  origin = {
    s3 = {
      domain_name = "mybucket.s3.amazonaws.com"
      origin_id   = "S3-mybucket"
    }
  }

  geo_restriction = {
    restriction_type = "none"
  }

  viewer_certificate = {
    cloudfront_default_certificate = true
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  tags = {
    "Name" = "example.awssandpet.com"
  }
}
