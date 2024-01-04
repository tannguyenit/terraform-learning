resource "aws_codestarconnections_connection" "main" {
  name          = var.name
  provider_type = var.type
}