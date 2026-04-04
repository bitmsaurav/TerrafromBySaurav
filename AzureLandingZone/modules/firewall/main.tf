resource "azurerm_firewall" "this" {
  for_each            = var.firewalls
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  ip_configuration {
    name                 = "configuration"
    subnet_id            = each.value.subnet_id
    public_ip_address_id = each.value.public_ip_id
  }
  tags = var.tags
}

resource "azurerm_firewall_policy" "this" {
  for_each            = var.firewalls
  name                = "${each.value.name}-policy"
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
}