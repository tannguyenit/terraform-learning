
data "template_file" "app_template" {
  template = file("${path.module}/templates/ecs-task-definition.tpl")
  vars = {
    app_image               = var.app_image
    app_port                = var.app_port
    fargate_cpu             = var.fargate_cpu
    fargate_memory          = var.fargate_memory
    aws_region              = var.aws_region
    aws_logs_group          = var.cloudwatch_log_group_name
    container_name          = var.container_name
    healthCheck_command     = jsonencode(var.healthCheck.command)
    healthCheck_interval    = var.healthCheck.interval
    healthCheck_retries     = var.healthCheck.retries
    healthCheck_startPeriod = var.healthCheck.startPeriod
  }
}

resource "aws_cloudwatch_log_group" "main" {
  name              = var.cloudwatch_log_group_name
  retention_in_days = 3
}

resource "aws_ecs_task_definition" "app" {
  family                   = var.ecs_task_definition_family
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.app_template.rendered
  tags                     = {}
}

resource "aws_ecs_service" "main" {
  name                               = var.ecs_service_name
  cluster                            = var.ecs_cluster_id
  task_definition                    = aws_ecs_task_definition.app.arn
  desired_count                      = var.number_containers
  enable_execute_command             = var.enable_execute_command
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  platform_version                   = "LATEST"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [var.ecs_task_security_group_id]
    subnets          = var.vpc_subnet_ids
    assign_public_ip = true
  }

  dynamic "load_balancer" {
    for_each = var.target_group_arn != "" ? [true] : []

    content {
      target_group_arn = var.target_group_arn
      container_name   = var.container_name
      container_port   = var.app_port
    }
  }

  service_connect_configuration {
    enabled = true
    namespace = var.service_discovery_namespace_id
    service {
      client_alias {
        port = "80"
      }
      discovery_name = var.ecs_service_name
      port_name = "app"
    }
    log_configuration {
      log_driver = "awslogs"
        options = {
          "awslogs-group": var.cloudwatch_log_group_name,
          "awslogs-region": var.aws_region,
          "awslogs-stream-prefix": "ecs"
        }
    }
  }

  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }
}
