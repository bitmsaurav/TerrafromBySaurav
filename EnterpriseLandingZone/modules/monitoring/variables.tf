variable "enabled" {
  description = "Enable or disable monitoring resources"
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "Resource group for monitoring resources"
  type        = string
}

variable "location" {
  description = "Azure region for monitoring resources"
  type        = string
}

variable "log_analytics_name" {
  description = "Log Analytics workspace name"
  type        = string
}

variable "retention_in_days" {
  description = "Log Analytics retention days"
  type        = number
  default     = 30
}

variable "enable_app_insights" {
  description = "Enable Application Insights"
  type        = bool
  default     = false
}

variable "app_insights_name" {
  description = "Name of the Application Insights resource"
  type        = string
  default     = ""
}

variable "policy_definitions" {
  description = "Custom policy definitions that should be created and assigned"
  type = map(object({
    display_name = string
    description  = string
    policy_rule  = any
    metadata     = map(string)
    scope        = string
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to monitoring resources"
  type        = map(string)
}
