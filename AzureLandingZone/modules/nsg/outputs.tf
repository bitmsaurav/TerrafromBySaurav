output "nsg_ids" {
  description = "NSG IDs"
  value       = { for k, v in azurerm_network_security_group.this : k => v.id }
}