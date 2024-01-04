resource "aws_service_discovery_private_dns_namespace" "main" {
  name        = var.private_dns_namespace
  description = "private dns namespace"
  vpc         = var.vpc_id

  tags = {
    Name = "${var.private_dns_namespace}-${var.env}-sdv"
  }
}