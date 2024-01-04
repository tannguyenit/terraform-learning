data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Service role
resource "aws_iam_role" "service_role" {
  name               = "codebuild-${var.name}-${var.env}-service-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role_policy.json
}

# Add extra polcies
resource "aws_iam_role_policy" "codebuild_role_extra_policies" {
  name   = "code_build_policy"
  role   = aws_iam_role.service_role.name
  policy = data.aws_iam_policy_document.codebuild_policies.json
}


####################
# Policy documents #
####################

# Assume Role
data "aws_iam_policy_document" "codebuild_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

# Extra policies
data "aws_iam_policy_document" "codebuild_policies" {
  statement {
    actions = [
      "codebuild:*",
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]

    resources = [
      "arn:aws:s3:::codepipeline-*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetAuthorizationToken",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:BatchDeleteImage"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases",
      "codebuild:BatchPutCodeCoverages"
    ]

    resources = [
      "arn:aws:codebuild:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:report-group/*"
    ]
  }
}
