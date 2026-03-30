
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
  subscription_id = "38b4536a-4483-490a-a8ab-5f0bd64454d2"
}
# Random string

resource "random_string" "myrandom" {
  length  = 16
  upper   = false
  lower   = false
  special = false
  number  = true

}