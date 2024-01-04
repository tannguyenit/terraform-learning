variable "app_image" {
    type = string
    description = "(optional) describe your variable"
}
variable "app_port" {
    type = string
    description = "(optional) describe your variable"
}
variable "fargate_cpu" {
    type = string
    description = "(optional) describe your variable"
}
variable "fargate_memory" {
    type = string
    description = "(optional) describe your variable"
}
variable "aws_region" {
    type = string
    description = "(optional) describe your variable"
}
variable "cloudwatch_log_group_name" {
    type = string
    description = "(optional) describe your variable"
}
variable "container_name" {
    type = string
    description = "(optional) describe your variable"
}
variable "ecs_task_definition_family" {
    type = string
    description = "(optional) describe your variable"
}
variable "ecs_task_execution_role_arn" {
    type = string
    description = "(optional) describe your variable"
}
variable "ecs_service_name" {
    type = string
    description = "(optional) describe your variable"
}
variable "number_containers" {
    type = string
    description = "(optional) describe your variable"
    default = "1"
}
variable "ecs_task_security_group_id" {
    type = string
    description = "(optional) describe your variable"
}
variable "ecs_cluster_id" {
    type = string
    description = "(optional) describe your variable"
}
variable "vpc_subnet_ids" {
    type = list(string)
    description = "(optional) describe your variable"
}
variable "target_group_arn" {
    type = string
    description = "(optional) describe your variable"
}
variable "service_discovery_namespace_id" {
    type = string
    description = "(optional) describe your variable"
}