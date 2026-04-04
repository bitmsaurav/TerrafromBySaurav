output "identity_id" {
  description = "User-assigned managed identity ID"
  value       = try(azurerm_user_assigned_identity.main[0].id, null)
}

output "key_vault_uri" {
  description = "Key Vault URI"
  value       = try(azurerm_key_vault.main[0].vault_uri, null)
}
