variable "aws_vpc_cidr_block" {
    description = "The CIDR block for the VPC."
    default = "172.17.0.0/16"
}
variable "az_count" {
    description = "Number of AZs to cover in a given region"
    default     = 1
}
variable "vpc_name" {
    description = "The name VPC"
    default     = ""
}
variable "subnet_private_name" {
    description = "The name subnet private"
    default     = ""
}
variable "subnet_public_name" {
    description = "The name subnet private"
    default     = ""
}
variable "vpc_id" {
    description = "The VPC ID"
    default = ""
}
variable "is_exists_vpc" {
    description = "The state for exists VPC"
    default = false
}

variable "default_index" {
    description = "The state for exists VPC"
    default = 0
}