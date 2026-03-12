resource "azurerm_virtual_network" "myvnet" {
  #name="${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  name                = local.vnet_name
  location            = azurerm_resource_group.myrg.location
  address_space       = ["10.0.0.0/16"]
  
  resource_group_name = azurerm_resource_group.myrg.name
  tags                = local.comman_tags
}