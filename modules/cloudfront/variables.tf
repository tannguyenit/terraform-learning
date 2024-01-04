variable "env" {
    type = string
    description = "(optional) describe your variable"
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
    description = "A shortcut to the full path for the origin access identity to use in CloudFront."
    default = ""
}
variable "acm_certificate_arn" {
    description = "A shortcut to the full path for the origin access identity to use in CloudFront."
    default = ""
}
variable "ssl_support_method" {
    description = "Specifies how you want CloudFront to serve HTTPS requests. One of vip or sni-only."
    default = "sni-only"
}
variable "is_web_static_page" {
    type = bool
    description = "Specifies how you want CloudFront to serve HTTPS requests. One of vip or sni-only."
    default = false
}
