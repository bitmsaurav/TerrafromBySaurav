output "log_analytics_workspace_ids" {
  description = "IDs of the created Log Analytics workspaces"
  value       = { for k, v in azurerm_log_analytics_workspace.this : k => v.id }
}

output "log_analytics_workspace_names" {
  description = "Names of the created Log Analytics workspaces"
  value       = { for k, v in azurerm_log_analytics_workspace.this : k => v.name }
}