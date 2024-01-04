output "alb_target_group_id" {
    description = "The alb target group id"
    value       = aws_lb_target_group.main.id
}
output "alb_zone_id" {
    description = "The alb zone id"
    value       = aws_lb.main.zone_id
}
output "alb_dns_name" {
    description = "The alb zone id"
    value       = aws_lb.main.dns_name
}