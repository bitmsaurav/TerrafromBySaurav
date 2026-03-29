
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.59.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform-storage-rg"
    storage_account_name = "terraformstatemithun101"
    container_name       = "tfstatefiles"
    key                  = "terraform.tfstate"
  }
}


provider "azurerm" {
  # Configuration options
  features {

  }
  subscription_id = "8a0253d9-8cdd-438f-91ae-002a028d44ab"
}


