output "nsg_id" {
  description = "Network security group ID"
  value       = try(azurerm_network_security_group.main[0].id, null)
}

output "nsg_name" {
  description = "Network security group name"
  value       = try(azurerm_network_security_group.main[0].name, null)
}
