<!-- BEGIN_TF_DOCS -->
# AWS CDN Terraform module

Terraform module which creates AWS CDN resources.

## Examples

See the **/examples** directory for working examples to reference

- [Basic](examples/basic/main.tf)
- [Custom-Origin](examples/custom-origin/main.tf)
- [S3-Origin](examples/s3-origin/main.tf)

## Usage


### Basic
```hcl
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
```
  
### Custom-Origin
```hcl
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
```

### S3-Origin
```hcl
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
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.29.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.29.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_monitoring_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_monitoring_subscription) | resource |
| [aws_cloudfront_origin_access_control.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_cloudfront_origin_access_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aliases"></a> [aliases](#input\_aliases) | Extra CNAMEs (alternate domain names), if any, for this distribution. | `list(string)` | `null` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | Any comments you want to include about the distribution. | `string` | `null` | no |
| <a name="input_create_distribution"></a> [create\_distribution](#input\_create\_distribution) | Controls if CloudFront distribution should be created | `bool` | `true` | no |
| <a name="input_create_monitoring_subscription"></a> [create\_monitoring\_subscription](#input\_create\_monitoring\_subscription) | If enabled, the resource for monitoring subscription will created. | `bool` | `false` | no |
| <a name="input_create_origin_access_control"></a> [create\_origin\_access\_control](#input\_create\_origin\_access\_control) | Controls if CloudFront origin access control should be created | `bool` | `false` | no |
| <a name="input_create_origin_access_identity"></a> [create\_origin\_access\_identity](#input\_create\_origin\_access\_identity) | Controls if CloudFront origin access identity should be created | `bool` | `false` | no |
| <a name="input_custom_error_response"></a> [custom\_error\_response](#input\_custom\_error\_response) | One or more custom error response elements | `any` | `{}` | no |
| <a name="input_default_cache_behavior"></a> [default\_cache\_behavior](#input\_default\_cache\_behavior) | The default cache behavior for this distribution | `any` | n/a | yes |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL. | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether the distribution is enabled to accept end user requests for content. | `bool` | `true` | no |
| <a name="input_geo_restriction"></a> [geo\_restriction](#input\_geo\_restriction) | The restriction configuration for this distribution (geo\_restrictions) | `any` | n/a | yes |
| <a name="input_http_version"></a> [http\_version](#input\_http\_version) | The maximum HTTP version to support on the distribution. Allowed values are http1.1 and http2. The default is http2. | `string` | `"http2"` | no |
| <a name="input_is_ipv6_enabled"></a> [is\_ipv6\_enabled](#input\_is\_ipv6\_enabled) | Whether the IPv6 is enabled for the distribution. | `bool` | `null` | no |
| <a name="input_logging_config"></a> [logging\_config](#input\_logging\_config) | The logging configuration that controls how logs are written to your distribution (maximum one). | `any` | `{}` | no |
| <a name="input_ordered_cache_behavior"></a> [ordered\_cache\_behavior](#input\_ordered\_cache\_behavior) | An ordered list of cache behaviors resource for this distribution. List from top to bottom in order of precedence. The topmost cache behavior will have precedence 0. | `any` | `[]` | no |
| <a name="input_origin"></a> [origin](#input\_origin) | One or more origins for this distribution (multiples allowed). | `any` | n/a | yes |
| <a name="input_origin_access_control"></a> [origin\_access\_control](#input\_origin\_access\_control) | Map of CloudFront origin access control | <pre>map(object({<br>    description      = string<br>    origin_type      = string<br>    signing_behavior = string<br>    signing_protocol = string<br>  }))</pre> | <pre>{<br>  "s3": {<br>    "description": "",<br>    "origin_type": "s3",<br>    "signing_behavior": "always",<br>    "signing_protocol": "sigv4"<br>  }<br>}</pre> | no |
| <a name="input_origin_access_identities"></a> [origin\_access\_identities](#input\_origin\_access\_identities) | Map of CloudFront origin access identities (value as a comment) | `map(string)` | `{}` | no |
| <a name="input_origin_group"></a> [origin\_group](#input\_origin\_group) | One or more origin\_group for this distribution (multiples allowed). | `any` | `{}` | no |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | The price class for this distribution. One of PriceClass\_All, PriceClass\_200, PriceClass\_100 | `string` | `null` | no |
| <a name="input_realtime_metrics_subscription_status"></a> [realtime\_metrics\_subscription\_status](#input\_realtime\_metrics\_subscription\_status) | A flag that indicates whether additional CloudWatch metrics are enabled for a given CloudFront distribution. Valid values are `Enabled` and `Disabled`. | `string` | `"Enabled"` | no |
| <a name="input_retain_on_delete"></a> [retain\_on\_delete](#input\_retain\_on\_delete) | Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_viewer_certificate"></a> [viewer\_certificate](#input\_viewer\_certificate) | The SSL configuration for this distribution | `any` | <pre>{<br>  "cloudfront_default_certificate": true,<br>  "minimum_protocol_version": "TLSv1"<br>}</pre> | no |
| <a name="input_wait_for_deployment"></a> [wait\_for\_deployment](#input\_wait\_for\_deployment) | If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this tofalse will skip the process. | `bool` | `true` | no |
| <a name="input_web_acl_id"></a> [web\_acl\_id](#input\_web\_acl\_id) | If you're using AWS WAF to filter CloudFront requests, the Id of the AWS WAF web ACL that is associated with the distribution. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned. If using WAFv2, provide the ARN of the web ACL. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_distribution_arn"></a> [cloudfront\_distribution\_arn](#output\_cloudfront\_distribution\_arn) | The ARN (Amazon Resource Name) for the distribution. |
| <a name="output_cloudfront_distribution_caller_reference"></a> [cloudfront\_distribution\_caller\_reference](#output\_cloudfront\_distribution\_caller\_reference) | Internal value used by CloudFront to allow future updates to the distribution configuration. |
| <a name="output_cloudfront_distribution_domain_name"></a> [cloudfront\_distribution\_domain\_name](#output\_cloudfront\_distribution\_domain\_name) | The domain name corresponding to the distribution. |
| <a name="output_cloudfront_distribution_etag"></a> [cloudfront\_distribution\_etag](#output\_cloudfront\_distribution\_etag) | The current version of the distribution's information. |
| <a name="output_cloudfront_distribution_hosted_zone_id"></a> [cloudfront\_distribution\_hosted\_zone\_id](#output\_cloudfront\_distribution\_hosted\_zone\_id) | The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | The identifier for the distribution. |
| <a name="output_cloudfront_distribution_in_progress_validation_batches"></a> [cloudfront\_distribution\_in\_progress\_validation\_batches](#output\_cloudfront\_distribution\_in\_progress\_validation\_batches) | The number of invalidation batches currently in progress. |
| <a name="output_cloudfront_distribution_last_modified_time"></a> [cloudfront\_distribution\_last\_modified\_time](#output\_cloudfront\_distribution\_last\_modified\_time) | The date and time the distribution was last modified. |
| <a name="output_cloudfront_distribution_status"></a> [cloudfront\_distribution\_status](#output\_cloudfront\_distribution\_status) | The current status of the distribution. Deployed if the distribution's information is fully propagated throughout the Amazon CloudFront system. |
| <a name="output_cloudfront_distribution_tags"></a> [cloudfront\_distribution\_tags](#output\_cloudfront\_distribution\_tags) | Tags of the distribution's |
| <a name="output_cloudfront_distribution_trusted_signers"></a> [cloudfront\_distribution\_trusted\_signers](#output\_cloudfront\_distribution\_trusted\_signers) | List of nested attributes for active trusted signers, if the distribution is set up to serve private content with signed URLs |
| <a name="output_cloudfront_monitoring_subscription_id"></a> [cloudfront\_monitoring\_subscription\_id](#output\_cloudfront\_monitoring\_subscription\_id) | The ID of the CloudFront monitoring subscription, which corresponds to the `distribution_id`. |
| <a name="output_cloudfront_origin_access_controls"></a> [cloudfront\_origin\_access\_controls](#output\_cloudfront\_origin\_access\_controls) | The origin access controls created |
| <a name="output_cloudfront_origin_access_controls_ids"></a> [cloudfront\_origin\_access\_controls\_ids](#output\_cloudfront\_origin\_access\_controls\_ids) | The IDS of the origin access identities created |
| <a name="output_cloudfront_origin_access_identities"></a> [cloudfront\_origin\_access\_identities](#output\_cloudfront\_origin\_access\_identities) | The origin access identities created |
| <a name="output_cloudfront_origin_access_identity_iam_arns"></a> [cloudfront\_origin\_access\_identity\_iam\_arns](#output\_cloudfront\_origin\_access\_identity\_iam\_arns) | The IAM arns of the origin access identities created |
| <a name="output_cloudfront_origin_access_identity_ids"></a> [cloudfront\_origin\_access\_identity\_ids](#output\_cloudfront\_origin\_access\_identity\_ids) | The IDS of the origin access identities created |
<!-- END_TF_DOCS -->