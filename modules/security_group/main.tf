# ALB Security Group: Edit to restrict access to the application
resource "aws_security_group" "alb" {
    name        = var.alb_security_group_name
    description = var.alb_security_group_description
    vpc_id      = var.vpc_id
    ingress {
        protocol    = "tcp"
        from_port   = 80
        to_port     = 80
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = var.alb_security_group_name
    }
}
# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_containser" {
    name        = var.ecs_tasks_security_group_name
    description = var.ecs_tasks_security_group_description
    vpc_id      = var.vpc_id
    ingress {
        protocol        = "tcp"
        from_port       = var.app_port
        to_port         = var.app_port
        security_groups = [aws_security_group.alb.id]
    }
    ingress {
        from_port       = var.app_port
        to_port         = var.app_port
        protocol        = "tcp"
        cidr_blocks = [var.vpc_cidr_block]
    }
    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = var.ecs_tasks_security_group_name
    }
}
