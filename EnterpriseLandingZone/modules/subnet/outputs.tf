output "subnet_ids" {
  description = "IDs of created subnets"
  value       = { for name, subnet in azurerm_subnet.main : name => subnet.id }
}

output "subnet_names" {
  description = "Names of created subnets"
  value       = { for name, subnet in azurerm_subnet.main : name => subnet.name }
}
