variable "project_name" {
    type = string
    description = "Project name"
}

variable "env" {
    type = string
    description = "The environment running"
}

variable "image_tag_mutability" {
    type = string
    description = "The tag mutability setting for the repository"
    default = "MUTABLE"

    validation {
      condition = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
      error_message = "Must be one of: MUTABLE or IMMUTABLE"
    }
}

variable "scan_on_push" {
    type = bool
    description = "Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)."
    default = false
}

variable "keep_tag_image_count" {
    type = number
    description = "Keep tag image in the number days"
    default = 0
}
variable "keep_tag_prefix_list" {
    type = list(string)
    description = "list prefix tag will be keep in the number days"
    default = []
}

variable "expired_image_days" {
    type = number
    description = "Expire images older than the numbder days"
    default = 0
}
variable "force_delete" {
    type = bool
    description = "force delete the repository even if it contains images"
    default = false
}