output "resource_group_id" {
  description = "Resource group id"
  # Attribut refrence
  value = azurerm_resource_group.myrg.id

}

output "resource_group_name" {
  description = "Resource_group_name"
  value       = azurerm_resource_group.myrg.name
}

output "virtual_network_name" {
  description = "virtual network name"
  value       = azurerm_virtual_network.vnet.name

}