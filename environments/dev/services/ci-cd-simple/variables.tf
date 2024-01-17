variable "env" {
  type        = string
  description = "(optional) describe your variable"
}
variable "app_name" {
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

variable "codepipeline" {
  type = object({
    connection_arn             = string
    repository_id              = string
    repository_branch          = string
    codepipeline_service_role  = string
    s3_artifact_store_location = string
    build_stage_name_alias     = string
  })
  default = {
    connection_arn             = ""
    repository_id              = ""
    repository_branch          = ""
    codepipeline_service_role  = ""
    s3_artifact_store_location = ""
    build_stage_name_alias     = "Build"
  }
  description = "(optional) describe your variable"
}

