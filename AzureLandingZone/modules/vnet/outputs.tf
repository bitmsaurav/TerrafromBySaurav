output "virtual_network_ids" {
  description = "Virtual Network IDs"
  value       = { for k, v in azurerm_virtual_network.this : k => v.id }
}

output "virtual_network_names" {
  description = "Virtual Network names"
  value       = { for k, v in azurerm_virtual_network.this : k => v.name }
}