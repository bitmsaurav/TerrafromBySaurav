resource "azurerm_lb" "this" {
  for_each            = var.load_balancers
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku
  frontend_ip_configuration {
    name                          = each.value.frontend_name
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "this" {
  for_each        = var.load_balancers
  loadbalancer_id = azurerm_lb.this[each.key].id
  name            = "backend"
}