data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Service role
resource "aws_iam_role" "service_role" {
  name               = "lambda-${var.name}-${var.env}-service-role"
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
      identifiers = [
        "lambda.amazonaws.com",
      ]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

locals {
  s3_sub_dir = [for item in var.s3_arn : "${item}/*"]
}

# Extra policies
data "aws_iam_policy_document" "codebuild_policies" {
  statement {
    actions = [
      "lambda:GetFunction",
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
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*",
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

    resources = local.s3_sub_dir
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket",
    ]

    resources = length(var.s3_arn) > 0 ? var.s3_arn : ["arn:aws:s3:::*"]
  }
}
