terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  alias           = "primary"
  features {}
  subscription_id = var.subscription_id
  # Authentication via az login or service principal
}

provider "azurerm" {
  alias           = "dr"
  features {}
  subscription_id = var.subscription_id
  # Same authentication
}

provider "azuread" {
  # For identity management
}