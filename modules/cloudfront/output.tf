output "domain_name" {
  value = one(aws_cloudfront_distribution.web_cloudfront_distribution[*].domain_name)
}

output "hosted_zone_id" {
  value = one(aws_cloudfront_distribution.web_cloudfront_distribution[*].hosted_zone_id)
}

output "s3_domain_name" {
  value = one(aws_cloudfront_distribution.s3_distribution[*].domain_name)
}

output "s3_hosted_zone_id" {
  value = one(aws_cloudfront_distribution.s3_distribution[*].hosted_zone_id)
}