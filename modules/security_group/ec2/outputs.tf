output "ssh_security_group_id" {
    description = "The ecs security group id"
    value       = aws_security_group.ec2_ssh.id
}