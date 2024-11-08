######################################################################################################
# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
#######################################################################################################

module "aws-cdn-custom-origin-example" {
  source = "../.."
  # source = "git::git@ssh.dev.azure.com:v3/petronasvsts/PETRONAS_AWS_IAC_Module/terraform-aws-cdn?ref=v4.0-latest"

  providers = {
    aws = aws.nvirginia
  }

  # aliases = ["cdn-custom-origin-example.petronassandpit.com"] # CNAME must use validated cert
  comment             = "cdn-custom-origin-example.petronassandpit.com"
  enabled             = true
  http_version        = "http2"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  # Origin Access Identity is a legacy CloudFront Access Control Feature, use Origin Access Control as the more modern approach
  # create_origin_access_identity = false
  # origin_access_identities = {
  #   comment = "CloudFront access to LB"
  # }
  create_origin_access_control = true


  origin = [
    {
      domain_name         = module.alb.dns_name
      origin_id           = module.alb.dns_name
      connection_timeout  = "10"
      connection_attempts = "3"
      custom_origin_config = {
        http_port              = "80"
        https_port             = "443"
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  ]

  default_cache_behavior = {
    target_origin_id       = module.alb.dns_name
    viewer_protocol_policy = "allow-all"
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["HEAD", "GET"]
    compress               = "true"
    smooth_streaming       = "false"
    use_forwarded_values   = "true"
    headers                = ["*"]
    query_string           = "true"
    cookies_forward        = "all"
  }


  viewer_certificate = {
    # acm_certificate_arn            = module.acm.cert_arn # coc-use

    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1.2_2019"
    ssl_support_method             = "sni-only"
  }

  geo_restriction = {
    restriction_type = "none"
  }

  //  web_acl_id = "arn:aws:wafv2:us-east-1:009612143196:global/webacl/web-acl-2/55293206-2aa0-4d63-8d10-c3b3596aaf95" # coc-use

  tags = {
    "Name" = "cdn-custom-origin-example.petronassandpit.com"
  }
}
