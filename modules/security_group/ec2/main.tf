resource "aws_security_group" "ec2_ssh" {
    name        = var.ec2_security_group_name
    description = var.ec2_security_group_description
    vpc_id      = var.vpc_id
    ingress {
        from_port       = var.ingress_ssh_port
        to_port         = var.ingress_ssh_port
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}