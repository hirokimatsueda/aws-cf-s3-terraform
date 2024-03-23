data "aws_iam_policy_document" "www" {
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
      "${aws_s3_bucket.www.arn}/*"
    ]
  }
}

resource "aws_s3_bucket" "www" {
  bucket_prefix = "www"
}

resource "aws_s3_bucket_policy" "www" {
  bucket = aws_s3_bucket.www.id
  policy = data.aws_iam_policy_document.www.json
}

resource "aws_s3_bucket_object" "index_html" {
  bucket       = aws_s3_bucket.www.id
  key          = "index.html"
  source       = var.index_html_file_path
  content_type = "text/html"
}
