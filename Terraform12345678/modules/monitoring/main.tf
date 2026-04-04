resource "azurerm_log_analytics_workspace" "this" {
  for_each = var.log_analytics_workspaces

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku
  retention_in_days   = each.value.retention_in_days

  tags = merge(
    var.common_tags,
    each.value.tags
  )
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = var.diagnostic_settings

  name                       = each.value.name
  target_resource_id         = each.value.target_resource_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this[each.value.workspace_key].id

  dynamic "log" {
    for_each = each.value.logs
    content {
      category = log.value.category
      enabled  = log.value.enabled

      dynamic "retention_policy" {
        for_each = log.value.retention_policy != null ? [log.value.retention_policy] : []
        content {
          enabled = retention_policy.value.enabled
          days    = retention_policy.value.days
        }
      }
    }
  }

  dynamic "metric" {
    for_each = each.value.metrics
    content {
      category = metric.value.category
      enabled  = metric.value.enabled

      dynamic "retention_policy" {
        for_each = metric.value.retention_policy != null ? [metric.value.retention_policy] : []
        content {
          enabled = retention_policy.value.enabled
          days    = retention_policy.value.days
        }
      }
    }
  }
}