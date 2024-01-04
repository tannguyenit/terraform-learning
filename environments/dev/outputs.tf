
output "ecs_service" {
    value = {
        project_name = var.project_name
        env = var.env
        vpc_id = module.vpc.vpc_id
        vpc_subnet_ids = module.vpc.public_subnets
        ecs_cluster_id = module.ecs.id
        ecs_cluster_name = module.ecs.cluster_name
        ecs_task_execution_role_arn = module.ecs_iam.task_excution_role_arn
        ecs_task_security_group_id = module.security_group.ecs_container_security_group_id
        alb_target_group_arn = module.alb.alb_target_group_id
        event_execution_role_arn = module.ecs_event.excution_role_arn
    }
}