output "public_ip_ids" {
  description = "IDs of the created public IPs"
  value       = { for k, v in azurerm_public_ip.this : k => v.id }
}

output "lb_ids" {
  description = "IDs of the created load balancers"
  value       = { for k, v in azurerm_lb.this : k => v.id }
}

output "backend_pool_ids" {
  description = "IDs of the created backend address pools"
  value       = { for k, v in azurerm_lb_backend_address_pool.this : k => v.id }
}