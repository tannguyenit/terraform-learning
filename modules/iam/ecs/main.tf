data "aws_iam_policy_document" "task_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "${var.app_name}-${var.env}-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.task_assume_role_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role",
    "arn:aws:iam::aws:policy/AWSAppMeshEnvoyAccess"
  ]
  tags = {
    Name        = "${var.app_name}-iam-role"
    Environment = var.env
  }
}

resource "aws_iam_role" "ecsTaskRole" {
  name               = "${var.app_name}-${var.env}-task-role"
  assume_role_policy = data.aws_iam_policy_document.task_assume_role_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
  tags = {
    Name        = "${var.app_name}-iam-role"
    Environment = var.env
  }
}