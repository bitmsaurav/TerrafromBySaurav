output "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID"
  value       = try(azurerm_log_analytics_workspace.main[0].id, null)
}

output "application_insights_id" {
  description = "Application Insights resource ID"
  value       = try(azurerm_application_insights.main[0].id, null)
}

output "policy_assignment_ids" {
  description = "IDs of custom policy assignments"
  value       = { for k, assignment in azurerm_policy_assignment.custom : k => assignment.id }
}
