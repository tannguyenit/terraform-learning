variable "service_role" {
    type = string
    description = "(optional) describe your variable"
    default = ""
}

variable "name" {
    type = string
    description = "(optional) describe your variable"
}

variable "environment_compute_type" {
    type = string
    description = "(optional) describe your variable"
    default = "BUILD_GENERAL1_SMALL"
}
variable "environment_image" {
    type = string
    description = "(optional) describe your variable"
    default = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
}
variable "environment_type" {
    type = string
    description = "(optional) describe your variable"
    default = "LINUX_CONTAINER"
}

variable "environment_variables" {
  type    = list(object({
    name  = string
    value = string
    type  = optional(string, "PLAINTEXT")
  }))
  default = []
}
variable "buildspec" {
    type = string
    description = "(optional) describe your variable"
    default = "buildspec.yml"
}