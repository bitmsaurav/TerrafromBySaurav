variable "storage_accounts" {
  description = "Map of storage accounts to create"
  type = map(object({
    name                     = string
    resource_group_name      = string
    location                 = string
    account_tier             = string
    account_replication_type = string
    account_kind             = optional(string, "StorageV2")
    is_hns_enabled           = optional(bool, false)
    blob_properties = optional(object({
      delete_retention_policy = optional(object({
        days = number
      }))
    }))
    tags = optional(map(string))
  }))
}

variable "storage_containers" {
  description = "Map of storage containers to create"
  type = map(object({
    name                  = string
    storage_account_key   = string
    container_access_type = optional(string, "private")
  }))
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}