output "rds_security_group_id" {
    description = "The RDS security group id"
    value       = aws_security_group.rds.id
}
