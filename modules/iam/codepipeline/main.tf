# Role for cicd pipeline
resource "aws_iam_role" "main" {
  name = "codepipeline-${var.name}-${var.env}-service-role"

  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "code_pipeline_policies" {
  statement {
    sid       = "AllowConnection"
    actions   = ["codestar-connections:UseConnection"]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions   = ["cloudwatch:*", "s3:*", "codebuild:*", "iam:PassRole"]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    sid    = "AllowECS"
    effect = "Allow"
    actions = [
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks",
      "ecs:ListTasks",
      "ecs:RegisterTaskDefinition",
      "ecs:TagResource",
      "ecs:UpdateService"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "main" {
  name        = "code-pipeline-policy"
  path        = "/"
  description = "Pipeline policy"
  policy      = data.aws_iam_policy_document.code_pipeline_policies.json
}

resource "aws_iam_role_policy_attachment" "attachment_custom_policies" {
  policy_arn = aws_iam_policy.main.arn
  role       = aws_iam_role.main.id
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryPowerUser" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  role       = aws_iam_role.main.id
}
