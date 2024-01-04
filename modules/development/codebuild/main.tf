resource "aws_codebuild_project" "main" {
  name         = var.name
  build_timeout = 15
  queued_timeout = 5
  service_role = var.service_role

  artifacts {
    type     = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    dynamic "environment_variable" {
        for_each = var.environment_variables

        content {
            name  = environment_variable.value["name"]
            value = environment_variable.value["value"]
            type  = environment_variable.value["type"]
        }
    }
  }

  source {
    type = "CODEPIPELINE"
    buildspec = var.buildspec
  }
}
