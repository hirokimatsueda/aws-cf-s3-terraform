resource "aws_cloudfront_distribution" "static_website" {
  origin {
    domain_name = var.s3_bucket.regional_domain_name
    origin_id   = var.s3_bucket.id
    s3_origin_config {
      origin_access_identity = var.cloudfront_origin_access_identity_cloudfront_access_identity_path
    }
  }

  enabled             = true
  default_root_object = "index.html"

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
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
}
