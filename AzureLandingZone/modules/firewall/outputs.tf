output "firewall_ids" {
  description = "Firewall IDs"
  value       = { for k, v in azurerm_firewall.this : k => v.id }
}