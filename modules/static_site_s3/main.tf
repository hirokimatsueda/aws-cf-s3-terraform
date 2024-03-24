data "aws_iam_policy_document" "static_site" {
  statement {
    sid    = "AllowCloudFront"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        var.cloudfront_origin_access_identity_iam_arn,
      ]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.static_site.arn}/*"
    ]
  }
}

resource "aws_s3_bucket" "static_site" {
  bucket_prefix = "site"
}

resource "aws_s3_bucket_policy" "static_site" {
  bucket = aws_s3_bucket.static_site.id
  policy = data.aws_iam_policy_document.static_site.json
}

resource "aws_s3_bucket_object" "index_html" {
  bucket       = aws_s3_bucket.static_site.id
  key          = "index.html"
  source       = var.index_html_file_path
  content_type = "text/html"
}
