variable "aws_access_key" {
    type = string
    description = "(optional) describe your variable"
}
variable "aws_secret_key" {
    type = string
    description = "(optional) describe your variable"
}
variable "aws_region" {
    type = string
    description = "(optional) describe your variable"
}

variable "project" {
  description = "The project name to use for unique resource naming"
  type        = string
}

variable "principal_arns" {
  description = "A list of principal arns allowed to assume the IAM role"
  default     = null
  type        = list(string)
}
