output "resource_group_ids" {
  description = "Resource Group IDs"
  value       = { for k, v in azurerm_resource_group.this : k => v.id }
}

output "resource_group_names" {
  description = "Resource Group names"
  value       = { for k, v in azurerm_resource_group.this : k => v.name }
}

output "resource_group_locations" {
  description = "Resource Group locations"
  value       = { for k, v in azurerm_resource_group.this : k => v.location }
}