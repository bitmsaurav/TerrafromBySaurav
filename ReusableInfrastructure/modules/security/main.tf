###############################################################################
# Security Module - Key Vault, NSG Rules, Firewall, Managed Identities
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

variable "enable_key_vault" {
  description = "Enable Key Vault creation"
  type        = bool
  default     = true
}

variable "key_vault_name" {
  description = "Name of the Key Vault (must be globally unique)"
  type        = string
}

variable "key_vault_sku" {
  description = "SKU of Key Vault (standard, premium)"
  type        = string
  default     = "standard"
  validation {
    condition     = contains(["standard", "premium"], var.key_vault_sku)
    error_message = "Key Vault SKU must be standard or premium."
  }
}

variable "enable_acl" {
  description = "Enable network ACLs for Key Vault"
  type        = bool
  default     = true
}

variable "enable_nsg" {
  description = "Enable NSG configuration"
  type        = bool
  default     = true
}

variable "nsg_id" {
  description = "Network Security Group ID"
  type        = string
}

variable "nsg_name" {
  description = "Network Security Group name"
  type        = string
}

variable "enable_firewall" {
  description = "Enable Azure Firewall"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

# Data source for current user
data "azurerm_client_config" "current" {}

# Key Vault
resource "azurerm_key_vault" "main" {
  count = var.enabled && var.enable_key_vault ? 1 : 0

  name                = var.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.key_vault_sku

  soft_delete_retention_days      = 7
  purge_protection_enabled        = true
  enable_rbac_authorization       = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  enabled_for_disk_encryption     = true

  tags = var.tags
}

# Key Vault Access Policy for current user
resource "azurerm_key_vault_access_policy" "current_user" {
  count = var.enabled && var.enable_key_vault ? 1 : 0

  key_vault_id = azurerm_key_vault.main[0].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "List",
    "Update",
    "Recover",
    "Backup",
    "Restore",
  ]

  secret_permissions = [
    "Delete",
    "Get",
    "List",
    "Set",
    "Recover",
    "Backup",
    "Restore",
  ]

  certificate_permissions = [
    "Create",
    "Delete",
    "Get",
    "List",
    "Update",
    "Recover",
    "Backup",
    "Restore",
  ]
}

# Example secret in Key Vault
resource "azurerm_key_vault_secret" "database_password" {
  count = var.enabled && var.enable_key_vault ? 1 : 0

  name         = "database-password"
  value        = random_password.db_password[0].result
  key_vault_id = azurerm_key_vault.main[0].id

  depends_on = [azurerm_key_vault_access_policy.current_user]
}

# Random password for demonstration
resource "random_password" "db_password" {
  count = var.enabled && var.enable_key_vault ? 1 : 0

  length  = 32
  special = true
}

# Network ACL rule for Key Vault (allow VNet access)
resource "azurerm_key_vault_network_rule" "vnet_rule" {
  count = var.enabled && var.enable_key_vault && var.enable_acl ? 1 : 0

  key_vault_id   = azurerm_key_vault.main[0].id
  default_action = "Deny"
  bypass         = ["AzureServices"]
}

# NSG Security Rules for application-specific access
resource "azurerm_network_security_rule" "allow_http" {
  count = var.enabled && var.enable_nsg ? 1 : 0

  name                        = "AllowHTTP"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.nsg_name
}

resource "azurerm_network_security_rule" "allow_https" {
  count = var.enabled && var.enable_nsg ? 1 : 0

  name                        = "AllowHTTPS"
  priority                    = 201
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.nsg_name
}

# User-Assigned Managed Identity (for applications)
resource "azurerm_user_assigned_identity" "main" {
  count = var.enabled ? 1 : 0

  name                = "${var.key_vault_name}-identity"
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = var.tags
}

# Outputs
output "key_vault_id" {
  value       = try(azurerm_key_vault.main[0].id, null)
  description = "Key Vault ID"
}

output "key_vault_name" {
  value       = try(azurerm_key_vault.main[0].name, null)
  description = "Key Vault name"
}

output "key_vault_uri" {
  value       = try(azurerm_key_vault.main[0].vault_uri, null)
  description = "Key Vault URI"
}

output "managed_identity_id" {
  value       = try(azurerm_user_assigned_identity.main[0].id, null)
  description = "Managed Identity ID"
}

output "managed_identity_principal_id" {
  value       = try(azurerm_user_assigned_identity.main[0].principal_id, null)
  description = "Managed Identity Principal ID"
}
