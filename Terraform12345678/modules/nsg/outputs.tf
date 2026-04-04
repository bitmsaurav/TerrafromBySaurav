output "nsg_ids" {
  description = "IDs of the created NSGs"
  value       = { for k, v in azurerm_network_security_group.this : k => v.id }
}

output "nsg_names" {
  description = "Names of the created NSGs"
  value       = { for k, v in azurerm_network_security_group.this : k => v.name }
}