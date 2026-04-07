data "azure_subscription" "current" {

}


output "current_subscription_disply_name" {
  value = data.azure_subscription.current.display_name
}

output "current_subscription_id" {
  value = data.azure_subscription.current.subscription_id
}

output "current_subscription_spending_limit" {
  value = data.azure_subscription.current.spending_limit
}

# Terraform command to run
# terraform show
#terraform state
#terraform state list
#terraform state show <resource_name>
#terraform state pull
#
