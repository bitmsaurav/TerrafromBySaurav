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

resource "azurerm_resource_group" "rg" {
  name     = var.rg_config.name
  location = var.rg_config.location
}