variable "aws_region" {
    type = string
    description = "(optional) describe your variable"
}
variable "aws_access_key" {
    type = string
    description = "(optional) describe your variable"
}
variable "aws_secret_key" {
    type = string
    description = "(optional) describe your variable"
}
variable "project_name" {
    type = string
    description = "(optional) describe your variable"
}
variable "env" {
    type = string
    description = "(optional) describe your variable"
}
variable "vpc_id" {
    type = string
    description = "(optional) describe your variable"
}

variable "ecs_task_execution_role_arn" {
    type = string
    description = "(optional) describe your variable"
    default = ""
}

variable "ecs_event_execution_role_arn" {
    type = string
    description = "(optional) describe your variable"
    default = ""
}
variable "ecs_task_security_group_id" {
    type = string
    description = "(optional) describe your variable"
    default = ""
}
variable "ecs_task_role_arn" {
    type = string
    description = "(optional) describe your variable"
}
variable "ecs_cluster_id" {
    type = string
    description = "(optional) describe your variable"
    default = ""
}
variable "alb_target_group_arn" {
    type = string
    description = "(optional) describe your variable"
    default = ""
}
variable "vpc_subnet_ids" {
    type = list(string)
    description = "(optional) describe your variable"
    default = []
}
variable "ecs_cluster_name" {
    type = string
    description = "(optional) describe your variable"
}