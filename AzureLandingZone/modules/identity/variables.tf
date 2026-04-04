variable "users" {
  description = "Map of users"
  type = map(object({
    user_principal_name = string
    display_name        = string
    password            = string
  }))
}

variable "groups" {
  description = "Map of groups"
  type = map(object({
    display_name = string
    description  = string
  }))
}

variable "role_assignments" {
  description = "Map of role assignments"
  type = map(object({
    scope                = string
    role_definition_name = string
    principal_id         = string
  }))
}