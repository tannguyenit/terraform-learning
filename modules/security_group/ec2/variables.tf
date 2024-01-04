variable "ec2_security_group_name" {
    description = "The name EC2 security group"
    default     = ""
}
variable "ec2_security_group_description" {
    description = "The description security group"
    default     = ""
}
variable "vpc_id" {
    description = "The VPC ID."
    default     = ""
}
variable "ingress_ssh_port" {
    description = "The ingress ssh port."
    default     = ""
}
