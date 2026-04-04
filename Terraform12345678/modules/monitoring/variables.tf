variable "log_analytics_workspaces" {
  description = "Map of Log Analytics workspaces to create"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    sku                 = string
    retention_in_days   = optional(number)
    tags                = optional(map(string))
  }))
}

variable "diagnostic_settings" {
  description = "Map of diagnostic settings"
  type = map(object({
    name               = string
    target_resource_id = string
    workspace_key      = string
    logs = list(object({
      category = string
      enabled  = bool
      retention_policy = optional(object({
        enabled = bool
        days    = number
      }))
    }))
    metrics = list(object({
      category = string
      enabled  = bool
      retention_policy = optional(object({
        enabled = bool
        days    = number
      }))
    }))
  }))
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}