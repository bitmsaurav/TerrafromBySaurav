data "azurerm_client_config" "current" {}

resource "azurerm_log_analytics_workspace" "main" {
  count               = var.enabled ? 1 : 0
  name                = var.log_analytics_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_in_days
  tags                = var.tags
}

resource "azurerm_application_insights" "main" {
  count               = var.enabled && var.enable_app_insights ? 1 : 0
  name                = var.app_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  retention_in_days   = var.retention_in_days
  workspace_id        = azurerm_log_analytics_workspace.main[0].id
  tags                = var.tags
}

resource "azurerm_policy_definition" "custom" {
  for_each = var.enabled ? var.policy_definitions : {}

  name         = each.key
  policy_type  = "Custom"
  mode         = "All"
  display_name = each.value.display_name
  description  = each.value.description
  metadata     = each.value.metadata
  policy_rule  = each.value.policy_rule
}

resource "azurerm_policy_assignment" "custom" {
  for_each = var.enabled ? var.policy_definitions : {}

  name                 = each.key
  scope                = each.value.scope != "" ? each.value.scope : "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  policy_definition_id = azurerm_policy_definition.custom[each.key].id
  description          = each.value.description
}

output "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID"
  value       = try(azurerm_log_analytics_workspace.main[0].id, null)
}

output "application_insights_id" {
  description = "Application Insights ID"
  value       = try(azurerm_application_insights.main[0].id, null)
}

output "policy_assignment_ids" {
  description = "Policy assignment IDs for custom monitoring policies"
  value       = { for k, p in azurerm_policy_assignment.custom : k => p.id }
}
