output "service_name" {
    value = aws_ecs_service.main.name
}
output "task_definition_arn" {
    value = aws_ecs_task_definition.app.arn
}
output "task_definition_arn_without_revision" {
    value = aws_ecs_task_definition.app.arn_without_revision
}