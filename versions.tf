######################################################################################################
# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.
#######################################################################################################

terraform {
  # https://github.com/hashicorp/terraform/releases/tag/v1.6.6
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      # https://github.com/hashicorp/terraform-provider-aws/releases/tag/v5.27.0
      version = ">= 4.29.0"
    }
  }
}
