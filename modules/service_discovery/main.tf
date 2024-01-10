resource "aws_service_discovery_http_namespace" "main" {
  name        = var.private_dns_namespace
  description = "Service discovery API Call"

  tags = {
    Name = "${var.private_dns_namespace}-${var.env}-sdv"
  }
}
