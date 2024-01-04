resource "aws_lb" "main" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_groups]
  subnets            = var.aws_public_subnets

  enable_deletion_protection = false

  tags = {
    Name        = "${var.name}-${var.environment}-alb"
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "main" {
  name        = "${var.name}-${var.environment}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.name}-${var.environment}-tg"
    Environment = var.environment
  }
  depends_on = [aws_lb.main]
}

# Redirect all traffic from the ALB to the target group

resource "aws_lb_listener" "http" {
    count             = var.is_ssl == true ? 0 : 1
    load_balancer_arn = aws_lb.main.id
    port              = 80
    protocol          = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.main.id
    }
}

# Redirect all traffic from the ALB to the https
resource "aws_lb_listener" "http_redirect" {
    count             = var.is_ssl == true ? 1 : 0
    load_balancer_arn = aws_lb.main.id
    port              = 80
    protocol          = "HTTP"

    default_action {
        type = "redirect"
        redirect {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
        }
    }
}

# Redirect traffic to target group
resource "aws_lb_listener" "https" {
    count             = var.is_ssl == true ? 1 : 0
    load_balancer_arn = aws_lb.main.id
    port              = 443
    protocol          = "HTTPS"
    ssl_policy        = "ELBSecurityPolicy-2016-08"
    certificate_arn   = var.certificate_arn_attach_alb_listener
    default_action {
        target_group_arn = aws_lb_target_group.main.id
        type             = "forward"
    }
}