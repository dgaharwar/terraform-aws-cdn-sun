## REQUIRED VARIABLES
variable "default_cache_behavior" {
  description = "The default cache behavior for this distribution"
  type        = any
  default     = ""

}
variable "geo_restriction" {
  description = "The restriction configuration for this distribution (geo_restrictions)"
  type        = any
  default     = {
    restriction_type = "none"
  }
}

variable "origin" {
  description = "One or more origins for this distribution (multiples allowed)."
  type        = any
  default     = {
    s3 = {
      domain_name = "mybucket.s3.amazonaws.com"
      origin_id   = "S3-mybucket"
    }
  }
}

## OPTIONAL VARIABLES
variable "aliases" {
  description = "Extra CNAMEs (alternate domain names), if any, for this distribution."
  type        = list(string)
  default     = null
}

variable "comment" {
  description = "Any comments you want to include about the distribution."
  type        = string
  default     = null
}

variable "create_distribution" {
  description = "Controls if CloudFront distribution should be created"
  type        = bool
  default     = true
}

variable "create_monitoring_subscription" {
  description = "If enabled, the resource for monitoring subscription will created."
  type        = bool
  default     = false
}

variable "create_origin_access_control" {
  description = "Controls if CloudFront origin access control should be created"
  type        = bool
  default     = false
}

variable "create_origin_access_identity" {
  description = "Controls if CloudFront origin access identity should be created"
  type        = bool
  default     = false
}

variable "custom_error_response" {
  description = "One or more custom error response elements"
  type        = any
  default     = {}
}

variable "default_root_object" {
  description = "The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL."
  type        = string
  default     = null
}

variable "enabled" {
  description = "Whether the distribution is enabled to accept end user requests for content."
  type        = bool
  default     = true
}


variable "http_version" {
  description = "The maximum HTTP version to support on the distribution. Allowed values are http1.1 and http2. The default is http2."
  type        = string
  default     = "http2"
}

variable "is_ipv6_enabled" {
  description = "Whether the IPv6 is enabled for the distribution."
  type        = bool
  default     = null
}

variable "logging_config" {
  description = "The logging configuration that controls how logs are written to your distribution (maximum one)."
  type        = any
  default     = {}
}

variable "origin_access_control" {
  description = "Map of CloudFront origin access control"
  type = map(object({
    description      = string
    origin_type      = string
    signing_behavior = string
    signing_protocol = string
  }))

  default = {
    s3 = {
      description      = "s3-oac",
      origin_type      = "s3",
      signing_behavior = "always",
      signing_protocol = "sigv4"
    }
  }
}

variable "origin_access_identities" {
  description = "Map of CloudFront origin access identities (value as a comment)"
  type        = map(string)
  default     = {}
}

variable "origin_group" {
  description = "One or more origin_group for this distribution (multiples allowed)."
  type        = any
  default     = {}
}

variable "ordered_cache_behavior" {
  description = "An ordered list of cache behaviors resource for this distribution. List from top to bottom in order of precedence. The topmost cache behavior will have precedence 0."
  type        = any
  default     = []
}

variable "price_class" {
  description = "The price class for this distribution. One of PriceClass_All, PriceClass_200, PriceClass_100"
  type        = string
  default     = null
}

variable "realtime_metrics_subscription_status" {
  description = "A flag that indicates whether additional CloudWatch metrics are enabled for a given CloudFront distribution. Valid values are `Enabled` and `Disabled`."
  type        = string
  default     = "Enabled"
}

variable "retain_on_delete" {
  description = "Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = null
}

variable "viewer_certificate" {
  description = "The SSL configuration for this distribution"
  type        = any
  default = {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1"
  }
}

variable "wait_for_deployment" {
  description = "If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this tofalse will skip the process."
  type        = bool
  default     = true
}

variable "web_acl_id" {
  description = "If you're using AWS WAF to filter CloudFront requests, the Id of the AWS WAF web ACL that is associated with the distribution. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned. If using WAFv2, provide the ARN of the web ACL."
  type        = string
  default     = null
}


## Provider Configurations

variable "aws_region" {
  type        = string
  default     = "ap-southeast-1"
  sensitive   = true
}

variable "aws_access_key" {
  type        = string

}

variable "aws_secret_key" {
  type        = string

}



## Tags
 
variable "Project_Code" {
  description = "Project Code associated with the deployment"
  type        = string
  default     = "03703"
}
 
variable "ApplicationId" {
  description = "Application ID for the project"
  type        = string
  default     = "ALPHA"
}
 
variable "ApplicationName" {
  description = "Name of the Application"
  type        = string
  default     = "ALPHA"
}
 
variable "environment" {
  description = "Deployment environment (e.g., Production, Staging)"
  type        = string
  default     = "Production"
}
 
variable "CostCenter" {
  description = "Cost Center for the project"
  type        = string
  default     = "001PXXX12"
}
 
variable "DataClassification" {
  description = "Data Classification level"
  type        = string
  default     = "Confidential"
}
 
variable "SCAClassification" {
  description = "SCA Classification level"
  type        = string
  default     = "Standard"
}
 
variable "IACRepo" {
  description = "Infrastructure as Code repository URL"
  type        = string
  default     = ""
}
 
variable "ProductOwner" {
  description = "Email of the Product Owner"
  type        = string
  default     = "user@petronas.com"
}
 
variable "ProductSupport" {
  description = "Email of the Product Support"
  type        = string
  default     = "user@petronas.com"
}
 
variable "BusinessOwner" {
  description = "Email of the Business Owner"
  type        = string
  default     = "user@petronas.com"
}
 
variable "CSBIA_Availability" {
  description = "CSBIA Availability level"
  type        = string
  default     = "Moderate"
}
 
variable "CSBIA_Confidentiality" {
  description = "CSBIA Confidentiality level"
  type        = string
  default     = "Major"
}
 
variable "CSBIA_ImpactScore" {
  description = "CSBIA Impact Score"
  type        = string
  default     = "Major"
}
 
variable "CSBIA_Integrity" {
  description = "CSBIA Integrity level"
  type        = string
  default     = "Moderate"
}
 
variable "BusinessOPU_HCU" {
  description = "Business OPU/HCU associated with the project"
  type        = string
  default     = "GTS"
}
 
variable "BusinessStream" {
  description = "Business Stream associated with the project"
  type        = string
  default     = "PDnT"
}
 
variable "SRNumber" {
  description = "Service Request Number"
  type        = string
  default     = "REQ000006277983"
}
