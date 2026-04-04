output "resource_group_names" {
  description = "Resource group names by deployment region"
  value       = { for k, rg in azurerm_resource_group.region : k => rg.name }
}

output "vnet_ids" {
  description = "Virtual network IDs by region"
  value       = { for k, module_obj in module.vnet : k => module_obj.id }
}

output "subnet_ids" {
  description = "Subnet IDs organized by region"
  value       = { for k, module_obj in module.subnet : k => module_obj.subnet_ids }
}

output "vm_ids" {
  description = "Provisioned VM IDs by region"
  value       = { for k, module_obj in module.vm : k => module_obj.vm_ids }
}

output "log_analytics_workspace_id" {
  description = "Log Analytics workspace resource ID"
  value       = try(module.monitoring.log_analytics_workspace_id, null)
}

output "application_insights_id" {
  description = "Application Insights resource ID"
  value       = try(module.monitoring.application_insights_id, null)
}

output "key_vault_uri" {
  description = "Key Vault URI for the enterprise landing zone"
  value       = try(module.security.key_vault_uri, null)
}
