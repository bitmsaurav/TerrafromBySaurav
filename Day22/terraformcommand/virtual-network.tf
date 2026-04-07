resource "azurerm_virtual_network" "myvnet" {
  name                = local.vnet_name
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  address_space       = local.vnet_address_space
  tags                = local.common_tags
}