# output values -virtual machine
output "vm_public_ip_address" {
  description = "my virtual machine public ip"
  value       = azurerm_linux_virtual_machine.mylinuxvm.public_ip_address
}
#virtual machine resource group name
output "vm_resource_group_name" {
  description = "virtual machine resource group name"
  value       = azurerm_linux_virtual_machine.mylinuxvm.resource_group_name
}