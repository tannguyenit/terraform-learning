output "identifier_distribution" {
    description = "The identifier for the distribution"
    value       = aws_cloudfront_origin_access_identity.origin_access_identity.id
}
output "cloudfront_access_identity_path" {
    description = "A shortcut to the full path for the origin access identity to use in CloudFront"
    value       = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
}
output "cloudfront_access_identity_iam_arn" {
    description = "A pre-generated ARN for use in S3 bucket policies"
    value = aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
}