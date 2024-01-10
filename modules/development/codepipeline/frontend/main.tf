resource "aws_codepipeline" "main" {
  name     = var.codepipeline_name
  role_arn = var.codepipeline_role_arn

  artifact_store {
    location = var.artifact_store_location
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.aws_codestar_connection
        FullRepositoryId = var.repository_id
        BranchName       = var.repository_branch
      }
    }
  }

  stage {
    name = "Build_And_Invalid_Cloudfront_Cache"

    action {
      name             = "Build_And_Invalid_Cloudfront_Cache"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = var.aws_codebuild_project_name
      }
    }
  }
}
