variable "name" {
  type = string
}

variable "stack" {
  description = "The stack to use for the app (default: \"scalingo-22\")."
  type    = string
  default = "scalingo-22"

  validation {
    condition     = contains(["scalingo-18", "scalingo-20", "scalingo-22"], var.stack)
    error_message = "The stack value must be one of the following: scalingo-18, scalingo-20, scalingo-22"
  }
}

variable "containers" {
  description = "Configuration of the containers of the application."
  type = map(object({
    size   = optional(string, "S")
    amount = optional(number, 1)
    autoscaler = optional(object({
      min_containers = optional(number, 2)
      max_containers = optional(number, 10)
      metric         = optional(string, "cpu")
      target         = optional(number, 0.8)
    }))
  }))
  default  = { web = { size = "S", amount = 0 } }
  nullable = false
}

variable "authorize_unsecure_http" {
  description = "When true, Scalingo does not automatically redirect HTTP traffic to HTTPS"
  type        = bool
  default     = false
  nullable    = false
}

variable "github_integration" {
  type = object({
    repo_url                              = string
    integration_uuid                      = optional(string)
    branch                                = optional(string, "main")
    auto_deploy_enabled                   = optional(bool, true)
    deploy_review_apps_enabled            = optional(bool, false)
    delete_on_close_enabled               = optional(bool, true)
    delete_stale_enabled                  = optional(bool, true)
    hours_before_delete_on_close          = optional(string, "0")
    hours_before_delete_stale             = optional(string, "72")
    automatic_creation_from_forks_allowed = optional(bool, false)
  })
  default = null
}

variable "gitlab_integration" {
  type = object({
    repo_url                              = string
    integration_uuid                      = optional(string)
    branch                                = optional(string, "main")
    auto_deploy_enabled                   = optional(bool, true)
    deploy_review_apps_enabled            = optional(bool, false)
    delete_on_close_enabled               = optional(bool, true)
    delete_stale_enabled                  = optional(bool, true)
    hours_before_delete_on_close          = optional(string, "0")
    hours_before_delete_stale             = optional(string, "72")
    automatic_creation_from_forks_allowed = optional(bool, false)
  })
  default = null
}

variable "additionnal_collaborators" {
  description = "List of emails of collaborators that have admin rights for the application"
  type        = list(string)
  default     = []
  nullable    = false

  validation {
    condition = alltrue([
      for email in var.additionnal_collaborators : 
        length(regexall("^([a-zA-Z0-9_\\-\\.]+)@([a-zA-Z0-9_\\-\\.]+)\\.([[:alpha:]]{2,5})$", email)) > 1
    ])
    error_message = "All elements in the list must be valid email addresses."
  }
}

variable "environment" {
  description = "Map of environment variables to set on the application"
  type        = map(string)
  default     = {}
}

variable "addons" {
  description = "List of addons to add to the application"
  type = list(object({
    provider          = string
    plan              = string
    database_features = optional(list(string))
  }))
  default  = []
  nullable = false
}

# TODO: implement notifier and alert
#
# variable "notifications" {
#   type = list(object({
#     name            = string
#     type            = string
#     active          = optional(bool, true)
#     emails          = optional(list(string), [])
#     send_all_alerts = optional(bool, false)
#     send_all_events = optional(bool, false)
#     events          = optional(list(string), [])
#     webhook_url     = optional(string, "")
#     container_alerts = object({
#       limit                   = optional(number, 0.8)
#       metric                  = optional(string, "cpu")
#       duration_before_trigger = optional(string)
#     })
#   }))
#   default  = []
#   nullable = false
# }

variable "domain" {
  description = "Main domain name of the application, known as \"canonical domain\" in Scalingo's dashboard. Notes that SSL configuration must be completed through the dashboard."
  type        = string
  default     = null
}

variable "domain_aliases" {
  description = "List of others domain names for the application"
  type        = list(string)
  default     = []
  nullable    = false
}

variable "log_drains" {
  type = list(object({
    type = string
    url  = optional(string, "")
  }))
  default  = []
  nullable = false
}
