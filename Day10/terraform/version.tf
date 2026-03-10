
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.59.0"
    }
  }
}


provider "azurerm" {
  # Configuration options
  features {

  }
  subscription_id = "8a0253d9-8cdd-438f-91ae-002a028d44ab"
}
# Random string

resource "random_string" "myrandom" {
  length  = 16
  upper   = false
  lower   = false
  special = false
  number  = true

}