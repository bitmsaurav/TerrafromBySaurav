output "policy_definition_ids" {
  description = "IDs of the created policy definitions"
  value       = { for k, v in azurerm_policy_definition.this : k => v.id }
}

output "policy_assignment_ids" {
  description = "IDs of the created policy assignments"
  value       = { for k, v in azurerm_policy_assignment.this : k => v.id }
}