output "user_ids" {
  description = "User IDs"
  value       = { for k, v in azuread_user.users : k => v.id }
}

output "group_ids" {
  description = "Group IDs"
  value       = { for k, v in azuread_group.groups : k => v.id }
}