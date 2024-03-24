############
## 証明書 ##
############
resource "aws_acm_certificate" "this" {
  domain_name       = "${var.sub_domain_name_prefix}.${var.parent_domain_name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "parent_zone" {
  name         = var.parent_domain_name
  private_zone = false
}

resource "aws_route53_record" "domain_validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.parent_zone.zone_id
}

resource "aws_acm_certificate_validation" "domain_validation" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.domain_validation : record.fqdn]
}

############################################################
## カスタムドメイン有効なCloudFrontディストリビューション ##
############################################################
resource "aws_cloudfront_distribution" "static_site" {
  origin {
    domain_name = var.s3_bucket.regional_domain_name
    origin_id   = var.s3_bucket.id
    s3_origin_config {
      origin_access_identity = var.cloudfront_origin_access_identity_cloudfront_access_identity_path
    }
  }

  enabled             = true
  default_root_object = "index.html"
  aliases             = ["${var.sub_domain_name_prefix}.${var.parent_domain_name}"]

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.s3_bucket.id
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.this.arn
    ssl_support_method  = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
}

resource "aws_route53_record" "static_site" {
  zone_id = data.aws_route53_zone.parent_zone.zone_id
  name    = "${var.sub_domain_name_prefix}.${var.parent_domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.static_site.domain_name
    zone_id                = aws_cloudfront_distribution.static_site.hosted_zone_id
    evaluate_target_health = false
  }
}
