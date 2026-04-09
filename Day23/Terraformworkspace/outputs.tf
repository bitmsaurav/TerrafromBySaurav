output "resource_group_id" {
  value = azurerm_resource_group.myrg.id
}

output "resource_group_name" {
  value = azurerm_resource_group.myrg.name
}

output "virtual_network_id" {
  value = azurerm_virtual_network.myvnet.id
}

output "virtual_network_name" {
  value = azurerm_virtual_network.myvnet.name
}

output "subnet_id" {
  value = azurerm_subnet.mysubnet.id
}



output "subnet_name" {
  value = azurerm_subnet.mysubnet.name
}

output "public_ip_id" {
  value = azurerm_public_ip.mypublicip.id
}

output "public_ip_name" {
  value = azurerm_public_ip.mypublicip.name
}

output "network_interface_id" {
  value = azurerm_network_interface.myvmnic.id
}


output "network_interface_name" {
  value = azurerm_network_interface.myvmnic.name
}

output "virtual_machine_id" {
  value = azurerm_linux_virtual_machine.mylinuxvm.id
}

output "virtual_machine_name" {
  value = azurerm_linux_virtual_machine.mylinuxvm.name
}


