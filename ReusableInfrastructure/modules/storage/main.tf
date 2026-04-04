###############################################################################
# Storage Module - Storage Accounts, Blob, File Shares
###############################################################################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.50.0"
    }
  }
}

variable "enabled" {
  description = "Enable/disable this module"
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the storage account (must be globally unique, lowercase)"
  type        = string
}

variable "account_kind" {
  description = "Kind of storage account (Storage, StorageV2, BlobStorage)"
  type        = string
  default     = "StorageV2"
  validation {
    condition     = contains(["Storage", "StorageV2", "BlobStorage"], var.account_kind)
    error_message = "Account kind must be Storage, StorageV2, or BlobStorage."
  }
}

variable "account_tier" {
  description = "Performance tier (Standard, Premium)"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "Account tier must be Standard or Premium."
  }
}

variable "replication_type" {
  description = "Replication type (LRS, GRS, RAGRS, ZRS)"
  type        = string
  default     = "LRS"
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS"], var.replication_type)
    error_message = "Replication type must be LRS, GRS, RAGRS, or ZRS."
  }
}

variable "enable_blob_container" {
  description = "Enable blob container creation"
  type        = bool
  default     = true
}

variable "blob_container_name" {
  description = "Name of the blob container"
  type        = string
  default     = "data"
}

variable "blob_container_access_type" {
  description = "Access type for blob container (Private, Blob, Container)"
  type        = string
  default     = "Private"
  validation {
    condition     = contains(["Private", "Blob", "Container"], var.blob_container_access_type)
    error_message = "Access type must be Private, Blob, or Container."
  }
}

variable "enable_file_share" {
  description = "Enable file share creation"
  type        = bool
  default     = false
}

variable "file_share_name" {
  description = "Name of the file share"
  type        = string
  default     = "share"
}

variable "file_share_quota" {
  description = "File share quota in GB"
  type        = number
  default     = 100
  validation {
    condition     = var.file_share_quota >= 1 && var.file_share_quota <= 102400
    error_message = "File share quota must be between 1 and 102400 GB."
  }
}

variable "enable_acl" {
  description = "Enable network ACLs"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

# Storage Account
resource "azurerm_storage_account" "main" {
  count = var.enabled ? 1 : 0

  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_kind             = var.account_kind
  account_tier             = var.account_tier
  account_replication_type = var.replication_type

  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2"
  shared_access_key_enabled  = true

  # Network ACLs (optional)
  network_rules {
    default_action = var.enable_acl ? "Deny" : "Allow"
    bypass         = ["AzureServices"]
  }

  tags = var.tags
}

# Blob Container
resource "azurerm_storage_container" "main" {
  count = var.enabled && var.enable_blob_container ? 1 : 0

  name                  = var.blob_container_name
  storage_account_name  = azurerm_storage_account.main[0].name
  container_access_type = var.blob_container_access_type
}

# File Share
resource "azurerm_storage_share" "main" {
  count = var.enabled && var.enable_file_share ? 1 : 0

  name                 = var.file_share_name
  storage_account_name = azurerm_storage_account.main[0].name
  quota                = var.file_share_quota
}

# Blob Lifecycle Management (optional - for automatic data tiering)
resource "azurerm_storage_management_policy" "tiering" {
  count = var.enabled && var.account_kind == "StorageV2" ? 1 : 0

  storage_account_id = azurerm_storage_account.main[0].id

  rule {
    name    = "archive-old-blobs"
    enabled = true

    filters {
      prefix_match = [""]
      blob_types   = ["blockBlob"]
    }

    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 30
        tier_to_archive_after_days_since_modification_greater_than = 90
        delete_after_days_since_modification_greater_than          = 365
      }

      snapshot {
        delete_after_days_since_creation_greater_than = 30
      }
    }
  }
}

# Outputs
output "storage_account_id" {
  value       = try(azurerm_storage_account.main[0].id, null)
  description = "Storage Account ID"
}

output "storage_account_name" {
  value       = try(azurerm_storage_account.main[0].name, null)
  description = "Storage Account name"
}

output "storage_account_primary_blob_endpoint" {
  value       = try(azurerm_storage_account.main[0].primary_blob_endpoint, null)
  description = "Primary blob endpoint"
}

output "blob_container_id" {
  value       = try(azurerm_storage_container.main[0].id, null)
  description = "Blob Container ID"
}

output "file_share_id" {
  value       = try(azurerm_storage_share.main[0].id, null)
  description = "File Share ID"
}

output "storage_access_key" {
  value       = try(azurerm_storage_account.main[0].primary_access_key, null)
  description = "Storage Account Primary Access Key"
  sensitive   = true
}

output "storage_connection_string" {
  value       = try(azurerm_storage_account.main[0].primary_connection_string, null)
  description = "Storage Account Primary Connection String"
  sensitive   = true
}
