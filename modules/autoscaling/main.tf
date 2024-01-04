resource "aws_appautoscaling_target" "target" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.aws_ecs_cluster_name}/${var.aws_ecs_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Automatically scale capacity up by one
resource "aws_appautoscaling_policy" "up" {
    name               = "ECSCPUUtilization:${var.aws_ecs_cluster_name}:${var.aws_ecs_service_name}-up"
    service_namespace  = "ecs"
    resource_id        = "service/${var.aws_ecs_cluster_name}/${var.aws_ecs_service_name}"
    scalable_dimension = "ecs:service:DesiredCount"

    step_scaling_policy_configuration {
        adjustment_type         = "ChangeInCapacity"
        cooldown                = 60 // Khi đã thực hiện scale thì trong vòng 60s sẽ k scale nữa
        metric_aggregation_type = var.metric_type

        step_adjustment {
            metric_interval_lower_bound = 0
            scaling_adjustment          = 1
        }
    }
    depends_on = [aws_appautoscaling_target.target]
}

# Automatically scale capacity down by one
resource "aws_appautoscaling_policy" "down" {
    name               = "ECSCPUUtilization:${var.aws_ecs_cluster_name}:${var.aws_ecs_service_name}-down"
    service_namespace  = "ecs"
    resource_id        = "service/${var.aws_ecs_cluster_name}/${var.aws_ecs_service_name}"
    scalable_dimension = "ecs:service:DesiredCount"

    step_scaling_policy_configuration {
        adjustment_type         = "ChangeInCapacity"
        cooldown                = 60
        metric_aggregation_type = var.metric_type

        step_adjustment {
            metric_interval_upper_bound = 0
            scaling_adjustment          = -1
        }
    }
    depends_on = [aws_appautoscaling_target.target]
}

# CloudWatch alarm that triggers the autoscaling up policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
    alarm_name          = "ECS/${var.aws_ecs_cluster_name}/${var.aws_ecs_service_name}/service-cpu-hight-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = "2"
    metric_name         = "CPUUtilization"
    namespace           = "AWS/ECS"
    period              = "60"
    statistic           = "Average"
    threshold           = var.cpu_percent.hight
    dimensions = {
        ClusterName = var.aws_ecs_cluster_name
        ServiceName = var.aws_ecs_service_name
    }

    alarm_actions = [aws_appautoscaling_policy.up.arn]
}

# CloudWatch alarm that triggers the autoscaling down policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_low" {
    alarm_name          = "ECS/${var.aws_ecs_cluster_name}/${var.aws_ecs_service_name}/service-cpu-low-alarm"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods  = "2"
    metric_name         = "CPUUtilization"
    namespace           = "AWS/ECS"
    period              = "60"
    statistic           = "Average"
    threshold           = var.cpu_percent.low
    dimensions = {
        ClusterName = var.aws_ecs_cluster_name
        ServiceName = var.aws_ecs_service_name
    }

    alarm_actions = [aws_appautoscaling_policy.down.arn]
}