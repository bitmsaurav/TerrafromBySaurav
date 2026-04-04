output "vnet_ids" {
  description = "IDs of the created VNets"
  value       = { for k, v in azurerm_virtual_network.this : k => v.id }
}

output "vnet_names" {
  description = "Names of the created VNets"
  value       = { for k, v in azurerm_virtual_network.this : k => v.name }
}

output "subnet_ids" {
  description = "IDs of the created subnets"
  value       = { for k, v in azurerm_subnet.this : k => v.id }
}

output "subnet_names" {
  description = "Names of the created subnets"
  value       = { for k, v in azurerm_subnet.this : k => v.name }
}