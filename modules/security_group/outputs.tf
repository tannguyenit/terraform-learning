output "alb_security_group_id" {
    description = "The ALB security group id"
    value       = aws_security_group.alb.id
}

output "ecs_container_security_group_id" {
    description = "The ecs task security group id"
    value       = aws_security_group.ecs_containser.id
}