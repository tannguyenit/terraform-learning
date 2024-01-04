resource "aws_lb_target_group" "main" {
  name        = "${var.project_name}-${var.env}-lb-tg"
  port        = var.target_group_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path    = var.health_check_path
    matcher = 200
    timeout = 5
  }
}

data "aws_lb_listener" "main" {
  load_balancer_arn = var.load_balancer_arn
  port              = var.listener_port
}

resource "aws_lb_listener_rule" "path_pattern" {
  count        = var.path_pattern != "" ? 1 : 0
  listener_arn = data.aws_lb_listener.main.arn
  priority     = var.rule_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    path_pattern {
      values = [var.path_pattern]
    }
  }
}
