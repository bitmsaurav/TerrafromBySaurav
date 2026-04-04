resource "azurerm_network_security_group" "this" {
  for_each = var.nsgs

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  dynamic "security_rule" {
    for_each = each.value.security_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      source_port_ranges         = security_rule.value.source_port_ranges
      destination_port_range     = security_rule.value.destination_port_range
      destination_port_ranges    = security_rule.value.destination_port_ranges
      source_address_prefix      = security_rule.value.source_address_prefix
      source_address_prefixes    = security_rule.value.source_address_prefixes
      destination_address_prefix = security_rule.value.destination_address_prefix
      destination_address_prefixes = security_rule.value.destination_address_prefixes
      source_application_security_group_ids      = security_rule.value.source_application_security_group_ids
      destination_application_security_group_ids = security_rule.value.destination_application_security_group_ids
    }
  }

  tags = merge(
    var.common_tags,
    each.value.tags
  )
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = var.subnet_nsg_associations

  subnet_id                 = each.value.subnet_id
  network_security_group_id = azurerm_network_security_group.this[each.value.nsg_key].id
}