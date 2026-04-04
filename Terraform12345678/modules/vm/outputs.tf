output "vm_ids" {
  description = "IDs of the created VMs"
  value = merge(
    { for k, v in azurerm_linux_virtual_machine.this : k => v.id },
    { for k, v in azurerm_windows_virtual_machine.this : k => v.id }
  )
}

output "vm_names" {
  description = "Names of the created VMs"
  value = merge(
    { for k, v in azurerm_linux_virtual_machine.this : k => v.name },
    { for k, v in azurerm_windows_virtual_machine.this : k => v.name }
  )
}

output "nic_ids" {
  description = "IDs of the created NICs"
  value = { for k, v in azurerm_network_interface.this : k => v.id }
}