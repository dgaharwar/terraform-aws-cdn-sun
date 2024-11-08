######################################################################################################
# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
#######################################################################################################

# This example is to use s3 as origin 
## TODO: USE ACM as the certs

module "aws-cdn-s3-origin-example" {
  source = "../.."
  # source = "git::git@ssh.dev.azure.com:v3/petronasvsts/PETRONAS_AWS_IAC_Module/terraform-aws-cdn?ref=v4.0-latest"

  providers = {
    aws = aws.nvirginia
  }

  # aliases = ["cdn-s3-origin-example.petronassandpit.com"] # CNAME must use validated cert
  comment = "cdn-s3-origin-example.petronassandpit.com distribution"

  default_root_object = "index.html"
  enabled             = true
  http_version        = "http2"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = true

  # Origin Access Identity is a legacy CloudFront Access Control Feature, use Origin Access Control as the more modern approach
  # create_origin_access_identity = false
  # origin_access_identities = {
  #   comment = "CloudFront OAI access to S3"
  # }
  create_origin_access_control = true

  origin_access_control = {
    cdn-s3 = {
      description      = "CloudFront OAC access to S3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }


  origin = [
    {
      domain_name           = module.s3_module1.bucket_regional_domain_name
      origin_id             = module.s3_module1.name
      connection_timeout    = "10"
      connection_attempts   = "3"
      origin_access_control = "cdn-s3"
    },
    {
      domain_name           = module.s3_module2.bucket_regional_domain_name
      origin_id             = module.s3_module2.name
      connection_timeout    = "10"
      connection_attempts   = "3"
      origin_access_control = "cdn-s3"
    }
  ]

  origin_group = [
    {
      origin_id                  = "s3_group_id"
      failover_status_codes      = [500, 502, 503, 504]
      primary_member_origin_id   = module.s3_module1.name
      secondary_member_origin_id = module.s3_module2.name
    }
  ]

  default_cache_behavior = {
    target_origin_id       = module.s3_module1.name
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["HEAD", "GET"]
    compress               = "true"
    smooth_streaming       = "false"
    use_forwarded_values   = "true"
    headers                = []
    query_string           = "true"
    cookies_forward        = "all"
  }


  viewer_certificate = {
    acm_certificate_arn = module.acm_cert_upload.cert_arn

    minimum_protocol_version = "TLSv1.2_2019"
    ssl_support_method       = "sni-only"
  }

  geo_restriction = {
    restriction_type = "none"
  }

  # web_acl_id = "arn:aws:wafv2:us-east-1:009612143196:global/webacl/web-acl-1/95308691-efad-4952-9ff9-1b8c374e2b84" # coc-use

  tags = {
    "Name" = "cdn-s3-origin-example.petronassandpit.com"
  }
}
