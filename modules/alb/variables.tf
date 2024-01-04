variable "name" {
    type = string
    description = "(optional) describe your variable"
}

variable "environment" {
    type = string
    description = "(optional) describe your variable"
}

variable "alb_security_groups" {
    type = string
    description = "(optional) describe your variable"
}

variable "aws_public_subnets" {
    description = "(optional) describe your variable"
}
variable "vpc_id" {
    type = string
    description = "(optional) describe your variable"
}
variable "health_check_path" {
    type = string
    description = "(optional) describe your variable"
    default = "/"
}

variable "is_ssl" {
    type = bool
    description = "(optional) describe your variable"
}
variable "certificate_arn_attach_alb_listener" {
    type = string
    description = "(optional) describe your variable"
}