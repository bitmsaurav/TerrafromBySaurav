variable "enabled" {
  description = "Enable or disable security resources"
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "Resource group containing security resources"
  type        = string
}

variable "location" {
  description = "Azure region for the security resources"
  type        = string
}

variable "key_vault_name" {
  description = "Name of the Azure Key Vault"
  type        = string
}

variable "enable_key_vault" {
  description = "Enable Key Vault creation"
  type        = bool
  default     = true
}

variable "access_policies" {
  description = "Key Vault access policies"
  type = map(object({
    tenant_id = string
    object_id = string
    permissions = object({
      keys         = list(string)
      secrets      = list(string)
      certificates = list(string)
    })
  }))
  default = {}
}

variable "enable_user_assigned_identity" {
  description = "Create a user-assigned managed identity"
  type        = bool
  default     = false
}

variable "identity_name" {
  description = "Name of the user-assigned identity"
  type        = string
  default     = ""
}

variable "role_assignments" {
  description = "Optional IAM role assignments"
  type = map(object({
    principal_id         = string
    role_definition_name = string
    scope                = string
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to security resources"
  type        = map(string)
}
