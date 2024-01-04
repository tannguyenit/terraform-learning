variable "route53_hosted_zone" {
    description = "The Hosted Zone name of the desired Hosted Zone"
    default     = ""
}
variable "route53_zone_id" {
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

