resource "aws_scheduler_schedule_group" "main" {
  name = "${var.project_name}-${var.env}-schedule-group"
}

resource "aws_scheduler_schedule" "main" {
  name = "${var.project_name}-${var.env}-schedule"
  description = "EventBridge Scheduler"
  schedule_expression_timezone = var.timezone
  group_name = aws_scheduler_schedule_group.main.name

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = var.schedule_expression

  target {
    arn      = var.cluster_arn
    role_arn = var.schedule_execution_role_arn

    ecs_parameters {
        task_definition_arn = replace(var.ecs_task_definition_arn, "/:[0-9]+$/", ":*")
        launch_type = "FARGATE"
        task_count = 1

        network_configuration {
            assign_public_ip = false
            subnets = var.vpc_subnets
            security_groups = var.vpc_security_groups
        }
    }

    input = jsonencode({
      containerOverrides = [
        {
            "name": "${var.ecs_service_name}",
            "command": var.ecs_command_overrides
        }
      ]
    })
  }
}
