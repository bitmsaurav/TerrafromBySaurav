
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
  subscription_id = "99054a73-fe84-4cb1-bc5e-3a75c9ad9c6b"
}
# Random string

resource "random_string" "myrandom" {
  length  = 16
  upper   = false
  lower   = false
  special = false
  number= true

}