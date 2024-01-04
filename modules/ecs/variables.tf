variable "ecs_cluster_name" {
    type = string
    description = "ECS Cluster name"
    default = ""
}

variable "tags" {
    description = "Tag of resource"
    default = {}
}