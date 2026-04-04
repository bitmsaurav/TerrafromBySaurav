resource "azuread_user" "users" {
  for_each            = var.users
  user_principal_name = each.value.user_principal_name
  display_name        = each.value.display_name
  password            = each.value.password
}

resource "azuread_group" "groups" {
  for_each     = var.groups
  display_name = each.value.display_name
  description  = each.value.description
}

resource "azurerm_role_assignment" "this" {
  for_each             = var.role_assignments
  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}