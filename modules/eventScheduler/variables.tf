variable "project_name" {
    type = string
    description = "The project name"
}
variable "env" {
    type = string
    description = "The environment running"
}

variable "schedule_expression" {
    type = string
    description = "Defines when the schedule runs"
}
variable "timezone" {
    type = string
    description = "Timezone in which the scheduling expression is evaluated."
    default = "UTC"
}
variable "cluster_arn" {
    type = string
    description = "ARN of the target of this schedule, ECS cluster. "
}
variable "schedule_execution_role_arn" {
    type = string
    description = "Scheduler Execution role. ARN of the IAM role that EventBridge Scheduler will use for this target when the schedule is invoked."
}
variable "ecs_service_name" {
    type = string
    description = "The ECS Service name"
}
variable "vpc_subnets" {
    type = list(string)
    description = "Subnets of VPC the ECS running"
    default = [ ]
}
variable "vpc_security_groups" {
    type = list(string)
    description = "Security group apply for ECS Task"
    default = [ ]
}
variable "ecs_task_definition_arn" {
    type = string
    description = "ECS Task definition arn"
}
variable "ecs_command_overrides" {
    type = list(string)
    description = "list command will orverride. Ex: [\"node\", \"index.js\"]"
    default = []
}