variable "aws_ecs_cluster_name" {
    type = string
    description = "(optional) describe your variable"
}
variable "aws_ecs_service_name" {
    type = string
    description = "(optional) describe your variable"
}
variable "max_capacity" {
    type = number
    description = "Max capacity of the scalable target."
}
variable "min_capacity" {
    type = number
    description = "Min capacity of the scalable target."
    default = 1
}

variable "metric_type" {
    type = string
    description = "Aggregation type for the policy's metrics."
    default = "Maximum"

    validation {
        condition = contains(["Minimum", "Maximum", "Average"], var.metric_type)
        error_message = "Valid values are Minimum, Maximum, and Average."
    }
}
variable "cpu_percent" {
    type = object({
      hight = string
      low = string
    })
    description = "The object defined percent of cpu will be trigger scale"
    default = {
      hight = "80"
      low = "20"
    }
}