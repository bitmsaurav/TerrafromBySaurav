# 1.output value resource group
output "resource_group_id" {
  description = "Resource group id"
  value       = azurerm_resource_group.myrg.id
}
output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.myrg.name
}
output "resource_group_location" {
  description = "Resource group location"
  value       = azurerm_resource_group.myrg.location
}
#2 output values: virtual network

output "virtual_network_name" {
  description = "virtual network name"
  value       = azurerm_virtual_network.myvnet.name

}
output "network_interface_id" {
  description = "VIRTUAL Network interface id"
  value       = azurerm_network_interface.myvmnic.id
}