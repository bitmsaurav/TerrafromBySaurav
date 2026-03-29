data "azurerm_subscription" "current" {

}

# Datasource using outputs

#my current subscription display name

output "current_subscription_display_name" {
  value = data.azurerm_subscription.current.display_name
}

#my current subscription id
output "current_subscription_dispalyid" {
  value = data.azurerm_subscription.current.subscription_id
}
#my current  id

output "current_id" {
  value = data.azurerm_subscription.current.id

}

# current speending limit

output "currnt_speendinglimit" {
  value = data.azurerm_subscription.current.spending_limit

}