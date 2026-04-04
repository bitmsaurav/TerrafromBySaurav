output "appgw_ids" {
  description = "Application Gateway IDs"
  value       = { for k, v in azurerm_application_gateway.this : k => v.id }
}