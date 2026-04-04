resource "azurerm_subnet" "main" {
  for_each             = var.enabled ? var.subnets : {}
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [each.value.prefix]
}

resource "azurerm_subnet_network_security_group_association" "main" {
  for_each = var.enabled && var.nsg_id != "" ? var.subnets : {}

  subnet_id                 = azurerm_subnet.main[each.key].id
  network_security_group_id = var.nsg_id
}
