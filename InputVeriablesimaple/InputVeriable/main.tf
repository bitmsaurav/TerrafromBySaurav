resource "azurerm_resource_group" "saurav" {
  for_each = var.mithunResousegroup
  name     = "rg-${each.key}"
  location = each.value

}
