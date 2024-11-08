## TODO : USE ACM as the certs

# # This example use the certificates from S3 bucket which uploaded manually by COC
# # The certs generated/given by app team / certificate team to COC
# # The s3 certs is then imported to ACM certificate.
# # The certs metadata for 'Content-Type' needs to be 'text/plain' to be able data source to download it
# locals {
#   core_iac_bucket_name = "ptawsg-core-iac-s3-bucket"
# }
#
# data "aws_s3_object" "cert_body" {
#   bucket = local.core_iac_bucket_name
#   key    = "/Certificates/2022/CommonInfra/TFE/DEV/example.petronas.com.crt"
# }
# data "aws_s3_object" "cert_key" {
#   bucket = local.core_iac_bucket_name
#   key    = "/Certificates/2022/CommonInfra/TFE/DEV/example.petronas.com.key"
# }
# data "aws_s3_object" "cert_chain" {
#   bucket = local.core_iac_bucket_name
#   key    = "/Certificates/2022/Chain/petronas.com_GlobalSign_RSA-OV-CA-2018_RootChain.cer"
# }
#
# module "ssl_cert" {
#   source = "git::git@ssh.dev.azure.com:v3/petronasvsts/PETRONAS_AWS_IAC_Module/terraform-aws-acm?ref=v4.0-latest"
#   providers = {
#     aws= aws.nvirginia
#   }
#   cert_body  = data.aws_s3_object.cert_body.body
#   cert_key   = data.aws_s3_object.cert_key.body
#   cert_chain = data.aws_s3_object.cert_chain.body
#   tags = {
#     "Name" = "example.petronas.com"
#   }
# }

## PURELY FOR TESTING ##
## This is an example of using self-signed certificate
## This is not recommended for production use

resource "tls_private_key" "example" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "example" {
  # key_algorithm   = tls_private_key.example.algorithm
  private_key_pem = tls_private_key.example.private_key_pem

  subject {
    common_name  = "cdn-s3-origin-example.petronassandpit.com"
    organization = "Petronas Examples"
  }

  validity_period_hours = 24

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

module "acm_cert_upload" {
  source = "git::git@ssh.dev.azure.com:v3/petronasvsts/PETRONAS_AWS_IAC_Module/terraform-aws-acm?ref=v5.1-latest"

  providers = {
    aws = aws.nvirginia
  }

  cert_key   = tls_private_key.example.private_key_pem
  cert_body  = tls_self_signed_cert.example.cert_pem
  cert_chain = ""

  tags = {
    "Name" = "cdn-s3-origin-example.petronassandpit.com"
  }
}
