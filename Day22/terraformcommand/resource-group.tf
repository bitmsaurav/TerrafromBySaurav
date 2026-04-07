resource "azurerm_resource_group" "myrg" {
  name     = local.rg_name
  location = var.location
  tags     = local.common_tags
}