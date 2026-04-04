output "id" {
  value       = try(azurerm_virtual_network.main[0].id, null)
  description = "Virtual network resource ID"
}

output "name" {
  value       = try(azurerm_virtual_network.main[0].name, null)
  description = "Virtual network name"
}
