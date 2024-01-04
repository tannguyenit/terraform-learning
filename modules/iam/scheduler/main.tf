data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["scheduler.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecsSchedulerExecutionRole" {
  name               = "${var.app_name}-${var.env}-scheduler-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags = {
    Name        = "${var.app_name}-iam-role"
    Environment = var.env
  }
}

resource "aws_iam_role_policy_attachment" "ecsSchedulerExecutionRole_policy" {
  role       = aws_iam_role.ecsSchedulerExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}
