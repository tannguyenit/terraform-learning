data "aws_iam_policy_document" "scheduled_task_cw_event_role_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["events.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "scheduled_task_cw_event_role_cloudwatch_policy" {
  statement {
    effect    = "Allow"
    actions   = ["ecs:RunTask"]
    resources = ["*"]

    condition {
      test     = "ArnEquals"
      variable = "ecs:cluster"
      values   = [var.ecs_cluster_arn]
    }
  }
  statement {
    actions   = ["iam:PassRole"]
    resources = var.ecs_task_role_arn == null ? [var.ecs_execution_task_role_arn] : [var.ecs_execution_task_role_arn, var.ecs_task_role_arn]
  }
}

resource "aws_iam_role" "main" {
  count              = var.event_rule_role_arn == null ? 1 : 0
  name               = "${var.app_name}-${var.env}-event-task-role"
  assume_role_policy = data.aws_iam_policy_document.scheduled_task_cw_event_role_assume_role_policy.json
}

resource "aws_iam_role_policy" "scheduled_task_cw_event_role_cloudwatch_policy" {
  count  = var.event_rule_role_arn == null ? 1 : 0
  name   = "${var.app_name}-${var.env}-event-task-policy"
  role   = aws_iam_role.main[0].id
  policy = data.aws_iam_policy_document.scheduled_task_cw_event_role_cloudwatch_policy.json
}