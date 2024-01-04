resource "aws_cloudwatch_event_rule" "main" {
  event_bus_name = "default"
  name = "${var.ecs_service_name}-${var.schedule_name}"
  description = var.schedule_desc
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "ecs_scheduled_task" {
  target_id = "run-scheduled-task-every-hour"
  arn       = var.ecs_cluster_arn
  rule      = aws_cloudwatch_event_rule.main.name
  role_arn  = var.execution_role_arn

  ecs_target {
    task_definition_arn = replace(var.ecs_task_definition_arn, "/:[0-9]+$/", "")
    launch_type = "FARGATE"
    task_count = 1

    network_configuration {
        assign_public_ip = true
        subnets = var.vpc_subnets
        security_groups = var.vpc_security_groups
    }
  }

  input = jsonencode({
    containerOverrides = [
      {
        name = "${var.ecs_container_name}",
        command = var.ecs_command_overrides
      }
    ]
  })
}