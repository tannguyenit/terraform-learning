output "service_name" {
    value = module.ecs-service.service_name
}
output "task_definition_arn" {
    value = module.ecs-service.task_definition_arn
}
output "task_definition_arn_without_revision" {
    value = module.ecs-service.task_definition_arn
}