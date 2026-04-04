resource "azurerm_application_gateway" "this" {
  for_each = var.application_gateways
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  sku {
    name     = each.value.sku_name
    tier     = each.value.sku_tier
    capacity = each.value.capacity
  }
  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.1"
  }
  gateway_ip_configuration {
    name      = "gateway"
    subnet_id = each.value.subnet_id
  }
  frontend_port {
    name = "http"
    port = 80
  }
  frontend_ip_configuration {
    name                 = "frontend"
    public_ip_address_id = each.value.public_ip_id
  }
  backend_address_pool {
    name = "backend"
  }
  backend_http_settings {
    name                  = "http"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }
  http_listener {
    name                           = "listener"
    frontend_ip_configuration_name = "frontend"
    frontend_port_name             = "http"
    protocol                       = "Http"
  }
  request_routing_rule {
    name                       = "rule"
    rule_type                  = "Basic"
    http_listener_name         = "listener"
    backend_address_pool_name  = "backend"
    backend_http_settings_name = "http"
  }
  tags = var.tags
}