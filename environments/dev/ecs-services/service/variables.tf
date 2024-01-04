variable "env" {
  type        = string
  description = "(optional) describe your variable"
}
variable "project_name" {
  type        = string
  description = "(optional) describe your variable"
}
variable "vpc_id" {
  type        = string
  description = "(optional) describe your variable"
}

variable "aws_region" {
  type        = string
  description = "(optional) describe your variable"
}

variable "codebuild_config" {
  type = object({
    buildspec              = string
    codebuild_service_role = string
    codebuild_env = list(object({
      name  = string
      value = string
      type  = optional(string, "PLAINTEXT")
    }))
  })
  default = {
    buildspec              = "deployment/buildspec.yml"
    codebuild_service_role = ""
    codebuild_env          = []
  }
}

variable "ecs" {
  type = object({
    cluster_arn                    = string
    cluster_name                   = string
    service_name                   = string
    service_discovery_namespace_id = string
    task_execution_role_arn        = string
    task_security_group_id         = string
    vpc_subnet_ids                 = list(string)
    alb_target_group_arn           = string
    app_port                       = number
    fargate_cpu                    = number
    fargate_memory                 = number
    app_container_name             = optional(string)
  })

  default = {
    cluster_arn                    = ""
    cluster_name                   = ""
    service_name                   = ""
    service_discovery_namespace_id = ""
    task_execution_role_arn        = ""
    task_security_group_id         = ""
    vpc_subnet_ids                 = []
    alb_target_group_arn           = ""
    app_port                       = 80
    fargate_cpu                    = 256
    fargate_memory                 = 512
    app_container_name             = "app"
  }
}

variable "codepipeline" {
  type = object({
    connection_arn             = string
    repository_id              = string
    repository_branch          = string
    codepipeline_service_role  = string
    s3_artifact_store_location = string
  })
  default = {
    connection_arn             = ""
    repository_id              = ""
    repository_branch          = ""
    codepipeline_service_role  = ""
    s3_artifact_store_location = ""
  }
  description = "(optional) describe your variable"
}

variable "autoscaling" {
  type = object({
    max_capacity             = number
    min_capacity              = number
  })
  default = {
    max_capacity             = 1
    min_capacity              = 1
  }
}