output "vpc_id" {
    description = "The VPC id"
    value       = var.is_exists_vpc ? data.aws_vpc.main[0].id : aws_vpc.main[0].id
}
output "public_subnet_ids" {
    description = "The id subnets public"
    value       = aws_subnet.public.*.id
}
output "app_private_subnet_ids" {
    description = "The id subnets private app"
    value       = aws_subnet.app_private.*.id
}
output "db_private_subnet_ids" {
    description = "The id subnets private db"
    value       = aws_subnet.db_private.*.id
}
output "vpc_cidr_block" {
    description = "The CIDR block for the VPC."
    value       = var.is_exists_vpc ? data.aws_vpc.main[0].cidr_block : aws_vpc.main[0].cidr_block
}