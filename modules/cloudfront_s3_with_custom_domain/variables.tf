variable "s3_bucket" {
  type = object({
    id                   = string
    regional_domain_name = string
  })
}

variable "cloudfront_origin_access_identity_cloudfront_access_identity_path" {
  type = string
}

variable "parent_domain_name" {
  type = string
}

variable "sub_domain_name_prefix" {
  type = string
}
