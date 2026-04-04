resource "azurerm_policy_definition" "this" {
  for_each = var.policy_definitions

  name         = each.value.name
  policy_type  = each.value.policy_type
  mode         = each.value.mode
  display_name = each.value.display_name
  description  = each.value.description

  metadata = jsonencode({
    category = each.value.category
  })

  policy_rule = jsonencode(each.value.policy_rule)
  parameters  = jsonencode(each.value.parameters)
}

resource "azurerm_policy_assignment" "this" {
  for_each = var.policy_assignments

  name                 = each.value.name
  scope                = each.value.scope
  policy_definition_id = azurerm_policy_definition.this[each.value.policy_definition_key].id
  description          = each.value.description
  display_name         = each.value.display_name

  dynamic "identity" {
    for_each = each.value.identity != null ? [each.value.identity] : []
    content {
      type = identity.value.type
    }
  }

  parameters = jsonencode(each.value.parameters)
}