data "azurerm_client_config" "current" {}

data "azurerm_role_definition" "roles" {
  for_each = var.enabled ? var.role_assignments : {}
  name     = each.value.role_definition_name
}

resource "azurerm_user_assigned_identity" "main" {
  count               = var.enabled && var.enable_user_assigned_identity ? 1 : 0
  name                = var.identity_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_key_vault" "main" {
  count                    = var.enabled && var.enable_key_vault ? 1 : 0
  name                     = var.key_vault_name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 90
  purge_protection_enabled    = true

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "main" {
  for_each = var.enabled && var.enable_key_vault ? var.access_policies : {}

  key_vault_id = azurerm_key_vault.main[0].id
  tenant_id    = each.value.tenant_id
  object_id    = each.value.object_id

  key_permissions         = each.value.permissions.keys
  secret_permissions      = each.value.permissions.secrets
  certificate_permissions = each.value.permissions.certificates
}

resource "azurerm_role_assignment" "main" {
  for_each = var.enabled ? var.role_assignments : {}

  scope              = each.value.scope
  role_definition_id = data.azurerm_role_definition.roles[each.key].id
  principal_id       = each.value.principal_id
}

output "identity_id" {
  value       = try(azurerm_user_assigned_identity.main[0].id, null)
  description = "User-assigned identity resource ID"
}

output "key_vault_uri" {
  value       = try(azurerm_key_vault.main[0].vault_uri, null)
  description = "Key Vault URI"
}
