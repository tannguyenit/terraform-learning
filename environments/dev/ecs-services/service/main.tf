locals {
  code_build_env = [
    {
      name  = "AWS_REGION",
      value = var.aws_region
    },
    {
      name  = "REPOSITORY_URI"
      value = module.ecr.url
    },
    {
      name  = "ECR_URI"
      value = "${module.ecr.registry_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
    },
  ]
}

module "ecr" {
  source               = "../../../../modules/ecr"
  project_name         = var.ecs.service_name
  env                  = var.env
  force_delete         = true
  keep_tag_image_count = 10
  keep_tag_prefix_list = ["v"]
  expired_image_days   = 7
}

module "code-build" {
  source                = "../../../../modules/development/codebuild"
  name                  = "${var.ecs.service_name}-${var.env}-codebuild"
  service_role          = var.codebuild_config.codebuild_service_role
  buildspec             = var.codebuild_config.buildspec
  environment_variables = concat(local.code_build_env, var.codebuild_config.codebuild_env)
}

module "code-pipeline" {
  source                     = "../../../../modules/development/codepipeline"
  aws_codestar_connection    = var.codepipeline.connection_arn
  aws_region                 = var.aws_region
  aws_codebuild_project_name = module.code-build.name
  repository_id              = var.codepipeline.repository_id
  repository_branch          = var.codepipeline.repository_branch
  artifact_store_location    = var.codepipeline.s3_artifact_store_location
  codepipeline_role_arn      = var.codepipeline.codepipeline_service_role
  codepipeline_name          = "${var.ecs.service_name}-${var.env}-codepipeline"
  ecs_cluster_name           = var.ecs.cluster_name
  ecs_service_name           = var.ecs.service_name
}

module "auto-scaling" {
  source = "../../../../modules/autoscaling"
  aws_ecs_cluster_name = var.ecs.cluster_name
  aws_ecs_service_name = module.ecs-service.service_name
  max_capacity = var.autoscaling.max_capacity
  min_capacity = var.autoscaling.min_capacity
}

module "ecs-service" {
  source                      = "../../../../modules/ecs/services"
  aws_region                  = var.aws_region
  ecs_task_execution_role_arn = var.ecs.task_execution_role_arn
  ecs_task_security_group_id  = var.ecs.task_security_group_id
  ecs_cluster_id              = var.ecs.cluster_arn
  vpc_subnet_ids              = var.ecs.vpc_subnet_ids
  target_group_arn            = var.ecs.alb_target_group_arn

  app_image                      = module.ecr.url
  app_port                       = var.ecs.app_port
  fargate_cpu                    = var.ecs.fargate_cpu
  fargate_memory                 = var.ecs.fargate_memory
  cloudwatch_log_group_name      = "/ecs/${var.ecs.cluster_name}/${var.ecs.service_name}"
  container_name                 = var.ecs.app_container_name
  ecs_task_definition_family     = "${var.ecs.service_name}-td"
  ecs_service_name               = var.ecs.service_name
  service_discovery_namespace_id = var.ecs.service_discovery_namespace_id
}
