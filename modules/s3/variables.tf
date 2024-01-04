variable "bucket_name" {
    description = "The bucket name"
}
variable "cloudfront_origin_access_identity_iam_arn" {
    description = "A pre-generated ARN for use in S3 bucket policies"
    default     = ""
}
variable "acl" {
    description = "(optional) describe your variable"
    default = "private"
}
variable "allowed_headers" {
    description = "The allowed headers"
    default     = ["*"]
}

variable "allowed_methods" {
    description = "The allowed methods"
    default     = ["PUT", "POST", "GET"]
}

variable "allowed_origins" {
    description = "The allowed origins"
    default     = ["*"]
}

variable "versioning" {
    description = "status of enable/disable bucket version"
    default     = "Disabled"
    validation {
        condition     = contains(["Enabled", "Suspended", "Disabled"], var.versioning)
        error_message = "Valid values: Enabled, Suspended, or Disabled"
    }
}
