resource "azurerm_resource_group" "myrg" {
  name     = local.rg_name
  location = "eastus"
  tags     = local.common_tags

}