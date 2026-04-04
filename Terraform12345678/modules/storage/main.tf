resource "azurerm_storage_account" "this" {
  for_each = var.storage_accounts

  name                     = each.value.name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
  account_kind             = each.value.account_kind
  is_hns_enabled           = each.value.is_hns_enabled

  dynamic "blob_properties" {
    for_each = each.value.blob_properties != null ? [each.value.blob_properties] : []
    content {
      dynamic "delete_retention_policy" {
        for_each = blob_properties.value.delete_retention_policy != null ? [blob_properties.value.delete_retention_policy] : []
        content {
          days = delete_retention_policy.value.days
        }
      }
    }
  }

  tags = merge(
    var.common_tags,
    each.value.tags
  )
}

resource "azurerm_storage_container" "this" {
  for_each = var.storage_containers

  name                  = each.value.name
  storage_account_id    = azurerm_storage_account.this[each.value.storage_account_key].id
  container_access_type = each.value.container_access_type
}