# Variables specify the provider
variable "aws_region" {
    description = "The region AWS"
    default     = "us-east-2"
}
variable "aws_access_key" {
    description = "The AWS access key"
    default     = ""
}
variable "aws_secret_key" {
    description = "The AWS secret key"
    default     = ""
}
variable "project_name" {
    description = "The Project name"
    default     = ""
}
variable "env" {
    description = "The environment"
    default     = ""
}
# End variables specify the provider

# Variables network
variable "public_subnets" {
    type = list(string)
    description = "(optional) describe your variable"
}
variable "vpc_cidr_block" {
    description = "The CIDR block for the VPC."
    default = "172.17.0.0/16"
}
variable "az_count" {
    description = "Number of AZs to cover in a given region"
    default     = 2
}
variable "vpc_id" {
    description = "The VPC ID"
    default = ""
}
variable "is_exists_vpc" {
    description = "The state for exists VPC"
    default = false
}
# End variables network


variable "route53_hosted_zone" {
    description = "The Hosted Zone name of the desired Hosted Zone"
    default     = ""
}
variable "route53_private_zone" {
    description = "Used with name field to get a private Hosted Zone"
    default = false
}
variable "certificate_domain_name" {
    description = "A domain name for which the certificate should be issued"
    default = ""
}
variable "subject_alternative_names" {
    description = "Set of domains that should be SANs in the issued certificate. To remove all elements of a previously configured list"
    default = []
}

#====================
variable "bucket" {
  description = "S3 Bucket name"
}
variable "acl" {
    description = "The canned ACL to apply. Valid values are private, public-read, public-read-write, aws-exec-read, authenticated-read, and log-delivery-write"
    default     = "private"
}
variable "app_bucket_versioning" {
    description = "Versioning state of the bucket.Valid values: Enabled, Suspended, or Disabled"
    default     = "Enabled"
}

# =============== Cerificate

variable "fe_certificate_domain_name" {
    type = string
    description = "(optional) describe your variable"
}

variable "app_certificate_domain_name" {
    type = string
    description = "(optional) describe your variable"
}


variable "ssl_support_method" {
  description = "How you want CloudFront to serve HTTPS requests. One of vip or sni-only"
  default = "sni-only"
}

variable "alb_certificate_domain_name" {
    type = string
    description = "(optional) describe your variable"
}