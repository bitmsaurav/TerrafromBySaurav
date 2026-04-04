resource "azurerm_public_ip" "this" {
  for_each = var.public_ips

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku

  tags = merge(
    var.common_tags,
    each.value.tags
  )
}

resource "azurerm_lb" "this" {
  for_each = var.load_balancers

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku

  frontend_ip_configuration {
    name                 = each.value.frontend_ip_configuration.name
    public_ip_address_id = each.value.frontend_ip_configuration.public_ip_address_id
  }

  tags = merge(
    var.common_tags,
    each.value.tags
  )
}

resource "azurerm_lb_backend_address_pool" "this" {
  for_each = var.backend_address_pools

  loadbalancer_id = azurerm_lb.this[each.value.lb_key].id
  name            = each.value.name
}

resource "azurerm_lb_probe" "this" {
  for_each = var.probes

  loadbalancer_id = azurerm_lb.this[each.value.lb_key].id
  name            = each.value.name
  port            = each.value.port
}

resource "azurerm_lb_rule" "this" {
  for_each = var.rules

  loadbalancer_id                = azurerm_lb.this[each.value.lb_key].id
  name                           = each.value.name
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.this[each.value.backend_address_pool_key].id]
  probe_id                       = azurerm_lb_probe.this[each.value.probe_key].id
}