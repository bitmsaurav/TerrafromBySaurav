output "vm_ids" {
  description = "VM IDs"
  value       = { for k, v in azurerm_linux_virtual_machine.this : k => v.id }
}

output "vm_private_ips" {
  description = "VM private IPs"
  value       = { for k, v in azurerm_network_interface.this : k => v.private_ip_address }
}