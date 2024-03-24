output "id" {
  value = aws_s3_bucket.static_site.id
}

output "regional_domain_name" {
  value = aws_s3_bucket.static_site.bucket_regional_domain_name
}
