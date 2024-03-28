data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Service role
resource "aws_iam_role" "service_role" {
  name               = "codebuild-${var.name}-${var.env}-service-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role_policy.json
}

resource "aws_iam_policy" "main" {
  name        = "code-build-policy"
  path        = "/"
  description = "Code build policy"
  policy      = data.aws_iam_policy_document.codebuild_policies.json
}

resource "aws_iam_role_policy_attachment" "attachment_custom_policies" {
  policy_arn = aws_iam_policy.main.arn
  role       = aws_iam_role.service_role.id
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
        "codebuild.amazonaws.com",
        "lambda.amazonaws.com",
        "logs.amazonaws.com",
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
      "logs:TagResource",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/*",
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*",
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

    resources = concat(["arn:aws:s3:::codepipeline-*"], local.s3_sub_dir)
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket",
    ]

    resources = length(var.s3_arn) > 0 ? var.s3_arn : ["arn:aws:s3:::*"]
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

  statement {
    effect = "Allow"

    actions = [
      "cloudfront:CreateInvalidation",
    ]

    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "iam:PassRole",
    ]

    resources = var.iam_pass_role
  }

  statement {
    effect = "Allow"

    actions = [
        "cloudformation:CreateChangeSet",
        "cloudformation:CreateStack",
        "cloudformation:DeleteChangeSet",
        "cloudformation:DeleteStack",
        "cloudformation:DescribeChangeSet",
        "cloudformation:DescribeStackEvents",
        "cloudformation:DescribeStackResource",
        "cloudformation:DescribeStackResources",
        "cloudformation:DescribeStacks",
        "cloudformation:ExecuteChangeSet",
        "cloudformation:ListStackResources",
        "cloudformation:SetStackPolicy",
        "cloudformation:UpdateStack",
        "cloudformation:UpdateTerminationProtection",
        "cloudformation:GetTemplate",
        "cloudformation:ValidateTemplate"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
        "lambda:Get*",
				"lambda:List*",
				"lambda:CreateFunction",
				"lambda:DeleteFunction",
				"lambda:CreateFunction",
				"lambda:DeleteFunction",
				"lambda:UpdateFunctionConfiguration",
				"lambda:UpdateFunctionCode",
				"lambda:PublishVersion",
				"lambda:CreateAlias",
				"lambda:DeleteAlias",
				"lambda:UpdateAlias",
				"lambda:AddPermission",
				"lambda:RemovePermission",
				"lambda:InvokeFunction"
    ]

    resources = [
      "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:*"
    ]
  }
}
