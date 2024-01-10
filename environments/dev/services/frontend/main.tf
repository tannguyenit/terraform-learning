
module "code-build" {
  source                = "../../../../modules/development/codebuild"
  name                  = "${var.app_name}-${var.env}-codebuild"
  service_role          = var.codebuild_config.codebuild_service_role
  buildspec             = var.codebuild_config.buildspec
  environment_variables = var.codebuild_config.codebuild_env
}

module "code-pipeline" {
  source                     = "../../../../modules/development/codepipeline/frontend"
  aws_codestar_connection    = var.codepipeline.connection_arn
  aws_region                 = var.aws_region
  aws_codebuild_project_name = module.code-build.name
  repository_id              = var.codepipeline.repository_id
  repository_branch          = var.codepipeline.repository_branch
  artifact_store_location    = var.codepipeline.s3_artifact_store_location
  codepipeline_role_arn      = var.codepipeline.codepipeline_service_role
  codepipeline_name          = "${var.app_name}-${var.env}-codepipeline"
}
