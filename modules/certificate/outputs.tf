output "acm_certificate_arn" {
    description = "The ARN of the certificate that is being validated."
    value       = aws_acm_certificate.certificate.arn
}
