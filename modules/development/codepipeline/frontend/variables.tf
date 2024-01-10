variable "aws_region" {
    type = string
    description = "(optional) describe your variable"
}
variable "aws_codestar_connection" {
    type = string
    description = "(optional) describe your variable"
}
variable "codepipeline_role_arn" {
    type = string
    description = "(optional) describe your variable"
}
variable "codepipeline_name" {
    type = string
    description = "(optional) describe your variable"
}
variable "artifact_store_location" {
    type = string
    description = "(optional) describe your variable"
}
variable "artifact_store_type" {
    type = string
    description = "(optional) describe your variable"
    default = "S3"
}
variable "aws_codebuild_project_name" {
    type = string
    description = "(optional) describe your variable"
}
variable "repository_id" {
    type = string
    description = "(optional) describe your variable"
}
variable "repository_branch" {
    type = string
    description = "(optional) describe your variable"
}
