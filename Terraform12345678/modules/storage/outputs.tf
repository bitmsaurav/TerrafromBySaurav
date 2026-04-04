output "storage_account_ids" {
  description = "IDs of the created storage accounts"
  value       = { for k, v in azurerm_storage_account.this : k => v.id }
}

output "storage_account_names" {
  description = "Names of the created storage accounts"
  value       = { for k, v in azurerm_storage_account.this : k => v.name }
}

output "storage_container_ids" {
  description = "IDs of the created storage containers"
  value       = { for k, v in azurerm_storage_container.this : k => v.id }
}