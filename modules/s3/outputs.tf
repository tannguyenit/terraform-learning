output "bucket_regional_domain_name" {
    description = "The DNS domain name of either the S3 bucket"
    value       = aws_s3_bucket.bucket.bucket_regional_domain_name
}
