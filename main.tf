terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1" # CloudFront用のACMの要件に沿って設定
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_cloudfront_origin_access_identity" "this" {}

module "mo_static_site_s3" {
  source = "./modules/static_site_s3"

  cloudfront_origin_access_identity_iam_arn = aws_cloudfront_origin_access_identity.this.iam_arn
  index_html_file_path                      = var.index_html_file_path
}

module "mo_cloudfront_s3_with_custom_domain" {
  source = "./modules/cloudfront_s3_with_custom_domain"

  s3_bucket = {
    id                   = module.mo_static_site_s3.id
    regional_domain_name = module.mo_static_site_s3.regional_domain_name
  }
  cloudfront_origin_access_identity_cloudfront_access_identity_path = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
  parent_domain_name                                                = var.parent_domain_name
  sub_domain_name_prefix                                            = var.sub_domain_name_prefix
}
