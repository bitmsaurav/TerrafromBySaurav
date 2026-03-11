output "resource_group_id" {
  description = "Resource group id"
  # Attribut refrence
  value = azurerm_resource_group.myrg.id

}

output "resource_group_name" {
  description = "Resource_group_name"
  value       = azurerm_resource_group.myrg.name
}

# output "virtual_network_name" {
#   description = "virtual network name"
#   value       = azurerm_virtual_network.vnet[*].name

# }

output "virtual_network_name_list_one_input" {
  description = "virtual network -for loop one input and list output with vnet name"
  value       = [for vnet in azurerm_virtual_network.vnet : vnet.name]

}
output "virtual_network_name_list_two_input" {
  description = "Virtual Network - For Loop Two Inputs, List Output which is Iterator i (var.environment)"
  value       = [for env, vnet in azurerm_virtual_network.vnet : env]
}

output "virtual_network_name_list_map_two_input" {
  description = "virtual network -for loop two input and map output withe iterrator env and vnet name"
  value       = { for env, vnet in azurerm_virtual_network.vnet : env => vnet.name }

}
output "virtual_network_name_list_map_one_input" {
  description = "virtual network -for loop one input and map output with VNET id and vnet name"
  value       = { for  vnet in azurerm_virtual_network.vnet : vnet.id => vnet.name }

}
