variable "env" {
    type = string
    description = "project environment"
    default = "dev"
}
variable "bucket_regional_domain_name" {
    description = "The DNS domain name of either the S3 bucket."
    default     = ""
}
variable "alternate_domain_names" {
    description = "Extra CNAMEs (alternate domain names), if any, for this distribution."
    default = []
}
variable "cloudfront_access_identity_path" {
    description = "The CloudFront origin access identity to associate with the origin."
    default = ""
}
variable "acm_certificate_arn" {
    description = "ARN of the AWS Certificate Manager certificate that you wish to use with this distribution"
    default = ""
}
variable "ssl_support_method" {
    description = "Specifies how you want CloudFront to serve HTTPS requests. One of vip or sni-only."
    default = "sni-only"
}
variable "is_webapp_distribution" {
    type = bool
    description = "The flag make cloudfront usage for web"
    default = false
}
variable "origin_shield_region" {
    type = string
    description = "AWS Region for Origin Shield"
    default = "us-east-2"
}
variable "lambda_function_name" {
    type = string
    description = "lambda function name"
    default = ""
}
variable "header_secret" {
    type = string
    description = "header secret pass to lambda function"
    default = ""
}
variable "cloudfront_function_name" {
    type = string
    description = "ARN of the CloudFront function."
    default = ""
}
variable "cloudfront_function_stage" {
    type = string
    description = "ARN of the CloudFront function."
    default = "DEVELOPMENT"
}