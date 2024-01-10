[
  {
    "name": "${container_name}",
    "image": "${app_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "environment": [],
    "essential": true,
    "healthCheck": {
      "timeout": 5,
      "command": ${healthCheck_command},
      "interval": ${healthCheck_interval},
      "retries": ${healthCheck_retries},
      "startPeriod": ${healthCheck_startPeriod}
    },
    "mountPoints": [],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_logs_group}",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "name": "app",
        "protocol": "tcp",
        "containerPort": ${app_port},
        "hostPort": ${app_port}
      }
    ],
    "volumesFrom": []
  }
]