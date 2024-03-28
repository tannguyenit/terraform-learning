variable "name" {
    type = string
    description = "(optional) describe your variable"
}
variable "env" {
    type = string
    description = "(optional) describe your variable"
}
variable "s3_arn" {
    type = list(string)
    description = "(optional) describe your variable"
    default = []
}
