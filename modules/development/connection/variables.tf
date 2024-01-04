variable "name" {
    type = string
    description = "Connection name"
}

variable "type" {
    type = string
    description = "The name of the external provider where your third-party code repository is configured. Valid values are Bitbucket, GitHub or GitHubEnterpriseServer"
    validation {
      condition = contains(["Bitbucket", "GitHub", "GitHubEnterpriseServer"], var.type)
      error_message = "Valid values are Bitbucket, GitHub or GitHubEnterpriseServer"
    }
}