output "lb_ids" {
  description = "Load Balancer IDs"
  value       = { for k, v in azurerm_lb.this : k => v.id }
}