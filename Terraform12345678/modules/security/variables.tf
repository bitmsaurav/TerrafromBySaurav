variable "policy_definitions" {
  description = "Map of policy definitions to create"
  type = map(object({
    name         = string
    policy_type  = string
    mode         = string
    display_name = string
    description  = string
    category     = string
    policy_rule  = any
    parameters   = optional(any)
  }))
}

variable "policy_assignments" {
  description = "Map of policy assignments"
  type = map(object({
    name                    = string
    scope                   = string
    policy_definition_key   = string
    description             = string
    display_name            = string
    identity = optional(object({
      type = string
    }))
    parameters = optional(any)
  }))
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}