terraform {
 required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.59.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tf-st-rg"
    storage_account_name = "tfst201"
    container_name       = "tfstfile"
    key                  = "state-commands-demo1.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "38b4536a-4483-490a-a8ab-5f0bd64454d2"
}

