resource "azurerm_resource_group" "myrg" {
  for_each = { for rg in var.multipal_reosuser_group : rg.name => rg }
  name     = each.value.name
  location = each.value.location
}