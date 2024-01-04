variable "app_name" {
    type = string
    description = "(optional) describe your variable"
}
variable "env" {
    type = string
    description = "(optional) describe your variable"
}
variable "event_rule_role_arn" {
    type = string
    description = "(optional) describe your variable"
    default = null
    nullable = true
}
variable "ecs_task_role_arn" {
    type = string
    description = "(optional) describe your variable"
    nullable = true
}
variable "ecs_execution_task_role_arn" {
    type = string
    description = "(optional) describe your variable"
}
variable "ecs_cluster_arn" {
    type = string
    description = "(optional) describe your variable"
}