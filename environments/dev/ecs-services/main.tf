
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.30.0"
    }
  }
  backend "s3" {
    bucket         = "poc-s3-backend"
    key            = "dev/ecs-service.tfstate"
    region         = "us-east-2"
    dynamodb_table = "poc-s3-backend"
    role_arn       = "arn:aws:iam::773801579928:role/PocS3BackendRole"
  }
}

locals {
  task_container_name = "app"
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

data "aws_ecs_cluster" "main" {
  cluster_name = var.ecs_cluster_name
}

data "aws_lb" "main" {
  name = "${var.project_name}-${var.env}-alb"
}

data "aws_service_discovery_dns_namespace" "main" {
  name = "poc.local"
  type = "DNS_PRIVATE"
}

data "aws_codestarconnections_connection" "main" {
  name = "Github Connection"
}

module "codebuild-iam" {
  source = "../../../modules/iam/codebuild"
  name   = var.project_name
  env    = var.env
}

module "codepipeline-iam" {
  source          = "../../../modules/iam/codepipeline"
  name            = var.project_name
  env             = var.env
  ecs_cluster_arn = data.aws_ecs_cluster.main.arn
}

resource "aws_s3_bucket" "code_pipeline" {
  bucket = "codepipeline-${var.project_name}-${var.env}"
  force_destroy = true

  tags = {
    Name        = "codepipeline for ecs"
    Environment = var.env
  }
}

module "gateway-service" {
  source       = "./service"
  env          = var.env
  aws_region   = var.aws_region
  vpc_id       = var.vpc_id
  project_name = var.project_name
  codebuild_config = {
    buildspec              = "deployment/buildspec.yml"
    codebuild_service_role = module.codebuild-iam.arn
    codebuild_env = [
      {
        name  = "USER_SERVICE_API_BASE"
        value = "user-svc.poc.local"
      }
    ]
  }
  ecs = {
    # Data value
    cluster_arn                    = data.aws_ecs_cluster.main.arn
    cluster_name                   = data.aws_ecs_cluster.main.cluster_name
    service_discovery_namespace_id = data.aws_service_discovery_dns_namespace.main.id
    # Variable value
    task_execution_role_arn = var.ecs_task_execution_role_arn
    task_security_group_id  = var.ecs_task_security_group_id
    vpc_subnet_ids          = var.vpc_subnet_ids
    alb_target_group_arn    = var.alb_target_group_arn
    # raw value
    service_name       = "gateway-svc"
    app_port           = 80
    fargate_cpu        = 256
    fargate_memory     = 512
    app_container_name = local.task_container_name
  }

  codepipeline = {
    connection_arn             = data.aws_codestarconnections_connection.main.arn
    codepipeline_service_role  = module.codepipeline-iam.arn
    s3_artifact_store_location = aws_s3_bucket.code_pipeline.id
    # raw value
    repository_id     = "tannguyenbsm/poc-api-gw"
    repository_branch = "dev"
  }
  autoscaling = {
    max_capacity = 3
    min_capacity = 1
  }
}

module "user-service-event" {
  source = "../../../modules/eventRule"
  schedule_name = "send-mail-to-lender"
  schedule_desc = "send email to lender if not have logo"
  schedule_expression = "rate(12 hours)"
  ecs_command_overrides = ["/usr/local/bin/node", "cronjob.js"]
  ecs_cluster_arn = data.aws_ecs_cluster.main.arn
  execution_role_arn = var.ecs_event_execution_role_arn
  ecs_service_name = module.user-service.service_name
  ecs_container_name = local.task_container_name
  vpc_subnets = var.vpc_subnet_ids
  vpc_security_groups = [var.ecs_task_security_group_id]
  ecs_task_definition_arn = module.user-service.task_definition_arn_without_revision
}

module "user-service" {
  source       = "./service"
  env          = var.env
  aws_region   = var.aws_region
  vpc_id       = var.vpc_id
  project_name = var.project_name
  codebuild_config = {
    buildspec              = "deployment/buildspec.yml"
    codebuild_service_role = module.codebuild-iam.arn
    codebuild_env          = []
  }
  ecs = {
    # Data value
    cluster_arn                    = data.aws_ecs_cluster.main.arn
    cluster_name                   = data.aws_ecs_cluster.main.cluster_name
    service_discovery_namespace_id = data.aws_service_discovery_dns_namespace.main.id
    # Variable value
    task_execution_role_arn = var.ecs_task_execution_role_arn
    task_security_group_id  = var.ecs_task_security_group_id
    vpc_subnet_ids          = var.vpc_subnet_ids
    alb_target_group_arn    = ""
    # raw value
    service_name       = "user-svc"
    app_port           = 80
    fargate_cpu        = 256
    fargate_memory     = 512
    app_container_name = local.task_container_name
  }

  codepipeline = {
    connection_arn             = data.aws_codestarconnections_connection.main.arn
    codepipeline_service_role  = module.codepipeline-iam.arn
    s3_artifact_store_location = aws_s3_bucket.code_pipeline.id
    # raw value
    repository_id     = "tannguyenbsm/poc-user-svc"
    repository_branch = "dev"
  }

  autoscaling = {
    max_capacity = 3
    min_capacity = 1
  }
}
